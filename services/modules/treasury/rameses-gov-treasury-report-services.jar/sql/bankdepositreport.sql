[getFundlist]
select 
  distinct lcf.fund_objid as objid , lcf.fund_title as title 
from bankdeposit bd 
  inner join bankdeposit_liquidation bl on bd.objid = bl.bankdepositid 
  inner join liquidation_fund lcf on lcf.objid = bl.objid  
where bd.objid = $P{bankdepositid}

[getBackAccountList]
select 
    distinct ba.objid, concat( ba.bank_code, ' ( ', ba.code, ' )'  ) as title 
from bankdeposit_entry be 
 inner join bankaccount ba on ba.objid = be.bankaccount_objid 
where parentid=$P{bankdepositid}

[getCollectionSummaryByAFAndFund]
select  
  concat('AF#' , a.objid ,  ':' , ct.title , '-' , ri.fund_title )  as particulars, 
  sum( cri.amount ) as amount 
from ( 
  select distinct lr.* 
  from bankdeposit_liquidation bdl 
    inner join liquidation_fund lcf on bdl.objid=lcf.objid 
    inner join liquidation liq on lcf.liquidationid=liq.objid 
    inner join liquidation_remittance lr on liq.objid=lr.liquidationid 
  where bdl.bankdepositid=$P{bankdepositid}  
)xx 
  inner join remittance_cashreceipt rc on xx.objid=rc.remittanceid 
  inner join cashreceipt cr on rc.objid=cr.objid 
  inner join collectiontype ct on ct.objid=cr.collectiontype_objid 
  inner join af a on a.objid=cr.formno 
  inner join cashreceiptitem cri on cri.receiptid = cr.objid
  inner join itemaccount ri on ri.objid = cri.item_objid 
where cr.objid not in ( select receiptid from cashreceipt_void where receiptid=cr.objid ) 
  and ri.fund_objid in ( 
    select objid from fund where objid = $P{fundname} 
    union 
    select objid from fund where objid in (${fundfilter}) 
  ) 
group by a.objid, ct.title, ri.fund_title 


[getRevenueItemSummaryByFund]
select 
  ri.fund_title as fundname, cri.item_objid as acctid, cri.item_title as acctname,
  cri.item_code as acctcode, sum( cri.amount ) as amount 
from( 
  select
    distinct lf.liquidationid, lf.fund_objid
  from bankdeposit b 
    inner join bankdeposit_liquidation bl on b.objid = bl.bankdepositid
    inner join liquidation_fund lf on lf.objid = bl.objid 
  where b.objid=$P{bankdepositid} 
  ) a 
  inner join liquidation_remittance lr on lr.liquidationid = a.liquidationid 
  inner join remittance_cashreceipt rc on rc.remittanceid = lr.objid 
  inner join cashreceipt c on c.objid = rc.objid 
  inner join cashreceiptitem cri on cri.receiptid = c.objid
  inner join itemaccount ri on ri.objid = cri.item_objid and ri.fund_objid = a.fund_objid
where c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
group by ri.fund_title, cri.item_objid, cri.item_code, cri.item_title 
order by fundname, acctcode  


[getBarangayShares]
select 
  ri.fund_title as fundname, ri.objid as acctid, ri.title as acctname,
  ri.code as acctcode, sum( cri.brgyshare + cri.brgyintshare ) as amount 
from( 
  select
    distinct lf.liquidationid
  from bankdeposit b 
    inner join bankdeposit_liquidation bl on b.objid = bl.bankdepositid
    inner join liquidation_fund lf on lf.objid = bl.objid 
  where b.objid=$P{bankdepositid} 
  ) a 
  inner join liquidation_remittance lr on lr.liquidationid = a.liquidationid 
  inner join remittance_cashreceipt rc on rc.remittanceid = lr.objid 
  inner join cashreceipt c on c.objid = rc.objid 
  inner join cashreceiptitem_rpt cri on cri.rptreceiptid = c.objid
  inner join brgyshare_account_mapping bam on cri.barangayid = bam.barangayid 
  inner join itemaccount ri on ri.objid = bam.acct_objid
where c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
  and c.formno = '56'
group by ri.fund_title, ri.objid, ri.code, ri.title 
order by fundname, acctcode, acctname  


