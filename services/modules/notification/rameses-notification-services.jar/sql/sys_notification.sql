[getList]
SELECT * FROM sys_notification 
WHERE recipientid=$P{recipientid} AND recipienttype=$P{recipienttype} 
ORDER BY dtfiled 

[getAllMessages]
SELECT * FROM sys_notification 
WHERE recipientid IN (${recipientid}) 
ORDER BY dtfiled 

[getMessagesByCustomFilter]
SELECT * FROM sys_notification WHERE ${filter} 
