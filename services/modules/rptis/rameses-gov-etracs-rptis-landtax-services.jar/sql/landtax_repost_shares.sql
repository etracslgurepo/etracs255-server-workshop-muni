[clearForRepostEntries]
delete from  cashreceipt_rpt_share_forposting_repost

[insertReceiptToRepost]
insert into cashreceipt_rpt_share_forposting_repost (
	objid,
	rptpaymentid,
	receiptid,
	receiptdate,
	rptledgerid,
	error,
	receipttype
)
select 
	CONCAT(rp.objid, '-', cr.objid) as objid,
	rp.objid as rptpaymentid,
	cr.objid as receiptid, 
	cr.receiptdate,
	rp.refid as rptledgerid,
	0 as error,
	'ONLINE' as receipttype
from collectionvoucher cv
inner join remittance rem on cv.objid = rem.collectionvoucherid
inner join cashreceipt cr on rem.objid = cr.remittanceid
inner join rptpayment rp on cr.objid = rp.receiptid
left join cashreceipt_void crv on crv.receiptid = cr.objid 
where cv.controldate >= $P{startdate} and cv.controldate < $P{enddate}
and crv.objid is null

[deleteRptSharesToRepost]
delete from rptpayment_share 
where parentid in (select rptpaymentid from cashreceipt_rpt_share_forposting_repost)

[deleteCashReceiptSharesToRepost]
delete from cashreceipt_share 
where receiptid in (
	select distinct receiptid from cashreceipt_rpt_share_forposting_repost
)

[findRemainingCount]
select count(*) as remaining from cashreceipt_rpt_share_forposting_repost
