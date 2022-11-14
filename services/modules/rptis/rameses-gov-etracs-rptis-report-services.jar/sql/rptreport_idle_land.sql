[getList]
select * 
from vw_idle_land
where lguid = $P{lguid} ${filter}
order by lguid, barangay, tdno