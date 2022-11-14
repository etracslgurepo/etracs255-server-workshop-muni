[getNodes]
select n.name, n.title as caption
from sys_wf_node n
where n.processname = 'consolidation'
and n.name not like 'assign%'
and n.name not in ('start', 'provapprover')
and n.name not like 'for%'
and exists(select * from sys_wf_transition where processname='consolidation' and parentid = n.name)
order by n.idx


[getList]
SELECT 
	c.*,
	f.fullpin AS rp_pin,
	r.totalareaha AS rpu_totalareaha,
	r.totalareasqm AS rpu_totalareasqm,
	(select trackingno from rpttracking where objid = c.objid ) AS trackingno,
	tsk.objid AS taskid,
	tsk.state AS taskstate,
	tsk.assignee_objid 
FROM consolidation c
	LEFT JOIN faas f ON c.newfaasid = f.objid 
	LEFT JOIN rpu r ON c.newrpuid = r.objid 
	LEFT JOIN realproperty rp ON c.newrpid = rp.objid 
	LEFT JOIN consolidation_task tsk ON c.objid = tsk.refid AND tsk.enddate IS NULL
where c.lguid LIKE $P{lguid} 
   and (rp.barangayid is null or rp.barangayid like $P{barangayid})
   and c.state LIKE $P{state}
   and (c.txnno like $P{searchtext} or f.tdno like $P{searchtext} or rp.pin like $P{searchtext} or f.name like $P{searchtext})
	${filters}	




[findById]
SELECT c.*,
	r.ry AS rpu_ry, 
	r.objid AS rpu_objid, 
	r.totalareaha AS rpu_totalareaha, 
	r.totalareasqm AS rpu_totalareasqm, 
	r.fullpin AS rpu_fullpin, 
	r.rputype AS rpu_rputype, 
	r.totalmv AS rpu_totalmv, 
	r.totalav AS rpu_totalav, 
	pc.code AS rpu_classfication_code,
	pc.name AS rpu_classification_name,

	rp.objid AS rp_objid,
	rp.state AS rp_state,
	rp.pin AS rp_pin,
	rp.ry AS rp_ry,
	rp.surveyno AS rp_surveyno,
	rp.cadastrallotno AS rp_cadastrallotno,
	rp.blockno AS rp_blockno,
	rp.lgutype AS rp_lgutype, 
	rp.barangayid AS rp_barangayid, 
	b.name AS rp_barangay,
	rp.claimno AS rp_claimno,
	tsk.objid AS taskid,
	tsk.state AS taskstate,
	tsk.assignee_objid 
FROM consolidation c
	LEFT JOIN faas f ON c.newfaasid = f.objid 
	LEFT JOIN realproperty rp ON c.newrpid = rp.objid 
	LEFT JOIN rpu r ON c.newrpuid = r.objid 
	LEFT JOIN barangay b on rp.barangayid = b.objid 
	LEFT JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	LEFT JOIN consolidation_task tsk ON c.objid = tsk.refid AND tsk.enddate IS NULL
WHERE c.objid = $P{objid}	


[getConsolidatedLands]
SELECT cl.*,
	f.objid AS faas_objid,
	f.rpuid AS faas_rpuid,
	f.tdno AS faas_tdno,
	f.fullpin AS faas_fullpin,
	f.owner_name AS faas_owner_name, 
	f.administrator_name AS faas_administrator_name, 
	r.realpropertyid AS rpu_realpropertyid,
	r.totalmv AS rpu_totalmv,
	r.totalav AS rpu_totalav,
	r.totalareaha AS rpu_totalareaha,
	r.totalareasqm AS rpu_totalareasqm,
	r.taxable AS rpu_taxable,
	rp.barangayid,
	rp.lguid,
	rp.lgutype
FROM consolidatedland cl
	INNER JOIN faas f ON cl.landfaasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE cl.consolidationid = $P{consolidationid}
ORDER BY r.fullpin 


[findDuplicateConsolidatedLand]
SELECT * FROM consolidatedland 
WHERE consolidationid = $P{consolidationid} AND landfaasid = $P{landfaasid}


