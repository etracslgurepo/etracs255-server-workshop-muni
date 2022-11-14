[getLookup]
SELECT * FROM sys_usergroup 
WHERE objid LIKE $P{searchtext}	
	OR domain LIKE $P{searchtext}	
	OR role LIKE $P{searchtext}	


[getRootNodes]
select distinct 
	ug.domain as caption, ug.domain as domain, 
	'' as usergroupid, 'domain' as filetype 
from sys_usergroup ug 
order by ug.domain 


[getChildNodes]
select 
	ug.role as caption, ug.domain as domain, ug.role, 
	ug.objid as usergroupid, 'usergroup-folder' as filetype, 
	ug.orgclass, ug.title 
from sys_usergroup ug 
where ug.domain = $P{domain} 
order by ug.domain, ug.role 


[getList]
select distinct 
	ugm.objid, ugm.usergroup_objid, ugm.user_objid, ugm.user_username, 
	u.lastname as user_lastname, u.firstname as user_firstname, 
	u.middlename as user_middlename, ugm.org_name, 
	sg.name AS securitygroup_name  
from sys_usergroup ug 
	inner join sys_usergroup_member ugm ON ug.objid=ugm.usergroup_objid ${usergroupfilter} 
	inner join sys_user u on u.objid = ugm.user_objid 
	left join sys_securitygroup sg ON ugm.securitygroup_objid=sg.objid 
where ug.domain = $P{domain} 
order by u.firstname, u.lastname, ugm.usergroup_objid 

[getAdminList]
SELECT uga.* FROM sys_usergroup_admin uga
WHERE uga.usergroupid=$P{usergroupid}

[search]
SELECT ugm.objid, su.username, su.name, sg.name AS securitygroup_name, so.name as org_name
FROM sys_usergroup_member ugm
INNER JOIN sys_user su ON su.objid=ugm.user_objid
INNER JOIN sys_securitygroup sg ON ugm.securitygroup_objid=sg.objid 
LEFT JOIN sys_org so ON ugm.org_objid=so.objid
WHERE su.name like $P{name}  

[changeState-approved]
UPDATE sys_usergroup_member SET state='APPROVED' WHERE objid=$P{objid} AND state='DRAFT' 

[getPermissions]
SELECT * FROM sys_usergroup_permission WHERE usergroup_objid=$P{objid}

[removePermissions]
delete FROM sys_usergroup_permission WHERE usergroup_objid=$P{objid}

[findPermission]
SELECT * FROM sys_usergroup_permission 
WHERE object=$P{object} 
	 and permission=$P{permission}
	 and usergroup_objid=$P{usergroupid} 

[findDuplicateWithoutOrg]
SELECT * FROM sys_usergroup_member 
WHERE user_objid=$P{userid} AND usergroup_objid=$P{usergroupid} AND org_objid IS NULL
	
[findDuplicateWithOrg]
SELECT * FROM sys_usergroup_member 
WHERE user_objid=$P{userid} AND usergroup_objid=$P{usergroupid} AND org_objid=$P{orgid}

