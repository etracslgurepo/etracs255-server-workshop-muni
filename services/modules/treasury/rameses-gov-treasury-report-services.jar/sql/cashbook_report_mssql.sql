[findBeginBalance]
select 
	convert(decimal(20,4), dr) as dr, 
	convert(decimal(20,4), cr) as cr, 
	convert(decimal(20,4), balance) as balance 
from ( 
	select 
		sum(receipt_amt)-sum(void_amt) as dr, sum(rem_amt)-sum(void_amt) as cr, 
		(sum(receipt_amt)-sum(void_amt)) - (sum(rem_amt)-sum(void_amt)) as balance 
	from ( 
		select 
			sum(ci.amount) as receipt_amt, 
			sum(case 
				when r.objid is null then 0.0 
				when r.controldate < $P{fromdate} then ci.amount 
			end) as rem_amt, 
			sum(case 
				when v.objid is null then 0.0 
				when v.txndate < $P{fromdate} then ci.amount 
			end) as void_amt
		from cashreceipt c 
			inner join cashreceiptitem ci on ci.receiptid = c.objid 
			inner join itemaccount ia on ia.objid = ci.item_objid 
			left join remittance r on (r.objid = c.remittanceid and r.state in ('DRAFT','OPEN','POSTED','CAPTURE'))
			left join cashreceipt_void v on v.receiptid = c.objid 
		where c.receiptdate < $P{fromdate}
			and c.collector_objid = $P{accountid} 
			and c.state in ('POSTED','CAPTURED') 
			and ia.fund_objid in (${fundfilter}) 

		union all 

		select 
			-sum(ci.amount) as receipt_amt, 
			-sum(case 
				when r.objid is null then 0.0 
				when r.controldate < $P{fromdate} then ci.amount 
			end) as rem_amt, 
			-sum(case 
				when v.objid is null then 0.0 
				when v.txndate < $P{fromdate} then ci.amount 
			end) as void_amt
		from cashreceipt c 
			inner join cashreceipt_share ci on ci.receiptid = c.objid 
			inner join itemaccount ia on ia.objid = ci.refitem_objid 
			left join remittance r on (r.objid = c.remittanceid and r.state in ('DRAFT','OPEN','POSTED','CAPTURE'))
			left join cashreceipt_void v on v.receiptid = c.objid 
		where c.receiptdate < $P{fromdate}
			and c.collector_objid = $P{accountid} 
			and c.state in ('POSTED','CAPTURED') 
			and ia.fund_objid in (${fundfilter}) 

		union all 

		select 
			sum(ci.amount) as receipt_amt, 
			sum(case 
				when r.objid is null then 0.0 
				when r.controldate < $P{fromdate} then ci.amount 
			end) as rem_amt, 
			sum(case 
				when v.objid is null then 0.0 
				when v.txndate < $P{fromdate} then ci.amount 
			end) as void_amt
		from cashreceipt c 
			inner join cashreceipt_share ci on ci.receiptid = c.objid 
			inner join itemaccount ia on ia.objid = ci.payableitem_objid 
			left join remittance r on (r.objid = c.remittanceid and r.state in ('DRAFT','OPEN','POSTED','CAPTURE'))
			left join cashreceipt_void v on v.receiptid = c.objid 
		where c.receiptdate < $P{fromdate}
			and c.collector_objid = $P{accountid} 
			and c.state in ('POSTED','CAPTURED') 
			and ia.fund_objid in (${fundfilter}) 
	)t0 
)t1 


[findRevolvingFund]
select 
	year(controldate) as controlyear, 
	month(controldate) as controlmonth, 
	sum(amount) as amount, 
	((year(controldate)*12) + month(controldate)) as indexno 
from cashbook_revolving_fund 
where issueto_objid = $P{accountid} 
	and controldate <= $P{fromdate} 
	and fund_objid in (${fundfilter})
	and state = 'POSTED' 
group by year(controldate), month(controldate), ((year(controldate)*12) + month(controldate)) 
order by ((year(controldate)*12) + month(controldate)) desc 


