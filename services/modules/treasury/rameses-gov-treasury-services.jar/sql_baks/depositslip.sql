[getAvailableChecks]
SELECT a.refno, a.refid, bnk.name AS bank_name, bnk.deposittype, a.refdate, a.amount 
FROM ( 
  SELECT 
  ncp.refno, ncp.refid, ncp.refdate, ncp.particulars, SUM(ncp.amount) AS amount
  FROM cashreceiptpayment_noncash ncp
  INNER JOIN cashreceipt cr ON cr.objid=ncp.receiptid
  INNER JOIN remittance r ON cr.remittanceid = r.objid 
  INNER JOIN collectionvoucher_fund cvf ON cvf.parentid=r.collectionvoucherid
  WHERE cvf.depositvoucherid = $P{depositvoucherid} 
  AND ncp.fund_objid=$P{fundid}
  AND ncp.amount > 0 
  AND ncp.reftype = 'CHECK'
  AND cr.objid NOT IN (SELECT receiptid FROM cashreceipt_void WHERE receiptid = cr.objid )
  AND ncp.refid NOT IN (
      SELECT checkid FROM depositslip_check 
      INNER JOIN depositslip  ON depositslip_check.depositslipid = depositslip.objid 
      WHERE depositslip.depositvoucherid = cvf.depositvoucherid 
  )
  GROUP BY ncp.refno, ncp.refid, ncp.refdate, ncp.particulars
) a
INNER JOIN checkpayment pc ON pc.objid = a.refid
INNER JOIN bank bnk ON pc.bankid = bnk.objid



[updateCheckTotal]
UPDATE depositslip
    SET totalcheck = (
		SELECT SUM(pc.amount) 
		FROM checkpayment pc
        WHERE pc.depositslipid = depositslip.objid   
	)
WHERE objid = $P{depositslipid}

[cleanUpNullTotals]
UPDATE depositslip 
SET 
    totalcheck = CASE WHEN totalcheck IS NULL THEN 0 ELSE totalcheck END
WHERE objid = $P{depositslipid}

[updateFundCheckTotals]
UPDATE depositvoucher 
   SET totalcheck = (
      SELECT SUM( ds.totalcheck )
      FROM depositslip ds 
      WHERE ds.depositvoucherid = depositvoucher.objid 
   )
WHERE objid=$P{depositvoucherid}   

[updateFundCashTotals]
UPDATE depositvoucher
   SET totalcash = (
   		SELECT SUM( ds.totalcash )
   		FROM depositslip ds 
   		WHERE ds.depositvoucherid = depositvoucher.objid 
   )
WHERE objid=$P{depositvoucherid}   

[updateFundCashTotals]
UPDATE depositvoucher 
   SET totalcash = (
      SELECT SUM( ds.totalcash )
      FROM depositslip ds 
      WHERE ds.depositvoucherid = depositvoucher.objid 
   )
WHERE objid=$P{depositvoucherid} 

[cleanUpNullFundTotals]
UPDATE depositvoucher 
SET 
    totalcheck = CASE WHEN totalcheck IS NULL THEN 0 ELSE totalcheck END,
    totalcash = CASE WHEN totalcash IS NULL THEN 0 ELSE totalcash END
WHERE objid=$P{depositvoucherid} 