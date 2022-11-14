[getReportA]
select 
	ds.depositdate, ds.state, ds.deposittype, 
	ba.code as bankaccount_code, ba.bank_name, 
	ds.totalcash, ds.totalcheck, 
	(ds.totalcash + ds.totalcheck) as amount, 
	ds.validation_refdate, ds.validation_refno, 
	fund.title as fund_title, fund.objid as fund_objid
from depositslip ds 
	inner join bankaccount ba on ba.objid = ds.bankacctid 
	inner join depositvoucher_fund dvf on dvf.objid = ds.depositvoucherfundid 
	inner join fund on fund.objid = dvf.fundid 
where ds.depositdate >= $P{startdate} 
	and ds.depositdate <  $P{enddate} 
order by ds.depositdate, ba.bank_name, ba.code 
