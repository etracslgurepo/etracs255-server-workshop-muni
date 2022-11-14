[getFunds]
select 
	fund.objid, fund.code, fund.title, 
	fund.groupid, fg.indexno as groupindexno 
from depositvoucher_fund dvf 
	inner join fund on fund.objid = dvf.fundid 
	inner join fundgroup fg on fg.objid = fund.groupid 
where dvf.parentid = $P{depositvoucherid} 
order by fg.indexno, LENGTH(fund.code), fund.code, fund.title 


[findDepositVoucherFund]
select dvf.amount, 0.0 as totalcash, 0.0 as totalcheck, 0.0 as totalcr, 
	fund.objid as fund_objid, fund.code as fund_code, fund.title as fund_title  
from depositvoucher_fund dvf 
	inner join fund on fund.objid = dvf.fundid 
where dvf.parentid = $P{depositvoucherid} 
	and dvf.fundid = $P{fundid}


[getLiquidations]
select 
	cv.liquidatingofficer_objid, cv.liquidatingofficer_name, 
	cv.controlno, cv.controldate, sum(cvf.amount-cvf.totalcr) as amount 
from depositvoucher dv 
	inner join collectionvoucher cv on cv.depositvoucherid = dv.objid 
	inner join collectionvoucher_fund cvf on cvf.parentid = cv.objid 
	inner join fund on fund.objid = cvf.fund_objid 	
where dv.objid = $P{depositvoucherid} 
	and fund.depositoryfundid like $P{fundid} 
group by cv.liquidatingofficer_objid, cv.liquidatingofficer_name, cv.controlno, cv.controldate  
order by cv.liquidatingofficer_name, cv.controldate, cv.controlno 


[getLiquidationsByBankAcct]
select 
	cv.liquidatingofficer_objid, cv.liquidatingofficer_name, 
	cv.controlno, cv.controldate, sum(cvf.amount-cvf.totalcr) as amount 
from ( 
	select distinct df.parentid as depositvoucherid, df.fundid
	from depositvoucher dv 
		inner join depositvoucher_fund df on df.parentid = dv.objid 
		inner join depositslip ds on ds.depositvoucherfundid = df.objid 
		inner join bankaccount ba on ba.objid = ds.bankacctid 
	where dv.objid = $P{depositvoucherid} 
		and ba.objid like $P{bankacctid} 
)t1 
	inner join collectionvoucher cv on cv.depositvoucherid = t1.depositvoucherid 
	inner join collectionvoucher_fund cvf on cvf.parentid = cv.objid 
	inner join fund on (fund.objid = cvf.fund_objid and fund.depositoryfundid = t1.fundid) 
group by cv.liquidatingofficer_objid, cv.liquidatingofficer_name, cv.controlno, cv.controldate


[getReceipts]
select 
	concat('AF#', ci.formno, ':', ci.collectiontype_name, '-', ff.title) as particular,
	sum(ci.amount) as amount 
from ( 
	select distinct df.parentid as depositvoucherid, df.fundid
	from depositvoucher dv 
		inner join depositvoucher_fund df on df.parentid = dv.objid 
	where dv.objid = $P{depositvoucherid} 
		and df.fundid like $P{fundid} 
)t1 
	inner join collectionvoucher cv on cv.depositvoucherid = t1.depositvoucherid 
	inner join vw_collectionvoucher_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
	inner join fund on (fund.objid = ci.fundid and fund.depositoryfundid = t1.fundid) 
	inner join fund ff on ff.objid = t1.fundid 
group by concat('AF#', ci.formno, ':', ci.collectiontype_name, '-', ff.title) 
order by concat('AF#', ci.formno, ':', ci.collectiontype_name, '-', ff.title)


[getReceiptsByBankAcct]
select 
	concat('AF#', ci.formno, ':', ci.collectiontype_name, '-', ff.title) as particular,
	sum(ci.amount) as amount 
from ( 
	select distinct df.parentid as depositvoucherid, df.fundid
	from depositvoucher dv 
		inner join depositvoucher_fund df on df.parentid = dv.objid 
		inner join depositslip ds on ds.depositvoucherfundid = df.objid 
		inner join bankaccount ba on ba.objid = ds.bankacctid 
	where dv.objid = $P{depositvoucherid} 
		and ba.objid like $P{bankacctid} 
)t1 
	inner join collectionvoucher cv on cv.depositvoucherid = t1.depositvoucherid 
	inner join vw_collectionvoucher_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
	inner join fund on (fund.objid = ci.fundid and fund.depositoryfundid = t1.fundid) 
	inner join fund ff on ff.objid = t1.fundid 
group by concat('AF#', ci.formno, ':', ci.collectiontype_name, '-', ff.title) 
order by concat('AF#', ci.formno, ':', ci.collectiontype_name, '-', ff.title)


[getRemittances]
select 
	dv.objid as depositvoucherid, dv.createdby_name as cashier_name, 
	concat(ba.bank_code, ' - ', ds.deposittype, ' D/S: Account ', ba.code) as refno, 
	sum(ds.amount) as amount, ds.deposittype  
from depositvoucher dv 
	inner join depositvoucher_fund df on df.parentid = dv.objid 
	inner join depositslip ds on ds.depositvoucherfundid = df.objid 
	inner join bankaccount ba on ba.objid = ds.bankacctid 
where dv.objid = $P{depositvoucherid} 
	and df.fundid like $P{fundid} 
group by 
	dv.objid, dv.createdby_name, concat(ba.bank_code, ' - ', ds.deposittype, ' D/S: Account ', ba.code), ds.deposittype 


[getBankAccounts]
select distinct 
	ba.objid, ba.code, ba.title, ba.accttype 
from depositvoucher dv 
	inner join depositvoucher_fund df on df.parentid = dv.objid 
	inner join depositslip ds on ds.depositvoucherfundid = df.objid 
	inner join bankaccount ba on ba.objid = ds.bankacctid 
where dv.objid = $P{depositvoucherid} 
order by ba.code, ba.title 


[getRemittancesByBankAcct]
select 
	dv.objid as depositvoucherid, dv.createdby_name as cashier_name, 
	concat(ba.bank_code, ' - ', ds.deposittype, ' D/S: Account ', ba.code) as refno, 
	sum(ds.amount) as amount, ds.deposittype  
from depositvoucher dv 
	inner join depositvoucher_fund df on df.parentid = dv.objid 
	inner join depositslip ds on ds.depositvoucherfundid = df.objid 
	inner join bankaccount ba on ba.objid = ds.bankacctid 
where dv.objid = $P{depositvoucherid} 
	and ba.objid like $P{bankacctid} 
group by 
	dv.objid, dv.createdby_name, concat(ba.bank_code, ' - ', ds.deposittype, ' D/S: Account ', ba.code), ds.deposittype  


[getDepositVoucherFundByBankAcct]
select distinct df.objid, df.amount 
from depositvoucher dv 
	inner join depositvoucher_fund df on df.parentid = dv.objid 
	inner join depositslip ds on ds.depositvoucherfundid = df.objid 
	inner join bankaccount ba on ba.objid = ds.bankacctid 
where dv.objid = $P{depositvoucherid} 
	and ba.objid like $P{bankacctid} 
