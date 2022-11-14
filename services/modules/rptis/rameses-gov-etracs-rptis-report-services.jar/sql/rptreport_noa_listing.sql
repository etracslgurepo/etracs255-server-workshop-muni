[getList]
select 
	an.objid,
	an.state,
	an.txnno,
	an.txndate,
	an.taxpayername,
	an.taxpayeraddress,
	an.administrator_name,
	an.administrator_address,
	an.receivedby,
	an.dtdelivered,
	an.assessmentyear,
	an.deliverytype_objid,
	ai.faasid,
	ai.effectivityyear,
	ai.effectivityqtr,
	ai.tdno,
	ai.owner_name,
	ai.owner_address,
	ai.rputype,
	ai.ry,
	ai.fullpin,
	ai.taxable,
	ai.totalareaha,
	ai.totalareasqm,
	ai.totalbmv,
	ai.totalmv,
	ai.totalav,
	ai.surveyno,
	ai.cadastrallotno,
	ai.blockno,
	ai.claimno,
	ai.street,
	ai.lguname,
	ai.barangay,
	ai.classcode,
	ai.classification
from assessmentnotice an 
inner join vw_assessment_notice_item ai on an.objid = ai.assessmentnoticeid
where ai.lguid = $P{lguid}
and an.state = $P{state}
and an.txndate >= $P{startdate}
and an.txndate < $P{enddate}