[getDetails]
select 
	refdate, refno, reftype, sortdate, sortindex, 
	convert(decimal(20,4), sum(dr)) as dr, convert(decimal(20,4), sum(cr)) as cr, 
	convert(decimal(20,4), sum(adr)) as adr, convert(decimal(20,4), sum(acr)) as acr 
from (
    select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sum(dr) as adr, sum(cr) as acr, sortdate, 0 as sortindex  
    from ( 
        select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, txndate as sortdate 
        from vw_cashbook_cashreceipt 
        where refdate >= $P{fromdate} 
            and refdate <  $P{todate} 
            and collectorid = $P{accountid} 
            and fundid in (${fundfilter})
            and state in ('POSTED','CAPTURED') 
		group by refdate, refno, reftype, txndate 
        union all 
        select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, txndate as sortdate 
        from vw_cashbook_cashreceipt_share  
        where refdate >= $P{fromdate} 
            and refdate <  $P{todate} 
            and collectorid = $P{accountid} 
            and fundid in (${fundfilter})
            and state in ('POSTED','CAPTURED') 
		group by refdate, refno, reftype, txndate
        union all 
        select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, txndate as sortdate 
        from vw_cashbook_cashreceipt_share_payable  
        where refdate >= $P{fromdate} 
            and refdate <  $P{todate} 
            and collectorid = $P{accountid} 
            and fundid in (${fundfilter})
            and state in ('POSTED','CAPTURED') 
		group by refdate, refno, reftype, txndate
    )t0 
    group by refdate, refno, reftype, sortdate 

    union all 

    select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sum(dr) as adr, sum(cr) as acr, sortdate, 2 as sortindex 
    from ( 
        select 
			refdate, (case when state='DRAFT' then '-- Draft Remittance --' else refno end) as refno, 
			reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
        from vw_cashbook_remittance 
        where refdate >= $P{fromdate} 
            and refdate <  $P{todate} 
            and collectorid = $P{accountid} 
            and fundid in (${fundfilter}) 
            and state in ('DRAFT','OPEN','POSTED','CAPTURE')
        group by refdate, (case when state='DRAFT' then '-- Draft Remittance --' else refno end), reftype, sortdate 
        union all 
        select 
            refdate, (case when state='DRAFT' then '-- Draft Remittance --' else refno end) as refno, 
            reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
        from vw_cashbook_remittance_share 
        where refdate >= $P{fromdate} 
            and refdate <  $P{todate} 
            and collectorid = $P{accountid} 
            and fundid in (${fundfilter}) 
            and state in ('DRAFT','OPEN','POSTED','CAPTURE')
        group by refdate, (case when state='DRAFT' then '-- Draft Remittance --' else refno end), reftype, sortdate 
        union all 
        select 
            refdate, (case when state='DRAFT' then '-- Draft Remittance --' else refno end) as refno, 
            reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
        from vw_cashbook_remittance_share_payable 
        where refdate >= $P{fromdate} 
            and refdate <  $P{todate} 
            and collectorid = $P{accountid} 
            and fundid in (${fundfilter}) 
            and state in ('DRAFT','OPEN','POSTED','CAPTURE')
        group by refdate, (case when state='DRAFT' then '-- Draft Remittance --' else refno end), reftype, sortdate 
    )t0 
    group by refdate, refno, reftype, sortdate 

	union all 

	select refdate, refno, 
		(case when sortindex >= 3 then 'void-remitted-receipt' else reftype end) as reftype, 
		sum(dr) as dr, sum(cr) as cr, sum(adr) as adr, sum(acr) as acr, sortdate, sortindex  
	from ( 
		select 
			refdate, refno, reftype, sortdate, sum(dr) as dr, sum(cr) as cr, 
			(case when receiptdate <= txndate then sum(dr) else null end) as adr, 
			(case when txndate > remittancedtposted then sum(cr) else null end) as acr, 
			(case when txndate <= isnull(remittancedtposted, txndate) then 1 else 3 end) as sortindex 
		from vw_cashbook_cashreceiptvoid  
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and state in ('POSTED','CAPTURED')
		group by refdate, refno, reftype, sortdate, receiptdate, txndate, remittancedtposted
		union all 
		select 
			refdate, refno, reftype, sortdate, sum(dr) as dr, sum(cr) as cr, 
			(case when receiptdate <= txndate then sum(dr) else null end) as adr, 
			(case when txndate > remittancedtposted then sum(cr) else null end) as acr, 
			(case when txndate <= isnull(remittancedtposted, txndate) then 1 else 3 end) as sortindex 
		from vw_cashbook_cashreceiptvoid_share  
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and state in ('POSTED','CAPTURED')
		group by refdate, refno, reftype, sortdate, receiptdate, txndate, remittancedtposted
		union all 
		select 
			refdate, refno, reftype, sortdate, sum(dr) as dr, sum(cr) as cr, 
			(case when receiptdate <= txndate then sum(dr) else null end) as adr, 
			(case when txndate > remittancedtposted then sum(cr) else null end) as acr, 
			(case when txndate <= isnull(remittancedtposted, txndate) then 1 else 3 end) as sortindex 
		from vw_cashbook_cashreceiptvoid_share_payable  
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and state in ('POSTED','CAPTURED')
		group by refdate, refno, reftype, sortdate, receiptdate, txndate, remittancedtposted
	)t0 
	group by refdate, refno, reftype, sortdate, sortindex  
)t1 
group by refdate, refno, reftype, sortdate, sortindex 
order by refdate, sortdate, sortindex, refno  


