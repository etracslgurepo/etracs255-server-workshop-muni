[lookupOfficers]
SELECT 
	a.objid,
	CASE 
		WHEN a.middlename IS NULL THEN CONCAT(a.firstname, ' ', a.lastname)
		ELSE CONCAT(a.firstname, ' ', a.middlename, ' ', a.lastname)
	END AS name,
	jp.title AS title
FROM personnel a
	INNER  JOIN jobposition jp ON a.objid = jp.assigneeid
WHERE ( lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext} ) 
ORDER BY name 



[lookupAppraisers]
SELECT 
	a.objid AS appraisedbyid,
	CASE 
		WHEN a.middlename IS NULL THEN CONCAT(a.firstname, ' ', a.lastname)
		ELSE CONCAT(a.firstname, ' ', a.middlename, ' ', a.lastname)
	END AS appraisedby,
	jp.title AS appraisedbytitle
FROM personnel a
LEFT JOIN jobposition jp ON a.objid = jp.assigneeid
WHERE lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext}


[lookupRecommenders]
SELECT 
	a.objid AS recommendedbyid,
	CASE 
		WHEN a.middlename IS NULL THEN CONCAT(a.firstname, ' ', a.lastname)
		ELSE CONCAT(a.firstname, ' ', a.middlename, ' ', a.lastname)
	END AS recommendedby,
	jp.title AS recommendedbytitle
FROM personnel a
LEFT JOIN jobposition jp ON a.objid = jp.assigneeid
WHERE lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext}



[lookupTaxmappers]
SELECT 
	a.objid AS taxmappedbyid,
	CASE 
		WHEN a.middlename IS NULL THEN CONCAT(a.firstname, ' ', a.lastname)
		ELSE CONCAT(a.firstname, ' ', a.middlename, ' ', a.lastname)
	END AS taxmappedby,
	jp.title AS taxmappedbytitle
FROM personnel a
LEFT JOIN jobposition jp ON a.objid = jp.assigneeid
WHERE lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext}


[lookupApprovers]
SELECT 
	a.objid AS approvedbyid,
	CASE 
		WHEN a.middlename IS NULL THEN CONCAT(a.firstname, ' ', a.lastname)
		ELSE CONCAT(a.firstname, ' ', a.middlename, ' ', a.lastname)
	END AS approvedby,
	jp.title AS approvedbytitle
FROM personnel a
LEFT JOIN jobposition jp ON a.objid = jp.assigneeid
WHERE lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext}
