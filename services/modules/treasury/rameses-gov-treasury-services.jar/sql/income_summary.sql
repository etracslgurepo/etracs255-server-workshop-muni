[clear]
delete from income_summary where refid = $P{collectionvoucherid} 

[post]
insert into income_summary ( 
	refid, refdate, refno, reftype, acctid, fundid, amount, 
	orgid, collectorid, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, 
	liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr 
)
select 
	refid, refdate, refno, reftype, acctid, fundid, 
	sum(amount) as amount, orgid, collectorid, 
	year(refdate) as refyear, month(refdate) as refmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as refqtr, 
	remittanceid, remittancedate, 
	year(remittancedate) as remittanceyear, month(remittancedate) as remittancemonth, 
	case 
		when month(remittancedate) <= 3 then 1
		when month(remittancedate) <= 6 then 2
		when month(remittancedate) <= 9 then 3
		when month(remittancedate) <= 12 then 4
	end as remittanceqtr,
	refid as liquidationid, refdate as liquidationdate, 
	year(refdate) as liquidationyear, month(refdate) as liquidationmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as liquidationqtr  
from ( 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		ci.item_objid as acctid, ci.item_fund_objid as fundid, sum(ci.amount) as amount, 
		c.org_objid as orgid, c.collector_objid as collectorid, c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptitem ci on ci.receiptid = c.objid
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.objid = $P{collectionvoucherid} 
		and v.objid is null 
	group by 
		cv.objid, cv.controldate, cv.controlno, ci.item_objid, ci.item_fund_objid, 
		c.org_objid, c.collector_objid, c.remittanceid, r.controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, cs.refitem_objid as acctid, 
		(select item_fund_objid from cashreceiptitem where receiptid = c.objid and item_objid = cs.refitem_objid limit 1) as fundid, 
		-cs.amount as amount, c.org_objid as orgid, c.collector_objid as collectorid, c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceipt_share cs on cs.receiptid = c.objid
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.objid = $P{collectionvoucherid} 
		and v.objid is null 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		ia.objid as acctid, ia.fund_objid as fundid, sum(cs.amount) as amount, 
		c.org_objid as orgid, c.collector_objid as collectorid, c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on ia.objid = cs.payableitem_objid
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.objid = $P{collectionvoucherid} 
		and v.objid is null 
	group by 
		cv.objid, cv.controldate, cv.controlno, ia.objid, ia.fund_objid,
		c.org_objid, c.collector_objid, c.remittanceid, r.controldate 
)t1 
group by 
	refid, refdate, refno, reftype, acctid, fundid,
	orgid, collectorid, remittanceid, remittancedate 



[removeItemsByRef]
delete from income_summary where refid = $P{refid} 

[postItem]
insert into income_summary ( 
	refid, refdate, refno, reftype, acctid, fundid, amount, 
	orgid, collectorid, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, 
	liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr 
) values (
	$P{refid}, $P{refdate}, $P{refno}, $P{reftype}, $P{acctid}, $P{fundid}, $P{amount}, 
	$P{orgid}, $P{collectorid}, $P{refyear}, $P{refmonth}, $P{refqtr}, 
	$P{remittanceid}, $P{remittancedate}, $P{remittanceyear}, $P{remittancemonth}, $P{remittanceqtr}, 
	$P{liquidationid}, $P{liquidationdate}, $P{liquidationyear}, $P{liquidationmonth}, $P{liquidationqtr} 
)
