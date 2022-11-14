[findRemittanceByid]
SELECT * FROM remittance WHERE objid = $P{remittanceid}

[getRemittanceFund]
select rf.* 
from remittance_fund rf 
  inner join remittance r on r.objid = rf.remittanceid   
where rf.remittanceid = $P{remittanceid} 

[getRemittanceAF]
select raf.* 
from remittance_af raf 
  inner join remittance r on r.objid = raf.remittanceid   
where raf.remittanceid = $P{remittanceid} 

[getCashReceipt]
SELECT cr.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
WHERE cr.remittanceid = $P{remittanceid}  

[getCashReceiptItem]
SELECT ci.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
  INNER JOIN cashreceiptitem ci ON ci.receiptid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid}  

[getCashReceiptVoid]
SELECT v.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
  INNER JOIN cashreceipt_void v on v.receiptid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid} 

[getCashReceiptNoncashPayment]
SELECT nc.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
  INNER JOIN cashreceiptpayment_noncash nc on nc.receiptid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid} 

[getCheckPayment]
SELECT cp.* 
FROM ( 
  SELECT DISTINCT nc.checkid 
  FROM remittance r 
    INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
    INNER JOIN cashreceiptpayment_noncash nc on nc.receiptid = cr.objid 
  WHERE cr.remittanceid = $P{remittanceid} 
    AND nc.reftype = 'CHECK' 
)t1, checkpayment cp 
WHERE cp.objid = t1.checkid  

[getCashReceiptShare]
SELECT s.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
  INNER JOIN cashreceipt_share s on s.receiptid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid} 

[getCashReceiptCancelSeries]
SELECT s.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
  INNER JOIN cashreceipt_cancelseries s on s.receiptid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid} 

[getCashReceiptReprintLog]
SELECT s.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
  INNER JOIN cashreceipt_reprint_log s on s.receiptid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid} 

[getCashTicket]
SELECT t.* 
FROM remittance r 
  INNER JOIN cashreceipt cr ON cr.remittanceid = r.objid 
  INNER JOIN cashreceipt_cashticket t on t.objid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid} 


[getRemittanceItems]
SELECT c.formno, c.collector_objid, c.controlid, min(c.formtype) as formtype,  
  case when c.formtype = 'serial' then  MIN(series) else null  end as startseries, 
  case when c.formtype = 'serial' then MAX(series) else null  end as endseries, 
  min( series ) as minseries, 
  SUM( CASE WHEN c.state = 'POSTED' then 1 else 0 end ) as qty ,  
  SUM( CASE WHEN c.state = 'CANCELLED' then 1 else 0 end ) as cqty , 
  SUM(CASE WHEN v.objid IS NULL THEN c.amount ELSE 0 END) AS amount,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalcash-c.cashchange ELSE 0 END) AS totalcash,
  SUM(CASE WHEN v.objid IS NULL THEN c.totalnoncash ELSE 0 END) AS totalnoncash
FROM cashreceipt c 
  INNER JOIN remittance r on r.objid = c.remittanceid 
  LEFT JOIN cashreceipt_void v ON c.objid=v.receiptid
where c.remittanceid = $P{remittanceid} 
GROUP BY c.collector_objid, c.formno, c.formtype, c.controlid
