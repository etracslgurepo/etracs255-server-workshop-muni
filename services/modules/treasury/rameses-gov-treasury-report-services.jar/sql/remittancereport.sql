[getRCDCollectionTypes]
select 
    xx.formtypeindexno, xx.controlid, 
    xx.formno, xx.formtype, xx.stubno, 
    min(xx.receiptno) as fromseries, 
    max(xx.receiptno) as toseries, 
    sum(xx.amount) as amount 
from ( 
  select 
    cr.controlid, cr.series, cr.receiptno, 
    cr.formno, af.formtype, cr.stub as stubno, xx.voided, 
    (case when xx.voided > 0 then 0.0 else cr.amount end) as amount, 
    (case when af.formtype='serial' then 1 else 2 end) as formtypeindexno 
  from ( 
    select c.objid, 
      (select count(*) from cashreceipt_void where receiptid=c.objid) as voided 
    from cashreceipt c  
    where remittanceid = $P{remittanceid} 
  )xx  
    inner join cashreceipt cr on xx.objid=cr.objid 
    inner join af on (cr.formno=af.objid) 
)xx 
group by xx.formtypeindexno, xx.controlid, xx.formno, xx.formtype, xx.stubno
order by xx.formtypeindexno, xx.formno, min(xx.receiptno)  


[getRCDCollectionTypesByFund]
select 
    xx.formtypeindexno, xx.controlid, 
    xx.formno, xx.formtype, xx.stubno, 
    min(xx.receiptno) as fromseries, 
    max(xx.receiptno) as toseries, 
    sum(xx.amount) as amount 
from ( 
  select 
    cr.controlid, cr.series, cr.receiptno, 
    cr.formno, af.formtype, cr.stub as stubno, xx.voided, 
    (case when xx.voided > 0 then 0.0 else cri.amount end) as amount, 
    (case when af.formtype='serial' then 1 else 2 end) as formtypeindexno 
  from ( 
    select c.objid, 
      (select count(*) from cashreceipt_void where receiptid=c.objid) as voided 
    from cashreceipt c  
    where remittanceid = $P{remittanceid} 
  )xx  
    inner join cashreceipt cr on xx.objid=cr.objid 
    inner join cashreceiptitem cri on cr.objid=cri.receiptid 
    inner join itemaccount ia on cri.item_objid=ia.objid 
    inner join af on cr.formno=af.objid 
  where ia.fund_objid = $P{fundid} 
)xx 
where xx.formno like $P{formno} 
group by xx.formtypeindexno, xx.controlid, xx.formno, xx.formtype, xx.stubno
order by xx.formtypeindexno, xx.formno, min(xx.receiptno)  


[getRCDCollectionSummaries]
select particulars, sum(amount) as amount 
from (  
  select  
    concat('AF#', a.objid, ':', ct.title, '-', ia.fund_title)  as particulars, 
    (case when xx.voided > 0 then 0.0 else cri.amount end) as amount 
  from ( 
    select c.objid, c.collectiontype_objid, c.formno, 
      (select count(*) from cashreceipt_void where receiptid=c.objid) as voided 
    from cashreceipt c  
    where c.remittanceid = $P{remittanceid} 
  )xx 
    inner join cashreceiptitem cri on cri.receiptid = xx.objid 
    inner join itemaccount ia on ia.objid = cri.item_objid 
    inner join collectiontype ct on ct.objid = xx.collectiontype_objid 
    inner join af a on a.objid = xx.formno 
  where ia.fund_objid like $P{fundid} 
    and a.objid like $P{formno}  
)xx 
group by particulars 


[getRCDOtherPayment]
select particulars, amount, reftype 
from ( 
  select nc.particulars, nc.amount, nc.reftype, nc.refdate, bank.name as bankname 
  from remittance_noncashpayment remnc 
    inner join cashreceiptpayment_noncash nc on nc.objid=remnc.objid 
    inner join checkpayment cp on cp.objid = nc.refid 
    inner join bank on bank.objid = cp.bankid 
  where remnc.remittanceid = $P{remittanceid} 

  union all 

  select nc.particulars, nc.amount, nc.reftype, nc.refdate, bank.name as bankname 
  from remittance_noncashpayment remnc 
    inner join cashreceiptpayment_noncash nc on nc.objid=remnc.objid 
    inner join creditmemo cm on cm.objid = nc.refid 
    inner join bankaccount ba on ba.objid = cm.bankaccount_objid 
    inner join bank on bank.objid = ba.bank_objid 
  where remnc.remittanceid = $P{remittanceid} 
)tmp1
order by bankname, refdate, amount  



