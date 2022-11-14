[getAppInfos]
SELECT bi.*, 
b.caption  AS attribute_caption, 
b.datatype AS attribute_datatype, 
b.sortorder AS attribute_sortorder,
b.category AS attribute_category,
b.handler AS attribute_handler
FROM business_application_info bi 
INNER JOIN businessvariable b ON b.objid=bi.attribute_objid
WHERE bi.applicationid=$P{applicationid} AND bi.type = 'appinfo'
ORDER BY b.category, b.sortorder 

[getAssessmentInfos]
SELECT bi.*, 
	b.caption  AS attribute_caption, 
	b.datatype AS attribute_datatype, 
	b.sortorder AS attribute_sortorder,
	b.category AS attribute_category,
	b.handler AS attribute_handler
FROM business_application_info bi 
	INNER JOIN businessvariable b ON b.objid=bi.attribute_objid
WHERE bi.applicationid=$P{applicationid} 
	AND bi.type = 'assessmentinfo'
ORDER BY b.category, b.sortorder 

[removeAppInfos]
DELETE FROM business_application_info WHERE applicationid=$P{applicationid} AND type = 'appinfo'

[removeAssessmentInfos]
DELETE FROM business_application_info WHERE applicationid=$P{applicationid} AND type = 'assessmentinfo'


