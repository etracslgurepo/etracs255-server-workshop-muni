[findCompromiseByTxnno]
select * from rptcompromise where txnno = $P{txnno}


[resetPayment]
update rptcompromise_item set 
	amtpaid = 0,
	interestpaid = 0
where parentid = $P{objid}	


[findPayment]
select sum(amount) as amtpaid 
from rptcompromise_credit c 
left join cashreceipt_void cv on c.receiptid = cv.objid 
where parentid = $P{objid}
and cv.objid is null 
and c.remarks not like '%current%'


[getItems]
select objid, year, amount, interest, amount + interest as total
from rptcompromise_item 
where parentid = $P{objid}
order by year, priority


[updateFullyPaidItem]
update rptcompromise_item set 
	basicpaid = basic,
	basicintpaid = basicint,
	basicidlepaid = basicidle,
	sefpaid = sef,
	sefintpaid = sefint,
	firecodepaid = firecode,
	basicidleintpaid = basicidleint,
	fullypaid = 1
where objid = $P{objid}	

[updatePartialledItem]
update rptcompromise_item set 
	basicpaid = $P{basicpaid},
	basicintpaid = $P{basicintpaid},
	basicidlepaid = $P{basicidlepaid},
	sefpaid = $P{sefpaid},
	sefintpaid = $P{sefintpaid},
	firecodepaid = $P{firecodepaid},
	basicidleintpaid = $P{basicidleintpaid},
	fullypaid = 0
where objid = $P{objid}	

