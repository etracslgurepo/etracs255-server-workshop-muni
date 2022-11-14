[updateDataCaptureFlag]
update faas set datacapture = $P{datacapture} where objid = $P{objid}

[deleteTasks]
DELETE FROM faas_task WHERE refid = $P{objid}


[findOnlinePaymentByFaas]
select f.objid, rl.objid as rptledgerid  
from faas f 
    inner join rptledger rl on f.objid = rl.faasid 
    inner join rptpayment rp on rl.objid = rp.refid
where f.objid = $P{objid}
and rp.voided = 0 

[findLedgerByFaasId]
select objid from rptledger where faasid = $P{objid}

[findExistingImprovements]
select i.objid 
from faas_list i
where i.realpropertyid in (
	select f.realpropertyid
	from faas_list f 
	where f.objid = $P{objid}
	and f.rputype = 'land' 
) and i.rputype <> 'land'




[findFaasById]
select objid, state from faas where objid = $P{objid}


[findSpecificClassById]
select spc.*
from lcuvspecificclass spc
where spc.objid = $P{objid}
 

[findLandRySetting]
select rs.objid, pc.objid as classid  
from lcuvspecificclass spc
	inner join landrysetting rs on spc.landrysettingid = rs.objid 
	inner join rysetting_lgu l on rs.objid = l.rysettingid
	inner join propertyclassification pc on spc.classification_objid = pc.objid 
where rs.ry = $P{ry}
 and l.lguid = $P{lguid}
 and pc.code = $P{classcode}

[findSubClassById] 
select objid 
from lcuvsubclass spc
where objid = $P{objid}


[findPlantTreeById]
select * 
from planttree 
where objid = $P{objid}


[findPlantTreeUnitValue]
select objid 
from planttreeunitvalue 
where objid = $P{objid}


[findPlantTreeRySetting]
select * 
from planttreerysetting rs
	inner join rysetting_lgu l on rs.objid = l.rysettingid
where rs.ry = $P{ry}
and l.lguid = $P{lguid}
and l.settingtype  = 'planttree' 


[findLandRpuById]
select objid from rpu where objid = $P{objid}

[findLandRpuByPin]
select r.objid
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
where rp.pin = $P{pin}
  and r.ry = $P{ry}


[findLandAdjustmentTypeById]  
select objid from landadjustmenttype where objid = $P{objid}

[findLandRySettingByAdjustmentType]
select rs.* 
from landrysetting rs 
	inner join landadjustmenttype lt on rs.objid = lt.landrysettingid
	inner join rysetting_lgu rl on rs.objid = rl.rysettingid
where rs.ry = $P{ry}
and rl.settingtype = 'land'
and rl.lguid = $P{lguid}



[getApproverTasks]
select * from faas_task 
where refid = $P{objid}
and exists(select * from sys_user where objid = faas_task.actor_objid)
order by startdate
