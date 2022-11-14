[approve]
update b set 
	b.state = (case 
		when b.state = 'PROCESSING' then 'ACTIVE' else b.state 
	end) 
from 
	business b, 
	vw_migrated_business mb 
where mb.objid = $P{objid} 
	and mb.appstate = 'FOR-APPROVAL' 
	and mb.txnmode = 'CAPTURE' 
	and b.objid = mb.objid 


[approveApp]
update a set 
	a.state = 'COMPLETED'
from 
	business_application a, 
	vw_migrated_business mb 
where mb.objid = $P{objid} 
	and mb.appstate = 'FOR-APPROVAL' 
	and mb.txnmode = 'CAPTURE' 
	and a.objid = mb.applicationid