[getLiquidations]
select distinct 
  l.liquidatingofficer_name as liquidatingofficer,
  l.txnno, lf.amount 
from bankdeposit b 
  inner join bankdeposit_liquidation bl on b.objid = bl.bankdepositid
  inner join liquidation_fund lf on lf.objid = bl.objid 
  inner join liquidation l on l.objid = lf.liquidationid
where b.objid=$P{bankdepositid} 
  and lf.fund_objid in ( 
    select objid from fund where objid=$P{fundname} 
    union 
    select objid from fund where objid in (${fundfilter}) 
  ) 


[getCashFundSummary]
select 
    bd.cashier_name as cashier, 
    concat(ba.bank_code, ' - Cash D/S: Account ' , be.bankaccount_code ) as depositref, 
    SUM(be.totalcash) as depositamt 
from bankdeposit bd 
 inner join bankdeposit_entry be on bd.objid = be.parentid 
 inner join bankaccount ba on ba.objid = be.bankaccount_objid 
where bd.objid=$P{bankdepositid} 
  and ba.fund_objid in ( 
    select objid from fund where objid=$P{fundname} 
    union 
    select objid from fund where objid in (${fundfilter}) 
  ) 
  and be.totalcash > 0.0 
GROUP BY bd.cashier_name, ba.bank_code, be.bankaccount_code


[getCheckFundSummary]
select 
    bd.cashier_name as cashier, 
    concat(ba.bank_code, ' - Check D/S: Account ' , be.bankaccount_code ) as depositref, 
    SUM(be.totalnoncash) as depositamt 
from bankdeposit bd 
 inner join bankdeposit_entry be on bd.objid = be.parentid 
 inner join bankaccount ba on ba.objid = be.bankaccount_objid 
where bd.objid=$P{bankdepositid} 
  and ba.fund_objid in ( 
    select objid from fund where objid=$P{fundname} 
    union 
    select objid from fund where objid in (${fundfilter}) 
  ) 
  and be.totalnoncash > 0.0 
GROUP BY bd.cashier_name, ba.bank_code, be.bankaccount_code


[getCashReceiptByBankdepositid]
select 
  c.collector_name as collectorname,  
  c.receiptdate as receiptdate,  
  c.receiptno as serialno, 
  c.paidby as payorname,  
  ci.item_title as accttitle,  
  ci.amount as amount, 
  ci.item_code as acctno,
  case when cv.objid IS null then 0 else 1 end as voided,
  c.formno as afid 
from( 
  select 
    distinct lf.liquidationid
  from bankdeposit b 
    inner join bankdeposit_liquidation bl on b.objid = bl.bankdepositid
    inner join liquidation_fund lf on lf.objid = bl.objid 
  where b.objid=$P{bankdepositid} 
) a 
inner join liquidation_remittance lr on lr.liquidationid = a.liquidationid 
inner join remittance_cashreceipt rc on rc.remittanceid = lr.objid 
inner join cashreceipt c on c.objid = rc.objid 
inner join cashreceiptitem ci on ci.receiptid = c.objid
left join cashreceipt_void cv on cv.receiptid = c.objid 


[getDepositAmount]
select 
  be.totalcash, be.totalnoncash, 
  ba.code AS bankacctno, ba.bank_code as bankcode, 
  ba.fund_title as fund, be.amount, be.summaries 
from bankdeposit_entry be 
   inner join bankaccount ba on be.bankaccount_objid = ba.objid 
where be.parentid = $P{bankdepositid} 
  and be.bankaccount_objid = $P{bankaccountid} 


[getDepositSlipSummaryByFund]
select 
  bd.cashier_name as cashier, 
  concat(ba.bank_code, ' - Cash D/S: Account ', be.bankaccount_code ) as depositref, 
  NULL as depositamt 
from bankdeposit bd 
  inner join bankdeposit_entry be on bd.objid = be.parentid 
  inner join bankaccount ba on ba.objid = be.bankaccount_objid 
  inner join fund f on ba.fund_objid = f.parentid
where bd.objid=$P{bankdepositid} 
  and f.objid in (  
    select objid from fund where objid = $P{fundname} 
    union 
    select objid from fund where objid in (${fundfilter})  
  ) 
