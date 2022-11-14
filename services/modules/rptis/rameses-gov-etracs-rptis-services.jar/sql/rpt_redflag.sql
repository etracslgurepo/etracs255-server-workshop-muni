[getList]
select * 
from rpt_redflag 
where parentid = $P{parentid}
and state like $P{state}
order by filedby_date desc 

[getLookup]
select * 
from rpt_redflag 
where objid in (
	select objid from rpt_redflag where caseno like $P{searchtext}
	union 
	select objid from rpt_redflag where refno like $P{searchtext}
)
order by caseno desc 


[getListFromSubdivision]
select x.*
from (
	select * 
	from rpt_redflag 
	where parentid in (
		select f.objid from subdividedland sl, faas f
		where sl.subdivisionid = $P{parentid}
		 and sl.newfaasid = f.objid 
	)
	and state like $P{state}

	union 

	select * 
	from rpt_redflag 
	where parentid in (
		select f.objid from subdivisionaffectedrpu sar, faas f
		where sar.subdivisionid = $P{parentid}
		 and sar.newfaasid = f.objid 
	)
	and state like $P{state}
)x
order by filedby_date desc 



[getListFromConsolidation]
select x.*
from (
	select * 
	from rpt_redflag 
	where parentid in (
		select f.objid from consolidation c, faas f
		where c.objid = $P{parentid}
		 and c.newfaasid = f.objid 
	)
	and state like $P{state}

	union 

	select * 
	from rpt_redflag 
	where parentid in (
		select f.objid from consolidationaffectedrpu ca, faas f
		where ca.consolidationid = $P{parentid}
		 and ca.newfaasid = f.objid 
	)
	and state like $P{state}
)x
order by filedby_date desc 

[findByCaseNo]
select * from rpt_redflag where caseno = $P{caseno}
