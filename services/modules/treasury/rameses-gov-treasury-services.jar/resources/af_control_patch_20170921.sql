

create table af_control_detail (
	objid varchar(150) not null, 
	controlid varchar(50) not null, 
	indexno int not null, 
	refid varchar(50) not null, 
	refno varchar(32) not null, 
	reftype varchar(32) not null, 
	refdate datetime not null, 
	txndate datetime not null, 
	txntype varchar(32) not null, 
	receivedstartseries int null, 
	receivedendseries int null, 
	beginstartseries int null, 
	beginendseries int null, 
	issuedstartseries int null, 
	issuedendseries int null, 
	endingstartseries int null, 
	endingendseries int null, 
	qtyreceived int not null, 
	qtybegin int not null, 
	qtyissued int not null, 
	qtyending int not null, 
	qtycancelled int not null, 
	remarks varchar(255) null, 
	primary key (objid)
);

alter table af_control_detail 
	add key ix_controlid (controlid), 
	add key ix_refid (refid),
	add key ix_refno (refno),
	add key ix_reftype (reftype), 
	add key ix_refdate (refdate),
	add key ix_txndate (txndate),
	add key ix_txntype (txntype)
; 

alter table af_control_detail 
	add constraint fk_af_control_detail_controlid 
	foreign key (controlid) references af_control (objid)
;


insert into af_control_detail ( 
	objid, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
	receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
	issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
	qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, remarks 
) 
select 
	afd.objid, afd.controlid, afd.lineno, afd.refid, afd.refno, afd.reftype, afd.refdate, afd.txndate, afd.txntype, 
	case when afd.txntype='ISSUANCE-RECEIPT' then afd.receivedstartseries else null end as receivedstartseries, 
	case when afd.txntype='ISSUANCE-RECEIPT' then afd.receivedendseries else null end as receivedendseries, 
	case when afd.txntype='ISSUANCE-RECEIPT' then null else afd.beginstartseries end as beginstartseries, 
	case when afd.txntype='ISSUANCE-RECEIPT' then null else afd.beginendseries end as beginendseries, 
	null as issuedstartseries, null as issuedendseries, afd.endingstartseries, afd.endingendseries, 
	case when afd.txntype='ISSUANCE-RECEIPT' then (afd.receivedendseries-afd.receivedstartseries)+1 else 0 end as qtyreceived, 
	case when afd.txntype='ISSUANCE-RECEIPT' then 0 else (afd.beginendseries-afd.beginstartseries)+1 end as qtybegin, 
	0 as qtyissued, (afd.endingendseries-afd.endingstartseries)+1 as qtyending, 0 as qtycancelled, afd.remarks 
from af_control afc 
	inner join af_inventory_detail afd on (afd.controlid=afc.objid and afd.lineno=1) 
;

insert into af_control_detail ( 
	objid, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
	receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
	issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
	qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, remarks 
) 
select 
	afd.objid, afd.controlid, afd.lineno, afd.refid, afd.refno, afd.reftype, afd.refdate, afd.txndate, afd.txntype, 
	afd.receivedstartseries, afd.receivedendseries, 
	case when afd.issuedstartseries is not null then afd.issuedstartseries else afd.beginstartseries end as beginstartseries, 
	case when afd.issuedstartseries is not null then afc.endseries else afd.beginendseries end as beginendseries, 
	afd.issuedstartseries, afd.issuedendseries, afd.endingstartseries, afd.endingendseries, 
	afd.qtyreceived, 
	case 
		when afd.issuedstartseries is not null then (afc.endseries-afd.issuedstartseries)+1 
		when afd.beginstartseries is not null then (afd.beginendseries-afd.beginstartseries)+1 
		else 0 
	end as qtybegin, 
	afd.qtyissued, afd.qtyending, afd.qtycancelled, afd.remarks 
from af_control afc 
	inner join af_inventory_detail afd on afd.controlid = afc.objid 
where afd.reftype='remittance'
;


alter table af_control 
	add currentindexno int null, 
	add lockid varchar(50) null
; 
update af_control set 
	currentindexno=(select max(indexno) from af_control_detail where controlid=af_control.objid)  
where 
	currentindexno is null 
;
update af_control set currentindexno=0 where currentindexno is null
;
alter table af_control modify currentindexno int not null
; 

