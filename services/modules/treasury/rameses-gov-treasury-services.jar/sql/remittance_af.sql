[getBuildAFs]
select 
    remittanceid, controlid, formno, formtype, formtitle, unit, serieslength, 
    denomination, stubno, startseries, endseries, nextseries, prefix, suffix, 
    receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
    (case 
        when formtype='serial' then issuedstartseries 
        when qtyissued > 0 and qtybegin > 0 then beginstartseries 
        when qtyissued > 0 and qtyreceived > 0 then receivedstartseries 
        else null 
    end) as issuedstartseries, 
    (case 
        when formtype='serial' then issuedendseries 
        when qtyissued > 0 and qtybegin > 0 then (beginstartseries + qtyissued)-1 
        when qtyissued > 0 and qtyreceived > 0 then (receivedstartseries + qtyissued)-1  
        else null 
    end) as issuedendseries, 
    (case 
        when formtype='serial' then endingstartseries 
        when qtybegin > 0 and (qtybegin-qtyissued) > 0 then (beginstartseries + qtyissued)
        when qtyreceived > 0 and (qtyreceived-qtyissued) > 0 then (receivedstartseries + qtyissued)  
        else null 
    end) as endingstartseries, 
    (case 
        when formtype='serial' then endingendseries 
        when qtybegin > 0 and (qtybegin-qtyissued) > 0 then beginendseries 
        when qtyreceived > 0 and (qtyreceived-qtyissued) > 0 then receivedendseries  
        else null 
    end) as endingendseries, 
    qtyreceived, qtybegin, qtyissued, 
    (case 
        when formtype='serial' then qtyending 
        when qtybegin > 0 and (qtybegin-qtyissued) > 0 then qtybegin-qtyissued 
        when qtyreceived > 0 and (qtyreceived-qtyissued) > 0 then qtyreceived-qtyissued 
        else 0 
    end) as qtyending 
