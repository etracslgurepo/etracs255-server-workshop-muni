[getList]
SELECT 
	qs.*, qs.objid as sectionid, 
	qs.groupid as group_objid, 
	qg.title as group_title   
FROM queue_section qs 
	INNER JOIN queue_group qg on qs.groupid=qg.objid 
ORDER BY qs.groupid, qs.sortorder, qs.title 

[resetTickets]
delete from queue_number 
where sectionid=$P{sectionid} 
	and objid not in ( select objid from queue_number_counter where objid=queue_number.objid ) 
