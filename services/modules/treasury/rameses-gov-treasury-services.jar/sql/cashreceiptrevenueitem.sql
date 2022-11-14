[getLookupBasicCashReceipt]
SELECT 
   r.objid,r.code,r.title, 
   r.fund_objid,  r.fund_code, r.fund_title, 
   cb.objid as cashbookid   
FROM itemaccount r 
LEFT JOIN cashbook cb ON cb.fund_objid=r.fund_objid AND cb.subacct_objid = $P{collectorid}
WHERE (r.title LIKE $P{title}  OR r.code LIKE $P{code} ) and r.state = 'APPROVED'

[getLookupExtendedCashReceipt]
SELECT 
   r.objid,r.code,r.title, 
   r.fund_objid,  r.fund_code, r.fund_title, 
   cb.objid as cashbookid   
FROM itemaccount r 
LEFT JOIN cashbook cb ON cb.fund_objid=r.fund_objid AND cb.subacct_objid = $P{collectorid}
WHERE r.objid IN ( ${filter} ) and r.state = 'APPROVED'

