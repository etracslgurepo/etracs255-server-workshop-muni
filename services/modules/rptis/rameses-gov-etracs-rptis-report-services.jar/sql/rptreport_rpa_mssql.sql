[getTaxables]
select 
  x.classid,
  x.classname, 
  x.orderno, 
  SUM(x.rpucount) as rpucount,
  SUM(x.areasqm) as areasqm, 
  SUM(x.areaha) as areaha, 
  SUM(x.landmv) as landmv,
  SUM(x.bldgmv175less) as bldgmv175less,
  SUM(x.bldgmvover175) as bldgmvover175,
  SUM(x.machmv) as machmv,
  SUM(x.othermv) as othermv, 
  SUM(x.totalmv) as totalmv,
  SUM(x.landav) as landav,
  SUM(x.bldgav175less) as bldgav175less,
  SUM(x.bldgavover175) as bldgavover175,
  SUM(x.machav) as machav,
  SUM(x.otherav) as otherav, 
  SUM(x.totalav) as totalav,
  SUM(x.carpav) as carpav,
  SUM(x.litigationav) as litigationav,
  SUM(x.otherrestrictionav) as otherrestrictionav,
  SUM(x.totalrestrictionav) as totalrestrictionav
from (
	SELECT 
		pc.objid AS classid,
		pc.name AS classname, 
		pc.orderno,
		(1) AS rpucount,
		(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareasqm ELSE 0.0 END ) AS areasqm, 
		(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareaha ELSE 0.0 END ) AS areaha, 

		( CASE WHEN r.rputype = 'land' THEN r.totalmv ELSE 0.0 END ) AS landmv,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv <= 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmv175less,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv > 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmvover175,
		( CASE WHEN r.rputype = 'mach' THEN r.totalmv ELSE 0.0 END ) AS machmv,
		( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalmv ELSE 0.0 END ) AS othermv, 
		( r.totalmv ) AS totalmv,
		
		( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landav,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv <= 175000 THEN r.totalav ELSE 0.0 END ) AS bldgav175less,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv > 175000 THEN r.totalav ELSE 0.0 END ) AS bldgavover175,
		( CASE WHEN r.rputype = 'mach' THEN r.totalav ELSE 0.0 END ) AS machav,
		( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalav ELSE 0.0 END ) AS otherav, 
		( r.totalav ) AS totalav,
		
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid = 'CARP' ) THEN r.totalav ELSE 0.0 END ) AS carpav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid = 'UNDER_LITIGATION' ) THEN r.totalav ELSE 0.0 END ) AS litigationav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid  NOT IN ('CARP', 'UNDER_LITIGATION')) THEN r.totalav ELSE 0.0 END ) AS otherrestrictionav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE') THEN r.totalav ELSE 0.0 END ) AS totalrestrictionav

	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	WHERE r.taxable = 1 
	  AND (
			(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
			(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
	  )
	  ${filter}
)x
GROUP BY x.classid, x.classname, x.orderno 
ORDER BY x.orderno 


[getTaxablesMixUse]
select 
  x.classid,
  x.classname, 
  x.orderno, 
  SUM(x.rpucount) as rpucount,
  SUM(x.areasqm) as areasqm, 
  SUM(x.areaha) as areaha, 
  SUM(x.landmv) as landmv,
  SUM(x.bldgmv175less) as bldgmv175less,
  SUM(x.bldgmvover175) as bldgmvover175,
  SUM(x.machmv) as machmv,
  SUM(x.othermv) as othermv, 
  SUM(x.totalmv) as totalmv,
  SUM(x.landav) as landav,
  SUM(x.bldgav175less) as bldgav175less,
  SUM(x.bldgavover175) as bldgavover175,
  SUM(x.machav) as machav,
  SUM(x.otherav) as otherav, 
  SUM(x.totalav) as totalav,
  SUM(x.carpav) as carpav,
  SUM(x.litigationav) as litigationav,
  SUM(x.otherrestrictionav) as otherrestrictionav,
  SUM(x.totalrestrictionav) as totalrestrictionav
from (
	SELECT 
		vra.objid,
		vra.dominantclass_objid,
		vra.actualuse_objid AS classid,
		vra.actualuse_name AS classname, 
		vra.actualuse_orderno AS orderno, 
		(case when vra.dominantclass_objid = vra.actualuse_objid  then 1 else 0 end ) AS rpucount,
		(CASE WHEN vra.rputype = 'land' and rp.claimno is null THEN vra.areasqm ELSE 0.0 END ) AS areasqm, 
		(CASE WHEN vra.rputype = 'land' and rp.claimno is null THEN vra.areaha ELSE 0.0 END ) AS areaha, 

		( CASE WHEN vra.rputype = 'land' THEN vra.marketvalue ELSE 0.0 END ) AS landmv,
		( CASE WHEN vra.rputype = 'bldg' AND vra.marketvalue <= 175000 THEN vra.marketvalue ELSE 0.0 END ) AS bldgmv175less,
		( CASE WHEN vra.rputype = 'bldg' AND vra.marketvalue > 175000 THEN vra.marketvalue ELSE 0.0 END ) AS bldgmvover175,
		( CASE WHEN vra.rputype = 'mach' THEN vra.marketvalue ELSE 0.0 END ) AS machmv,
		( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN vra.marketvalue ELSE 0.0 END ) AS othermv, 
		( vra.marketvalue ) AS totalmv,
		
		( CASE WHEN vra.rputype = 'land' THEN vra.assessedvalue ELSE 0.0 END ) AS landav,
		( CASE WHEN vra.rputype = 'bldg' AND vra.marketvalue <= 175000 THEN vra.assessedvalue ELSE 0.0 END ) AS bldgav175less,
		( CASE WHEN vra.rputype = 'bldg' AND vra.marketvalue > 175000 THEN vra.assessedvalue ELSE 0.0 END ) AS bldgavover175,
		( CASE WHEN vra.rputype = 'mach' THEN vra.assessedvalue ELSE 0.0 END ) AS machav,
		( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN vra.assessedvalue ELSE 0.0 END ) AS otherav, 
		( vra.assessedvalue ) AS totalav,
		
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid = 'CARP' ) THEN vra.assessedvalue ELSE 0.0 END ) AS carpav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid = 'UNDER_LITIGATION' ) THEN vra.assessedvalue ELSE 0.0 END ) AS litigationav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid  NOT IN ('CARP', 'UNDER_LITIGATION')) THEN vra.assessedvalue ELSE 0.0 END ) AS otherrestrictionav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE') THEN vra.assessedvalue ELSE 0.0 END ) AS totalrestrictionav

	FROM faas f
		INNER JOIN realproperty rp on f.realpropertyid = rp.objid 
		INNER JOIN vw_rpu_assessment vra ON f.rpuid = vra.objid 
	WHERE vra.taxable = 1 
	  AND (
			(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
			(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
	  )
	  ${filter}
)x
GROUP BY x.classid, x.classname, x.orderno 
ORDER BY x.orderno 


[getExempts]
select
  x.classid,
  x.classname, 
  x.orderno,
  SUM(x.rpucount) as rpucount,
  SUM(x.areasqm) as areasqm, 
  SUM(x.areaha) as areaha, 
  SUM(x.landmv) as landmv,
  SUM(x.bldgmv175less) as bldgmv175less,
  SUM(x.bldgmvover175) as bldgmvover175,
  SUM(x.machmv) as machmv,
  SUM(x.othermv) as othermv, 
  SUM(x.totalmv) as totalmv,
  SUM(x.landav) as landav,
  SUM(x.bldgav175less) as bldgav175less,
  SUM(x.bldgavover175) as bldgavover175,
  SUM(x.machav) as machav,
  SUM(x.otherav) as otherav, 
  SUM(x.totalav) as totalav,
  SUM(x.carpav) as carpav,
  SUM(x.litigationav) as litigationav,
  SUM(x.otherrestrictionav) as otherrestrictionav,
  SUM(x.totalrestrictionav) as totalrestrictionav
from (
	SELECT 
		e.objid AS classid,
		e.name AS classname, 
		e.orderno, 
		(1) AS rpucount,
		(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareasqm ELSE 0.0 END ) AS areasqm, 
		(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareaha ELSE 0.0 END ) AS areaha, 

		( CASE WHEN r.rputype = 'land' THEN r.totalmv ELSE 0.0 END ) AS landmv,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv <= 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmv175less,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv > 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmvover175,
		( CASE WHEN r.rputype = 'mach' THEN r.totalmv ELSE 0.0 END ) AS machmv,
		( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalmv ELSE 0.0 END ) AS othermv, 
		( r.totalmv ) AS totalmv,
		
		( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landav,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv <= 175000 THEN r.totalav ELSE 0.0 END ) AS bldgav175less,
		( CASE WHEN r.rputype = 'bldg' AND r.totalmv > 175000 THEN r.totalav ELSE 0.0 END ) AS bldgavover175,
		( CASE WHEN r.rputype = 'mach' THEN r.totalav ELSE 0.0 END ) AS machav,
		( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalav ELSE 0.0 END ) AS otherav, 
		( r.totalav ) AS totalav,
		
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid = 'CARP' ) THEN r.totalav ELSE 0.0 END ) AS carpav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid = 'UNDER_LITIGATION' ) THEN r.totalav ELSE 0.0 END ) AS litigationav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE' and restrictiontype_objid  NOT IN ('CARP', 'UNDER_LITIGATION')) THEN r.totalav ELSE 0.0 END ) AS otherrestrictionav,
		( CASE WHEN exists(select * from faas_restriction where parent_objid = f.objid and state = 'ACTIVE') THEN r.totalav ELSE 0.0 END ) AS totalrestrictionav

	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
		INNER JOIN exemptiontype e ON r.exemptiontype_objid = e.objid 
	WHERE r.taxable = 0
	  AND (
			(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
			(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
	  )
	  ${filter}
)x
GROUP BY x.classid, x.classname, x.orderno
ORDER BY x.orderno







[getLiftTaxables]
SELECT 
	pc.objid AS classid,
	pc.name AS classname, 

	SUM(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareasqm ELSE 0.0 END ) AS areasqm, 

	SUM( CASE WHEN r.rputype = 'land' THEN 1 ELSE 0 END ) AS countland,
	SUM( CASE WHEN r.rputype = 'bldg' THEN 1 ELSE 0 END ) AS countbldg,
	SUM( CASE WHEN r.rputype = 'mach' THEN 1 ELSE 0 END ) AS countmach,
	SUM( CASE WHEN r.rputype not in ('land', 'bldg', 'mach') THEN 1 ELSE 0 END ) AS countother,
	SUM( 1 ) AS counttotal,


	SUM( CASE WHEN r.rputype = 'land' THEN r.totalmv ELSE 0.0 END ) AS landmv,
	SUM( CASE WHEN pc.name='RESIDENTIAL' and r.rputype = 'bldg' AND r.totalmv <= 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmv175less,
	SUM( CASE WHEN pc.name='RESIDENTIAL' and r.rputype = 'bldg' AND r.totalmv > 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmvover175,
	SUM( CASE WHEN  pc.name <> 'RESIDENTIAL' and r.rputype = 'bldg' THEN r.totalmv ELSE 0.0 END ) AS bldgmv,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalmv ELSE 0.0 END ) AS machmv,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalmv ELSE 0.0 END ) AS othermv, 
	SUM( r.totalmv ) AS totalmv,
	
	SUM( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landav,
	SUM( CASE WHEN r.rputype = 'bldg' THEN r.totalav ELSE 0.0 END ) AS bldgav,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalav ELSE 0.0 END ) AS machav,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalav ELSE 0.0 END ) AS otherav, 
	SUM( r.totalav ) AS totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
