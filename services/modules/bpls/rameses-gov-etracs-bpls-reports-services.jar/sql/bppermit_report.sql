[getLOBs]
SELECT alob.*, 
	a.apptype, a.txndate, a.dtfiled, a.appno, 
	(
		select sum(decimalvalue) from business_application_info 
		where applicationid=a.objid and lob_objid=alob.lobid and attribute_objid='CAPITAL' 
	) as capital, 
	(
		select sum(decimalvalue) from business_application_info 
		where applicationid=a.objid and lob_objid=alob.lobid and attribute_objid='GROSS' 
	) as gross 	
from business_permit p 
	inner join business_application pa on pa.objid=p.applicationid 
	inner join business_application a on (a.business_objid=pa.business_objid and a.appyear=pa.appyear)
	inner join business_application_lob alob on alob.applicationid=a.objid 
where p.objid = $P{permitid} 
	and a.state='COMPLETED' 
	and a.txndate <= pa.txndate 
order by a.txndate 


[getPayments]
select bpay.refno   
from business_permit p 
	inner join business_application pa on pa.objid=p.applicationid 
	inner join business_application a on (a.business_objid=pa.business_objid and a.appyear=pa.appyear )
	inner join business_payment bpay on (bpay.applicationid=a.objid and bpay.voided=0) 
where p.objid = $P{permitid}  
	and a.state='COMPLETED' 
	and a.txndate <= pa.txndate 
order by bpay.refdate, bpay.refno 


[getList]
select * from ( 
	select tmp2.*, 
		b.owner_name, b.owner_address_text as owner_address, 
		b.tradename, b.address_text as businessaddress, 
		b.objid as business_objid, idtin.idno as tin, b.orgtype, 
	 	(
			select sum( ai.intvalue ) from business_application a 
				inner join business_application_info ai on ai.applicationid=a.objid 
			where a.business_objid=tmp2.businessid 
				and a.appyear=tmp2.activeyear 
				and a.apptype in ('NEW','RENEW')
				and a.state='COMPLETED' 			
				and ai.attribute_objid='NUM_EMPLOYEE' 
		) as numemployee, 
		(
			select sum( ai.intvalue ) from business_application a 
				inner join business_application_info ai on ai.applicationid=a.objid 
			where a.business_objid=tmp2.businessid 
				and a.appyear=tmp2.activeyear 
				and a.apptype in ('NEW','RENEW')
				and a.state='COMPLETED' 			
				and ai.attribute_objid='NUM_EMPLOYEE_MALE'
		) as nummale, 
		(
			select sum( ai.intvalue ) from business_application a 
				inner join business_application_info ai on ai.applicationid=a.objid 
			where a.business_objid=tmp2.businessid 
				and a.appyear=tmp2.activeyear 
				and a.apptype in ('NEW','RENEW')
				and a.state='COMPLETED' 			
				and ai.attribute_objid='NUM_EMPLOYEE_FEMALE' 
		) as numfemale    
	from ( 
		select tmp1.*, 
			p.objid as permitid, p.permitno, p.dtissued  
		from ( 
			select 
				businessid, activeyear, max(version) as maxver 
			from business_permit 
			where activeyear in (YEAR($P{startdate}), YEAR($P{enddate}))
				and dtissued >= $P{startdate} 
				and dtissued <  $P{enddate} 
				and state = 'ACTIVE' 
			group by businessid, activeyear 
		)tmp1, business_permit p 
		where p.businessid=tmp1.businessid 
			and p.activeyear=tmp1.activeyear 
			and p.version=tmp1.maxver 
	)tmp2 
		inner join business_application ba on (ba.business_objid=tmp2.businessid and ba.appyear=tmp2.activeyear) 
		inner join business b on ba.business_objid=b.objid 
		left join entityid idtin on (idtin.entityid=b.owner_objid and idtin.idtype='TIN') 	
		left join business_address addr ON b.address_objid=addr.objid  
	where ba.parentapplicationid is null 
		and ba.apptype in ('NEW','RENEW') 
		${filter}  
)tmp3 
${orderbyfilter} 
