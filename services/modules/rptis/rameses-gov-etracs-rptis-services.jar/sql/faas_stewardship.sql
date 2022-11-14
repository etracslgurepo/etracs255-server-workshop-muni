[getStewardshipFaases]
select 
	r.rpumasterid, f.objid, f.tdno, f.fullpin, f.state, f.owner_name, f.owner_address,
	rp.cadastrallotno, rp.blockno, rp.surveyno, rp.stewardshipno,
	r.totalareaha, r.totalareasqm, r.totalmv, r.totalav
from faas_stewardship fs 
	inner join rpu r on fs.stewardrpumasterid = r.rpumasterid 
	inner join faas f on r.objid = f.rpuid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
where fs.rpumasterid = $P{rpumasterid}
and f.state <> 'CANCELLED'
order by f.fullpin




[getAffectedRpus]	
select 
	arpu.*,
	f.owner_name, f.owner_address, f.tdno,
	f.prevtdno, f.fullpin as prevpin 
from faas_affectedrpu arpu
	inner join faas f on arpu.prevfaasid = f.objid 
where arpu.faasid = $P{objid}
order by f.fullpin 


[getAffectedRpusByLandFaasId]
select bf.objid as prevfaasid
from faas lf 
	inner join bldgrpu br on br.landrpuid = lf.rpuid 
	inner join faas bf on br.objid = bf.rpuid 
where lf.objid = $P{objid}
  and bf.state = 'CURRENT'

union 
  
select bf.objid as prevfaasid
from faas lf 
	inner join machrpu br on br.landrpuid = lf.rpuid 
	inner join faas bf on br.objid = bf.rpuid 
where lf.objid = $P{objid}
  and bf.state = 'CURRENT'

union 
  
select bf.objid as prevfaasid
from faas lf 
	inner join planttreerpu br on br.landrpuid = lf.rpuid 
	inner join faas bf on br.objid = bf.rpuid 
where lf.objid = $P{objid}
  and bf.state = 'CURRENT'

union 

select bf.objid as prevfaasid
from faas lf 
	inner join miscrpu br on br.landrpuid = lf.rpuid 
	inner join faas bf on br.objid = bf.rpuid 
where lf.objid = $P{objid}
  and bf.state = 'CURRENT'



[findPreviousFaas]
select prevfaasid as objid from previousfaas where faasid = $P{objid}


[findAffectedRpuByPrevFaas]
select * from faas_affectedrpu where prevfaasid = $P{prevfaasid}
