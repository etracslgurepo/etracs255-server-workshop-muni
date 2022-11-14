[getCounterSections]
SELECT 
	qs.*, qcs.counterid, qcs.sectionid, 
	qs.groupid as group_objid, qg.title as group_title   
FROM queue_counter_section qcs 
	INNER JOIN queue_section qs on qcs.sectionid=qs.objid 
	INNER JOIN queue_group qg on qs.groupid=qg.objid 
WHERE qcs.counterid = $P{counterid}
ORDER BY qs.groupid, qs.sortorder, qs.title 

[findCounterSection]
SELECT 
	qs.*, qcs.counterid, qcs.sectionid, 
	qs.groupid as group_objid, qg.title as group_title 
FROM queue_counter_section qcs 
	INNER JOIN queue_section qs on qcs.sectionid=qs.objid 
	INNER JOIN queue_group qg on qs.groupid=qg.objid 
WHERE qcs.counterid = $P{counterid} 
	AND qcs.sectionid = $P{sectionid}  
