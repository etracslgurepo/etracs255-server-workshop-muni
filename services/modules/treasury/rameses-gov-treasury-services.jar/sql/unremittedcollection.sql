[getList]
select 
	c.objid, c.state, c.txndate, c.txnmode, c.formno, c.receiptno, c.receiptdate, 
	c.paidby, c.paidbyaddress, c.collectiontype_name, c.collectiontype_objid, 
	c.controlid, c.collector_objid, c.collector_name, 
	case when t1.voided=0 then 0 else 1 end as voided, 
	case when t1.voided=0 then c.amount else 0.0 end as amount 
from ( 
	select c.objid, 
		(select count(*) from cashreceipt_void where receiptid=c.objid) as voided 
	from cashreceipt c 
	where c.remittanceid is null 
		and c.collector_objid = $P{collectorid} 
		and c.state in ('POSTED','CANCELLED','DELEGATED') 
		${filter} 
)t1, cashreceipt c 
where c.objid = t1.objid 
order by c.formno, c.controlid, c.series 
