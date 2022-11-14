[getRootNodes]
select a.* FROM form60setup a WHERE a.type='category' order by code

[getChildNodes]
SELECT * FROM form60setup a WHERE type='item' and parentid=$P{objid}  order by code

[getList]
SELECT * FROM form60setup a WHERE type='item' and parentid=$P{objid} order by code

[getSearch]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM form60setup WHERE code LIKE $P{searchtext} and type='item' 
  UNION 
  SELECT * FROM form60setup WHERE title LIKE $P{searchtext} and type='item' 
) a
 ORDER BY a.code 

[getLookup]
SELECT a.* FROM 
(
	SELECT objid,code,title,type FROM form60setup t WHERE t.code LIKE $P{searchtext} AND type='item'
	UNION
	SELECT objid,code,title,type FROM form60setup t WHERE t.title LIKE $P{searchtext} AND type='item'
) a
ORDER BY a.code


[getRevenueItemList]
SELECT r.objid,r.code,r.title,
fs.objid AS account_objid, fs.title AS account_title, fs.code AS account_code
FROM itemaccount r 
LEFT JOIN form60account m ON m.revenueitemid=r.objid
LEFT JOIN form60setup fs ON fs.objid=m.parentid
WHERE r.title LIKE $P{searchtext} 
ORDER BY r.code

[getRevenueItemListByCode]
SELECT r.objid,r.code,r.title,
fs.objid AS account_objid, fs.title AS account_title, fs.code AS account_code
FROM itemaccount r 
LEFT JOIN form60account m ON m.revenueitemid=r.objid
LEFT JOIN form60setup fs ON fs.objid=m.parentid
WHERE r.code LIKE $P{searchtext} 
ORDER BY r.code