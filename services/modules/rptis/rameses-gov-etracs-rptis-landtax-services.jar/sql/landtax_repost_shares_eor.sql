[getReceiptsToRepost]
select 
	cr.objid,
	cr.receiptdate,
	'EOR'as receipttype
from eor_remittance rem 
inner join eor cr on rem.objid = cr.remittanceid
where rem.controldate >= $P{startdate} and rem.controldate < $P{enddate}

[deleteEorShares]
delete from eor_share 
where parentid = $P{receiptid}


[insertEorShare]
insert into eor_share (
	objid,
	parentid,
	refitem_objid,
	refitem_code,
	refitem_title,
	payableitem_objid,
	payableitem_code,
	payableitem_title,
	amount,
	share,
	receiptitemid,
	refitem_fund_objid,
	payableitem_fund_objid
)
values(
	$P{objid},
	$P{parentid},
	$P{refitemid},
	$P{refitemcode},
	$P{refitemtitle},
	$P{payableitemid},
	$P{payableitemcode},
	$P{payableitemtitle},
	$P{amount},
	$P{share},
	$P{receiptitemid},
	$P{refitemfundid},
	$P{payableitemfundid}
)