[findNextAvailableNumber]
select * from queue_number qn 
where sectionid=$P{sectionid} 
	and txndate between $P{startdate} and $P{enddate}  
	and state = 'PENDING' 
	and not exists ( 
		select objid from queue_number_counter where objid=qn.objid 
	) 
order by txndate, seriesno 

[getPendingList]
select * from ( 
	select qn.*, qs.title as sectiontitle  
	from queue_number qn 
		inner join queue_section qs on qn.sectionid=qs.objid 
	where qn.sectionid=$P{sectionid} 
		and qn.state='PENDING' 
)xxx 
order by groupid, sectionid, seriesno 

[getPendingListByCounter]
select 
	qn.*, qs.title as sectiontitle 
from queue_counter_section qcs 
	inner join queue_number qn on qcs.sectionid=qn.sectionid 
	inner join queue_section qs on qn.sectionid=qs.objid 
where qcs.counterid=$P{counterid} 
	and qn.txndate between $P{startdate} and $P{enddate}  
	and qn.state = 'PENDING' 
	and qn.objid not in (select objid from queue_number_counter where objid=qn.objid) 
order by qn.txndate 

[getPendingListByGroup]
select 
	qn.*, qs.title as sectiontitle 
from queue_number qn 
	inner join queue_section qs on qn.sectionid=qs.objid 
where qn.groupid=$P{groupid} 
	and qn.txndate between $P{startdate} and $P{enddate}  
	and qn.state = 'PENDING' 
	and qn.objid not in (select objid from queue_number_counter where objid=qn.objid) 
order by qn.txndate 


[getPendingSections]
select distinct 
	qs.objid, qs.title, qs.groupid, qg.title as grouptitle 
from queue_number qn 
	inner join queue_section qs on qn.sectionid=qs.objid 
	inner join queue_group qg on qs.groupid=qg.objid 
where qn.groupid=$P{groupid} 
	and qn.state='PENDING' 

[removeExpiredTickets]
delete from queue_number 
where ( txndate IS NULL or txndate < $P{txndate} ) 
	and objid not in ( 
		select objid from queue_number_counter 
		where objid=queue_number.objid 
	) 


[getSkipTickets]
select * from ( 
	select qn.*, qs.title as sectiontitle  
	from queue_counter_section qcs 
		inner join queue_section qs on qcs.sectionid=qs.objid 
		inner join queue_number qn on qn.sectionid=qs.objid 
	where qcs.counterid=$P{counterid} 
		and qn.state='SKIP' 
		and qn.txndate >= $P{startdate} 
		and qn.txndate < $P{enddate} 
)xxx 
order by xxx.txndate desc, xxx.ticketno desc 


[getStatusList]
select qs.*, ( 
		select count(*) from queue_number qn 
		where qn.sectionid=qs.objid 
			and qn.state='PENDING' 
			and qn.objid not in (select objid from queue_number_counter where objid=qn.objid) 
			and qn.txndate >= $P{startdate} 
			and qn.txndate < $P{enddate}  
	) as pendingcount, 
	( 
		select count(*) from queue_number qn 
		where qn.sectionid=qs.objid 
			and qn.state='SKIP' 
			and qn.txndate >= $P{startdate} 
			and qn.txndate < $P{enddate} 			
	) as skipcount 
from queue_counter_section qcs 
	inner join queue_section qs on qcs.sectionid=qs.objid 
where qcs.counterid=$P{counterid} 
order by qs.groupid, qs.sortorder, qs.title 

[getSectionStatusList]
select 
	qs.*, qg.title as grouptitle, 
	( 
		select qn.ticketno  
		from queue_number qn, queue_number_counter qnc 
		where qn.sectionid=qs.objid and qn.objid=qnc.objid and qn.state='PENDING' 
		limit 1 
	) as servedticketno, 
	( 
		select qn.ticketno from queue_number qn 
		where qn.sectionid=qs.objid 
			and qn.txndate >= convert(now(), date) 
			and qn.objid not in ( select objid from queue_number_counter where objid=qn.objid ) 
			and qn.state='PENDING' 
		order by qn.seriesno 
		limit 1 
	) as nextticketno 
from queue_section qs 
	inner join queue_group qg on qs.groupid=qg.objid 
order by qs.groupid, qs.sortorder, qs.title 
