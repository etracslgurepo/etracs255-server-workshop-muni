[getNodes]
select n.name, n.title as caption
from sys_wf_node n
where n.processname = 'cancelledfaas'
and n.name not like 'assign%'
and n.name <> 'start'
and exists(select * from sys_wf_transition where processname='cancelledfaas' and parentid = n.name)
order by n.idx


[getList]
SELECT 
	cf.*,
	f.tdno AS faas_tdno,
	f.owner_name AS faas_owner_name,
	rpu.fullpin AS faas_fullpin,
	rpu.rputype AS faas_rputype,
	rpu.classification_objid as faas_classification_objid,
	rpu.totalareasqm AS faas_totalareasqm,
	rpu.totalareaha AS faas_totalareaha,
	rpu.totalmv AS faas_totalmv,
	rpu.totalav AS faas_totalav,
	b.name as barangay, 
	ctr.code AS reason_code,
	ctr.name AS reason_name,
	tsk.objid AS taskid,
	tsk.state AS taskstate,
	tsk.assignee_objid
FROM cancelledfaas cf 
	INNER JOIN faas f ON cf.faasid = f.objid 
	INNER JOIN rpu rpu ON f.rpuid = rpu.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN barangay b on rp.barangayid = b.objid 
	LEFT JOIN canceltdreason ctr ON cf.reason_objid = ctr.objid 
	LEFT JOIN cancelledfaas_task tsk ON cf.objid = tsk.refid AND tsk.enddate IS NULL
where 1=1 ${filters}	
	and (
		f.objid in (
			select objid from faas where tdno like $P{searchtext}
			union 
			select objid from faas where name like $P{searchtext}
			union 
			select f.objid from faas f, realproperty rp where f.realpropertyid = rp.objid and rp.pin like $P{searchtext}
		)
		or 
		cf.txnno like $P{searchtext}
	)

[findById]
SELECT 
	cf.*,
	f.objid as faas_objid,
	f.tdno AS faas_tdno,
	f.owner_name AS faas_owner_name,
	f.rpuid AS faas_rpuid,
	r.fullpin AS faas_fullpin,
	r.rputype AS faas_rputype,
	r.classification_objid as faas_classification_objid,
	r.realpropertyid AS faas_realpropertyid,
	r.totalareasqm AS faas_totalareasqm,
	r.totalareaha AS faas_totalareaha,
	r.totalmv AS faas_totalmv,
	r.totalav AS faas_totalav,
	b.objid AS barangayid, 
	b.name as barangay, 
	ctr.code AS reason_code,
	ctr.name AS reason_name,
	tsk.objid AS taskid,
	tsk.state AS taskstate,
	tsk.assignee_objid
FROM cancelledfaas cf 
	INNER JOIN faas f ON cf.faasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN barangay b on rp.barangayid = b.objid 
	LEFT JOIN canceltdreason ctr ON cf.reason_objid = ctr.objid 
	LEFT JOIN cancelledfaas_task tsk ON cf.objid = tsk.refid AND tsk.enddate IS NULL
WHERE cf.objid = $P{objid}


[cancelFaas]
UPDATE faas SET 
	state = 'CANCELLED', 
	cancelreason = $P{cancelreason},
	cancelledbytdnos = $P{cancelledbytdnos},
	canceldate = $P{canceldate},
	cancelledyear = $P{cancelledyear},
	cancelledqtr = $P{cancelledqtr},
	cancelledmonth = $P{cancelledmonth},
	cancelledday = $P{cancelledday}
WHERE objid = $P{objid} 

[cancelRpu]
UPDATE rpu SET state = 'CANCELLED' WHERE objid = $P{objid}

[cancelRealProperty]
UPDATE realproperty SET state = 'CANCELLED' WHERE objid = $P{objid}


[getNonCancelledImprovements]
select 
	x.tdno 
from (
	SELECT 
		f.tdno,
		case 
			when br.landrpuid is not null then br.landrpuid 
			when mr.landrpuid is not null then mr.landrpuid 
			when pr.landrpuid is not null then pr.landrpuid 
			when mir.landrpuid is not null then mir.landrpuid 
			else null 
		end as landrpuid 
	FROM faas f
		INNER JOIN rpu r ON f.rpuid = r.objid 
		LEFT JOIN bldgrpu br on r.objid = br.objid 
		LEFT JOIN machrpu mr on r.objid = mr.objid 
		LEFT JOIN planttreerpu pr on r.objid = pr.objid 
		LEFT JOIN miscrpu mir on r.objid = mir.objid 
	WHERE r.realpropertyid = $P{realpropertyid}
		AND r.rputype <> 'land'
		AND f.state <> 'CANCELLED'	
)x 
WHERE x.landrpuid = $P{rpuid}
ORDER BY x.tdno   


[updateSignatoryInfo]
update cancelledfaas_signatory set 
	${updatefields}
where objid = $P{objid}


[deleteSignatories]
delete from cancelledfaas_signatory where objid = $P{objid}


[deleteRequirements]	
delete from rpt_requirement where refid = $P{objid}

[deleteTasks]	
delete from cancelledfaas_task where refid = $P{objid}



[findParetLguByBarangayId]
select 
	case when m.objid is null then d.name else m.name end as munidistrict,
	case when p.objid is null then c.name else p.name end as cityprov,
	case when p.objid is null then 1 else 0 end as iscity 
from barangay b 
	left join municipality m on b.parentid = m.objid 
	left join province p on m.parentid = p.objid 
	left join district d on b.parentid = d.objid 
	left join city c on d.parentid = c.objid 
where b.objid = $P{barangayid}	


[getSignatories]
select 
	ft.objid,
	ft.state,
	ft.actor_name,
	ft.actor_title,
	ft.signature,
	ft.enddate as dtsigned
from cancelledfaas_task ft,
	(
		select 
			refid, 
			state, 
			max(enddate) as enddate 
		from cancelledfaas_task 
		where refid = $P{objid}
			and state not like 'assign%'
			and enddate is not null 
		group by refid, state 
	) t 
where ft.refid = $P{objid}
  and ft.refid = t.refid 
  and ft.state = t.state 
  and ft.enddate = t.enddate