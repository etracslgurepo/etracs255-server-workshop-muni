[getCraafData]
select t5.* 
from ( 
  select t4.*, af.formtype, t4.endseries+1 as nextseries, a.prefix, a.suffix, 
    (case when t4.issuedto_objid is null then 0 else 1 end) as ownerlevel, 
    (case when t4.issuedto_objid is null then 'AFO' else 'COLLECTOR' end) as ownertype, 
    (case when t4.issuedto_objid is null then 'AFO' else t4.issuedto_objid end) as ownerid, 
    (case when t4.issuedto_objid is null then 'AFO' else t4.issuedto_name end) as ownername, 
    (case 
        when t4.issuedto_objid is null then 0 
        when d.txntype = 'SALE' then 1 else 0 
    end) as saled, 
    (case when t4.qtyending = 0 then 1 else 0 end) as consumed, 
    (case 
      when t4.issuedto_objid is null then null 
      when d.txntype = 'SALE' then 'SALE' 
      when t4.qtyending = 0 then 'CONSUMED' 
      else null 
    end) as remarks, 
    (case when t4.issuedto_objid is null then 'AFO' else t4.issuedto_name end) as name, 
    (case when t4.issuedto_objid is null then 'AFO' else 'COLLECTOR' end) as respcentertype, 
    (case when t4.issuedto_objid is null then 1 else 2 end) as respcenterlevel, 
    (case when t4.qtyissued > 0 then 0 else 1 end) as categoryindex 
  from ( 
    select t3.*, 
      (case 
        when t3.endingstartseries is null then 0 
        else (t3.endingendseries-t3.endingstartseries)+1 
      end) as qtyending, 
      (
        select top 1 objid from af_control_detail 
        where controlid = t3.controlid and refdate < $P{enddate}   
        order by refdate desc, txndate desc, indexno desc 
      ) as detailid 
    from ( 
      select 
        controlid, afid, startseries, endseries, dtfiled, issuedto_objid, 
        (
          select top 1 issuedto_name from af_control_detail 
          where controlid = t2.controlid 
            and issuedto_objid = t2.issuedto_objid 
            and issuedto_name is not null 
          order by refdate desc, txndate desc, indexno desc 
        ) issuedto_name,         
        receivedstartseries, receivedendseries, qtyreceived, 
        (case when qtyreceived > 0 then null else beginstartseries end) as beginstartseries, 
        (case when qtyreceived > 0 then null else beginendseries end) as beginendseries, 
        (case when qtyreceived > 0 then 0 else qtybegin end) as qtybegin, 
        issuedstartseries, issuedendseries, qtyissued, 
        (case 
          when qtyissued > 0 and issuedendseries >= endseries then null 
          when qtyissued > 0 and issuedendseries < endseries then issuedendseries+1 
          when qtyreceived > 0 then receivedstartseries else beginstartseries 
        end) as endingstartseries, 
        (case 
          when qtyissued > 0 and issuedendseries >= endseries then null 
          when qtyissued > 0 and issuedendseries < endseries then endseries 
          when qtyreceived > 0 then receivedendseries else beginendseries 
        end) as endingendseries 
      from ( 
        select 
          controlid, afid, startseries, endseries, dtfiled, issuedto_objid, 
          min(receivedstartseries) as receivedstartseries, max(receivedendseries) as receivedendseries, 
          max(receivedendseries)-min(receivedstartseries)+1 as qtyreceived,  
          min(beginstartseries) as beginstartseries, max(beginendseries) as beginendseries, 
          max(beginendseries)-min(beginstartseries)+1 as qtybegin,  
          min(issuedstartseries) as issuedstartseries, max(issuedendseries) as issuedendseries, 
          max(issuedendseries)-min(issuedstartseries)+1 as qtyissued
        from ( 

          select 
            d.controlid, a.afid, a.startseries, a.endseries, a.dtfiled, d.issuedto_objid, 
            null as receivedstartseries, null as receivedendseries, 
            d.endingstartseries as beginstartseries, d.endingendseries as beginendseries, 
            null as issuedstartseries, null as issuedendseries 
          from ( 
            select 
              xx.startdate, d.controlid, max(d.refdate) as refdate, ( 
                select top 1 objid from af_control_detail 
                where controlid = d.controlid and refdate < xx.startdate 
                order by refdate desc, txndate desc, indexno desc 
              ) as detailid 
            from af_control_detail d, af_control a, 
              (select $P{startdate}  as startdate) xx  
            where d.refdate < xx.startdate 
              and d.controlid = a.objid 
              and a.afid like $P{afid}  
            group by xx.startdate, d.controlid 
          )t1, af_control_detail d, af_control a  
          where d.objid = t1.detailid 
            and d.controlid = a.objid 
            and d.qtyending > 0 
            and d.reftype in ('BEGIN_BALANCE', 'PURCHASE_RECEIPT','RETURN','REMITTANCE','FORWARD') 

          union all 

          select 
            d.controlid, a.afid, a.startseries, a.endseries, a.dtfiled, null as issuedto_objid, 
            (case when d.qtyreceived > 0 then d.receivedstartseries else null end) as receivedstartseries, 
            (case when d.qtyreceived > 0 then d.receivedendseries else null end) as receivedendseries, 
            (case when d.qtybegin > 0 then d.beginstartseries else null end) as beginstartseries, 
            (case when d.qtybegin > 0 then d.beginendseries else null end) as beginendseries, 
            null as issuedstartseries, null as issuedendseries 
          from af_control_detail d, af_control a  
          where d.refdate >= $P{startdate}  
            and d.refdate <  $P{enddate}  
            and d.controlid = a.objid 
            and d.reftype in ('BEGIN_BALANCE', 'PURCHASE_RECEIPT','RETURN')
            and a.afid like $P{afid}  

          union all 

          select 
            d.controlid, a.afid, a.startseries, a.endseries, a.dtfiled, null as issuedto_objid, 
            null as receivedstartseries, null as receivedendseries, 
            null as beginstartseries, null as beginendseries, 
            case 
              when d.qtyissued > 0 then d.issuedstartseries 
              when d.qtyending > 0 then d.endingstartseries 
            end as issuedstartseries, 
            case 
              when d.qtyissued > 0 then d.issuedendseries 
              when d.qtyending > 0 then d.endingendseries 
            end as issuedendseries 
          from af_control_detail d, af_control a  
          where d.refdate >= $P{startdate}  
            and d.refdate <  $P{enddate}  
            and d.controlid = a.objid 
            and d.reftype in ('ISSUE','TRANSFER','MANUAL_ISSUE')
            and a.afid like $P{afid}  

          union all 

          select 
            d.controlid, a.afid, a.startseries, a.endseries, a.dtfiled, d.issuedto_objid, 
            (case when d.qtyreceived > 0 then d.receivedstartseries else null end) as receivedstartseries, 
            (case when d.qtyreceived > 0 then d.receivedendseries else null end) as receivedendseries, 
            (case when d.qtybegin > 0 then d.beginstartseries else null end) as beginstartseries, 
            (case when d.qtybegin > 0 then d.beginendseries else null end) as beginendseries, 
            (case when d.qtyissued > 0 then d.issuedstartseries else null end) as issuedstartseries, 
            (case when d.qtyissued > 0 then d.issuedendseries else null end) as issuedendseries 
          from af_control_detail d, af_control a  
          where d.refdate >= $P{startdate}  
            and d.refdate <  $P{enddate}  
            and d.controlid = a.objid 
            and a.afid like $P{afid}  
            and d.reftype not in ('BEGIN_BALANCE', 'PURCHASE_RECEIPT','RETURN')

        )t1 
        group by controlid, afid, startseries, endseries, dtfiled, issuedto_objid 

      )t2 
    )t3 
  )t4, af_control_detail d, af_control a, af   
  where d.objid = t4.detailid 
    and d.controlid = a.objid 
    and a.afid = af.objid 
)t5
order by afid, respcenterlevel, dtfiled, startseries 


