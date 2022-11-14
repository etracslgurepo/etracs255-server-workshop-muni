[getAfSerials]
select af.objid as formno, af.* 
from af 
where formtype = 'serial' 
order by objid 


[getSubmittedBatches]
select t1.* 
from (
	select 
		bc.objid, bc.state, bc.formno, bc.collector_name, bc.capturedby_name, bc.collectiontype_name, 
		MIN(bce.series) AS issuedstartseries, MAX(bce.series) AS issuedendseries,
		SUM(CASE WHEN bce.voided = 0 THEN bce.totalcash ELSE 0 END ) AS totalcash,
		SUM(CASE WHEN bce.voided = 0 THEN bce.totalnoncash ELSE 0 END ) AS totalnoncash,
		SUM(CASE WHEN bce.voided = 0 THEN bce.amount ELSE 0 END ) AS amount,
		SUM(CASE WHEN bce.voided = 0 THEN 0 ELSE 1 END) AS voidcount, 
		afc.startseries as sortseries 
	from batchcapture_collection bc
		inner join af_control afc on afc.objid = bc.controlid 
		inner join batchcapture_collection_entry bce ON bce.parentid = bc.objid 
	where bc.collector_objid = $P{collectorid} 
		and bc.state IN ('FORPOSTING', 'POSTED') 
	group by bc.objid, bc.state, bc.formno, bc.collector_name, 
		bc.capturedby_name, bc.collectiontype_name, afc.startseries 
)t1
where 1=1 ${filter} 
order by t1.formno, t1.sortseries 