[getAffectedRpus]
SELECT 
	car.*,
	f.state AS prevstate,
	f.tdno AS prevtdno,
	f.owner_name,
	f.owner_address,
	r.suffix AS prevsuffix,
	r.fullpin AS prevfullpin,
	r.rputype 
FROM consolidationaffectedrpu car
	INNER JOIN faas f ON car.prevfaasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid
WHERE car.consolidationid = $P{consolidationid}	
ORDER BY r.fullpin 

[getAffectedRpusWithNoPin]
SELECT 
	car.*,
	f.tdno AS prevtdno
FROM consolidationaffectedrpu car
	INNER JOIN faas f ON car.prevfaasid = f.objid 
WHERE car.consolidationid = $P{objid}	
  AND car.newrpid IS NULL 


[getAffectedRpusByConsolidatedLandId]
SELECT 
	r.objid,
	r.rputype 
FROM consolidationaffectedrpu car
	INNER JOIN rpu r ON car.newrpuid = r.objid 
WHERE car.landfaasid = $P{landfaasid}


[getAffectedRpusByConsolidatedLand]
SELECT 
	fi.objid AS objid,
	fi.state, 
  $P{consolidationid} AS consolidationid,
	fi.objid AS prevfaasid,
	fi.rpuid AS prevrpuid, 
	r.suffix AS newsuffix,
	fi.rputype,
	fl.objid AS landfaasid,
	ledger.state AS ledgerstate
FROM faas_list fi
	INNER JOIN rpu r on fi.rpuid = r.objid 
	INNER JOIN faas_list fl on fi.realpropertyid = fl.realpropertyid 
	LEFT JOIN rptledger ledger ON fi.objid = ledger.faasid 
WHERE fi.realpropertyid = $P{realpropertyid}
  AND fi.rputype <> 'land' 
  AND fl.rputype = 'land'
  AND fi.state <> 'CANCELLED' 
  AND fl.state = 'CURRENT'
  AND NOT EXISTS(SELECT * FROM consolidationaffectedrpu WHERE prevfaasid = fi.objid )





[getNewlyCreatedAffectedRpus]
SELECT 
	f.objid AS objid,
	$P{consolidationid} AS consolidationid,
	f.objid AS prevfaasid,
	r.objid AS prevrpuid, 
	r.suffix AS newsuffix,
	r.rputype,
	fl.objid AS landfaasid
FROM consolidatedland cl
	INNER JOIN rpu r ON cl.rpid = r.realpropertyid
	INNER JOIN faas f ON  r.objid = f.rpuid 
	INNER JOIN rpu rl ON cl.rpid = rl.realpropertyid
	INNER JOIN faas fl ON rl.objid = fl.rpuid 
WHERE cl.consolidationid = $P{consolidationid}
  AND r.rputype <> 'land' 
  AND rl.rputype = 'land'
  AND f.state <> 'CANCELLED' 
  AND fl.state = 'CURRENT'
  AND NOT EXISTS(SELECT * FROM consolidationaffectedrpu WHERE prevfaasid = f.objid )
ORDER BY rputype 


[deleteAffectedRpuByLandFaasId]
DELETE FROM consolidationaffectedrpu WHERE landfaasid = $P{landfaasid}


[deleteAffectedRpuByPrevFaasId]
DELETE FROM consolidationaffectedrpu WHERE prevfaasid = $P{prevfaasid}

  
[findTotalConsolidatedLandArea]  
SELECT SUM( r.totalareasqm ) AS totalareasqm 
FROM consolidatedland cl
	INNER JOIN rpu r on cl.rpuid = r.objid 
WHERE cl.consolidationid = $P{consolidationid}


[setConsolidationFaasId]
UPDATE consolidation SET newfaasid = $P{newfaasid} WHERE objid = $P{objid}


[clearConsolidationFaasId]
UPDATE consolidation SET newfaasid = null WHERE objid = $P{objid}


[clearAffectedRpuNewFaasId]
UPDATE consolidationaffectedrpu SET newfaasid = null WHERE objid = $P{objid}




