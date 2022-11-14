[getReport]
select 
	controldate, sum(total_collection) as total_collection, 
	sum(total_remittance) as total_remittance, sum(total_liquidation) as total_liquidation, 
	sum(total_deposit) as total_deposit 
from ( 
	select 
		null as controldate, 
		sum(amount) as total_collection, null as total_remittance, 
		null as total_liquidation, null as total_deposit 
	from ( 
		select sum(c.amount) as amount 
		from cashreceipt c 
			left join cashreceipt_void v on v.receiptid = c.objid 
		where c.receiptdate < $P{startdate} 
			and c.state = 'POSTED' 
			and c.remittanceid is null 
			and v.objid is null 
		union all 
		select sum(c.amount) as amount 
		from cashreceipt c 
			inner join remittance r on r.objid = c.remittanceid 
			left join cashreceipt_void v on v.receiptid = c.objid 
		where c.receiptdate < $P{startdate} 
			and r.controldate >= $P{startdate} 
			and c.state = 'POSTED' 
			and v.objid is null 
	)t0 
	having sum(amount) > 0 
	union all 
	select 
		cast(c.receiptdate as date) as controldate, 
		sum(c.amount) as total_collection, null as total_remittance, 
		null as total_liquidation, null as total_deposit 
	from cashreceipt c
		left join cashreceipt_void v on v.receiptid = c.objid 
	where c.receiptdate >= $P{startdate} 
		and c.receiptdate <  $P{enddate}
		and c.state = 'POSTED' 
		and v.objid is null 
	group by cast(c.receiptdate as date) 
	union all 
	select 
		cast(r.controldate as date) as controldate, 
		null as total_collection, sum(r.amount) as total_remittance, 
		null as total_liquidation, null as total_deposit 
	from remittance r 
	where r.controldate >= $P{startdate} 
		and r.controldate <  $P{enddate}
		and r.state = 'POSTED'
	group by cast(r.controldate as date) 
	union all 
	select 
		cast(cv.controldate as date) as controldate, 
		null as total_collection, null as total_remittance, 
		sum(cv.amount) as total_liquidation, null as total_deposit 
	from collectionvoucher cv 
	where cv.controldate >= $P{startdate} 
		and cv.controldate <  $P{enddate}
		and cv.state = 'POSTED'
	group by cast(cv.controldate as date) 
	union all 
	select 
		ds.depositdate as controldate, 
		null as total_collection, null as total_remittance, 
		null as total_liquidation, sum(ds.amount) as total_deposit 
	from depositvoucher dv 
		inner join depositvoucher_fund dvf on dvf.parentid = dv.objid 
		inner join depositslip ds on ds.depositvoucherfundid = dvf.objid 
	where ds.depositdate >= $P{startdate} 
		and ds.depositdate <  $P{enddate} 
		and ds.state in ('APPROVED','PRINTED','VALIDATED') 
	group by ds.depositdate 	
)t1
group by controldate 
