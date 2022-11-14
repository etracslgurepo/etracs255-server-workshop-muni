[getRootNodes]
SELECT a.* FROM account a  WHERE a.parentid IS NULL and a.type='group' ORDER BY a.code

[getChildNodes]
SELECT a.* FROM account a WHERE a.parentid=$P{objid} and a.type='group' ORDER BY a.code

[getList]
SELECT * FROM account WHERE parentid=$P{objid} ORDER BY code 

[getSearch]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM account WHERE code LIKE $P{searchtext}
  UNION 
  SELECT * FROM account WHERE title LIKE $P{searchtext}
) a
 ORDER BY a.code 

[findInfo]
SELECT a.*, p.code AS parent_code, p.title AS parent_title 
FROM account a
LEFT JOIN account p ON a.parentid = p.objid
WHERE a.objid=$P{objid}

[getLookup]
SELECT a.* FROM 
(SELECT objid,code,title FROM account t WHERE t.code LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid}
UNION
SELECT objid,code,title FROM account t WHERE t.title LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid} ) 
AS a ORDER BY a.title

[approve]
UPDATE account SET state='APPROVED' WHERE objid=$P{objid} 

[changeParent]
UPDATE account SET parentid=$P{parentid} WHERE objid=$P{objid} 

[getSubaccounts]
SELECT a.* FROM account a WHERE a.parentid=$P{objid} AND a.type='subaccount' ORDER BY a.code