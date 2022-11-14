
DROP VIEW IF EXISTS vw_collectiontype;
CREATE VIEW  vw_collectiontype AS	
SELECT
   c.objid AS objid,
   c.state AS state,
   c.name AS name,
   c.title AS title,
   c.formno AS formno,
   c.handler AS handler,
   c.allowbatch AS allowbatch,
   c.barcodekey AS barcodekey,
   c.allowonline AS allowonline,
   c.allowoffline AS allowoffline,
   c.sortorder AS sortorder,
   o.org_objid AS orgid,
   c.fund_objid AS fund_objid,
   c.fund_title AS fund_title,
   c.category AS category,
   c.queuesection AS queuesection,
   c.system AS system,
   af.formtype AS af_formtype,
   af.serieslength AS af_serieslength,
   af.denomination AS af_denomination,
   af.baseunit AS af_baseunit,
   c.allowpaymentorder AS allowpaymentorder,
   c.allowkiosk AS allowkiosk,
   c.allowcreditmemo,
   c.connection,
   c.servicename
FROM collectiontype_org o
INNER JOIN  collectiontype c on c.objid = o.collectiontypeid
INNER JOIN af ON af.objid = c.formno
WHERE c.state = 'ACTIVE'

UNION 

SELECT 
   c.objid AS objid,
   c.state AS state,
   c.name AS name,
   c.title AS title,
   c.formno AS formno,
   c.handler AS handler,
   c.allowbatch AS allowbatch,
   c.barcodekey AS barcodekey,
   c.allowonline AS allowonline,
   c.allowoffline AS allowoffline,
   c.sortorder AS sortorder,
   NULL AS orgid,
   c.fund_objid AS fund_objid,
   c.fund_title AS fund_title,
   c.category AS category,
   c.queuesection AS queuesection,
   c.system AS system,
   af.formtype AS af_formtype,
   af.serieslength AS af_serieslength,
   af.denomination AS af_denomination,
   af.baseunit AS af_baseunit,
   c.allowpaymentorder AS allowpaymentorder,
   c.allowkiosk AS allowkiosk,
   c.allowcreditmemo,
   c.connection,
   c.servicename 
FROM collectiontype c 
INNER JOIN af ON af.objid = c.formno
LEFT JOIN collectiontype_org o ON c.objid = o.collectiontypeid
WHERE o.objid IS NULL AND c.state = 'ACTIVE'
