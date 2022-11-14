[getApproveFaasListing]
SELECT 
	f.objid, 
	f.state,
	f.tdno,
	f.owner_name,
	f.administrator_name, 
	f.titleno,
	f.prevtdno,
	f.effectivityyear,
	cancelledbytdnos,
	canceldate,
	cancelreason,
	r.rputype,
	r.fullpin,
	r.totalareasqm,
	r.totalareaha,
	r.totalmv,
	r.totalav,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	pc.code AS classcode
FROM faas f 
	INNER JOIN rpu r ON f.rpuid = r.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
WHERE ${filter}
	AND f.state IN ('CURRENT', 'CANCELLED')
	AND rp.section like $P{section}
	${txntypefilter}
ORDER BY f.tdno  	

