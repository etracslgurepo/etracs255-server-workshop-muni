[getTopNPayments]
select distinct 
	x.amount
from (
	select 
		payer_name,
		sum(amount) as amount
	from report_rptcollection_annual_bypayer
	where year = $P{year}
    and rputype like $P{type}
	group by payer_name
) x 
order by x.amount desc 

[getTopNTaxpayerPayments]
select 
    x.*
from (
	select 
		payer_name,
		sum(amount) as amount
	from report_rptcollection_annual_bypayer
	where year = $P{year}
    and rputype like $P{type}
	group by payer_name
) x 
where x.amount = $P{amount}
order by x.payer_name


[findFirstItem]
select *
from report_rptcollection_annual_bypayer
where year = $P{year}
	and rputype like $P{type}

[deleteSummaries]	
delete from report_rptcollection_annual_bypayer 
where year = $P{year}

[insertSummaries]
insert into report_rptcollection_annual_bypayer(
  rputype,
	year, 
	payer_name,
	amount,
  dtgenerated
)
select 
  rl.rputype,
		year(c.receiptdate), 
		c.paidby as payer_name, 
		sum(
			basic + basicint - basicdisc + 
			sef + sefint - sefdisc + firecode +
			basicidle + basicidleint - basicidledisc +
			sh + shint - shdisc
		) as amount,
    $P{dtgenerated} as dtgenerated
from collectionvoucher cv
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt c on rem.objid = c.remittanceid 
	left join cashreceipt_void crv on c.objid = crv.receiptid
	inner join rptpayment rp on c.objid = rp.receiptid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
where cv.controldate >= $P{fromdate} and cv.controldate < $P{todate}
group by rl.rputype, c.receiptdate,  c.paidby 


