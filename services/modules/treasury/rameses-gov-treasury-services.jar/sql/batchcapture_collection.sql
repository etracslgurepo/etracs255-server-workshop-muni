[findBatchControlByState]
select objid from batchcapture_collection 
where controlid=$P{controlid} and state NOT IN ('POSTED','CLOSED')

[post]	
update batchcapture_collection set 
	state=$P{state}, 
	postedby_objid=$P{postedby_objid},
	postedby_name=$P{postedby_name},
	postedby_date=$P{postedby_date}
where objid=$P{objid}

[getList]
select 
	bcc.objid, bcc.txndate, bcc.state, bcc.formno, 
	bcc.startseries, bcc.endseries, bcc.totalamount, 
	bcc.collector_name as collectorname, 
	bcc.capturedby_name as capturedbyname
from ( 
	select objid as batchid 
	from batchcapture_collection 
	where collector_name like $P{searchtext} 
	union 
	select objid as batchid 
	from batchcapture_collection 
	where capturedby_name like $P{searchtext} 
	union 
	select objid as batchid 
	from batchcapture_collection 
	where txndate like $P{searchtext} 
	union 
	select objid as batchid 
	from batchcapture_collection 
	where startseries like $P{searchtext} 
	union 
	select objid as batchid 
	from batchcapture_collection 
	where endseries like $P{searchtext} 
)xxa 
	inner join batchcapture_collection bcc on bcc.objid=xxa.batchid 
where 1=1 ${filter} 
order by bcc.txndate desc 

[getBatchEntryItems]
select bcei.*, 
	case 
		when cta.account_objid is null then ia.valuetype 
		else cta.valuetype 
	end as valuetype 
from batchcapture_collection_entry bce 
	inner join batchcapture_collection_entry_item bcei on bce.objid=bcei.parentid 
	inner join batchcapture_collection bc on bce.parentid=bc.objid 
	inner join itemaccount ia on bcei.item_objid = ia.objid 
	left join collectiontype_account cta on (bcei.item_objid=cta.account_objid and cta.collectiontypeid=bc.collectiontype_objid)
where bce.objid=$P{objid} 

#
# added scripts 
#
[findBatchSummary]
select 
	sum(case when voided > 0 then 0.0 else totalcash end) as totalcash, 
	sum(case when voided > 0 then 0.0 else totalnoncash end) as totalnoncash, 
	sum(case when voided > 0 then 0.0 else amount end) as totalamount 
from batchcapture_collection_entry 
where parentid=$P{objid} 


[updateBatchSummary]
update batchcapture_collection set 
	totalamount = $P{totalamount}, 
	totalcash = $P{totalcash}, 
	totalnoncash = $P{totalnoncash} 
where 
	objid=$P{objid}


[findRemitCount]
select bcc.objid, count(bcce.objid) as remitcount   
from batchcapture_collection bcc 
	inner join batchcapture_collection_entry bcce on bcc.objid=bcce.parentid 
where bcc.objid=$P{batchid} and bcc.state='POSTED' 
	and bcce.objid in ( select objid from cashreceipt where objid=bcce.objid and remittanceid is not null) 
group by bcc.objid 

[getAFHistory]
select 
	objid, controlid, min(series) as minseries, max(series) as maxseries, count(*) as txncount, 
	(case when sum(remitted)>0 then 1 else 0 end) as hasremittance 
from ( 
	select 
		bcc2.objid, bcc2.controlid, bcce2.series, 
		(select count(*) from cashreceipt where objid=bcce2.objid and remittanceid is not null) as remitted 
	from ( 
		select 
			bcc.objid, bcc.controlid, 
			min(bcce.series) as minseries,
			max(bcce.series) as maxseries 
		from batchcapture_collection_entry bcce 
			inner join batchcapture_collection bcc on bcce.parentid=bcc.objid 
		where bcce.parentid=$P{batchid} 
		group by bcc.objid, bcc.controlid 
	)xxa 
		inner join batchcapture_collection bcc2 on bcc2.controlid=xxa.controlid 
		inner join batchcapture_collection_entry bcce2 on bcc2.objid=bcce2.parentid  
	where bcce2.series >= xxa.minseries 
		and bcc2.state in ('POSTED','CLOSED') 
)xxb 
group by objid, controlid 
order by min(series) 

[getForPostingSummary]
select 
	bcc2.objid, bcc2.controlid, 
	min(bcce2.series) as minseries, 
	max(bcce2.series) as maxseries, 
	count(bcc2.objid) as txncount 
from ( 
	select 
		bcc.objid, bcc.controlid, 
		max(bcce.series) as maxseries 
	from batchcapture_collection bcc 
		inner join batchcapture_collection_entry bcce on bcc.objid=bcce.parentid 
	where bcc.objid=$P{batchid}  
	group by bcc.objid, bcc.controlid 
)xxa 
	inner join batchcapture_collection bcc2 on bcc2.controlid=xxa.controlid 
	inner join batchcapture_collection_entry bcce2 on bcc2.objid=bcce2.parentid 
where bcc2.state='FORPOSTING' 
	and bcce2.series <= xxa.maxseries 
group by bcc2.objid, bcc2.controlid 
order by min(bcce2.series) 

[getPostedSummary]
select 
	bcc2.objid, bcc2.controlid, 
	min(bcce2.series) as minseries, 
	max(bcce2.series) as maxseries, 
	count(bcc2.objid) as txncount 
from ( 
	select 
		bcc.objid, bcc.controlid, 
		max(bcce.series) as maxseries 
	from batchcapture_collection bcc 
		inner join batchcapture_collection_entry bcce on bcc.objid=bcce.parentid 
	where bcc.objid=$P{batchid} 
	group by bcc.objid, bcc.controlid 
)xxa 
	inner join batchcapture_collection bcc2 on bcc2.controlid=xxa.controlid 
	inner join batchcapture_collection_entry bcce2 on bcc2.objid=bcce2.parentid 
where bcc2.state='POSTED' 
	and bcce2.series <= xxa.maxseries 
group by bcc2.objid, bcc2.controlid 
order by min(bcce2.series) 

[findMaxReceiptDate]
select bcc.controlid, max(bcce.receiptdate) as maxreceiptdate 
from batchcapture_collection bcc 
	inner join batchcapture_collection_entry bcce on bcc.objid=bcce.parentid 
where bcc.controlid=$P{controlid} 
group by bcc.controlid 
