[getProcessingSummaries]
select t.* 
from (
	select 
		1 as task_typeid,
		case when ft.assignee_name is null then 0 else 1 end as task_assigneeid,
		sn.idx as task_idx,
		'FAAS' as type,
		case when ft.assignee_name is null then 'UN-ASSIGNED' else ft.assignee_name end as assignee_name,
		sn.title as taskstate,
		count(*) as count
	from faas_list fl
		inner join faas_task ft on fl.taskid = ft.objid 
		inner join sys_wf_node sn on ft.state = sn.name
	where fl.lguid = $P{lguid}
		and fl.state not in ('current', 'cancelled')
		and sn.processname = 'faas'
	group by 
		ft.assignee_name,
		sn.title,
		sn.idx 

	union all 

	select 
		2 as task_typeid,
		case when st.assignee_name is null then 0 else 1 end as task_assigneeid,
		sn.idx as task_idx,
		'Subdivision' as type,
		case when st.assignee_name is null then 'UN-ASSIGNED' else st.assignee_name end as assignee_name,
		sn.title as taskstate,
		count(*) as count
	from subdivision s
		inner join subdivision_task st on s.objid = st.refid 
		inner join sys_wf_node sn on st.state = sn.name 
	where s.lguid = $P{lguid}
	and s.state not in ('approved')
	and sn.processname = 'subdivision'
	and st.enddate is null 
	group by 
		st.assignee_name,
		st.assignee_title,
		sn.title,
		sn.idx

	union all 


	select 
		3 as task_typeid,
		case when st.assignee_name is null then 0 else 1 end as task_assigneeid,
		sn.idx as task_idx,
		'Consolidation' as type,
		case when st.assignee_name is null then 'UN-ASSIGNED' else st.assignee_name end as assignee_name,
		sn.title as taskstate,
		count(*) as count
	from consolidation c
		inner join consolidation_task st on c.objid = st.refid 
		inner join sys_wf_node sn on st.state = sn.name 
	where c.lguid = $P{lguid}
	and c.state not in ('approved')
	and sn.processname = 'consolidation'
	and st.enddate is null 
	group by 
		st.assignee_name,
		sn.title,
		sn.idx

	union all 

	
	select 
		4 as task_typeid,
		case when st.assignee_name is null then 0 else 1 end as task_assigneeid,
		sn.idx as task_idx,
		'Cancelled FAAS' as type,
		case when st.assignee_name is null then 'UN-ASSIGNED' else st.assignee_name end as assignee_name,
		sn.title as taskstate,
		count(*) as count
	from cancelledfaas c
		inner join cancelledfaas_task st on c.objid = st.refid 
		inner join sys_wf_node sn on st.state = sn.name 
	where c.lguid = $P{lguid}
	and c.state not in ('approved')
	and sn.processname = 'cancelledfaas'
	and st.enddate is null 
	group by 
		st.assignee_name,
		sn.title,
		sn.idx
)t 
order by 
	t.task_typeid,
	t.task_assigneeid,
	t.assignee_name,
	t.task_idx




[getTxnDetails]
select 
	t.type, 
	t.txntype_objid,
	t.assignee,
	t.idx,
	t.state,
	sum(t.count) as txncount 
from (
	select 
		'01.FAAS' as type,
		f.txntype_objid,
		ft.assignee_name as assignee, 
		sn.idx,
		sn.title as state,
		count(*) as count
	from faas f
		inner join faas_task ft on f.objid = ft.refid
		inner join sys_wf_node sn on ft.state = sn.name
	where f.lguid =  $P{lguid}
		and ft.state not like 'assign%'
		and sn.processname = 'faas'
		and year(ft.startdate) = $P{year}
    	and month(ft.startdate) = $P{monthid}
	group by 
	  f.txntype_objid,
		ft.assignee_name,
		sn.idx,
		sn.title
		

	union all 

	select 
		'02.Subdivision' as type,
		s.txntype_objid,
		st.assignee_name as assignee, 
		sn.idx,
		sn.title as state,
		count(*) as count
	from subdivision s
		inner join subdivision_task st on s.objid = st.refid 
		inner join sys_wf_node sn on st.state = sn.name 
	where s.lguid = $P{lguid}
	and sn.processname = 'subdivision'
	and year(st.startdate) = $P{year}
	and month(st.startdate) = $P{monthid}
	group by 
		s.txntype_objid,
		st.assignee_name,
		sn.idx,
		sn.title

	union all 

	select 
		'03.Consolidation' as type,
		'CS' as txntype_objid,
		st.assignee_name as assignee, 
		sn.idx,
		sn.title as state,
		count(*) as count
	from consolidation c
		inner join consolidation_task st on c.objid = st.refid 
		inner join sys_wf_node sn on st.state = sn.name 
	where c.lguid = $P{lguid}
	and sn.processname = 'consolidation'
	and year(st.startdate) = $P{year}
	and month(st.startdate) = $P{monthid}
	group by 
		st.assignee_name,
		sn.idx,
		sn.title


	union all 

	
	select 
		'04.FAAS Cancellation' as type,
		'CF' as txntype_objid,
		st.assignee_name as assignee, 
		sn.idx,
		sn.title as state,
		count(*) as count
	from cancelledfaas c
		inner join cancelledfaas_task st on c.objid = st.refid 
		inner join sys_wf_node sn on st.state = sn.name 
	where c.lguid =  $P{lguid}
	and sn.processname = 'cancelledfaas'
	and year(st.startdate) = $P{year}
	and month(st.startdate) = $P{monthid}
	group by 
		st.assignee_name,
		sn.idx,
		sn.title

)t 
group by 
	t.type, 
	t.txntype_objid,
	t.assignee,
	t.idx,
	t.state
order by 
	t.type, 
	t.txntype_objid,
	t.idx




[getReportLogs]
select 
	x.objid, 
	x.tdno,
	x.idx,
	x.txntype_objid,
	x.dtreceived,
	x.appraiser,
	x.taxmapper,
	x.state,
	min(x.startdate) as startdate,
	max(x.enddate) as enddate 
from (
	select
		f.objid, 
		f.tdno,
		sn.idx, 
		f.txntype_objid, 
		(select top 1 startdate from faas_task where refid = f.objid and state = 'receiver' order by startdate) as dtreceived, 
		(select top 1 assignee_name from faas_task where refid = f.objid and state = 'appraiser' order by startdate desc ) as appraiser, 
		(select top 1 assignee_name from faas_task where refid = f.objid and state = 'taxmapper' order by startdate desc ) as taxmapper, 
		ft.state, 
		ft.startdate, 
		ft.enddate
	from faas f 
		inner join faas_task ft on f.objid = ft.refid 
		inner join sys_wf_node sn on ft.state = sn.name and sn.processname = 'faas' 
	where f.year = $P{year}
	and f.month = $P{monthid}
	and f.state in ('current', 'cancelled')
	and ft.state not like 'assign%'
	and ft.state not like '%chief%'
) x
group by 
	x.objid, 
	x.tdno,
	x.idx,
	x.txntype_objid,
	x.dtreceived,
	x.appraiser,
	x.taxmapper,
	x.state
order by x.tdno, x.idx 