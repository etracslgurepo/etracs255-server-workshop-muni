[getCounters]
SELECT a.* 
FROM queue_section a
	INNER JOIN queue_counter_section b ON a.objid=b.sectionid
WHERE b.counterid = $P{counterid}

[findCurrentNumber]
SELECT 
	qg.title AS groupname, qs.title, qs.prefix, qn.seriesno, 
	qn.sectionid, qn.ticketno, qn.objid as numberid 
FROM queue_number_counter qnc 
	INNER JOIN queue_number qn ON qnc.objid=qn.objid
	INNER JOIN queue_group qg ON qn.groupid=qg.objid
	INNER JOIN queue_section qs ON qn.sectionid=qs.objid
WHERE qnc.counterid=$P{counterid}

