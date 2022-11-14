[getList]
select *  
from ( 
	select c.objid 
	from cashreceipt c 
	where 1=1 and ${filter} 
	order by ${orderby}
	limit 500
)t0 


[getListByIds]
select 
	c.objid, c.state, c.txndate, convert(c.receiptdate, date) as receiptdate, c.receiptno, 
	c.txnmode, c.paidby, c.paidbyaddress, c.amount, c.collector_objid, c.collector_name, 
	c.collectiontype_objid, c.collectiontype_name, c.controlid, c.series, c.formno, c.formtype, 
	(case when v.objid is null then 0 else 1 end) as voided, 
	(case when r.objid is null then 0 else 1 end) as remitted, 
	(case when r.collectionvoucherid is null then 0 else 1 end) as liquidated 
from cashreceipt c   
	left join cashreceipt_void v on v.receiptid = c.objid 
	left join remittance r on r.objid = c.remittanceid 
where c.objid in (${objids}) 
order by ${orderby} 


[getUnremittedCashReceipts]
select 
	c.objid, c.formno, c.receiptno, c.receiptdate, c.txndate, 
	c.txnmode, c.paidby, c.amount, c.totalnoncash, (c.amount-c.totalnoncash) as totalcash, 
	c.collectiontype_objid, c.collectiontype_name, c.collector_objid, c.collector_name, 
	c.subcollector_objid, c.subcollector_name, c.state, 
	case when v.objid is null then 0 else 1 end as voided 
from ( 
	select cr.objid 
	from cashreceipt cr 
	where cr.remittanceid is null 
		and cr.state = 'POSTED' 
		and cr.collector_objid like $P{userid} 
		and ${filter} 
	union  
	select cr.objid 
	from cashreceipt cr 
	where cr.remittanceid is null 
		and cr.state = 'DELEGATED' 
		and cr.subcollector_objid like $P{userid} 
		and ${filter} 
)t1 
	inner join cashreceipt c on c.objid = t1.objid 
	left join cashreceipt_void v on v.receiptid = c.objid 
order by c.receiptdate, c.txndate 
