[getRevisionYears]
select distinct ry from machrysetting

[getMachineries]
select * 
from vw_machinery 
where lgu_objid like $P{lguid}
  and state = 'CURRENT'
  and ry = $P{ry}
  and barangay_objid like $P{barangayid}
	and taxpayer_objid like $P{taxpayerid}
	and classification_objid like $P{classificationid}
	and machine_objid like $P{machineid}
order by owner_name, tdno
