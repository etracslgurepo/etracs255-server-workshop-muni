[getList]
SELECT 
	m.*,
	f.tdno AS prevfaas_tdno,
	rpu.ry AS prevfaas_ry,
	rpu.fullpin AS prevfaas_pin,
	rp.claimno AS prevfaas_claimno,
	e.name  AS prevfaas_taxpayer_name,
	e.address_text AS prevfaas_taxpayer_address,
	rp.cadastrallotno AS prevfaas_cadastrallotno,
	rp.surveyno AS prevfaas_surveyno,
	nf.tdno AS newfaas_tdno
FROM mcsettlement m 
	INNER JOIN faas f ON m.prevfaas_objid = f.objid 
	INNER JOIN rpu rpu ON f.rpuid = rpu.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	LEFT JOIN faas nf ON m.newfaas_objid = nf.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
WHERE (f.tdno LIKE $P{searchtext} OR rp.pin LIKE $P{searchtext})



[findById]
SELECT 
	m.*,
	f.tdno AS prevfaas_tdno,
	rpu.objid AS prevfaas_rpuid,
	rpu.ry AS prevfaas_ry,
	rpu.fullpin AS prevfaas_pin,
	rp.claimno AS prevfaas_claimno,
	e.name  AS prevfaas_taxpayer_name,
	e.address_text AS prevfaas_taxpayer_address,
	rp.objid AS prevfaas_realpropertyid,
	rp.cadastrallotno AS prevfaas_cadastrallotno,
	rp.surveyno AS prevfaas_surveyno,
	nf.tdno AS newfaas_tdno
FROM mcsettlement m 
	INNER JOIN faas f ON m.prevfaas_objid = f.objid 
	INNER JOIN rpu rpu ON f.rpuid = rpu.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	LEFT JOIN faas nf ON m.newfaas_objid = nf.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
WHERE m.objid = $P{objid}


[getOtherClaims]
SELECT
	mo.*,
	f.tdno,
	rp.pin,
	rp.claimno,
	f.owner_name,
	f.owner_address,
	r.totalmv,
	r.totalav 
FROM mcsettlement_otherclaim mo
	INNER JOIN faas f ON mo.faas_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
WHERE mo.mcsettlementid = $P{objid}
ORDER BY rp.pin 


[getAffectedRpus]
SELECT
	ma.*,
	r.rputype,
	f.tdno,
	r.fullpin,
	f.owner_name,
	f.owner_address,
	r.totalmv,
	r.totalav 
FROM mcsettlement_affectedrpu ma
	INNER JOIN faas f ON ma.prevfaas_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
WHERE ma.mcsettlementid = $P{objid}
ORDER BY r.fullpin 


[getOpenOtherClaims]
SELECT
	ocf.objid AS faas_objid
FROM faas wf 
	INNER JOIN realproperty wrp ON wf.realpropertyid = wrp.objid
	INNER JOIN realproperty ocrp ON wrp.pin = ocrp.pin 
	INNER JOIN faas ocf ON ocrp.objid = ocf.realpropertyid 
	INNER JOIN rpu ocr ON ocf.rpuid = ocr.objid 
WHERE wf.objid like $P{objid}
  AND wf.state = 'CURRENT'
  AND ocf.state = 'CURRENT' 
  AND wf.objid <> ocf.objid 
  AND ocr.rputype = 'land' 
  AND NOT EXISTS(
	SELECT * FROM mcsettlement_otherclaim WHERE faas_objid = ocf.objid 
  )  


[getOpenAffectedRpus]
SELECT
	af.objid AS faas_objid
FROM faas wf 
	INNER JOIN realproperty wrp ON wf.realpropertyid = wrp.objid
	INNER JOIN realproperty arp ON wrp.pin = arp.pin 
	INNER JOIN faas af ON arp.objid = af.realpropertyid 
	INNER JOIN rpu ocr ON af.rpuid = ocr.objid 
WHERE wf.objid like $P{objid}
  AND wf.state = 'CURRENT'
  AND af.state = 'CURRENT' 
  AND wf.objid <> af.objid 
  AND ocr.rputype <> 'land' 
  AND NOT EXISTS(
	SELECT * FROM mcsettlement_affectedrpu WHERE prevfaas_objid = af.objid 
  )


[deleteOtherClaims]
DELETE FROM mcsettlement_otherclaim WHERE mcsettlementid = $P{objid}


[deleteAffectedRpus]
DELETE FROM mcsettlement_affectedrpu WHERE mcsettlementid = $P{objid}


[updateState]
UPDATE mcsettlement SET state = $P{state} WHERE objid = $P{objid} AND state = $P{prevstate}


[cancelOtherClaimFaas]
UPDATE f SET
	f.state = 'CANCELLED',
	f.cancelreason = $P{cancelreason},
	f.canceldate	= $P{canceldate},
	f.cancelledbytdnos = $P{cancelledbytdnos}
FROM mcsettlement mc 
	INNER JOIN mcsettlement_otherclaim mo ON mc.objid = mo.mcsettlementid
	INNER JOIN faas f ON mo.faas_objid = f.objid 
WHERE mc.objid = $P{objid} 


[cancelOtherClaimLedger]
UPDATE rl SET
	rl.state = 'CANCELLED'
FROM mcsettlement mc 
	INNER JOIN mcsettlement_otherclaim mo ON mc.objid = mo.mcsettlementid
	INNER JOIN faas f ON mo.faas_objid = f.objid 
	INNER JOIN rptledger rl ON f.objid = rl.faasid 
WHERE mc.objid = $P{objid} 


[cancelOtherClaimRpu]
UPDATE r SET
	r.state = 'CANCELLED'
FROM mcsettlement mc 
	INNER JOIN mcsettlement_otherclaim mo ON mc.objid = mo.mcsettlementid
	INNER JOIN faas f ON mo.faas_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
WHERE mc.objid = $P{objid} 


[cancelOtherClaimRealProperty]
UPDATE rp SET
	rp.state = 'CANCELLED'
FROM mcsettlement mc 
	INNER JOIN mcsettlement_otherclaim mo ON mc.objid = mo.mcsettlementid
	INNER JOIN faas f ON mo.faas_objid = f.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE mc.objid = $P{objid} 




[findTrackingNo]
SELECT trackingno FROM rpttracking WHERE objid = $P{objid}
