[findFaasForApproval]
select objid, state, datacapture from faas  where objid = $P{objid}

[findCurrentTask]
select * from faas_task where refid = $P{objid} and enddate is null

