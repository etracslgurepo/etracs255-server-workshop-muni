[getFaasValuationRestrictionSummary]
select 
	s.name as municipality,
	sum(r.totalmv) as totalmv,
	sum(r.totalav) as totalav,
	sum(case when fr.objid is null then 0 else r.totalav end) as restrictionav,
	sum(case when fr.objid is null then 0 else r.totalmv end) as restrictionmv
FROM faas f 
	inner join sys_org s on f.lguid = s.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	left join faas_restriction fr on f.objid = fr.parent_objid
	left join faas_restriction_type frt on fr.restrictiontype_objid = frt.objid 
where (
		(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
		(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
  )
and r.taxable = 1 
 ${filter}
group by s.name   
