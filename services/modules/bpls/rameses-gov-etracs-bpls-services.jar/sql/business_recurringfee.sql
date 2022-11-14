[getList]
select rf.*, 
	ia.code as account_code, 
	tt.feetype as txntype_feetype
from business_recurringfee rf
	inner join itemaccount ia ON ia.objid = rf.account_objid
	left join business_billitem_txntype tt on tt.objid = rf.txntype_objid 
WHERE rf.businessid = $P{businessid}