WHERE r.taxable = 1 
  AND (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
  ${filter}
GROUP BY pc.objid, pc.name, pc.orderno
ORDER BY pc.orderno  


[getLiftTaxablesMixUse]
SELECT 
	vra.objid,
	vra.dominantclass_objid,
	vra.actualuse_objid AS classid,
	vra.actualuse_name AS classname, 

	SUM(CASE WHEN vra.rputype = 'land' AND rp.claimno is null THEN vra.areasqm ELSE 0.0 END ) AS areasqm, 

	SUM( CASE WHEN vra.rputype = 'land' AND vra.dominantclass_objid = vra.actualuse_objid  THEN 1 else 0 end)  AS countland,
	SUM( CASE WHEN vra.rputype = 'bldg'  AND vra.dominantclass_objid = vra.actualuse_objid  THEN 1 else 0 end) AS countbldg,
	SUM( CASE WHEN vra.rputype = 'mach'  AND vra.dominantclass_objid = vra.actualuse_objid  THEN 1 else 0 end) AS countmach,
	SUM( CASE WHEN vra.rputype not in ('land', 'bldg', 'mach')  AND vra.dominantclass_objid = vra.actualuse_objid  THEN 1 else 0 end ) AS countother,
	SUM( case when vra.dominantclass_objid = vra.actualuse_objid  THEN 1 else 0 end ) AS counttotal,


	SUM( CASE WHEN vra.rputype = 'land' THEN vra.marketvalue ELSE 0.0 END ) AS landmv,
	SUM( CASE WHEN vra.actualuse_name = 'RESIDENTIAL' AND vra.rputype = 'bldg' AND vra.marketvalue <= 175000 THEN vra.marketvalue ELSE 0.0 END ) AS bldgmv175less,
	SUM( CASE WHEN vra.actualuse_name = 'RESIDENTIAL' AND vra.rputype = 'bldg' AND vra.marketvalue > 175000 THEN vra.marketvalue ELSE 0.0 END ) AS bldgmvover175,
	SUM( CASE WHEN  vra.actualuse_name <> 'RESIDENTIAL' AND vra.rputype = 'bldg' THEN vra.marketvalue ELSE 0.0 END ) AS bldgmv,
	SUM( CASE WHEN vra.rputype = 'mach' THEN vra.marketvalue ELSE 0.0 END ) AS machmv,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN vra.marketvalue ELSE 0.0 END ) AS othermv, 
	SUM( vra.marketvalue ) AS totalmv,
	
	SUM( CASE WHEN vra.rputype = 'land' THEN vra.assessedvalue ELSE 0.0 END ) AS landav,
	SUM( CASE WHEN vra.rputype = 'bldg' THEN vra.assessedvalue ELSE 0.0 END ) AS bldgav,
	SUM( CASE WHEN vra.rputype = 'mach' THEN vra.assessedvalue ELSE 0.0 END ) AS machav,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN vra.assessedvalue ELSE 0.0 END ) AS otherav, 
	SUM( vra.assessedvalue ) AS totalav
