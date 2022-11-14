[getList]
select * 
from vw_newly_assessed_property
where effectivityyear = $P{year}
order by owner_name, tdno
