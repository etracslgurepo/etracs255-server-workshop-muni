[getListByDateApplied]
select 
	b.tradename, b.businessname, b.address_text, b.owner_name, b.orgtype, b.yearstarted, 
	STUFF((
		select (', ' + classification_objid)
		from business_application a, business_application_lob al, lob 
		where a.business_objid = t1.business_objid 
			and a.appyear = t1.appyear 
			and a.apptype in ('NEW','RENEW') 
			and a.state = 'COMPLETED' 
			and al.applicationid = a.objid 
			and lob.objid = al.lobid 
		FOR XML PATH('')), 1, 1, ''
	) as businessnature, 
	(
		select top 1 permitno from business_permit 
		where businessid = t1.business_objid 
			and activeyear = t1.appyear 
			and state = 'ACTIVE' 
		order by dtissued desc, version desc 
	) as permitno 
from ( 
		select distinct business_objid, appyear  
		from business_application 
		where dtfiled >= $P{startdate} 
			and dtfiled <= $P{enddate} 
			and appyear = YEAR(dtfiled) 
			and apptype in ('NEW','RENEW') 
			and state in ('COMPLETED') 
	)t1
	inner join business b on b.objid = t1.business_objid 
where b.permittype = $P{permittypeid} 	
order by b.businessname 


[getListByDateReleased]
select 
	b.tradename, b.businessname, b.address_text, b.owner_name, b.orgtype, b.yearstarted, 
	STUFF((
		select (', ' + classification_objid)
		from business_application a, business_application_lob al, lob 
		where a.business_objid = t1.business_objid 
			and a.appyear = t1.appyear 
			and a.apptype in ('NEW','RENEW') 
			and a.state = 'COMPLETED' 
			and al.applicationid = a.objid 
			and lob.objid = al.lobid 
		FOR XML PATH('')), 1, 1, ''
	) as businessnature, 
	(
		select top 1 permitno from business_permit 
		where businessid = t1.business_objid 
			and activeyear = t1.appyear 
			and state = 'ACTIVE' 
		order by dtissued desc, version desc 
	) as permitno 
from ( 
		select distinct a.business_objid, a.appyear  
		from business_application_task t, business_application a 
		where t.enddate >= $P{startdate} 
			and t.enddate <= $P{enddate} 
			and t.state = 'release' 
			and a.objid = t.refid 
			and a.appyear = YEAR(t.enddate) 
			and a.apptype in ('NEW','RENEW') 
			and a.state in ('COMPLETED') 
	)t1
	inner join business b on b.objid = t1.business_objid 
where b.permittype = $P{permittypeid} 	
order by b.businessname 
