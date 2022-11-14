[getList]
SELECT 
	e.*, 
	ej.tin, ej.dtregistered, ej.orgtype, ej.nature, ej.placeregistered, 
	ej.administrator_name, ej.administrator_address, ej.administrator_position 
FROM entity e 
	INNER JOIN entityjuridical ej ON e.objid=ej.objid 
WHERE e.entityname LIKE $P{searchtext} 
ORDER BY e.entityname 

[getLookup]
SELECT e.objid, e.entityno, e.name, e.address_text, e.type, ej.orgtype 
FROM entity e 
INNER JOIN entityjuridical ej ON e.objid=ej.objid 
WHERE e.entityname LIKE $P{searchtext} 
${filter}
ORDER BY e.entityname 

[getPositionList]
SELECT DISTINCT administrator_position AS position FROM entityjuridical 
WHERE administrator_position LIKE $P{searchtext}

[getMatchList]
SELECT e.objid, e.entityno, e.name, e.address_text, e.address_objid 
FROM entityjuridical ej
INNER JOIN entity e ON ej.objid=e.objid 
WHERE e.name LIKE $P{name}


[insertJuridical]
insert into entityjuridical(
	objid,
	tin,
	dtregistered,
	orgtype,
	nature,
	administrator_name,
	administrator_address,
	administrator_position
)
values(
	$P{objid},
	$P{tin},
	$P{dtregistered},
	$P{orgtype},
	$P{nature},
	$P{administrator_name},
	$P{administrator_address},
	$P{administrator_position}
)