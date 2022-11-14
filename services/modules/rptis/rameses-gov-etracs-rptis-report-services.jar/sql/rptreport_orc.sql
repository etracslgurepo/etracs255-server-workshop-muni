[getList]  
select *
from vw_report_orc
where taxpayerid = $P{taxpayerid}
order by state, dtapproved, tdno 