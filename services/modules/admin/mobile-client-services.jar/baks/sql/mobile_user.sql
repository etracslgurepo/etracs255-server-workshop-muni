[findByUsername]
SELECT * FROM sys_user where username=$P{username}  

[findByPrimaryKey]
SELECT * FROM sys_user where objid=$P{objid}  

[incrementLoginCount]
UPDATE sys_user SET 
	pwdlogincount=$P{pwdlogincount}+1 
WHERE  
	username=$P{username} AND pwdlogincount=$P{pwdlogincount} 

[updateLock]
UPDATE sys_user SET lockid=$P{lockid} WHERE username=$P{username} 

[getPermissions]
SELECT  
	ug.domain, ug.role AS role, 
	sg.exclude AS security_exclude, um.exclude AS custom_exclude 
FROM sys_usergroup_member um 
	INNER JOIN sys_usergroup ug ON um.usergroupid = ug.objid 
	INNER JOIN sys_user u ON um.user_objid = u.objid 
	LEFT JOIN sys_securitygroup sg ON um.securitygroupid=sg.objid 
WHERE u.objid = $P{userid} AND um.org_objid IS NULL 	

[getPermissionsByOrg]
SELECT  
	ug.domain, ug.role AS role, 
	sg.exclude AS security_exclude, um.exclude AS custom_exclude, 
	o.objid AS orgid, o.name AS orgname  
FROM sys_usergroup_member um  
	INNER JOIN sys_usergroup ug ON um.usergroupid = ug.objid 
	INNER JOIN sys_user u ON um.user_objid = u.objid 
	INNER JOIN sys_org o ON um.org_objid=o.objid 
	LEFT JOIN sys_securitygroup sg ON um.securitygroupid=sg.objid 
WHERE 
	u.objid=$P{userid} AND 
	(o.name=$P{orgname} OR o.objid=$P{orgname}) 
