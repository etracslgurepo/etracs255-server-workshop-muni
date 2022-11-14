[findBeginBalance]
select sum(dr) as dr, sum(cr) as cr, sum(dr)-sum(cr) as balance 
from ( 
	select sum(ci.amount) as dr, 0.0 as cr
	from remittance r 
		inner join remittance_fund ci on ci.remittanceid = r.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where r.controldate < $P{startdate} 
		and r.liquidatingofficer_objid = $P{accountid} 
		and r.state = 'POSTED' 
		and ${filter} 
	union all 
	select sum(ci.amount) as dr, 0.0 as cr
	from remittance r 
		inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
		inner join remittance_fund ci on ci.remittanceid = r.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where r.controldate < $P{startdate} 
		and cv.liquidatingofficer_objid = $P{accountid} 
		and cv.liquidatingofficer_objid <> r.liquidatingofficer_objid 
		and r.state = 'POSTED' 
		and ${filter} 
	union all 
	select 0.0 as dr, sum(ci.amount) as cr 
	from collectionvoucher cv 
		inner join collectionvoucher_fund ci on ci.parentid= cv.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where cv.controldate < $P{startdate} 
		and cv.liquidatingofficer_objid = $P{accountid} 
		and cv.state = 'POSTED' 
		and ${filter} 
)t0 


[getReport]
select * 
from ( 
	select 
		cv.controldate as refdate, r.controlno as refno, 
		r.collector_name as particulars, r.dtposted as sortdate, 
		sum(ci.amount) as dr, 0.0 as cr, 'remittance' as reftype, 
		r.collector_objid as userid, r.collector_name as username, 
		1 as groupindexno 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join remittance_fund ci on ci.remittanceid = r.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where cv.controldate >= $P{startdate} 
		and cv.controldate < $P{enddate} 
		and cv.liquidatingofficer_objid = $P{accountid} 
		and cv.state = 'POSTED' 		
		and ${filter} 
	group by 
		cv.controldate, r.controldate, r.controlno, r.collector_name, 
		r.dtposted,	r.collector_objid 
	union all 
	select 
		cv.controldate as refdate, cv.controlno as refno, 
		cv.liquidatingofficer_name as particulars, cv.dtposted as sortdate, 
		0.0 as dr, sum(ci.amount) as cr, 'liquidation' as reftype, 
		cv.liquidatingofficer_objid as userid, cv.liquidatingofficer_name as username, 
		2 as groupindexno 
	from collectionvoucher cv 
		inner join collectionvoucher_fund ci on ci.parentid = cv.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where cv.controldate >= $P{startdate} 
		and cv.controldate < $P{enddate} 
		and cv.liquidatingofficer_objid = $P{accountid} 
		and cv.state = 'POSTED' 		
		and ${filter} 
	group by 
		cv.controldate, cv.controlno, cv.liquidatingofficer_name, 
		cv.dtposted, cv.liquidatingofficer_objid 
)t0 
order by t0.refdate, t0.groupindexno, t0.refno 


[getReportTemplateB]
select 
		controldate as refdate, refno, reftype, particulars, 
		sortdate, dr, cr, groupindexno, userid, username 
from ( 
	select 
		cv.controldate, r.controldate as refdate, r.controlno as refno, 
		r.collector_name as particulars, r.dtposted as sortdate, 
		sum(ci.amount) as dr, 0.0 as cr, 'remittance' as reftype, 
		(case when cv.controldate = r.controldate then 1 else 0 end) as groupindexno, 
		r.collector_objid as userid, r.collector_name as username 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join remittance_fund ci on ci.remittanceid = r.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where cv.controldate >= $P{startdate} 
		and cv.controldate <  $P{enddate} 
		and cv.state = 'POSTED' 		
		and cv.liquidatingofficer_objid = $P{accountid}  
		and ${filter} 
	group by 
		cv.controldate, r.controldate, r.controlno, r.collector_name, 
		r.dtposted,	r.collector_objid 

	union all 

	select 
		cv.controldate, cv.controldate as refdate, cv.controlno as refno, 
		cv.liquidatingofficer_name as particulars, cv.dtposted as sortdate, 
		0.0 as dr, sum(ci.amount) as cr, 'liquidation' as reftype, 1 as groupindexno, 
		cv.liquidatingofficer_objid as userid, cv.liquidatingofficer_name as username 
	from collectionvoucher cv 
		inner join collectionvoucher_fund ci on ci.parentid = cv.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where cv.controldate >= $P{startdate} 
		and cv.controldate <  $P{enddate} 
		and cv.state = 'POSTED' 
		and cv.liquidatingofficer_objid = $P{accountid}  
		and ${filter} 
	group by 
		cv.controldate, cv.controlno, cv.liquidatingofficer_name, 
		cv.dtposted, cv.liquidatingofficer_objid

	union all 

	select 
		r.controldate, r.controldate as refdate, r.controlno as refno, 
		r.collector_name as particulars, r.dtposted as sortdate, 
		sum(ci.amount) as dr, 0.0 as cr, 'remittance' as reftype, 2 as groupindexno, 
		r.collector_objid as userid, r.collector_name as username 
	from remittance r 
		inner join remittance_fund ci on ci.remittanceid = r.objid 
		inner join fund on fund.objid = ci.fund_objid 
	where r.controldate >= $P{startdate} 
		and r.controldate <  $P{enddate} 
		and r.state = 'POSTED' 
		and r.liquidatingofficer_objid = $P{accountid} 
		and r.collectionvoucherid is null 
		and ${filter} 
	group by 
		r.controldate, r.controlno, r.collector_name, r.dtposted, r.collector_objid

	union all 

	select 
		r.controldate, r.controldate as refdate, r.controlno as refno, 
		r.collector_name as particulars, r.dtposted as sortdate, 
		sum(ci.amount) as dr, 0.0 as cr, 'remittance' as reftype, 2 as groupindexno, 
		r.collector_objid as userid, r.collector_name as username 
	from remittance r 
		inner join remittance_fund ci on ci.remittanceid = r.objid 
		inner join collectionvoucher cv on cv.objid = r.collectionvoucherid
		inner join fund on fund.objid = ci.fund_objid 
	where r.controldate >= $P{startdate} 
		and r.controldate <  $P{enddate} 
		and r.state = 'POSTED' 
		and r.liquidatingofficer_objid = $P{accountid}  
		and cv.controldate <> r.controldate 
		and ${filter} 
	group by 
		r.controldate, r.controlno, r.collector_name, r.dtposted, r.collector_objid
)t0 
order by t0.controldate, t0.groupindexno, t0.refno
