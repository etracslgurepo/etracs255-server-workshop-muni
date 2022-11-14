[getTasks]
select * from business_application_task 
where refid=$P{refid} 
order by startdate 

[findCurrentStatus]
select * from business_application_task 
where refid=$P{refid} 
	and enddate is null 
order by startdate 

[findCurrentStatusByAppno]
SELECT bt.state 
FROM business_application_task bt 
INNER JOIN business_application ba ON ba.objid=bt.refid
WHERE ba.appno=$P{appno} AND bt.enddate IS NULL

[findCurrentTaskByAppno]
SELECT bt.objid AS taskid
FROM business_application_task bt 
INNER JOIN business_application ba ON ba.objid=bt.refid
WHERE ba.appno=$P{appno} AND bt.enddate IS NULL

[findCurrentTaskByAppid]
SELECT bt.objid AS taskid, bt.*
FROM business_application_task bt 
INNER JOIN business_application ba ON ba.objid=bt.refid
WHERE ba.objid=$P{applicationid} AND bt.enddate IS NULL

[findStatusByBIN]
SELECT bt.assignee_name, bt.startdate, bt.state, ba.apptype, ba.appno, ba.dtfiled  
FROM business_application_task bt
INNER JOIN business_application ba ON bt.refid=ba.objid 
INNER JOIN business b ON b.objid=ba.business_objid
WHERE b.bin = $P{bin}


[deleteTasks]
DELETE FROM business_application_task WHERE refid=$P{applicationid} 

[findReturnToInfo]
select *
from business_application_task
where refid = $P{refid}
  and state = $P{state}
order by startdate desc 

[findLastTask]
select tsk.* 
from ( 
	select refid, max(startdate) as startdate  
	from business_application_task 
	where refid = $P{refid}   
	group by refid 
)tmp  
	inner join business_application_task tsk on tsk.refid=tmp.refid 
where tsk.startdate=tmp.startdate 
