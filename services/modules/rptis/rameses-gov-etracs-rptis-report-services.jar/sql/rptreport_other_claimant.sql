[getList]
select 
	f.objid, 
	b.pin, 
	b.name as barangay,
	f.tdno, 
	f.fullpin,
	f.owner_name, 
	f.administrator_name, 
	pc.code as classcode,
	pc.name as classification, 
	r.totalareaha, 
	r.totalareasqm, 
	r.totalmv, 
	r.totalav,
	rp.cadastrallotno,
	rp.surveyno,
	rp.blockno, 
	rp.claimno,
	f.titleno,
	r.rputype
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 	
	inner join barangay b on rp.barangayid = b.objid 
where rp.claimno is not null 
and f.state = 'current' 
and r.rputype = 'land' 
and f.lguid = $P{lguid}
and rp.barangayid like $P{barangayid}
order by b.pin, f.owner_name 


[getSummary]
select 
	b.pin, 
	b.name as barangay,
	count(*) as rpucount,
	sum(r.totalareaha) as totalareaha, 
	sum(r.totalareasqm) as totalareasqm, 
	sum(r.totalmv) as totalmv, 
	sum(r.totalav) as totalav
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 	
	inner join barangay b on rp.barangayid = b.objid 
where rp.claimno is not null 
and f.state = 'current' 
and r.rputype = 'land' 
and f.lguid = $P{lguid}
and rp.barangayid like $P{barangayid}
group by b.pin, b.name 
order by b.pin
