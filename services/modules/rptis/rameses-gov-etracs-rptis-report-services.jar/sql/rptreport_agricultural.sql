[getItemsByLgu]
select 
	case when c.objid is not null then c.name else m.name end as lguname, 
	lspc.name as specificclass, 
	sum(ld.areaha) as area
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join landdetail ld on r.objid = ld.landrpuid 
	inner join lcuvspecificclass spc on ld.specificclass_objid = spc.objid 
	inner join propertyclassification pc on spc.classification_objid = pc.objid 
	inner join landspecificclass lspc on ld.landspecificclass_objid = lspc.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	left join municipality m on m.objid = f.lguid
	left join city c on c.objid = f.lguid
where f.lguid LIKE $P{lguid}
  and f.state = 'current' 
  and pc.name = 'AGRICULTURAL' 
  and r.taxable = $P{taxable}
group by case when c.objid is not null then c.name else m.name end, lspc.name
order by case when c.objid is not null then c.name else m.name end, lspc.name 


[getItemsByBarangay]
select 
	b.name as lguname,
	lspc.name as specificclass, 
	sum(ld.areaha) as area
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join landdetail ld on r.objid = ld.landrpuid 
	inner join lcuvspecificclass spc on ld.specificclass_objid = spc.objid 
	inner join propertyclassification pc on spc.classification_objid = pc.objid 
	inner join landspecificclass lspc on ld.landspecificclass_objid = lspc.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	left join municipality m on m.objid = f.lguid
	left join city c on c.objid = f.lguid
where f.lguid = $P{lguid}
  and rp.barangayid LIKE $P{barangayid}
  and f.state = 'current' 
  and pc.name = 'AGRICULTURAL' 
  and r.taxable = $P{taxable}
  and rp.section like $P{section}
group by case when c.objid is not null then c.name else m.name end, b.name, lspc.name
order by case when c.objid is not null then c.name else m.name end, b.name, lspc.name 


