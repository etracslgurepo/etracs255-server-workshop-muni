[getCollectionFundlist]
select * from ( 
  select 
    fund_objid as fundid, fund_title as fundname, 
    case 
      when fund_objid='GENERAL' then 1 
      when fund_objid='TRUST' then 3 
      when fund_objid='SEF' then 2       
      else 100   
    end as fundsortorder 
  from collectionvoucher_fund 
  where parentid = $P{collectionvoucherid} 
)t1  
order by t1.fundsortorder, t1.fundname 


[findCollectionVoucherFund]
select 
  cv.controlno, cv.controldate, 
  cv.liquidatingofficer_name, cv.liquidatingofficer_title, 
  cvf.fund_objid, cvf.fund_title, cvf.amount, cv.cashbreakdown 
from collectionvoucher cv  
  inner join collectionvoucher_fund cvf on cvf.parentid = cv.objid 
where cv.objid = $P{collectionvoucherid}  
  and cvf.fund_objid = $P{fundid} 


[getRCDRemittances]
select 
  collectorid, collectorname, dtposted, txnno, sum(amount) as amount  
from ( 
  select 
      r.collector_objid as collectorid, r.collector_name as collectorname, 
      r.controlno as txnno, convert(DATE, r.controldate) as dtposted, rf.amount 
  from remittance r 
    inner join remittance_fund rf ON rf.remittanceid = r.objid   
  where r.collectionvoucherid = $P{collectionvoucherid}   
    and rf.fund_objid in ( 
      select objid from fund where objid like $P{fundid}  
      union 
      select objid from fund where objid in (${fundfilter}) 
    ) 
)t1  
group by collectorid, collectorname, dtposted, txnno 
order by collectorid, collectorname, dtposted, txnno 


[getRCDCollectionSummary]
select * from ( 
  select  
    cvf.fund_title as particulars, cvf.amount, 
    case 
        when cvf.fund_objid='GENERAL' then 1 
        when cvf.fund_objid='SEF' then 2 
        when cvf.fund_objid='TRUST' then 3 
        else 100  
    end as fundsortorder
  from collectionvoucher_fund cvf  
  where cvf.parentid = $P{collectionvoucherid} 
    and cvf.fund_objid in ( 
      select objid from fund where objid like $P{fundid} 
      union 
      select objid from fund where objid in (${fundfilter}) 
    ) 
)t1 
order by t1.fundsortorder, t1.particulars 


[getRCDOtherPayments]
select * 
from ( 
  select 
    cp.bank_name, nc.reftype, nc.particulars, 
    sum(nc.amount) as amount, min(nc.refdate) as refdate 
  from remittance rem 
    inner join cashreceipt c on c.remittanceid = rem.objid 
    inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'CHECK') 
    inner join checkpayment cp on cp.objid = nc.refid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where rem.collectionvoucherid = $P{collectionvoucherid} 
    and nc.fund_objid in ( 
      select objid from fund where objid like $P{fundid} 
      union 
      select objid from fund where objid in (${fundfilter}) 
    ) 
    and v.objid is null 
  group by cp.bank_name, nc.reftype, nc.particulars 

  union all 

  select 
    ba.bank_name, nc.reftype, nc.particulars, 
    sum(nc.amount) as amount, min(nc.refdate) as refdate 
  from remittance rem 
    inner join cashreceipt c on c.remittanceid = rem.objid 
    inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'EFT') 
    inner join eftpayment e on e.objid = nc.refid 
    inner join bankaccount ba on ba.objid = e.bankacctid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where rem.collectionvoucherid = $P{collectionvoucherid} 
    and nc.fund_objid in ( 
      select objid from fund where objid like $P{fundid} 
      union 
      select objid from fund where objid in (${fundfilter}) 
    ) 
    and v.objid is null 
  group by ba.bank_name, nc.reftype, nc.particulars 
)t1 
order by bank_name, refdate, amount 


[getRevenueItemSummaryByFund]
select 
  t1.fundid, fund.title as fundname, 
  t1.acctid, t1.acctcode, t1.acctname, 
  sum(t1.amount)-sum(t1.share) as amount 
