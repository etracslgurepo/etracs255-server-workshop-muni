[getCurrentProperties]
select 
	f.objid, 
	f.state,
	f.tdno,
	f.titleno,
	f.fullpin,
	r.rputype,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	rp.cadastrallotno,
	pc.code as classcode,
	r.taxable
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid 
where f.taxpayer_objid = $P{objid}	
  and f.state IN ('CURRENT')
  ${filter}
order by rp.pin, r.suffix 

[getItems]
select 
	f.objid, 
	f.state,
	f.tdno,
	f.titleno,
	f.fullpin,
	f.owner_name,
	f.effectivityyear,
	r.rputype,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	rp.cadastrallotno,
	pc.code as classcode,
	pc.name as classname,
	b.name as barangay_name
from rptcertificationitem rc
	inner join faas f on rc.refid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid 
where rc.rptcertificationid = $P{objid}
order by rp.pin, r.suffix 