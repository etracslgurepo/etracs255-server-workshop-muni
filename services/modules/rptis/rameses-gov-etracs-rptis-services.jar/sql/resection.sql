[getItems]
select f.objid, r.rputype, rp.pintype, rp.pin, rp.claimno, r.suffix  
from faas f 
inner join rpu r on f.rpuid = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.state = 'CURRENT' 
and rp.barangayid = $P{barangayid}
and rp.section = $P{section}


[deleteFaasTasks]
delete from faas_task 
where refid in (
	select newfaas_objid 
	from resection_item 
	where parent_objid = $P{objid}
)

[insertFaasSignatories]
INSERT INTO faas_task 
     (objid, refid, parentprocessid, state, startdate, enddate, 
      assignee_objid, assignee_name, assignee_title, 
      actor_objid, actor_name, actor_title, message, signature) 
select
    concat(rt.objid, f.utdno) as objid, 
    ri.newfaas_objid, 
    rt.parentprocessid, 
    rt.state, 
    rt.startdate, 
    rt.enddate, 
    rt.assignee_objid, 
    rt.assignee_name, 
    rt.assignee_title, 
    rt.actor_objid, 
    rt.actor_name, 
    rt.actor_title, 
    rt.message, 
    rt.signature
from resection r
    inner join resection_item ri on r.objid = ri.parent_objid
	inner join faas f on ri.newfaas_objid = f.objid 
    inner join resection_task rt on r.objid = rt.refid 
where r.objid = $P{objid}
  and rt.state not like 'assign%'
  and not exists(select * from faas_task where objid = concat(rt.objid, f.utdno))


[findPendingFaasesCount]
select count(*) as icount 
from resection_item ri 
	inner join faas f on ri.newfaas_objid = f.objid 
where ri.parent_objid = $P{objid}
and f.state = 'PENDING'


[findFaasInfo]
select 
  f.*,
  rp.barangayid as rp_barangay_objid,
  rp.ry as rpu_ry 
from faas f 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.objid = $P{objid}