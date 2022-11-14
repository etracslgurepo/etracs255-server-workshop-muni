[getNodes]
select n.name, n.title as caption
from sys_wf_node n
where n.processname = 'faas'
and n.name not like 'assign%'
and n.name <> 'start'
and exists(select * from sys_wf_transition where processname='faas' and parentid = n.name)
order by n.idx

[insertFaasList]
insert into faas_list(
	objid,
	state,
	datacapture,
	rpuid,
	realpropertyid,
	ry,
	txntype_objid,
	tdno,
	utdno,
	prevtdno,
	displaypin,
	pin,
	taxpayer_objid,
	owner_name,
	owner_address,
	administrator_name,
	administrator_address,
	rputype,
	barangayid,
	barangay,
	classification_objid,
	classcode,
	cadastrallotno,
	blockno,
	surveyno,
	titleno,
	totalareaha,
	totalareasqm,
	totalmv,
	totalav,
	effectivityyear,
	effectivityqtr,
	cancelreason,
	cancelledbytdnos,
	lguid,
	originlguid,
	yearissued,
	taskid,
	taskstate,
	assignee_objid
)
select 
	f.objid,
	f.state,
	f.datacapture,
	f.rpuid,
	f.realpropertyid,
	r.ry,
	f.txntype_objid,
	f.tdno,
	f.utdno,
	f.prevtdno,
	f.fullpin as displaypin,
	case when r.rputype = 'land' then rp.pin else concat(rp.pin, '-', r.suffix) end as pin,
	f.taxpayer_objid,
	f.owner_name,
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	r.rputype,
	rp.barangayid,
	(select name from barangay where objid = rp.barangayid) as barangay,
	r.classification_objid,
	pc.code as classcode,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	f.titleno,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	f.effectivityyear,
	f.effectivityqtr,
	f.cancelreason,
	f.cancelledbytdnos,
	f.lguid,
	f.originlguid,
	f.year as yearissued,
	(select objid from faas_task where refid = f.objid and enddate is null) as taskid,
	(select state from faas_task where refid = f.objid and enddate is null) as taskstate,
	(select assignee_objid from faas_task where refid = f.objid and enddate is null) as assignee_objid
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	left join propertyclassification pc on r.classification_objid = pc.objid 
where f.objid = $P{objid}	


[updateFaasList]
update faas_list fl, faas f, rpu r, realproperty rp, propertyclassification pc set 
	fl.realpropertyid = f.realpropertyid,
	fl.state = f.state,
	fl.datacapture = f.datacapture,
	fl.tdno = f.tdno,
	fl.utdno = f.utdno,
	fl.displaypin = f.fullpin,
	fl.pin = case when r.rputype = 'land' then rp.pin else concat(rp.pin, '-', r.suffix) end,
	fl.prevtdno = f.prevtdno,
	fl.taxpayer_objid = f.taxpayer_objid,
	fl.owner_name = f.owner_name,
	fl.owner_address = f.owner_address,
	fl.administrator_name = f.administrator_name,
	fl.administrator_address = f.administrator_address,
	fl.classification_objid = r.classification_objid,
	fl.classcode = pc.code,
	fl.cadastrallotno = rp.cadastrallotno,
	fl.blockno = rp.blockno,
	fl.surveyno = rp.surveyno,
	fl.titleno = f.titleno,
	fl.totalareaha = r.totalareaha,
	fl.totalareasqm = r.totalareasqm,
	fl.totalmv = r.totalmv,
	fl.totalav = r.totalav,
	fl.effectivityyear = f.effectivityyear,
	fl.effectivityqtr = f.effectivityqtr,
	fl.cancelreason = f.cancelreason,
	fl.cancelledbytdnos = f.cancelledbytdnos,
	fl.yearissued = f.year,
	fl.taskid = (select objid from faas_task where refid = f.objid and enddate is null limit 1),
	fl.taskstate = (select state from faas_task where refid = f.objid and enddate is null limit 1),
	fl.assignee_objid = (select assignee_objid from faas_task where refid = f.objid and enddate is null limit 1)
where fl.objid = $P{objid}	
 	and fl.objid = f.objid 
	and f.rpuid = r.objid 
	and f.realpropertyid = rp.objid 
	and (r.classification_objid = pc.objid or r.classification_objid is null)



[deleteFaasList]
delete from faas_list where objid = $P{objid}


[findById]
select * from faas_list where objid  = $P{objid}


[updateTaskId]
update faas_list set taskid = $P{objid} where objid = $P{refid}
	