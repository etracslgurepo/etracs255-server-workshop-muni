[getList]
SELECT ca.*,
	fa.fileno AS annotation_fileno,
	fa.annotationtype_objid AS annotation_annotationtype_objid,
	fat.type AS annotation_annotationtype_type,
	fa.orno AS annotation_orno,
	fa.ordate AS annotation_ordate,
	fa.oramount AS annotation_oramount,
	f.tdno AS annotation_faas_tdno,
	r.fullpin AS annotation_faas_fullpin
FROM cancelannotation ca
	INNER JOIN faasannotation fa ON ca.annotationid = fa.objid 
	INNER JOIN faasannotationtype fat ON fa.annotationtype_objid = fat.objid 
	INNER JOIN faas f ON fa.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
where 1=1 ${filters}


[open]
SELECT ca.*,
	fa.fileno AS annotation_fileno,
	fa.memoranda AS memoranda,
	fa.annotationtype_objid AS annotation_annotationtype_objid,
	fat.type AS annotation_annotationtype_type,
	fa.orno AS annotation_orno,
	fa.ordate AS annotation_ordate,
	fa.oramount AS annotation_oramount,
	f.tdno AS annotation_faas_tdno,
	r.fullpin AS annotation_faas_fullpin
FROM cancelannotation ca
	INNER JOIN faasannotation fa ON ca.annotationid = fa.objid 
	INNER JOIN faasannotationtype fat ON fa.annotationtype_objid = fat.objid 
	INNER JOIN faas f ON fa.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
WHERE ca.objid = $P{objid}


[findById]
select * from cancelannotation where objid = $P{objid}

[findAnnotationByCancelId]
select a.* 
from cancelannotation ca 
inner join faasannotation a on ca.annotationid = a.objid 
where ca.objid = $P{objid}