[getNonCashPayments]
select cc.* from ( 
  select rc.*, 
    (select count(*) from cashreceipt_void where receiptid=rc.objid) as voided 
  from remittance_cashreceipt rc 
  where remittanceid = $P{remittanceid} 
)xx 
  inner join remittance r on xx.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash cc ON xx.objid = cc.receiptid 
where xx.voided = 0 
order by cc.bank, cc.refno    


[getReceiptsByRemittanceCollectionType]
select 
  objid, afid, serialno, txndate, paidby, remarks, 
  case when voided=0 then amount else 0.0 end as amount, 
  case when voided=0 then collectiontype else '***VOIDED***' end as collectiontype 
from ( 
  select 
    c.objid, c.formno as afid, c.receiptno as serialno, 
    c.receiptdate as txndate, c.paidby, c.amount, c.remarks, 
    case when ct.title is null then c.collectiontype_name else ct.title end as collectiontype, 
    case when v.objid is null then 0 else 1 end as voided 
  from cashreceipt c  
    left join collectiontype ct on ct.objid = c.collectiontype_objid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where c.remittanceid = $P{remittanceid} 
    and c.collectiontype_objid like $P{collectiontypeid} 
)t1 
order by afid, serialno 


[getReceiptsByRemittanceFund]
select 
  c.receiptid, c.voided, c.formno as afid, c.receiptno as serialno, 
  c.receiptdate as txndate, t2.fundid, fund.title as fundname, 
  (select remarks from cashreceipt where objid = t2.receiptid) as remarks, 
  (case when c.voided = 0 then c.paidby else '***VOIDED***' end) AS payer,
  (case when c.voided = 0 then t2.acctname else '***VOIDED***' end) AS particulars,
  (case when c.voided = 0 then c.paidbyaddress else '' end) AS payeraddress,
  (case when c.voided = 0 then t2.amount else 0.0 end) AS amount, 
  (case when c.voided = 0 then t2.remarks else null end) AS itemremarks  
from ( 
  select receiptid, fundid, acctid, acctname, sum(amount) as amount, max(remarks) as remarks 
  from ( 
    select 
      ci.receiptid, ci.acctid, ci.acctname, ci.amount, ci.fundid, 
      (case when ci.remarks is null then '' else ci.remarks end) as remarks 
    from vw_remittance_cashreceiptitem ci  
    where ci.remittanceid = $P{remittanceid} 
    union all 
    select 
      ci.receiptid, ia.objid as acctid, ia.title as acctname, -ci.amount, 
      ia.fund_objid as fundid, '' as remarks 
    from vw_remittance_cashreceiptshare ci 
      inner join itemaccount ia on ia.objid = ci.refacctid 
    where ci.remittanceid = $P{remittanceid}  
    union all 
    select ci.receiptid, ci.acctid, ci.acctname, ci.amount, ci.fundid, '' as remarks 
    from vw_remittance_cashreceiptshare ci  
    where ci.remittanceid = $P{remittanceid} 
  )t1 
  group by receiptid, fundid, acctid, acctname 
)t2, vw_remittance_cashreceipt c, fund  
where c.receiptid = t2.receiptid 
  and fund.objid = t2.fundid 
  ${fundfilter} 
order by c.formno, c.receiptno, c.paidby 


[getSerialReceiptsByRemittanceFund]
select 
  c.receiptid as objid, c.formno as afid, c.receiptno as serialno, c.receiptdate as txndate, 
  c.paidby as payer, t1.fundid, fund.title as fundname, t1.acctname as particulars, 
  sum(t1.amount) as amount 
