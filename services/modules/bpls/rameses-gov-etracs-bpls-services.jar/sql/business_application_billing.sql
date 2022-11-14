[findBillInfo]
SELECT * FROM business_billing WHERE applicationid=$P{applicationid}

[getItems]
SELECT a.* FROM
(SELECT br.*, 
bl.assessmenttype AS lob_assessmenttype,
ri.code AS account_code,
CASE (br.taxfeetype) 
   WHEN 'TAX' THEN 0
   WHEN 'REGFEE' THEN 1
   ELSE 2
END AS sortorder,

( SELECT bi.decimalvalue FROM business_application_info bi 
  WHERE bi.applicationid=br.applicationid AND  bi.lob_objid=br.lob_objid AND br.taxfeetype= 'TAX' 
  AND (bi.attribute_objid='DECLARED_GROSS' OR  bi.attribute_objid='DECLARED_CAPITAL')) AS taxbase,

(SELECT 
SUM(pi.amount+pi.surcharge+pi.interest) 
FROM business_payment_item pi
INNER JOIN business_payment bp ON bp.objid=pi.parentid 
WHERE pi.receivableid=br.objid AND MONTH(bp.refdate) IN (1,2,3) AND pi.txntype='basic') AS q1, 

(SELECT 
SUM(pi.amount+pi.surcharge+pi.interest) 
FROM business_payment_item pi
INNER JOIN business_payment bp ON bp.objid=pi.parentid 
WHERE pi.receivableid=br.objid AND MONTH(bp.refdate) IN (4,5,6) AND pi.txntype='basic') AS q2, 

(SELECT 
SUM(pi.amount+pi.surcharge+pi.interest) 
FROM business_payment_item pi
INNER JOIN business_payment bp ON bp.objid=pi.parentid 
WHERE pi.receivableid=br.objid AND MONTH(bp.refdate) IN (7,8,9) AND pi.txntype='basic') AS q3, 

(SELECT 
SUM(pi.amount+pi.surcharge+pi.interest) 
FROM business_payment_item pi
INNER JOIN business_payment bp ON bp.objid=pi.parentid 
WHERE pi.receivableid=br.objid AND MONTH(bp.refdate) IN (10,11,12) AND pi.txntype='basic') AS q4,

(SELECT 
SUM(bi.amount+bi.surcharge+bi.interest) 
FROM business_billing_item bi
INNER JOIN business_billing bb ON bb.objid=bi.parentid
WHERE bi.receivableid=br.objid AND bi.qtr=2 ) AS bq2, 

(SELECT 
SUM(bi.amount+bi.surcharge+bi.interest) 
FROM business_billing_item bi
INNER JOIN business_billing bb ON bb.objid=bi.parentid
WHERE bi.receivableid=br.objid AND bi.qtr=3 ) AS bq3, 

(SELECT 
SUM(bi.amount+bi.surcharge+bi.interest) 
FROM business_billing_item bi
INNER JOIN business_billing bb ON bb.objid=bi.parentid
WHERE bi.receivableid=br.objid AND bi.qtr=4 ) AS bq4 
	
FROM business_receivable br
LEFT JOIN business_application ba ON ba.objid=br.applicationid
LEFT JOIN business_application_lob bl ON bl.applicationid=br.applicationid AND br.lob_objid=bl.lobid
LEFT JOIN itemaccount ri ON ri.objid=br.account_objid
WHERE ba.objid=$P{applicationid} ) a
ORDER BY a.sortorder

[getPayments]
SELECT * FROM business_payment WHERE applicationid=$P{applicationid} ORDER BY refdate, refno