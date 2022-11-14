[getTargetAssignees]
select u.objid, u.name, u.jobtitle as title 
from sys_user u 
inner join sys_usergroup_member  m on u.objid = m.user_objid 
where m.usergroup_objid = $P{role}
order by u.name 

[updateTaskAssignee]
UPDATE faas_task SET
	assignee_objid = $P{assigneeid},
	assignee_name = $P{assigneename},
	assignee_title = $P{assigneetitle}
WHERE objid = $P{objid}

[findReturnToInfo]
select *
from rptcertification_task
where refid = $P{refid}
  and state = $P{state}
order by startdate desc 
