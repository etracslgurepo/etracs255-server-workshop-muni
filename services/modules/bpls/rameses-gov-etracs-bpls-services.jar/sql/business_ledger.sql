[getList]
select distinct 
	b.objid, b.state, b.bin, b.tradename, b.businessname, 
	b.owner_objid, b.owner_name, b.activeyear, 
	b.address_objid, b.address_text, xx.sortindex  
from ( 
	select businessid, min(sortindex) as sortindex 
	from ( 
		select objid as businessid, 0 as sortindex 
		from business 
		where bin like $P{bin} 
		union 
		select objid as businessid, 1 as sortindex  
		from business 
		where businessname like $P{businessname} 
		union 
		select objid as businessid, 2 as sortindex  
		from business 
		where owner_name like $P{ownername} 
	)xx 
	group by businessid 
)xx 
	inner join business b on xx.businessid=b.objid 
where b.state not in ('PROCESSING') 
order by xx.sortindex, b.tradename 
