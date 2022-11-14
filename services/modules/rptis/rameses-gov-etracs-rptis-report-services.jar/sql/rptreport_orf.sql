[getORF]  
SELECT
	b.name AS barangay, rp.cadastrallotno, pc.code AS classcode, r.fullpin, 
	f.prevtdno, e.name as taxpayer_name, e.address_text as taxpayer_address, f.tdno, 
	r.totalareasqm, r.totalareaha, r.totalmv, r.totalav, f.txntype_objid AS txntype,
	rp.street, rp.purok, rp.blockno, rp.surveyno, r.rputype, 
	f.titleno, f.administrator_name, f.administrator_address, o.name AS lguname 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
	INNER JOIN sys_org o on f.lguid = o.objid 
WHERE f.taxpayer_objid = $P{taxpayerid} 
  AND f.state = 'CURRENT'  
ORDER BY r.fullpin   
