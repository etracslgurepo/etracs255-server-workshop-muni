[getReportDataHourly]
select 
	sectionid, sectiontitle, txnyear, txnday, txnhour, 
	sum(closedcount) as closedcount, sum(skipcount) as skipcount 
from ( 
	select 
		section_objid as sectionid, section_title as sectiontitle, 
		convert(enddate, DATE) as txndate, year(enddate) as txnyear, 
		DAYOFMONTH(enddate) as txnday, hour(enddate) as txnhour, 
		(case when state='CLOSED' then 1 else 0 end) as closedcount, 
		(case when state='SKIP' then 1 else 0 end) as skipcount 
	from queue_number_archive 
	where group_objid = $P{groupid} 
		and enddate >= $P{startdate} 
		and enddate <  $P{enddate} 
		and state in ('CLOSED','SKIP')  
		${filter} 
)tmpa 
group by sectionid, sectiontitle, txnyear, txnday, txnhour 
