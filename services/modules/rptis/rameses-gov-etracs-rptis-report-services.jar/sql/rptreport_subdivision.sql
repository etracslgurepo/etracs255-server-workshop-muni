[getSubdividedLands]
select * 
from vw_report_subdividedland
where subdivisionid = $P{objid}
order by blockno, cadastrallotno


[getMotherLandsSummary]
select * 
from vw_report_motherland_summary
where subdivisionid = $P{objid}
