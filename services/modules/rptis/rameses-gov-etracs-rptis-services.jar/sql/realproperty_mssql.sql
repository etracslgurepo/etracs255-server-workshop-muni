[getList]
SELECT t.* FROM (
	SELECT rp.*, b.objid AS barangay_objid, b.name AS barangay_name
	FROM realproperty rp
		INNER JOIN barangay b ON rp.barangayid = b.objid 
	WHERE rp.pin LIKE $P{searchtext}
	${filters}

	UNION 

	SELECT rp.*, b.objid AS barangay_objid, b.name AS barangay_name
	FROM realproperty rp
		INNER JOIN barangay b ON rp.barangayid = b.objid 
	WHERE rp.cadastrallotno = $P{cadastrallotno}
	${filters}

	UNION

	SELECT rp.*, b.objid AS barangay_objid, b.name AS barangay_name
	FROM realproperty rp
		INNER JOIN barangay b ON rp.barangayid = b.objid 
	WHERE rp.surveyno = $P{surveyno}
	${filters}

	UNION

	SELECT rp.*, b.objid AS barangay_objid, b.name AS barangay_name
	FROM realproperty rp
		INNER JOIN barangay b ON rp.barangayid = b.objid 
	WHERE b.name = $P{barangay}
	${filters}
) t
ORDER BY barangay_name, pin 

