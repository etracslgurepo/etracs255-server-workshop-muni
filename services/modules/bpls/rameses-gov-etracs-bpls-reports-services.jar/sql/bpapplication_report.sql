[getList]
select 
	b.objid as businessid, tmp2.applicationid, a.apptype, a.appno, a.appyear, 
	b.orgtype, b.tradename, b.address_text as businessaddress, addr.barangay_name, 
	b.owner_name, b.owner_address_text as owner_address, 
	lob.objid as lobid, lob.name as lobname, lob.classification_objid, 
	tmp2.declaredcapital, tmp2.declaredgross, tmp2.capital, tmp2.gross, 
	case 
		when a.state='COMPLETED' then (
			select dtissued from business_permit 
			where businessid=b.objid and activeyear=a.appyear and state='ACTIVE' 
			order by version desc limit 1
		) else null 
	end as dtissued  
from ( 
	select 
		applicationid, lobid, 
		ifnull(sum(declaredcapital), 0) as declaredcapital,
		ifnull(sum(declaredgross), 0) as declaredgross,
		ifnull(sum(capital), 0) as capital,
		ifnull(sum(gross), 0) as gross 
	from ( 
		select 
			ba.objid as applicationid, bal.lobid,  
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='DECLARED_CAPITAL') as declaredcapital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='DECLARED_GROSS') as declaredgross,  
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='CAPITAL') as capital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='GROSS') as gross 
		from business_application ba 
			inner join business b on ba.business_objid=b.objid 
			inner join business_application_lob bal on bal.applicationid=ba.objid 
		where ba.appyear in (YEAR($P{startdate}), YEAR($P{enddate}))
			and ba.dtfiled >= $P{startdate} 
			and ba.dtfiled <  $P{enddate} 
			and ba.apptype in ( ${apptypefilter} ) 
			and ba.state in ( ${appstatefilter} ) 
			and b.permittype = $P{permittypeid} 
	)tmp1 
	group by applicationid, lobid 
)tmp2 
	inner join business_application a on a.objid=tmp2.applicationid 
	inner join business b on a.business_objid=b.objid 
	inner join lob on lob.objid=tmp2.lobid 
	left join business_address addr on b.address_objid=addr.objid 
where 1=1 ${filter} 
order by b.tradename, a.appno, lob.name  


[getCompletedList]
select 
	b.objid as businessid, tmp3.applicationid, a.apptype, a.appno, a.appyear, 
	b.orgtype, b.tradename, b.address_text as businessaddress, addr.barangay_name, 
	b.owner_name, b.owner_address_text as owner_address, 
	lob.objid as lobid, lob.name as lobname, lob.classification_objid, 
	tmp3.declaredcapital, tmp3.declaredgross, tmp3.capital, tmp3.gross, 
	(
		select dtissued from business_permit 
		where businessid = b.objid and activeyear = a.appyear and state = 'ACTIVE' 
		order by dtissued desc, version desc limit 1
	) as dtissued  
from ( 
	select 
		applicationid, lobid, 
		(case when sum(declaredcapital) is null then 0 else sum(declaredcapital) end) as declaredcapital, 
		(case when sum(declaredgross) is null then 0 else sum(declaredgross) end) as declaredgross, 
		(case when sum(capital) is null then 0 else sum(capital) end) as capital, 
		(case when sum(gross) is null then 0 else sum(gross) end) as gross 
	from ( 
		select 
			ba.objid as applicationid, bal.lobid,  
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='DECLARED_CAPITAL') as declaredcapital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='DECLARED_GROSS') as declaredgross,  
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='CAPITAL') as capital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='GROSS') as gross 
		from ( 
			select task.refid, max(task.enddate) as txndate   
			from business_application_task task 
			where task.enddate >= $P{taskstartdate}  
				and task.enddate <  $P{taskenddate} 
				and task.state = 'release' 
			group by task.refid 
			having max(task.enddate) >= $P{startdate} 
				and max(task.enddate) < $P{enddate} 
		)tmp1  
			inner join business_application ba on ba.objid = tmp1.refid 
			inner join business b on b.objid = ba.business_objid
			inner join business_application_lob bal on bal.applicationid = ba.objid 
		where ba.state = 'COMPLETED' 
			and ba.apptype in ( ${apptypefilter} ) 
			and b.permittype = $P{permittypeid} 
	)tmp2
	group by applicationid, lobid 
)tmp3
	inner join business_application a on a.objid = tmp3.applicationid 
	inner join business b on b.objid = a.business_objid 
	inner join lob on lob.objid = tmp3.lobid 
	left join business_address addr on addr.objid = b.address_objid 
where 1=1 ${filter} 
order by b.tradename, a.appno, lob.name  


[getPermitList]
select 
	b.objid as businessid, tmp4.applicationid, a.apptype, a.appno, a.appyear, 
	b.orgtype, b.tradename, b.address_text as businessaddress, addr.barangay_name, 
	b.owner_name, b.owner_address_text as owner_address, 
	lob.objid as lobid, lob.name as lobname, lob.classification_objid, 
	tmp4.declaredcapital, tmp4.declaredgross, tmp4.capital, tmp4.gross, 
	tmp4.dtissued, tmp4.permitno 
from ( 
	select 
		applicationid, lobid, dtissued, permitno, 
		(case when sum(declaredcapital) is null then 0 else sum(declaredcapital) end) as declaredcapital, 
		(case when sum(declaredgross) is null then 0 else sum(declaredgross) end) as declaredgross, 
		(case when sum(capital) is null then 0 else sum(capital) end) as capital, 
		(case when sum(gross) is null then 0 else sum(gross) end) as gross 
	from ( 
		select 
			ba.objid as applicationid, bal.lobid, tmp2.dtissued, tmp2.permitno, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='DECLARED_CAPITAL') as declaredcapital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='DECLARED_GROSS') as declaredgross,  
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='CAPITAL') as capital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and lob_objid=bal.lobid and attribute_objid='GROSS') as gross
		from ( 
			select tmp1.*, ( 
					select permitno from business_permit 
					where businessid = tmp1.businessid and activeyear = tmp1.activeyear 
						and dtissued = tmp1.dtissued and state = 'ACTIVE' 
					order by version desc limit 1 
				) as permitno 
			from ( 
				select businessid, activeyear, state, max(dtissued) as dtissued 
				from business_permit 
				where dtissued >= $P{startdate} 
					and dtissued < $P{enddate} 
					and state = 'ACTIVE' 
				group by businessid, activeyear, state 
			)tmp1 
		)tmp2 
			inner join business_application ba on (ba.business_objid = tmp2.businessid and ba.appyear = tmp2.activeyear) 
			inner join business b on b.objid = ba.business_objid
			inner join business_application_lob bal on bal.applicationid = ba.objid 
		where ba.appyear = tmp2.activeyear
			and ba.parentapplicationid is null 
			and ba.apptype in ( ${apptypefilter} ) 
			and b.permittype = $P{permittypeid} 
	)tmp3 
	group by applicationid, lobid, dtissued, permitno 
)tmp4
	inner join business_application a on a.objid = tmp4.applicationid 
	inner join business b on b.objid = a.business_objid 
	inner join lob on lob.objid = tmp4.lobid 
	left join business_address addr on addr.objid = b.address_objid 
where 1=1 ${filter} 
order by b.tradename, a.appno, lob.name  
