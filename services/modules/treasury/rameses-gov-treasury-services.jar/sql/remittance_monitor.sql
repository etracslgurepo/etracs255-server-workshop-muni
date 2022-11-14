[getUnremittedSummaries]
select t3.*, 
	r.controlno as lastremittanceno, 
	r.controldate as lastremittancedate  
from ( 
	select t2.*, ( 
			select objid from remittance 
			where collector_objid = t2.collector_objid 
			order by controldate desc, dtposted desc 
			limit 1 
		) as remittanceid 
	from ( 
		select 
			t1.collector_objid, t1.collector_name, 
			sum(t1.amount) as amount, sum(t1.voidamount) as voidamount, count(*) as icount  
		from ( 
			select distinct 
				c.objid as receiptid, c.collector_objid, c.collector_name, 
				case when v.objid is null then c.amount else 0.0 end as amount, 
				case when v.objid is null then 0.0 else c.amount end as voidamount 
			from cashreceipt c 
				left join cashreceipt_void v on v.receiptid = c.objid 
			where c.remittanceid is null 
				and c.receiptdate <= $P{rundate} 
				and c.state = 'POSTED' 
		)t1 
		group by t1.collector_objid, t1.collector_name 
	)t2 
)t3 
	left join remittance r on r.objid = t3.remittanceid 
order by t3.collector_name 
