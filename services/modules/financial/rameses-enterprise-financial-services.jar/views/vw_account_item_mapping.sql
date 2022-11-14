drop view if exists vw_account_item_mapping 
;
create view vw_account_item_mapping as 
select 
	a.*, l.amount, l.fundid, l.year, l.month, 
	aim.itemid, ia.code as itemcode, ia.title as itemtitle 
from account_item_mapping aim 
	inner join account a on a.objid = aim.acctid 
	inner join itemaccount ia on ia.objid = aim.itemid 
	inner join vw_income_ledger l on l.itemacctid = aim.itemid 
;
