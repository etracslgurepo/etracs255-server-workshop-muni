[getRestrictionAvSummary]
select 
	s.name as lguname,
	frt.objid as restriction_objid, 
	frt.name as restriction_name,
	frt.idx as restriction_idx,
	frt.isother as isother_idx,
	case when frt.isother = 0 then '' else 'OTHERS' end as isother_name,
	sum(r.totalav) as totalav
FROM faas_restriction fr 
	inner join faas_restriction_type frt on fr.restrictiontype_objid = frt.objid 
	inner join faas f on fr.parent_objid = f.objid 
	inner join sys_org s on f.lguid = s.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
where (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
 ${filter}
group by frt.objid, s.name, frt.name, frt.idx, frt.isother
order by s.name, frt.isother, frt.idx