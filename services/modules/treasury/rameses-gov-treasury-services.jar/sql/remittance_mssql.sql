[getOpenChecks]
SELECT refno, receivedfrom, amount, amtused 
FROM checkpayment
WHERE objid IN ( 
   SELECT refid 
   FROM cashreceiptpayment_noncash npc
   INNER JOIN cashreceipt c ON c.objid=npc.receiptid
   LEFT JOIN cashreceipt_void cv ON cv.receiptid = c.objid 
   WHERE c.remittanceid =  $P{remittanceid} AND cv.objid IS NULL
)   
AND (amount - amtused) > 0 

[findInvalidCheck]
select 
	pc.refno, pc.amount, sum(nc.amount) as noncashamount 
from cashreceipt c 
	inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
	inner join checkpayment pc on pc.objid = nc.checkid 
where c.remittanceid = $P{remittanceid} 
	and c.objid not in (select receiptid from cashreceipt_void where receiptid=c.objid) 
group by pc.refno, pc.amount
having (pc.amount-sum(nc.amount)) > 0 

[insertRemittanceFund]
INSERT INTO remittance_fund ( 
	objid, controlno, remittanceid, fund_objid, fund_title, 
	amount, totalcash, totalcheck, totalcr, cashbreakdown 
)
SELECT 
    ( ISNULL( cr.remittanceid, '-' ) + f.objid ), 
    ( ISNULL( r.controlno, '-') + f.code ),
    cr.remittanceid, f.objid, f.title,
    SUM( cri.amount ), 0, 0, 0, '[]' 
FROM cashreceipt cr 
	inner join remittance r ON r.objid = cr.remittanceid 
	inner join cashreceiptitem cri on cri.receiptid = cr.objid 
	inner join fund f ON f.objid = cri.item_fund_objid 
	left join cashreceipt_void cv ON cv.receiptid = cr.objid 
WHERE cr.remittanceid = $P{remittanceid}  
	and cv.objid IS NULL 
	and cr.state <> 'CANCELLED'
GROUP BY 
	( ISNULL( cr.remittanceid, '-' ) + f.objid ), 
	( ISNULL( r.controlno, '-') + f.code ), 
	cr.remittanceid, f.objid, f.code, f.title 


[getCashReceiptsForRemittance]
SELECT 
	( cr.collector_objid + cr.remittanceid + afc.objid ) AS objid, 
	af.formtype, cr.remittanceid, cr.collector_objid, 
	afc.objid AS afcontrolid, afc.stubno, cr.formno,  
	MIN(cr.series) AS fromseries, MAX(cr.series) AS toseries, afc.endseries,
	COUNT(*) AS qty, SUM( CASE WHEN cv.objid IS NULL THEN cr.amount ELSE 0 END ) AS amount  
FROM ( 
	SELECT * FROM cashreceipt 
	WHERE remittanceid IS NULL 
		AND collector_objid = $P{collectorid} 
		AND receiptdate <= $P{remdate} 
)cr 
	INNER JOIN af_control afc ON cr.controlid=afc.objid 
	INNER JOIN af ON afc.afid = af.objid 
	LEFT JOIN cashreceipt_void cv ON cr.objid = cv.receiptid
GROUP BY 
	(cr.collector_objid + cr.remittanceid + afc.objid), 
	af.formtype, cr.remittanceid, cr.collector_objid, 
	afc.objid, afc.stubno, cr.formno, afc.endseries 


[getBuildRemittanceFunds]
select 
	remittanceid, controlno, fund_objid, fund_title, fund_code, 
	sum(amount) as amount, sum(totalcheck) as totalcheck, sum(totalcr) as totalcr, 
	(sum(amount)-sum(totalcheck)-sum(totalcr)) as totalcash 
from ( 
	select 
		c.remittanceid, r.controlno,  
		fund.objid as fund_objid, fund.title as fund_title, fund.code as fund_code, 
		SUM(ci.amount) as amount, 0.0 as totalcash, 0.0 as totalcheck, 0.0 as totalcr
	from remittance r 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptitem ci on ci.receiptid = c.objid 
		inner join fund on fund.objid = ci.item_fund_objid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where r.objid = $P{remittanceid} 
		and v.objid is null 
	group by c.remittanceid, r.controlno, fund.objid, fund.title, fund.code

	union all 

	select 
		c.remittanceid, r.controlno,  
		fund.objid as fund_objid, fund.title as fund_title, fund.code as fund_code, 
		0.0 as amount, 0.0 as totalcash, sum(nc.amount) as totalcheck, 0.0 as totalcr 
	from remittance r 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
		inner join fund on fund.objid = nc.fund_objid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where r.objid = $P{remittanceid} 
		and nc.reftype = 'CHECK'
		and v.objid is null 
	group by c.remittanceid, r.controlno, fund.objid, fund.title, fund.code

	union all 

	select 
		c.remittanceid, r.controlno,  
		fund.objid as fund_objid, fund.title as fund_title, fund.code as fund_code, 
		0.0 as amount, 0.0 as totalcash, 0.0 as totalcheck, sum(nc.amount) as totalcr 
	from remittance r 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
		inner join fund on fund.objid = nc.fund_objid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where r.objid = $P{remittanceid} 
		and nc.reftype <> 'CHECK'
		and v.objid is null 
	group by c.remittanceid, r.controlno, fund.objid, fund.title, fund.code
)t1 
group by remittanceid, controlno, fund_objid, fund_title, fund_code 


[findPrevious]
select top 1 
	r.objid, r.state, r.controlno, r.controldate, r.dtposted, 
	r.collector_objid, r.collector_name, r.amount, r.collectionvoucherid  
from ( 
	select dtposted, collector_objid 
	from remittance 
	where objid = $P{remittanceid} 
		and state in ('OPEN','POSTED') 
)t1, remittance r 
where r.collector_objid = t1.collector_objid 
	and r.dtposted < t1.dtposted 
	and r.state in ('OPEN','POSTED') 
order by r.dtposted desc, r.controldate desc, r.controlno desc 


[findReceiptSummary]
select 
	sum(amount) as amount, 
	sum(voidamount) as voidamount, 
	sum(totalnoncash) as totalnoncash, 
	sum(amount)-sum(totalnoncash) as totalcash,
	sum(amount)-sum(voidamount) as total 
from vw_remittance_cashreceipt 
where remittanceid = $P{remittanceid} 
