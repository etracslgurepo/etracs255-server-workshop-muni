[removeUndueItems]
delete from report_bpdelinquency_item 
where parentid = $P{parentid} 
	and duedate >= $P{duedate} 
