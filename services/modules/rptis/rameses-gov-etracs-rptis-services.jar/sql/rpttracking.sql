[getLogs]
select *
from (
	select 
		startdate, 
		state,
		assignee_name
	from faas_task
	where refid = $P{objid}
	and state not like 'assign%'

	union 

	select 
		startdate, 
		state,
		assignee_name
	from subdivision_task
	where refid = $P{objid}
	and state not like 'assign%'

	union 

	select 
		startdate, 
		state,
		assignee_name
	from consolidation_task
	where refid = $P{objid}
	and state not like 'assign%'

	union 

	select 
		startdate, 
		state,
		assignee_name
	from cancelledfaas_task
	where refid = $P{objid}
	and state not like 'assign%'

	union 

	select 
		startdate, 
		state,
		assignee_name
	from resection_task
	where refid = $P{objid}
	and state not like 'assign%'
)x
order by x.startdate
