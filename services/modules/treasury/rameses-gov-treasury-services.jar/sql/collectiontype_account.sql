[removeAccounts]
DELETE FROM collectiontype_account WHERE collectiontypeid = $P{objid}

[getAccounts]
SELECT ca.*, ri.code AS account_code, ri.fund_objid AS account_fund_objid,
ri.fund_title AS account_fund_title, ri.fund_code AS account_fund_code 
FROM collectiontype_account ca
INNER JOIN itemaccount ri ON ri.objid=ca.account_objid
WHERE ca.collectiontypeid=$P{objid} ORDER BY ca.sortorder ASC

[findAccount]
SELECT ca.*, ri.code AS account_code, ri.fund_objid AS account_fund_objid,
ri.fund_title AS account_fund_title, ri.fund_code AS account_fund_code 
FROM collectiontype_account ca
INNER JOIN itemaccount ri ON ri.objid=ca.account_objid
WHERE ca.collectiontypeid=$P{objid} ORDER BY ca.sortorder ASC

[findAccountByTag]
SELECT ca.*, ri.code AS account_code, ri.fund_objid AS account_fund_objid,
ri.fund_title AS account_fund_title, ri.fund_code AS account_fund_code 
FROM collectiontype_account ca
INNER JOIN itemaccount ri ON ri.objid=ca.account_objid
WHERE ca.collectiontypeid=$P{objid} AND ca.tag=$P{tag} 

[findAccountByHandlerAndTag]
SELECT cta.*,  
	ia.code AS account_code, ia.fund_objid AS account_fund_objid,
	ia.fund_title AS account_fund_title, ia.fund_code AS account_fund_code 
FROM collectiontype ct, collectiontype_account cta, itemaccount ia 
WHERE ct.handler=$P{handler} and cta.tag=$P{tag} 
	AND ct.objid=cta.collectiontypeid 
	AND cta.account_objid=ia.objid 
