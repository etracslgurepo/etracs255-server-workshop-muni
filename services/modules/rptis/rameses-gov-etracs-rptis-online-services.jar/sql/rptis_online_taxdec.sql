[getImprovementsByPermitNo]
select x.* 
from (
	select 
		fl.objid, fl.rputype, fl.tdno, fl.displaypin as fullpin, 
		fl.pin, fl.taxpayer_objid, fl.owner_name, fl.owner_address,
		fl.classcode, fl.totalareasqm, fl.totalmv, fl.totalav 
	from bldgrpu br 
	inner join faas_list fl on br.objid = fl.rpuid 
	where br.permitno = $P{permitno}
	and fl.state = 'CURRENT'

	union 

	select 
		fl.objid, fl.rputype, fl.tdno, fl.displaypin as fullpin, 
		fl.pin, fl.taxpayer_objid, fl.owner_name, fl.owner_address,
		fl.classcode, fl.totalareasqm, fl.totalmv, fl.totalav 
	from machrpu mr 
	inner join faas_list fl on mr.objid = fl.rpuid 
	inner join rpu br on mr.bldgmaster_objid = br.rpumasterid
	inner join bldgrpu brr on br.objid = brr.objid 
	where brr.permitno = $P{permitno}
	and fl.state = 'CURRENT'
) x
order by x.pin 


