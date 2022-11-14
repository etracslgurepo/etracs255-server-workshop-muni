[getUnuseChecks]
select 
	cp.objid, cp.refno, cp.refdate, cp.amount, 
	cp.bankid, cp.bank_name, cp.receivedfrom, cp.state, 
	cp.collector_objid, cp.collector_name, 
	cp.subcollector_objid, cp.subcollector_name 
from (  
	select objid 
	from checkpayment 
	where collector_objid like $P{userid} 
		and amtused = 0 
		and ${filter} 
	union 
	select objid 
	from checkpayment 
	where subcollector_objid like $P{userid} 
		and amtused = 0 
		and ${filter} 
)t1 
	inner join checkpayment cp on cp.objid = t1.objid 
order by cp.refdate, cp.refno 
