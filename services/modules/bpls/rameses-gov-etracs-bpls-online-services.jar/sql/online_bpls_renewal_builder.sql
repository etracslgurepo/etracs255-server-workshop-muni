[findBusiness]
select * from business where objid=$P{objid}


[findExistingRenewalApp]
select * 
from business_application 
where business_objid = $P{businessid}
	and appyear = $P{appyear}
	and apptype = 'RENEW'


[findBusinessApp]
select a.*, 
	oa.approvedappno, oa.contact_email, oa.contact_mobileno, oa.partnername
from business_application a 
	inner join business b on b.objid = a.business_objid 
	inner join online_business_application oa on oa.objid = a.objid 
where a.objid = $P{objid} 


[getBusinessAppInfos]
select * 
from business_active_info 
where businessid = $P{businessid} 
	and type = 'appinfo'


[insertApp]
insert into business_application (
	objid, business_objid, state, appno, apptype, dtfiled, ownername, owneraddress, 
	tradename, businessaddress, txndate, yearstarted, appyear, appqtr, txnmode, 
	createdby_objid, createdby_name, totals_tax, totals_regfee, totals_othercharge, totals_total 
) 
select 
	oa.objid, b.objid as business_objid, 'INFO' as state, approvedappno as appno, oa.apptype, 
	oa.appdate as dtfiled, b.owner_name as ownername, b.owner_address_text as owneraddress, 
	b.tradename, b.address_text as businessaddress, oa.dtcreated as txndate, b.yearstarted, 
	oa.appyear, 0 as appqtr, 'ONLINE' as txnmode, approvedby_objid as createdby_objid, 
	approvedby_name as createdby_name, 0.0 as totals_tax, 0.0 as totals_regfee, 	
	0.0 as totals_othercharge, 0.0 as totals_total 
from online_business_application oa 
	inner join business b on b.objid = oa.business_objid 
where oa.objid = $P{objid} 


[updateBusinessForProcessing]
update 
	business aa, 
	( 
		select a.objid as applicationid, a.business_objid 
		from business_application a 
		where a.objid = $P{objid} 
	)bb 
set 
	aa.state = 'PROCESSING', 
	aa.appcount = $P{appcount},  
	aa.currentapplicationid = bb.applicationid 
where aa.objid = bb.business_objid 

