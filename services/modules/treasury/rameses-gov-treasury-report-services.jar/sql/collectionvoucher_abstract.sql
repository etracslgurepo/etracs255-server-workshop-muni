[getReport]
SELECT a.af, 
a.receiptno,
a.receiptdate,
CASE WHEN a.voided=0 THEN a.paidby ELSE '** VOIDED **' END AS paidby,
a.collector,
f.title AS fund,
CASE WHEN b.acctcode IS NULL THEN 'UNMAPPED' ELSE CONCAT(b.accttitle, ' (', b.acctcode, ')') END AS account,
a.amount,
a.voided 
FROM 
(SELECT 
cr.formno AS af, cr.receiptno, cr.receiptdate, cr.paidby, 
cr.collector_name AS collector, ci.item_fund_objid AS fundid,
CASE WHEN cv.objid IS NULL THEN ci.amount ELSE 0 END AS amount,
CASE WHEN cv.objid IS NULL THEN 0 ELSE 1 END AS voided, 
ci.item_objid AS itemacctid 
FROM cashreceiptitem ci
INNER JOIN cashreceipt cr ON ci.receiptid = cr.objid
INNER JOIN remittance r ON cr.remittanceid = r.objid
LEFT JOIN cashreceipt_void cv ON cv.receiptid = cr.objid
WHERE r.collectionvoucherid = $P{collectionvoucherid} ) a

LEFT JOIN 
(
SELECT aim.itemid AS itemacctid, a.code AS acctcode, a.title AS accttitle  
FROM account_item_mapping aim 
INNER JOIN account a ON aim.acctid = a.objid
WHERE a.maingroupid = $P{acctgroupid}
) b ON a.itemacctid = b.itemacctid

INNER JOIN fund f ON f.objid = a.fundid  

ORDER BY a.af, a.receiptno, f.title, b.acctcode