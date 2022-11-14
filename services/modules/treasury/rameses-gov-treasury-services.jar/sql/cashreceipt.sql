[getTxnTypes]
SELECT * FROM cashreceipt_txntype 

[getList]
SELECT c.*, 
	CASE WHEN v.receiptid IS NULL THEN 0 ELSE 1 END AS voided,  
	CASE WHEN r.objid IS NULL THEN 0 ELSE 1 END AS remitted  
FROM cashreceipt c 
	LEFT JOIN remittance r on r.objid = c.remittanceid 
	LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE c.receiptno LIKE $P{searchtext} 
ORDER BY ${orderBy} 


[getListByPaidBy]
SELECT c.*, 
	CASE WHEN v.receiptid IS NULL THEN 0 ELSE 1 END AS voided,  
	CASE WHEN r.objid IS NULL THEN 0 ELSE 1 END AS remitted  
FROM cashreceipt c 
	LEFT JOIN remittance r on r.objid = c.remittanceid 
	LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE c.paidby LIKE $P{searchtext} 
ORDER BY ${orderBy} 


[getListByPayer]
SELECT c.*, 
	CASE WHEN v.receiptid IS NULL THEN 0 ELSE 1 END AS voided,  
	CASE WHEN r.objid IS NULL THEN 0 ELSE 1 END AS remitted  
FROM cashreceipt c 
	LEFT JOIN remittance r on r.objid = c.remittanceid 
	LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
WHERE c.payer_name LIKE $P{searchtext} 
ORDER BY ${orderBy} 


[findCashReceiptInfo]
SELECT c.*, 
	CASE WHEN v.receiptid IS NULL THEN 0 ELSE 1 END AS voided,  
	CASE WHEN r.objid IS NULL THEN 0 ELSE 1 END AS remitted,
	ct.handler AS collectiontype_handler,
	ct.servicename AS collectiontype_servicename,
	ct.connection AS collectiontype_connection	
FROM cashreceipt c 
	LEFT JOIN remittance r ON r.objid = c.remittanceid 
	LEFT JOIN cashreceipt_void v ON c.objid = v.receiptid
	LEFT JOIN collectiontype ct ON ct.objid = c.collectiontype_objid
WHERE c.objid = $P{objid} 

[getItems]
SELECT ci.*, r.fund_objid AS item_fund_objid, r.fund_title AS item_fund_title
FROM cashreceiptitem ci
	INNER JOIN itemaccount r ON r.objid = ci.item_objid
WHERE ci.receiptid=$P{objid}

[getNoncashPayments]
SELECT * FROM cashreceiptpayment_noncash WHERE receiptid=$P{objid}

[updateState]
update cashreceipt set state=$P{state} where objid=$P{objid}

[findAFSummary]
select sum(amount) as amount 
from cashreceipt cr 
where controlid=$P{controlid} 
	and objid not in (
		select receiptid from cashreceipt_void where receiptid=cr.objid
	) 

[removeReceiptVoid]
delete from cashreceipt_void where receiptid=$P{receiptid}  

[removeReceiptItems]
delete from cashreceiptitem where receiptid=$P{receiptid} 

[removeReceipt]
delete from cashreceipt where objid=$P{receiptid} 

[getReceipts]
select objid, controlid, series, amount 
from cashreceipt cr 
where controlid=$P{controlid} 
	and objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
order by series 

[findMaxReceiptDateByControlid]
select max(receiptdate) as receiptdate 
from cashreceipt 
where controlid=$P{controlid} 

[findAFReceiptSummary]
select 
	controlid, 
	min(series) as minseries, 
	max(series) as maxseries 
from cashreceipt  
where controlid=$P{controlid} 
group by controlid   
