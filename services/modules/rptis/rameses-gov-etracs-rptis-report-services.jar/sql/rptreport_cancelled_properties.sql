[getList]
select 
	f.objid,
	f.state, 
	f.owner_name, 
	f.owner_address, 
	f.administrator_name, 
	f.administrator_address, 
	f.tdno, 
	f.fullpin,
	f.titleno, 
	f.effectivityyear, 
	f.prevtdno, 
	f.cancelledbytdnos, 
	f.cancelreason, 
	f.canceldate,
	f.lguid,
	r.rputype, 
	r.totalareaha, 
	r.totalareasqm, 
	r.totalmv, 
	r.totalav, 
	rp.cadastrallotno,  
	rp.blockno, 
	rp.surveyno,
	pc.code as classcode,
	b.name as barangay
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid 
	inner join barangay b on rp.barangayid = b.objid 
where f.lguid = $P{lguid}
and f.state = 'CANCELLED' 
and f.canceldate >= $P{startdate} and f.canceldate < $P{enddate}
${filter}



