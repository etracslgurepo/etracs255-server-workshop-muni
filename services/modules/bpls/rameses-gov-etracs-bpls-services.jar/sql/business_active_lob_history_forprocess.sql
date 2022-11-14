[insertForProcess]
insert into business_active_lob_history_forprocess ( businessid ) 
select objid from business 


[getAppYears]
select 
	business_objid as businessid, appyear 
from business_application 
where business_objid = $P{businessid} 
order by appyear desc 


[getForProcessCount]
select count(*) as txncount from business_active_lob_history_forprocess 
