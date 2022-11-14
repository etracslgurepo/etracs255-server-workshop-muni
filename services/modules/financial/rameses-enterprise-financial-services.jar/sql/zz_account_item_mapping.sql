[getAllList]
SELECT a.* FROM account a  WHERE a.parentid IS NULL and a.type='group' ORDER BY a.code
