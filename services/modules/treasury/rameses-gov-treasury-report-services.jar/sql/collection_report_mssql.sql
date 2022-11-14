[getFunds]
select fund.*, g.indexno as groupindexno  
from fundgroup g, fund 
where g.objid = fund.groupid ${filter} 
order by g.indexno, fund.code, fund.title 


[getLiquidatedReport]
select 
  t0.fundid, fund.title as fundtitle, t0.formno, t0.controlid, t0.series, t0.receiptno, t0.receiptdate, t0.payorname, 
  t0.acctid as itemid, t0.acctcode as itemcode, t0.acctname as itemtitle, sum(t0.amount) as itemamount, 
  t0.collectorid as collector_objid, t0.collectorname as collector_name, fg.indexno as fundsortorder  
from ( 
  select 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptdate, 
    case when ci.formtype = 'serial' then ci.receiptno else '' end as receiptno, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.acctid else '*** VOIDED ***' end as acctid, 
    case when ci.voided=0 then ci.acctcode else '' end as acctcode, 
    case when ci.voided=0 then ci.acctname else '*** VOIDED ***' end as acctname, 
    ci.fundid, sum(ci.amount) as amount, 0.0 as share, 
    ci.collectorid, ci.collectorname, ci.collectortitle 
  from collectionvoucher cv 
    inner join vw_remittance_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
  where cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptno, ci.receiptdate, 
    ci.voided, ci.paidby, ci.paidbyaddress, ci.acctid, ci.acctcode, ci.acctname, 
    ci.fundid, ci.collectorid, ci.collectorname, ci.collectortitle 

  union all 

  select 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptdate, 
    case when ci.formtype = 'serial' then ci.receiptno else '' end as receiptno, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then t0.acctid else '*** VOIDED ***' end as acctid, 
    case when ci.voided=0 then t0.acctcode else '' end as acctcode, 
    case when ci.voided=0 then t0.acctname else '*** VOIDED ***' end as acctname, 
    t0.fundid, 0.0 as amount, sum(ci.amount) as share, 
    ci.collectorid, ci.collectorname, ci.collectortitle 
  from ( 
    select ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
    from collectionvoucher cv
      inner join vw_remittance_cashreceiptshare cs on cs.collectionvoucherid = cv.objid 
      inner join vw_remittance_cashreceiptitem ci on (ci.receiptid = cs.receiptid and ci.acctid = cs.refacctid) 
    where cv.controldate >= $P{startdate} 
      and cv.controldate <  $P{enddate} 
      and cv.state = 'POSTED' 
    group by ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
  )t0, vw_remittance_cashreceiptshare ci 
  where ci.receiptid = t0.receiptid 
    and ci.refacctid = t0.acctid 
  group by 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptno, ci.receiptdate, 
    ci.voided, ci.paidby, ci.paidbyaddress, t0.acctid, t0.acctcode, t0.acctname, 
    t0.fundid, ci.collectorid, ci.collectorname, ci.collectortitle 

  union all 

  select 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptdate, 
    case when ci.formtype = 'serial' then ci.receiptno else '' end as receiptno, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.acctid else '*** VOIDED ***' end as acctid, 
    case when ci.voided=0 then ci.acctcode else '' end as acctcode, 
    case when ci.voided=0 then ci.acctname else '*** VOIDED ***' end as acctname, 
    ci.fundid, sum(ci.amount) as amount, 0.0 as share, 
    ci.collectorid, ci.collectorname, ci.collectortitle 
  from collectionvoucher cv 
    inner join vw_remittance_cashreceiptshare ci on ci.collectionvoucherid = cv.objid 
  where cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptno, ci.receiptdate, 
    ci.voided, ci.paidby, ci.paidbyaddress, ci.acctid, ci.acctcode, ci.acctname, 
    ci.fundid, ci.collectorid, ci.collectorname, ci.collectortitle 
)t0, fund, fundgroup fg 
where fund.objid = t0.fundid 
  and fund.groupid = fg.objid 
  ${filter} 
group by 
  t0.fundid, fund.title, t0.formno, t0.controlid, t0.series, t0.receiptno, t0.receiptdate, 
  t0.payorname, t0.acctid, t0.acctcode, t0.acctname, t0.collectorid, t0.collectorname, fg.indexno 
order by 
  t0.collectorname, t0.formno, fg.indexno, fund.title, t0.receiptdate, t0.series, t0.acctcode 


[getRemittedReport]
select 
  t0.fundid, fund.title as fundtitle, t0.formno, t0.controlid, t0.series, t0.receiptno, t0.receiptdate, t0.payorname, 
  t0.acctid as itemid, t0.acctcode as itemcode, t0.acctname as itemtitle, sum(t0.amount) as itemamount, 
  t0.collectorid as collector_objid, t0.collectorname as collector_name, fg.indexno as fundsortorder  
