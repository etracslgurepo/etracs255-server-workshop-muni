[getCollectionsByCount]
SELECT TOP ${receiptcount}   
	cr.receiptno, cr.formno, 
	CASE WHEN cv.objid IS NULL THEN cr.amount  ELSE 0.0 END AS amount, 
	CASE WHEN cv.objid IS NULL THEN 0  ELSE 1 END AS voided 
FROM cashreceipt cr 
	LEFT JOIN cashreceipt_void cv ON cr.objid = cv.receiptid 
WHERE cr.remittanceid IS NULL 
  AND cr.txnmode = 'ONLINE' 
  AND ${filters} 
ORDER BY cr.txndate DESC 


[getCollections]
select * 
from ( 
	SELECT 
		cr.receiptno, cr.formno, cr.receiptdate, cr.txndate, 
		(CASE WHEN cv.objid IS NULL THEN cr.amount  ELSE 0.0 END) AS amount,
		(CASE WHEN cv.objid IS NULL THEN 0  ELSE 1 END) AS voided
	FROM cashreceipt cr 
		LEFT JOIN cashreceipt_void cv ON cr.objid = cv.receiptid 
	WHERE cr.collector_objid = $P{userid} 
		AND cr.subcollector_objid IS NULL 
		AND cr.remittanceid IS NULL 
		AND cr.txnmode = 'ONLINE'
  	AND ${filters} 

	UNION ALL 

	SELECT 
		cr.receiptno, cr.formno, cr.receiptdate, cr.txndate, 
		(CASE WHEN cv.objid IS NULL THEN cr.amount  ELSE 0.0 END) AS amount,
		(CASE WHEN cv.objid IS NULL THEN 0  ELSE 1 END) AS voided
	FROM cashreceipt cr 
		LEFT JOIN cashreceipt_void cv ON cr.objid = cv.receiptid 
	WHERE cr.subcollector_objid = $P{userid} 
		AND cr.remittanceid IS NULL 
		AND cr.txnmode = 'ONLINE'
  	AND ${filters} 
)t0 
ORDER BY t0.txndate DESC
