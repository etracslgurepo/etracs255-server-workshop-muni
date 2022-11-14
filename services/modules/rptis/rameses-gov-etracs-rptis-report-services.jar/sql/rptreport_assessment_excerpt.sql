[findExcerpt]
select 
	SUM( case when 'av' = $P{type} then x.taxableav else x.taxablemv end ) AS taxable,
	SUM( x.taxablecnt ) AS taxablecnt,
	SUM( case when 'av' = $P{type} then x.exemptav else x.exemptmv end ) AS exempt,
	SUM( x.exemptcnt ) AS exemptcnt
from (

	SELECT 
		r.totalav as taxableav, 
		r.totalmv as taxablemv, 
		1 as taxablecnt, 
		0 as exemptav, 
		0 as exemptmv, 
		0 as exemptcnt
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
		INNER JOIN barangay b ON rp.barangayid = b.objid 
	WHERE ${filter}
    and f.state = $P{state}
		AND r.taxable = 1 

	union all 

	SELECT 
		0 as taxableav, 
		0 as taxablemv, 
		0 as taxablecnt, 
		r.totalav as exemptav, 
		r.totalmv as exemptmv, 
		1 as exemptcnt
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
		LEFT JOIN exemptiontype e ON r.exemptiontype_objid = e.objid 
		INNER JOIN barangay b ON rp.barangayid = b.objid 
	WHERE ${filter}
    and f.state = $P{state}
		AND r.taxable = 0
) x 


