[getList]
SELECT 
	rq.*,
	rqt.name AS requirementtype_name 
FROM rpt_requirement rq
	INNER JOIN rpt_requirement_type rqt ON rq.requirementtypeid = rqt.objid 
WHERE rqt.name LIKE $P{searchtext} OR rq.value_txnno LIKE $P{searchtext}	
ORDER BY rqt.sortorder, rqt.name  


[deleteRequirements]
DELETE FROM rpt_requirement WHERE refid = $P{refid}

[getRequirements]
SELECT 
	rq.*,
	rqt.name AS requirementtype_name 
FROM rpt_requirement rq
	INNER JOIN rpt_requirement_type rqt ON rq.requirementtypeid = rqt.objid 
WHERE rq.refid = $P{refid}
ORDER BY rqt.sortorder, rqt.name  


[getUncompliedRequirements]
SELECT rq.*
FROM rpt_requirement rq
WHERE rq.refid = $P{refid} 
  AND complied = 0


[findRequirementByType]
SELECT 
	r.*,
	rt.name AS requirementtype_name 
FROM rpt_requirement r
	INNER JOIN rpt_requirement_type rt ON r.requirementtypeid = rt.objid 
where r.refid = $P{refid}
 and r.requirementtypeid = $P{typeid}


[findFaasInfo]
select 
	f.tdno, f.fullpin, 
	f.txntype_objid, ft.displaycode as txntype_displaycode, 
	f.owner_name, f.owner_address 
from faas f
	inner join faas_txntype ft on f.txntype_objid = ft.objid 
where f.objid = $P{objid}


[findSubdivisionInfo]
select 
	mf.tdno, mf.fullpin, 
	'SD' as txntype_objid, 'SD' as txntype_displaycode, 
	mf.owner_name, mf.owner_address 
from subdivision s 
	inner join subdivision_motherland m on s.objid = m.subdivisionid 
	inner join faas mf on m.landfaasid = mf.objid 
where s.objid = $P{objid}


[findConsolidationInfo]
select 
	f.tdno, f.fullpin, 
	'CS' as txntype_objid, 'CS' as txntype_displaycode, 
	f.owner_name, f.owner_address 
from consolidation c
	inner join faas f on c.newfaasid = f.objid 
where c.objid = $P{objid}