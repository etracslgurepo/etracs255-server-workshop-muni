[getReportA]
select dv.* 
from depositvoucher dv 
where dv.controldate >= $P{startdate} 
	and dv.controldate <  $P{enddate} 
	and dv.state in ('OPEN','POSTED') 
order by dv.controldate, dv.dtcreated  


[getReportB]
select 
	dv.controldate, cv.controlno, cv.totalcash, cv.totalcheck, 
	(cv.totalcash + cv.totalcheck) as amount 
from depositvoucher dv 
	inner join collectionvoucher cv on cv.depositvoucherid = dv.objid 
where dv.controldate >= $P{startdate} 
	and dv.controldate <  $P{enddate} 
	and dv.state in ('OPEN','POSTED') 
order by dv.controldate, cv.controlno 


[getReportByFund]
select 
	dv.controldate, dv.state, fund.title as particulars, 
	dvf.amount, dvf.amountdeposited, dvf.totaldr, dvf.totalcr, 
	fund.objid as fund_objid, fg.indexno 
from depositvoucher dv 
	inner join depositvoucher_fund dvf on dvf.parentid = dv.objid 
	inner join fund on fund.objid = dvf.fundid 
	inner join fundgroup fg on fg.objid = fund.groupid 
where dv.controldate >= $P{startdate} 
	and dv.controldate <  $P{enddate} 
	and dv.state in ('OPEN','POSTED') 
order by dv.controldate, fg.indexno, fund.title 


[getReportByBankAccount]
select 
	dv.controldate, dv.state, ds.state as depositslip_state, 
	ba.objid as bankaccount_objid, ba.code as bankaccount_code, 
	ba.bank_name, ba.bank_objid,
	sum(ds.totalcash) as totalcash, 
	sum(ds.totalcheck) as totalcheck, 
	sum(ds.amount) as amount 
from depositvoucher dv 
	inner join depositvoucher_fund dvf on dvf.parentid = dv.objid 
	inner join depositslip ds on ds.depositvoucherfundid = dvf.objid 
	inner join bankaccount ba on ba.objid = ds.bankacctid 
where dv.controldate >= $P{startdate} 
	and dv.controldate <  $P{enddate} 
	and dv.state in ('OPEN','POSTED') 
group by 
	dv.controldate, dv.state, ds.state, 
	ba.objid, ba.code, ba.bank_name, ba.bank_objid 
order by 
	dv.controldate, ba.bank_name, ba.code 
