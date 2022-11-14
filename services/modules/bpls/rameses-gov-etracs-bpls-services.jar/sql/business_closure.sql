[findInfo]
select 
	b.objid, b.bin, b.state, b.activeyear, b.owner_name, 
	b.owner_address_text, b.businessname, b.tradename, b.address_text, 
	c.objid as closure_objid, c.dtceased as closure_dtceased, 
	c.dtissued as closure_dtissued, c.remarks as closure_remarks, 
	ei.objid as ind_objid, ei.gender as ind_gender,  
	concat(ei.firstname,case when ei.middlename is null then ' ' else concat(' ',ei.middlename,' ') end,ei.lastname) as ind_name 
from business b 
	left join business_closure c on c.businessid = b.objid 
	inner join entity e on e.objid = b.owner_objid 
	left join entityindividual ei on ei.objid = b.owner_objid 
where b.objid = $P{businessid} 
