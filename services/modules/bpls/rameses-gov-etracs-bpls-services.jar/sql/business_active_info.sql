[getAppInfos]
SELECT bi.*, 
b.caption  AS attribute_caption, 
b.datatype AS attribute_datatype, 
b.sortorder AS attribute_sortorder,
b.category AS attribute_category,
b.handler AS attribute_handler
FROM business_active_info bi 
INNER JOIN businessvariable b ON b.objid=bi.attribute_objid
WHERE bi.businessid=$P{businessid} AND bi.type = 'appinfo'
ORDER BY b.category, b.sortorder 

[getAssessmentInfos]
SELECT bi.*, 
b.caption  AS attribute_caption, 
b.datatype AS attribute_datatype, 
b.sortorder AS attribute_sortorder,
b.category AS attribute_category,
b.handler AS attribute_handler
FROM business_active_info bi 
INNER JOIN businessvariable b ON b.objid=bi.attribute_objid
WHERE bi.businessid=$P{businessid} AND bi.type = 'assessmentinfo'
ORDER BY b.category, b.sortorder 

[removeAppInfos]
DELETE FROM business_active_info WHERE businessid=$P{businessid} AND type = 'appinfo'

[removeAssessmentInfos]
DELETE FROM business_active_info WHERE businessid=$P{businessid} AND type = 'assessmentinfo'

[cleanupInfos]
DELETE FROM business_active_info 
WHERE businessid=$P{businessid} 
	AND lob_objid IS NOT NULL 
	AND lob_objid NOT IN (
		SELECT lobid FROM business_active_lob 
		WHERE businessid=$P{businessid}  
	) 
