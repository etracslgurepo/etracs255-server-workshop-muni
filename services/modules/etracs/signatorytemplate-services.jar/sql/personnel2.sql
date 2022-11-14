[getList]
SELECT 
	p.objid, p.firstname, p.middlename, p.lastname, j.title, o.title as department 
FROM personnel p 
INNER JOIN jobposition j ON j.assigneeid = p.objid 
inner join orgunit o on o.objid = j.orgunitid 
WHERE p.lastname LIKE $P{searchtext} OR p.firstname LIKE $P{searchtext} 
ORDER BY p.lastname, p.firstname 