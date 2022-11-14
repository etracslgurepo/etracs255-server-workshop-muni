[getList]
SELECT
lob.objid AS lobid, 
lob.name AS lobname,
m.groupid,
m.objid AS categoryid,
m.title AS category,
m.mappingid
FROM lob 
LEFT JOIN 
	( 
		SELECT lrc.*, lrcm.lobid, lrcm.objid AS mappingid 
		FROM lob_report_category_mapping lrcm 
		INNER JOIN lob_report_category lrc ON lrcm.categoryid=lrc.objid
		WHERE lrc.groupid = $P{groupid}
	) m
ON lob.objid=m.lobid
