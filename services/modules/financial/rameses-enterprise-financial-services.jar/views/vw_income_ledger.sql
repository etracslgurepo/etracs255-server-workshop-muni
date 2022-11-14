DROP VIEW IF EXISTS vw_income_ledger
;
CREATE VIEW vw_income_ledger AS
SELECT 
	YEAR(jev.jevdate) AS year, MONTH(jev.jevdate) AS month, 
	jev.fundid, l.itemacctid, cr AS amount, l.jevid, l.objid  
FROM income_ledger l 
	INNER JOIN jev ON jev.objid = l.jevid
UNION ALL 
SELECT 
	YEAR(jev.jevdate) AS year, MONTH(jev.jevdate) AS month, 
	jev.fundid, l.refitemacctid as itemacctid, 
	(l.cr - l.dr) AS amount, l.jevid, l.objid  
FROM payable_ledger l  
	INNER JOIN jev ON jev.objid = l.jevid
;