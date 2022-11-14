drop view if exists vw_af_control_detail
;
create view vw_af_control_detail as 
select 
	afd.*, 
	afc.afid, afc.unit, af.formtype, af.denomination, af.serieslength, 
	afu.qty, afu.saleprice, afc.startseries, afc.endseries, afc.currentseries, 
	afc.stubno, afc.prefix, afc.suffix, afc.cost, afc.batchno, 
	afc.state as controlstate, afd.qtyending as qtybalance 
from af_control_detail afd 
	inner join af_control afc on afc.objid = afd.controlid 
	inner join af on af.objid = afc.afid 
	inner join afunit afu on (afu.itemid=af.objid and afu.unit=afc.unit) 
;