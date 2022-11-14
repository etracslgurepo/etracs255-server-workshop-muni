[getPropertiesForBIR]
select
	f.objid, f.state, f.tdno, f.fullpin, 
	r.rputype, r.totalmv, r.totalav
from faas f
	inner join rpu r on f.rpuid = r.objid 
where f.taxpayer_objid = $P{taxpayerid}
  and f.state in ('CURRENT', 'CANCELLED')
  and f.year <= $P{asofyear}
  and r.ry <= $P{ry}
order by f.tdno   


[getLandHoldingBirItems]
SELECT 
	f.objid, f.state, f.tdno, f.fullpin, 
	r.rputype, r.totalmv, r.totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
WHERE f.taxpayer_objid	= $P{taxpayerid}
  AND r.rputype = 'land'
  and f.state in ('CURRENT', 'CANCELLED')
  and f.year <= $P{asofyear}
  and r.ry <= $P{ry}
order by f.tdno 



[getLandHoldingWithImprovementBirItems]
SELECT 
	f.objid, f.state, f.tdno, f.fullpin, 
	r.rputype, r.totalmv, r.totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE f.taxpayer_objid	= $P{taxpayerid}
  AND r.rputype = 'land'
  and f.state in ('CURRENT', 'CANCELLED')
  and f.year <= $P{asofyear}
  and r.ry <= $P{ry}
  AND EXISTS( SELECT * 
  			  FROM faas fx 
  			  	INNER JOIN rpu rx ON fx.rpuid = rx.objid 
  			  WHERE fx.realpropertyid = r.realpropertyid 
  			    AND fx.state in ('CURRENT', 'CANCELLED')
  			    AND rx.rputype <> 'land'
  			    and fx.year <= $P{asofyear}
  				and rx.ry <= $P{ry}
  			)
order by f.tdno   


[getLandHoldingWithNoImprovementBirItems]
SELECT 
	f.objid, f.state, f.tdno, f.fullpin, 
	r.rputype, r.totalmv, r.totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE f.taxpayer_objid	= $P{taxpayerid}
  AND r.rputype = 'land'
  and f.state in ('CURRENT', 'CANCELLED')
  and f.year <= $P{asofyear}
  and r.ry <= $P{ry}
  AND NOT EXISTS( 
  				SELECT * 
				FROM faas fx 
			  inner join rpu  rx on fx.rpuid = rx.objid 
  			  WHERE rx.realpropertyid = f.realpropertyid 
  			    AND fx.state in ('CURRENT', 'CANCELLED')
  			    AND rx.rputype <> 'land'
  			    and fx.year <= $P{asofyear}
  			  	and rx.ry <= $P{ry}
  			)



[findRyForAsOfYear]
select r.ry 
from faas f
	inner join rpu r on f.rpuid = r.objid 
where f.year = $P{asofyear}

[findRyForAsOfYearByFaas]
select r.ry 
from faas f
	inner join rpu r on f.rpuid = r.objid 
where f.objid = $P{faasid} 
and f.year = $P{asofyear}




[createItem]
insert into rptcertificationitem (rptcertificationid,refid)
values ($P{objid}, $P{refid})



[getItems]
SELECT 
	f.tdno,
	e.name as taxpayer_name, 
	f.owner_name, 
	f.titleno,	
	f.rpuid, 
	pc.code AS classcode, 
	pc.name AS classname,
	rp.cadastrallotno,
	CASE WHEN  op.parent_orgclass = 'MUNICIPALITY' THEN op.name ELSE ogp.name END AS lguname,
	b.name AS barangay, 
	r.rputype, 
	r.totalareaha AS totalareaha,
	r.totalareasqm AS totalareasqm,
	r.totalav,
	r.totalmv, 
	rp.surveyno,
	rp.street,
	r.taxable
FROM rptcertificationitem rci 
	INNER JOIN faas f ON rci.refid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN sys_org b ON rp.barangayid = b.objid 
	INNER JOIN sys_org op ON b.parent_objid = op.objid 
	INNER JOIN sys_org ogp ON op.parent_objid = ogp.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
WHERE rci.rptcertificationid = $P{objid}  
ORDER BY r.fullpin


[getBldgTypes]	
select bt.code
from bldgrpu_structuraltype st
	inner join bldgtype bt on st.bldgtype_objid = bt.objid 
where st.bldgrpuid = $P{rpuid}



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

[findPlantTreeCount]  
select count(*) as improvcount
from faas f 
inner join planttreedetail ptd on f.rpuid = ptd.landrpuid
where f.objid = $P{faasid}

[getBldgLands]
SELECT bf.tdno, bf.fullpin 
FROM bldgrpu_land bl 
	INNER JOIN faas bf ON bl.rpu_objid = bf.rpuid 
WHERE bl.landfaas_objid = $P{faasid}
  AND bf.state NOT IN ('CANCELLED')
  AND bf.year <= $P{asofyear}  



[getImprovementBirItems]
SELECT 
	f.objid, f.state, f.tdno, f.fullpin, 
	r.rputype, r.totalmv, r.totalav
FROM faas land
	inner join faas f on land.realpropertyid = f.realpropertyid
	INNER JOIN rpu r ON f.rpuid = r.objid 
WHERE land.objid = $P{faasid}
  AND r.rputype <> 'land'
  and f.state in ('CURRENT', 'CANCELLED')
  and f.year <= $P{asofyear}
  and r.ry <= $P{ry}
order by f.tdno 