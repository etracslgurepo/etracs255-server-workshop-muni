[getReceiptsByControlid]
select 
	objid, controlid, series, 
	receiptno, receiptdate, amount, 
	collectiontype_name, collector_name 
from cashreceipt 
where controlid=$P{controlid} 
order by series desc 
 

[getReceiptFunds]
select distinct 
	cr.collector_objid, ia.fund_objid 
from cashreceipt cr 
	inner join cashreceiptitem cri on cr.objid=cri.receiptid 
	inner join itemaccount ia on cri.item_objid=ia.objid 
where cr.controlid=$P{controlid}  

[getRemittances]
select distinct 
	cr.remittanceid 
from cashreceipt cr 
	inner join remittance rem on cr.remittanceid=rem.objid 
where cr.controlid=$P{controlid} 

[getLiquidationRemittances]
select * from liquidation_remittance where objid in (${remittanceids}) 

[removeBatchCollections]
delete from batchcapture_collection where controlid=$P{controlid} 

[removeBatchCollectionEntries]
delete from batchcapture_collection_entry where parentid in (  
	select objid from batchcapture_collection 
	where controlid=$P{controlid} 
)  

[removeBatchCollectionEntryItems]
delete from batchcapture_collection_entry_item where parentid in (  
	select b.objid from batchcapture_collection a 
		inner join batchcapture_collection_entry b on a.objid=b.parentid 
	where a.controlid=$P{controlid} 
) 

[removeReceipts]
delete from cashreceipt where controlid=$P{controlid} 

[removeReceiptItems]
delete from cashreceiptitem where receiptid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeVoidReceipts]
delete from cashreceipt_void where receiptid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeCancelReceipts]
delete from cashreceipt_cancelseries where receiptid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeBurialReceipts]
delete from cashreceipt_burial where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
) 

[removeCTReceipts]
delete from cashreceipt_cashticket where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeCTCIReceipts]
delete from cashreceipt_ctc_individual where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeCTCCReceipts]
delete from cashreceipt_ctc_corporate where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeLCOReceipts]
delete from cashreceipt_largecattleownership where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeLCTReceipts]
delete from cashreceipt_largecattletransfer where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeMarriageReceipts]
delete from cashreceipt_marriage where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeSlaughterReceipts]
delete from cashreceipt_slaughter where objid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeCreditMemoReceipts]
delete from cashreceiptpayment_creditmemo where receiptid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)

[removeNonCashReceipts]
delete from cashreceiptpayment_noncash where receiptid in ( 
	select objid from cashreceipt 
	where controlid=$P{controlid} 
)
