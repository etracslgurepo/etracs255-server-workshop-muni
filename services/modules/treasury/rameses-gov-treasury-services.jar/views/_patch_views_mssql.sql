if object_id('dbo.cashreceipt_af_summary', 'V') is not null 
	drop view dbo.cashreceipt_af_summary 

go 

create view dbo.cashreceipt_af_summary as 
select 
	(cr.collector_objid + cr.remittanceid + afc.objid) as objid, 
	cr.collector_objid, cr.remittanceid, afc.objid as afcontrolid, 
	af.formtype, afc.stubno, cr.formno, afc.endseries, 
	min(cr.series) as fromseries, max(cr.series) as toseries, count(*) AS qty, 
	sum( case when cv.objid is null then cr.amount else 0 end) as amount  
from cashreceipt cr
	inner join af_control afc ON cr.controlid=afc.objid 
	inner join af ON afc.afid = af.objid 
	left join cashreceipt_void cv ON cr.objid = cv.receiptid
group by 
	cr.collector_objid, cr.remittanceid, afc.objid, 
	af.formtype, afc.stubno, cr.formno, afc.endseries 

go 


if object_id('dbo.cashreceipt_fund_summary', 'V') is not null 
	drop view dbo.cashreceipt_fund_summary 

go 

create view dbo.cashreceipt_fund_summary AS 
SELECT 
    ( ISNULL( cr.remittanceid, '-' ) + f.objid ) AS objid, 
    ( ISNULL( r.controlno, '-') + f.code ) AS controlno,
    cr.remittanceid, f.objid AS fund_objid, 
    f.code AS fund_code, f.title AS fund_title,
    SUM( cri.amount ) AS amount    
FROM cashreceiptitem cri 
	INNER JOIN cashreceipt cr ON cri.receiptid=cr.objid
	LEFT JOIN cashreceipt_void cv ON cv.receiptid = cr.objid 
	LEFT JOIN remittance r ON cr.remittanceid = r.objid 
	INNER JOIN fund f ON cri.item_fund_objid = f.objid 
WHERE cv.objid IS NULL AND cr.state <> 'CANCELLED'
GROUP BY cr.remittanceid, f.objid, r.controlno, f.code, f.title  

go 


if object_id('dbo.vw_af_control_detail', 'V') is not null 
	drop view dbo.vw_af_control_detail 

go 

CREATE VIEW dbo.vw_af_control_detail AS 
SELECT 
	afd.*, 
	afc.afid, afc.unit, af.formtype, af.denomination, af.serieslength, 
	afu.qty, afu.saleprice, afc.stubno, afc.prefix, afc.suffix, afc.cost, afc.state AS controlstate, afc.batchno, 
	afc.startseries, afc.endseries, afc.currentseries,
	(afc.endseries-afc.currentseries+1) AS qtybalance,	
	CASE 
		WHEN afd.issuedstartseries IS NOT NULL THEN afd.issuedstartseries 
		WHEN afd.beginstartseries IS NOT NULL THEN afd.beginstartseries 
		WHEN afd.receivedstartseries IS NOT NULL THEN afd.receivedstartseries 
		WHEN afd.endingstartseries IS NOT NULL THEN afd.endingstartseries 
	END AS _startseries, 
	CASE 
		WHEN afd.issuedstartseries IS NOT NULL THEN afd.issuedendseries 
		WHEN afd.beginstartseries IS NOT NULL THEN afd.beginendseries 
		WHEN afd.receivedstartseries IS NOT NULL THEN afd.receivedendseries 
		WHEN afd.endingstartseries IS NOT NULL THEN afd.endingendseries 
	END AS _endseries  	
FROM af_control_detail afd 
	INNER JOIN af_control afc ON afc.objid = afd.controlid 
	INNER JOIN af ON af.objid = afc.afid 
	INNER JOIN afunit afu ON (afu.itemid=af.objid AND afu.unit=afc.unit) 

go 


if object_id('dbo.vw_afunit', 'V') is not null 
	drop view dbo.vw_afunit 

go 

create view dbo.vw_afunit  as 
select 
	u.objid, af.title, af.usetype, af.serieslength, af.system, af.denomination, 
	af.formtype, u.itemid, u.unit, u.qty, u.saleprice  
from afunit u 
	inner join af on af.objid = u.itemid  

go 