FROM faas f
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN vw_rpu_assessment vra ON f.rpuid = vra.objid 
WHERE vra.taxable = 1 
  AND (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
  ${filter}
GROUP BY vra.objid, vra.dominantclass_objid, vra.actualuse_objid, vra.actualuse_name, vra.actualuse_orderno
ORDER BY vra.actualuse_orderno  



[getLiftExempts]
SELECT 
	e.objid AS classid,
	e.name AS classname, 
	SUM(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareasqm ELSE 0.0 END ) AS areasqm, 

	SUM( CASE WHEN r.rputype = 'land' THEN 1 ELSE 0 END ) AS countland,
	SUM( CASE WHEN r.rputype = 'bldg' THEN 1 ELSE 0 END ) AS countbldg,
	SUM( CASE WHEN r.rputype = 'mach' THEN 1 ELSE 0 END ) AS countmach,
	SUM( CASE WHEN r.rputype not in ('land', 'bldg', 'mach') THEN 1 ELSE 0 END ) AS countother,
	SUM( 1 ) AS counttotal,


	SUM( CASE WHEN r.rputype = 'land' THEN r.totalmv ELSE 0.0 END ) AS landmv,
	SUM( 0 ) AS bldgmv175less,
	SUM( 0 ) AS bldgmvover175,
	SUM( case when r.rputype = 'bldg' THEN r.totalmv ELSE 0.0 END ) AS bldgmv,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalmv ELSE 0.0 END ) AS machmv,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalmv ELSE 0.0 END ) AS othermv, 
	SUM( r.totalmv ) AS totalmv,
	
	SUM( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landav,
	SUM( CASE WHEN r.rputype = 'bldg' THEN r.totalav ELSE 0.0 END ) AS bldgav,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalav ELSE 0.0 END ) AS machav,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalav ELSE 0.0 END ) AS otherav, 
	SUM( r.totalav ) AS totalav

FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc on r.classification_objid = pc.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN exemptiontype e ON r.exemptiontype_objid = e.objid 
WHERE r.taxable = 0
  AND (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
  ${filter}
GROUP BY e.objid, e.name, e.orderno 
ORDER BY e.orderno  




[getLiftIdleLandTaxables]
SELECT 
	pc.objid AS classid,
	pc.name AS classname, 

	SUM(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareasqm ELSE 0.0 END ) AS areasqm, 

	SUM( CASE WHEN r.rputype = 'land' THEN 1 ELSE 0 END ) AS countland,
	SUM( CASE WHEN r.rputype = 'bldg' THEN 1 ELSE 0 END ) AS countbldg,
	SUM( CASE WHEN r.rputype = 'mach' THEN 1 ELSE 0 END ) AS countmach,
	SUM( CASE WHEN r.rputype not in ('land', 'bldg', 'mach') THEN 1 ELSE 0 END ) AS countother,
	SUM( 1 ) AS counttotal,


	SUM( CASE WHEN r.rputype = 'land' THEN r.totalmv ELSE 0.0 END ) AS landmv,
	SUM( CASE WHEN pc.name='RESIDENTIAL' and r.rputype = 'bldg' AND r.totalmv <= 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmv175less,
	SUM( CASE WHEN pc.name='RESIDENTIAL' and r.rputype = 'bldg' AND r.totalmv > 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmvover175,
	SUM( CASE WHEN  pc.name <> 'RESIDENTIAL' and r.rputype = 'bldg' THEN r.totalmv ELSE 0.0 END ) AS bldgmv,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalmv ELSE 0.0 END ) AS machmv,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalmv ELSE 0.0 END ) AS othermv, 
	SUM( r.totalmv ) AS totalmv,
	
	SUM( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landav,
	SUM( CASE WHEN r.rputype = 'bldg' THEN r.totalav ELSE 0.0 END ) AS bldgav,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalav ELSE 0.0 END ) AS machav,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalav ELSE 0.0 END ) AS otherav, 
	SUM( r.totalav ) AS totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN landrpu lr ON f.rpuid = lr.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
