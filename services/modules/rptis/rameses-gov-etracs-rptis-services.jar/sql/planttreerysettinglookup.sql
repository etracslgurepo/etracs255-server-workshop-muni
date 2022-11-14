
#===================================================================
# LOOKUP SUPPORT
#===================================================================
[lookupAssessLevels]
SELECT lal.*, l.barangayid 
FROM planttreerysetting rs
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN planttreeassesslevel lal ON rs.objid = lal.planttreerysettingid 
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (lal.objid = $P{objid} OR lal.previd = $P{previd} OR lal.code LIKE $P{searchtext} OR lal.name LIKE $P{searchtext})	
ORDER BY lal.code 


[lookupAssessLevelByPrevId]
SELECT lal.* 
FROM planttreeassesslevel lal 
WHERE lal.previd = $P{previd}


[lookupUnitValues]
SELECT puv.*, l.barangayid,
  puv.code AS planttreeunitvalue_code,
  puv.name AS planttreeunitvalue_name,
	pt.code AS planttree_code,
	pt.name AS planttree_name
FROM planttreerysetting rs
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN planttreeunitvalue puv ON rs.objid = puv.planttreerysettingid
	INNER JOIN planttree pt ON puv.planttree_objid = pt.objid 
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (puv.objid = $P{objid} OR puv.previd = $P{previd} OR puv.code LIKE $P{searchtext} OR puv.name LIKE $P{searchtext} OR pt.code LIKE $P{searchtext} OR pt.name LIKE $P{searchtext} )	
ORDER BY puv.code 	

[lookupUnitValueByPrevId]
SELECT puv.*,
  puv.code AS planttreeunitvalue_code,
  puv.name AS planttreeunitvalue_name,
  pt.code AS planttree_code,
  pt.name AS planttree_name
FROM planttreerysetting rs
  INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
  INNER JOIN planttreeunitvalue puv ON rs.objid = puv.planttreerysettingid
  INNER JOIN planttree pt ON puv.planttree_objid = pt.objid 
WHERE puv.previd = $P{previd}


