    
[findLedgerInfo]  
SELECT 
    rl.tdno, rl.fullpin, rl.cadastrallotno, b.name AS barangay, 
    rl.totalmv, rl.totalav AS assessedvalue, rl.totalareaha,
    e.name AS taxpayer_name, e.address_text AS taxpayer_address
FROM rptledger rl 
    INNER JOIN barangay b ON rl.barangayid = b.objid 
    INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
WHERE rl.objid = $P{objid}

[getCredits]
select 
  'downpayment' as type,
  'Downpayment' as particular,
  cr.receiptno, 
  cr.receiptdate, 
  max(cro.year) as year, 
  sum(cro.basic - cro.basicdisc) as basic,
  sum(cro.basicidle - cro.basicidledisc) as basicidle,
  sum(cro.sef - cro.sefdisc) as sef,
  sum(cro.sh - cro.shdisc) as sh,
  sum(cro.firecode) as firecode,
  sum(cro.basicint + cro.sefint + cro.basicidleint + cro.shint) as penalty 
from rptcompromise rc 
  inner join cashreceipt cr on rc.downpaymentreceiptid = cr.objid
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join vw_rptpayment_item_detail cro on rp.objid = cro.parentid
where rc.objid = $P{objid}
group by cr.receiptno, cr.receiptdate

union all 

select 
  'cypayment' as type,
  'Current Year Payment' as particular,
  cr.receiptno, 
  cr.receiptdate, 
  max(cro.year) as year, 
  sum(cro.basic - cro.basicdisc) as basic,
  sum(cro.basicidle - cro.basicidledisc) as basicidle,
  sum(cro.sef - cro.sefdisc) as sef,
  sum(cro.sh - cro.shdisc) as sh,
  sum(cro.firecode) as firecode,
  sum(cro.basicint + cro.sefint + cro.basicidleint + cro.shint) as penalty 
from rptcompromise rc 
  inner join cashreceipt cr on rc.cypaymentreceiptid = cr.objid
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join vw_rptpayment_item_detail cro on rp.objid = cro.parentid
where rc.objid = $P{objid}
group by cr.receiptno, cr.receiptdate 


[getLedgerCredits]
select c.installmentid, c.ordate, c.orno, c.amount as oramount, c.remarks 
from rptcompromise_credit c
	left join rptcompromise_installment i on c.installmentid = i.objid 
where c.parentid = $P{objid}
order by i.installmentno, c.ordate, c.orno 