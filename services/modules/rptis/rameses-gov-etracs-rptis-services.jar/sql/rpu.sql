[createRpuMaster]
INSERT INTO rpumaster(objid, currentfaasid, currentrpuid) 
VALUES($P{objid}, $P{currentfaasid}, $P{currentrpuid})


[deleteRpuMaster]
DELETE FROM rpumaster WHERE objid = $P{objid}

[findRpuMasterById]
SELECT * FROM rpumaster WHERE objid = $P{objid}


[findDuplicateFullPin]
SELECT objid   
FROM faas_list
WHERE rpuid <> $P{objid} AND ry = $P{ry} AND pin = $P{fullpin} 
AND state <> 'CANCELLED'


[deleteRpu]
DELETE FROM rpu WHERE objid = $P{objid}


[deleteAllAssessments]
DELETE FROM rpu_assessment WHERE rpuid = $P{objid}


[findRpuInfoById]
SELECT * FROM rpu WHERE objid = $P{objid}


[findLandRpuById]
SELECT *
FROM rpu 
WHERE objid = $P{objid}


[findLandRpuByRealPropertyId]
SELECT rpu.*
FROM rpu rpu
  INNER JOIN realproperty rp ON rpu.realpropertyid = rp.objid 
WHERE rpu.realpropertyid = $P{realpropertyid} 
  AND rpu.rputype = 'land' 


[updateRpuState]
UPDATE rpu SET state = $P{state} WHERE objid = $P{objid}


[getNextSuffixes]
SELECT 
  rputype,
  MAX(suffix +1) AS nextsuffix 
FROM rpu 
WHERE realpropertyid = $P{realpropertyid}
AND rputype <> 'land'
GROUP BY rputype 

[findNextSuffix]
SELECT 
  MAX(r.suffix + 1) AS suffix,
  MAX(case when r.subsuffix is null then 1 else r.subsuffix + 1 end) AS subsuffix
FROM faas f 
  inner join rpu r on f.rpuid = r.objid 
WHERE f.realpropertyid = $P{realpropertyid}
AND r.rputype = $P{rputype}
GROUP BY r.rputype 


[updateSuffix]
UPDATE rpu SET suffix = $P{suffix}, fullpin = $P{fullpin} WHERE objid = $P{objid}


[getLandImprovementsRpuByRealPropertyId]
SELECT f.objid as faasid, rpu.objid, rpu.suffix, f.fullpin, rpu.rputype  
FROM rpu rpu
  INNER JOIN realproperty rp ON rpu.realpropertyid = rp.objid 
  INNER JOIN faas f ON rpu.objid = f.rpuid 
WHERE f.realpropertyid = $P{realpropertyid} 
  AND f.state <> 'CANCELLED'
  AND rpu.rputype != 'land'   


[findLandRySetting]
select objid from landrysetting where ry = $P{ry}



[findImprovementByRpuId]
select f.objid, f.rpuid, f.realpropertyid, f.fullpin, rp.pin, rp.ry 
from faas f 
inner join bldgrpu br on f.rpuid = br.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.rpuid = $P{objid}

union 

select f.objid, f.rpuid, f.realpropertyid, f.fullpin, rp.pin, rp.ry 
from faas f 
inner join machrpu br on f.rpuid = br.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.rpuid = $P{objid}

union 

select f.objid, f.rpuid, f.realpropertyid, f.fullpin, rp.pin, rp.ry 
from faas f 
inner join miscrpu br on f.rpuid = br.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.rpuid = $P{objid}

union 

select f.objid, f.rpuid, f.realpropertyid, f.fullpin, rp.pin, rp.ry 
from faas f 
inner join planttreerpu br on f.rpuid = br.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.rpuid = $P{objid}


[findLandFaasByPin]
select f.objid, f.rpuid, f.realpropertyid 
from realproperty rp 
inner join faas f on rp.objid = f.realpropertyid
inner join rpu r on f.rpuid = r.objid 
where rp.pin = $P{pin} and rp.ry = $P{ry}
and r.rputype = 'land'


[updateBldgLandRpuId]
update bldgrpu set 
	landrpuid = $P{landrpuid}
where objid = $P{objid}	

[updateMachLandRpuId]
update machrpu set 
	landrpuid = $P{landrpuid}
where objid = $P{objid}	

[updateMiscLandRpuId]
update miscrpu set 
	landrpuid = $P{landrpuid}
where objid = $P{objid}	

[updatePlantTreeLandRpuId]
update planttreerpu set 
	landrpuid = $P{landrpuid}
where objid = $P{objid}	
