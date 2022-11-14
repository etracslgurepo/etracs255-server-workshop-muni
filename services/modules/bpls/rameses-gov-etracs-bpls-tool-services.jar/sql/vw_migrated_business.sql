[approve]
update 
	business b, 
	vw_migrated_business mb 
set 
	b.state = (case 
		when b.state = 'PROCESSING' then 'ACTIVE' else b.state 
	end) 
where mb.objid = $P{objid} 
	and mb.appstate = 'FOR-APPROVAL' 
	and mb.txnmode = 'CAPTURE' 
	and b.objid = mb.objid 


[approveApp]
update 
	business_application a, 
	vw_migrated_business mb 
set 
	a.state = 'COMPLETED'
where mb.objid = $P{objid} 
	and mb.appstate = 'FOR-APPROVAL' 
	and mb.txnmode = 'CAPTURE' 
	and a.objid = mb.applicationid
