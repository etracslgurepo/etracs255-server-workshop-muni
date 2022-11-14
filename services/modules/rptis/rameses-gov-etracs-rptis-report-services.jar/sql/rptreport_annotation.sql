[getAnnotationListing]
SELECT 
	f.tdno, f.titleno, f.titledate, f.titletype, f.owner_name, f.owner_address, 
	r.fullpin, rp.cadastrallotno, r.rputype, b.name AS barangay, pc.code AS classcode, r.totalmv, r.totalav, 
	r.totalareaha,	r.totalareasqm, fat.type AS annotationtype, fa.memoranda, 
	rp.blockno, rp.surveyno
FROM faasannotation fa 
	INNER JOIN faasannotationtype fat ON fa.annotationtype_objid = fat.objid 
	INNER JOIN faasannotation_faas faf on fa.objid = faf.parent_objid
	INNER JOIN faas f ON faf.faas_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE fa.state = 'APPROVED'  
  AND f.lguid LIKE $P{lguid} 
  AND rp.barangayid LIKE $P{barangayid}
  AND f.state = 'CURRENT'  
${orderbyclause} 
