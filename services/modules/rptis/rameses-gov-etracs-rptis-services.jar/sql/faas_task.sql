[findOpenTask]
SELECT * FROM faas_task WHERE refid = $P{objid} AND enddate IS NULL 
  

[findReturnToInfo]
select *
from faas_task
where refid = $P{refid}
  and state = $P{state}
order by startdate desc 

[closeTask]
UPDATE faas_task SET 
	enddate=$P{enddate},
	assignee_name = $P{assigneename},
	assignee_title = $P{assigneetitle}
WHERE refid = $P{refid} AND enddate IS NULL 


[updateTaskAssignee]
UPDATE faas_task SET
	assignee_objid = $P{assigneeid},
	assignee_name = $P{assigneename},
	assignee_title = $P{assigneetitle}
WHERE objid = $P{objid}


[getAssignees]
SELECT distinct assignee_objid, assignee_name, assignee_title 
FROM faas_task 
WHERE refid = $P{refid}
  AND assignee_objid IS NOT NULL 
  AND assignee_objid <> $P{assigneeid}
ORDER BY startdate DESC 

[deleteOpenTask]
delete from faas_task where refid = $P{objid} and enddate is null 

[findRecommederTask]
select * 
from faas_task 
where refid = $P{refid}
and state = 'recommender' 
order by startdate desc 


[getTargetAssignees]
select u.objid, u.name, u.jobtitle as title 
from sys_user u 
inner join sys_usergroup_member  m on u.objid = m.user_objid 
where m.usergroup_objid = $P{role}
order by u.name 