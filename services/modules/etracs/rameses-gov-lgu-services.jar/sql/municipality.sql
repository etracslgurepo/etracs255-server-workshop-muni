[getList]
SELECT b.*, 'municipality' AS lgutype, b.pin AS code
FROM municipality b 
WHERE b.name LIKE $P{name}  OR b.parentid LIKE $P{parentid}
ORDER BY b.name 


[lookup]
SELECT b.*, 'municipality' AS lgutype
FROM municipality b 
WHERE b.name LIKE $P{name}  OR b.parentid LIKE $P{parentid}
ORDER BY b.name 

[changeState]
UPDATE municipality SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 


[getById]
SELECT m.*, 'municipality' AS lgutype FROM municipality m WHERE objid = $P{objid}