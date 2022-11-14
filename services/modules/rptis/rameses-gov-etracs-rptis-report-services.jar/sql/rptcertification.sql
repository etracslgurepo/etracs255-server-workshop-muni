[getList]
SELECT * 
FROM rptcertification
where 1=1 ${filters}
ORDER BY txndate DESC


[getItemsTest]
SELECT 
	$P{objid} as rptcertificationid,
	f.objid 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE (f.taxpayer_objid	= $P{taxpayerid}
	or exists(select * from entitymember where member_objid = $P{taxpayerid})
  )
  AND r.rputype = 'land'
  ${asoffilter}


[insertLandHoldingItems]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE f.state = 'CURRENT'
AND f.taxpayer_objid IN (${taxpayerids})
AND r.rputype = 'land'


[insertLandHoldingWithImprovementItems]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE f.state = 'CURRENT'
  AND f.taxpayer_objid IN (${taxpayerids})
  AND r.rputype = 'land'
  AND EXISTS( SELECT * 
  			  FROM faas fx
  			  	INNER JOIN rpu rpu ON fx.rpuid = rpu.objid 
  			  WHERE fx.realpropertyid = f.realpropertyid 
  			    AND fx.state = 'CURRENT' 
  			    AND rpu.rputype <> 'land'
  			)


[insertLandHoldingWithNoImprovementItems]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE f.state = 'CURRENT'
  AND f.taxpayer_objid IN (${taxpayerids})
  AND r.rputype = 'land'
  AND NOT EXISTS( SELECT * 
  			  FROM faas fx 
  			  	INNER JOIN rpu rpu ON fx.rpuid = rpu.objid 
  			  WHERE fx.realpropertyid = f.realpropertyid
  			    AND fx.state = 'CURRENT' 
  			    AND rpu.rputype <> 'land'
  			)

[insertMultipleItems]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE f.state ='CURRENT' 
  AND f.taxpayer_objid IN (${taxpayerids})


[getLandHoldingItems]
SELECT * 
FROM vw_rptcertification_item 
WHERE rptcertificationid = $P{objid}
${orderby}

[getMultipleItems]
SELECT * 
FROM vw_rptcertification_item 
WHERE rptcertificationid = $P{objid}
${orderby}

[getFaasInfo]
SELECT 
	f.objid, f.tdno, f.titleno, f.titledate, f.effectivityyear,
	f.owner_name, f.owner_address, 
	f.administrator_name, f.administrator_address, 
	pc.code AS classcode, 
	pc.name AS classname, 
	r.realpropertyid, r.rputype, r.fullpin, r.totalmv, r.totalav,
	r.totalareasqm, r.totalareaha,
	rp.ry, rp.barangayid, rp.cadastrallotno, rp.blockno, rp.surveyno, rp.street,
	b.name AS barangay_name, so.name as lgu_name, r.taxable,
	po.name as parentlgu_name
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	LEFT JOIN sys_org so on f.lguid = so.objid 
	LEFT JOIN sys_org po on so.parent_objid = po.objid 
WHERE f.objid = $P{faasid}


[getAnnotation]
SELECT objid, txnno
FROM faasannotation
WHERE faasid = $P{faasid} 
  AND STATE = 'APPROVED'


[getProperties]
select x.*
from (
	SELECT objid, tdno FROM faas WHERE taxpayer_objid = $P{taxpayerid} AND state = 'CURRENT'
	union
	SELECT f.objid, f.tdno FROM faas f 
		inner join entitymember m on f.taxpayer_objid = m.entityid 
	WHERE f.state = 'CURRENT' AND m.member_objid = $P{taxpayerid} 
)x
order by x.tdno 



[findImprovementCount]
SELECT 
	COUNT(*) AS improvcount
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp on f.realpropertyid = rp.objid 
WHERE f.state IN ('CURRENT')
  AND f.year <= $P{asofyear}
  AND r.rputype <> 'land'
  AND rp.pin IN (
		select xrp.pin 
    from faas xf 
		inner join realproperty xrp on xf.realpropertyid = xrp.objid 
	  where xf.objid = $P{faasid}
  )


[findBldgLandCount]
SELECT COUNT(*) AS improvcount
FROM bldgrpu_land bl 
	INNER JOIN faas bf ON bl.rpu_objid = bf.rpuid 
WHERE bl.landfaas_objid = $P{faasid}
  AND bf.state NOT IN ('CANCELLED')
  AND bf.year <= $P{asofyear}

[getBldgLands]
SELECT bf.tdno, bf.fullpin 
FROM bldgrpu_land bl 
	INNER JOIN faas bf ON bl.rpu_objid = bf.rpuid 
WHERE bl.landfaas_objid = $P{faasid}
  AND bf.state NOT IN ('CANCELLED')
  AND bf.year <= $P{asofyear}  


[findPlantTreeCount]  
select count(*) as improvcount
from faas f 
inner join planttreedetail ptd on f.rpuid = ptd.landrpuid
where f.objid = $P{faasid}



