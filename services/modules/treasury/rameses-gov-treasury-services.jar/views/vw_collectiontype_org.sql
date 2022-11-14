drop view vw_collectiontype_org
;
create view vw_collectiontype_org as 
select 
	c.objid, c.state, c.name, c.title, c.formno, c.handler, c.allowbatch, 
	c.barcodekey, c.allowonline, c.allowoffline, c.sortorder, o.org_objid, 
	o.org_name, c.fund_objid, c.fund_title, c.category, c.queuesection, c.system,
	af.formtype as af_formtype, af.serieslength as af_serieslength, 
	af.denomination as af_denomination, af.baseunit as af_baseunit, c.allowpaymentorder, c.allowkiosk  
from collectiontype_org o 
	inner join collectiontype c on c.objid = o.collectiontypeid 
	inner join af on af.objid = c.formno 

union all 

select 
	c.objid, c.state, c.name, c.title, c.formno, c.handler, c.allowbatch, 
	c.barcodekey, c.allowonline, c.allowoffline, c.sortorder, null as org_objid, 
	null as org_name, c.fund_objid, c.fund_title, c.category, c.queuesection, c.system,
	af.formtype as af_formtype, af.serieslength as af_serieslength, 
	af.denomination as af_denomination, af.baseunit as af_baseunit, c.allowpaymentorder, c.allowkiosk  
from collectiontype c 
	inner join af on af.objid = c.formno 
;
