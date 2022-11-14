[getLandDetails]
SELECT ld.*,
	sub.code AS subclass_code,
	sub.name AS subclass_name,
	sub.unitvalue AS subclass_unitvalue,
	lspc.code AS specificclass_code,
	lspc.name AS specificclass_name,
	spc.areatype AS specificclass_areatype,
	cls.objid AS specificclass_classification_objid,
	cls.code AS specificclass_classification_code,
	cls.name AS specificclass_classification_name,
	lspc.code AS landspecificclass_code,
	lspc.name AS landspecificclass_name,
	lal.code AS actualuse_code,
	lal.name AS actualuse_name,
	lal.fixrate AS actualuse_fixrate,
	lal.rate AS actualuse_rate,
	pc.objid AS actualuse_classification_objid,
	pc.code AS actualuse_classification_code,
	pc.name AS actualuse_classification_name,
	st.striplevel AS stripping_striplevel,
	st.rate AS stripping_rate
FROM landdetail ld
	LEFT JOIN lcuvsubclass sub ON ld.subclass_objid = sub.objid
	LEFT JOIN lcuvspecificclass spc ON ld.specificclass_objid = spc.objid 
	LEFT JOIN landspecificclass lspc ON ld.landspecificclass_objid = lspc.objid 
	LEFT JOIN propertyclassification cls ON spc.classification_objid = cls.objid 
	LEFT JOIN landassesslevel lal ON ld.actualuse_objid = lal.objid 
	LEFT JOIN propertyclassification pc ON lal.classification_objid = pc.objid 
	LEFT JOIN lcuvstripping st ON ld.stripping_objid = st.objid 
WHERE ld.landrpuid = $P{landrpuid}
ORDER BY ld.objid DESC, sub.code, st.striplevel 


[getAssessments]
SELECT 
  ba.*,
  bal.code AS  actualuse_code,
  bal.name AS actualuse_name,
  pc.code AS classification_code, 
  pc.name AS classification_name
FROM rpu_assessment ba
  INNER JOIN landassesslevel bal ON ba.actualuse_objid = bal.objid 
  INNER JOIN propertyclassification pc ON ba.classification_objid = pc.objid 
WHERE ba.rpuid = $P{objid}

UNION ALL

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




[getLandAdjustments]
SELECT la.*,
	lat.code AS adjustmenttype_code,
	lat.name AS adjustmenttype_name,
	lat.expr AS adjustmenttype_expr
FROM landadjustment la
	INNER JOIN landadjustmenttype lat ON la.adjustmenttype_objid = lat.objid 
WHERE la.landrpuid = $P{landrpuid}
  AND la.type = $P{type}
ORDER BY lat.idx    


[getLandDetailAdjustments]
SELECT la.*,
	lat.code AS adjustmenttype_code,
	lat.name AS adjustmenttype_name,
	lat.expr AS adjustmenttype_expr
FROM landadjustment la
	INNER JOIN landadjustmenttype lat ON la.adjustmenttype_objid = lat.objid 
WHERE la.landdetailid = $P{landdetailid}
  AND la.type = $P{type}

[getAdjustmentParameters]  
SELECT lp.*, 
	rp.name AS param_name, rp.paramtype AS param_paramtype,
	rp.caption AS param_caption
FROM landadjustmentparameter lp 
	INNER JOIN rptparameter rp ON lp.param_objid = rp.objid 
WHERE lp.landadjustmentid = $P{objid}




[getPlantTrees]  
SELECT 
	ptd.*,
	puv.code AS planttreeunitvalue_code,
	puv.name AS planttreeunitvalue_name,
	puv.unitvalue AS planttreeunitvalue_unitvalue,
	pt.code AS planttree_code,
	pt.name AS planttree_name,
	al.code AS actualuse_code,
	al.name AS actualuse_name,
	al.rate AS actualuse_rate,
	pc.objid AS actualuse_classification_objid,
	pc.code AS actualuse_classification_code,
	pc.name AS actualuse_classification_name
FROM planttreedetail ptd
	INNER JOIN planttreeunitvalue puv ON ptd.planttreeunitvalue_objid = puv.objid 
	INNER JOIN planttree pt ON ptd.planttree_objid = pt.objid 
	INNER JOIN planttreeassesslevel al ON ptd.actualuse_objid = al.objid 
	INNER JOIN propertyclassification pc ON al.classification_objid = pc.objid 
WHERE ptd.landrpuid	= $P{landrpuid} 
ORDER BY ptd.objid DESC 



[findAssessLevelRange]
SELECT r.rate
FROM landassesslevelrange r
  INNER JOIN landrysetting s ON r.landrysettingid = s.objid 
WHERE s.ry = $P{ry}
  AND r.landassesslevelid = $P{landassesslevelid}
  AND $P{marketvalue} >= r.mvfrom 
  AND ( $P{marketvalue} < r.mvto OR r.mvto = 0)


[getAdjustmentApplicationClassifications]  
SELECT pc.*
FROM landadjustmenttype_classification lc
	INNER JOIN propertyclassification pc ON lc.classification_objid = pc.objid 
WHERE lc.landadjustmenttypeid = $P{objid}


[findLandRpuByRealPropertyId]
SELECT r.* 
FROM faas f 
	inner join rpu r on f.rpuid = r.objid 
WHERE f.realpropertyid = $P{realpropertyid} 
  AND r.rputype = 'land' 
  AND f.state <> 'CANCELLED'



[getLatestRevisedLandFaas]
SELECT rp.*
FROM realproperty rp
	INNER JOIN rpu rpu ON rp.objid = rpu.realpropertyid
	INNER JOIN faas f ON rpu.objid = f.rpuid 
WHERE rp.ry = $P{ry} 
  AND rp.pin = $P{pin}
  AND rp.claimno 
  AND rp.state <> 'CANCELLED' 


[deleteLandAdjustments]
delete from landadjustment where landrpuid = $P{objid}
	
[deleteAdjustmentParameters]
DELETE FROM landadjustmentparameter WHERE landadjustmentid = $P{objid}

[deleteAdjustmentParametersByRpu]
DELETE FROM landadjustmentparameter WHERE landrpuid = $P{landrpuid} 


[findLandActualUseInfo]
select objid, name, code 
from landassesslevel 
where objid = $P{objid}

 
[findPlantTreeActualUseInfo]
select objid, name, code 
from planttreeassesslevel 
where objid = $P{objid}

[getAppliedTo]
select classification_objid 
from landadjustmenttype_classification 
where landadjustmenttypeid = $P{objid}

[findClassification]
select objid, name from propertyclassification where objid = $P{objid}