from ( 
  select ci.receiptid, ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptitem ci   
  where ci.remittanceid = $P{remittanceid} 
    and ci.formtype = 'serial' 
  group by ci.receiptid, ci.fundid, ci.acctid, ci.acctname 
  union all 
  select 
    ci.receiptid, ia.fund_objid as fundid, ia.objid as acctid, 
    ia.title as acctname, -sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
    inner join itemaccount ia on ia.objid = ci.refacctid 
  where ci.remittanceid = $P{remittanceid} 
    and ci.formtype = 'serial' 
  group by ci.receiptid, ia.fund_objid, ia.objid, ia.title 
  union all 
  select ci.receiptid, ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
  where ci.remittanceid = $P{remittanceid} 
    and ci.formtype = 'serial' 
  group by ci.receiptid, ci.fundid, ci.acctid, ci.acctname 
)t1, vw_remittance_cashreceipt c, fund 
where c.receiptid = t1.receiptid 
  and fund.objid = t1.fundid 
  ${fundfilter} 
group by c.receiptid, c.formno, c.receiptno, c.receiptdate, 
  c.paidby, t1.fundid, fund.title, t1.acctname 
having sum(t1.amount) > 0 
order by c.formno, t1.acctname, c.receiptno 


[getNonSerialReceiptDetailsByFund]
select 
  c.receiptid as objid, c.formno as afid, c.receiptdate as txndate, c.paidby as payer, 
  t1.fundid, fund.title as fundname, t1.acctname as particulars, sum(t1.amount) as amount 
from ( 
  select ci.receiptid, ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptitem ci   
  where ci.remittanceid = $P{remittanceid} 
    and ci.formtype <> 'serial' 
  group by ci.receiptid, ci.fundid, ci.acctid, ci.acctname 
  union all 
  select 
    ci.receiptid, ia.fund_objid as fundid, ia.objid as acctid, 
    ia.title as acctname, -sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
    inner join itemaccount ia on ia.objid = ci.refacctid 
  where ci.remittanceid = $P{remittanceid} 
    and ci.formtype <> 'serial' 
  group by ci.receiptid, ia.fund_objid, ia.objid, ia.title 
  union all 
  select ci.receiptid, ci.fundid, ci.acctid, ci.acctname, sum(ci.amount) as amount 
  from vw_remittance_cashreceiptshare ci 
  where ci.remittanceid = $P{remittanceid} 
    and ci.formtype <> 'serial' 
  group by ci.receiptid, ci.fundid, ci.acctid, ci.acctname 
)t1, vw_remittance_cashreceipt c, fund 
where c.receiptid = t1.receiptid 
  and fund.objid = t1.fundid 
  ${fundfilter} 
group by c.receiptid, c.formno, c.receiptdate, 
  c.paidby, t1.fundid, fund.title, t1.acctname 
having sum(t1.amount) > 0 
order by c.formno, t1.acctname 


[getRevenueItemSummaryByFund]
select 
  t1.fundid, fund.title as fundname, fund.code as fundcode, 
  t1.acctid, t1.acctcode, t1.acctname, sum(t1.amount) as amount 
from ( 
  select ci.fundid, ci.acctid, ci.acctcode, ci.acctname, ci.amount
  from vw_remittance_cashreceiptitem ci  
  where ci.remittanceid = $P{remittanceid} 
  union all 
  select 
    ia.fund_objid as fundid, ia.objid as acctid, ia.code as acctcode, ia.title as acctname, -ci.amount 
  from vw_remittance_cashreceiptshare ci 
    inner join itemaccount ia on ia.objid = ci.refacctid 
  where ci.remittanceid = $P{remittanceid}  
  union all 
  select ci.fundid, ci.acctid, ci.acctcode, ci.acctname, ci.amount 
  from vw_remittance_cashreceiptshare ci 
  where ci.remittanceid = $P{remittanceid} 
)t1, fund 
where fund.objid = t1.fundid 
  ${fundfilter} 
group by t1.fundid, fund.title, fund.code, t1.acctid, t1.acctcode, t1.acctname 
order by fund.code, fund.title, t1.acctcode, t1.acctname 


[getReceiptsGroupByFund]
select 
  t2.fundid, t2.fundcode, t2.fundname, c.formno, c.receiptno, t2.amount, 
  (case when c.voided = 0 then c.paidby else '*** VOIDED ***' end) as paidby 
