CREATE VIEW liquidation_cashreceipt AS 
SELECT 
  c.collector_name AS collectorname,  
  c.receiptdate AS receiptdate,  
  c.receiptno AS serialno, 
  c.paidby AS payorname,  
  ci.item_title AS accttitle, 
  ci.item_objid AS acctid, 
  ci.amount AS amount, 
  ci.item_code AS acctno,
  CASE WHEN (SELECT 1 FROM cashreceipt_void cv WHERE cv.receiptid=c.objid LIMIT 1 ) IS NULL THEN 0 ELSE 1 END AS voided,
  c.formno AS afid,
  r.objid AS remittanceid,
  r.dtposted AS remittancedate,
  l.objid AS liquidationid,
  l.dtposted AS liquidationdate 
FROM cashreceiptitem ci 
INNER JOIN cashreceipt c ON ci.receiptid = c.objid
INNER JOIN remittance_cashreceipt rc ON rc.objid = c.objid 
INNER JOIN remittance r ON rc.remittanceid=r.objid
INNER JOIN liquidation_remittance lr ON lr.objid = r.objid 
INNER JOIN liquidation l ON lr.liquidationid = l.objid 