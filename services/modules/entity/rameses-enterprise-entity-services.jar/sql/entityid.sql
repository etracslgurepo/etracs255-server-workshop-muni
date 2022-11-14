[getList]
SELECT * FROM entityid
WHERE entityid = $P{entityid}

[findDuplicate]
SELECT e.objid, e.name, e.entityno 
FROM entity e
INNER JOIN entityid ei ON ei.entityid=e.objid
WHERE ei.idtype = $P{idtype} AND ei.idno = $P{idno}