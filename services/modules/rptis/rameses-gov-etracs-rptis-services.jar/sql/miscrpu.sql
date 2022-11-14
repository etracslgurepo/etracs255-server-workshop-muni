[getMiscRpuItems]
SELECT
  mri.*,
  miv.expr AS miv_expr,
  mi.code AS miscitem_code,
  mi.name AS miscitem_name
FROM miscrpuitem mri
  INNER JOIN miscitemvalue miv ON mri.miv_objid = miv.objid 
  INNER JOIN miscitem mi ON mri.miscitem_objid = mi.objid 
WHERE mri.miscrpuid = $P{objid} 


[getMiscRpuItemParams]
SELECT
  mr.*,
  p.name AS param_name,
  p.caption AS param_caption,
  p.paramtype AS param_type,
  p.maxvalue AS param_maxvalue,
  p.minvalue AS param_minvalue
FROM miscrpuitem_rptparameter mr
  INNER JOIN rptparameter p ON mr.param_objid = p.objid
WHERE mr.miscrpuitemid = $P{miscrpuitemid}

[getAssessments]
SELECT 
  ba.*,
  bal.code AS  actualuse_code,
  bal.name AS actualuse_name,
  pc.code AS classification_code, 
  pc.name AS classification_name
FROM rpu_assessment ba
  INNER JOIN miscassesslevel bal ON ba.actualuse_objid = bal.objid 
  INNER JOIN propertyclassification pc ON ba.classification_objid = pc.objid 
WHERE ba.rpuid = $P{objid}


[deleteAllMiscRpuItems]
DELETE FROM miscrpuitem WHERE miscrpuid = $P{objid}


[deleteAllParams]
DELETE FROM miscrpuitem_rptparameter WHERE miscrpuid =  $P{objid}


[deleteItemParams]
DELETE FROM miscrpuitem_rptparameter WHERE miscrpuitemid = $P{objid}

[findAssessLevelRange]
SELECT r.rate
FROM miscassesslevelrange r
  INNER JOIN miscrysetting s ON r.miscrysettingid = s.objid 
WHERE s.ry = $P{ry}
  AND r.miscassesslevelid = $P{miscassesslevelid}
  AND $P{marketvalue} >= r.mvfrom 
  AND ( $P{marketvalue} < r.mvto OR r.mvto = 0)
