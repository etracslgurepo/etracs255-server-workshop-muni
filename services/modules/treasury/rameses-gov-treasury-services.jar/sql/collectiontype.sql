[getList]
SELECT ct.* 
FROM collectiontype ct 
	LEFT JOIN sys_org o ON ct.org_objid=o.objid 
WHERE ct.name LIKE $P{searchtext} ${filter} 
ORDER BY ct.name 

[getFormTypes]
SELECT * FROM af  

[findAllByFormNo]
SELECT c.*, cf.formtype 
FROM collectiontype c
INNER JOIN af cf 
ON c.formno=cf.objid  
WHERE c.formno = $P{formno}
ORDER BY c.name

[getOnlineCollectionTypes]
SELECT ct.*, cf.formtype  
FROM ( 
	SELECT objid FROM collectiontype WHERE allowonline=1 AND org_objid IS NULL AND $P{clientcode} IS NULL 
	UNION 
	SELECT objid FROM collectiontype WHERE allowonline=1 AND org_objid=$P{orgcode} AND $P{clientcode} IS NULL 
	UNION 
	SELECT objid FROM collectiontype WHERE allowonline=1 AND org_objid=$P{clientcode} AND $P{clientcode} IS NOT NULL 
)bt 
	INNER JOIN collectiontype ct ON bt.objid=ct.objid 
	INNER JOIN af cf ON ct.formno=cf.objid 
WHERE NOT(ct.objid IS NULL) ${filter}	
ORDER BY ct.sortorder 


[getOfflineCollectionTypes]
SELECT ct.*, cf.formtype  
FROM ( 
	SELECT objid FROM collectiontype WHERE allowoffline=1 AND org_objid IS NULL AND $P{clientcode} IS NULL 
	UNION 
	SELECT objid FROM collectiontype WHERE allowoffline=1 AND org_objid=$P{orgcode} AND $P{clientcode} IS NULL 
	UNION 
	SELECT objid FROM collectiontype WHERE allowoffline=1 AND org_objid=$P{clientcode} AND $P{clientcode} IS NOT NULL 
)bt 
	INNER JOIN collectiontype ct ON bt.objid=ct.objid 
	INNER JOIN af cf ON ct.formno=cf.objid 
WHERE NOT(ct.objid IS NULL) ${filter}	
ORDER BY ct.sortorder 
 
[getBatchCollectionTypes]
SELECT ct.*, cf.formtype  
FROM collectiontype ct 
INNER JOIN af cf ON ct.formno=cf.objid 
WHERE allowbatch=1 AND org_objid IS NULL
ORDER BY ct.sortorder 


[getBatchCollectionTypesByOrgClass]
SELECT ct.*, cf.formtype  
FROM collectiontype ct 
INNER JOIN af cf ON ct.formno=cf.objid 
INNER JOIN sys_org so ON so.objid=ct.org_objid
WHERE allowbatch=1  AND so.orgclass=$P{orgclass}
ORDER BY ct.sortorder

[getBatchCollectionTypesByOrg]
SELECT ct.*, cf.formtype  
FROM collectiontype ct 
INNER JOIN af cf ON ct.formno=cf.objid 
WHERE allowbatch=1  AND org_objid=$P{orgcode}
ORDER BY ct.sortorder 

[approve]
UPDATE collectiontype SET state='APPROVED' WHERE objid=$P{objid}

[getFormTypesForBatch]
select distinct  cf.*  
from collectiontype ct
	inner join af cf on ct.formno = cf.objid
where allowbatch=1

[findAllByFormNoForBatch]
SELECT c.*, cf.formtype 
FROM collectiontype c
INNER JOIN af cf 
ON c.formno=cf.objid 
WHERE c.formno = $P{formno} and allowbatch=1
ORDER BY c.name

[getFormTypesSerial]
select * from af 

[findCollectionTypeByBarcode]
SELECT * FROM collectiontype WHERE barcodekey=$P{barcode}

[findCollectionTypeByHandler]
select * from collectiontype where handler=$P{handler} 

[getCategories]
SELECT DISTINCT category FROM collectiontype WHERE NOT(category IS NULL) ORDER BY category