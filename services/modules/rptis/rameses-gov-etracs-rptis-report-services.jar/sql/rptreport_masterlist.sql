
[getListing]
SELECT t.* FROM (  
	SELECT 
		f.state, f.owner_name, f.administrator_name, f.name, r.fullpin, f.tdno, f.titleno, rp.cadastrallotno,  
		r.rputype, pc.code AS classcode, r.totalareaha, r.totalareasqm, r.totalmv, r.totalav, f.effectivityyear, 
		f.prevtdno, NULL AS cancelledbytdnos, NULL AS cancelreason, canceldate,
		rp.blockno, rp.surveyno
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	WHERE f.state = 'CURRENT' 
	${filters}

	UNION ALL

	SELECT 
		f.state, f.owner_name, f.administrator_name, f.name, r.fullpin, f.tdno, f.titleno, rp.cadastrallotno,  
		r.rputype, pc.code AS classcode, r.totalareaha, r.totalareasqm, r.totalmv, r.totalav, f.effectivityyear, 
		f.prevtdno, cancelledbytdnos, cancelreason, canceldate,
		rp.blockno, rp.surveyno
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	WHERE f.state = 'CANCELLED' 
	  AND f.cancelledyear = $P{currentyear}  
	  ${filters}
) t 
${orderbyclause} 


[getCurrentListing]
SELECT t.* 
FROM (
	SELECT 
		f.state, f.owner_name, f.administrator_name, f.name, r.fullpin, f.tdno, f.titleno, rp.cadastrallotno,  
		r.rputype, pc.code AS classcode, r.totalareaha, r.totalareasqm, r.totalmv, r.totalav, f.effectivityyear, 
		f.prevtdno, NULL AS cancelledbytdnos, NULL AS cancelreason, canceldate,
		rp.blockno, rp.surveyno
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	WHERE f.state = 'CURRENT' 
		${filters}
) t 
${orderbyclause} 


[getCancelledListing]
SELECT t.* 
FROM (
	SELECT 
		f.state, f.owner_name, f.administrator_name, f.name, r.fullpin, f.tdno, f.titleno, rp.cadastrallotno,  
		r.rputype, pc.code AS classcode, r.totalareaha, r.totalareasqm, r.totalmv, r.totalav, f.effectivityyear, 
		f.prevtdno, cancelledbytdnos, cancelreason, canceldate,
		rp.blockno, rp.surveyno
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	WHERE f.state = 'CANCELLED' 
		AND f.cancelledyear = $P{currentyear}  
		${filters}
) t
${orderbyclause} 