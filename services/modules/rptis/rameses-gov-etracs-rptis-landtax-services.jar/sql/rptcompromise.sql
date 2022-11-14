[getList]
SELECT 
	c.objid, c.state, c.txnno, c.txndate, c.rptledgerid, 
	c.secondpartyname, c.term, c.numofinstallment, 
	c.downpaymentrequired, c.downpayment, c.downpaymentorno,
	c.amount, c.amtpaid, c.enddate, c.cypaymentrequired, c.cypaymentorno, 
	rl.tdno, e.objid as taxpayer_objid, e.name AS taxpayer_name, e.address_text AS taxpayer_address, 
	rl.fullpin, rl.cadastrallotno
FROM rptcompromise c 
	INNER JOIN rptledger rl ON c.rptledgerid = rl.objid 
	INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
WHERE (c.txnno LIKE $P{searchtext} 
   OR rl.tdno LIKE $P{searchtext} 
   OR rl.owner_name LIKE $P{searchtext}
   OR rl.cadastrallotno LIKE $P{searchtext}
   OR rl.taxpayer_objid LIKE $P{searchtext})
ORDER BY c.txnno 

[getLookupList]
SELECT c.* , rl.tdno, rl.cadastrallotno 
FROM rptcompromise c 
	INNER JOIN rptledger rl ON c.rptledgerid = rl.objid 
WHERE ${whereclause} 


[getUnpaidItems]
select 
	objid, 
	parentid,
	rptledgerfaasid, 
	year, 
	qtr, 
	revtype,
	revperiod,
	amount - amtpaid as amount,
	interest - interestpaid as interest,
	0 as discount,
	amount - amtpaid + interest - interestpaid as total, 
	priority,
	taxdifference
from rptcompromise_item
where parentid = $P{objid}
and amount - amtpaid + interest - interestpaid > 0 
order by year 


[getPaidInstallmentsByReceipt]
SELECT i.*
FROM rptcompromise_installment  i 
	inner join rptcompromise_credit c on i.objid = c.installmentid 
WHERE c.receiptid = $P{objid}
ORDER BY i.installmentno

[getItemsForPrinting]
SELECT
	rl.owner_name, 
	rl.tdno,
	rl.rputype,
	rl.totalav, 
	rl.fullpin,
	rl.totalareaha * 10000 AS  totalareasqm,
	rl.cadastrallotno,
	rl.classcode,
	b.name AS barangay,
	md.name as munidistrict,
	pct.name as provcity, 
	rp.fromyear, 
	rp.fromqtr, 
	rp.toyear,
	rp.toqtr,
	sum(case when rpi.revtype = 'basic' then rpi.amount else 0 end) as basic,
	sum(case when rpi.revtype = 'basic' then rpi.interest else 0 end) as basicint,
	sum(case when rpi.revtype = 'basic' then rpi.discount else 0 end) as basicdisc,
	sum(case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end) as basicdp,
	sum(case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end) as basicnet,
	sum(case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end) as basicidle,
	sum(case when rpi.revtype = 'basicidle' then rpi.interest else 0 end) as basicidleint,
	sum(case when rpi.revtype = 'basicidle' then rpi.discount else 0 end) as basicidledisc,
	sum(case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end) as basicidledp,
	sum(case when rpi.revtype = 'sef' then rpi.amount else 0 end) as sef,
	sum(case when rpi.revtype = 'sef' then rpi.interest else 0 end) as sefint,
	sum(case when rpi.revtype = 'sef' then rpi.discount else 0 end) as sefdisc,
	sum(case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end) as sefdp,
	sum(case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end) as sefnet,
	sum(case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end) as firecode,
	sum(case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end) as sh,
	sum(case when rpi.revtype = 'sh' then rpi.interest else 0 end) as shint,
	sum(case when rpi.revtype = 'sh' then rpi.discount else 0 end) as shdisc,
	sum(case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end) as shdp,
	sum(rpi.amount + rpi.interest - rpi.discount) as amount,
	max(rpi.partialled) as partialled 
FROM rptpayment rp 
	INNER JOIN rptpayment_item rpi ON rp.objid = rpi.parentid
	INNER JOIN rptledger rl ON rp.refid = rl.objid 
	INNER JOIN sys_org b ON rl.barangayid = b.objid
	inner join sys_org md on md.objid = b.parent_objid 
	inner join sys_org pct on pct.objid = md.parent_objid
	left join rptcompromise rc on rl.objid = rc.rptledgerid
WHERE rp.receiptid = $P{objid}
GROUP BY 
	rl.owner_name, 
	rl.tdno,
	rl.rputype,
	rl.totalav, 
	rl.fullpin,
	rl.totalareaha,
	rl.cadastrallotno,
	rl.classcode,
	b.name,
	md.name,
	pct.name,
	rp.fromyear, 
	rp.fromqtr, 
	rp.toyear,
	rp.toqtr
ORDER BY rp.fromyear 	






[getUnpaidLedgerItems]
select 
	rci.objid,
	rc.rptledgerid as parentid,
	rlf.objid as rptledgerfaasid,
	rlf.objid as rptledgerfaas_objid,
	null as remarks,
	rlf.assessedvalue as basicav,
	rlf.assessedvalue as sefav,
	rlf.assessedvalue as  av,
	rci.revtype,
	rci.year,
	rci.qtr, 
	rci.amount,
	rci.amtpaid,
	rci.priority,
	rci.taxdifference,
	0 as system
from rptcompromise rc 
inner join rptcompromise_item rci on rc.objid = rci.parentid 
inner join rptledgerfaas rlf on rci.rptledgerfaasid = rlf.objid 
where rc.objid = $P{objid}
and (rci.amount - rci.amtpaid + rci.interest - rci.interestpaid) > 0



[findFirstUnpaidCompromiseItem]
select * 
from rptcompromise_item
where parentid = $P{objid}
  and (amount - amtpaid + interest - interestpaid ) > 0
order by year


[findLastPaidCompromiseItem]
select * 
from rptcompromise_item
where parentid = $P{objid}
  and amount - amtpaid + interest - interestpaid <= 0 
order by year desc


[findCompromiseByReceiptForVoiding]
SELECT DISTINCT cr.parentid, cr.rptreceiptid
FROM rptcompromise_credit cr 
WHERE receiptid = $P{objid}









[getDefaultedCompromises]
select *
from rptcompromise
where enddate < $P{enddate}
  and state = 'APPROVED' 




[findLedgerItem]
select * from rptledgeritem where rptledgerid = $P{rptledgerid} and year = $P{partialledyear}

