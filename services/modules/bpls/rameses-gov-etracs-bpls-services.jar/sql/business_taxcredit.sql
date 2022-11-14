[getList]
SELECT tci.* 
FROM business_taxcredit tc
INNER JOIN business_taxcredit_item tci ON tci.parentid=tc.objid
WHERE tc.businessid=$P{businessid}

