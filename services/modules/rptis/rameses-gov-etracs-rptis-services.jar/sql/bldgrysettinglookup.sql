[lookupBldgRySettingById]
SELECT * FROM bldgrysetting WHERE objid = $P{objid}



[lookupAssessLevels]
SELECT bal.*, l.barangayid
FROM bldgrysetting rs
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN bldgassesslevel bal ON rs.objid = bal.bldgrysettingid 
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (bal.code LIKE $P{searchtext} OR bal.name LIKE $P{searchtext})	
ORDER BY CODE 


[lookupAssessLevelByPrevId]
SELECT bal.* 
FROM bldgassesslevel bal
WHERE bal.previd = $P{previd}


[lookupBldgTypes]
SELECT bt.*, l.barangayid, rs.ry
FROM bldgrysetting rs
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN bldgtype bt ON rs.objid = bt.bldgrysettingid
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (bt.code LIKE $P{searchtext} OR bt.name LIKE $P{searchtext})	
ORDER BY CODE 


[lookupBldgTypeByPrevId]
SELECT bt.* 
FROM bldgtype bt
WHERE bt.previd = $P{previd}


[lookupBldgTypeById]
SELECT bt.*, l.barangayid 
FROM bldgrysetting rs
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
	INNER JOIN bldgtype bt ON rs.objid = bt.bldgrysettingid
WHERE bt.objid = $P{objid}	


[lookupBldgKindBuccs]
SELECT 
	bucc.*,
	bk.code AS bldgkind_code,
	bk.name AS bldgkind_name,
	bt.basevaluetype AS btbasevaluetype
FROM bldgkindbucc bucc 
	INNER JOIN bldgkind bk ON bucc.bldgkind_objid = bk.objid 
	INNER JOIN bldgtype bt ON bucc.bldgtypeid = bt.objid 
WHERE bucc.bldgtypeid = $P{bldgtypeid}
  AND (bk.code LIKE $P{searchtext} OR bk.name LIKE $P{searchtext})	
ORDER BY bk.code 


[lookupBldgKindBuccByPrevId]
SELECT 
	bucc.*,
	bk.code AS bldgkind_code,
	bk.name AS bldgkind_name
FROM bldgkindbucc bucc 
	INNER JOIN bldgkind bk ON bucc.bldgkind_objid = bk.objid 
WHERE bucc.previd = $P{previd}


[lookupBldgKindBuccById]
SELECT 
	bucc.*,
	bk.code AS bldgkind_code,
	bk.name AS bldgkind_name
FROM bldgkindbucc bucc 
	INNER JOIN bldgkind bk ON bucc.bldgkind_objid = bk.objid 
WHERE bucc.objid = $P{objid}


[getDepreciations]
SELECT * 
FROM bldgtype_depreciation
WHERE bldgtypeid = $P{bldgtypeid}
ORDER BY agefrom 


[lookupBldgAssessLevelById]
SELECT *
FROM bldgassesslevel 
WHERE objid = $P{objid}


[lookupBldgAssessLevel]
SELECT *
FROM bldgassesslevel 
WHERE bldgrysettingid = $P{bldgrysettingid} 
  AND classification_objid = $P{classificationid}


[lookupAssessLevelFromRange]  
SELECT *
FROM bldgassesslevelrange
WHERE bldgassesslevelid = $P{bldgassesslevelid}
  AND $P{mv} >= mvfrom 
  AND ( $P{mv} < mvto OR mvto = 0)



[lookupAdditionalItems]
SELECT
	bai.*, l.barangayid
FROM bldgadditionalitem bai
	INNER JOIN bldgrysetting rs ON bai.bldgrysettingid = rs.objid 
	INNER JOIN rysetting_lgu l ON rs.objid = l.rysettingid 
WHERE rs.ry = $P{ry}
  AND l.lguid = $P{lguid}
  AND (bai.code LIKE $P{searchtext} OR bai.name LIKE $P{searchtext})	
  AND bai.type LIKE $P{type}
ORDER BY bai.code 



[lookupAdditionalItemByPrevId]
SELECT
	bai.*
FROM bldgadditionalitem bai
WHERE bai.previd = $P{previd}



[findByLguIdRy]
SELECT bs.*, bl.barangayid 
FROM bldgrysetting bs
	INNER JOIN rysetting_lgu bl ON bs.objid = bl.rysettingid
WHERE bs.ry = $P{ry}
  AND bl.lguid = $P{lguid}


[findMultiStoreyAdjustmentSetting]
select sa.*
from bldgrysetting rs
	inner join rysetting_lgu l on rs.objid = l.rysettingid
	inner join bldgtype_storeyadjustment sa on rs.objid = sa.bldgrysettingid
	left join bldgtype_storeyadjustment_bldgkind sab on sa.objid = sab.parentid
where l.lguid = $P{lguid}
and rs.ry = $P{ry}
and sa.bldgtypeid = $P{bldgtypeid}
and sa.floorno = $P{floorno}
and (sab.objid is null or sab.bldgkindid = $P{bldgkindid})

