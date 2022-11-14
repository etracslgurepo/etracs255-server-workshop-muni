[getFunds]
select fund.objid, fund.code, fund.title, sum(t1.amount) as amount 
from ( 
  select ci.fundid, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptitem ci  
  where ci.remittanceid = $P{remittanceid} 
  group by ci.fundid 
  union all 
  select ia.fund_objid as fundid, -sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
    inner join itemaccount ia on ia.objid = ci.refacctid 
  where ci.remittanceid = $P{remittanceid}  
  group by ia.fund_objid 
  union all 
  select ci.fundid, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
  where ci.remittanceid = $P{remittanceid} 
  group by ci.fundid 
)t1, fund 
where fund.objid = t1.fundid 
group by fund.objid, fund.code, fund.title 
order by fund.code, fund.title 


[getReport]
select 
	c.receiptdate, c.receiptno, c.paidby, 
	ia.objid as item_objid, t2.amount, c.voided, 
	fund.objid as fund_objid, fund.title as fund_title, 
	a.code, a.title 
from ( 
	select t1.receiptid, t1.fundid, t1.acctid, sum(t1.amount) as amount 
	from ( 
		select ci.receiptid, ci.fundid, ci.acctid, sum(ci.amount) as amount 
		from vw_remittance_cashreceiptitem ci  
		where ci.remittanceid = $P{remittanceid} 
		group by ci.receiptid, ci.fundid, ci.acctid 
		union all 
		select ci.receiptid, ia.fund_objid as fundid, ia.objid as acctid, -sum(ci.amount) as amount 
		from vw_remittance_cashreceiptshare ci 
			inner join itemaccount ia on ia.objid = ci.refacctid 
		where ci.remittanceid = $P{remittanceid} 
		group by ci.receiptid, ia.fund_objid, ia.objid
		union all 
		select ci.receiptid, ci.fundid, ci.acctid, sum(ci.amount) as amount 
		from vw_remittance_cashreceiptshare ci 
		where ci.remittanceid = $P{remittanceid} 
		group by ci.receiptid, ci.fundid, ci.acctid 
	)t1 
	group by t1.receiptid, t1.fundid, t1.acctid 
)t2 
	inner join vw_remittance_cashreceipt c on c.receiptid = t2.receiptid 
	inner join itemaccount ia on ia.objid = t2.acctid 
	inner join fund on fund.objid = t2.fundid 
	left join ( 
		select a.objid, a.code, a.title, m.itemid 
		from account a, vw_account_mapping m 
		where a.maingroupid = $P{maingroupid} 
			and m.acctid = a.objid 
	)a on a.itemid = t2.acctid 
where 1=1 ${filters} 
order by c.receiptno, a.code, a.title 