from ( 
  select 
    t1.receiptid, t1.fundid, fund.code as fundcode, 
    fund.title as fundname, sum(t1.amount) as amount   
  from ( 
    select ci.receiptid, ci.fundid, sum(ci.amount) as amount 
    from vw_remittance_cashreceiptitem ci  
    where ci.remittanceid = $P{remittanceid} 
    group by ci.receiptid, ci.fundid 
    union all 
    select ci.receiptid, ia.fund_objid as fundid, -sum(ci.amount) as amount 
    from vw_remittance_cashreceiptshare ci 
      inner join itemaccount ia on ia.objid = ci.refacctid 
    where ci.remittanceid = $P{remittanceid} 
    group by ci.receiptid, ia.fund_objid 
    union all 
    select ci.receiptid, ci.fundid, sum(ci.amount) as amount 
    from vw_remittance_cashreceiptshare ci 
    where ci.remittanceid = $P{remittanceid} 
    group by ci.receiptid, ci.fundid 
  )t1, fund 
  where fund.objid = t1.fundid ${fundfilter} 
  group by t1.receiptid, t1.fundid, fund.code, fund.title 
)t2, vw_remittance_cashreceipt c 
where c.receiptid = t2.receiptid 
order by t2.fundcode, t2.fundname, c.formno, c.receiptno 


[getFundlist]
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
having sum(t1.amount) > 0 
order by fund.code, fund.title 


[getCollectionType]
select distinct 
  ct.objid, ct.title 
from ( 
  select rc.objid, 
    (select count(*) from cashreceipt_void where receiptid=rc.objid) as voided 
  from cashreceipt rc 
  where remittanceid = $P{remittanceid} 
)xx 
  inner join cashreceipt cr on xx.objid = cr.objid 
  inner join collectiontype ct on cr.collectiontype_objid = ct.objid 
order by ct.title 


[getCashTicketCollectionSummaries]
select formno, particulars, sum(amount) as amount 
from ( 
  select distinct 
    c.objid, c.formno, ifnull(c.subcollector_name, c.collector_name) as particulars, 
    case when v.objid is null then c.amount else 0.0 end as amount,   
    case when v.objid is null then 0 else 1 end as voided  
  from cashreceipt c 
    inner join af on (af.objid = c.formno and af.formtype = 'cashticket') 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where c.remittanceid = $P{remittanceid} 
)t1 
group by formno, particulars 
having sum(amount) > 0 


[getAbstractSummaryOfCollectionByFund]
select 
  rem.objid as remid, rem.controlno as remno, rem.controldate as remdate, rem.dtposted, rem.amount as total, 
  rem.collector_name, rem.collector_title, rem.liquidatingofficer_name, rem.liquidatingofficer_title, 
  c.formno, c.controlid, c.series, c.receiptno, c.receiptdate, fund.objid as acctcode, fund.title as accttitle, 
  (case when c.voided = 0 then c.paidby else '*** VOIDED ***' end) as paidby, t2.amount 
from ( 
  select t1.receiptid, t1.fundid, sum(t1.amount) as amount 
  from ( 
    select ci.receiptid, ci.fundid, sum(ci.amount) as amount 
    from vw_remittance_cashreceiptitem ci  
    where ci.remittanceid = $P{remittanceid} 
    group by ci.receiptid, ci.fundid 
    union all 
    select ci.receiptid, ia.fund_objid as fundid, -sum(ci.amount) as amount 
    from vw_remittance_cashreceiptshare ci 
      inner join itemaccount ia on ia.objid = ci.refacctid 
    where ci.remittanceid = $P{remittanceid} 
    group by ci.receiptid, ia.fund_objid 
    union all 
    select ci.receiptid, ci.fundid, sum(ci.amount) as amount 
    from vw_remittance_cashreceiptshare ci 
    where ci.remittanceid = $P{remittanceid} 
    group by ci.receiptid, ci.fundid 
  )t1 
  group by t1.receiptid, t1.fundid 
)t2 
  inner join vw_remittance_cashreceipt c on c.receiptid = t2.receiptid 
  inner join remittance rem on rem.objid = c.remittanceid 
  inner join fund on fund.objid = t2.fundid 
order by c.receiptdate, c.formno, c.controlid, c.series 


[getAFList]
select 
  ia.fund_objid, cr.formno, af.title as formtitle   
from remittance rem 
  inner join cashreceipt cr on cr.remittanceid = rem.objid 
  inner join cashreceiptitem cri on cri.receiptid = cr.objid 
  inner join itemaccount ia on ia.objid = cri.item_objid 
  inner join af on af.objid = cr.formno 
where rem.objid = $P{remittanceid} 
group by ia.fund_objid, cr.formno, af.title 
order by ia.fund_objid, cr.formno 
