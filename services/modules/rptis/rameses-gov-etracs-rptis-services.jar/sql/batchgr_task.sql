[findOpenTask]
SELECT * FROM batchgr_task WHERE refid = $P{objid} AND enddate IS NULL 

[findReturnToInfo]
select *
from batchgr_task
where refid = $P{refid}
  and state = $P{state}
order by startdate desc 

[updateTaskAssignee]
UPDATE batchgr_task SET
	assignee_objid = $P{assigneeid},
	assignee_name = $P{assigneename},
	assignee_title = $P{assigneetitle}
WHERE objid = $P{objid}

[closeTask]
UPDATE batchgr_task SET 
	enddate=$P{enddate},
	assignee_name = $P{assigneename},
	assignee_title = $P{assigneetitle},
	actor_name = $P{assigneename},
	actor_title = $P{assigneetitle}
WHERE refid = $P{refid} AND enddate IS NULL 

[getTasks]
select * from batchgr_task where refid = $P{objid}

[removeOpenTask]
delete from batchgr_task where refid = $P{objid} and enddate is null


[findRecommederTask]
select * 
from batchgr_task 
where refid = $P{refid}
and state = 'recommender' 
order by startdate desc 

[getTargetAssignees]
select u.objid, u.name, u.jobtitle as title 
from sys_user u 
inner join sys_usergroup_member  m on u.objid = m.user_objid 
where m.usergroup_objid = $P{role}
order by u.name 