[getRDAPRPTA100]
SELECT 
	b.pin,
	b.name AS barangay,
	b.indexno, 
	SUM( 1 ) AS landtaxablecount,
	SUM( 1 ) AS landexemptcount,
	SUM( CASE WHEN rp.claimno is null and r.taxable = 1 THEN r.totalareaha ELSE 0.0 END ) AS landareataxable,
	SUM( CASE WHEN rp.claimno is null and r.taxable = 0 THEN r.totalareaha ELSE 0.0 END ) AS landareaexempt,
	SUM( case when rp.claimno is null then r.totalareaha else 0 end ) AS landareatotal,
	SUM( 1 ) AS tdtaxablecount,
	SUM( 1 ) AS tdexemptcount,
	SUM( 1 ) AS tdcount,
	SUM( CASE WHEN r.rputype = 'land' THEN r.totalav ELSE 0.0 END ) AS landavtotal,
	SUM( CASE WHEN r.rputype <> 'land' THEN r.totalav ELSE 0.0 END ) AS improvavtotal,
	SUM( r.totalav ) AS avtotal,
	SUM( CASE WHEN r.taxable = 1 THEN r.totalav ELSE 0.0 END ) AS avtaxable,
	SUM( CASE WHEN r.taxable = 0 THEN r.totalav ELSE 0.0 END ) AS avexempt
FROM faas f 
	INNER JOIN realproperty rp ON rp.objid = f.realpropertyid
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid
WHERE (
	(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
	(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
)
${filter}
GROUP BY b.pin, b.indexno, b.name 
ORDER BY b.pin 


  