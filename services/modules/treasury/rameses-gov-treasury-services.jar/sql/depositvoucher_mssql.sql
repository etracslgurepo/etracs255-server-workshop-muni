[getCollectionVoucherFunds]
select 
  cv.controlno, cvf.fund_objid, cvf.fund_title, 
  cvf.amount, cvf.totalcash, cvf.totalcheck, cvf.totalcr, 
  fund.depositoryfundid 
from collectionvoucher cv 
  inner join collectionvoucher_fund cvf on cvf.parentid = cv.objid 
  inner join fund on fund.objid = cvf.fund_objid 
  left join fund fd on fd.objid = fund.depositoryfundid 
where cv.depositvoucherid = $P{depositvoucherid} 
order by cv.controlno, cvf.fund_title 


[getChecksForDeposit]
select cv.depositvoucherid, cp.objid as checkid, fund.depositoryfundid as fundid 
from collectionvoucher cv 
  inner join remittance r on r.collectionvoucherid = cv.objid 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
  inner join checkpayment cp on cp.objid = nc.refid 
  inner join fund on fund.objid = nc.fund_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
where cv.depositvoucherid = $P{depositvoucherid} 
  and v.objid is null 
group by cv.depositvoucherid, cp.objid, fund.depositoryfundid 
order by cp.objid 


[getChecksForVerification]
select 
  cp.refno, cp.refdate, cp.amount, 
  bank.objid as bank_objid, cp.bank_name 
from checkpayment cp 
  left join bank on bank.objid = cp.bankid 
where cp.depositvoucherid = $P{depositvoucherid} 
  and bank.objid is null 
order by cp.bank_name, cp.refno 


[getBankAccountLedgerItems]
SELECT 
  a.fundid, a.bankacctid,
  ba.acctid AS itemacctid, ia.code as itemacctcode, ia.title as itemacctname,
  a.dr, 0.0 AS cr, 'bankaccount_ledger' AS _schemaname, ba.acctid, ia.title as acctname 
FROM (
  SELECT 
    dvf.fundid, dvf.parentid AS depositvoucherid, ds.bankacctid, SUM(ds.amount) AS dr
  FROM depositslip ds 
    INNER JOIN depositvoucher_fund dvf ON ds.depositvoucherfundid = dvf.objid
  WHERE dvf.parentid = $P{depositvoucherid} 
  GROUP BY dvf.fundid, dvf.parentid, ds.bankacctid
)a 
  INNER JOIN depositvoucher dv ON a.depositvoucherid = dv.objid 
  INNER JOIN bankaccount ba ON a.bankacctid = ba.objid
  INNER JOIN itemaccount ia on ia.objid = ba.acctid


[getCashLedgerItems]
SELECT tmp.*, ia.code as itemacctcode, ia.title as itemacctname  
FROM (
  SELECT 
    dvf.fundid, ( 
      SELECT TOP 1 a.objid FROM itemaccount a 
      WHERE a.fund_objid = dvf.fundid 
        AND a.type = 'CASH_IN_TREASURY' 
    ) AS itemacctid,
    0.0 AS dr, dvf.amount AS cr, 
    'cash_treasury_ledger' AS _schemaname
  FROM depositvoucher_fund dvf
  WHERE dvf.parentid = $P{depositvoucherid} 
) tmp
  LEFT JOIN itemaccount ia on ia.objid = tmp.itemacctid  


[getOutgoingItems]
SELECT 
  frdvf.fundid,
  (frdvf.fundid + '-TO-' + tofund.objid ) AS item_objid,
  ('DUE TO ' + tofund.title ) AS item_title,
  tofund.objid AS item_fund_objid,
  tofund.code AS item_fund_code,
  tofund.title AS item_fund_title,
  'OFT' AS item_type,
  0 AS dr, dft.amount AS cr,
  'interfund_transfer_ledger' AS _schemaname
FROM deposit_fund_transfer dft
  INNER JOIN depositvoucher_fund todvf ON dft.todepositvoucherfundid = todvf.objid
  INNER JOIN fund tofund ON todvf.fundid = tofund.objid
  INNER JOIN depositvoucher_fund frdvf ON dft.fromdepositvoucherfundid = frdvf.objid
WHERE frdvf.parentid = $P{depositvoucherid} 


[getIncomingItems]
SELECT 
  todvf.fundid,
  (todvf.fundid + '-FROM-' + fromfund.objid ) AS item_objid,
  ('DUE FROM ' + fromfund.title ) AS item_title,
  fromfund.objid AS item_fund_objid,
  fromfund.code AS item_fund_code,
  fromfund.title AS item_fund_title,
  'IFT' AS item_type,
  dft.amount AS dr, 0.0 AS cr,
  'interfund_transfer_ledger' AS _schemaname
FROM deposit_fund_transfer dft
  INNER JOIN depositvoucher_fund fromdvf ON dft.fromdepositvoucherfundid = fromdvf.objid
  INNER JOIN fund fromfund ON fromdvf.fundid = fromfund.objid
  INNER JOIN depositvoucher_fund todvf ON dft.todepositvoucherfundid = todvf.objid
WHERE todvf.parentid = $P{depositvoucherid} 

