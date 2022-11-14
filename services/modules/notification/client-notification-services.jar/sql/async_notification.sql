[getPendingList]
SELECT p.* 
FROM async_notification_pending p 
	INNER JOIN async_notification t ON p.objid=t.objid 
	LEFT JOIN async_notification_processing pr ON t.objid=pr.objid 
WHERE pr.objid IS NULL 
ORDER BY t.dtfiled 

[moveToProcessing]
INSERT INTO async_notification_processing ( objid, dtfiled ) 
SELECT a.objid, a.dtretry 
FROM async_notification_pending a 
WHERE a.dtretry <= $P{rundate}  
	AND a.objid NOT IN (SELECT objid FROM async_notification_processing WHERE objid=a.objid)  

[getProcessList]
SELECT * FROM ( 
	SELECT t.*, p.dtfiled as dtprocess, pe.dtretry 
	FROM async_notification_processing p 
		INNER JOIN async_notification_pending pe on p.objid=pe.objid 
		INNER JOIN async_notification t ON p.objid=t.objid 
)xx 
ORDER BY dtfiled 

[getFailedList]
SELECT t.*, p.dtfiled as dtprocess 
FROM async_notification_failed f 
	INNER JOIN async_notification t ON f.refid=t.objid 
ORDER BY t.dtfiled 


[reschedulePending]
UPDATE async_notification_pending SET 
	dtretry=$P{dtretry} 
WHERE 
	objid=$P{objid} 

[removePending]
DELETE FROM async_notification_pending WHERE objid=$P{objid} 

[removeProcess]
DELETE FROM async_notification_processing WHERE objid=$P{objid} 

[removeProcessBefore]
DELETE FROM async_notification_processing WHERE dtfiled <= $P{dtfiled} 

[removeFailed]
DELETE FROM async_notification_failed WHERE refid=$P{refid} 

[removeDelivered]
DELETE FROM async_notification_delivered WHERE refid=$P{refid} 

[findMessage]
SELECT objid FROM async_notification WHERE objid=$P{objid} 