[getLandItems]
SELECT 
	f.objid as faasid,
	r.objid as rpuid, 
	rp.objid as realpropertyid, 
	f.tdno,
	e.name as taxpayer_name, 
	f.owner_name, 
	f.titleno,	
	f.effectivityyear,
	pc.code AS classcode, 
	pc.name AS classname,
	rp.cadastrallotno,
	so.name AS lguname,
	b.name AS barangay, 
	r.totalareaha AS totalareaha,
	r.totalareasqm AS totalareasqm,
	r.totalav,
	r.totalmv, 
	rp.blockno,
	rp.surveyno,
	rp.street,
	r.rputype,
	r.taxable,
	f.effectivityyear,
	f.effectivityqtr
FROM rptcertificationitem rci 
	INNER JOIN faas f ON rci.refid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN sys_org so ON f.lguid = so.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
WHERE rci.rptcertificationid = $P{objid}
ORDER BY f.tdno 





[insertLandWithNoImprovement]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE f.objid = $P{faasid} 


[insertLandImprovements]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid
FROM faas f 
	INNER JOIN rpu r on f.rpuid = r.objid 
	INNER JOIN realproperty rp on f.realpropertyid = rp.objid 
WHERE r.rputype <> 'land' 
  and f.state ='CURRENT'
  ${asoffilter}
  AND rp.pin IN (
		select xrp.pin 
		from faas xf 
		inner join realproperty xrp on xf.realpropertyid = xrp.objid 
		where xf.objid = $P{faasid}
  )


[insertLandImprovementFromBldgLand]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid 
FROM bldgrpu_land bl 
	INNER JOIN faas f ON bl.rpu_objid = f.rpuid 
WHERE bl.landfaas_objid = $P{faasid}
and f.objid <>  $P{faasid}
  ${asoffilter}




[findFaasById]
SELECT 
	f.tdno,
	f.owner_name,
	b.name AS barangay
FROM faas f 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE f.objid = $P{faasid}



[insertLastAndExistingItems]
INSERT INTO rptcertificationitem (rptcertificationid,refid)
SELECT 
	$P{objid} as rptcertificationid,
	f.objid as refid
FROM faas f 
WHERE f.state = 'CURRENT' 
  and f.taxpayer_objid	= $P{taxpayerid}

union 

SELECT 
	$P{objid} as rptcertificationid,
	f.objid as refid
FROM faas f 
	inner join entitymember m on f.taxpayer_objid = m.entityid 
WHERE f.state = 'CURRENT' 
  and m.member_objid = $P{taxpayerid}


[getLatestAndExistingItems]
SELECT 
	f.tdno,
	f.titleno,	
	e.name as taxpayer_name, 
	f.owner_name, 
	f.administrator_name,
	pc.code AS classcode,
	pc.name AS classname,
	b.name AS barangay, 
	r.totalareaha AS totalareaha,
	r.totalareasqm AS totalareasqm,
	r.totalav,
	r.totalmv, 
	rp.blockno,
	rp.cadastrallotno,
	rp.surveyno,
	rp.street,
	r.objid as rpuid,
	r.rputype,
	r.taxable
FROM rptcertificationitem rci 
	INNER JOIN faas f ON rci.refid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
WHERE rci.rptcertificationid = $P{objid}
ORDER BY r.fullpin


[getBldgTypes]	
select bt.code
from bldgrpu_structuraltype st
	inner join bldgtype bt on st.bldgtype_objid = bt.objid 
where st.bldgrpuid = $P{rpuid}


[getNoPropertyTaxpayers]
select e.name
from rptcertificationitem rci 
	inner join entity e on rci.refid = e.objid 
where rci.rptcertificationid = $P{objid}
order by e.name 


[getBldgInfos]
select bt.name as bldgtype,  bk.name as bldgkind_name 
from bldgrpu_structuraltype st 
	inner join bldgtype bt on st.bldgtype_objid = bt.objid 
	inner join bldgkindbucc bucc on st.bldgkindbucc_objid = bucc.objid 
	inner join bldgkind bk on bucc.bldgkind_objid = bk.objid 
where st.bldgrpuid = $P{rpuid}


[getMachInfos]
select m.name as machine_name
from machdetail md 
	inner join machine m on md.machine_objid = m.objid 
where md.machrpuid = $P{rpuid}


[getPlantTreeInfos]
select pt.name as planttree_name 
from planttreedetail ptd 
	inner join planttree pt on ptd.planttree_objid = pt.objid 
where ptd.planttreerpuid = $P{rpuid}


[getMiscInfos]
select mi.name as miscitem_name 
from miscrpuitem mri 
	inner join miscitem mi on mri.miscitem_objid = mi.objid 
where mri.miscrpuid = $P{rpuid}


[getLandDetails]
select * from vw_certification_landdetail where faasid = $P{faasid} order by specificclass_name

[getLandImprovements]
select * from vw_certification_land_improvement where faasid = $P{faasid} order by improvement



[deleteItems]
delete from rptcertificationitem where rptcertificationid = $P{objid}