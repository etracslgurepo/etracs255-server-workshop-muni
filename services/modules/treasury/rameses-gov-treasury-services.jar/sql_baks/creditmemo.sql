[getList]
SELECT * FROM creditmemo WHERE refno LIKE $P{searchtext} ORDER BY refdate DESC 

[getItems]
SELECT 
	dci.*,
	ri.code AS item_code,
	ri.title AS item_title,
	ri.fund_objid AS item_fund_objid,
	ri.fund_code AS item_fund_code,
	ri.fund_title  AS item_fund_title
FROM creditmemoitem dci 
INNER JOIN itemaccount ri ON dci.item_objid = ri.objid
WHERE dci.parentid = $P{objid}	 

[getReportData]
SELECT
	dc.refno, dc.refdate,
	ri.code, ri.title, dci.amount
FROM creditmemo dc
	INNER JOIN creditmemoitem dci ON dc.objid = dci.parentid
	INNER JOIN itemaccount ri ON dci.item_objid = ri.objid
WHERE dc.refdate between $P{fromdate} and $P{todate}
  AND dc.state = 'POSTED' 
  AND ri.objid LIKE $P{acctid}
ORDER BY dc.refdate , ri.code 

[findForCashReceipt]
SELECT c.objid, c.payer_objid, e.name AS payer_name, 
c.payername AS paidby, c.payeraddress AS paidbyaddress, 
c.amount, c.refno, c.refdate, c.bankaccount_objid, c.bankaccount_code, c.bankaccount_title,
ba.bank_name, ba.fund_title, ba.fund_objid, ba.fund_code, c.state, 
ba.bank_objid, c.particulars 
FROM creditmemo c
INNER JOIN entity e ON c.payer_objid=e.objid 
INNER JOIN bankaccount ba ON c.bankaccount_objid=ba.objid  
WHERE refno = $P{refno}	

[postPayment]
UPDATE creditmemo SET state='POSTED', receiptid=$P{receiptid},
receiptno=$P{receiptno} 
WHERE objid=$P{creditmemoid}

[findHasCreditMemoTypeAccount]
SELECT COUNT(*) AS count FROM creditmemotype_account WHERE typeid=$P{typeid} 

[getLookupByCreditMemoFund]
SELECT i.* FROM itemaccount i
INNER JOIN creditmemotype cr ON i.fund_objid=cr.fund_objid
WHERE cr.objid=$P{typeid}
${filter}

[getLookupByAccount]
SELECT i.* FROM itemaccount i
INNER JOIN creditmemotype_account ca ON ca.account_objid=i.objid 
WHERE ca.typeid=$P{typeid}
${filter}

[getLookupByFund]
SELECT * FROM itemaccount i WHERE fund_objid=$P{fundid} ${filter}

[getOpenListByRefno]
SELECT  b.code AS bank_code, ct.fund_title, c.* FROM creditmemo c
INNER JOIN bankaccount ba ON c.bankaccount_objid=ba.objid
INNER JOIN bank b ON ba.bank_objid=b.objid
INNER JOIN creditmemotype ct ON c.type_objid=ct.objid
WHERE c.refno LIKE $P{refno} AND c.state='OPEN'
ORDER BY c.refdate DESC 

[getOpenListByControlno]
SELECT  b.code AS bank_code, ct.fund_title, c.* FROM creditmemo c
INNER JOIN bankaccount ba ON c.bankaccount_objid=ba.objid
INNER JOIN bank b ON ba.bank_objid=b.objid
INNER JOIN creditmemotype ct ON c.type_objid=ct.objid
WHERE c.controlno LIKE $P{controlno}  AND c.state='OPEN'
ORDER BY c.refdate DESC 
