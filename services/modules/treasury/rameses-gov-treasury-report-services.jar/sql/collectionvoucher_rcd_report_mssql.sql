[getRemittances]
select 
	remittanceid, collectorname, controlno, controldate, sum(amount) as amount 
from ( 
	select 
		remf.remittanceid, rem.collector_name as collectorname, 
		rem.controlno, convert(date, rem.controldate) as controldate, remf.amount
	from remittance rem 
		inner join remittance_fund remf on remf.remittanceid = rem.objid 
	where rem.collectionvoucherid = $P{collectionvoucherid} 
		and remf.fund_objid like $P{fundid}  
)tmp1 
group by remittanceid, collectorname, controlno, controldate
order by controldate, collectorname, controlno 


[getCollectionSummaries]
select 
	cvf.fund_title as particulars, cvf.amount
from collectionvoucher_fund cvf 
	inner join collectionvoucher cv on cv.objid = cvf.parentid 
	inner join fund on fund.objid = cvf.fund_objid 
where cvf.parentid = $P{collectionvoucherid} 
	and cvf.fund_objid like $P{fundid}  
order by cvf.parentid, fund.code, fund.title  


[getOtherPayments]
select * 
from ( 
	select 
		cp.bank_name, nc.reftype, nc.particulars, 
		sum(nc.amount) as amount, min(nc.refdate) as refdate 
	from remittance rem 
		inner join cashreceipt c on c.remittanceid = rem.objid 
		inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'CHECK') 
		inner join checkpayment cp on cp.objid = nc.refid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where rem.collectionvoucherid = $P{collectionvoucherid} 
		and nc.fund_objid like $P{fundid} 
		and v.objid is null 
	group by cp.bank_name, nc.reftype, nc.particulars 
	union all 
	select 
		ba.bank_name, nc.reftype, nc.particulars, 
		sum(nc.amount) as amount, min(nc.refdate) as refdate 
	from remittance rem 
		inner join cashreceipt c on c.remittanceid = rem.objid 
		inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'EFT') 
		inner join eftpayment e on e.objid = nc.refid 
		inner join bankaccount ba on ba.objid = e.bankacctid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where rem.collectionvoucherid = $P{collectionvoucherid} 
		and nc.fund_objid like $P{fundid} 
		and v.objid is null 
	group by ba.bank_name, nc.reftype, nc.particulars 
)t1 
order by bank_name, refdate, amount 


[getRemittedAFs]
select 
	(case when af.formtype = 'serial' then 0 else 1 end) as formindex, 
	afc.afid, af.formtype, afc.stubno, afc.startseries, afc.endseries, 
	afc.endseries+1 as nextseries, af.denomination, af.serieslength, t1.*, 
	((t1.qtyreceived + t1.qtybegin) - t1.qtyissued) as qtyending, 
	case 
		when ((t1.qtyreceived + t1.qtybegin) - t1.qtyissued) = 0 then null 
		when t1.qtyissued > 0 then t1.issuedendseries+1 
		when t1.qtybegin > 0 then t1.beginstartseries 
		else t1.receivedstartseries 
	end as endingstartseries, 
	case 
		when ((t1.qtyreceived + t1.qtybegin) - t1.qtyissued) = 0 then null 
		when t1.qtybegin > 0 then t1.beginendseries 
		else t1.receivedendseries 
	end as endingendseries 
from ( 
	select raf.controlid, 
		min(raf.receivedstartseries) as receivedstartseries, max(raf.receivedendseries) as receivedendseries, 
		min(raf.beginstartseries) as beginstartseries, max(raf.beginendseries) as beginendseries, 
		min(raf.issuedstartseries) as issuedstartseries, max(raf.issuedendseries) as issuedendseries, 
		case when min(raf.receivedstartseries) > 0 then max(raf.receivedendseries)-min(raf.receivedstartseries)+1 else 0 end as qtyreceived, 
		case when min(raf.beginstartseries) > 0 then max(raf.beginendseries)-min(raf.beginstartseries)+1 else 0 end as qtybegin, 
		case when min(raf.issuedstartseries) > 0 then max(raf.issuedendseries)-min(raf.issuedstartseries)+1 else 0 end as qtyissued  
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join remittance_af raf on raf.remittanceid = r.objid 
	where cv.objid = $P{collectionvoucherid} 
	group by raf.controlid 
)t1
	inner join af_control afc on afc.objid = t1.controlid 
	inner join af on af.objid = afc.afid 
order by 
	(case when af.formtype = 'serial' then 0 else 1 end), 
	afc.afid, afc.prefix, afc.suffix, afc.startseries 
