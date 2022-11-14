[lookup]
SELECT b.*, 'province' AS lgutype
FROM province b 
WHERE b.name LIKE $P{name}  
ORDER BY b.name 

[changeState]
UPDATE province SET 
	state=$P{newstate} 
WHERE 
	objid=$P{objid} AND state=$P{oldstate} 

[getById]
SELECT p.*, 'province' AS lgutype FROM province p WHERE objid = $P{objid}