[getReportA]
select 
	c.receiptdate, c.receiptno, c.txnmode, c.txndate, c.paidby, c.paidbyaddress, 
	t1.amount, t1.totalcash, t1.totalcheck, t1.totalcr, c.collector_name, 
	c.collectiontype_name, c.org_name, c.formno, c.user_name 
from ( 
	select 
		objid, sum(amount) as amount, 
		sum(amount)-sum(totalcheck + totalcr) as totalcash, 
		sum(totalcheck) as totalcheck, sum(totalcr) as totalcr 
	from ( 
		select c.objid, c.amount, 0.0 as totalcheck, 0.0 as totalcr 
		from cashreceipt c 
			left join cashreceipt_void v on v.receiptid = c.objid 
		where c.receiptdate < $P{startdate}
			and c.state = 'POSTED' 
			and c.remittanceid is null 
			and v.objid is null 
		union all 
		select 
			c.objid, 0.0 as amount, 
			(case when nc.reftype = 'CHECK' then nc.amount else 0.0 end) as totalcheck, 
			(case when nc.reftype = 'CHECK' then 0.0 else nc.amount end) as totalcr 
		from cashreceipt c 
			inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
			left join cashreceipt_void v on v.receiptid = c.objid 
		where c.receiptdate < $P{startdate}
			and c.state = 'POSTED' 
			and c.remittanceid is null 
			and v.objid is null 
	)t0 
	group by objid 
)t1, cashreceipt c 
where c.objid = t1.objid 
order by c.receiptdate, c.txndate 
