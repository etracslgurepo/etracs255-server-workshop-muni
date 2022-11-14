[getRyListLAND]
SELECT s.* 
FROM landrysetting s
	INNER JOIN rysetting_lgu r ON s.objid = r.rysettingid
WHERE r.lguid = $P{lguid}
  AND s.ry > $P{ry}


[getRyListBLDG]
SELECT s.* 
FROM bldgrysetting s
	INNER JOIN rysetting_lgu r ON s.objid = r.rysettingid
WHERE r.lguid = $P{lguid}
  AND s.ry > $P{ry}  


[getRyListMACH]
SELECT s.* 
FROM machrysetting s
	INNER JOIN rysetting_lgu r ON s.objid = r.rysettingid
WHERE r.lguid = $P{lguid}
  AND s.ry > $P{ry}    


[getRyListPLANTTREE]
SELECT s.* 
FROM planttreerysetting s
	INNER JOIN rysetting_lgu r ON s.objid = r.rysettingid
WHERE r.lguid = $P{lguid}
  AND s.ry > $P{ry}    


[getRyListMISC]
SELECT s.* 
FROM miscrysetting s
	INNER JOIN rysetting_lgu r ON s.objid = r.rysettingid
WHERE r.lguid = $P{lguid}
  AND s.ry > $P{ry}    



[findCurrentRevisedLandRpu]
SELECT rpu.objid, rpu.realpropertyid
FROM rpu rpu
	INNER JOIN landrpu lr ON rpu.objid = lr.objid 
WHERE rpu.objid = $P{objid}
 AND rpu.ry = $P{ry}  

[findCurrentRevisedLandRpuByPin]
SELECT rpu.objid, rpu.realpropertyid
FROM rpu rpu
	INNER JOIN landrpu lr ON rpu.objid = lr.objid 
	inner join realproperty rp on rpu.realpropertyid = rp.objid
WHERE rp.pin = $P{pin}
 AND rpu.ry = $P{ry}  


[findRevisedLandRpu]
SELECT rpu.objid, rpu.realpropertyid
FROM rpu rpu
	INNER JOIN landrpu lr ON rpu.objid = lr.objid 
WHERE rpu.previd = $P{previd}
 AND rpu.ry = $P{ry}   


[findRevisedLandByRealPropertyId]
SELECT rpu.objid, rpu.realpropertyid
FROM rpu rpu
	INNER JOIN landrpu lr ON rpu.objid = lr.objid 
WHERE rpu.realpropertyid = $P{realpropertyid}
 AND rpu.ry = $P{ry}


[findNonCurrentCount]
select count(*) as count 
from realproperty rp 
	inner join faas f on rp.objid = f.realpropertyid 
	inner join rpu r on f.rpuid = r.objid 
where rp.barangayid = $P{barangayid}
and rp.ry = $P{ry}
and rp.section = $P{section}
and r.rputype = 'land'
and f.state not in ('CURRENT', 'CANCELLED')


[getLandsForRepinning]
select f.objid, f.rpuid, f.realpropertyid, f.tdno, rp.pin, rp.barangayid, rp.pintype  
from realproperty rp 
	inner join faas f on rp.objid = f.realpropertyid 
	inner join rpu r on f.rpuid = r.objid 
where rp.barangayid = $P{barangayid}
and rp.ry = $P{ry}
and rp.section = $P{section}
and r.rputype = 'land'
and f.state = $P{state}
${orderby}


[getImprovementsForRepinning]
select f.objid, f.rpuid, f.fullpin, r.suffix 
from faas f 
	inner join rpu r on f.rpuid = r.objid 
where f.realpropertyid = $P{rpid}
and r.rputype = $P{rputype}
and f.state not in ('CANCELLED')
order by r.suffix 



[getFaasForApproval]
select f.objid, f.state, f.tdno, f.fullpin
from realproperty rp 
	inner join faas f on rp.objid = f.realpropertyid 
	inner join rpu r on f.rpuid = r.objid 
where rp.barangayid = $P{barangayid}
and rp.ry = $P{ry}
and rp.section = $P{section}
and f.state not in ('CANCELLED')
order by rp.pin, r.suffix 