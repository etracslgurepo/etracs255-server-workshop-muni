
[lookupUnreferencedLguland] 
SELECT objid, lguname, pin FROM lgu 
WHERE lgutype IN ( 'MUNICIPALITY','CITY') 
  AND lguname LIKE $P{lguname} 
  AND NOT EXISTS(
		SELECT * 
		FROM landrysetting r
		INNER JOIN rysetting_lgu rl ON r.objid = rl.rysettingid 
		WHERE rl.lguid = lgu.objid 
		  AND rl.settingtype = $P{settingtype} 
		  AND r.ry = $P{ry} 
  ) 
ORDER BY lguname 

[lookupUnreferencedLgubldg]
SELECT objid, lguname, pin FROM lgu 
WHERE lgutype IN ( 'MUNICIPALITY','CITY') 
  AND lguname LIKE $P{lguname} 
  AND NOT EXISTS(
		SELECT * 
		FROM bldgrysetting r
		INNER JOIN rysetting_lgu rl ON r.objid = rl.rysettingid 
		WHERE rl.lguid = lgu.objid 
		  AND rl.settingtype = $P{settingtype} 
		  AND r.ry = $P{ry} 
  ) 
ORDER BY lguname 

[lookupUnreferencedLgumach]
SELECT objid, lguname, pin FROM lgu 
WHERE lgutype IN ( 'MUNICIPALITY','CITY') 
  AND lguname LIKE $P{lguname} 
  AND NOT EXISTS(
		SELECT * 
		FROM machrysetting r
		INNER JOIN rysetting_lgu rl ON r.objid = rl.rysettingid 
		WHERE rl.lguid = lgu.objid 
		  AND rl.settingtype = $P{settingtype} 
		  AND r.ry = $P{ry} 
  ) 
ORDER BY lguname 

[lookupUnreferencedLguplanttree]
SELECT objid, lguname, pin FROM lgu 
WHERE lgutype IN ( 'MUNICIPALITY','CITY') 
  AND lguname LIKE $P{lguname} 
  AND NOT EXISTS(
		SELECT * 
		FROM planttreerysetting r
		INNER JOIN rysetting_lgu rl ON r.objid = rl.rysettingid 
		WHERE rl.lguid = lgu.objid 
		  AND rl.settingtype = $P{settingtype} 
		  AND r.ry = $P{ry} 
  ) 
ORDER BY lguname 

[lookupUnreferencedLgumisc]
SELECT objid, lguname, pin FROM lgu 
WHERE lgutype IN ( 'MUNICIPALITY','CITY') 
  AND lguname LIKE $P{lguname} 
  AND NOT EXISTS(
		SELECT * 
		FROM miscrysetting r
		INNER JOIN rysetting_lgu rl ON r.objid = rl.rysettingid 
		WHERE rl.lguid = lgu.objid 
		  AND rl.settingtype = $P{settingtype} 
		  AND r.ry = $P{ry} 
  ) 
ORDER BY lguname 

[getLguList]
SELECT * FROM rysetting_lgu WHERE rysettingid = $P{objid} AND settingtype = $P{settingtype}

[deleteLgus]
DELETE FROM rysetting_lgu WHERE rysettingid = $P{objid} AND settingtype = $P{settingtype}


[getSetting]
SELECT * FROM {setting} 
