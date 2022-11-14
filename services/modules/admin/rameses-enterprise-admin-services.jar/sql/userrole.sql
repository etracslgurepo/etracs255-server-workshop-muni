[getUsers]
SELECT 
	u.objid as objid, 
	u.username as username, 
	u.lastname as lastname,
	u.firstname as firstname,
	u.middlename AS middlename,
	ug.role as role,
	ug.domain,
	ugm.org_name,
	u.jobtitle as title,
	u.txncode
FROM sys_usergroup ug 
	INNER JOIN sys_usergroup_member ugm ON ug.objid=ugm.usergroup_objid 
	INNER JOIN sys_user u ON u.objid=ugm.user_objid 
WHERE ug.domain=$P{domain} 
	AND ug.role IN (${roles}) 
ORDER BY u.lastname, u.firstname 


[getRolesByUser]
SELECT 
	ug.domain,ug.role,
	ugm.exclude AS custom_exclude, 
	sg.exclude AS security_exclude
FROM sys_usergroup_member ugm
	INNER JOIN sys_usergroup ug ON ugm.usergroup_objid=ug.objid
	LEFT JOIN sys_securitygroup sg ON sg.objid=ugm.securitygroup_objid 
WHERE 
	ugm.user_objid=$P{userid} ${filter}


[findPermissionExist]
SELECT 
   up.object,up.permission, ug.role,ug.domain,ugm.user_objid,
   ugm.exclude AS roleexclude, sg.exclude AS securitygroupexclude
FROM sys_usergroup_permission up 
INNER JOIN sys_usergroup ug ON up.usergroup_objid=ug.objid
INNER JOIN sys_usergroup_member ugm ON ugm.usergroup_objid=ug.objid 
LEFT JOIN sys_securitygroup sg ON sg.objid=ugm.securitygroup_objid 
WHERE up.object = $P{object} AND up.permission=$P{action} AND ugm.user_objid=$P{userid}