[getReceipts]
select 
  	c.receiptid, c.controlid, c.formno, c.series, 
	convert(c.receiptdate, date) as receiptdate, c.receiptno, tmp2.amount, 
  	case when c.voided = 0 then ia.title else '***VOIDED***' end as particulars,
  	case when c.voided = 0 then c.paidby else '***VOIDED***' end as payer,
  	case when c.voided = 0 then c.paidbyaddress else '' end as payeraddress, 
	c.paidby, c.paidbyaddress 
from ( 
	select receiptid, acctid, sum(amount) as amount 
	from ( 
		select ci.receiptid, ci.acctid, sum(ci.amount) as amount 
		from collectionvoucher cv 
			inner join vw_remittance_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
		where ci.remittance_controldate >= $P{startdate} 
			and ci.remittance_controldate < $P{enddate} 
			and cv.state = 'POSTED' 
			and ci.acctid in ( ${acctids} ) 
		group by ci.receiptid, ci.acctid 
		union all 
		select ci.receiptid, ci.refacctid as acctid, -sum(ci.amount) as amount 
		from collectionvoucher cv 
			inner join vw_remittance_cashreceiptshare ci on ci.collectionvoucherid = cv.objid 
		where ci.remittance_controldate >= $P{startdate} 
			and ci.remittance_controldate < $P{enddate} 
			and cv.state = 'POSTED' 
			and ci.refacctid in ( ${acctids} ) 
		group by ci.receiptid, ci.refacctid 
		union all 
		select ci.receiptid, ci.acctid, sum(ci.amount) as amount 
		from collectionvoucher cv 
			inner join vw_remittance_cashreceiptshare ci on ci.collectionvoucherid = cv.objid 
		where ci.remittance_controldate >= $P{startdate} 
			and ci.remittance_controldate < $P{enddate} 
			and cv.state = 'POSTED' 
			and ci.acctid in ( ${acctids} ) 
		group by ci.receiptid, ci.acctid 
	)tmp1 
	group by receiptid, acctid 
)tmp2 
	inner join vw_remittance_cashreceipt c on c.receiptid = tmp2.receiptid 
	inner join itemaccount ia on ia.objid = tmp2.acctid 
order by c.formno, convert(c.receiptdate, date), c.series 


[getSummary]
select ia.objid, ia.fund_objid, ia.fund_title, ia.code, ia.title, sum(tmp1.amount) as amount 
from ( 
	select ci.acctid, sum(ci.amount) as amount 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
	where ci.remittance_controldate >= $P{startdate} 
		and ci.remittance_controldate <  $P{enddate} 
		and cv.state = 'POSTED' 
		and ci.acctid in ( ${acctids} ) 
	group by ci.acctid 
	union all 
	select ci.refacctid as acctid, -sum(ci.amount) as amount 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptshare ci on ci.collectionvoucherid = cv.objid 
	where ci.remittance_controldate >= $P{startdate} 
		and ci.remittance_controldate <  $P{enddate} 
		and cv.state = 'POSTED' 
		and ci.refacctid in ( ${acctids} ) 
	group by ci.refacctid 
	union all 
	select ci.acctid, sum(ci.amount) as amount 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptshare ci on ci.collectionvoucherid = cv.objid 
	where ci.remittance_controldate >= $P{startdate} 
		and ci.remittance_controldate <  $P{enddate} 
		and cv.state = 'POSTED' 
		and ci.acctid in ( ${acctids} ) 
	group by ci.acctid 
)tmp1 
	inner join itemaccount ia on ia.objid = tmp1.acctid 
group by ia.objid, ia.fund_objid, ia.fund_title, ia.code, ia.title 
having sum(tmp1.amount) > 0 
order by ia.fund_title, ia.fund_objid, ia.code, ia.title 
