[getSegments]
SELECT * FROM account_segment 
WHERE objectname=$P{objectname} ORDER BY sortorder

#-----------------------------------------------------
# display each segment
#-----------------------------------------------------
[findSegment]
SELECT a.objid,a.code,a.title
FROM ${objectname}_${segment} i
INNER JOIN ${source} a ON a.objid=i.acctid
WHERE i.objid=$P{objid} 

[addSegment]
INSERT INTO ${objectname}_${segment}
(objid,acctid) VALUES  ($P{objid}, $P{acctid})

[removeSegment]
DELETE FROM ${objectname}_${segment}
WHERE objid=$P{objid} 