

rename table deposit to cash_deposit; 


CREATE TABLE `collection_cash` (
  `objid` varchar(150) NOT NULL,
  `depositid` varchar(150) DEFAULT NULL,
  `liquidationfundid` varchar(150) NOT NULL,
  `fundid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `controlno` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_controlno` (`controlno`),
  KEY `ix_depositid` (`depositid`),
  KEY `ix_liquidationfundid` (`liquidationfundid`),
  KEY `ix_fundid` (`fundid`),
  KEY `fk_collection_cash_liquidationfundid_controlno` (`liquidationfundid`,`controlno`),
  CONSTRAINT `fk_collection_cash_liquidationfundid_controlno` FOREIGN KEY (`liquidationfundid`, `controlno`) REFERENCES `liquidation_fund` (`objid`, `controlno`),
  CONSTRAINT `fk_collection_cash_depositid` FOREIGN KEY (`depositid`) REFERENCES `cash_deposit` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `epayment` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `partnerid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `traceno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_partnerid` (`partnerid`),
  KEY `ix_receiptid` (`receiptid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


ALTER TABLE account_receivable
	ADD totaldr  decimal(16,4) NULL,
	ADD totalcr  decimal(16,4) NULL
; 
update account_receivable set totaldr = 0.0 where totaldr is null; 
update account_receivable set totalcr = 0.0 where totalcr is null; 

ALTER TABLE account_receivable
	modify totaldr  decimal(16,4) not NULL,
	modify totalcr  decimal(16,4) not NULL
; 


// 
// Rebuild collection cash 
//

delete from collection_cash;

insert into collection_cash ( 
	objid, liquidationfundid, controlno, fundid, amount 
) 
select 
	lf.objid, lf.objid, lf.controlno, lf.fund_objid, (lf.totalcash + lf.totalcheck) 
from liquidation_fund lf 
	inner join liquidation l on l.objid = lf.liquidationid 
where lf.objid not in (select objid from collection_cash where objid=lf.objid) 
	and l.state in ('POSTED','CLOSED') 
	and (lf.totalcash + lf.totalcheck) > 0 
	and lf.controlno is not null 	
;



// 
// Rebuild jev entries 
// 

delete from jevitem;
delete from jev; 

insert into jev (
	objid, jevno, jevdate, fundid, dtposted, txntype, 
	refid, refno, reftype, amount, state, postedby_objid, postedby_name 
) 
select 
	lf.objid, null, null, lf.fund_objid, l.dtposted, 'COLLECTION', 
	lf.objid, l.txnno, 'liquidation', lf.amount, 'OPEN', 
	l.liquidatingofficer_objid, l.liquidatingofficer_name 
from liquidation_fund lf 
	inner join liquidation l on l.objid=lf.liquidationid 
where lf.objid not in (select objid from jev where objid=lf.objid) 
	and l.state in ('POSTED','CLOSED') 
;

insert into jevitem ( 
	objid, jevid, accttype, acctid, dr, cr, particulars 
)
select 
	c.objid, c.objid, ia.accttype, ia.acctid, amount, 0.0, null 
from collection_cash c 
	inner join ( 
		select fund_objid, min(type) as accttype, min(objid) as acctid 
		from itemaccount 
		where type = 'CASH_IN_TREASURY' 
		group by fund_objid  
	) ia on ia.fund_objid = c.fundid  
;

insert into jevitem ( 
	objid, jevid, accttype, acctid, dr, cr, particulars 
)
select * from (
	select  
		concat(lf.objid,'-',ba.acctid) as objid, 
		lf.objid as jevid, ia.type, 
		ba.acctid, sum(nc.amount) as dr, 
		0.0 as cr, null as particulars 
	from liquidation_fund lf 
		inner join liquidation l on l.objid=lf.liquidationid
		inner join remittance_fund remf on remf.liquidationfundid = lf.objid 
		inner join cashreceiptpayment_noncash nc on nc.remittancefundid = remf.objid 
		inner join cashreceipt c on c.objid = nc.receiptid 
		inner join creditmemo cm on cm.objid = nc.refid 
		inner join bankaccount ba on ba.objid = cm.bankaccount_objid 
		inner join itemaccount ia on ia.objid = ba.acctid 
	where l.state in ('POSTED','CLOSED') 
		and c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
		and c.state <> 'CANCELLED' 
	group by lf.objid, ba.acctid, ia.type
)tmp1 
where objid not in (select objid from jevitem where objid=tmp1.objid) 
	and acctid is not null 
; 


insert into jevitem ( 
	objid, jevid, accttype, acctid, dr, cr, particulars 
)
select * from (
	select  
		concat(lf.objid,'-',ia.objid) as objid, 
		lf.objid as jevid, ia.type, ia.objid as acctid, 
		sum(nc.amount) as dr, 0.0 as cr, null as particulars 
	from liquidation_fund lf 
		inner join liquidation l on l.objid=lf.liquidationid
		inner join remittance_fund remf on remf.liquidationfundid = lf.objid 
		inner join cashreceiptpayment_noncash nc on nc.remittancefundid = remf.objid 
		inner join cashreceipt c on c.objid = nc.receiptid 
		inner join epayment ep on ep.objid = nc.refid 
		inner join paymentpartner cm on cm.objid = ep.partnerid 
		inner join itemaccount ia on ia.objid = cm.receivableacctid 
	where l.state in ('POSTED','CLOSED') 
		and c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
		and c.state <> 'CANCELLED' 
	group by lf.objid, ia.objid, ia.type
)tmp1 
where objid not in (select objid from jevitem where objid=tmp1.objid) 
	and acctid is not null 
; 

insert into jevitem ( 
	objid, jevid, accttype, acctid, dr, cr, particulars 
) 
select * from ( 
	select 
		concat(lf.objid,'-',ia.objid) as objid, 
		lf.objid as jevid, ia.type as accttype, ia.objid as acctid, 
		0.0 as dr, sum(ci.amount) as cr, null as particulars 
	from liquidation_fund lf 
		inner join liquidation l on l.objid=lf.liquidationid
		inner join remittance rem on rem.liquidationid=l.objid 
		inner join cashreceipt c on c.remittanceid=rem.objid 	
		inner join cashreceiptitem ci on (ci.receiptid=c.objid and ci.item_fund_objid=lf.fund_objid)
		inner join itemaccount ia on ia.objid = ci.item_objid 
	where l.state in ('POSTED','CLOSED') 
		and c.objid not in (select receiptid from cashreceipt_share where receiptid=c.objid) 
		and c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid)  
		and c.state <> 'CANCELLED' 
	group by lf.objid, ia.objid, ia.type 
)tmp1 
where objid not in (select objid from jevitem where objid=tmp1.objid) 
;

