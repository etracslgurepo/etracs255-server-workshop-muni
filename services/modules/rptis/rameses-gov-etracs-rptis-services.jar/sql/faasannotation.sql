[getList]
SELECT fa.*,
	f.tdno AS faas_tdno,
	f.owner_name AS faas_owner_name,
	f.owner_address AS faas_owner_address,
	r.fullpin AS faas_fullpin,
	r.totalmv AS faas_totalmv,
	r.totalav AS faas_totalav,
	pc.code AS faas_classification,
	fat.type AS annotationtype_type
FROM faasannotation fa
	INNER JOIN faasannotationtype fat ON fa.annotationtype_objid = fat.objid 
	INNER JOIN faas f ON fa.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc on r.classification_objid = pc.objid 
where 1=1 ${filters}



[getActiveAnnotationsByFaasId]
SELECT fa.*,
	f.tdno AS faas_tdno,
	f.owner_name AS faas_owner_name,
	f.owner_address AS faas_owner_address,
	r.fullpin AS faas_fullpin,
	r.totalmv AS faas_totalmv,
	r.totalav AS faas_totalav,
	pc.code AS faas_classification,
	fat.objid AS annotationtype_objid,
	fat.type AS annotationtype_type
FROM faasannotation fa
	INNER JOIN faasannotationtype fat ON fa.annotationtype_objid = fat.objid 
	INNER JOIN faasannotation_faas faf on fa.objid = faf.parent_objid
	INNER JOIN faas f ON faf.faas_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc on r.classification_objid = pc.objid 
WHERE faf.faas_objid = $P{faasid}
  AND fa.state = 'APPROVED'
ORDER BY fa.txnno DESC 



[getAnnotationHistoryByFaasId]
SELECT fa.*,
	f.tdno AS faas_tdno,
	f.owner_name AS faas_owner_name,
	f.owner_address AS faas_owner_address,
	r.fullpin AS faas_fullpin,
	r.totalmv AS faas_totalmv,
	r.totalav AS faas_totalav,
	pc.code AS faas_classification,
	fat.objid AS annotationtype_objid,
	fat.type AS annotationtype_type
FROM faasannotation fa
	INNER JOIN faasannotationtype fat ON fa.annotationtype_objid = fat.objid 
	INNER JOIN faas f ON fa.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc on r.classification_objid = pc.objid 
WHERE fa.faasid = $P{faasid}
  AND fa.state IN ('APPROVED', 'CANCELLED')
ORDER BY fa.txnno DESC 


[findById]
SELECT fa.*,
	f.tdno AS faas_tdno,
	f.owner_name AS faas_owner_name,
	f.owner_address AS faas_owner_address,
	r.fullpin AS faas_fullpin,
	r.totalmv AS faas_totalmv,
	r.totalav AS faas_totalav,
	pc.code AS faas_classification_code,
	fat.objid AS annotationtype_objid,
	fat.type AS annotationtype_type
FROM faasannotation fa
	INNER JOIN faasannotationtype fat ON fa.annotationtype_objid = fat.objid 
	INNER JOIN faas f ON fa.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc on r.classification_objid = pc.objid 
WHERE fa.objid = $P{objid}


[getAnnotationTypes]
SELECT * FROM faasannotationtype ORDER BY type 

[getActiveAnnotations]
select objid, txnno, fileno from faasannotation where faasid = $P{objid} and state = 'APPROVED'

