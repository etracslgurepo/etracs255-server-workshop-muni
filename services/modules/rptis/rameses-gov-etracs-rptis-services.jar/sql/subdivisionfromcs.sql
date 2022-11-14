[getConsolidatedLands]
SELECT cl.*,
	f.tdno AS faas_tdno,
	f.owner_name AS faas_owner_name, 
	r.realpropertyid AS rpu_realpropertyid,
	r.fullpin AS rpu_fullpin,
	r.totalmv AS rpu_totalmv,
	r.totalav AS rpu_totalav,
	r.totalareaha AS rpu_totalareaha,
	r.totalareasqm AS rpu_totalareasqm,
	rp.barangayid,
	rp.lguid,
	rp.lgutype
FROM subdivision_consolidatedland cl
	INNER JOIN faas f ON cl.landfaasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE cl.subdivisionid = $P{subdivisionid}
ORDER BY r.fullpin 


[findDuplicateConsolidatedLand]
SELECT * 
FROM subdivision_consolidatedland 
WHERE subdivisionid = $P{subdivisionid} 
  AND landfaasid = $P{landfaasid}



[getAffectedRpusByConsolidatedLandId]
SELECT 
	r.objid,
	r.rputype 
FROM subdivisionaffectedrpu arpu
	INNER JOIN rpu r ON arpu.newrpuid = r.objid 
WHERE arpu.landfaasid = $P{landfaasid}  

[deleteAffectedRpuByLandFaasId]
DELETE FROM subdivisionaffectedrpu WHERE landfaasid = $P{landfaasid}


[getAffectedRpusByConsolidatedLand]
SELECT 
	f.objid AS objid,
	f.state, 
	f.tdno,
	f.utdno,
	$P{subdivisionid} AS subdivisionid,
	f.objid AS prevfaasid,
	r.objid AS prevrpuid, 
	r.suffix AS newsuffix,
	r.rputype,
	fl.objid AS landfaasid,
	ledger.state AS ledgerstate
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN rpu rl ON r.realpropertyid = rl.realpropertyid
	INNER JOIN faas fl ON rl.objid = fl.rpuid 	
	LEFT JOIN rptledger ledger ON f.objid = ledger.faasid 
WHERE r.realpropertyid = $P{realpropertyid}
  AND r.rputype <> 'land' 
  AND rl.rputype = 'land'
  AND f.state <> 'CANCELLED' 
  AND fl.state = 'CURRENT'
  AND NOT EXISTS(SELECT * FROM subdivisionaffectedrpu WHERE prevfaasid = f.objid )


[findBarangayFromConsolidatedLands]
SELECT DISTINCT rp.barangayid 
FROM subdivision_consolidatedland sc 
	INNER JOIN realproperty rp ON sc.rpid = rp.objid 
WHERE sc.subdivisionid = $P{subdivisionid}




[cancelRealProperty]
UPDATE realproperty SET state = 'CANCELLED' WHERE objid = $P{objid}


[cancelLandLedger]
UPDATE rptledger SET state = 'CANCELLED' WHERE faasid = $P{faasid}

