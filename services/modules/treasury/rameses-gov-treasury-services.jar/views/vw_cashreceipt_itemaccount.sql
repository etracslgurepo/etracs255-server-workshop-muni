[MySQL]
DROP VIEW IF EXISTS vw_cashreceipt_itemaccount 
; 
CREATE VIEW vw_cashreceipt_itemaccount AS 
SELECT 
  objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
  defaultvalue, valuetype, sortorder, org_objid AS orgid, hidefromlookup  
FROM itemaccount 
WHERE state='ACTIVE' 
  AND type IN ('REVENUE','NONREVENUE','PAYABLE') 
  AND IFNULL(generic, 0) = 0 
;

[SQLServer]
if object_id('dbo.vw_cashreceipt_itemaccount', 'V') IS NOT NULL 
  drop view dbo.vw_cashreceipt_itemaccount; 
go 
CREATE VIEW vw_cashreceipt_itemaccount as 
SELECT 
  objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
  defaultvalue, valuetype, sortorder, org_objid AS orgid, hidefromlookup  
FROM itemaccount 
WHERE state='ACTIVE' 
  AND type IN ('REVENUE','NONREVENUE','PAYABLE') 
  AND ISNULL(generic, 0) = 0 
go 
