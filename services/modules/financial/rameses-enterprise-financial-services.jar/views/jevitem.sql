DROP VIEW IF EXISTS jevitem;

CREATE VIEW jevitem AS 

SELECT 
ia.objid, cl.jevid, ia.code AS acctcode, ia.title AS acctname, SUM(dr) AS dr, SUM(cr) AS cr, NULL AS itemrefid 
FROM cash_treasury_ledger cl
INNER JOIN itemaccount ia ON ia.objid=cl.`itemacctid` 
GROUP BY ia.objid,cl.jevid,ia.code,ia.title

UNION ALL  

SELECT 
ia.objid, cl.jevid, ia.code AS acctcode, ia.title AS acctname,  SUM(dr) AS dr, SUM(cr) AS cr, NULL AS itemrefid 
FROM bankaccount_ledger cl
INNER JOIN itemaccount ia ON ia.objid=cl.itemacctid 
GROUP BY ia.objid,cl.jevid,ia.code,ia.title

UNION ALL  

SELECT
ia.objid, cl.jevid, ia.code AS acctcode, ia.title AS acctname,  SUM(dr) AS dr, SUM(cr) AS cr, NULL AS itemrefid 
FROM income_ledger cl
INNER JOIN itemaccount ia ON ia.objid=cl.itemacctid 
GROUP BY ia.objid,cl.jevid,ia.code,ia.title

UNION ALL

SELECT
ia.objid, cl.jevid,  ia.code AS acctcode, ia.title AS acctname,  SUM(dr) AS dr, SUM(cr) AS cr, ra.objid AS itemrefid
FROM payable_ledger cl
INNER JOIN itemaccount ia ON ia.objid=cl.itemacctid 
INNER JOIN itemaccount ra ON ra.objid=cl.refitemacctid 
GROUP BY ia.objid,cl.jevid,ia.code,ia.title
