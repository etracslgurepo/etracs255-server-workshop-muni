[getConsolidations]
select * 
from vw_report_consolidation
where objid = $P{objid}
order by cadastrallotno


[getConsolidatedLands]
select * 
from vw_report_consolidated_land
where consolidationid = $P{objid}
order by cadastrallotno