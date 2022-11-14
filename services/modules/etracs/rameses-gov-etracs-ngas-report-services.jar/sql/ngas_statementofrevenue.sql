[getRemittanceFunds]
select fund.objid, fund.code, fund.title, sum(t1.amount) as amount 
from ( 
  select ci.fundid, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptitem ci  
  where ci.remittanceid = $P{refid} 
  group by ci.fundid 
  union all 
  select ia.fund_objid as fundid, -sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
    inner join itemaccount ia on ia.objid = ci.refacctid 
  where ci.remittanceid = $P{refid}  
  group by ia.fund_objid 
  union all 
  select ci.fundid, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
  where ci.remittanceid = $P{refid} 
  group by ci.fundid 
)t1, fund 
where fund.objid = t1.fundid 
group by fund.objid, fund.code, fund.title 
having sum(t1.amount) > 0 
order by fund.code, fund.title 


[getLiquidationFunds]
select fund.objid, fund.code, fund.title, sum(t1.amount) as amount 
from ( 
  select ci.fundid, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptitem ci  
  where ci.collectionvoucherid = $P{refid} 
  group by ci.fundid 
  union all 
  select ia.fund_objid as fundid, -sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
    inner join itemaccount ia on ia.objid = ci.refacctid 
  where ci.collectionvoucherid = $P{refid}  
  group by ia.fund_objid 
  union all 
  select ci.fundid, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
  where ci.collectionvoucherid = $P{refid} 
  group by ci.fundid 
)t1, fund 
where fund.objid = t1.fundid 
group by fund.objid, fund.code, fund.title 
having sum(t1.amount) > 0 
order by fund.code, fund.title 


[getAccounts]
select 
	upper(a.code) as acctcode, upper(a.title) as accttitle, 
	a.`level`, a.leftindex, a.objid, a.groupid, a.type, 
	0.0 as amount 
from account a 
where a.maingroupid = $P{maingroupid} 
order by a.`level`, a.leftindex  


[getRemittanceReport]
select t2.*, m.acctid  
from ( 
	select 
		t1.fundid, ia.objid as itemid, ia.code as itemcode, 
		ia.title as itemtitle, sum(t1.amount) as amount 
	from ( 
		select ci.fundid, ci.acctid, sum(ci.amount) as amount 
		from vw_remittance_cashreceiptitem ci  
		where ci.remittanceid = $P{refid} 
			and ci.voided = 0 
		group by ci.fundid, ci.acctid 
		union all 
		select ia.fund_objid as fundid, ia.objid as acctid, -sum(ci.amount) as amount 
		from vw_remittance_cashreceiptshare ci 
			inner join itemaccount ia on ia.objid = ci.refacctid 
		where ci.remittanceid = $P{refid} 
			and ci.voided = 0 
		group by ia.fund_objid, ia.objid
		union all 
		select ci.fundid, ci.acctid, sum(ci.amount) as amount 
		from vw_remittance_cashreceiptshare ci 
		where ci.remittanceid = $P{refid} 
			and ci.voided = 0 
		group by ci.fundid, ci.acctid 
	)t1, itemaccount ia 
	where ia.objid = t1.acctid 
	group by t1.fundid, ia.objid, ia.code, ia.title 
)t2 
	left join vw_account_mapping m on (m.itemid = t2.itemid and m.maingroupid = $P{maingroupid}) 
where 1=1  ${filters} 
order by m.objid, t2.itemcode, t2.itemtitle 


[getLiquidationReport]
select t2.*, m.acctid  
from ( 
	select 
		t1.fundid, ia.objid as itemid, ia.code as itemcode, 
		ia.title as itemtitle, sum(t1.amount) as amount 
	from ( 
		select ci.fundid, ci.acctid, sum(ci.amount) as amount 
		from vw_remittance_cashreceiptitem ci  
		where ci.collectionvoucherid = $P{refid} 
			and ci.voided = 0 
		group by ci.fundid, ci.acctid 
		union all 
		select ia.fund_objid as fundid, ia.objid as acctid, -sum(ci.amount) as amount 
		from vw_remittance_cashreceiptshare ci 
			inner join itemaccount ia on ia.objid = ci.refacctid 
		where ci.collectionvoucherid = $P{refid} 
			and ci.voided = 0 
		group by ia.fund_objid, ia.objid
		union all 
		select ci.fundid, ci.acctid, sum(ci.amount) as amount 
		from vw_remittance_cashreceiptshare ci 
		where ci.collectionvoucherid = $P{refid} 
			and ci.voided = 0 
		group by ci.fundid, ci.acctid 
	)t1, itemaccount ia 
	where ia.objid = t1.acctid 
	group by t1.fundid, ia.objid, ia.code, ia.title 
)t2 
	left join vw_account_mapping m on (m.itemid = t2.itemid and m.maingroupid = $P{maingroupid}) 
where 1=1  ${filters} 
order by m.objid, t2.itemcode, t2.itemtitle 
