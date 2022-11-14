[getSeries]
select 
  objid,
  nextSeries as nextseries
from sys_sequence 
where objid like $P{key}
order by objid desc


[getRequestedSeries]
select * from faas_requested_series 
where parentid = $P{objid} 
order by createdby_date 