[getList]
SELECT * FROM cloud_notification WHERE groupid=$P{groupid} ORDER BY dtfiled 

[getAttachments]
SELECT * FROM cloud_notification_attachment 
WHERE parentid=${objid} 
ORDER BY indexno 

[findPendingDurableMessage]
SELECT p.*  
FROM cloud_notification_pending p 
	INNER JOIN cloud_notification n on p.objid=n.objid 
WHERE NOT(n.messagetype='notification' and n.filetype='async_request') 
ORDER BY n.dtfiled 

[getPendingDurableMessages]
SELECT p.*  
FROM cloud_notification_pending p 
	INNER JOIN cloud_notification n on p.objid=n.objid 
WHERE NOT(n.messagetype='notification' and n.filetype='async_request') 
ORDER BY n.dtfiled 

[getPendingImmediateMessages]
SELECT p.*  
FROM cloud_notification_pending p 
	INNER JOIN cloud_notification n on p.objid=n.objid 
WHERE n.messagetype='notification' and n.filetype='async_request'
ORDER BY n.dtfiled 

[reschedulePending]
UPDATE cloud_notification_pending SET 
	dtretry=$P{dtretry} 
WHERE 
	objid=$P{objid} 

[removePending]
DELETE FROM cloud_notification_pending WHERE objid=$P{objid} 

[removeFailed]
DELETE FROM cloud_notification_failed WHERE refid=$P{refid} 

[removeDelivered]
DELETE FROM cloud_notification_delivered WHERE objid=$P{objid} 

[removeReceived]
DELETE FROM cloud_notification_received WHERE objid=$P{objid} 

[removeData]
DELETE FROM cloud_notification_data WHERE parentid=$P{parentid} 

#
# script for cloud notification listing 
#
[getAllNotifications]
SELECT n.* FROM cloud_notification n ORDER BY n.dtfiled DESC 

[getFailedNotifications]
select distinct n.* 
from cloud_notification_failed f 
	inner join cloud_notification n on f.refid=n.objid 
order by n.dtfiled 

[getPendingNotifications]
select distinct n.* 
from cloud_notification_pending t 
	inner join cloud_notification n on t.objid=n.objid 
order by n.dtfiled 

[getDeliveredNotifications]
select distinct n.* 
from cloud_notification_delivered t 
	inner join cloud_notification n on t.objid=n.objid 
order by n.dtfiled desc 

[findFailedMessage]
select n.*, t.objid as failid, t.reftype 
from cloud_notification_failed t 
	inner join cloud_notification n on t.refid=n.objid 
where t.refid=$P{objid} 

#
# script for uploading failed messages 
#
[getFailedMessages]
select 
	f.*, n.objid as txnid, n.dtfiled as txndate, 
	(select count(*) from cloud_notification_delivered where objid=n.objid) as delivered 
from cloud_notification_failed f 
	inner join cloud_notification n on f.refid=n.objid 
order by n.dtfiled 
