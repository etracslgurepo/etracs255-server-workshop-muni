[removeAccounts]
DELETE FROM creditmemotype_account WHERE typeid = $P{objid}

[getAccounts]
SELECT ca.*, ri.code AS account_code, ri.fund_objid AS account_fund_objid,
ri.fund_title AS account_fund_title, ri.fund_code AS account_fund_code 
FROM creditmemotype_account ca
INNER JOIN itemaccount ri ON ri.objid=ca.account_objid
WHERE ca.typeid=$P{objid} ORDER BY ca.sortorder ASC

[findAccount]
SELECT ca.*, ri.code AS account_code, ri.fund_objid AS account_fund_objid,
ri.fund_title AS account_fund_title, ri.fund_code AS account_fund_code 
FROM creditmemotype_account ca
INNER JOIN itemaccount ri ON ri.objid=ca.account_objid
WHERE ca.typeid=$P{objid} ORDER BY ca.sortorder ASC
