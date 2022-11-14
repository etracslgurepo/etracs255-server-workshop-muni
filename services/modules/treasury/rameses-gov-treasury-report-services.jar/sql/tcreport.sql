[getFunds]
select fund.*, g.indexno as groupindexno  
from fundgroup g, fund 
where g.objid = fund.groupid ${filter} 
order by g.indexno, fund.code, fund.title 


[getRemittedCollectionByFund]
select 
  fg.indexno as fundgroupindexno, t1.fundid, fund.code as fundcode, fund.title as fundname, 
  t1.acctid, t1.acctcode, t1.acctname, sum(t1.amount)-sum(t1.share) as amount 
from ( 
  select 
    ci.fundid, ci.acctid, ci.acctcode, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from remittance r 
    inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
    inner join vw_remittance_cashreceiptitem ci on ci.remittanceid = r.objid 
  where r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by ci.fundid, ci.acctid, ci.acctcode, ci.acctname 

  union all 

  select 
    t0.fundid, t0.acctid, t0.acctcode, t0.acctname, 0.0 as amount, sum(cs.amount) as share 
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
  )t0, vw_remittance_cashreceiptshare cs 
  where cs.receiptid = t0.receiptid 
    and cs.refacctid = t0.acctid 
  group by t0.fundid, t0.acctid, t0.acctcode, t0.acctname 

  union all 

  select 
    ci.fundid, ci.acctid, ci.acctcode, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from remittance r 
    inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
    inner join vw_remittance_cashreceiptshare ci on ci.remittanceid = r.objid 
  where r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
)t1, fund, fundgroup fg 
where fund.objid = t1.fundid 
  and fund.groupid = fg.objid 
  ${filter} 
group by fg.indexno, t1.fundid, fund.code, fund.title, t1.acctid, t1.acctcode, t1.acctname 
order by fg.indexno, fund.code, fund.title, t1.acctcode, t1.acctname 


[getLiquidatedCollectionByFund]
select 
  fg.indexno as fundgroupindexno, t1.fundid, fund.code as fundcode, fund.title as fundname, 
  t1.acctid, t1.acctcode, t1.acctname, sum(t1.amount)-sum(t1.share) as amount 
from ( 
  select 
    ci.fundid, ci.acctid, ci.acctcode, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from collectionvoucher cv
    inner join vw_remittance_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
  where cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by ci.fundid, ci.acctid, ci.acctcode, ci.acctname 

  union all 

  select 
    t0.fundid, t0.acctid, t0.acctcode, t0.acctname, 0.0 as amount, sum(cs.amount) as share 
  from ( 
    select ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
    from collectionvoucher cv
      inner join vw_remittance_cashreceiptshare cs on cs.collectionvoucherid = cv.objid 
      inner join vw_remittance_cashreceiptitem ci on (ci.receiptid = cs.receiptid and ci.acctid = cs.refacctid) 
    where cv.controldate >= $P{startdate} 
      and cv.controldate <  $P{enddate}  
      and cv.state = 'POSTED' 
    group by ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
  )t0, vw_remittance_cashreceiptshare cs 
  where cs.receiptid = t0.receiptid 
    and cs.refacctid = t0.acctid 
  group by t0.fundid, t0.acctid, t0.acctcode, t0.acctname 

  union all 

  select 
    ci.fundid, ci.acctid, ci.acctcode, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from collectionvoucher cv
    inner join vw_remittance_cashreceiptshare ci on ci.collectionvoucherid = cv.objid 
  where cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
)t1, fund, fundgroup fg 
where fund.objid = t1.fundid 
  and fund.groupid = fg.objid 
  ${filter} 
group by fg.indexno, t1.fundid, fund.code, fund.title, t1.acctid, t1.acctcode, t1.acctname 
order by fg.indexno, fund.code, fund.title, t1.acctcode, t1.acctname 


[getLiquidatedAbstractOfCollection]
select 
  t0.formno, t0.receiptno, t0.receiptdate, t0.formtype, 
  t0.collectorid, t0.collectorname, t0.collectortitle, 
  t0.payorname, t0.payoraddress, t0.fundid, fund.title as fundname, 
  t0.acctid, t0.acctname as accttitle, sum(t0.amount)-sum(t0.share) as amount 
