[lookup]
SELECT b.objid, b.state, b.indexno, b.pin, b.name, 'city' AS lgutype
FROM city b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 

[changeState]
UPDATE city SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 

[getById]
SELECT c.*, 'city' AS lgutype FROM city c WHERE objid = $P{objid}