[getSummaries]
select 
	refdate, groupdate, groupindex, grouprefno, groupid, particulars, refno, min(sortdate) as sortdate, 
	convert(decimal(20,4), sum(dr)) as dr, convert(decimal(20,4), sum(cr)) as cr, 
	convert(decimal(20,4), sum(adr)) as adr, convert(decimal(20,4), sum(acr)) as acr 
from ( 
	select 
		groupid, groupdate, grouprefno, controlid, formno, formtype, min(sortdate) as sortdate, 
		min(refdate) as refdate, min(series) as minseries, max(series) as maxseries, 
		(case when formno = '51' then 'VARIOUS TAXES AND FEES' else af_title end) as particulars, 
		('AF '+ formno +  
			(case 
				when formtype = 'cashticket' then (' - '+ af_title) 
				else ('#'+ convert(varchar, min(refno)) +'-'+ convert(varchar, max(refno))) 
			end)
		) as refno, 
		sum(dr) as dr, sum(cr) as cr, sum(dr) as adr, sum(cr) as acr, 0 as groupindex 
	from ( 
		select 
			c.refdate, c.controlid, c.formno, c.series, af.formtype, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, c.remittanceid as groupid, 
			isnull(c.remittancedtposted, c.receiptdate) as groupdate, c.formno as grouprefno  
		from vw_cashbook_cashreceipt c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('POSTED','CAPTURED')
		union all 
		select 
			c.refdate, c.controlid, c.formno, c.series, af.formtype, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, c.remittanceid as groupid, 
			isnull(c.remittancedtposted, c.receiptdate) as groupdate, c.formno as grouprefno  
		from vw_cashbook_cashreceipt_share c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('POSTED','CAPTURED')
		union all 
		select 
			c.refdate, c.controlid, c.formno, c.series, af.formtype, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, c.remittanceid as groupid, 
			isnull(c.remittancedtposted, c.receiptdate) as groupdate, c.formno as grouprefno  
		from vw_cashbook_cashreceipt_share_payable c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('POSTED','CAPTURED')
	)t0 
	group by groupid, groupdate, grouprefno, controlid, formno, formtype, af_title 

	union all 

	select 
		groupid, groupdate, grouprefno, null as controlid, null as formno, null as formtype, 
		min(sortdate) as sortdate, refdate, null as minseries, null as maxseries, 
		particulars, refno, sum(dr) as dr, sum(cr) as cr, sum(dr) as adr, sum(cr) as acr, 2 as groupindex  
	from ( 
		select 
			c.refdate, c.refno, c.dr, c.cr, c.sortdate, c.refid as groupid, 
			isnull(c.txndate, c.refdate) as groupdate, c.refno as grouprefno, 
			(case 
				when state='DRAFT' then '-- Draft Remittance --' 
				else ('REMITTANCE - '+ c.liquidatingofficer_name) 
			end) as particulars 
		from vw_cashbook_remittance c  
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('DRAFT','OPEN','POSTED','CAPTURE') 
		union all 
		select 
			c.refdate, c.refno, c.dr, c.cr, c.sortdate, c.refid as groupid, 
			isnull(c.txndate, c.refdate) as groupdate, c.refno as grouprefno, 
			(case 
				when state='DRAFT' then '-- Draft Remittance --' 
				else ('REMITTANCE - '+ c.liquidatingofficer_name) 
			end) as particulars 
		from vw_cashbook_remittance_share c  
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('DRAFT','OPEN','POSTED','CAPTURE') 
		union all 
		select 
			c.refdate, c.refno, c.dr, c.cr, c.sortdate, c.refid as groupid, 
			isnull(c.txndate, c.refdate) as groupdate, c.refno as grouprefno, 
			(case 
				when state='DRAFT' then '-- Draft Remittance --' 
				else ('REMITTANCE - '+ c.liquidatingofficer_name) 
			end) as particulars 
		from vw_cashbook_remittance_share_payable c  
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('DRAFT','OPEN','POSTED','CAPTURE') 
	)t0 
	group by groupid, groupdate, grouprefno, refdate, particulars, refno  

	union all 

	select 
		groupid, groupdate, grouprefno, controlid, formno, formtype, min(sortdate) as sortdate, 
		min(refdate) as refdate, min(series) as minseries, max(series) as maxseries, 
		(case when formno = '51' then 'VARIOUS TAXES AND FEES' else af_title end) as particulars, 
		('*** VOIDED - AF '+ formno +'#'+ refno +' ***') as refno, 
		sum(dr) as dr, sum(cr) as cr, sum(adr) as adr, sum(acr) as acr, groupindex  
	from ( 
		select 
			c.refdate, c.refid as controlid, c.formno, af.formtype, c.series, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, 
			c.refid as groupid, c.txndate as groupdate, c.formno as grouprefno,  
			(case when c.receiptdate <= c.txndate then dr else null end) as adr, 
			(case when c.txndate > c.remittancedtposted then cr else null end) as acr, 
			(case when c.txndate <= isnull(c.remittancedtposted, c.txndate) then 1 else 3 end) as groupindex 
		from vw_cashbook_cashreceiptvoid c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('POSTED','CAPTURED') 
		union all 
		select 
			c.refdate, c.refid as controlid, c.formno, af.formtype, c.series, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, 
			c.refid as groupid, c.txndate as groupdate, c.formno as grouprefno,  
			(case when c.receiptdate <= c.txndate then dr else null end) as adr, 
			(case when c.txndate > c.remittancedtposted then cr else null end) as acr, 
			(case when c.txndate <= isnull(c.remittancedtposted, c.txndate) then 1 else 3 end) as groupindex 
		from vw_cashbook_cashreceiptvoid_share c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('POSTED','CAPTURED') 
		union all 
		select 
			c.refdate, c.refid as controlid, c.formno, af.formtype, c.series, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, 
			c.refid as groupid, c.txndate as groupdate, c.formno as grouprefno,  
			(case when c.receiptdate <= c.txndate then dr else null end) as adr, 
			(case when c.txndate > c.remittancedtposted then cr else null end) as acr, 
			(case when c.txndate <= isnull(c.remittancedtposted, c.txndate) then 1 else 3 end) as groupindex 
		from vw_cashbook_cashreceiptvoid_share_payable c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and c.state in ('POSTED','CAPTURED') 
	)t0
  group by 
		groupid, groupdate, groupindex, grouprefno, controlid, formno, formtype, refno, 
		(case when formno = '51' then 'VARIOUS TAXES AND FEES' else af_title end) 

)t1 
group by groupid, groupdate, groupindex, grouprefno, refdate, particulars, refno 
order by refdate, groupdate, groupindex, grouprefno, min(sortdate) 
