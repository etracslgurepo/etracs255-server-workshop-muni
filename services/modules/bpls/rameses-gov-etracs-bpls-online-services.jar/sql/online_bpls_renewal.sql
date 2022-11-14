[findBIN]
select * from business where bin=$P{bin}

[findBusiness]
select * from business where objid=$P{objid}

[findLastApp]
select 
	a.objid, a.appno, a.appyear, a.txndate, a.apptype, a.state, b.nextrenewaldate  
from business b 
	inner join business_application a on a.business_objid = b.objid 
where b.bin = $P{bin} 
	and a.appyear <= $P{currentyear} 
	and a.apptype in ('NEW','RENEW') 
order by a.appyear desc, a.txndate desc 


[getDelinquentApps]
select 
	a.objid, a.appyear, a.apptype, 
	a.appno, a.dtfiled, a.txndate, 
	sum(r.amount - r.amtpaid) as balance   
from business b 
	inner join business_application a on a.business_objid = b.objid 
	inner join business_receivable r on r.applicationid = a.objid 
where b.bin = $P{bin} 
	and a.appyear < $P{currentyear} 
	and a.state in ('PAYMENT','RELEASE','COMPLETED') 
group by 	
	a.objid, a.appyear, a.apptype,  
	a.appno, a.dtfiled, a.txndate 
having sum(r.amount - r.amtpaid) > 0 
order by a.appyear, a.txndate 


[getRedFlags]
select * from ( 
	select caseno, message, dtfiled 
	from business_redflag 
	where businessid= $P{businessid} 
		and resolved = 0 
		and effectivedate is null 

	union all 

	select caseno, message, dtfiled 
	from business_redflag 
	where businessid = $P{businessid} 
		and resolved = 0 
		and effectivedate <= $P{currentdate} 
)t1 
order by dtfiled 


[findApplication]
select 
	b.objid as businessid, b.bin, b.tradename, 
	b.businessname, b.address_text as businessaddress, 
	b.owner_name, b.owner_address_text as owner_address, 
	b.yearstarted, b.activeyear, 
	a.objid as prevapp_objid, a.appno as prevapp_appno, 
	a.apptype as prevapp_apptype, a.appyear as prevapp_appyear 
from business_application a 
	inner join business b on b.objid = a.business_objid 
where a.objid = $P{objid} 


[getApplicationLobs]
select t2.*, 
	(case when cap.objid is null then null else cap.decimalvalue end) as prevcapital, 
	(case when gro.objid is null then null else gro.decimalvalue end) as prevgross 
from ( 
	select 
		t1.business_objid, t1.appyear, 
		lob.objid as lob_objid, lob.name as lob_name, 
		max(t1.txndate) as txndate, sum(t1.iflag) as iflag 
	from ( 
		select 
			a.business_objid, a.appyear, a.txndate, al.lobid, 
			(case when al.assessmenttype = 'RETIRE' then -1 else 1 end) as iflag 
		from business b 
			inner join business_application a on a.business_objid = b.objid 
			inner join business_application_lob al on al.applicationid = a.objid 
		where b.objid = $P{businessid} 
			and a.appyear = $P{appyear} 
			and a.state = 'COMPLETED' 
	)t1, lob 
	where lob.objid = t1.lobid 
	group by t1.business_objid, t1.appyear, lob.objid, lob.name 
	having sum(t1.iflag) > 0 
)t2 
	inner join business_application ba on ba.business_objid = t2.business_objid 
	left join business_application_info cap on (cap.applicationid = ba.objid and cap.lob_objid = t2.lob_objid and cap.attribute_objid = 'CAPITAL') 
	left join business_application_info gro on (gro.applicationid = ba.objid and gro.lob_objid = t2.lob_objid and gro.attribute_objid = 'GROSS') 
where ba.appyear = t2.appyear 
	and ba.txndate = t2.txndate 
order by t2.txndate 


[getApplicationInfos]
select 
	v.objid, v.name, v.caption, v.datatype, 
	ai.attribute_objid, ai.attribute_name, 
	case 
		when v.datatype = 'decimal' then ai.decimalvalue 
		when v.datatype = 'integer' then ai.intvalue
		when v.datatype = 'boolean' then ai.boolvalue
		else ai.stringvalue 
	end as value 
from business b 
	inner join business_active_info ai on ai.businessid = b.objid 
	inner join businessvariable v on v.objid = ai.attribute_objid 
where b.objid = $P{businessid} 
	and ai.lob_objid is null 
	and ai.attribute_objid in (  
		'NUM_EMPLOYEE_MALE', 'NUM_EMPLOYEE_FEMALE', 'NUM_EMPLOYEE_RESIDENT'
	) 