from ( 
  select 
    cri.receiptid, cri.item_fund_objid as fundid, 
    cri.item_objid as acctid, cri.item_code as acctcode, cri.item_title as acctname, 
    case when v.objid is null then cri.amount else 0.0 end as amount, 0.0 as share, 
    case when v.objid is null then 0 else 1 end as voided 
  from remittance r 
    inner join cashreceipt c on c.remittanceid = r.objid 
    inner join cashreceiptitem cri on cri.receiptid = c.objid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where r.collectionvoucherid = $P{collectionvoucherid} 

  union all 

  select
    tt2.receiptid, tt2.fundid, tt2.acctid, tt2.acctcode, tt2.acctname, 0.0 as amount, 
    case when tt2.voided=0 then cs.amount else 0.0 end as share, tt2.voided
  from ( 
    select receiptid, fundid, acctid, acctcode, acctname, voided, count(*) as icount  
    from (  
      select 
        cri.receiptid, cri.item_fund_objid as fundid, 
        cri.item_objid as acctid, cri.item_code as acctcode, cri.item_title as acctname, 
        case when v.objid is null then 0 else 1 end as voided 
      from remittance r 
        inner join cashreceipt c on c.remittanceid = r.objid 
        inner join cashreceiptitem cri on cri.receiptid = c.objid 
        left join cashreceipt_void v on v.receiptid = c.objid 
      where r.collectionvoucherid = $P{collectionvoucherid} 
    )tt1 
    group by receiptid, fundid, acctid, acctcode, acctname, voided 
  )tt2, cashreceipt_share cs 
  where cs.receiptid = tt2.receiptid 
    and cs.refitem_objid = tt2.acctid 

  union all 

  select 
    cs.receiptid, ia.fund_objid as fundid, ia.objid as acctid, ia.code as acctcode, ia.title as acctname, 
    case when v.objid is null then cs.amount else 0.0 end as amount, 0.0 as share, 
    case when v.objid is null then 0 else 1 end as voided 
  from remittance r 
    inner join cashreceipt c on c.remittanceid = r.objid 
    inner join cashreceipt_share cs on cs.receiptid = c.objid 
    inner join itemaccount ia on ia.objid = cs.payableitem_objid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where r.collectionvoucherid = $P{collectionvoucherid} 
)t1, fund 
where fund.objid = t1.fundid ${fundfilter} 
group by t1.fundid, fund.title, t1.acctid, t1.acctcode, t1.acctname 
order by fund.title, t1.acctcode 


[getReceipts]
select 
  c.objid, c.remittanceid, c.formno as afid, c.receiptno as serialno, c.receiptdate as txndate, 
  c.paidby, c.paidbyaddress, c.remarks, fund.objid as fundid, fund.title as fundname, 
  case when t2.voided=0 then c.paidby else '***VOIDED***' end as payer,
  case when t2.voided=0 then t2.acctname else '***VOIDED***' end as particulars,
  case when t2.voided=0 then c.paidbyaddress else '' end as payeraddress,
  case when t2.voided=0 then t2.amount else 0.0 end as amount 
