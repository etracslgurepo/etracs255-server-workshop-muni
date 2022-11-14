[getReportByFundReceipts]
select 
	ci.controlid, ci.series, ci.formno, ci.receiptno, ci.receiptdate, 
	ci.paidby, ci.acctid, ci.acctname, sum(ci.amount) as amount, 
	convert(char(255), ci.remarks) as remarks 
from depositvoucher_fund dvf 
	inner join depositvoucher dv on dv.objid = dvf.parentid 
	inner join collectionvoucher cv on cv.depositvoucherid = dv.objid 
	inner join vw_collectionvoucher_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
	inner join fund on (fund.objid = ci.fundid and fund.depositoryfundid = dvf.fundid) 
where dvf.parentid = $P{depositvoucherid} 
	and dvf.fundid like $P{fundid} 
group by 
	ci.controlid, ci.series, ci.formno, ci.receiptno, ci.receiptdate, 
	ci.paidby, ci.acctid, ci.acctname, convert(char(255), ci.remarks) 
order by 
	ci.formno, ci.controlid, ci.receiptdate, ci.series, ci.acctname 


[getReportByFundAcctSummaries]
select 
	fg.indexno as groupindexno, ff.code as fund_code,
	ff.objid as fund_objid, ff.title as fund_title, 
	ci.acctid, ci.acctcode, ci.acctname, sum(ci.amount) as amount 
from depositvoucher_fund dvf 
	inner join depositvoucher dv on dv.objid = dvf.parentid 
	inner join collectionvoucher cv on cv.depositvoucherid = dv.objid 
	inner join vw_collectionvoucher_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
	inner join fund on (fund.objid = ci.fundid and fund.depositoryfundid = dvf.fundid) 
	inner join fund ff on ff.objid = dvf.fundid 
	inner join fundgroup fg on fg.objid = ff.groupid 
where dvf.parentid = $P{depositvoucherid} 
	and dvf.fundid like $P{fundid} 
group by fg.indexno, ff.code, ff.objid, ff.title, ci.acctid, ci.acctcode, ci.acctname 
order by fg.indexno, ff.title, ci.acctcode, ci.acctname 
