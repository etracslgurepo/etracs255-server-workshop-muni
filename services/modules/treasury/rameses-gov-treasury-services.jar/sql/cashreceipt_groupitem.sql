[getReceipts]
select gi.*, c.receiptno
from cashreceipt_groupitem gi 
	inner join cashreceipt c on c.objid = gi.objid 
where gi.parentid = $P{parentid}