from ( 
  select 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptdate, 
    case when ci.formtype = 'serial' then ci.receiptno else '' end as receiptno, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.acctid else '*** VOIDED ***' end as acctid, 
    case when ci.voided=0 then ci.acctcode else '' end as acctcode, 
    case when ci.voided=0 then ci.acctname else '*** VOIDED ***' end as acctname, 
    ci.fundid, sum(ci.amount) as amount, 0.0 as share, 
    ci.collectorid, ci.collectorname, ci.collectortitle 
  from remittance r 
  	inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
    inner join vw_remittance_cashreceiptitem ci on ci.remittanceid = r.objid 
  where r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptno, ci.receiptdate, 
    ci.voided, ci.paidby, ci.paidbyaddress, ci.acctid, ci.acctcode, ci.acctname, 
    ci.fundid, ci.collectorid, ci.collectorname, ci.collectortitle 

  union all 

  select 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptdate, 
    case when ci.formtype = 'serial' then ci.receiptno else '' end as receiptno, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then t0.acctid else '*** VOIDED ***' end as acctid, 
    case when ci.voided=0 then t0.acctcode else '' end as acctcode, 
    case when ci.voided=0 then t0.acctname else '*** VOIDED ***' end as acctname, 
    t0.fundid, 0.0 as amount, sum(ci.amount) as share, 
    ci.collectorid, ci.collectorname, ci.collectortitle 
  from ( 
    select ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
    from remittance r 
      inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
      inner join vw_remittance_cashreceiptshare cs on cs.remittanceid = r.objid 
      inner join vw_remittance_cashreceiptitem ci on (ci.receiptid = cs.receiptid and ci.acctid = cs.refacctid) 
    where r.controldate >= $P{startdate} 
      and r.controldate <  $P{enddate} 
      and cv.state = 'POSTED' 
    group by ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
  )t0, vw_remittance_cashreceiptshare ci 
  where ci.receiptid = t0.receiptid 
    and ci.refacctid = t0.acctid 
  group by 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptno, ci.receiptdate, 
    ci.voided, ci.paidby, ci.paidbyaddress, t0.acctid, t0.acctcode, t0.acctname, 
    t0.fundid, ci.collectorid, ci.collectorname, ci.collectortitle 

  union all 

  select 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptdate, 
    case when ci.formtype = 'serial' then ci.receiptno else '' end as receiptno, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.acctid else '*** VOIDED ***' end as acctid, 
    case when ci.voided=0 then ci.acctcode else '' end as acctcode, 
    case when ci.voided=0 then ci.acctname else '*** VOIDED ***' end as acctname, 
    ci.fundid, sum(ci.amount) as amount, 0.0 as share, 
    ci.collectorid, ci.collectorname, ci.collectortitle 
  from remittance r 
  	inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
    inner join vw_remittance_cashreceiptshare ci on ci.remittanceid = r.objid 
  where r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by 
    ci.formno, ci.formtype, ci.controlid, ci.series, ci.receiptno, ci.receiptdate, 
    ci.voided, ci.paidby, ci.paidbyaddress, ci.acctid, ci.acctcode, ci.acctname, 
    ci.fundid, ci.collectorid, ci.collectorname, ci.collectortitle 
)t0, fund, fundgroup fg 
where fund.objid = t0.fundid 
  and fund.groupid = fg.objid 
  ${filter} 
group by 
  t0.fundid, fund.title, t0.formno, t0.controlid, t0.series, t0.receiptno, t0.receiptdate, 
  t0.payorname, t0.acctid, t0.acctcode, t0.acctname, t0.collectorid, t0.collectorname, fg.indexno 
order by 
  t0.collectorname, t0.formno, fg.indexno, fund.title, t0.receiptdate, t0.series, t0.acctcode 


[getFundSummary]
select distinct 
  fundid, code, title, indexno as groupindexno  
from ( 
  select  
    rf.fund_objid as fundid, f.code, f.title, fg.indexno, count(*) as icount 
  from remittance r 
    inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
    inner join remittance_fund rf on rf.remittanceid = r.objid
    inner join fund f on f.objid = rf.fund_objid 
    inner join fundgroup fg on fg.objid = f.groupid 
  where 1=1 
    and 'BY_REMITTANCE_DATE' = $P{postingtypeid} 
    and r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and r.collector_objid like $P{collectorid} 
    and cv.state = 'POSTED' 
  group by rf.fund_objid, f.code, f.title, fg.indexno 
 
  union 

  select  
    rf.fund_objid as fundid, f.code, f.title, fg.indexno, count(*) as icount 
  from collectionvoucher cv 
    inner join remittance r on r.collectionvoucherid = cv.objid 
    inner join remittance_fund rf on rf.remittanceid = r.objid
    inner join fund f on f.objid = rf.fund_objid 
    inner join fundgroup fg on fg.objid = f.groupid 
  where 1=1 
    and 'BY_LIQUIDATION_DATE' = $P{postingtypeid} 
    and cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and r.collector_objid like $P{collectorid}  
    and cv.state = 'POSTED' 
  group by rf.fund_objid, f.code, f.title, fg.indexno  
)t1 
order by t1.indexno, t1.code, t1.title 


[getReportSummary]
select t.xdate, ${sqlqry} 
from (
  select 
    day(r.controldate) as xdate, ${subqry} 
  from remittance r 
    inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
    inner join remittance_fund rf on rf.remittanceid = r.objid 
    inner join fund f on f.objid = rf.fund_objid 
  where 1=1 
    and 'BY_REMITTANCE_DATE' = $P{postingtypeid} 
    and r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and r.collector_objid like $P{collectorid} 
    and cv.state = 'POSTED' 

  union 

  select  
    day(r.controldate) as xdate, ${subqry} 
  from collectionvoucher cv 
    inner join remittance r on r.collectionvoucherid = cv.objid 
    inner join remittance_fund rf on rf.remittanceid = r.objid
    inner join fund f on f.objid = rf.fund_objid 
  where 1=1 
    and 'BY_LIQUIDATION_DATE' = $P{postingtypeid} 
    and cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and r.collector_objid like $P{collectorid}     
    and cv.state = 'POSTED' 
)t 
group by t.xdate 
order by t.xdate 
