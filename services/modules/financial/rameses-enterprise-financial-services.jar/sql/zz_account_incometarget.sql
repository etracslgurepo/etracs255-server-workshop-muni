[getList]
SELECT 
a.objid, a.code as account_code, 
a.title AS account_title,
(SELECT target FROM account_incometarget WHERE objid=a.objid AND year=${year} limit 1) AS target 
FROM account a 
WHERE a.type='detail' AND a.code LIKE $P{code} 
ORDER BY a.code