[approveConsolidation]
UPDATE cs SET
	cs.state = 'APPROVED'
FROM consolidation cs
	INNER JOIN faas f ON cs.newfaasid = f.objid  
WHERE cs.objid = $P{objid}


[cancelRealProperty]
UPDATE realproperty SET state = 'CANCELLED' WHERE objid = $P{objid}

[cancelLandLedger]
UPDATE rptledger SET state = 'CANCELLED' WHERE faasid = $P{faasid}






#===============================================================
#
#  ASYNCHRONOUS APPROVAL SUPPORT 
#
#================================================================

[findFaasById]
SELECT 
	f.objid AS newfaasid, 
	f.tdno, 
	f.utdno, 
	r.ry AS rpu_ry, 
	rp.barangayid AS rp_barangay_objid
FROM faas f 
	inner join rpu r on f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE f.objid =  $P{newfaasid}	


[updateFaasNewTdNo]
UPDATE faas SET 
	tdno = $P{newtdno}, utdno = $P{newtdno}
WHERE objid = $P{newfaasid}	


[updateConsolidationNewTdNo]
UPDATE consolidation SET 
	newtdno = $P{newtdno}, newutdno = $P{newutdno}
WHERE objid =$P{objid}	

[updateConsolidationNewFaasId]
UPDATE consolidation SET 
	newfaasid = $P{newfaasid}
WHERE objid =$P{objid}	


[updateAffectedNewTdNo]
UPDATE consolidationaffectedrpu SET 
	newtdno = $P{newtdno}, newutdno = $P{newutdno}
WHERE objid =$P{objid}	






[findBarangayId]
SELECT rp.barangayid
FROM consolidation c
	LEFT JOIN realproperty rp ON c.newrpid = rp.objid 
WHERE c.objid = $P{objid}	




[getFaasListing]
SELECT 
	f.objid, 
	f.tdno, 
	r.rputype,
	r.fullpin 
FROM faas f 
	INNER JOIN rpu r ON f.rpuid = r.objid 
WHERE f.objid in (	
	SELECT c.newfaasid
	FROM consolidation c
	WHERE c.objid = $P{objid}

	UNION ALL

	SELECT arpu.newfaasid
	FROM consolidation c
		INNER JOIN consolidationaffectedrpu arpu ON c.objid = arpu.consolidationid
	WHERE c.objid = $P{objid}
)
ORDER BY f.tdno 



[findTrackingNo]
SELECT trackingno FROM rpttracking WHERE objid = $P{objid}


[deleteTasks]
DELETE FROM consolidation_task WHERE refid = $P{objid}


[deleteMotherFaasTasks]
delete from faas_task where refid in (
	select newfaasid from consolidation where objid = $P{objid}
)


[deleteAffectedRpuFaasTasks]
delete from faas_task 
where refid in (
	select newfaasid from consolidationaffectedrpu where consolidationid = $P{objid}
)



[deleteRequirements]
DELETE FROM rpt_requirement WHERE refid = $P{objid}





[getSignatories]
SELECT  DISTINCT
	ft.actor_name as assignee_name, ft.actor_title as assignee_title,
	x.assignee_dtsigned, x.type 
FROM consolidation_task ft, 
(
	SELECT refid, state AS type, max(enddate) AS assignee_dtsigned
	FROM consolidation_task 
	WHERE refid = $P{objid}
		AND actor_name IS NOT NULL
	GROUP BY refid, state
) x
where ft.refid = x.refid
and ft.state = x.type 
and ft.enddate = x.assignee_dtsigned


[deleteTasks]
DELETE FROM consolidation_task WHERE refid = $P{objid}

[insertTask]
INSERT INTO consolidation_task 
	(objid, refid, state, startdate, enddate, assignee_objid, assignee_name, assignee_title)
VALUES 
	($P{objid}, $P{refid}, $P{state}, $P{startdate}, $P{enddate}, 
		$P{assigneeid}, $P{assigneename}, $P{assigneetitle})	


[findState]
SELECT state FROM consolidation WHERE objid = $P{objid}	




