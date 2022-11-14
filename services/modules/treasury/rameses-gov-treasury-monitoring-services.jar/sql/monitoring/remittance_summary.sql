[getReportA]
select 
	cast(r.controldate as date) as controldate, 
	r.amount, r.controlno, r.collector_name 
from remittance r 
where r.controldate >= $P{startdate} 
	and r.controldate <  $P{enddate} 
	and r.state = 'POSTED' 
	and ${filter} 
order by cast(r.controldate as date), r.collector_name 


[getReportB]
select 
	cast(r.controldate as date) as controldate, 
	sum(r.totalcash) as totalcash, sum(r.totalcheck) as totalcheck, 
	sum(r.totalcr) as totalcr, sum(r.amount) as amount 
from remittance r 
where r.controldate >= $P{startdate} 
	and r.controldate <  $P{enddate} 
	and r.state = 'POSTED' 
	and ${filter} 
group by cast(r.controldate as date)
order by cast(r.controldate as date)


[getReportByFund]
select 
	controldate, sum(amount) as amount, 
	particulars, indexno, fund_objid 
from ( 
	select 
		cast(r.controldate as date) as controldate, sum(ci.amount) as amount, 
		fund.title as particulars, fg.indexno as indexno, fund.objid as fund_objid 
	from remittance r 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptitem ci on ci.receiptid = c.objid 
		inner join fund on fund.objid = ci.item_fund_objid 
		inner join fundgroup fg on fg.objid = fund.groupid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where r.controldate >= $P{startdate} 
		and r.controldate <  $P{enddate} 
		and r.state = 'POSTED' 
		and v.objid is null 
		and ${filter} 
	group by cast(r.controldate as date), fund.title, fund.objid, fg.indexno
	union all 
	select 
		cast(r.controldate as date) as controldate, -sum(cs.amount) as amount, 
		fund.title as particulars, fg.indexno as indexno, fund.objid as fund_objid 
	from remittance r 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on ia.objid = cs.refitem_objid 
		inner join fund on fund.objid = ia.fund_objid 
		inner join fundgroup fg on fg.objid = fund.groupid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where r.controldate >= $P{startdate} 
		and r.controldate <  $P{enddate} 
		and r.state = 'POSTED' 
		and v.objid is null 
		and ${filter} 
	group by cast(r.controldate as date), fund.title, fund.objid, fg.indexno
	union all 
	select 
		cast(r.controldate as date) as controldate, sum(cs.amount) as amount, 
		fund.title as particulars, fg.indexno as indexno, fund.objid as fund_objid 
	from remittance r 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on ia.objid = cs.payableitem_objid
		inner join fund on fund.objid = ia.fund_objid 
		inner join fundgroup fg on fg.objid = fund.groupid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where r.controldate >= $P{startdate} 
		and r.controldate <  $P{enddate} 
		and r.state = 'POSTED' 
		and v.objid is null 
		and ${filter} 
	group by cast(r.controldate as date), fund.title, fund.objid, fg.indexno
)t0 
group by controldate, particulars, indexno, fund_objid 
order by controldate, indexno, particulars 


[getReportByCollector]
select 
	cast(r.controldate as date) as controldate, 
	sum(r.amount) as amount, r.collector_name as particulars 
from remittance r 
where r.controldate >= $P{startdate} 
	and r.controldate <  $P{enddate} 
	and r.state = 'POSTED' 
	and ${filter} 
group by cast(r.controldate as date), r.collector_name
order by cast(r.controldate as date), r.collector_name


[getReportByCollectionType]
select 
	cast(r.controldate as date) as controldate, sum(c.amount) as amount, 
	c.collectiontype_name as particulars, ct.sortorder as indexno
from remittance r 
	inner join cashreceipt c on c.remittanceid = r.objid 
	left join collectiontype ct on ct.objid = c.collectiontype_objid 
	left join cashreceipt_void v on v.receiptid = c.objid 
where r.controldate >= $P{startdate} 
	and r.controldate <  $P{enddate} 
	and r.state = 'POSTED' 
	and v.objid is null 
	and ${filter} 
group by cast(r.controldate as date), c.collectiontype_name, ct.sortorder
order by cast(r.controldate as date), ct.sortorder, c.collectiontype_name 
