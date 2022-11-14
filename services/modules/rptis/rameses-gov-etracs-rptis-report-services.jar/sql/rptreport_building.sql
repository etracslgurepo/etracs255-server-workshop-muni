[getRevisionYears]
select distinct ry from bldgrysetting

[getBuildings]
select * 
from vw_building 
where lgu_objid like $P{lguid}
  and state = 'CURRENT'
  and ry = $P{ry}
  and barangay_objid like $P{barangayid}
	and taxpayer_objid like $P{taxpayerid}
	and classification_objid like $P{classificationid}
	and bldgtype_objid like $P{bldgtypeid}
	and bldgkind_objid like $P{bldgkindid}
order by owner_name, tdno
