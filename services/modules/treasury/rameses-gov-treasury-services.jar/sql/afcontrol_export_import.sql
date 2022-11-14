[getOpenList]
select 
	c.*, af.formtype, af.serieslength, af.denomination, 
	(case when af.formtype = 'serial' then c.startseries else null end) as sstartseries, 
	(case when af.formtype = 'serial' then c.endseries else null end) as sendseries  
from af_control c 
	inner join af on af.objid = c.afid 
where c.owner_objid = $P{ownerid} 
	and c.afid = $P{afid} 
	and c.state = 'ISSUED' 
	and c.currentseries <= c.endseries 


[findAFControl]
select 
	c.*, af.formtype, af.serieslength, af.denomination, 
	(case when af.formtype = 'serial' then c.startseries else null end) as sstartseries, 
	(case when af.formtype = 'serial' then c.endseries else null end) as sendseries  
from af_control c 
	inner join af on af.objid = c.afid 
where c.objid = $P{controlid} 


[getAFControlDetails]
select * from af_control_detail 
where controlid = $P{controlid} 
order by refdate, txndate, indexno 


[findAFInventory]
select 
	a.objid, a.afid, a.owner_objid as respcenter_objid, a.owner_name as respcenter_name, 'COLLECTOR' as respcenter_type, 
	tmp2.startseries, tmp2.endseries, tmp2.currentseries, a.stubno as startstub, a.stubno as endstub, a.stubno as currentstub, 
	a.prefix, a.suffix, a.unit, (tmp2.endseries-tmp2.startseries+1) as qtyin, (tmp2.currentseries-tmp2.startseries) as qtyout,
	(tmp2.endseries-tmp2.startseries+1)-(tmp2.currentseries-tmp2.startseries) as qtybalance, 0 as qtycancelled,   
	(case when tmp2.maxindexno > tmp2.itemcount then tmp2.maxindexno else tmp2.itemcount end) as currentlineno, 
	(case when a.cost is null then 0.0 else a.cost end) as cost 
from ( 
	select tmp1.*,  
		(case when tmp1.qtyreceived > 0 then tmp1.receivedstartseries else tmp1.beginstartseries end) as startseries, 
		(case when tmp1.qtyreceived > 0 then tmp1.receivedendseries else tmp1.beginendseries end) as endseries, 
		(case 
			when tmp1.qtyissued > 0 then tmp1.issuedendseries+1 
			when tmp1.qtybegin > 0 then tmp1.beginstartseries 
			else tmp1.receivedstartseries 
		end) as currentseries 
	from ( 
		select d.controlid, 
			min(d.receivedstartseries) as receivedstartseries, 
			max(d.receivedendseries) as receivedendseries, 
			max(d.receivedendseries)-min(d.receivedstartseries)+1 as qtyreceived, 
			min(d.beginstartseries) as beginstartseries, 
			max(d.beginendseries) as beginendseries,	
			max(d.beginendseries)-min(d.beginstartseries)+1 as qtybegin, 
			min(d.issuedstartseries) as issuedstartseries, 
			max(d.issuedendseries) as issuedendseries,	
			max(d.issuedendseries)-min(d.issuedstartseries)+1 as qtyissued, 
			max(d.indexno) as maxindexno, 
			count(d.objid) as itemcount 
		from af_control_detail d  
		where d.controlid = $P{controlid} 
			and d.reftype not in ('BEGIN_BALANCE','PURCHASE_RECEIPT') 
		group by d.controlid 
	)tmp1 
)tmp2, af_control a 
where a.objid = tmp2.controlid 


[getAFInventoryDetails]
select 
	d.objid, d.controlid, d.indexno, d.refid, d.refno, d.refdate, 
	(case 
		when d.reftype = 'FORWARD' then 'system' 
		when d.reftype = 'ISSUE' and d.txntype='COLLECTION' then 'stockissue' 
		when d.reftype = 'ISSUE' and d.txntype='SALE' then 'stocksale' 
		when d.reftype = 'REMITTANCE' then 'remittance' 
		when d.reftype = 'RETURN' then 'stockreturn' 
		when d.reftype = 'TRANSFER' then d.reftype 
		else d.reftype 
	end) as reftype, 
	(case 
		when d.reftype = 'FORWARD' then 'COLLECTOR BEG.BAL.' 
		when d.reftype = 'ISSUE' and d.txntype='COLLECTION' then 'ISSUANCE-RECEIPT' 
		when d.reftype = 'ISSUE' and d.txntype='SALE' then 'SALE-RECEIPT' 
		when d.reftype = 'REMITTANCE' then d.txntype 
		when d.reftype = 'RETURN' then d.reftype 
		when d.reftype = 'TRANSFER' then d.reftype 
		else d.txntype  
	end) as txntype,
	d.txndate, 
	d.receivedstartseries, d.receivedendseries, d.beginstartseries, d.beginendseries, 
	d.issuedstartseries, d.issuedendseries, d.endingstartseries, d.endingendseries, 
	null as cancelledstartseries, null as cancelledendseries, 
	d.qtyreceived, d.qtybegin, d.qtyissued, d.qtyending, d.qtycancelled, d.remarks, 
	(case when d.reftype in ('FORWARD','ISSUE') then a.cost else null end) as cost 
from af_control_detail d  
	inner join af_control a on a.objid = d.controlid 
where d.controlid = $P{controlid} 
	and d.reftype not in ('BEGIN_BALANCE','PURCHASE_RECEIPT') 
order by d.refdate, d.txndate, d.indexno 
