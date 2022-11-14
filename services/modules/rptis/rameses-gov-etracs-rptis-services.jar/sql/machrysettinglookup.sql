[lookupAssessLevels]
SELECT mal.*, l.barangayid 
FROM machrysetting rs
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN machassesslevel mal ON rs.objid = mal.machrysettingid 
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (mal.code LIKE $P{searchtext} OR mal.name LIKE $P{searchtext})	
ORDER BY mal.code 


[lookupAssessLevelByPrevId]
SELECT mal.* 
FROM machassesslevel mal
WHERE mal.previd = $P{previd}


[lookupMachRySettingById]
SELECT * FROM machrysetting WHERE objid = $P{objid}


[lookupForex]
SELECT mf.objid, mf.forex 
FROM machrysetting s, machforex mf 
WHERE s.objid = mf.machrysettingid 
  AND s.ry = $P{ry}
  AND mf.year = $P{year}


[lookupForexByPrevId]
SELECT mf.objid, mf.forex 
FROM machforex mf 
WHERE mf.previd = $P{previd}


[lookupAssessLevelByRange]  
SELECT rate
FROM machassesslevelrange 
WHERE machassesslevelid = $P{machassesslevelid}
  AND $P{mv} >= mvfrom
  AND ( $P{mv} < mvto OR mvto = 0)


[getMachineSmvs]
SELECT 
	m.*,
	xx.expr,
	xx.objid AS smv_objid,
	xx.expr AS smv_expr,
	xx.previd AS smv_previd
FROM machine m
LEFT JOIN 
(SELECT ms.*
	FROM machine_smv ms 
	INNER JOIN machrysetting rs ON ms.parent_objid = rs.objid 
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	WHERE 1=1 
	${filters}
)xx ON m.objid = xx.machine_objid
WHERE (m.code LIKE $P{searchtext} OR m.name LIKE $P{searchtext})	
ORDER BY m.code