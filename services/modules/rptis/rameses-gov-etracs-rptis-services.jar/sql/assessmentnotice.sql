[getItems]
select * from vw_assessment_notice_item where assessmentnoticeid = $P{objid}

[getBldgTypes]	
select bt.code, bk.name as bldgkind 
from bldgrpu_structuraltype st
	inner join bldgtype bt on st.bldgtype_objid = bt.objid 
	inner join bldgkindbucc bucc on st.bldgkindbucc_objid = bucc.objid
	inner join bldgkind bk on bucc.bldgkind_objid = bk.objid 
where st.bldgrpuid = $P{rpuid}


[getSignatories]
select 
	ft.objid,
	ft.state,
	ft.actor_name,
	ft.actor_title,
	ft.signature,
	ft.enddate as dtsigned
from faas_task ft,
	(
		select 
			refid, 
			state, 
			max(enddate) as enddate 
		from faas_task 
		where refid = $P{objid}
			and state not like 'assign%'
			and enddate is not null 
		group by refid, state 
	) t 
where ft.refid = $P{objid}
  and ft.refid = t.refid 
  and ft.state = t.state 
  and ft.enddate = t.enddate


[getApprovedFaasList]
SELECT 
	f.objid AS faasid,
    f.effectivityyear,
    f.effectivityqtr,
    f.tdno,
    f.taxpayer_objid,
    e.name as taxpayer_name,
    e.address_text as taxpayer_address,
    f.owner_name,
    f.owner_address,
    f.administrator_name,
    f.administrator_address,
    f.rpuid, 
    rpu.rputype,
    rpu.ry,
    rpu.fullpin ,
    rpu.taxable,
    rpu.totalareaha,
    rpu.totalareasqm,
    rpu.totalbmv,
    rpu.totalmv,
    rpu.totalav,
    rp.section,
    rp.parcel,
    rp.surveyno,
    rp.cadastrallotno,
    rp.blockno,
    rp.claimno,
    rp.street,
    o.name as lguname, 
    b.name AS barangay,
    pc.code AS classcode,
    pc.name as classification 
FROM faas f 
	INNER JOIN rpu rpu ON f.rpuid = rpu.objid
	INNER JOIN propertyclassification pc ON rpu.classification_objid = pc.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN sys_org o ON f.lguid = o.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
WHERE f.taxpayer_objid = $P{taxpayerid}
  AND f.state = 'CURRENT'


[findFaasById]
SELECT ${fields}
FROM faas f 
	INNER JOIN rpu rpu ON f.rpuid = rpu.objid
	INNER JOIN propertyclassification pc ON rpu.classification_objid = pc.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN sys_org o ON f.lguid = o.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
WHERE f.objid = $P{faasid}
  AND f.state = 'CURRENT'

[getTaxpayerList]  
select distinct f.taxpayer_objid as objid,
	 e.name as name, 
	e.address_text as address 
from faas f 
 inner join rpu r on f.rpuid = r.objid 
 inner join realproperty rp on rp.objid = r.realpropertyid 
 INNER JOIN entity e on f.taxpayer_objid = e.objid 
where f.state='CURRENT' 
	and r.ry=$P{revisionyear}
	and rp.barangayid like $P{barangayid}
	and rp.section like $P{section}  

[getTaxpayerPropertyListForBatch]  
select f.objid 
from faas f 
 inner join rpu r on f.rpuid = r.objid 
 inner join realproperty rp on rp.objid = r.realpropertyid 
where f.state='CURRENT' 
	and r.ry=$P{revisionyear}
	and rp.barangayid like $P{barangayid}
	and rp.section like $P{section}



[getFaasIds]
select
  f.objid, f.tdno
from faas f  
  inner join rpu r on r.objid = f.rpuid 
  inner join realproperty rp on rp.objid = r.realpropertyid 
where rp.barangayid LIKE $P{barangayid}
	and r.ry = $P{revisionyear} 
	and f.state LIKE $P{state}
	${sectionfilter}
	${starttdnofilter}
	${endtdnofilter}
order by f.tdno 


[getNoticesByRef]
select a.objid, a.txnno, f.tdno
from assessmentnotice a 
	inner join assessmentnoticeitem i on a.objid = i.assessmentnoticeid
	inner join faas f on i.faasid = f.objid 
where i.faasid in (
	select newfaasid from subdividedland where subdivisionid = $P{objid}
	union 
	select newfaasid from subdivisionaffectedrpu where subdivisionid = $P{objid}
	union 
	select newfaasid from consolidation where objid = $P{objid}
	union 
	select newfaasid from consolidationaffectedrpu where consolidationid = $P{objid}
	union 
	select newfaasid from batchgr_item where parent_objid = $P{objid}
	union 
	select newfaas_objid from resection_item where parent_objid = $P{objid}
)
order by f.tdno


[getFaasesForNoaByRef]
select x.objid 
from (
	select newfaasid as objid from subdividedland where subdivisionid = $P{objid}
	union 
	select newfaasid as objid from subdivisionaffectedrpu where subdivisionid = $P{objid}
	union 
	select newfaasid as objid  from consolidation where objid = $P{objid}
	union 
	select newfaasid as objid  from consolidationaffectedrpu where consolidationid = $P{objid}
	union 
	select newfaasid as objid  from batchgr_item where parent_objid = $P{objid}
	union 
	select newfaas_objid as objid  from resection_item where parent_objid = $P{objid}
)x 
