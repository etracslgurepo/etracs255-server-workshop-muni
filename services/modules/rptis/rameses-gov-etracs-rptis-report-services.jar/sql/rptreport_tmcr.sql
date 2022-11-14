[findCurrentRy]
select ry from landrysetting order by ry desc 

[getTmcrSimplified]
SELECT
	b.name AS barangay, pc.code AS classcode, 
	f.state,  f.memoranda, f.owner_name, f.owner_address, 
	f.administrator_name, f.administrator_address,
	r.rputype, f.tdno, f.titleno, f.txntype_objid, ft.displaycode as txntype_code,
	rp.cadastrallotno, rp.section, rp.surveyno, rp.blockno, 
	r.fullpin, r.totalareasqm, r.totalareasqm, r.totalav, r.totalmv 
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE rp.ry = $P{ry}
  AND rp.barangayid = $P{barangayid} 
  AND f.state IN ('CURRENT', 'CANCELLED')
  AND rp.section = $P{section} 
  ${txntypefilter}
  ${rputypefilter}
order by  rp.pin, r.suffix, f.tdno


[getTmcrList2]
SELECT
	b.name as barangay, rp.barangayid, rp.section, rp.blockno, 
	r.fullpin, rp.surveyno, f.titleno, r.totalareasqm,
	 pc.code, f.owner_name, f.tdno, f.rpuid, r.rputype,
	 f.txntype_objid, ft.displaycode as txntype_code
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE rp.ry = $P{ry}
  AND rp.barangayid = $P{barangayid} 
  AND f.state IN ('CURRENT', 'CANCELLED')
  AND rp.section LIKE $P{section} 
  ${txntypefilter}
order by  rp.pin, r.suffix, f.tdno



[getCurrentTmcrList]
SELECT ${tmcrfields}
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE rp.ry = $P{ry}
  AND rp.barangayid = $P{barangayid} 
  AND f.state = 'CURRENT'
  AND rp.section = $P{section} 
  ${rputypefilter}
order by  rp.pin, r.suffix, f.tdno


[getCancelledTmcrFaases]
SELECT ${tmcrfields}
FROM faas_previous pf 
	INNER JOIN faas f on pf.prevfaasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE pf.faasid = $P{faasid}
  and f.state = 'CANCELLED'
  ${rputypefilter}
ORDER BY f.tdno DESC   



[getTMCRData]
select 
	f.objid, 
	f.state,
	f.cancelreason, 
	f.canceldate, 
	f.tdno, 
	f.fullpin,
	f.titleno,
	case when pc.code in ('A', 'AGR') or pc.name = 'AGRICULTURAL' then r.totalareaha else r.totalareasqm end as area,
	case when pc.code in ('A', 'AGR') or pc.name = 'AGRICULTURAL' then 'has' else 'sqm' end as areatype,
	rp.surveyno,
	rp.cadastrallotno,
	rp.section,
	rp.blockno, 
	rp.parcel,
	pc.code as classcode,
	f.owner_name, 
	f.administrator_name,
	f.prevtdno,
	f.txntype_objid,
	ft.displaycode as txntype_code, 
	r.ry,
	r.rputype, 
	r.suffix,
	r.rpumasterid,
	r.totalmv,
	r.totalav, 

	case when p.objid is not null then p.name else c.name end as parentlguname, 
	case when p.objid is not null then p.indexno else c.indexno end as parentlguindex,   
	case when m.objid is not null then m.name else d.name end as lguname, 
	case when m.objid is not null then m.indexno else d.indexno end as lguindex,  
	b.name as barangay, 
	b.indexno as barangayindex
from faas f
	inner join rpu r on f.rpuid = r.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join faas_txntype ft on f.txntype_objid = ft.objid 
	left join municipality m on b.parentid = m.objid  
	left join district d on b.parentid = d.objid 
	left join province p on m.parentid = p.objid 
	left join city c on d.parentid = c.objid 
where rp.ry = $P{ry}
  and rp.barangayid = $P{barangayid} 
  and f.state in ('CURRENT', 'CANCELLED')
  and rp.section = $P{section} 
  ${txntypefilter}
  ${rputypefilter}
order by  rp.pin, r.suffix, f.tdno



[findImprovementCount]
select count(*)  as count 
from faas f
	inner join rpu r on f.rpuid = r.objid 
where f.realpropertyid in (
	select xf.realpropertyid 
	from faas xf
		inner join rpu xr on xf.rpuid = xr.objid 
	where xf.objid = $P{objid}
)
and r.rputype = $P{rputype}
and f.state = 'CURRENT' 