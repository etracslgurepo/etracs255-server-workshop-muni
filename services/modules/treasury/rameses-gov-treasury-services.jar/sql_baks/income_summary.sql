[postIncomeSummary]
insert into income_summary ( 
   refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
   remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr,
   orgid, collectorid, acctid, fundid, amount, 
   liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr 
) 
select 
   refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
   remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, 
   orgid, collectorid, acctid, fundid, sum(amount) as amount, 
   refid as liquidationid, refdate as liquidationdate, refyear as liquidationyear,
   refmonth as liquidationmonth, refqtr as liquidationqtr 
from ( 
   select  
      lq.objid as refid, convert(lq.dtposted, date) as refdate, lq.txnno as refno, 'liquidation' as reftype,
      year(lq.dtposted) as refyear, month(lq.dtposted) as refmonth, 
      case 
         when month(lq.dtposted) <= 3 then 1
         when month(lq.dtposted) <= 6 then 2
         when month(lq.dtposted) <= 9 then 3
         when month(lq.dtposted) <= 12 then 4
         else 0 
      end as refqtr, 
      r.objid as remittanceid, convert(r.remittancedate, date) as remittancedate, 
      year(r.remittancedate) as remittanceyear, month(r.remittancedate) as remittancemonth, 
      case 
         when month(r.remittancedate) <= 3 then 1
         when month(r.remittancedate) <= 6 then 2
         when month(r.remittancedate) <= 9 then 3
         when month(r.remittancedate) <= 12 then 4
         else 0 
      end as remittanceqtr, 
      ci.item_objid AS acctid, 
      ri.fund_objid AS fundid,
      ci.amount,
      c.org_objid AS orgid,
      r.collector_objid AS collectorid 
   FROM liquidation lq 
       INNER JOIN liquidation_remittance lr ON lq.objid=lr.liquidationid 
       INNER JOIN remittance r ON r.objid=lr.objid 
       INNER JOIN remittance_cashreceipt rc ON rc.remittanceid=r.objid 
       INNER JOIN cashreceipt c ON c.objid=rc.objid 
       INNER JOIN cashreceiptitem ci ON c.objid=ci.receiptid 
       INNER JOIN itemaccount ri ON ci.item_objid=ri.objid 
   WHERE lq.objid = $P{liquidationid} 
      AND c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
)tmp1 
group by 
   refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
   remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, 
   orgid, collectorid, acctid, fundid 
