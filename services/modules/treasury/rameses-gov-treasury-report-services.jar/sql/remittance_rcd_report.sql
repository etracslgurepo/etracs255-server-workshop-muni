[getCollectionTypes]
select 
	c.formtypeindexno, c.formno, c.formtype, c.controlid, c.stubno, 
	min(c.series) as minseries, max(c.series) as maxseries, 
	case when c.formtype = 'serial' then min(c.receiptno) else null end as fromseries, 
	case when c.formtype = 'serial' then max(c.receiptno) else null end as toseries,
	sum(c.amount) - sum(c.voidamount) as amount 
from vw_remittance_cashreceipt c 
where c.remittanceid = $P{remittanceid} 
group by c.formtypeindexno, c.formno, c.formtype, c.controlid, c.stubno 
order by c.formtypeindexno, c.formno, min(c.series) 


[getCollectionSummaries]
select 
	t1.formindex, t1.formno, t1.collectiontype_objid, t1.collectiontypetitle, 
	t1.fundid, fund.title as fundtitle, sum(t1.amount) as amount 
from ( 
	select 
		ci.formtypeindex as formindex, ci.formno, 
		ci.collectiontype_objid, ci.collectiontype_name as collectiontypetitle, 
		sum(ci.amount) as amount, ci.fundid 
	from vw_remittance_cashreceiptitem ci 
	where ci.remittanceid = $P{remittanceid} 
	group by ci.formtypeindex, ci.formno, ci.collectiontype_objid, ci.collectiontype_name, ci.fundid 
	union all 
	select 
		ci.formtypeindex as formindex, ci.formno, 
		ci.collectiontype_objid, ci.collectiontype_name as collectiontypetitle,
		-sum(ci.amount) as amount, ia.fund_objid as fundid    
	from vw_remittance_cashreceiptshare ci 
		inner join itemaccount ia on ia.objid = ci.refacctid 
	where ci.remittanceid = $P{remittanceid} 
	group by ci.formtypeindex, ci.formno, ci.collectiontype_objid, ci.collectiontype_name, ia.fund_objid  
	union all 
	select 
		ci.formtypeindex as formindex, ci.formno, 
		ci.collectiontype_objid, ci.collectiontype_name as collectiontypetitle,
		sum(ci.amount) as amount, ci.fundid 
	from vw_remittance_cashreceiptshare ci 
	where ci.remittanceid = $P{remittanceid} 
	group by ci.formtypeindex, ci.formno, ci.collectiontype_objid, ci.collectiontype_name, ci.fundid  
)t1, fund 
where fund.objid = t1.fundid 
group by t1.formindex, t1.formno, t1.collectiontype_objid, t1.collectiontypetitle, t1.fundid, fund.title 
order by t1.formindex, t1.formno, t1.collectiontypetitle 


[getOtherPayments]
select * from ( 
	select 
		reftype, bankid, bank_name, particulars, 
		sum(amount)-sum(voidamount) as amount, min(refdate) as refdate 
	from vw_remittance_cashreceiptpayment_noncash 
	where remittanceid = $P{remittanceid} 
		and voided = 0 
	group by reftype, bankid, bank_name, particulars 
)t1 
where amount > 0 
order by bank_name, refdate, amount 


[getRemittedAFs]
select tmp1.* 
from ( 
	select remaf.*, 
		af.formtype, afc.afid as formno, af.serieslength, af.denomination, afc.stubno, 
		afc.prefix, afc.suffix, afc.startseries, afc.endseries, afc.endseries+1 as nextseries, 
		(case when af.formtype = 'serial' then 0 else 1 end) as formindex 
	from remittance_af remaf 
		inner join af_control afc on afc.objid = remaf.controlid 
		inner join af on af.objid = afc.afid 
	where remaf.remittanceid = $P{remittanceid} 
)tmp1
order by tmp1.formindex, tmp1.formno, tmp1.startseries 