WHERE r.taxable = 1 and lr.idleland = 1 
  AND (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
  ${filter}
GROUP BY pc.objid, pc.name, pc.orderno
ORDER BY pc.orderno  


[getLiftIdleLandExempts]
SELECT 
	e.objid AS classid,
	e.name AS classname, 
	SUM(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareasqm ELSE 0.0 END ) AS areasqm, 

	SUM( CASE WHEN r.rputype = 'land' THEN 1 ELSE 0 END ) AS countland,
	SUM( CASE WHEN r.rputype = 'bldg' THEN 1 ELSE 0 END ) AS countbldg,
	SUM( CASE WHEN r.rputype = 'mach' THEN 1 ELSE 0 END ) AS countmach,
	SUM( CASE WHEN r.rputype not in ('land', 'bldg', 'mach') THEN 1 ELSE 0 END ) AS countother,
	SUM( 1 ) AS counttotal,


	SUM( CASE WHEN r.rputype = 'land' THEN r.totalmv ELSE 0.0 END ) AS landmv,
	SUM( 0 ) AS bldgmv175less,
	SUM( 0) AS bldgmvover175,
	SUM( CASE WHEN  r.rputype = 'bldg' THEN r.totalmv ELSE 0.0 END ) AS bldgmv,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalmv ELSE 0.0 END ) AS machmv,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalmv ELSE 0.0 END ) AS othermv, 
	SUM( r.totalmv ) AS totalmv,
	
	SUM( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landav,
	SUM( CASE WHEN r.rputype = 'bldg' THEN r.totalav ELSE 0.0 END ) AS bldgav,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalav ELSE 0.0 END ) AS machav,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalav ELSE 0.0 END ) AS otherav, 
	SUM( r.totalav ) AS totalav

FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN landrpu lr ON f.rpuid = lr.objid 
	INNER JOIN propertyclassification pc on r.classification_objid = pc.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN exemptiontype e ON r.exemptiontype_objid = e.objid 
WHERE r.taxable = 0 and lr.idleland = 1 
  AND (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
  ${filter}
GROUP BY e.objid, e.name, e.orderno 
ORDER BY e.orderno  




[getLiftRestrictions]
SELECT 
	frt.name AS restriction, 
	frt.idx, 

	pc.objid AS classid,
	pc.name AS classname, 
	pc.orderno,


	SUM(CASE WHEN r.rputype = 'land' and rp.claimno is null THEN r.totalareasqm ELSE 0.0 END ) AS areasqm, 

	SUM( CASE WHEN r.rputype = 'land' THEN 1 ELSE 0 END ) AS countland,
	SUM( CASE WHEN r.rputype = 'bldg' THEN 1 ELSE 0 END ) AS countbldg,
	SUM( CASE WHEN r.rputype = 'mach' THEN 1 ELSE 0 END ) AS countmach,
	SUM( CASE WHEN r.rputype not in ('land', 'bldg', 'mach') THEN 1 ELSE 0 END ) AS countother,
	SUM( 1 ) AS counttotal,


	SUM( CASE WHEN r.rputype = 'land' THEN r.totalmv ELSE 0.0 END ) AS landmv,
	SUM( CASE WHEN pc.name='RESIDENTIAL' and r.rputype = 'bldg' AND r.totalmv <= 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmv175less,
	SUM( CASE WHEN pc.name='RESIDENTIAL' and r.rputype = 'bldg' AND r.totalmv > 175000 THEN r.totalmv ELSE 0.0 END ) AS bldgmvover175,
	SUM( CASE WHEN  pc.name <> 'RESIDENTIAL' and r.rputype = 'bldg' THEN r.totalmv ELSE 0.0 END ) AS bldgmv,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalmv ELSE 0.0 END ) AS machmv,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalmv ELSE 0.0 END ) AS othermv, 
	SUM( r.totalmv ) AS totalmv,
	
	SUM( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landav,
	SUM( CASE WHEN r.rputype = 'bldg' THEN r.totalav ELSE 0.0 END ) AS bldgav,
	SUM( CASE WHEN r.rputype = 'mach' THEN r.totalav ELSE 0.0 END ) AS machav,
	SUM( CASE WHEN rputype NOT IN( 'land', 'bldg', 'mach') THEN r.totalav ELSE 0.0 END ) AS otherav, 
	SUM( r.totalav ) AS totalav
FROM faas_restriction fr 
	inner join faas_restriction_type frt on fr.restrictiontype_objid = frt.objid 
	inner join faas f on fr.parent_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
WHERE (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.dtapproved < $P{enddate} AND f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
  and fr.state = 'ACTIVE'
  ${filter}
GROUP BY frt.name, frt.idx, pc.objid, pc.name, pc.orderno 
ORDER BY frt.idx, pc.orderno 