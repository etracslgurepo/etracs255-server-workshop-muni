[getList]
SELECT * FROM notification WHERE groupid=$P{groupid} ORDER BY dtfiled 

[updateChunkInfo]
UPDATE notification SET 
	chunkcount = (SELECT COUNT(*) FROM notification_data WHERE parentid=$P{objid}), 
	chunksize = (SELECT SUM(contentlength) FROM notification_data WHERE parentid=$P{objid}) 
WHERE 
	objid=$P{objid} 

[removePending]
DELETE FROM notification_pending WHERE objid=$P{objid} 

[removeData]
DELETE FROM notification_data WHERE parentid=$P{parentid} 

[removeForDownload]
DELETE FROM notification_fordownload WHERE objid=$P{objid} 

[removeForProcess]
DELETE FROM notification_forprocess WHERE objid=$P{objid} 

[findPendingMessage]
SELECT p.*, n.chunksize 
FROM notification_pending p 
	INNER JOIN notification n ON n.objid=p.objid 
ORDER BY n.dtfiled 

[getPendingMessages]
SELECT p.*, n.chunksize 
FROM notification_pending p 
	INNER JOIN notification n ON n.objid=p.objid 
ORDER BY n.dtfiled 

[getData]
SELECT b.*, a.origin  
FROM notification_data b 
	INNER JOIN notification a on a.objid=b.parentid 
WHERE b.parentid=$P{parentid} 
	AND b.indexno BETWEEN $P{startindexno} AND $P{endindexno}  
ORDER BY b.indexno 

[getContents]
SELECT * 
FROM notification_data 
WHERE parentid=$P{parentid} 
ORDER BY indexno 

[findData]
SELECT objid FROM notification_data WHERE objid=$P{objid} 

[findHeader]
SELECT objid FROM notification WHERE objid=$P{objid}

[getChannelsForDownload]
select n.channel, n.channelgroup, n.origin 
from notification_fordownload p 
	inner join notification n on n.objid=p.objid 
group by n.channel, n.channelgroup, n.origin 
order by n.channel, n.channelgroup, n.origin 

[findMessageForDownload]
SELECT p.* 
FROM notification_fordownload p 
	INNER JOIN notification n ON n.objid=p.objid 
ORDER BY n.dtfiled 

[findMessageForDownloadByChannel]
select p.* 
from notification_fordownload p 
	inner join notification n on n.objid=p.objid 
where n.channel=$P{channel} 
	and n.channelgroup=$P{channelgroup} 
	and n.origin=$P{origin}
order by n.dtfiled 

[findCheckSum]
SELECT 
	n.objid, n.chunksize, n.chunkcount, 
	(SELECT COUNT(*) FROM notification_data WHERE parentid=n.objid) AS datacount, 
	(SELECT MAX(indexno) FROM notification_data WHERE parentid=n.objid) AS maxindexno, 
	(SELECT SUM(contentlength) FROM notification_data WHERE parentid=n.objid) AS datalength 
FROM notification n 
WHERE n.objid=$P{objid} 

[findMessageForProcess]
SELECT n.*  
FROM notification_forprocess p 
	INNER JOIN notification n ON n.objid=p.objid 
ORDER BY n.dtfiled 

[findAsyncPendingMessage]
SELECT p.*  
FROM notification_async_pending p 
	INNER JOIN notification_async a on a.objid=p.objid 
	INNER JOIN notification n on n.objid=p.objid 
ORDER BY n.dtfiled 

[removeAsyncPending]
DELETE FROM notification_async_pending WHERE objid=$P{objid}
