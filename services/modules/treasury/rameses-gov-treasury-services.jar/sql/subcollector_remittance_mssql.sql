[getList]
select r.* 
from subcollector_remittance r 
where 1=1 ${filter} 
order by r.dtposted desc 

[getCollectors]
SELECT 
   DISTINCT   
   cr.collector_name AS name,
   cr.collector_title AS title,
   cr.collector_objid AS objid
FROM cashreceipt cr
WHERE cr.state = 'DELEGATED'
AND cr.subcollector_objid=$P{subcollectorid}

[getUremittedCollectionSummary]
SELECT 
   cr.controlid, cr.formno, cr.stub, 
   MIN(cr.receiptno) AS startno,
   MAX(cr.receiptno) AS endno,
   SUM( CASE WHEN cv.objid IS NULL THEN cr.amount ELSE 0 END ) AS amount
FROM cashreceipt cr
  LEFT JOIN cashreceipt_void cv ON cr.objid=cv.receiptid
WHERE cr.state = 'DELEGATED'
  AND cr.collector_objid = $P{collectorid}
  AND cr.subcollector_objid = $P{subcollectorid}
GROUP BY cr.controlid, cr.formno, cr.stub 
ORDER BY cr.formno, cr.stub, cr.controlid 

[getItemsRemittance]
select 
  cr.controlid, cr.formno, cr.stub, 
  min(cr.receiptno) as startno, max(cr.receiptno) as endno, 
  sum(case when xx.voided=0 then cr.amount else 0.0 end) as amount, 
  count(cr.objid) as qtyissued, af.formtype, af.denomination
from ( 
  select remc.*, 
    (select count(*) from cashreceipt_void where receiptid=remc.objid) as voided 
  from subcollector_remittance_cashreceipt remc 
  where remc.remittanceid=$P{objid} 
)xx 
  inner join cashreceipt cr on xx.objid=cr.objid 
  inner join af on cr.formno=af.objid 
group by cr.controlid, cr.formno, cr.stub, af.formtype, af.denomination  
order by cr.formno, min(cr.series) 

[findSummaryTotals]
select 
  sum(itemcount) as itemcount, 
  sum(case when voided>0 then 0 else amount end) as amount, 
  sum(case when voided>0 then 0 else totalcash end) as totalcash, 
  sum(case 
    when voided>0 then 0 
    when checked>0 then totalnoncash 
    else 0 
    end 
  ) as totalnoncash 
from ( 
  SELECT 
    (select count(*) from cashreceipt_void where receiptid=cr.objid) as voided, 
    (select count(*) from cashreceiptpayment_noncash where receiptid=cr.objid) as checked, 
    1 as itemcount, cr.amount, cr.totalnoncash, (cr.totalcash-cr.cashchange) as totalcash 
  FROM cashreceipt cr
  WHERE cr.state = 'DELEGATED'
    AND cr.collector_objid = $P{collectorid} 
    AND cr.subcollector_objid = $P{subcollectorid} 
)xx 
  
[collectReceipts]
INSERT INTO subcollector_remittance_cashreceipt (objid, remittanceid)
SELECT cr.objid, $P{remittanceid} 
FROM cashreceipt cr  
WHERE cr.state = 'DELEGATED'
AND cr.collector_objid = $P{collectorid}
AND cr.subcollector_objid=$P{subcollectorid}

[updateCashReceiptState]
UPDATE cr  
SET cr.state = 'POSTED'
from  cashreceipt cr
WHERE EXISTS (
  SELECT csr.objid 
  FROM subcollector_remittance_cashreceipt csr
  WHERE csr.remittanceid = $P{remittanceid} AND csr.objid=cr.objid
)

[getCheckPaymentByRemittanceId]
select 
  rc.remittanceid, nc.refid, nc.refno, nc.refdate, nc.reftype, nc.particulars, 
  sum(nc.amount) as amount 
from subcollector_remittance_cashreceipt rc 
  inner join cashreceiptpayment_noncash nc on nc.receiptid = rc.objid 
  left join cashreceipt_void cv on cv.receiptid = nc.receiptid 
where rc.remittanceid = $P{remittanceid} 
   and cv.objid is null 
group by rc.remittanceid, nc.refid, nc.refno, nc.refdate, nc.reftype, nc.particulars 

[getCheckPaymentBySubcollector]
select 
  nc.refid, nc.refno, nc.refdate, nc.reftype, nc.particulars, 
  sum(nc.amount) as amount 
from cashreceipt c 
  inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
  left join cashreceipt_void cv on cv.receiptid = nc.receiptid 
where c.state='DELEGATED' 
   and c.collector_objid = $P{collectorid} 
   and c.subcollector_objid = $P{subcollectorid} 
    and cv.objid is null 
group by nc.refid, nc.refno, nc.refdate, nc.reftype, nc.particulars  

[getCollectionSummaries]
select 
  controlid, formno, startseries, endseries, 
  min(series) as receivedstartseries, endseries as receivedendseries, 
  min(series) as issuedstartseries, max(series) as issuedendseries, 
  case when max(series) >= endseries then null else max(series)+1 end as endingstartseries, 
  case when max(series) >= endseries then null else endseries end as endingendseries, 
  endseries-min(series)+1 as qtyreceived, 
  max(series)-min(series)+1 as qtyissued, 
  case when max(series) >= endseries then 0 else endseries-max(series) end as qtyending, 
  sum(amount) as amount 
from ( 
  select distinct 
    c.objid, c.controlid, c.formno, afc.startseries, afc.endseries, c.series, 
    case when v.objid is null then 1 else 0 end as txncount, 
    case when v.objid is null then 0 else 1 end as voidcount,  
    case when v.objid is null then c.amount else 0.0 end as amount 
  from subcollector_remittance r 
    inner join subcollector_remittance_cashreceipt rc on rc.remittanceid = r.objid 
    inner join cashreceipt c on c.objid = rc.objid 
    inner join af_control afc on afc.objid = c.controlid 
    left join cashreceipt_void v on v.receiptid = c.objid 
  where r.objid = $P{remittanceid} 
)t1 
group by controlid, formno, startseries, endseries  
order by formno, startseries 


[getRemittedChecks]
select 
   nc.refid, nc.refno, nc.particulars, nc.reftype, sum(nc.amount) as amount  
from subcollector_remittance rem 
  inner join subcollector_remittance_cashreceipt remc on rem.objid=remc.remittanceid 
  inner join cashreceiptpayment_noncash nc on remc.objid=nc.receiptid 
where rem.objid=$P{remittanceid} 
  and remc.objid not in ( select receiptid from cashreceipt_void where receiptid=remc.objid ) 
group by nc.refid, nc.refno, nc.particulars, nc.reftype 
