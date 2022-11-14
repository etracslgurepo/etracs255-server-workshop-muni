
[getInspections]
SELECT *
FROM (
	SELECT
		f.objid as faasid, 
		brgy.name AS barangay,
		rp.section,
		r.rputype, 
		r.fullpin, 
		r.objid,
		rp.parcel,
		f.owner_name,
		f.owner_address,
		f.tdno,
		f.classcode,
		r.totalmv,
		r.totalav,
		r.totalareaha,
		r.totalareasqm,
		null as dtoccupied,
		null as bldgtype,
		null AS kind,
		rp.pin, 
		r.suffix,
		case when r.taxable = 1 then 'T' else 'E' end as taxability
	FROM faas_list f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN landrpu l ON r.objid = l.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
		INNER JOIN barangay brgy ON rp.barangayid = brgy.objid 
	WHERE brgy.objid = $P{barangayid}
	  AND rp.section like $P{section}
	  AND rp.parcel like $P{parcel}
	  AND f.state = 'CURRENT'

	UNION ALL 

	SELECT
		f.objid as faasid, 
		brgy.name AS barangay,
		rp.section,
		r.rputype, 
		r.fullpin, 
		r.objid,
		concat(rp.parcel, '-', r.suffix) AS parcel,
		f.owner_name,
		f.owner_address,
		f.tdno,
		f.classcode,
		r.totalmv,
		r.totalav,
		r.totalareaha,
		r.totalareasqm,
		b.dtoccupied,
		bt.name as bldgtype,
		bk.name AS kind,
		rp.pin, 
		r.suffix,
		case when r.taxable = 1 then 'T' else 'E' end as taxability
	FROM faas_list f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN bldgrpu b ON r.objid = b.objid 
		INNER JOIN bldgrpu_structuraltype st ON b.objid = st.bldgrpuid
		INNER JOIN bldgtype bt ON st.bldgtype_objid = bt.objid 
		INNER JOIN bldgkindbucc bucc ON st.bldgkindbucc_objid = bucc.objid 
		INNER JOIN bldgkind bk ON bucc.bldgkind_objid = bk.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
		INNER JOIN barangay brgy ON rp.barangayid = brgy.objid 
	WHERE brgy.objid = $P{barangayid}
	  AND rp.section like $P{section}
		AND rp.parcel like $P{parcel}
	  AND f.state = 'CURRENT'
) t
${orderby}



[getLandSpecificClasses]
SELECT spc.name 
FROM landdetail ld 
	INNER JOIN landspecificclass spc ON ld.landspecificclass_objid = spc.objid 
WHERE ld.landrpuid = $P{objid}


[getBldgStrucutureInfo]  
SELECT 
	CASE WHEN s.name = 'COLUMNS' THEN m.name ELSE null END AS columns,
	CASE WHEN s.name = 'EXTERIOR WALLS' THEN m.name ELSE null END AS extwalls,
	CASE WHEN s.name = 'ROOF' THEN m.name ELSE null END AS roofing
FROM bldgrpu b
	INNER JOIN bldgstructure bs ON b.objid = bs.bldgrpuid
	INNER JOIN structure s ON bs.structure_objid = s.objid 
	LEFT JOIN material m ON bs.material_objid = m.objid 
WHERE b.objid = $P{objid}
  AND s.objid IN ('STR00000003', 'STR00000006', 'STR00000012')



