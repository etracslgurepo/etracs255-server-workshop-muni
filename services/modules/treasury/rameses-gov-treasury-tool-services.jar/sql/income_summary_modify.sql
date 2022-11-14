[deleteDataByLiquidation]
delete from income_summary where refid = $P{objid} and reftype='liquidation'


[insertDataByLiquidation]
insert into income_summary ( 
	refid, refdate, refno, reftype, acctid, fundid, amount, orgid, collectorid, 
	refyear, refmonth, refqtr, remittanceid, remittancedate, 
	remittanceyear, remittancemonth, remittanceqtr, liquidationid, liquidationdate, 
	liquidationyear, liquidationmonth, liquidationqtr 
) 
select 
	refid, refdate, refno, reftype, acctid, fundid, 
	sum(amount) as amount, orgid, collectorid, 
	year(refdate) as refyear, month(refdate) as refmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as refqtr, 
	remittanceid, remittancedate, 
	year(remittancedate) as remittanceyear, month(remittancedate) as remittancemonth, 
	case 
		when month(remittancedate) <= 3 then 1
		when month(remittancedate) <= 6 then 2
		when month(remittancedate) <= 9 then 3
		when month(remittancedate) <= 12 then 4
	end as remittanceqtr,
	refid as liquidationid, refdate as liquidationdate, 
	year(refdate) as liquidationyear, month(refdate) as liquidationmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as liquidationqtr  
from ( 
	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		rc.acctid, rc.fundid, sum(rc.amount) as amount, rc.org_objid as orgid, rc.collectorid, 
		rc.remittanceid, rc.remittance_controldate as remittancedate 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptitem rc on rc.collectionvoucherid = cv.objid  
	where cv.objid = $P{objid} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, rc.acctid, rc.fundid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		ia.objid as acctid, ia.fund_objid as fundid, -sum(rc.amount) as amount, rc.org_objid as orgid, 
		rc.collectorid, rc.remittanceid, rc.remittance_controldate as remittancedate 
	from collectionvoucher cv 
		inner join  vw_remittance_cashreceiptshare rc on rc.collectionvoucherid = cv.objid 
		inner join itemaccount ia on ia.objid = rc.refacctid 
	where cv.objid = $P{objid} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, ia.objid, ia.fund_objid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		rc.acctid, rc.fundid, sum(rc.amount) as amount, rc.org_objid as orgid, 
		rc.collectorid, rc.remittanceid, rc.remittance_controldate as remittancedate 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptshare rc on rc.collectionvoucherid = cv.objid 
	where cv.objid = $P{objid} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, rc.acctid, rc.fundid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 
)t1 
group by 
	refid, refdate, refno, reftype, acctid, fundid, 
	orgid, collectorid, remittanceid, remittancedate, 
	year(refdate), month(refdate), year(remittancedate), month(remittancedate)


[deleteDataByRemittanceDate]
delete from income_summary where 
	remittancedate >= $P{startdate} and 
	remittancedate <  $P{enddate} and 
	reftype = 'liquidation' 

[deleteDataByLiquidationDate]
delete from income_summary where 
	refdate >= $P{startdate} and 
	refdate <  $P{enddate} and 
	reftype = 'liquidation' 

[deleteDataByCreditMemoDate]
delete from income_summary where 
	refdate >= $P{startdate} and 
	refdate <  $P{enddate} and 
	reftype not in ('liquidation') 


[insertDataByRemittanceDate]
insert into income_summary ( 
	refid, refdate, refno, reftype, acctid, fundid, amount, orgid, collectorid, 
	refyear, refmonth, refqtr, remittanceid, remittancedate, 
	remittanceyear, remittancemonth, remittanceqtr, liquidationid, liquidationdate, 
	liquidationyear, liquidationmonth, liquidationqtr 
) 
select 
	refid, refdate, refno, reftype, acctid, fundid, 
	sum(amount) as amount, orgid, collectorid, 
	year(refdate) as refyear, month(refdate) as refmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as refqtr, 
	remittanceid, remittancedate, 
	year(remittancedate) as remittanceyear, month(remittancedate) as remittancemonth, 
	case 
		when month(remittancedate) <= 3 then 1
		when month(remittancedate) <= 6 then 2
		when month(remittancedate) <= 9 then 3
		when month(remittancedate) <= 12 then 4
	end as remittanceqtr,
	refid as liquidationid, refdate as liquidationdate, 
	year(refdate) as liquidationyear, month(refdate) as liquidationmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as liquidationqtr  
from ( 
	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		rc.acctid, rc.fundid, sum(rc.amount) as amount, rc.org_objid as orgid, rc.collectorid, 
		rc.remittanceid, rc.remittance_controldate as remittancedate 
	from vw_remittance_cashreceiptitem rc 
		inner join collectionvoucher cv on cv.objid = rc.collectionvoucherid 
	where rc.remittance_controldate >= $P{startdate} 
		and rc.remittance_controldate < $P{enddate} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, rc.acctid, rc.fundid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		ia.objid as acctid, ia.fund_objid as fundid, -sum(rc.amount) as amount, rc.org_objid as orgid, 
		rc.collectorid, rc.remittanceid, rc.remittance_controldate as remittancedate 
	from vw_remittance_cashreceiptshare rc 
		inner join collectionvoucher cv on cv.objid = rc.collectionvoucherid 
		inner join itemaccount ia on ia.objid = rc.refacctid 
	where rc.remittance_controldate >= $P{startdate} 
		and rc.remittance_controldate < $P{enddate} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, ia.objid, ia.fund_objid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		rc.acctid, rc.fundid, sum(rc.amount) as amount, rc.org_objid as orgid, 
		rc.collectorid, rc.remittanceid, rc.remittance_controldate as remittancedate 
	from vw_remittance_cashreceiptshare rc 
		inner join collectionvoucher cv on cv.objid = rc.collectionvoucherid 
	where rc.remittance_controldate >= $P{startdate} 
		and rc.remittance_controldate < $P{enddate} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, rc.acctid, rc.fundid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 
)t1 
group by 
	refid, refdate, refno, reftype, acctid, fundid, 
	orgid, collectorid, remittanceid, remittancedate, 
	year(refdate), month(refdate), year(remittancedate), month(remittancedate)