insert into jevitem ( 
	objid, jevid, accttype, acctid, dr, cr, particulars 
) 
select * from ( 
	select  
		concat(lf.objid,'-',ia.objid,'-revenue') as objid, 
		lf.objid as jevid, ia.type as accttype, ia.objid as acctid, 
		0.0 as dr, sum(cs.amount) as cr, null as particulars 
	from liquidation_fund lf 
		inner join liquidation l on l.objid = lf.liquidationid
		inner join remittance rem on rem.liquidationid = l.objid 
		inner join cashreceipt c on c.remittanceid = rem.objid 	
		inner join cashreceipt_share cs on (cs.receiptid = c.objid and cs.payableacctid is null)
		inner join itemaccount ia on (ia.objid = cs.refacctid and ia.fund_objid = lf.fund_objid) 
	where l.state in ('POSTED','CLOSED') 
		and c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
		and c.state <> 'CANCELLED' 
	group by lf.objid, ia.objid, ia.type   

	union all 

	select  
		concat(lf.objid,'-',ia.objid,'-payable') as objid, 
		lf.objid as jevid, ia.type as accttype, ia.objid as acctid, 
		0.0 as dr, sum(cs.amount) as cr, null as particulars 
	from liquidation_fund lf 
		inner join liquidation l on l.objid = lf.liquidationid
		inner join remittance rem on rem.liquidationid = l.objid 
		inner join cashreceipt c on c.remittanceid = rem.objid 	
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on (ia.objid = cs.payableacctid and ia.fund_objid = lf.fund_objid) 
	where l.state in ('POSTED','CLOSED') 
		and c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
		and c.state <> 'CANCELLED' 
	group by lf.objid, ia.objid, ia.type 
)tmp1 
where objid not in (select objid from jevitem where objid=tmp1.objid) 
;

