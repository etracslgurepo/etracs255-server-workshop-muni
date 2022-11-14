
[getList]
SELECT 
 * 
FROM noticeofdelinquency  
WHERE doctype LIKE $P{doctype} 


[getListByDoctype]
SELECT 
 * 
FROM noticeofdelinquency  
WHERE doctype LIKE $P{doctype} 


[getLedgerForNoticeOfDeliquency] 
SELECT   
	objid, taxpayerid, taxpayerno, taxpayername,   
	taxpayeraddress, administratorname, administratoraddress   
FROM rptledger   
WHERE lastyearpaid <= $P{value}    
AND docstate = 'APPROVED' 

[updateNODByType]  
UPDATE noticeofdelinquency   
SET doctype = $P{doctype}  
WHERE objid = $P{objid}  
 
[getFaasListByLedgerid]
SELECT * FROM faaslist WHERE ledgerid = $P{ledgerid}