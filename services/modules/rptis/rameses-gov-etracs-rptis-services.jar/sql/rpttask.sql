[getAssignees]
select distinct 
	u.objid, u.lastname, u.firstname, u.middlename, u.jobtitle
from sys_user u
	inner join sys_usergroup_member m on u.objid = m.user_objid
	inner join sys_usergroup g on m.usergroup_objid = g.objid 
where g.domain = 'RPT' 
and g.role = $P{role}
and u.objid <> $P{assigneeid}
order by u.lastname, u.firstname, u.middlename 
