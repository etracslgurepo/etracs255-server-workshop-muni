[getItemsForPayment]
select rl.objid
from rptbill b 
	inner join rptbill_ledger bl on b.objid = bl.billid 
	inner join rptledger rl on bl.rptledgerid = rl.objid 
	inner join barangay brgy on rl.barangayid = brgy.objid 
	left join municipality m on brgy.parentid = m.objid 
	left join district d  on brgy.parentid = d.objid 
where b.objid = $P{objid}	
and rl.objid like $P{rptledgerid}
and (
 		( rl.lastyearpaid < $P{billtoyear} OR (rl.lastyearpaid = $P{billtoyear} AND rl.lastqtrpaid < $P{billtoqtr}))
 		or 
 		(exists(select * from rptledger_item where parentid = rl.objid))
 	)
order by rl.tdno 

[getItemsForPaymentByLedger]
select rl.objid
from rptledger rl
	inner join barangay brgy on rl.barangayid = brgy.objid 
	left join municipality m on brgy.parentid = m.objid 
	left join district d  on brgy.parentid = d.objid 
where rl.objid = $P{rptledgerid}
and (
 		( rl.lastyearpaid < $P{billtoyear} OR (rl.lastyearpaid = $P{billtoyear} AND rl.lastqtrpaid < $P{billtoqtr}))
 		or 
 		(exists(select * from rptledger_item where parentid = rl.objid))
 	)
order by rl.tdno 

[getItemsForPrinting]
select
	rl.objid as rptledgerid,
	rl.owner_name, 
	rl.tdno,
	rl.rputype,
	rl.totalav, 
	rl.fullpin,
	rl.totalareaha * 10000 AS  totalareasqm,
	rl.cadastrallotno,
	rl.blockno,
	rl.classcode,
	b.name AS barangay,
	md.name AS munidistrict,
	pct.name AS provcity, 
	min(rpi.year) as fromyear, 
	rp.fromqtr, 
	max(rpi.year) as toyear,
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
	INNER JOIN sys_org md ON md.objid = b.parent_objid 
	INNER JOIN sys_org pct ON pct.objid = md.parent_objid
where rp.receiptid = $P{objid}  
group by 
	rl.objid,
	rl.owner_name, 
	rl.tdno,
	rl.rputype,
	rl.totalav, 
	rl.fullpin,
	rl.totalareaha,
	rl.cadastrallotno,
	rl.blockno,
	rl.classcode,
	b.name,
	md.name,
	pct.name,
	rp.fromyear, 
	rp.fromqtr, 
	rp.toyear,
	rp.toqtr	


[getPaidLedgers]
select 
	rl.objid, 
	rl.tdno, 
	rl.fullpin, 
	rl.owner_name, 
	rl.totalav,
	rl.lastyearpaid,
	rl.lastqtrpaid
from rptpayment rp 
inner join rptledger rl on rp.refid = rl.objid 
where rp.receiptid = $P{objid}
order by rl.tdno 