[updateAffectedRpuRealPropertyId]
UPDATE rpu SET realpropertyid = $P{realpropertyid} WHERE objid = $P{rpuid}



[getAffectedRpusForApproval]
SELECT ar.*, f.tdno as newtdno 
FROM consolidation s 
	INNER JOIN consolidationaffectedrpu ar ON s.objid = ar.consolidationid  
	INNER JOIN faas f ON ar.newfaasid = f.objid 
WHERE s.objid = $P{consolidationid}
  AND f.state = 'PENDING' 


[deleteTasks]
DELETE FROM consolidation_task WHERE refid = $P{objid}


[updateConsolidationFaasInfo]
update faas f, consolidation c set 
	f.taxpayer_objid = c.taxpayer_objid,	
	f.owner_name = c.taxpayer_name,
	f.owner_address = c.taxpayer_address
where c.objid = $P{objid}
  and f.objid = c.newfaasid 
   

   
[insertConsolidatedFaasSignatories]
INSERT INTO faas_task 
     (objid, refid, parentprocessid, state, startdate, enddate, 
      assignee_objid, assignee_name, assignee_title, 
      actor_objid, actor_name, actor_title, message, signature) 
select
    t.objid + f.utdno as objid, 
    c.newfaasid, 
    t.parentprocessid, 
    t.state, 
    t.startdate, 
    t.enddate, 
    t.assignee_objid, 
    t.assignee_name, 
    t.assignee_title, 
    t.actor_objid, 
    t.actor_name, 
    t.actor_title, 
    t.message, 
    t.signature
from consolidation c
    inner join faas f on c.newfaasid = f.objid 
    inner join consolidation_task t on c.objid = t.refid 
where c.objid = $P{objid}
  and t.state not like 'assign%'   


[insertAffectedRpuSignatories]
INSERT INTO faas_task 
     (objid, refid, parentprocessid, state, startdate, enddate, 
      assignee_objid, assignee_name, assignee_title, 
      actor_objid, actor_name, actor_title, message, signature) 
select
    t.objid + f.utdno as objid, 
    ca.newfaasid, 
    t.parentprocessid, 
    t.state, 
    t.startdate, 
    t.enddate, 
    t.assignee_objid, 
    t.assignee_name, 
    t.assignee_title, 
    t.actor_objid, 
    t.actor_name, 
    t.actor_title, 
    t.message, 
    t.signature
from consolidation c
    inner join consolidationaffectedrpu ca on c.objid = ca.consolidationid
    inner join faas f on ca.newfaasid = f.objid 
    inner join consolidation_task t on c.objid = t.refid 
where c.objid = $P{objid}
  and t.state not like 'assign%'


[getTasks]
select * from consolidation_task where refid = $P{refid}


[findLandReferenceByConsolidation]
select newrpid as landrpid, newrpuid as landrpuid from consolidation where objid = $P{objid}


[findPendingAffectedRpuCount]
select count(*) AS icount 
from consolidationaffectedrpu arpu
	inner join faas f on arpu.newfaasid = f.objid 
where arpu.consolidationid = $P{objid}
and f.state = 'PENDING'


[findAffectedRpuBySuffix]
select pr.fullpin 
from consolidationaffectedrpu arpu 
	inner join faas pf on arpu.prevfaasid = pf.objid 
	inner join rpu pr on pf.rpuid = pr.objid 
where arpu.consolidationid = $P{consolidationid}
and arpu.objid <> $P{objid}
and arpu.newsuffix = $P{newsuffix}


[findOpenTask]  
select * from consolidation_task where refid = $P{objid} and enddate is null


[findOpenTaskFromFaas]
select * from consolidation_task 
where refid in (
	select objid from consolidation where newfaasid = $P{objid}
	union 
	select consolidationid from consolidationaffectedrpu where newfaasid = $P{objid}
)
and enddate is null


[getAffectedRpuWithNoPin]
SELECT pf.fullpin
FROM consolidationaffectedrpu cr
	inner JOIN faas pf ON cr.prevfaasid = pf.objid 
WHERE cr.consolidationid = $P{objid}	
and cr.newfaasid is null 