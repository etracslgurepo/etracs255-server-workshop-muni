[findExpiryDate]
SELECT expirydate FROM business_billing WHERE applicationid=$P{applicationid}

[findByApplicationid]
SELECT bb.*, b.businessname, b.tradename, b.address_text, b.owner_name, b.owner_address_text,
ba.apptype, ba.appyear, ba.appno 
FROM business_billing bb
INNER JOIN business b ON bb.businessid=b.objid
INNER JOIN business_application ba ON ba.objid=bb.applicationid
WHERE bb.applicationid=$P{applicationid}

[findByBusinessAndYear]
SELECT bb.*, b.businessname, b.tradename, b.address_text, b.owner_name, b.owner_address_text, b.apptype  
FROM business_billing bb 
INNER JOIN business b ON bb.businessid=b.objid
WHERE businessid=$P{businessid} AND appyear=$P{appyear}

[removeItems]
DELETE FROM business_billing_item WHERE parentid=$P{objid}

[findApplicationBill]
SELECT 
b.businessname, b.tradename, b.address_text, b.owner_name, b.owner_address_text, 
ba.appno, bb.*
FROM business_billing bb 
INNER JOIN business b ON bb.businessid=b.objid
INNER JOIN business_application ba ON bb.applicationid=ba.objid
WHERE ba.objid=$P{applicationid}

[getBillItems]
SELECT a.* FROM 
(SELECT bi.*, (bi.amount + bi.surcharge+bi.interest-bi.discount) AS total, l.name AS lob_name,
(sortorder * 10 + qtr) AS isortorder
FROM business_billing_item bi 
LEFT JOIN lob l ON bi.lob_objid=l.objid
WHERE bi.parentid=$P{objid}) a
ORDER BY a.isortorder

[getOpenBillItemsByQtr]
SELECT bi.* 
FROM business_billing_item bi
INNER JOIN business_billing b ON bi.parentid=b.objid
WHERE b.applicationid=$P{applicationid}
AND bi.qtr <= $P{qtr}

[getUnpaidBillsByBIN]
SELECT b.bin, bb.amount AS amtdue, bb.surcharge, bb.interest, bb.expirydate 
FROM business_billing bb 
INNER JOIN business b ON bb.businessid=b.objid 
WHERE b.bin = $P{bin}
