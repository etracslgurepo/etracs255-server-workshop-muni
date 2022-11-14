[getAccountMappings]
select 
  aim.itemid, 
  a.code AS account_code, 
  a.title AS account_title 
from account_item_mapping aim 
  inner join account a on a.objid = aim.acctid 
where aim.maingroupid = $P{maingroupid} 
  and aim.itemid in ( ${acctids} ) 
group by a.code, a.title, aim.itemid  
order by a.code, a.title, aim.itemid  


[findRPTReceivables]
select 
  '127' as account_code,
  '      RPT RECEIVABLE' AS account_title,
  0.0 as debit, sum(rs.amount) as credit
from rptpayment rp 
  inner join rptpayment_share rs on rs.parentid = rp.objid 
  inner join itemaccount ia on ia.objid = rs.item_objid 
where rp.receiptid in ( ${receiptids} ) 
  and ia.fund_objid = $P{fundid} 
  and rs.revtype like $P{revtype} 
  and rp.type = 'eor' 


[findRPTBasicDiscount]
select 
  sum(rs.discount) as discount
from rptpayment rp 
  inner join rptpayment_share rs on rs.parentid = rp.objid 
  inner join itemaccount ia on ia.objid = rs.item_objid 
where rp.receiptid in ( ${receiptids} ) 
  and ia.fund_objid = $P{fundid} 
  and rs.revtype like $P{revtype} 
  and rp.type = 'eor' 


[getRPTShares]
select 
  rs.sharetype, sum(rs.amount) as share
from rptpayment rp 
  inner join rptpayment_share rs on rs.parentid = rp.objid 
  inner join itemaccount ia on ia.objid = rs.item_objid 
where rp.receiptid in ( ${receiptids} ) 
  and ia.fund_objid = $P{fundid} 
  and rs.revtype like $P{revtype} 
  and rs.sharetype <> $P{orgtype} 
  and rp.type = 'eor' 
group by rs.sharetype 
