[getLiquidationFunds]
select fund.objid, fund.code, fund.title 
from vw_remittance_cashreceiptitem ci, fund 
where ci.collectionvoucherid = $P{refid}  
  and fund.objid = ci.fundid 
group by fund.objid, fund.code, fund.title


[getJevEntries]
select 
  a.code AS account_code, a.title AS account_title,
  0.0 AS debit, SUM(cri.amount) AS credit
from remittance r 
  inner join cashreceipt cr on cr.remittanceid = r.objid 
  inner join cashreceiptitem cri on cri.receiptid = cr.objid 
  inner join itemaccount ia on ia.objid = cri.item_objid 
  left join cashreceipt_void v on v.receiptid = cr.objid 
  left join collectiontype ct on ct.objid = cr.collectiontype_objid 
  left join account_item_mapping aim on (aim.maingroupid = $P{maingroupid} and aim.itemid = ia.objid) 
  left join account a on a.objid = aim.acctid 
where r.collectionvoucherid = $P{collectionvoucherid} 
  and cri.item_fund_objid = $P{fundid} 
  and cr.formno <> '56' 
  and v.objid is null 
  and ifnull(ct.handler,'') <> 'rpt' 
group by a.code, a.title 
order by a.code, a.title  


[findRPTReceivables]
select 
  '127' as account_code,
  '      RPT RECEIVABLE' AS account_title,
  0.0 as debit, sum(rs.amount) as credit
from remittance r 
  inner join cashreceipt cr on cr.remittanceid = r.objid 
  inner join rptpayment rp on rp.receiptid = cr.objid 
  inner join rptpayment_share rs on rs.parentid = rp.objid 
  inner join itemaccount ia on ia.objid = rs.item_objid 
  left join cashreceipt_void v on v.receiptid = cr.objid 
where r.collectionvoucherid = $P{collectionvoucherid} 
  and ia.fund_objid = $P{fundid} 
  and rs.revtype like $P{revtype} 
  and v.objid is null 


[findRPTBasicDiscount]
select sum(rs.discount) as discount 
from remittance r 
  inner join cashreceipt cr on cr.remittanceid = r.objid 
  inner join rptpayment rp on rp.receiptid = cr.objid 
  inner join rptpayment_share rs on rs.parentid = rp.objid 
  inner join itemaccount ia on ia.objid = rs.item_objid 
  left join cashreceipt_void v on v.receiptid = cr.objid 
where r.collectionvoucherid = $P{collectionvoucherid} 
  and ia.fund_objid = $P{fundid} 
  and rs.revtype like $P{revtype} 
  and v.objid is null 


[getRPTIncomes]
select 
  a.code as account_code, a.title as account_title,
  0.0 as debit, sum(cri.amount) as credit 
from ( 
  select distinct rp.receiptid 
  from remittance r 
    inner join cashreceipt cr on cr.remittanceid = r.objid 
    inner join rptpayment rp on rp.receiptid = cr.objid 
    left join cashreceipt_void v on v.receiptid = cr.objid 
  where r.collectionvoucherid = $P{collectionvoucherid} 
    and v.objid is null 
)t1 
  inner join cashreceiptitem cri on cri.receiptid = t1.receiptid 
  left join account_item_mapping aim on (aim.maingroupid = $P{maingroupid} and aim.itemid = cri.item_objid) 
  left join account a on a.objid = aim.acctid 
where cri.item_fund_objid = $P{fundid} 
group by a.code, a.title 
order by a.code, a.title 


[getRPTShares]
select 
  rs.sharetype, sum(rs.amount) as share
from remittance r 
  inner join cashreceipt cr on cr.remittanceid = r.objid 
  inner join rptpayment rp on rp.receiptid = cr.objid 
  inner join rptpayment_share rs on rs.parentid = rp.objid 
  inner join itemaccount ia on ia.objid = rs.item_objid 
  left join cashreceipt_void v on v.receiptid = cr.objid 
where r.collectionvoucherid = $P{collectionvoucherid} 
  and ia.fund_objid = $P{fundid} 
  and rs.revtype like $P{revtype} 
  and rs.sharetype <> $P{orgtype} 
  and v.objid is null 
group by rs.sharetype 
