[MySQL]
drop view if exists vw_cashreceipt_itemaccount_collectiongroup
; 
CREATE VIEW vw_cashreceipt_itemaccount_collectiongroup as 
SELECT 
  ia.objid, ia.state, ia.code, ia.title, ia.description, 
  ia.type, ia.fund_objid, ia.fund_code, ia.fund_title,
  CASE WHEN ca.defaultvalue=0 THEN ia.defaultvalue ELSE ca.defaultvalue END AS defaultvalue,
  CASE WHEN ca.defaultvalue=0 THEN ia.valuetype ELSE ca.valuetype END AS valuetype, 
  ca.sortorder, ia.org_objid AS orgid, ca.collectiongroupid, ia.generic, ia.hidefromlookup  
FROM collectiongroup_account ca 
  INNER JOIN itemaccount ia ON ia.objid = ca.account_objid
;
 

[SQLServer]
if object_id('dbo.vw_cashreceipt_itemaccount_collectiongroup', 'V') IS NOT NULL 
  drop view dbo.vw_cashreceipt_itemaccount_collectiongroup; 
go 
CREATE VIEW vw_cashreceipt_itemaccount_collectiongroup as 
SELECT 
  ia.objid, ia.state, ia.code, ia.title, ia.description, 
  ia.type, ia.fund_objid, ia.fund_code, ia.fund_title,
  CASE WHEN ca.defaultvalue=0 THEN ia.defaultvalue ELSE ca.defaultvalue END AS defaultvalue,
  CASE WHEN ca.defaultvalue=0 THEN ia.valuetype ELSE ca.valuetype END AS valuetype, 
  ca.sortorder, ia.org_objid AS orgid, ca.collectiongroupid, ia.generic, ia.hidefromlookup  
FROM collectiongroup_account ca 
  INNER JOIN itemaccount ia ON ia.objid = ca.account_objid
go 