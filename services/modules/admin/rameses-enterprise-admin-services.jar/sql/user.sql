[getList]
SELECT a.* FROM 
(SELECT objid, pwd, username,lastname,firstname,middlename,jobtitle,txncode, state FROM sys_user u WHERE u.lastname LIKE $P{searchtext} 
UNION 
SELECT objid, pwd, username,lastname,firstname,middlename,jobtitle,txncode, state FROM sys_user u WHERE u.firstname LIKE $P{searchtext} 
UNION 
SELECT objid, pwd, username,lastname,firstname,middlename,jobtitle,txncode, state FROM sys_user u WHERE u.username LIKE $P{searchtext} 
) AS a 
ORDER BY a.lastname, a.firstname

[approve]
UPDATE sys_user SET state='APPROVED' 
WHERE objid=$P{objid} 

[getUsergroups]
SELECT 
	ugm.objid, ugm.org_objid, ugm.org_name, ugm.org_orgclass, ug.domain, ug.role, 
	sg.objid AS securitygroup_objid, sg.name AS securitygroup_name, 
	ug.objid AS usergroup_objid, ug.title AS usergroup_title  
FROM sys_usergroup_member ugm 
	INNER JOIN sys_usergroup ug ON ugm.usergroup_objid=ug.objid 
	LEFT JOIN sys_securitygroup sg ON ugm.securitygroup_objid=sg.objid AND ugm.usergroup_objid=sg.usergroup_objid 
WHERE ugm.user_objid=$P{objid}  
 
[findByUsername]
SELECT * FROM sys_user WHERE username=$P{username} AND (state IS NULL OR state='ACTIVE')

[incrementLoginCount]
UPDATE sys_user SET 
	pwdlogincount=$P{pwdlogincount}+1 
WHERE 
	username=$P{username} and pwdlogincount=$P{pwdlogincount} 

[changePassword]
UPDATE sys_user SET 
    pwd=$P{pwd}, pwdlogincount=$P{pwdlogincount}, 
    pwdexpirydate=$P{pwdexpirydate}, usedpwds=$P{usedpwds} 
WHERE 
    objid=$P{objid} 


