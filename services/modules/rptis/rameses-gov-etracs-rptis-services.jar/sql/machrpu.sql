[getMachUses]
SELECT 
  mu.*,
  mal.code AS actualuse_code,
  mal.name AS actualuse_name,
  mal.fixrate AS actualuse_fixrate,
  mal.rate AS actualuse_rate
FROM machuse mu
  INNER JOIN machassesslevel mal ON mu.actualuse_objid = mal.objid 
WHERE mu.machrpuid = $P{machrpuid}  


[getMachDetails]
SELECT
  md.*,
  m.code AS machine_code,
  m.name AS machine_name 
FROM machdetail md
  INNER JOIN machine m ON md.machine_objid = m.objid 
WHERE md.machuseid = $P{machuseid}  


[getAssessments]
SELECT 
  ba.*,
  bal.code AS  actualuse_code,
  bal.name AS actualuse_name,
  pc.code AS classification_code, 
  pc.name AS classification_name
FROM rpu_assessment ba
  INNER JOIN machassesslevel bal ON ba.actualuse_objid = bal.objid 
  INNER JOIN propertyclassification pc ON ba.classification_objid = pc.objid 
WHERE ba.rpuid = $P{objid}


[deleteAllMachDetails]
DELETE FROM machdetail WHERE machrpuid = $P{objid}


[deleteAllMachUses]
DELETE FROM machuse WHERE machrpuid = $P{objid}


[findMachRySetting]
SELECT * FROM machrysetting WHERE ry = $P{ry}

[findActualUseInfo]
select * from machassesslevel where objid = $P{objid}

[findBldgMaster]
select 
  r.rpumasterid as objid,
  f.state, f.tdno, f.owner_name, f.fullpin,
  pc.code as classification_code,
  r.rputype, r.totalmv, r.totalav
from faas f 
  inner join rpu r on f.rpuid = r.objid 
  inner join propertyclassification pc on r.classification_objid = pc.objid 
where r.rpumasterid = $P{objid}
and f.state <> 'CANCELLED'