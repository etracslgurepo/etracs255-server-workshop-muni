[getReportByCollectionType]
select 
	cast(c.receiptdate as date) as controldate, sum(c.amount) as amount, 
	c.collectiontype_name as particulars, ct.sortorder as indexno
from cashreceipt c
	left join collectiontype ct on ct.objid = c.collectiontype_objid 
	left join cashreceipt_void v on v.receiptid = c.objid 
where c.receiptdate >= $P{startdate}
	and c.receiptdate <  $P{enddate}
	and c.state = 'POSTED' 
	and v.objid is null 
	and ${filter} 
group by cast(c.receiptdate as date), c.collectiontype_name, ct.sortorder
order by cast(c.receiptdate as date), ct.sortorder, c.collectiontype_name 


[getReportByFund]
select 
	controldate, sum(amount) as amount, 
	particulars, indexno, fund_objid 
from ( 
	select 
		cast(c.receiptdate as date) as controldate, sum(ci.amount) as amount, 
		fund.title as particulars, fg.indexno as indexno, fund.objid as fund_objid 
	from cashreceipt c 
		inner join cashreceiptitem ci on ci.receiptid = c.objid 
		inner join fund on fund.objid = ci.item_fund_objid 
		inner join fundgroup fg on fg.objid = fund.groupid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where c.receiptdate >= $P{startdate} 
		and c.receiptdate <  $P{enddate} 
		and c.state = 'POSTED' 
		and v.objid is null 
		and ${filter} 
	group by cast(c.receiptdate as date), fund.title, fund.objid, fg.indexno
	union all 
	select 
		cast(c.receiptdate as date) as controldate, -sum(cs.amount) as amount, 
		fund.title as particulars, fg.indexno as indexno, fund.objid as fund_objid 
	from cashreceipt c 
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on ia.objid = cs.refitem_objid 
		inner join fund on fund.objid = ia.fund_objid 
		inner join fundgroup fg on fg.objid = fund.groupid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where c.receiptdate >= $P{startdate} 
		and c.receiptdate <  $P{enddate} 
		and c.state = 'POSTED' 
		and v.objid is null 
		and ${filter} 
	group by cast(c.receiptdate as date), fund.title, fund.objid, fg.indexno
	union all 
	select 
		cast(c.receiptdate as date) as controldate, sum(cs.amount) as amount, 
		fund.title as particulars, fg.indexno as indexno, fund.objid as fund_objid 
	from cashreceipt c 
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on ia.objid = cs.payableitem_objid 
		inner join fund on fund.objid = ia.fund_objid 
		inner join fundgroup fg on fg.objid = fund.groupid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where c.receiptdate >= $P{startdate} 
		and c.receiptdate <  $P{enddate} 
		and c.state = 'POSTED' 
		and v.objid is null 
		and ${filter} 
	group by cast(c.receiptdate as date), fund.title, fund.objid, fg.indexno
)t0 
group by controldate, particulars, indexno, fund_objid 
order by controldate, indexno, particulars 


[getReportByCollector]
select 
	cast(c.receiptdate as date) as controldate, 
	sum(c.amount) as amount, c.collector_name as particulars 
from cashreceipt c
	left join cashreceipt_void v on v.receiptid = c.objid 
where c.receiptdate >= $P{startdate} 
	and c.receiptdate <  $P{enddate} 
	and c.state = 'POSTED' 
	and v.objid is null 
	and ${filter} 
group by cast(c.receiptdate as date), c.collector_name
order by cast(c.receiptdate as date), c.collector_name
