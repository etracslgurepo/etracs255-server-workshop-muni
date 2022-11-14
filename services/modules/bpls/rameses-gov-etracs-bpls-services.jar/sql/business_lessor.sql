[getList]
SELECT * FROM ( 
	SELECT * FROM business_lessor bl 
	WHERE CONCAT(bldgname, IFNULL(street,'')) LIKE $P{searchtext} 
		AND government=$P{government} 
	UNION
	SELECT * FROM business_lessor bl 
	WHERE lessor_name LIKE $P{searchtext} 
		AND government=$P{government} 
	UNION
	SELECT * FROM business_lessor bl 
	WHERE lessor_address_text LIKE $P{searchtext} 
		AND government=$P{government} 
)bl 

[getListByOwner]
SELECT bl.*, 
	CASE 
	    WHEN b.expirydate IS NULL THEN 'PROCESSING'
	    WHEN b.state = 'PROCESSING'  THEN 'PROCESSING'
	    WHEN b.expirydate < $P{today} THEN 'EXPIRED'
	    ELSE 'ACTIVE'
	END AS status
FROM ( 
	SELECT objid FROM business_lessor bl 
	WHERE lessor_objid = $P{ownerid} 
		AND bldgname LIKE $P{searchtext} 
	UNION
	SELECT objid FROM business_lessor bl 
	WHERE lessor_objid = $P{ownerid} 
		AND lessor_name LIKE $P{searchtext} 
	UNION
	SELECT objid FROM business_lessor bl 
	WHERE lessor_objid = $P{ownerid} 
		AND lessor_address_text LIKE $P{searchtext} 
)x  
	INNER JOIN business_lessor bl ON x.objid=bl.objid 
	LEFT JOIN business_address ba ON ba.ownedaddressid=bl.objid 
	LEFT JOIN business b ON ba.businessid=b.objid 


[getListByLessor]
SELECT * FROM business_lessor 
WHERE lessor_objid=$P{ownerid}
