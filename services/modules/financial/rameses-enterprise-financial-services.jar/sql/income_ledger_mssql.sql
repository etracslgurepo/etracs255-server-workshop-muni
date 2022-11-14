[getReport]
select 
	t1.objid, t1.code, t1.title, t1.type, 
	t1.leftindex, t1.rightindex, t1.[level], 
	t1.maingroupid, sum(t1.amount) as amount 
from ( 
	select 
		a.objid, a.code, a.title, a.type, 
		a.leftindex, a.rightindex, a.[level], 
		a.maingroupid, sum(a.amount) as amount 
	from vw_account_item_mapping a 
	where a.maingroupid = $P{maingroupid} ${filter} 
	group by 	
		a.objid, a.code, a.title, a.type, 
		a.leftindex, a.rightindex, a.[level], 
		a.maingroupid 

	union all 

	select 
		p.objid, p.code, p.title, p.type, 
		p.leftindex, p.rightindex, p.[level], 
		p.maingroupid, 0.0 as amount  
	from account p 
		inner join ( 
			select a.maingroupid, max(a.leftindex) as leftindex 
			from vw_account_item_mapping a 
			where a.maingroupid = $P{maingroupid} ${filter} 
			group by a.maingroupid 
		)m on p.maingroupid = m.maingroupid 
	where p.leftindex < m.leftindex 

	union all 

	select 
		a.itemid as objid, a.itemcode as code, a.itemtitle as title, 'itemaccount' as type, 
		a.leftindex, a.rightindex, a.[level]+1 as [level], a.maingroupid, sum(a.amount) as amount 
	from vw_account_item_mapping a 
	where a.maingroupid = $P{maingroupid} ${filter} ${itemacctfilter} 
	group by 
		a.itemid, a.itemcode, a.itemtitle, a.leftindex, a.rightindex, a.[level], a.maingroupid 	
)t1 
group by 
	t1.objid, t1.code, t1.title, t1.type, 
	t1.leftindex, t1.rightindex, t1.[level], 
	t1.maingroupid 
order by t1.leftindex, t1.[level], t1.code  
