[insertCollectionVoucherFund]
INSERT INTO collectionvoucher_fund ( 
  objid, controlno, parentid, fund_objid, fund_title, 
  amount, totalcash, totalcheck, totalcr, cashbreakdown 
) 
SELECT 
  CONCAT(cv.objid, '-', rf.fund_objid) AS objid, CONCAT(cv.controlno, '-', f.code) AS controlno, 
  cv.objid AS parentid, rf.fund_objid, rf.fund_title, SUM(rf.amount) AS amount, 
  SUM(rf.totalcash) AS totalcash, SUM(rf.totalcheck) AS totalcheck, 
  SUM(rf.totalcr) AS totalcr, '[]' AS cashbreakdown 
FROM remittance_fund rf
  INNER JOIN remittance r ON rf.remittanceid = r.objid 
  INNER JOIN collectionvoucher cv ON cv.objid = r.collectionvoucherid 
  INNER JOIN fund f ON f.objid = rf.fund_objid 
WHERE cv.objid = $P{collectionvoucherid} 
GROUP BY 
  CONCAT(cv.objid, '-', rf.fund_objid), 
  CONCAT(cv.controlno, '-', f.code), 
  cv.objid, rf.fund_objid, rf.fund_title 


[getCashLedgerItems]
SELECT tmp.*, ia.code as itemacctcode, ia.title as itemacctname  
FROM ( 
  SELECT 
    cv.fund_objid AS fundid, 'CASH_IN_TREASURY' AS itemacctid,
    (cv.totalcash + cv.totalcheck) AS dr, 0 AS cr,
    'cash_treasury_ledger' AS _schemaname 
  FROM collectionvoucher_fund cv 
  WHERE cv.parentid = $P{collectionvoucherid} 
)tmp 
  left join itemaccount ia on ia.objid = tmp.itemacctid 


[getBankAccountLedgerItems]
SELECT  
  nc.fund_objid AS fundid, ba.objid AS bankacctid,
  ba.acctid AS itemacctid, ia.code as itemacctcode, ia.title as itemacctname, 
  SUM(nc.amount) AS dr, 0.0 AS cr, 'bankaccount_ledger' AS _schemaname 
FROM  cashreceiptpayment_noncash nc
  INNER JOIN cashreceipt c ON nc.receiptid=c.objid
  INNER JOIN eftpayment cm ON cm.objid = nc.refid
  INNER JOIN bankaccount ba ON cm.bankacctid = ba.objid 
  INNER JOIN remittance r ON c.remittanceid = r.objid
  INNER JOIN collectionvoucher ccv ON r.collectionvoucherid = ccv.objid 
  LEFT JOIN itemaccount ia on ia.objid = ba.acctid 
  LEFT JOIN cashreceipt_void cv ON cv.receiptid=c.objid 
WHERE ccv.objid = $P{collectionvoucherid} 
  AND cv.objid IS NULL 
GROUP BY 
  nc.fund_objid, ba.objid, ba.acctid, ia.code, ia.title 


[getIncomeLedgerItems]
SELECT 
  a.fundid, a.itemacctid, a.itemacctcode, a.itemacctname, 
  SUM(a.dr) AS dr, SUM(a.cr) AS cr, 'income_ledger' AS _schemaname  
FROM ( 
  SELECT
        ci.item_fund_objid AS fundid,
        ci.item_objid AS itemacctid,
        ci.item_code as itemacctcode, 
        ci.item_title as itemacctname, 
        0 AS dr,
        SUM( ci.amount ) AS cr
  FROM cashreceiptitem ci
        INNER JOIN cashreceipt c ON ci.receiptid=c.objid
        INNER JOIN remittance r ON c.remittanceid=r.objid
        INNER JOIN collectionvoucher cv ON r.collectionvoucherid=cv.objid
        LEFT JOIN cashreceipt_void crv ON crv.receiptid=c.objid
  WHERE cv.objid = $P{collectionvoucherid} AND crv.objid IS NULL
  GROUP BY ci.item_fund_objid, ci.item_objid, ci.item_code, ci.item_title 

  UNION ALL

  SELECT
      ia.fund_objid AS fundid,
      ia.objid AS itemacctid,     
      ia.code AS itemacctcode, 
      ia.title AS itemacctname,  
      SUM( cs.amount ) AS dr,
      0 AS cr
  FROM cashreceipt_share cs
        INNER JOIN itemaccount ia ON cs.refitem_objid = ia.objid
        INNER JOIN cashreceipt c ON cs.receiptid=c.objid
        LEFT JOIN cashreceipt_void crv ON crv.receiptid=c.objid
        INNER JOIN remittance r ON c.remittanceid=r.objid
        INNER JOIN collectionvoucher cv ON r.collectionvoucherid=cv.objid
  WHERE  cv.objid = $P{collectionvoucherid} AND  crv.objid IS NULL
  GROUP BY ia.fund_objid, ia.objid, ia.code, ia.title 
  ) a 
GROUP BY a.fundid, a.itemacctid, a.itemacctcode, a.itemacctname 

[getPayableLedgerItems]
SELECT 
  ra.fund_objid AS fundid, ra.objid AS refitemacctid, 
  ia.objid AS itemacctid, ia.code AS itemacctcode, 
  ia.title AS itemacctname, 0.0 AS dr, 
  SUM( cs.amount ) AS cr, 'payable_ledger' AS _schemaname 
FROM cashreceipt_share cs 
  INNER JOIN itemaccount ia ON cs.payableitem_objid = ia.objid 
  INNER JOIN itemaccount ra ON cs.refitem_objid = ra.objid 
  INNER JOIN cashreceipt c ON cs.receiptid = c.objid 
  INNER JOIN remittance r ON c.remittanceid = r.objid 
  INNER JOIN collectionvoucher cv ON r.collectionvoucherid = cv.objid 
  LEFT JOIN cashreceipt_void crv ON crv.receiptid = c.objid 
WHERE cv.objid = $P{collectionvoucherid} 
  AND crv.objid IS NULL
GROUP BY 
  ra.fund_objid, ra.objid, ia.objid, ia.code, ia.title  


[findReceiptSummary]
select 
  sum(c.amount) as amount, 
  sum(c.voidamount) as voidamount, 
  sum(c.totalnoncash) as totalnoncash, 
  sum(c.amount)-sum(c.totalnoncash) as totalcash,
  sum(c.amount)-sum(c.voidamount) as total 
from collectionvoucher cv 
  inner join vw_remittance_cashreceipt c on c.collectionvoucherid = cv.objid 
where cv.objid = $P{collectionvoucherid} 
