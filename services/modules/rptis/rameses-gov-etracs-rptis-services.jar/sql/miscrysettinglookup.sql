[getMiscRySettingById]
SELECT * FROM miscrysetting WHERE objid = $P{objid}


[lookupAssessLevels]
SELECT
	mal.*, l.barangayid ,
	pc.code AS actualuse_code,
	pc.name AS actualuse_name
FROM miscassesslevel mal
	INNER JOIN miscrysetting rs ON mal.miscrysettingid = rs.objid 
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN propertyclassification pc ON mal.classification_objid = pc.objid 
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (mal.code LIKE $P{searchtext} OR mal.name LIKE $P{searchtext})	
ORDER BY mal.code 


[lookupAssessLevelById]
SELECT
	mal.*,
	pc.code AS actualuse_code,
	pc.name AS actualuse_name
FROM miscassesslevel mal
	INNER JOIN propertyclassification pc ON mal.classification_objid = pc.objid 
WHERE mal.objid = $P{objid}


[lookupAssessLevelByPrevId]
SELECT
	mal.*,
	pc.code AS actualuse_code,
	pc.name AS actualuse_name
FROM miscassesslevel mal
	INNER JOIN propertyclassification pc ON mal.classification_objid = pc.objid 
WHERE mal.previd = $P{previd}


[lookupAssessLevelRange]
SELECT * 
FROM miscassesslevelrange 
WHERE miscassesslevelid = $P{miscassesslevelid}
  AND $P{mv} >= mvfrom 
  AND ( $P{mv} < mvto OR mvto = 0 )


[lookupMiscItemValues]
SELECT
	miv.*, l.barangayid ,
	mi.code AS miscitem_code,
	mi.name AS miscitem_name
FROM miscitemvalue miv
	INNER JOIN miscrysetting rs ON miv.miscrysettingid = rs.objid 
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN miscitem mi ON miv.miscitem_objid = mi.objid 
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (mi.code LIKE $P{searchtext} OR mi.name LIKE $P{searchtext})	
ORDER BY mi.code 


[lookupMiscItemValueByPrevId]
SELECT
	miv.*,
	mi.code AS miscitem_code,
	mi.name AS miscitem_name
FROM miscitemvalue miv
	INNER JOIN miscrysetting rs ON miv.miscrysettingid = rs.objid 
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN miscitem mi ON miv.miscitem_objid = mi.objid 
WHERE miv.previd = $P{previd}

