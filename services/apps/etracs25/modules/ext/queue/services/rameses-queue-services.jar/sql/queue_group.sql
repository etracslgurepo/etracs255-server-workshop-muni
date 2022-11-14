[getSectionCounters]
select 
	c.*, cs.sectionid, 
	( 
		select n.seriesno from queue_number_counter nc 
			inner join queue_number n on nc.objid=n.objid 
		where nc.counterid=c.objid and n.sectionid=s.objid  
	) as seriesno, 
	( 
		SELECT n.ticketno FROM queue_number_counter nc 
			INNER JOIN queue_number n ON nc.objid=n.objid 
		WHERE nc.counterid=c.objid AND n.sectionid=s.objid  
	) AS ticketno   	
from queue_section s 
	inner join queue_counter_section cs on s.objid=cs.sectionid 
	inner join queue_counter c on cs.counterid=c.objid 
where s.objid=$P{sectionid} 

[resetTickets]
delete from queue_number 
where groupid=$P{groupid}   
	and objid not in ( select objid from queue_number_counter where objid=queue_number.objid ) 
