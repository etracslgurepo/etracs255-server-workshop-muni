[postIncomeSummary]
INSERT INTO income_summary ( 
   refid, refdate, acctid, fundid, 
   amount, refno, reftype, orgid, 
   collectorid 
) 
SELECT 
   r.objid AS refid, 
   CONVERT(DATE, r.dtposted) AS refdate,
   ci.item_objid AS acctid, 
   ri.fund_objid AS fundid,
   SUM( ci.amount) AS amount,
   r.txnno AS refno,
   'remittance' AS reftype,
   c.org_objid AS orgid,
   r.collector_objid AS collectorid 
FROM liquidation lq
   INNER JOIN liquidation_remittance lr ON lq.objid=lr.liquidationid
   INNER JOIN remittance r ON r.objid=lr.objid
   INNER JOIN remittance_cashreceipt rc ON rc.remittanceid=r.objid
   INNER JOIN cashreceipt c ON c.objid=rc.objid
   INNER JOIN cashreceiptitem ci ON c.objid=ci.receiptid
   INNER JOIN itemaccount ri ON ci.item_objid=ri.objid
   LEFT JOIN cashreceipt_void cv ON cv.receiptid=c.objid    
WHERE lq.objid=$P{liquidationid} AND cv.objid IS NULL
GROUP BY  
   r.objid, 
   CONVERT(DATE, r.dtposted), 
   ci.item_objid, 
   ri.fund_objid,
   r.txnno,
   c.org_objid, 
   r.collector_objid 
