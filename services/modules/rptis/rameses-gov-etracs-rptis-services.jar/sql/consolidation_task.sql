[findOpenTask]
SELECT * FROM consolidation_task WHERE refid = $P{objid} AND enddate IS NULL 
  

[findReturnToInfo]
select *
from consolidation_task
where refid = $P{refid}
  and state = $P{state}
order by startdate desc 

[updateTaskAssignee]
UPDATE consolidation_task SET
	assignee_objid = $P{assigneeid},
	assignee_name = $P{assigneename},
	assignee_title = $P{assigneetitle}
WHERE objid = $P{objid}

[closeTask]
UPDATE consolidation_task SET 
	enddate=$P{enddate},
	assignee_name = $P{assigneename},
	assignee_title = $P{assigneetitle}
WHERE refid = $P{refid} AND enddate IS NULL 

[getTasks]
select * from consolidation_task where refid = $P{objid}

[removeOpenTask]
delete from consolidation_task where refid = $P{objid} and enddate is null

[getTargetAssignees]
select u.objid, u.name, u.jobtitle as title 
from sys_user u 
inner join sys_usergroup_member  m on u.objid = m.user_objid 
where m.usergroup_objid = $P{role}
order by u.name 	