from ( 
  select receiptid, fundid, acctid, acctname, sum(amount)-sum(share) as amount, voided 
  from ( 
    select 
      cri.receiptid, cri.item_fund_objid as fundid, cri.item_objid as acctid, cri.item_title as acctname, 
      case when v.objid is null then cri.amount else 0.0 end as amount, 0.0 as share, 
      case when v.objid is null then 0 else 1 end as voided 
    from remittance r 
      inner join cashreceipt c on c.remittanceid = r.objid 
      inner join cashreceiptitem cri on cri.receiptid = c.objid 
      left join cashreceipt_void v on v.receiptid = c.objid 
    where r.collectionvoucherid = $P{collectionvoucherid} 

    union all 

    select
      tt2.receiptid, tt2.fundid, tt2.acctid, tt2.acctname, 0.0 as amount, 
      case when tt2.voided=0 then cs.amount else 0.0 end as share, tt2.voided
    from ( 
      select receiptid, fundid, acctid, acctname, voided, count(*) as icount  
      from (  
        select 
          cri.receiptid, cri.item_fund_objid as fundid, cri.item_objid as acctid, cri.item_title as acctname, 
          case when v.objid is null then 0 else 1 end as voided 
        from remittance r 
          inner join cashreceipt c on c.remittanceid = r.objid 
          inner join cashreceiptitem cri on cri.receiptid = c.objid 
          left join cashreceipt_void v on v.receiptid = c.objid 
        where r.collectionvoucherid = $P{collectionvoucherid} 
      )tt1 
      group by receiptid, fundid, acctid, acctname, voided 
    )tt2, cashreceipt_share cs 
    where cs.receiptid = tt2.receiptid 
      and cs.refitem_objid = tt2.acctid 

    union all 

    select 
      cs.receiptid, ia.fund_objid as fundid, ia.objid as acctid, ia.title as acctname, 
      case when v.objid is null then cs.amount else 0.0 end as amount, 0.0 as share, 
      case when v.objid is null then 0 else 1 end as voided 
    from remittance r 
      inner join cashreceipt c on c.remittanceid = r.objid 
      inner join cashreceipt_share cs on cs.receiptid = c.objid 
      inner join itemaccount ia on ia.objid = cs.payableitem_objid 
      left join cashreceipt_void v on v.receiptid = c.objid 
    where r.collectionvoucherid = $P{collectionvoucherid} 
  )t1 
  group by receiptid, fundid, acctid, acctname, voided 
)t2, cashreceipt c, fund  
where c.objid = t2.receiptid 
  and fund.objid = t2.fundid ${fundfilter} 
order by c.formno, c.receiptno 


[getReceiptItemAccounts]
select 
  t1.fundid, fund.title as fundname, 
  t1.acctid, t1.acctcode, t1.acctname, 
  sum(t1.amount)-sum(t1.share) as amount 
from ( 
  select 
    cri.receiptid, cri.item_fund_objid as fundid, 
    cri.item_objid as acctid, cri.item_code as acctcode, cri.item_title as acctname, 
    case when v.objid is null then cri.amount else 0.0 end as amount, 0.0 as share, 
    case when v.objid is null then 0 else 1 end as voided 
  from remittance r 
    inner join cashreceipt c on c.remittanceid = r.objid 
    inner join cashreceiptitem cri on cri.receiptid = c.objid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where r.collectionvoucherid = $P{collectionvoucherid} 

  union all 

  select
    tt2.receiptid, tt2.fundid, tt2.acctid, tt2.acctcode, tt2.acctname, 0.0 as amount, 
    case when tt2.voided=0 then cs.amount else 0.0 end as share, tt2.voided
  from ( 
    select receiptid, fundid, acctid, acctcode, acctname, voided, count(*) as icount  
    from (  
      select 
        cri.receiptid, cri.item_fund_objid as fundid, 
        cri.item_objid as acctid, cri.item_code as acctcode, cri.item_title as acctname, 
        case when v.objid is null then 0 else 1 end as voided 
      from remittance r 
        inner join cashreceipt c on c.remittanceid = r.objid 
        inner join cashreceiptitem cri on cri.receiptid = c.objid 
        left join cashreceipt_void v on v.receiptid = c.objid 
      where r.collectionvoucherid = $P{collectionvoucherid} 
    )tt1 
    group by receiptid, fundid, acctid, acctcode, acctname, voided 
  )tt2, cashreceipt_share cs 
  where cs.receiptid = tt2.receiptid 
    and cs.refitem_objid = tt2.acctid 

  union all 

  select 
    cs.receiptid, ia.fund_objid as fundid, ia.objid as acctid, ia.code as acctcode, ia.title as acctname, 
    case when v.objid is null then cs.amount else 0.0 end as amount, 0.0 as share, 
    case when v.objid is null then 0 else 1 end as voided 
  from remittance r 
    inner join cashreceipt c on c.remittanceid = r.objid 
    inner join cashreceipt_share cs on cs.receiptid = c.objid 
    inner join itemaccount ia on ia.objid = cs.payableitem_objid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where r.collectionvoucherid = $P{collectionvoucherid} 
)t1, fund 
where fund.objid = t1.fundid ${fundfilter} 
group by t1.fundid, fund.title, t1.acctid, t1.acctcode, t1.acctname 
order by fund.title, t1.acctcode 
