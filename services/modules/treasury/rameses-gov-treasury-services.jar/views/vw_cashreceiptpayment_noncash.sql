create view vw_cashreceiptpayment_noncash 
as 
select nc.*, v.objid as void_objid, 
	(case when v.objid is null then 0 else 1 end) as voided, 
	c.receiptno as receipt_receiptno, c.receiptdate as receipt_receiptdate, c.amount as receipt_amount, 
	c.collector_objid as receipt_collector_objid, c.collector_name as receipt_collector_name, c.remittanceid, 
	rem.objid as remittance_objid, rem.controlno as remittance_controlno, rem.controldate as remittance_controldate
from cashreceiptpayment_noncash nc 
	inner join cashreceipt c on c.objid = nc.receiptid 
	left join cashreceipt_void v on v.receiptid = c.objid 
	left join remittance rem on rem.objid = c.remittanceid 
;
