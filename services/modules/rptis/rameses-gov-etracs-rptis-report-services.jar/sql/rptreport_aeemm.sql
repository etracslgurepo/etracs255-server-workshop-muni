[getTaxablesByClassification]
SELECT 
	'TAXABLE' as taxability,
	pc.objid AS classid,
	SUM( case when rp.claimno is null then 1 else 0 end ) as rpucount,
	SUM( case when rp.claimno is null then r.totalareasqm else 0 end ) as totalareasqm,
	SUM( r.totalmv) as totalmv,
	SUM( r.totalav) as totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
WHERE r.rputype = 'land' 
  AND r.taxable = 1 
  and (
	(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
	(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
 )
  ${filter}
GROUP BY pc.objid, pc.orderno
ORDER BY pc.orderno  


[getExemptsByClassification]
SELECT 
	'EXEMPT' as taxability,
	e.objid AS classid,
	SUM( case when rp.claimno is null then 1 else 0 end ) as rpucount,
	SUM( case when rp.claimno is null then r.totalareasqm else 0 end ) as totalareasqm,
	SUM( r.totalmv) as totalmv,
	SUM( r.totalav) as totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN exemptiontype e ON r.exemptiontype_objid = e.objid 
WHERE r.rputype = 'land' 
  AND r.taxable = 0
  and (
	(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
	(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
 )
GROUP BY e.objid, e.orderno
ORDER BY e.orderno  



[getPropertiesByType]
select x.* 
from 
(
	SELECT 
		case 
			when r.rputype = 'land' then 'LAND'
			when r.rputype = 'bldg' then 'BUILDING'
			when r.rputype = 'mach' then 'MACHINERY'
			else 'OTHERS'
		end as kind, 
		case 
			when r.rputype = 'land' then 1
			when r.rputype = 'bldg' then 2
			when r.rputype = 'mach' then 3
			else 4
		end as idx, 
		SUM(1 ) AS rpucount,
		SUM( case when r.taxable = 1 then r.totalmv else 0 end) as totalmvtaxable,
		SUM( case when r.taxable = 0 then r.totalmv else 0 end) as totalmvexempt,
		SUM( case when r.taxable = 1 then r.totalav else 0 end) as totalavtaxable,
		SUM( case when r.taxable = 0 then r.totalav else 0 end) as totalavexempt
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
		INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	WHERE (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
	 )
	 ${filter}
	GROUP BY r.rputype 
)x
order by x.idx


[getTaxmappings]
SELECT 
	b.name as barangay, 
	sum( 1 ) AS rpucount,
	SUM( case when r.rputype = 'land' and rp.claimno is null then r.totalareasqm else 0 end ) as totalareasqm,
	SUM( r.totalmv) as totalmv,
	SUM( r.totalav) as totalav
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN barangay b on rp.barangayid = b.objid 
WHERE (
	(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
	(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
 )
GROUP BY b.pin, b.name 
ORDER BY b.pin 