[getList]
SELECT 
	e.*, ei.gender, ei.birthdate, 
	(SELECT bldgno FROM entity_address WHERE objid=e.address_objid) as address_bldgno, 
	(SELECT bldgname FROM entity_address WHERE objid=e.address_objid) as address_bldgname,  
	(SELECT unitno FROM entity_address WHERE objid=e.address_objid) as address_unitno , 
	(SELECT street FROM entity_address WHERE objid=e.address_objid) as address_street ,  
	(SELECT subdivision FROM entity_address WHERE objid=e.address_objid) as address_subdivision, 
	(SELECT barangay_name FROM entity_address WHERE objid=e.address_objid) as address_barangay_name, 
	(SELECT city FROM entity_address WHERE objid=e.address_objid) as address_city, 
	(SELECT municipality FROM entity_address WHERE objid=e.address_objid) as address_municipality, 
	(SELECT province FROM entity_address WHERE objid=e.address_objid) as address_province 
FROM entity e 
	INNER JOIN entityindividual ei ON e.objid=ei.objid 
WHERE e.entityname LIKE $P{searchtext}  
ORDER BY e.entityname 

[getLookup]
SELECT 
	e.*, ei.gender, ei.birthdate,  
	(SELECT bldgno FROM entity_address WHERE objid=e.address_objid) as address_bldgno, 
	(SELECT bldgname FROM entity_address WHERE objid=e.address_objid) as address_bldgname,  
	(SELECT unitno FROM entity_address WHERE objid=e.address_objid) as address_unitno , 
	(SELECT street FROM entity_address WHERE objid=e.address_objid) as address_street ,  
	(SELECT subdivision FROM entity_address WHERE objid=e.address_objid) as address_subdivision, 
	(SELECT barangay_name FROM entity_address WHERE objid=e.address_objid) as address_barangay_name, 
	(SELECT city FROM entity_address WHERE objid=e.address_objid) as address_city, 
	(SELECT municipality FROM entity_address WHERE objid=e.address_objid) as address_municipality, 
	(SELECT province FROM entity_address WHERE objid=e.address_objid) as address_province 
FROM entity e 
	INNER JOIN entityindividual ei ON e.objid=ei.objid 
WHERE e.entityname LIKE $P{searchtext}  
ORDER BY e.entityname 

[getMatchList]
SELECT ei.objid, e.entityno, ei.lastname, ei.firstname, ei.middlename, 
ei.birthdate, ei.gender, e.name, e.address_objid, e.address_text 
FROM entityindividual ei
INNER JOIN entity e ON e.objid=ei.objid
WHERE ei.lastname LIKE $P{lastname}

[findPhoto]
SELECT photo FROM entityindividual WHERE objid=$P{objid}

[updatePhoto]
UPDATE entityindividual SET photo=$P{photo}, thumbnail=$P{thumbnail} WHERE objid=$P{objid}

[findThumbnail]
SELECT thumbnail FROM entityindividual WHERE objid=$P{objid}


[updateName]
UPDATE entityindividual 
SET firstname=$P{firstname}, 
lastname=$P{lastname}, 
middlename=$P{middlename} 
WHERE objid=$P{objid}


[insertIndividual]
insert into entityindividual (
	objid,
	lastname,
	firstname,
	middlename,
	birthdate,
	birthplace,
	citizenship,
	gender,
	civilstatus,
	religion,
	profession,
	photo,
	thumbnail,
	tin,
	sss
)
values(
	$P{objid},
	$P{lastname},
	$P{firstname},
	$P{middlename},
	$P{birthdate},
	$P{birthplace},
	$P{citizenship},
	$P{gender},
	$P{civilstatus},
	$P{religion},
	$P{profession},
	$P{photo},
	$P{thumbnail},
	$P{tin},
	$P{sss}
)