[getCraafData_bak1]
select t5.* 
from ( 
  select t4.*, af.formtype, t4.endseries+1 as nextseries, 
    (case when t4.issuedto_objid is null then 0 else 1 end) as ownerlevel, 
    (case when t4.issuedto_objid is null then 'AFO' else 'COLLECTOR' end) as ownertype, 
    (case when t4.issuedto_objid is null then 'AFO' else t4.issuedto_objid end) as ownerid, 
    (case when t4.issuedto_objid is null then 'AFO' else t4.issuedto_name end) as ownername, 
    (case when d.txntype = 'SALE' then 1 else 0 end) as saled, 
    (case when t4.qtyending = 0 then 1 else 0 end) as consumed, 
    (case 
      when d.txntype = 'SALE' then 'SALE' 
      when t4.qtyending = 0 then 'CONSUMED' 
      else null 
    end) as remarks, 
    (case when t4.issuedto_objid is null then 'AFO' else t4.issuedto_name end) as name, 
    (case when t4.issuedto_objid is null then 'AFO' else 'COLLECTOR' end) as respcentertype, 
    (case when t4.issuedto_objid is null then 1 else 2 end) as respcenterlevel, 
    (case when t4.qtyissued > 0 then 0 else 1 end) as categoryindex 
  from ( 
    select t3.*, 
      (case 
        when t3.endingstartseries is null then 0 
        else (t3.endingendseries-t3.endingstartseries)+1 
      end) as qtyending, 
      (
        select top 1 objid from af_control_detail 
        where controlid = t3.controlid and refdate < $P{enddate}  
        order by refdate desc, txndate desc, indexno desc 
      ) as detailid 
    from ( 
      select 
        controlid, afid, startseries, endseries, dtfiled, issuedto_objid, 
        (
          select top 1 issuedto_name from af_control_detail 
          where controlid = t2.controlid 
            and issuedto_objid = t2.issuedto_objid 
            and issuedto_name is not null 
          order by refdate desc, txndate desc, indexno desc  
        ) issuedto_name,         
        receivedstartseries, receivedendseries, qtyreceived, 
        (case when qtyreceived > 0 then null else beginstartseries end) as beginstartseries, 
        (case when qtyreceived > 0 then null else beginendseries end) as beginendseries, 
        (case when qtyreceived > 0 then 0 else qtybegin end) as qtybegin, 
        issuedstartseries, issuedendseries, qtyissued, 
        (case 
          when qtyissued > 0 and issuedendseries >= endseries then null 
          when qtyissued > 0 and issuedendseries < endseries then issuedendseries+1 
          when qtyreceived > 0 then receivedstartseries else beginstartseries 
        end) as endingstartseries, 
        (case 
          when qtyissued > 0 and issuedendseries >= endseries then null 
          when qtyissued > 0 and issuedendseries < endseries then endseries 
          when qtyreceived > 0 then receivedendseries else beginendseries 
        end) as endingendseries 
      from ( 
        select 
          controlid, afid, startseries, endseries, dtfiled, issuedto_objid, 
          min(receivedstartseries) as receivedstartseries, max(receivedendseries) as receivedendseries, 
          max(receivedendseries)-min(receivedstartseries)+1 as qtyreceived,  
          min(beginstartseries) as beginstartseries, max(beginendseries) as beginendseries, 
          max(beginendseries)-min(beginstartseries)+1 as qtybegin,  
          min(issuedstartseries) as issuedstartseries, max(issuedendseries) as issuedendseries, 
          max(issuedendseries)-min(issuedstartseries)+1 as qtyissued
        from ( 
          select 
            d.controlid, a.afid, a.startseries, a.endseries, a.dtfiled, d.issuedto_objid, 
            null as receivedstartseries, null as receivedendseries, 
            d.endingstartseries as beginstartseries, d.endingendseries as beginendseries, 
            null as issuedstartseries, null as issuedendseries 
          from ( 
            select t1.*, (
                select top 1 objid from af_control_detail 
                where controlid = t1.controlid and refdate = t1.refdate  
                order by refdate desc, txndate desc, indexno desc  
              ) as detailid 
            from ( 
              select d.controlid, max(d.refdate) as refdate 
              from af_control_detail d, af_control a   
              where d.refdate < $P{startdate}  
                and d.controlid = a.objid 
                and a.afid like $P{afid} 
              group by d.controlid 
            )t1 
          )t2, af_control_detail d, af_control a  
          where d.objid = t2.detailid 
            and d.controlid = a.objid 
            and d.qtyending > 0 

          union all 

          select 
            d.controlid, a.afid, a.startseries, a.endseries, a.dtfiled, d.issuedto_objid, 
            (case when d.qtyreceived > 0 then d.receivedstartseries else null end) as receivedstartseries, 
            (case when d.qtyreceived > 0 then d.receivedendseries else null end) as receivedendseries, 
            (case when d.qtybegin > 0 then d.beginstartseries else null end) as beginstartseries, 
            (case when d.qtybegin > 0 then d.beginendseries else null end) as beginendseries, 
            (case when d.qtyissued > 0 then d.issuedstartseries else null end) as issuedstartseries, 
            (case when d.qtyissued > 0 then d.issuedendseries else null end) as issuedendseries 
          from af_control_detail d, af_control a  
          where d.refdate >= $P{startdate} 
            and d.refdate <  $P{enddate} 
            and d.controlid = a.objid 
            and a.afid like $P{afid} 
        )t1 
        group by controlid, afid, startseries, endseries, dtfiled, issuedto_objid 

      )t2 
    )t3 
  )t4, af_control_detail d, af_control a, af   
  where d.objid = t4.detailid 
    and d.controlid = a.objid 
    and a.afid = af.objid 
)t5
order by afid, respcenterlevel, categoryindex, dtfiled, startseries 
