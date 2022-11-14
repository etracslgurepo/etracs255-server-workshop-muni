[getList]
select * from sys_session where userid=$P{userid} 

[getInfo]
select * from sys_session where sessionid=$P{sessionid} 
