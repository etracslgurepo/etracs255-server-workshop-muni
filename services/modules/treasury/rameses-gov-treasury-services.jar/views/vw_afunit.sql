
drop view if exists vw_afunit
;

create view vw_afunit as 
select 
	u.objid, af.title, af.usetype, af.serieslength, af.system, af.denomination, u.interval, 
	af.formtype, u.itemid, u.unit, u.qty, u.saleprice  
from afunit u 
	inner join af on af.objid = u.itemid  
;