if object_id('dbo.vw_remittance_cashreceipt_af', 'V') is not null 
	drop view dbo.vw_remittance_cashreceipt_af 

go 

create view dbo.vw_remittance_cashreceipt_af as 
select 
	cr.remittanceid, cr.collector_objid, cr.controlid, 
	min(cr.receiptno) as fromreceiptno, max(cr.receiptno) as toreceiptno, 
	min(cr.series) as fromseries, max(cr.series) as toseries, 
	count(cr.objid) as qty, sum(cr.amount) as amount, 
	0 as qtyvoided, 0.0 as voidamt, 
	0 as qtycancelled, 0.0 as cancelledamt, 
	af.formtype, af.serieslength, af.denomination, 
	cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  
from cashreceipt cr
	inner join remittance rem on rem.objid = cr.remittanceid 
	inner join af_control afc ON cr.controlid=afc.objid 
	inner join af ON afc.afid = af.objid 
group by 
	cr.remittanceid, cr.collector_objid, cr.controlid, 
	af.formtype, af.serieslength, af.denomination, 
	cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  

union all 

select 
	cr.remittanceid, cr.collector_objid, cr.controlid, 
	null as fromreceiptno, null as toreceiptno, 
	null as fromseries, null as toseries, 
	0 as qty, 0.0 as amount, 
	count(cr.objid) as qtyvoided, sum(cr.amount) as voidamt, 
	0 as qtycancelled, 0.0 as cancelledamt, 
	af.formtype, af.serieslength, af.denomination, 
	cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  
from cashreceipt cr 
	inner join cashreceipt_void cv on cv.receiptid = cr.objid 
	inner join remittance rem on rem.objid = cr.remittanceid 
	inner join af_control afc ON cr.controlid=afc.objid 
	inner join af ON afc.afid = af.objid 
group by 
	cr.remittanceid, cr.collector_objid, cr.controlid, 
	af.formtype, af.serieslength, af.denomination, 
	cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  

union all 

select 
	cr.remittanceid, cr.collector_objid, cr.controlid, 
	null as fromreceiptno, null as toreceiptno, 
	null as fromseries, null as toseries, 
	0 as qty, 0.0 as amount, 0 as qtyvoided, 0.0 as voidamt, 
	count(cr.objid) as qtycancelled, sum(cr.amount) as cancelledamt, 
	af.formtype, af.serieslength, af.denomination, 
	cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  
from cashreceipt cr 
	inner join remittance rem on rem.objid = cr.remittanceid 
	inner join af_control afc ON cr.controlid=afc.objid 
	inner join af ON afc.afid = af.objid 
where cr.state = 'CANCELLED' 
group by 
	cr.remittanceid, cr.collector_objid, cr.controlid, 
	af.formtype, af.serieslength, af.denomination, 
	cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  

go 


if object_id('dbo.vw_remittance_cashreceipt_afsummary', 'V') is not null 
	drop view dbo.vw_remittance_cashreceipt_afsummary 

go 

create view dbo.vw_remittance_cashreceipt_afsummary as 
select 
	(remittanceid + collector_objid + controlid) as objid, 
	remittanceid, collector_objid, controlid, 
	min(fromreceiptno) as fromreceiptno, max(toreceiptno) as toreceiptno, 
	min(fromseries) as fromseries, max(toseries) as toseries, 
	sum(qty) as qty, sum(amount) as amount, 
	sum(qtyvoided) as qtyvoided, sum(voidamt) as voidamt, 
	sum(qtycancelled) as qtycancelled, sum(cancelledamt) as cancelledamt, 
	formtype, serieslength, denomination, formno, stubno, 
	startseries, endseries, prefix, suffix 
from vw_remittance_cashreceipt_af 
group by 
	remittanceid, collector_objid, controlid, 
	formtype, serieslength, denomination, formno, stubno, 
	startseries, endseries, prefix, suffix 

go 



create view vw_collectiontype_org as 
select 
	c.objid, c.state, c.name, c.title, c.formno, c.handler, c.allowbatch, 
	c.barcodekey, c.allowonline, c.allowoffline, c.sortorder, o.org_objid, 
	o.org_name, c.fund_objid, c.fund_title, c.category, c.queuesection 
from collectiontype_org o 
	inner join collectiontype c on c.objid = o.collectiontypeid 
go

