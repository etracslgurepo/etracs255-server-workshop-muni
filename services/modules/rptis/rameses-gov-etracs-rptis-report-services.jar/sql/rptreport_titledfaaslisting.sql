[getTitledProperties]
select 
	b.name as barangay,
	f.state,
	f.tdno,
	r.fullpin,
	f.titleno,
	f.owner_name,
	f.owner_address,
	f.administrator_name, 
	r.totalareasqm,
	r.totalareaha,
	r.totalmv,
	r.totalav,
	rp.cadastrallotno,
	rp.surveyno,
	rp.blockno,
	pc.code as classcode,
	pc.name as classification,
	r.rputype  
from faas f 
	inner join rpu r on f.rpuid = r.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid 
where f.lguid like $P{lguid}
   and rp.barangayid like $P{barangayid}
   and rp.section like $P{section}
   and f.taxpayer_objid like $P{taxpayerid}
   and f.state = 'CURRENT'
   and r.rputype = 'land'
   and f.titleno is not null 
order by b.name, f.tdno  	

