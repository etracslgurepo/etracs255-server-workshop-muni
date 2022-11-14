[getAssessLevelById]
SELECT * FROM landassesslevel WHERE objid = $P{objid}

[getRYSetting]
SELECT * FROM planttreerysetting s, rysetting_lgu rl 
WHERE s.objid = rl.objid 
  AND rl.lguid LIKE $P{lguid} 
  AND ry = $P{ry} 

[getLatestRevisedLandFaas] 
SELECT objid, docstate, rputype, txntype, taxpayerid, ry   
FROM faaslist   
WHERE pin = $P{pin}  
  AND rputype = 'land' 
  AND docstate <> 'CANCELLED'  
  AND ry = $P{ry} 
  AND txntype = 'GR'  
  
[getPlantTreeDetails]
SELECT
  pd.*,
  uv.code AS planttreeunitvalue_code,
  uv.name AS planttreeunitvalue_name,
  uv.unitvalue AS planttreeunitvalue_unitvalue,
  au.code AS actualuse_code,
  au.name AS actualuse_name,
  au.rate AS actualuse_rate,
  au.classification_objid as actualuse_classification_objid,
  pt.code AS planttree_code,
  pt.name AS planttree_name
FROM planttreedetail pd
  INNER JOIN planttreeunitvalue uv ON pd.planttreeunitvalue_objid = uv.objid 
  INNER JOIN planttreeassesslevel au ON pd.actualuse_objid = au.objid 
  INNER JOIN planttree pt ON pd.planttree_objid = pt.objid 
WHERE pd.planttreerpuid = $P{objid} 


[findActualUseInfo]
select objid, name, code 
from planttreeassesslevel 
where objid = $P{objid}


[getAssessments]
SELECT 
  ba.*,
  bal.code AS  actualuse_code,
  bal.name AS actualuse_name,
  pc.code AS classification_code, 
  pc.name AS classification_name
FROM rpu_assessment ba
  INNER JOIN planttreeassesslevel bal ON ba.actualuse_objid = bal.objid 
  INNER JOIN propertyclassification pc ON ba.classification_objid = pc.objid 
WHERE ba.rpuid = $P{objid}


[findFaasByRpu]
select objid, rpuid, realpropertyid 
from faas 
where rpuid = $P{objid}
and state <> 'CANCELLED'
order by state DESC 

[findLandFaasByRealProperty]
select f.objid, f.rpuid, f.realpropertyid 
from faas f 
inner join rpu r on f.rpuid = r.objid 
where f.realpropertyid = $P{realpropertyid}
and f.state <> 'CANCELLED'
and r.rputype = 'land';


[findRpu]
select * from planttreerpu where objid = $P{rpuid}