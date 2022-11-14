
#----------------------------------------------------------------------
#
# Real Property Assessment Accomplishment Report 
#
#----------------------------------------------------------------------
[getPreceedingRPAAccomplishment]
SELECT  
	b.objid AS barangayid, 
	b.name AS barangay, 
	SUM( CASE WHEN r.taxable = 1 THEN 1 ELSE 0.0 END ) AS preceedingtaxablecount, 
	SUM( CASE WHEN r.taxable = 1 THEN r.totalav ELSE 0.0 END ) AS preceedingtaxableav, 
	SUM( CASE WHEN r.taxable = 0 THEN 1 ELSE 0.0 END ) AS preceedingexemptcount, 
	SUM( CASE WHEN r.taxable = 0 THEN r.totalav ELSE 0.0 END ) AS preceedingexemptav 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE  (
	(f.dtapproved < $P{startdate} AND f.state = 'CURRENT' ) OR 
	(f.dtapproved < $P{startdate} and f.canceldate >= $P{startdate} AND f.state = 'CANCELLED' )
)
${filter} 
GROUP BY b.objid, b.name , b.indexno 	 
ORDER BY b.indexno 	 


[getCurrentRPAAccomplishment]
SELECT  
	b.objid AS barangayid, 
	b.name AS barangay, 
	SUM( CASE WHEN r.taxable = 1 THEN 1 ELSE 0.0 END) AS currenttaxablecount, 
	SUM( CASE WHEN r.taxable = 1 THEN r.totalav ELSE 0.0 END ) AS currenttaxableav, 
	SUM( CASE WHEN r.taxable = 0 THEN 1 ELSE 0.0 END ) AS currentexemptcount, 
	SUM( CASE WHEN r.taxable = 0 THEN r.totalav ELSE 0.0 END ) AS currentexemptav 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE (
	(f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate} ) 
)
${filter}
GROUP BY b.objid, b.name , b.indexno 	 
ORDER BY b.indexno 	 


[getCancelledRPAAccomplishment]
SELECT  
	b.objid AS barangayid, 
	b.name AS barangay, 
	SUM( CASE WHEN r.taxable = 1 THEN 1 ELSE 0.0 END) AS cancelledtaxablecount, 
	SUM( CASE WHEN r.taxable = 1 THEN r.totalav ELSE 0.0 END ) AS cancelledtaxableav, 
	SUM( CASE WHEN r.taxable = 0 THEN 1 ELSE 0.0 END ) AS cancelledexemptcount, 
	SUM( CASE WHEN r.taxable = 0 THEN r.totalav ELSE 0.0 END ) AS cancelledexemptav 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE f.state = 'CANCELLED' 
  and f.dtapproved is not null 
  and (f.canceldate >= $P{startdate} AND  f.canceldate < $P{enddate} )
  ${filter}
GROUP BY b.objid, b.name , b.indexno 	 
ORDER BY b.indexno 	 


