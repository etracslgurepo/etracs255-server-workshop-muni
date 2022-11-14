[findApp]
select * from business_application where objid = $P{objid} 

[changeAppMode]
update business_application set txnmode = $P{txnmode} where objid = $P{objid} 

[findBusiness]
select * from business where objid = $P{objid} 

[getApplicationLobs]
select * from business_application_lob where applicationid = $P{applicationid} 

[getApplicationInfos]
select * from business_application_info where applicationid = $P{applicationid} 

[getActiveLobs]
select * from business_active_lob where businessid = $P{businessid} 

[getActiveInfos]
select * from business_active_info where businessid = $P{businessid} 

[removeActiveLobs]
delete from business_active_lob where businessid = $P{businessid} 

[removeActiveLob]
delete from business_active_lob where businessid = $P{businessid} and lobid = $P{lobid}  

[getBusinessAppLobs]
select alob.* 
from business_application a 
	inner join business_application_lob alob on alob.applicationid = a.objid 
where a.business_objid = $P{businessid} 
	and a.appyear = $P{appyear} 
	and a.state = 'COMPLETED' 
order by a.txndate, alob.name 
