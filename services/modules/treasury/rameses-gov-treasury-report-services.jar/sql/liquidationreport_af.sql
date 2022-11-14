[getRemittedAFs]
select * 
from ( 
	select 
		t2.controlid, t2.afid, t2.formtype, t2.stubno, t2.startseries, t2.endseries, 
		t2.endseries+1 as nextseries, t2.prefix, t2.suffix, t2.denomination, t2.serieslength,
		min(raf.receivedstartseries) as receivedstartseries, max(raf.receivedendseries) as receivedendseries, 
		min(raf.beginstartseries) as beginstartseries, max(raf.beginendseries) as beginendseries, 
		min(t2.issuedstartseries) as issuedstartseries, max(t2.issuedendseries) as issuedendseries, 
		max(raf.endingstartseries) as endingstartseries, max(raf.endingendseries) as endingendseries, 
		max(raf.qtyreceived) as qtyreceived, max(raf.qtybegin) as qtybegin, sum(t2.qtyissued) as qtyissued, 
		min(raf.qtyending) as qtyending, sum(raf.qtycancelled) as qtycancelled   
	from ( 
		select 
			remittanceid, controlid, afid, formtype, stubno, startseries, endseries, prefix, suffix, denomination, serieslength, 
			min(series) as issuedstartseries, max(series) as issuedendseries, count(*) as qtyissued 
		from ( 
			select 
				c.remittanceid, ci.receiptid, c.controlid, c.series, afc.afid, af.formtype, afc.stubno, 
				afc.startseries, afc.endseries, afc.prefix, afc.suffix, af.denomination, af.serieslength 
			from remittance r 
				inner join cashreceipt c on c.remittanceid = r.objid 
				inner join cashreceiptitem ci on ci.receiptid = c.objid 
				inner join af_control afc on afc.objid = c.controlid 
				inner join af on (af.objid = afc.afid and af.formtype = 'serial') 
			where r.collectionvoucherid = $P{collectionvoucherid} 
				and ci.item_fund_objid like $P{fundid}  
			group by 
				c.remittanceid, ci.receiptid, c.controlid, c.series, afc.afid, af.formtype, afc.stubno, 
				afc.startseries, afc.endseries, afc.prefix, afc.suffix, af.denomination, af.serieslength 
		)t1 
		group by remittanceid, controlid, afid, formtype, stubno, startseries, endseries, prefix, suffix, denomination, serieslength 
	)t2 
		inner join remittance_af raf on (raf.remittanceid = t2.remittanceid and raf.controlid = t2.controlid) 
	group by 	
		t2.controlid, t2.afid, t2.formtype, t2.stubno, t2.startseries, t2.endseries, 
		t2.prefix, t2.suffix, t2.denomination, t2.serieslength 

	union all 

	select 
		t2.controlid, t2.afid, t2.formtype, t2.stubno, t2.startseries, t2.endseries, 
		t2.endseries as nextseries, t2.prefix, t2.suffix, t2.denomination, t2.serieslength, 
		null as receivedstartseries, null as receivedendseries, null as beginstartseries, null as beginendseries, 
		null as issuedstartseries, null as issuedendseries, null as endingstartseries, null as endingendseries, 
		max(t2.qtyreceived) as qtyreceived, max(t2.qtybegin) as qtybegin, sum(t2.qtyissued) as qtyissued, min(t2.qtyending) as qtyending, 0 as qtycancelled  
	from ( 
		select 
			t1.remittanceid, t1.controlid, convert(sum(t1.amtissued) / af.denomination, signed) as qtyissued, afc.prefix, 
			afc.afid, af.formtype, afc.stubno, afc.startseries, afc.endseries, af.denomination, af.serieslength, afc.suffix, 
			max(raf.qtyreceived) as qtyreceived, max(raf.qtybegin) as qtybegin, min(raf.qtyending) as qtyending 
		from ( 
			select c.remittanceid, ci.receiptid, ci.objid as receiptitemid, c.controlid, ci.amount as amtissued 
			from remittance r 
				inner join cashreceipt c on c.remittanceid = r.objid 
				inner join cashreceiptitem ci on ci.receiptid = c.objid 
				inner join af_control afc on afc.objid = c.controlid 
				inner join af on (af.objid = afc.afid and af.formtype <> 'serial') 
				left join cashreceipt_void v on v.receiptid = c.objid 
			where r.collectionvoucherid = $P{collectionvoucherid} 
				and ci.item_fund_objid like $P{fundid}  
				and v.objid is null 
			group by c.remittanceid, ci.receiptid, ci.objid, c.controlid, ci.amount 
		)t1 
			inner join remittance_af raf on (raf.remittanceid = t1.remittanceid and raf.controlid = t1.controlid) 
			inner join af_control afc on afc.objid = t1.controlid 
			inner join af on af.objid = afc.afid 
		group by 
			t1.remittanceid, t1.controlid, afc.afid, af.formtype, afc.stubno, afc.prefix,
			afc.startseries, afc.endseries, af.denomination, af.serieslength, afc.suffix 
	)t2 
	group by 
		t2.controlid, t2.afid, t2.formtype, t2.stubno, t2.startseries, t2.endseries, 
		t2.prefix, t2.suffix, t2.denomination, t2.serieslength 
)t3
order by 
	(case when formtype = 'serial' then 0 else 1 end), 
	afid, prefix, suffix, startseries 
