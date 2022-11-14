[getNodes]
select n.name, n.title as caption
from sys_wf_node n
where n.processname = 'batchgr'
and n.name not like 'assign%'
and n.name not in ('start', 'provapprover')
and n.name not like 'for%'
and exists(select * from sys_wf_transition where processname='batchgr' and parentid = n.name)
order by n.idx


[getList]
SELECT 
	bgr.*,
	(select trackingno from rpttracking where objid = bgr.objid) as trackingno,
	tsk.objid AS taskid,
	tsk.state AS taskstate,
	tsk.assignee_objid,
  b.name as barangay_name,
  b.pin as barangay_pin,
  o.name as lgu_name,
  pc.name as classification_name
FROM batchgr bgr
  INNER JOIN barangay b on bgr.barangay_objid = b.objid 
  INNER JOIN sys_org o on bgr.lgu_objid = o.objid 
  LEFT JOIN propertyclassification pc on bgr.classification_objid = pc.objid 
	LEFT JOIN batchgr_task tsk ON bgr.objid = tsk.refid AND tsk.enddate IS NULL
WHERE bgr.lgu_objid LIKE $P{lguid} 
  and bgr.barangay_objid like $P{barangayid}
   and bgr.state LIKE $P{state}
   and bgr.objid in (
   		select objid from batchgr where txnno LIKE $P{searchtext}
   		union
   		select objid from batchgr where section LIKE $P{searchtext}
   	)
   ${filters}
order by bgr.txnno desc 	


[insertItems]
insert into batchgr_item(
  objid,
  parent_objid,
  state,
  rputype,
  tdno,
  fullpin,
  pin,
  suffix
)
select 
  f.objid,
  $P{objid} as parentid,
  'FORREVISION' as state,
  r.rputype,
  f.tdno,
  f.fullpin,
  rp.pin,
  r.suffix
from faas f 
    inner join rpu r on f.rpuid = r.objid 
    inner join realproperty rp on f.realpropertyid = rp.objid
    inner join propertyclassification pc on r.classification_objid = pc.objid 
    inner join barangay b on rp.barangayid = b.objid 
where rp.barangayid = $P{barangayid}
  and r.ry < $P{ry}
  and r.ry = $P{prevry}
  and f.state = 'CURRENT'
  and r.rputype like $P{rputype}
  and r.classification_objid like $P{classificationid}
  and rp.section like $P{section}
  and not exists(select * from batchgr_item where objid = f.objid)


[findCounts]
select 
  sum(1) as count,
  sum(case when rputype = 'land' then 1 else 0 end) as land,
  sum(case when rputype <> 'land' then 1 else 0 end) as improvement,
  sum(case when state = 'REVISED' then 1 else 0 end) as revised,
  sum(case when state = 'CURRENT' then 1 else 0 end) as currentcnt,
  sum(case when state = 'ERROR' then 1 else 0 end) as error
from batchgr_item 
where parent_objid = $P{objid}
and pin like $P{pin}
and rputype like $P{rputype}
and state like $P{state}


[getFaasListing]
SELECT 
  f.objid, 
  CASE WHEN f.tdno IS NULL THEN f.utdno ELSE f.tdno END AS tdno, 
  r.rputype,
  r.fullpin 
FROM batchgr_item bi
  INNER JOIN faas f ON bi.newfaasid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE bi.parent_objid = $P{objid}
ORDER BY f.tdno, rp.pin, r.suffix, r.subsuffix



[insertRevisedFaasSignatories]
INSERT INTO faas_task 
     (objid, refid, parentprocessid, state, startdate, enddate, 
      assignee_objid, assignee_name, assignee_title, 
      actor_objid, actor_name, actor_title, message, signature) 
select
    concat(bt.objid, f.utdno) as objid, 
    bi.newfaasid, 
    bt.parentprocessid, 
    bt.state, 
    bt.startdate, 
    bt.enddate, 
    bt.assignee_objid, 
    bt.assignee_name, 
    bt.assignee_title, 
    bt.actor_objid, 
    bt.actor_name, 
    bt.actor_title, 
    bt.message, 
    bt.signature
from batchgr_item bi
  inner join faas f on bi.newfaasid = f.objid 
  inner join batchgr_task bt on bi.parent_objid = bt.refid 
where bi.parent_objid = $P{objid}
  and bt.state not like 'assign%'
  and not exists(select * from batchgr_task where objid = concat(bt.objid, f.utdno))

[insertFaasSignatories]
INSERT INTO faas_task 
     (objid, refid, parentprocessid, state, startdate, enddate, 
      assignee_objid, assignee_name, assignee_title, 
      actor_objid, actor_name, actor_title, message, signature) 
select
    concat(bt.objid, f.utdno) as objid, 
    bi.newfaasid, 
    bt.parentprocessid, 
    bt.state, 
    bt.startdate, 
    bt.enddate, 
    bt.assignee_objid, 
    bt.assignee_name, 
    bt.assignee_title, 
    bt.actor_objid, 
    bt.actor_name, 
    bt.actor_title, 
    bt.message, 
    bt.signature
from batchgr_item bi
  inner join faas f on bi.newfaasid = f.objid 
  inner join batchgr_task bt on bi.parent_objid = bt.refid 
where bi.newfaasid = $P{newfaasid}
  and bt.state not like 'assign%'
  and not exists(select * from batchgr_task where objid = concat(bt.objid, f.utdno))  

[findFaasInfo]
select 
  f.*,
  rp.barangayid as rp_barangay_objid,
  rp.ry as rpu_ry 
from faas f 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.objid = $P{objid}


[findPendingFaasesCount]
select count(*) as icount 
from batchgr_item bi 
  inner join faas f on bi.newfaasid = f.objid 
where bi.parent_objid = $P{objid}
and f.state = 'PENDING'  
