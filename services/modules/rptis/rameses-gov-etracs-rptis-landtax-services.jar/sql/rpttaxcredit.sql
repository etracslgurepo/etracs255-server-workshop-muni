[getCreditYearPayments]
select
	rp.receiptid,
	rp.receiptno,
	rp.receiptdate as txndate,
  	min(qtr) as startqtr,
	max(qtr) as endqtr,
	sum(rpi.amount - rpi.discount) as cr,
	sum(rpi.discount) as crdisc
from rptpayment rp 
inner join rptpayment_item rpi on rp.objid = rpi.parentid 
left join cashreceipt_void cv on rp.receiptid = cv.objid 
where rp.refid = $P{rptledgerid}
and rpi.year = $P{year}
and rp.type <> 'credit'
and cv.objid is null 
group by rp.receiptid, rp.receiptno, rp.receiptdate


[findTaxDueFromLedgerItem]
select 
	x.taxdue, 
	x.av, 
	(x.taxdue / x.av * 100) as rateoflevy
from (
	select 
		sum(amount) as taxdue, 
		min(av) as av
	from rptledger_item 
	where parentid = $P{rptledgerid}
	and year = $P{year}
	and taxdifference = 0
)x


[findTaxDueFromPaymentItem]
select 
	x.taxdue, 
	x.av, 
	(x.taxdue / x.av * 100) as rateoflevy
from (
	select 
		sum(rpi.amount) as taxdue, 
		min(rlf.assessedvalue) as av
	from rptpayment rp
	inner join rptpayment_item rpi on rpi.parentid = rp.objid 
	inner join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
	left join cashreceipt_void cv on rp.receiptid = cv.receiptid 
	where rp.refid = $P{rptledgerid}
	and year = $P{year}
	and cv.objid is null 
)x


[findDiscountAvailed]
select 
	sum(rpi.discount) as discount 
from rptpayment rp
inner join rptpayment_item rpi on rpi.parentid = rp.objid 
inner join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
left join cashreceipt_void cv on rp.receiptid = cv.receiptid 
where rp.refid = $P{rptledgerid}
and year = $P{year}
and cv.objid is null 




[closeBatchTaxCredits]
update batch_rpttaxcredit b, 
	batch_rpttaxcredit_ledger_posted bl, 
	rpttaxcredit c
set 
	c.state = 'CLOSED'
where b.objid = bl.parentid 
and bl.objid = c.rptledger_objid
and b.objid = $P{objid}
and c.state <> 'CLOSED'


[revertTaxCredits]
update 
	rptledger_item rli, 
	( select 
			bl.objid as rptledgerid,
			rpi.revtype, 
			rpi.year, 
			sum(rpi.amount) as amtpaid
		from batch_rpttaxcredit b 
		inner join batch_rpttaxcredit_ledger_posted bl on b.objid = bl.parentid 
		inner join rpttaxcredit t on bl.objid = t.rptledger_objid 
		inner join rptpayment rp on t.objid = rp.receiptid 
		inner join rptpayment_item rpi on rp.objid = rpi.parentid 
		where b.objid = $P{objid}
		and t.state <> 'CLOSED'
		group by bl.objid, revtype, year
	)x
set 
	rli.amtpaid = rli.amtpaid - x.amtpaid
where rli.parentid = x.rptledgerid
and rli.year = x.year 
and rli.revtype = x.revtype 


[findTaxDifference]
select 
	concat(
		year, 
		'-',
		case 
		when fromqtr = 1 then '01'
		when fromqtr = 2 then '04'
		when fromqtr = 3 then '07'
		else '10'
		end, 
		'-01') as txndate,
		remarks as particulars,
		sum(amount) as dr 
from rptledger_item 
where parentid = $P{objid}
and taxdifference = 1 
group by year, fromqtr, remarks

[findCreditInfo]
select 
	rp.receiptdate,
	sum(interest) as dr,
  sum(discount) as cr
from rptpayment rp
	inner join rptpayment_item rpi on rp.objid = rpi.parentid 
where rp.receiptid = $P{objid}
and rp.type = 'CREDIT'
and rp.fromyear = $P{year}
group by rp.receiptdate