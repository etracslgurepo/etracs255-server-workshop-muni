CREATE VIEW remittance_cashreceiptitem AS 
SELECT 
    ci.objid,
    c.receiptno,
    c.receiptdate,
    ci.item_objid,
    ci.item_title,
    ci.item_fund_objid,
    ci.amount,
    ci.receiptid,
    r.objid AS remittanceid,
    rf.objid AS remittancefundid,
    rf.`liquidationfundid`,
    lf.liquidationid 
FROM cashreceiptitem ci
INNER JOIN cashreceipt c ON ci.`receiptid`=c.objid 
INNER JOIN remittance r ON c.`remittanceid`=r.objid 
INNER JOIN remittance_fund rf ON rf.`remittanceid`=r.objid AND rf.`fund_objid`=ci.`item_fund_objid` 
LEFT JOIN cashreceipt_void cv ON c.objid=cv.receiptid
LEFT JOIN liquidation_fund lf ON lf.objid=rf.liquidationfundid 
WHERE cv.objid  IS NULL

