[getList]
select cg.* 
from ( 
	select objid as collectiongroupid 
	from collectiongroup 
	where name like $P{searchtext}  
	union 
	select objid as collectiongroupid 
	from collectiongroup 
	where org_objid like $P{orgid} 
		and name like $P{searchtext}  
	union 
	select cgi.collectiongroupid 
	from itemaccount ia 
		inner join collectiongroup_revenueitem cgi on ia.objid=cgi.revenueitemid 
		inner join collectiongroup cg on cgi.collectiongroupid=cg.objid 
	where ia.fund_objid like $P{fundid} 
		and cg.name like $P{searchtext} 
)xx1, collectiongroup cg 
where cg.objid=xx1.collectiongroupid 
order by cg.name 

[deleteRevenueItems]
delete from collectiongroup_revenueitem where collectiongroupid=$P{objid} 

[getRevenueItems]
select c.*, r.* from collectiongroup_revenueitem c 
	inner join itemaccount r on r.objid = c.revenueitemid 
where c.collectiongroupid = $P{objid} 
order by c.orderno 

[approve]
update collectiongroup set state='APPROVED' where objid=$P{objid} 

