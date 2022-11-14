[findInfoById]
select r.*
from planttreerpu r
where r.objid = $P{objid}	

[getPlantTreeAppraisals]
SELECT
	ptd.areacovered,
	ptd.nonproductiveage,
	pt.name AS planttreename,
	ptuv.name AS subname, 
	ptd.nonproductive,
	ptd.productive,
	ptd.unitvalue,
	ptd.basemarketvalue
FROM planttreedetail ptd 	
	INNER JOIN planttree pt ON ptd.planttree_objid = pt.objid 
	INNER JOIN planttreeunitvalue ptuv  ON ptd.planttreeunitvalue_objid = ptuv.objid 
${filter}	

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
	INNER JOIN planttreeassesslevel lal ON ra.actualuse_objid = lal.objid 
WHERE ra.rpuid = $P{objid}	


[findTotalAdjustment]
SELECT
  	sum(basemarketvalue) as basemarketvalue,
	max(adjustmentrate) as adjustmentrate,
	sum(adjustment) as adjustment,
	sum(marketvalue) as marketvalue
FROM planttreedetail pd
where pd.planttreerpuid = $P{objid}


[getLandAdjustments]
select 
	x.*,
	lat.name as adjtypename
from (
	select 
		la.objid, 
		la.adjustmenttype_objid, 
		max(la.adjustment / la.basemarketvalue) as adjrate
	from landadjustment la 
	where landrpuid = $P{objid}
	group by la.objid, la.adjustmenttype_objid, la.basemarketvalue 
)x 
inner join landadjustmenttype lat on x.adjustmenttype_objid = lat.objid 
order by lat.idx 


[getAdjustmentParameters]  
select 
	lp.param_objid,
	lp.value,
	rp.name AS param_name, rp.paramtype AS param_paramtype,
	rp.caption AS param_caption
FROM landadjustmentparameter lp 
	INNER JOIN rptparameter rp ON lp.param_objid = rp.objid 
WHERE lp.landadjustmentid = $P{objid}