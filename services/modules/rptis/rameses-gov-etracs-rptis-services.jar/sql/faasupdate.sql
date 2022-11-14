[getList]
SELECT 
	fu.*,
	f.tdno AS tdno,
	f.owner_name,
	f.owner_address,
	r.ry, 
	r.fullpin,
	r.realpropertyid,
	pc.code AS classification_code,
	pc.name AS classification_name
FROM faasupdate fu
	INNER JOIN faas f ON fu.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid
where 1=1 ${filters}	
ORDER BY fu.txnno 
	

[findById]
SELECT 
	fu.*,
	f.tdno AS tdno,
	f.owner_name,
	f.owner_address,
	r.ry, 
	r.fullpin,
	r.rputype,
	r.realpropertyid,
	pc.code AS classification_code,
	pc.name AS classification_name
FROM faasupdate fu
	INNER JOIN faas f ON fu.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid
WHERE fu.objid = $P{objid}
