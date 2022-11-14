[getPin]
SELECT * FROM pin WHERE pin = $P{pin}

[updateLedgerPin]
UPDATE rptledger SET 
	fullpin = $P{newpin},
	municityid = $P{municityid},
	municityname = $P{municityname},
	barangay = $P{barangay} 
WHERE faasid = $P{faasid} 

[updateRealProperty]
UPDATE realproperty SET
	munidistrict = $P{munidistrict},
	barangay = $P{barangay},
	barangayid = $P{barangayid},
	pintype = $P{pintype},
	pin = $P{pin},
	munidistrictindex = $P{munidistrictindex},
	barangayindex = $P{barangayindex},
	section = $P{section},
	parcel = $P{parcel}
WHERE landfaasid = $P{faasid}



[insertPin]
INSERT INTO pin (pin, claimno, docstate) 
VALUES($P{pin}, '-', $P{docstate}) 

[deletePin]
DELETE FROM pin 
WHERE pin = $P{pin} AND claimno = '-'



[findByPinRy]
SELECT * FROM realproperty WHERE pin = $P{pin} AND ry = $P{ry} AND state <> 'CANCELLED'

[modifyRpuPin]
update rpu set 
  fullpin=$P{newpin}, 
  suffix=$P{suffix}, 
  subsuffix=$P{subsuffix}, 
  realpropertyid = $P{realpropertyid}
where objid=$P{rpuid}


[modifySubLedgerPin]
update rptledger rl, rptledger_subledger sl set 
  fullpin = concat($P{newpin}, '-', sl.subacctno),
  barangayid = $P{barangayid}
where faasid = $P{faasid}
and rl.objid = sl.parent_objid

[modifyLedgerPin]
update rptledger set 
  fullpin=$P{newpin},
  barangayid = $P{barangayid}
where faasid = $P{faasid}
and not exists(select * from rptledger_subledger where objid = rptledger.objid)

[modifyFaasPin]
update faas set 
  fullpin=$P{newpin},
  realpropertyid = $P{realpropertyid}
where objid = $P{faasid}

[modifyFaasListPin]
update faas_list set 
  displaypin=$P{newpin},
  pin=$P{pin},
  realpropertyid = $P{realpropertyid},
  barangayid = $P{barangayid},
  barangay = $P{barangayname}
where objid = $P{faasid}

[modifySubdividedLandPin]
update subdividedland set 
  newpin=$P{newpin}
where newfaasid = $P{faasid}

[modifySubdivisionAffectedRpu]
update subdivisionaffectedrpu set 
  newpin=$P{newpin}, newsuffix=$P{suffix}, 
  newrpid = $P{realpropertyid}
where newrpuid=$P{rpuid}


[findFaasInfo]
select objid, fullpin, rpuid, realpropertyid, taxpayer_objid from faas where objid = $P{faasid}


[findLandFaas]
select f.objid, f.realpropertyid, f.rpuid, f.fullpin, rp.pin as rp_pin,
	rp.barangayid as barangay_objid, b.name as barangay_name  
from faas f 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join barangay b on rp.barangayid = b.objid 
where f.objid = $P{landfaasid}


[findLandRpuByPinRy]
SELECT r.objid 
FROM faas f 
	inner join rpu r on f.rpuid = r.objid 
where r.fullpin = $P{pin}	 and r.ry = $P{ry}
and r.rputype = 'land'
and f.state <> 'CANCELLED'
order by r.state 


[modifyBldgLandRpu]
update bldgrpu set landrpuid = $P{landrpuid} where objid = $P{rpuid}

[modifyMachLandRpu]
update machrpu set landrpuid = $P{landrpuid} where objid = $P{rpuid}	

[modifyPlantTreeLandRpu]
update planttreerpu set landrpuid = $P{landrpuid} where objid = $P{rpuid}		

[modifyMiscLandRpu]
update miscrpu set landrpuid = $P{landrpuid} where objid = $P{rpuid}		


[getImprovements]
select x.* 
from (
	select r.objid, r.suffix, r.rputype, f.fullpin, f.objid as faasid
	from faas f 
	inner join bldgrpu br on f.rpuid = br.objid 
	inner join rpu r on br.objid = r.objid 
	where landrpuid = $P{landrpuid}
	and f.state <> 'CANCELLED' 

	union 

	select r.objid, r.suffix, r.rputype, f.fullpin, f.objid as faasid
	from faas f 
	inner join machrpu br on f.rpuid = br.objid 
	inner join rpu r on br.objid = r.objid 
	where landrpuid = $P{landrpuid}
	and f.state <> 'CANCELLED' 

	union 

	select r.objid, r.suffix, r.rputype, f.fullpin, f.objid as faasid
	from faas f 
	inner join planttreerpu br on f.rpuid = br.objid 
	inner join rpu r on br.objid = r.objid 
	where landrpuid = $P{landrpuid}
	and f.state <> 'CANCELLED' 

	union 

	select r.objid, r.suffix, r.rputype, f.fullpin, f.objid as faasid
	from faas f 
	inner join miscrpu br on f.rpuid = br.objid 
	inner join rpu r on br.objid = r.objid 
	where landrpuid = $P{landrpuid}
	and f.state <> 'CANCELLED' 
) x



[deleteTableData]
delete from ${tablename}