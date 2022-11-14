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

[findFaasById]
SELECT  
	f.objid,
	f.state, 
	f.rpuid as rpu_objid,
	f.realpropertyid as rp_objid, 
	f.tdno, 
	f.fullpin, 
	f.txntype_objid,
	ft.displaycode as txntype_displaycode,
	f.effectivityyear,
	f.effectivityqtr,
	f.titleno,
	f.titledate,
	f.taxpayer_objid, 
	f.owner_name, f.owner_address,
	f.administrator_name, f.administrator_address,
	f.beneficiary_name, f.beneficiary_address,
	f.memoranda,
	f.canceldate,
	f.cancelnote,
	f.restrictionid,
	f.backtaxyrs,
	f.prevtdno,
	f.ryordinanceno,
	f.ryordinancedate,
	fl.trackingno 
FROM faas f
	INNER JOIN faas_list fl ON f.objid = fl.objid 
	INNER JOIN faas_txntype ft on f.txntype_objid = ft.objid 
WHERE f.objid = $P{objid}


[findRpuById]
select
	r.objid, 
	r.rputype, 
	r.ry, 
	pc.code as classification_code,
	pc.name as classification_name,
	et.code AS exemptiontype_code,
	et.name AS exemptiontype_name,
	r.taxable, 
	r.totalareaha, 
	r.totalareasqm, 
	r.totalbmv, 
	r.totalmv, 
	r.totalav, 
	r.hasswornamount, 
	r.swornamount, 
	r.useswornamount
from rpu r 
	left join propertyclassification pc on r.classification_objid = pc.objid 
	left join exemptiontype et on r.exemptiontype_objid = et.objid 
where r.objid = $P{objid}	


[findRealPropertyById]
select
	rp.pin,
	rp.section,
	rp.parcel,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	rp.street,
	rp.purok,
	rp.north,
	rp.south,
	rp.east,
	rp.west,
	rp.portionof,
	rp.barangayid,
	rp.portionof,
	b.objid as barangay_objid,
	b.name as barangay_name, 
	b.parentid as barangay_parentid
from realproperty rp 
	inner join barangay b on rp.barangayid = b.objid 
where rp.objid = $P{objid}	



[getActiveAnnotations]
SELECT 
	fa.memoranda, 
	fa.memoranda as annotationtext 
FROM faasannotation fa
	INNER JOIN faasannotation_faas faf on fa.objid = faf.parent_objid
WHERE faf.faas_objid = $P{objid}
  AND fa.state = 'APPROVED'


[findLandReference]
select
	r.fullpin as landownerpin, 
	r.totalareasqm as landarea, 
	f.owner_name as landownername, 
	f.tdno as landtdno, 
	f.titleno as landtitleno, 
	rp.cadastrallotno as landlotno,
	rp.surveyno as landsurveyno,
	rp.blockno as landblockno,
	rp.portionof,
	f.administrator_name as landadminname
 from rpu r 
	inner join faas f on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
where r.objid=$P{landrpuid}
order by f.dtapproved desc


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
  and ft.enddate = t.enddate;



[getCancellingFaasInfo]
select 
	f.tdno,
	f.fullpin,
	f.effectivityyear,
	f.effectivityqtr
from faas_previous pf 
	inner join faas f on pf.faasid = f.objid 
where pf.prevfaasid = $P{objid}


[findCancelFaasReason]
select 
	ctd.name as reason,
	cf.remarks, 
	cf.txndate
from cancelledfaas cf 
	inner join canceltdreason ctd on cf.reason_objid = ctd.objid 
where cf.faasid = $P{objid}
and cf.state = 'APPROVED' 



[findEntityContactInfo]
select 
	case 
		when e.mobileno is not null then mobileno 
		when e.phoneno is not null then phoneno 
		else e.email 
	end as contactno,
	case 
		when i.objid is not null then i.tin
		when j.objid is not null then j.tin
		else null 
	end as tin
from entity e 
	left join entityindividual i on e.objid = i.objid 
	left join entityjuridical j on e.objid = j.objid 
where e.objid = $P{objid}



[getLandAreas]
SELECT
	ld.areasqm, 
	ld.areaha,
	CASE WHEN ld.areatype = 'HA' THEN ld.areaha ELSE ld.areasqm END AS area,
	ld.areatype
FROM landdetail ld 
WHERE ld.landrpuid = $P{landrpuid}	


[findUserByRole]
select ug.* 
from sys_user u
	inner join sys_usergroup_member ugm on u.objid = ugm.user_objid 
	inner join sys_usergroup ug on ugm.usergroup_objid = ug.objid 
where u.objid = $P{userid}
and ug.role = $P{role}


[findEsigned]
select objid 
from faas_task 
where refid = $P{objid} 
and state = 'approver' 
and signature is not null 
order by startdate desc



[getActiveClaims]
select cf.owner_name, cf.tdno 
from faas f 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join realproperty cp on rp.pin = cp.pin 
inner join faas cf on cp.objid = cf.realpropertyid
inner join rpu cr on cf.rpuid = cr.objid 
where cf.state = 'CURRENT'
and cr.rputype = 'land' 
and f.objid = $P{objid}
and f.objid <> cf.objid