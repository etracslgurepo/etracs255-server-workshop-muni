[getList]
SELECT 
	rp.objid,
	rp.pintype,
	rp.pin,
	rp.ry,
	rp.claimno,
	rp.section,
	rp.parcel,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	rp.street,
	rp.purok,
	rp.north,
	rp.south,
	rp.east,
	rp.west,
	rp.barangayid,
	rp.lgutype,
	rp.previd,
	rp.lguid,
	rp.stewardshipno,
	f.state, 
	f.tdno, 
	b.objid AS barangay_objid, 
	b.name AS barangay_name
FROM realproperty rp
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN faas_list f on rp.objid = f.realpropertyid 
WHERE (
	rp.pin like $P{searchtext} or 
	rp.cadastrallotno like $P{searchtext} or 
	rp.surveyno like $P{searchtext} or 
	f.tdno like $P{searchtext}
) 
and f.rputype = 'land'
${filters}
ORDER BY b.name , rp.pin 
