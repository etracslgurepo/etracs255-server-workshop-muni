[getList]
SELECT 
    bl.*, 
    lc.name AS classification_name, 
    lc.objid as classification_objid   
FROM business_active_lob bl
INNER JOIN lob ON bl.lobid=lob.objid
INNER JOIN lobclassification lc ON lob.classification_objid=lc.objid 
WHERE bl.businessid = $P{businessid} 

[removeList]
DELETE FROM business_active_lob WHERE businessid=$P{businessid}


[findLob]
select * from business_active_lob 
where businessid=$P{businessid} and lobid=$P{lobid}


[removeLob]
delete from business_active_lob 
where businessid=$P{businessid} and lobid=$P{lobid}
