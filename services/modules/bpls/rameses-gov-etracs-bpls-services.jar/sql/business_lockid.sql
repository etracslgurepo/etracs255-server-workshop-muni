[findBusiness]
select 
	b.objid, b.state, b.yearstarted, a.objid as app_objid
from business b 
	left join business_application a on a.objid = b.currentapplicationid  
where b.objid = $P{objid} 


[findApp]
select 
	a.objid, a.appno 
from business_application a 
where a.objid = $P{objid} 
	and a.appyear = $P{appyear} 
	and a.apptype = $P{apptype} 
