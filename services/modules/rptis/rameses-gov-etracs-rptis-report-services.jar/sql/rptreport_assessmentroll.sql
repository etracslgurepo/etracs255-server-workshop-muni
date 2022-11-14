[findCurrentRy]
select max(ry) as ry from landrysetting 

[getAssessmentRollTaxable]
SELECT
	r.ry, rp.section,  
	CASE WHEN p.objid IS NOT NULL THEN p.name ELSE c.name END AS parentlguname, 
	CASE WHEN p.objid IS NOT NULL THEN p.indexno ELSE c.indexno END AS parentlguindex,   
	CASE WHEN m.objid IS NOT NULL THEN m.name ELSE d.name END AS lguname, 
	CASE WHEN m.objid IS NOT NULL THEN m.indexno ELSE d.indexno END AS lguindex,  
	
	b.name AS barangay, b.indexno AS barangayindex, 
	f.owner_name, f.owner_address, 
	f.administrator_name, f.administrator_address, 
	f.tdno, f.effectivityyear, f.prevtdno, 
	rp.cadastrallotno, rp.surveyno, rp.blockno, pc.code AS classcode, r.rputype, r.totalav, 
	r.fullpin, f.prevtdno, f.memoranda, rp.barangayid 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	LEFT JOIN municipality m ON b.parentid = m.objid  
	LEFT JOIN district d ON b.parentid = d.objid 
	LEFT JOIN province p ON m.parentid = p.objid 
	LEFT JOIN city c ON d.parentid = c.objid 
WHERE rp.ry = $P{ry}
  AND rp.barangayid = $P{barangayid} 
  AND rp.section LIKE $P{section} 
  AND f.state = 'CURRENT'  
  AND r.taxable = 1 
ORDER BY rp.pin, r.suffix   

[getAssessmentRollExempt]
SELECT
	r.ry, rp.section,  
	CASE WHEN p.objid IS NOT NULL THEN p.name ELSE c.name END AS parentlguname, 
	CASE WHEN p.objid IS NOT NULL THEN p.indexno ELSE c.indexno END AS parentlguindex,   
	CASE WHEN m.objid IS NOT NULL THEN m.name ELSE d.name END AS lguname, 
	CASE WHEN m.objid IS NOT NULL THEN m.indexno ELSE d.indexno END AS lguindex,  
	
	b.name AS barangay, b.indexno AS barangayindex, 
	f.owner_name, f.owner_address, 
	f.administrator_name, f.administrator_address, 
	f.tdno, f.effectivityyear, f.prevtdno, 
	rp.cadastrallotno,  rp.surveyno, rp.blockno, pc.code AS classcode, r.rputype, r.totalav, 
	r.fullpin, f.memoranda, rp.barangayid,
	f.memoranda, et.code AS legalbasis  
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	LEFT JOIN exemptiontype et ON r.exemptiontype_objid = et.objid 
	LEFT JOIN municipality m ON b.parentid = m.objid  
	LEFT JOIN district d ON b.parentid = d.objid 
	LEFT JOIN province p ON m.parentid = p.objid 
	LEFT JOIN city c ON d.parentid = c.objid 
WHERE rp.ry = $P{ry}
  AND rp.barangayid = $P{barangayid} 
  AND rp.section LIKE $P{section} 
  AND f.state = 'CURRENT'  
  AND r.taxable = 0 
ORDER BY rp.pin, r.suffix



[getContinuousAssessmentRoll]
SELECT
	CASE WHEN p.objid IS NOT NULL THEN p.name ELSE c.name END AS parentlguname, 
	CASE WHEN p.objid IS NOT NULL THEN p.indexno ELSE c.indexno END AS parentlguindex,   
	CASE WHEN m.objid IS NOT NULL THEN m.name ELSE d.name END AS lguname, 
	CASE WHEN m.objid IS NOT NULL THEN m.indexno ELSE d.indexno END AS lguindex,  
	f.state, r.ry, f.cancelledbytdnos, f.cancelreason,
	f.owner_name, f.owner_address, 
	f.administrator_name, f.administrator_address, 
	f.tdno, f.effectivityyear, f.prevtdno, 
	rp.cadastrallotno, rp.surveyno, rp.blockno, pc.code AS classcode, r.rputype, r.totalav, r.totalareasqm, r.totalareaha,
	r.fullpin, f.prevtdno, f.memoranda, 
	b.name AS barangay, b.indexno AS barangayindex,
	et.code AS legalbasis   
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	LEFT JOIN exemptiontype et ON r.exemptiontype_objid = et.objid 
	LEFT JOIN municipality m ON b.parentid = m.objid  
	LEFT JOIN district d ON b.parentid = d.objid 
	LEFT JOIN province p ON m.parentid = p.objid 
	LEFT JOIN city c ON d.parentid = c.objid 
WHERE rp.ry = $P{ry}
  AND f.lguid = $P{lguid}
  AND rp.barangayid like $P{barangayid}
  AND f.state IN ('CURRENT', 'CANCELLED')
  AND r.taxable = 1 
ORDER BY f.tdno 



[getContinuousAssessmentRollExempt]
SELECT
	r.ry, rp.section,  
	CASE WHEN p.objid IS NOT NULL THEN p.name ELSE c.name END AS parentlguname, 
	CASE WHEN p.objid IS NOT NULL THEN p.indexno ELSE c.indexno END AS parentlguindex,   
	CASE WHEN m.objid IS NOT NULL THEN m.name ELSE d.name END AS lguname, 
	CASE WHEN m.objid IS NOT NULL THEN m.indexno ELSE d.indexno END AS lguindex,  
	
	b.name AS barangay, b.indexno AS barangayindex, 
	f.owner_name, f.owner_address, 
	f.administrator_name, f.administrator_address, 
	f.tdno, f.effectivityyear, f.prevtdno, 
	rp.cadastrallotno,  rp.surveyno, rp.blockno, pc.code AS classcode, r.rputype, r.totalav, r.totalareasqm, r.totalareaha,
	r.fullpin, f.memoranda, rp.barangayid,
	f.memoranda, et.code AS legalbasis  
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	LEFT JOIN exemptiontype et ON r.exemptiontype_objid = et.objid 
	LEFT JOIN municipality m ON b.parentid = m.objid  
	LEFT JOIN district d ON b.parentid = d.objid 
	LEFT JOIN province p ON m.parentid = p.objid 
	LEFT JOIN city c ON d.parentid = c.objid 
WHERE rp.ry = $P{ry}
  AND f.lguid = $P{lguid}
  AND rp.barangayid like $P{barangayid}
  AND f.state IN ('CURRENT', 'CANCELLED')
  AND r.taxable = 0
ORDER BY f.tdno 
