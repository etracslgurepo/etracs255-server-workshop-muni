[getBankAccountLedgerItems]
SELECT  
  ba.fund_objid AS fundid,
  ba.objid AS bankacctid,
  ba.acctid AS itemacctid,
  ia.code as itemacctcode, 
  ia.title as itemacctname, 
  SUM(cm.amount) AS dr, 0.0 AS cr,
  'bankaccount_ledger' AS _schemaname 
FROM creditmemo cm
  INNER JOIN bankaccount ba ON cm.bankaccount_objid = ba.objid
  INNER JOIN itemaccount ia ON ba.acctid = ia.objid 
WHERE cm.objid = $P{objid}
GROUP BY ba.fund_objid, ba.objid, ba.acctid, ia.code, ia.title 


[getIncomeLedgerItems]
SELECT 
  ba.fund_objid AS fundid, 
  ia.objid AS itemacctid, 
  ia.code AS itemacctcode, 
  ia.title AS itemacctname, 
  0.0 AS dr, cmi.amount AS cr, 
  'income_ledger' AS _schemaname  
FROM creditmemoitem cmi 
  INNER JOIN creditmemo cm ON cm.objid = cmi.parentid
  INNER JOIN bankaccount ba ON cm.bankaccount_objid = ba.objid
  INNER JOIN itemaccount ia ON cmi.item_objid = ia.objid
WHERE cm.objid = $P{objid}


[postIncomeSummary]
insert into income_summary ( 
  refid, refdate, refno, reftype, acctid, fundid, orgid, collectorid, refyear, refmonth, refqtr, 
  liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr, 
  remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, amount 
) 
select 
  refid, refdate, refno, reftype, acctid, fundid, orgid, collectorid, refyear, refmonth, refqtr, 
  liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr, 
  remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, sum(amount) as amount 
from ( 
  select 
    cm.objid as refid, cm.refdate, cm.refno, 'CREDITMEMO' as reftype, 
    ia.objid as acctid, ia.fund_objid as fundid, cmi.amount, 
    ${orgid} as orgid, cm.issuedby_objid as collectorid, 
    year(cm.refdate) as refyear, 
    month(cm.refdate) as refmonth, 
    case 
      when month(cm.refdate) between 1 and 3 then 1
      when month(cm.refdate) between 4 and 6 then 2
      when month(cm.refdate) between 7 and 9 then 3
      when month(cm.refdate) between 10 and 12 then 4
    end as refqtr, 
    cm.objid as liquidationid, 
    cm.refdate as liquidationdate, 
    year(cm.refdate) as liquidationyear, 
    month(cm.refdate) as liquidationmonth, 
    case 
      when month(cm.refdate) between 1 and 3 then 1 
      when month(cm.refdate) between 4 and 6 then 2 
      when month(cm.refdate) between 7 and 9 then 3 
      when month(cm.refdate) between 10 and 12 then 4 
    end as liquidationqtr, 
    cm.objid as remittanceid, 
    cm.refdate as remittancedate, 
    year(cm.refdate) as remittanceyear, 
    month(cm.refdate) as remittancemonth, 
    case 
      when month(cm.refdate) between 1 and 3 then 1 
      when month(cm.refdate) between 4 and 6 then 2 
      when month(cm.refdate) between 7 and 9 then 3 
      when month(cm.refdate) between 10 and 12 then 4 
    end as remittanceqtr 
  from creditmemo cm 
    inner join creditmemoitem cmi on cmi.parentid = cm.objid 
    inner join itemaccount ia on ia.objid = cmi.item_objid 
  where cm.objid = $P{objid} 
    and cm.state = 'POSTED' 
)t1 
group by 
  refid, refdate, refno, reftype, acctid, fundid, orgid, collectorid, refyear, refmonth, refqtr, 
  liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr, 
  remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr 
