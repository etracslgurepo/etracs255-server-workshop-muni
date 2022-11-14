[findMiscRpuInfo]
select 
	mr.*,
	au.code as actualuse_code,
	au.name as actualuse_name 
from miscrpu mr 
	inner join miscassesslevel au on mr.actualuse_objid = au.objid 
where mr.objid = $P{objid}

[getItems]
SELECT 
	mri.objid,
	mri.expr,
	mri.depreciation,
	mri.depreciatedvalue,
	mri.basemarketvalue,
	mri.marketvalue,
	mri.assesslevel,
	mri.assessedvalue,
  miv.expr AS miv_expr,
  mi.code AS miscitem_code,
  mi.name AS miscitem_name
FROM miscrpuitem mri
  INNER JOIN miscitemvalue miv ON mri.miv_objid = miv.objid 
  INNER JOIN miscitem mi ON mri.miscitem_objid = mi.objid 
WHERE mri.miscrpuid = $P{objid} 


[getItemParams]
SELECT
  mr.*,
  p.name AS param_name,
  p.caption AS param_caption,
  p.paramtype AS param_type,
  p.maxvalue AS param_maxvalue,
  p.minvalue AS param_minvalue
FROM miscrpuitem_rptparameter mr
  INNER JOIN rptparameter p ON mr.param_objid = p.objid
WHERE mr.miscrpuitemid = $P{objid}

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
	INNER JOIN miscassesslevel lal ON ra.actualuse_objid = lal.objid 
WHERE ra.rpuid = $P{objid}	

