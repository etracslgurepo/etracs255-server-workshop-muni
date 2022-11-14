[getTaxableSummary]
SELECT
	pc.objid as classid, 
	sum(r.totalmv) as mv,
	sum(r.totalav) as av
FROM faas f 
	INNER JOIN rpu r on f.rpuid = r.objid 
	INNER JOIN realproperty rp on f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc on r.classification_objid = pc.objid 
WHERE f.state IN ('CURRENT', 'CANCELLED')
AND f.dtapproved >= $P{startdate} 
AND f.dtapproved < $P{enddate} 
AND r.taxable = 1
${filter}
GROUP BY pc.objid


[getExemptSummary]
SELECT
	et.objid as classid, 
	sum(r.totalmv) as mv,
	sum(r.totalav) as av
FROM faas f 
	INNER JOIN rpu r on f.rpuid = r.objid 
	INNER JOIN realproperty rp on f.realpropertyid = rp.objid 
	INNER JOIN exemptiontype et on r.exemptiontype_objid = et.objid 
WHERE f.state IN ('CURRENT', 'CANCELLED')
AND f.dtapproved >= $P{startdate} 
AND f.dtapproved < $P{enddate} 
AND r.taxable = 0
${filter}
GROUP BY et.objid