from ( 
    select 
        tt2.remittanceid, tt2.controlid, afc.afid as formno, af.formtype, af.title as formtitle, 
        afc.unit, af.serieslength, af.denomination, afc.stubno, afc.startseries, afc.endseries, 
        afc.endseries+1 as nextseries, afc.prefix, afc.suffix, 
        tt2.receivedstartseries, tt2.receivedendseries, tt2.beginstartseries, tt2.beginendseries, 
        tt2.issuedstartseries, tt2.issuedendseries, tt2.qtyissued, tt2.qtyreceived, tt2.qtybegin, 
        case 
            when tt2.qtyissued > 0 then (case when tt2.issuedendseries+1 > afc.endseries then null else tt2.issuedendseries+1 end) 
            when tt2.qtybegin > 0 then tt2.beginstartseries 
            when tt2.qtyreceived > 0 then tt2.receivedstartseries 
            else null 
        end as endingstartseries, 
        case 
            when tt2.qtyissued > 0 then (case when tt2.issuedendseries+1 > afc.endseries then null else afc.endseries end) 
            when tt2.qtybegin > 0 then afc.endseries 
            when tt2.qtyreceived > 0 then afc.endseries 
            else null 
        end as endingendseries, 
        case 
            when tt2.qtyissued > 0 then 
                (case when tt2.issuedendseries+1 > afc.endseries then null else (afc.endseries-(tt2.issuedendseries+1)+1) end) 
            when tt2.qtybegin > 0 then tt2.qtybegin
            when tt2.qtyreceived > 0 then tt2.qtyreceived 
            else 0  
        end as qtyending  
    from ( 

        select 
            t0.remittanceid, t0.controlid, t0.receivedstartseries, t0.receivedendseries, t0.qtyreceived, 
            t0.beginstartseries, t0.beginendseries, t0.qtybegin, t0.issuedstartseries, 
            (t0.issuedendseries + (case when afu.`interval` > 1 then afu.`interval`-1 else 0 end)) as issuedendseries, 
            (t0.qtyissued * (case when afu.`interval` > 1 then afu.`interval` else 1 end)) as qtyissued  
        from ( 
            select tt1.remittanceid, tt1.controlid, 
                    min(tt1.receivedstartseries) as receivedstartseries, max(tt1.receivedendseries) as receivedendseries, max(tt1.qtyreceived) as qtyreceived, 
                    min(tt1.beginstartseries) as beginstartseries, max(tt1.beginendseries) as beginendseries, max(tt1.qtybegin) as qtybegin, 
                    min(tt1.issuedstartseries) as issuedstartseries, max(tt1.issuedendseries) as issuedendseries, max(tt1.qtyissued) as qtyissued  
            from ( 
                    select t1.remittanceid, t1.controlid, 
                            (case 
                                    when convert(d.txndate, date) = t1.remittancedate and d.qtyissued > 0 then null 
                                    when convert(d.txndate, date) = t1.remittancedate and d.qtyreceived > 0 then d.receivedstartseries 
                                    else null 
                            end) as receivedstartseries, 
                            (case 
                                    when convert(d.txndate, date) = t1.remittancedate and d.qtyissued > 0 then null 
                                    when convert(d.txndate, date) = t1.remittancedate and d.qtyreceived > 0 then d.receivedendseries 
                                    else null 
                            end) as receivedendseries, 
                            (case 
                                    when convert(d.txndate, date) = t1.remittancedate and d.qtyissued > 0 then 0
                                    when convert(d.txndate, date) = t1.remittancedate and d.qtyreceived > 0 then d.qtyreceived 
                                    else 0 
                            end) as qtyreceived, 
                            (case 
                                    when d.qtyissued > 0 then d.endingstartseries 
                                    when convert(d.txndate, date) <> t1.remittancedate then d.endingstartseries 
                                    when d.qtybegin > 0 then d.endingstartseries else null 
                            end) as beginstartseries, 
                            (case 
                                    when d.qtyissued > 0 then d.endingendseries 
                                    when convert(d.txndate, date) <> t1.remittancedate then d.endingendseries 
                                    when d.qtybegin > 0 then d.endingendseries else null 
                            end) as beginendseries, 
                            (case 
                                    when d.qtyissued > 0 then d.qtyending 
                                    when convert(d.txndate, date) <> t1.remittancedate then d.qtyending 
                                    when d.qtybegin > 0 then d.qtyending else 0 
                            end) as qtybegin, 
                            null as issuedstartseries, null as issuedendseries, 0 as qtyissued 
                    from ( 
                            select 
                                    r.objid as remittanceid, convert(r.dtposted, date) as remittancedate, 
                                    r.dtposted as remittancedtposted, r.collector_objid as ownerid, a.objid as controlid, (
                                            select objid from af_control_detail 
                                            where controlid = a.objid and txndate < r.dtposted  
                                            order by refdate desc, txndate desc, indexno desc limit 1 
                                    ) as lastdetailid, a.startseries, a.endseries  
                            from remittance r, af_control a 
                            where r.objid = $P{remittanceid}  
                                    and a.owner_objid = r.collector_objid 
                                    and a.dtfiled <= r.dtposted 
                                    and a.currentseries <= a.endseries 
                    )t1, af_control_detail d 
                    where d.objid = t1.lastdetailid 
                            and (d.issuedto_objid = t1.ownerid or d.reftype in ('BEGIN_BALANCE','PURCHASE_RECEIPT'))
                            and d.qtyending > 0 

                    union all 

                    select t2.remittanceid, t2.controlid, 
                            (case 
                                    when convert(d.txndate, date) = t2.remittancedate and d.qtyissued > 0 then null 
                                    when convert(d.txndate, date) = t2.remittancedate and d.qtyreceived > 0 then d.receivedstartseries 
                                    else null 
                            end) as receivedstartseries, 
                            (case 
                                    when convert(d.txndate, date) = t2.remittancedate and d.qtyissued > 0 then null 
                                    when convert(d.txndate, date) = t2.remittancedate and d.qtyreceived > 0 then d.receivedendseries 
                                    else null 
                            end) as receivedendseries, 
                            (case 
                                    when convert(d.txndate, date) = t2.remittancedate and d.qtyissued > 0 then 0
                                    when convert(d.txndate, date) = t2.remittancedate and d.qtyreceived > 0 then d.qtyreceived 
                                    else 0 
                            end) as qtyreceived, 
                            (case 
                                    when d.qtyissued > 0 then d.endingstartseries 
                                    when convert(d.txndate, date) <> t2.remittancedate then d.endingstartseries 
                                    when d.qtybegin > 0 then d.endingstartseries else null 
                            end) as beginstartseries, 
                            (case 
                                    when d.qtyissued > 0 then d.endingendseries 
                                    when convert(d.txndate, date) <> t2.remittancedate then d.endingendseries 
                                    when d.qtybegin > 0 then d.endingendseries else null 
                            end) as beginendseries, 
                            (case 
                                    when d.qtyissued > 0 then d.qtyending 
                                    when convert(d.txndate, date) <> t2.remittancedate then d.qtyending 
                                    when d.qtybegin > 0 then d.qtyending else 0 
                            end) as qtybegin, 
                            t2.issuedstartseries, t2.issuedendseries, t2.qtyissued 
                    from ( 
                            select 
                                    t1.remittanceid, t1.remittancedate, t1.remittancedtposted, t1.controlid, t1.formtype, ( 
                                            select objid from af_control_detail 
                                            where controlid = t1.controlid and txndate < t1.remittancedtposted  
                                            order by refdate desc, txndate desc, indexno desc limit 1 
                                    ) as lastdetailid, 
                                    t1.issuedstartseries, t1.issuedendseries, t1.qtyissued 
                            from ( 
                                    select 
                                            r.objid as remittanceid, convert(r.dtposted, date) as remittancedate, 
                                            r.dtposted as remittancedtposted, afc.objid as controlid, af.formtype, 
                                            min(c.series) as issuedstartseries, max(c.series) as issuedendseries, count(c.objid) as qtyissued 
                                    from remittance r 
                                            inner join cashreceipt c on c.remittanceid = r.objid 
                                            inner join af_control afc on afc.objid = c.controlid 
                                            inner join af on (af.objid = afc.afid and af.formtype = 'serial') 
                                    where r.objid = $P{remittanceid}  
                                    group by r.objid, r.dtposted, afc.objid, af.formtype  
                                    union all 
                                    select 
                                            r.objid as remittanceid, convert(r.dtposted, date) as remittancedate, 
                                            r.dtposted as remittancedtposted, afc.objid as controlid, af.formtype, 
                                            null as issuedstartseries, null as issuedendseries, 
                                            convert((sum(c.amount) / af.denomination), signed) as qtyissued  
                                    from remittance r 
                                            inner join cashreceipt c on c.remittanceid = r.objid 
                                            inner join af_control afc on afc.objid = c.controlid 
                                            inner join af on (af.objid = afc.afid and af.formtype <> 'serial') 
                                            left join cashreceipt_void v on v.receiptid = c.objid 
                                    where r.objid = $P{remittanceid}  
                                            and v.objid is null 
                                    group by r.objid, r.dtposted, afc.objid, af.formtype, af.denomination 
                            )t1 
                    )t2, af_control_detail d 
                    where d.objid = t2.lastdetailid 
                    
            )tt1 
            group by tt1.remittanceid, tt1.controlid 

        )t0, af_control afc, afunit afu 
        where afc.objid = t0.controlid 
            and afc.afid = afu.itemid 
            and afc.unit = afu.unit 

    )tt2, af_control afc, af
    where afc.objid = tt2.controlid 
        and afc.afid = af.objid 

)tt3 
order by formno, prefix, suffix, startseries 


[getCancelledSeries]
select 
    c.remittanceid, c.controlid, af.formtype, afc.afid, 
    c.series, c.receiptno as refno, c.objid as refid 
from cashreceipt c 
    inner join af_control afc on afc.objid = c.controlid 
    inner join af on af.objid = afc.afid 
where c.remittanceid = $P{remittanceid}  
    and c.state = 'CANCELLED' 
    and af.formtype = 'serial' 


[getAFSummary]
select * 
from ( 
    select 
        raf.remittanceid, raf.controlid, afc.afid, afc.stubno, afc.unit, af.formtype, 
        raf.issuedstartseries, raf.issuedendseries, raf.qtyissued, raf.qtycancelled, 
        raf.endingstartseries, raf.endingendseries, raf.qtyending, afc.dtfiled, afc.startseries, 
        (case when raf.qtyissued > 0 or raf.qtycancelled > 0 then 0 else 1 end) as indexlevel   
    from remittance_af raf, af_control afc, af 
    where raf.remittanceid = $P{remittanceid}  
        and afc.objid = raf.controlid 
        and af.objid = afc.afid 
)t1 
order by indexlevel, afid, dtfiled, startseries 