[insertDataByLiquidationDate]
insert into income_summary ( 
	refid, refdate, refno, reftype, acctid, fundid, amount, orgid, collectorid, 
	refyear, refmonth, refqtr, remittanceid, remittancedate, 
	remittanceyear, remittancemonth, remittanceqtr, liquidationid, liquidationdate, 
	liquidationyear, liquidationmonth, liquidationqtr 
) 
select 
	refid, refdate, refno, reftype, acctid, fundid, 
	sum(amount) as amount, orgid, collectorid, 
	year(refdate) as refyear, month(refdate) as refmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as refqtr, 
	remittanceid, remittancedate, 
	year(remittancedate) as remittanceyear, month(remittancedate) as remittancemonth, 
	case 
		when month(remittancedate) <= 3 then 1
		when month(remittancedate) <= 6 then 2
		when month(remittancedate) <= 9 then 3
		when month(remittancedate) <= 12 then 4
	end as remittanceqtr,
	refid as liquidationid, refdate as liquidationdate, 
	year(refdate) as liquidationyear, month(refdate) as liquidationmonth, 
	case 
		when month(refdate) <= 3 then 1
		when month(refdate) <= 6 then 2
		when month(refdate) <= 9 then 3
		when month(refdate) <= 12 then 4
	end as liquidationqtr  
from ( 
	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		rc.acctid, rc.fundid, sum(rc.amount) as amount, rc.org_objid as orgid, rc.collectorid, 
		rc.remittanceid, rc.remittance_controldate as remittancedate 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptitem rc on rc.collectionvoucherid = cv.objid 
	where cv.controldate >= $P{startdate} 
		and cv.controldate < $P{enddate} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, rc.acctid, rc.fundid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		ia.objid as acctid, ia.fund_objid as fundid, -sum(rc.amount) as amount, rc.org_objid as orgid, 
		rc.collectorid, rc.remittanceid, rc.remittance_controldate as remittancedate 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptshare rc on rc.collectionvoucherid = cv.objid 
		inner join itemaccount ia on ia.objid = rc.refacctid 
	where cv.controldate >= $P{startdate} 
		and cv.controldate < $P{enddate} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, ia.objid, ia.fund_objid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 

	union all 

	select 
		cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		rc.acctid, rc.fundid, sum(rc.amount) as amount, rc.org_objid as orgid, 
		rc.collectorid, rc.remittanceid, rc.remittance_controldate as remittancedate 
	from collectionvoucher cv 
		inner join vw_remittance_cashreceiptshare rc on rc.collectionvoucherid = cv.objid 
	where cv.controldate >= $P{startdate} 
		and cv.controldate < $P{enddate} 
		and cv.state = 'POSTED' 
		and rc.voided = 0 
	group by 
		cv.objid, cv.controldate, cv.controlno, rc.acctid, rc.fundid, 
		rc.org_objid, rc.collectorid, rc.remittanceid, rc.remittance_controldate 
)t1 
group by 
	refid, refdate, refno, reftype, acctid, fundid, 
	orgid, collectorid, remittanceid, remittancedate, 
	year(refdate), month(refdate), year(remittancedate), month(remittancedate)


[insertDataByCreditMemoDate]
insert into income_summary ( 
	refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, liquidationid, 
	orgid, collectorid, acctid, fundid, amount 
) 
select 
	refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, liquidationid, 
	orgid, collectorid, acctid, fundid, sum(amount) as amount 
from ( 
	select 
		cm.objid as refid, cm.refdate, cm.refno, 'CREDITMEMO' as reftype, 
		year(cm.refdate) as refyear, month(cm.refdate) as refmonth, 
		case 
			when month(cm.refdate) between 1 and 3 then 1 
			when month(cm.refdate) between 4 and 6 then 2 
			when month(cm.refdate) between 7 and 9 then 3
	 		when month(cm.refdate) between 10 and 12 then 4
		end as refqtr, 
		cmi.item_objid as acctid, ia.fund_objid as fundid, 
		cmi.amount, o.objid as orgid, cm.issuedby_objid as collectorid, 
		cm.objid as remittanceid, cm.refdate as remittancedate, 
		cm.objid as liquidationid 
	from creditmemo cm 
		inner join collectiontype ct on ct.objid = cm.type_objid 
		inner join creditmemoitem cmi on cmi.parentid = cm.objid 
		inner join itemaccount ia on ia.objid = cmi.item_objid 
		inner join sys_org o on o.root = 1 
	where cm.refdate >= $P{startdate} 
		and cm.refdate <  $P{enddate} 
		and cm.receiptid is null 
		and cm.state = 'POSTED' 
)tt1
group by 
	refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, liquidationid, 
	orgid, collectorid, acctid, fundid
