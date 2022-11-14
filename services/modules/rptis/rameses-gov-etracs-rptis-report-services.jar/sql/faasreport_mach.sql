[findMachInfoById]
select mr.*
from machrpu mr 
where mr.objid = $P{objid}	


[findBldgInfoByPin]
select 
	f.owner_name as bldgownername,
	f.fullpin as bldgpin
from faas f 
  inner join rpu r on f.rpuid = r.objid 
  inner join propertyclassification pc on r.classification_objid = pc.objid 
where r.rpumasterid = $P{objid}
and f.state <> 'CANCELLED'


[getMachDetails]
select
	m.name as machinename,
	md.*
from machdetail md 	
	inner join machine m on md.machine_objid = m.objid 
where md.machrpuid = $P{objid}


[getAppraisals]
select 
	md.*,
	m.code as machine_code,
	m.name as machine_name 
from machdetail md 
	inner join machine m on md.machine_objid = m.objid 	
where md.machrpuid = $P{objid}


[getAssessments]
SELECT 
	lal.code as classcode,
	lal.name as classname, 
	lal.code AS actualuse,
	lal.name AS actualusename,
	ra.marketvalue,
	ra.assesslevel / 100 AS assesslevel,
	ra.assesslevel AS assesslevelrate,
	ra.assessedvalue AS assessedvalue,
	ra.taxable,
	case when ra.taxable = '1' then 'T' else 'E' end as taxability
FROM rpu_assessment ra 
	INNER JOIN machassesslevel lal ON ra.actualuse_objid = lal.objid 
WHERE ra.rpuid = $P{objid}	


