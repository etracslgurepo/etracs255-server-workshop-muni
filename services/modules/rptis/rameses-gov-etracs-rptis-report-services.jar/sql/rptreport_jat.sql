[getJAT]
SELECT 
	x.*
FROM (
	SELECT 
		1 as idx, 
		b.name AS barangay, 
		f.dtapproved AS txndate, 
		f.tdno, r.fullpin, f.titleno, f.prevtdno,
		f.txntype_objid AS txntype, f.owner_name, f.administrator_name, r.rputype, pc.code AS classcode, 
		r.totalareaha, r.totalareasqm, r.totalmv, r.totalav, 'CURRENT' as state, 
		rp.ry, rp.section, rp.cadastrallotno, rp.pin, r.suffix,
		case when r.taxable = 1 then 'T' else 'E' end as taxability,
		e.name as exemptiontype, 
		e.code as exemptiontypecode 
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
		INNER JOIN barangay b ON rp.barangayid = b.objid 
		LEFT JOIN exemptiontype e on r.exemptiontype_objid = e.objid 
	WHERE rp.barangayid like $P{barangayid} 
	  AND rp.ry = $P{ry}
	  AND f.dtapproved >= $P{startdate} AND f.dtapproved < $P{enddate}

	  union 

	  SELECT 
	  	2 as idx, 
		b.name AS barangay, 
		f.canceldate AS txndate, 
		f.tdno, r.fullpin, f.titleno, f.prevtdno,
		f.txntype_objid AS txntype, f.owner_name, f.administrator_name, r.rputype, pc.code AS classcode, 
		r.totalareaha, r.totalareasqm, r.totalmv, r.totalav, 'CANCELLED' as state, 
		rp.ry, rp.section, rp.cadastrallotno, rp.pin, r.suffix,
		case when r.taxable = 1 then 'T' else 'E' end as taxability,
		e.name as exemptiontype, 
		e.code as exemptiontypecode 
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
		INNER JOIN barangay b ON rp.barangayid = b.objid 
		LEFT JOIN exemptiontype e on r.exemptiontype_objid = e.objid 
	WHERE rp.barangayid like $P{barangayid} 
	  AND rp.ry = $P{ry}
	  AND f.canceldate >= $P{startdate} AND f.canceldate < $P{enddate}
)x 
ORDER BY x.barangay, x.txndate, x.pin, x.suffix
