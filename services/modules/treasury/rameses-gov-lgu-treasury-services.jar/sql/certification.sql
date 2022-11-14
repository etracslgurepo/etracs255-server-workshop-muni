[getList]
select c.*, c.type AS _filetype 
from ( 
	select objid from certification where requestedby like $P{searchtext}  
	union 
	select objid from certification where txnno like $P{searchtext} 
	union 
	select objid from certification where orno like $P{searchtext} 
)xx 
	inner join certification c on xx.objid=c.objid 
 order by txnno desc 