from ( 
  select 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.paidbyaddress else '' end as payoraddress, 
    ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from collectionvoucher cv 
    inner join vw_remittance_cashreceiptitem ci on ci.collectionvoucherid = cv.objid 
  where cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    ci.voided, ci.paidby, ci.paidbyaddress, 
    ci.fundid, ci.acctid, ci.acctname 

  union all 

  select 
    cs.formno, cs.receiptno, cs.receiptdate, cs.formtype, 
    cs.collectorid, cs.collectorname, cs.collectortitle, 
    case when cs.voided=0 then cs.paidby else '*** VOIDED ***' end as payorname, 
    case when cs.voided=0 then cs.paidbyaddress else '' end as payoraddress, 
    cs.fundid, cs.acctid, cs.acctname, 0.0 as amount, sum(cs.amount) as share     
  from ( 
    select ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
    from collectionvoucher cv
      inner join vw_remittance_cashreceiptshare cs on cs.collectionvoucherid = cv.objid 
      inner join vw_remittance_cashreceiptitem ci on (ci.receiptid = cs.receiptid and ci.acctid = cs.refacctid) 
    where cv.controldate >= $P{startdate} 
      and cv.controldate <  $P{enddate} 
      and cv.state = 'POSTED' 
    group by ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
  )t0, vw_remittance_cashreceiptshare cs 
  where cs.receiptid = t0.receiptid 
    and cs.refacctid = t0.acctid 
  group by 
    cs.formno, cs.receiptno, cs.receiptdate, cs.formtype, 
    cs.collectorid, cs.collectorname, cs.collectortitle, 
    cs.voided, cs.paidby, cs.paidbyaddress, 
    cs.fundid, cs.acctid, cs.acctname 

  union all 

  select 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.paidbyaddress else '' end as payoraddress, 
    ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from collectionvoucher cv 
    inner join vw_remittance_cashreceiptshare ci on ci.collectionvoucherid = cv.objid 
  where cv.controldate >= $P{startdate} 
    and cv.controldate <  $P{enddate} 
    and cv.state = 'POSTED' 
  group by 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    ci.voided, ci.paidby, ci.paidbyaddress, 
    ci.fundid, ci.acctid, ci.acctname 
)t0, fund, fundgroup fg 
where fund.objid = t0.fundid 
  and fund.groupid = fg.objid 
  ${filter} 
group by 
  t0.formno, t0.receiptno, t0.receiptdate, t0.formtype, 
  t0.collectorid, t0.collectorname, t0.collectortitle, 
  t0.payorname, t0.payoraddress, t0.fundid, fund.title, 
  t0.acctid, t0.acctname
order by t0.formno, t0.receiptno 


[getRemittedAbstractOfCollection]
select 
  t0.formno, t0.receiptno, t0.receiptdate, t0.formtype, 
  t0.collectorid, t0.collectorname, t0.collectortitle, 
  t0.payorname, t0.payoraddress, t0.fundid, fund.title as fundname, 
  t0.acctid, t0.acctname as accttitle, sum(t0.amount)-sum(t0.share) as amount 
from ( 
  select 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.paidbyaddress else '' end as payoraddress, 
    ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from remittance r  
    inner join vw_remittance_cashreceiptitem ci on ci.remittanceid = r.objid 
  where r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and r.state = 'POSTED' 
  group by 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    ci.voided, ci.paidby, ci.paidbyaddress, 
    ci.fundid, ci.acctid, ci.acctname 

  union all 

  select 
    cs.formno, cs.receiptno, cs.receiptdate, cs.formtype, 
    cs.collectorid, cs.collectorname, cs.collectortitle, 
    case when cs.voided=0 then cs.paidby else '*** VOIDED ***' end as payorname, 
    case when cs.voided=0 then cs.paidbyaddress else '' end as payoraddress, 
    cs.fundid, cs.acctid, cs.acctname, 0.0 as amount, sum(cs.amount) as share     
  from ( 
    select ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
    from remittance r  
      inner join vw_remittance_cashreceiptshare cs on cs.remittanceid = r.objid 
      inner join vw_remittance_cashreceiptitem ci on (ci.receiptid = cs.receiptid and ci.acctid = cs.refacctid) 
    where r.controldate >= $P{startdate} 
      and r.controldate <  $P{enddate} 
      and r.state = 'POSTED' 
    group by ci.receiptid, ci.fundid, ci.acctid, ci.acctcode, ci.acctname 
  )t0, vw_remittance_cashreceiptshare cs 
  where cs.receiptid = t0.receiptid 
    and cs.refacctid = t0.acctid 
  group by 
    cs.formno, cs.receiptno, cs.receiptdate, cs.formtype, 
    cs.collectorid, cs.collectorname, cs.collectortitle, 
    cs.voided, cs.paidby, cs.paidbyaddress, 
    cs.fundid, cs.acctid, cs.acctname 

  union all 

  select 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    case when ci.voided=0 then ci.paidby else '*** VOIDED ***' end as payorname, 
    case when ci.voided=0 then ci.paidbyaddress else '' end as payoraddress, 
    ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount, 0.0 as share 
  from remittance r  
    inner join vw_remittance_cashreceiptshare ci on ci.remittanceid = r.objid 
  where r.controldate >= $P{startdate} 
    and r.controldate <  $P{enddate} 
    and r.state = 'POSTED' 
  group by 
    ci.formno, ci.receiptno, ci.receiptdate, ci.formtype, 
    ci.collectorid, ci.collectorname, ci.collectortitle, 
    ci.voided, ci.paidby, ci.paidbyaddress, 
    ci.fundid, ci.acctid, ci.acctname 
)t0, fund, fundgroup fg 
where fund.objid = t0.fundid 
  and fund.groupid = fg.objid 
  ${filter} 
group by 
  t0.formno, t0.receiptno, t0.receiptdate, t0.formtype, 
  t0.collectorid, t0.collectorname, t0.collectortitle, 
  t0.payorname, t0.payoraddress, t0.fundid, fund.title, 
  t0.acctid, t0.acctname
order by t0.formno, t0.receiptno 
