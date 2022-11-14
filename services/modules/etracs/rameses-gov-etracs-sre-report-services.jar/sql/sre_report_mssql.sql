[getFunds]
select f.*, g.indexno as groupindexno 
from fund f, fundgroup g  
where f.groupid = g.objid 
order by g.indexno, g.title, f.code, f.title 

[getFundsByGroup]
select * 
from fund 
where groupid = $P{groupid} 
order by code, title 

[getAcctGroups]
select g.* 
from account_maingroup g 
where g.reporttype='SRE' 
order by g.version desc 

[getAcctTypes]
select distinct 
	ia.type as objid, ia.type as title 
from itemaccount ia 
where ia.type NOT IN ('CASH_IN_BANK','CASH_IN_TREASURY') 

[getAccounts]
select 
	upper(a.code) as acctcode, upper(a.title) as accttitle, 
	a.level, a.leftindex, a.objid, a.groupid, a.type, 
	0.0 as amount 
from account a 
where a.maingroupid = $P{maingroupid} 
order by a.level, a.leftindex 

[getAcctTargets]
select distinct 
	a.objid as acctid, t.target 
from account a 
	inner join account_incometarget t on t.itemid = a.objid 
where a.maingroupid = $P{maingroupid} 
	and t.year = YEAR($P{startdate}) 
	and t.target > 0 

[getIncomeSummary]
select t1.*, m.objid as acctid 
from ( 
	select fundid, itemid, itemcode, itemtitle, sum(amount) as amount 
	from vw_income_summary a 
	where remittancedate >= $P{startdate} 
		and remittancedate <  $P{enddate} 
		${filters} 
	group by fundid, itemid, itemcode, itemtitle 
)t1, vw_account_mapping m 
where m.itemid = t1.itemid 
	and m.maingroupid = $P{maingroupid} 
order by m.objid, t1.itemcode, t1.itemtitle 


[getIncomeSummaryByLiquidationDate]
select t1.*, m.objid as acctid 
from ( 
	select fundid, itemid, itemcode, itemtitle, sum(amount) as amount 
	from vw_income_summary a 
	where refdate >= $P{startdate} 
		and refdate <  $P{enddate} 
		${filters} 
	group by fundid, itemid, itemcode, itemtitle 
)t1, vw_account_mapping m 
where m.itemid = t1.itemid 
	and m.maingroupid = $P{maingroupid} 
order by m.objid, t1.itemcode, t1.itemtitle 
