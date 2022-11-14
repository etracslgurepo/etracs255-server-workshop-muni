[getReport]
select 
  t1.afid, t1.formtype, t1.denomination, t1.serieslength, 
  t1.controlid, t1.prefix, t1.suffix, t1.cost, t1.startseries, t1.endseries, t1.nextseries, 
  min(ISNULL(t1.receivedstartseries, 999999999)) as receivedstartseries, max(ISNULL(t1.receivedendseries,-999999999)) as receivedendseries, sum(t1.qtyreceived) as qtyreceived, 
  min(ISNULL(t1.beginstartseries, 999999999)) as beginstartseries, max(ISNULL(t1.beginendseries,-999999999)) as beginendseries, sum(t1.qtybegin) as qtybegin, 
  min(ISNULL(t1.issuedstartseries, 999999999)) as issuedstartseries, max(ISNULL(t1.issuedendseries,-999999999)) as issuedendseries, sum(t1.qtyissued) as qtyissued, 
  min(ISNULL(t1.endingstartseries, 999999999)) as endingstartseries, max(ISNULL(t1.endingendseries,-999999999)) as endingendseries, sum(t1.qtyending) as qtyending, 
  sum(t1.qtycancelled) as qtycancelled 
from ( 
  select 
    a.afid, af.formtype, af.denomination, af.serieslength, 
    d.controlid, a.prefix, a.suffix, a.cost, 
    a.startseries, a.endseries, a.endseries+1 as nextseries, 
    null as receivedstartseries, null as receivedendseries, 0 as qtyreceived, 
    case when d.reftype='PURCHASE_RECEIPT' then d.receivedstartseries else d.beginstartseries end as beginstartseries, 
    case when d.reftype='PURCHASE_RECEIPT' then d.receivedendseries else d.beginendseries end as beginendseries,
    case when d.reftype='PURCHASE_RECEIPT' then d.qtyreceived else d.qtybegin end as qtybegin, 
    null as issuedstartseries, null as issuedendseries, 0 as qtyissued, 
    null as endingstartseries, null as endingendseries, 0 as qtyending, 
    d.qtycancelled 
  from ( 
    select controlid, sum(iflag) as iflag   
    from ( 
      select d.controlid, 
        case when d.reftype in ('PURCHASE_RECEIPT','BEGIN_BALANCE') then 1 else -1 end as iflag 
      from af_control_detail d 
      where d.refdate < $P{startdate} 
        and d.reftype in ('PURCHASE_RECEIPT','BEGIN_BALANCE','ISSUE','MANUAL_ISSUE')
    )t1 
    group by controlid 
    having sum(iflag) > 0 
  )t2 
    inner join af_control_detail d on (d.controlid = t2.controlid and d.reftype in ('PURCHASE_RECEIPT','BEGIN_BALANCE')) 
    inner join af_control a on a.objid = d.controlid 
    inner join af on af.objid = a.afid 

  union all 

  select 
    a.afid, af.formtype, af.denomination, af.serieslength, 
    d.controlid, a.prefix, a.suffix, a.cost, 
    a.startseries, a.endseries, a.endseries+1 as nextseries, 
    null as receivedstartseries, null as receivedendseries, 0 as qtyreceived, 
    d.beginstartseries, d.beginendseries, d.qtybegin, 
    null as issuedstartseries, null as issuedendseries, 0 as qtyissued, 
    null as endingstartseries, null as endingendseries, 0 as qtyending, 
    d.qtycancelled 
  from af_control_detail d 
    inner join af_control a on a.objid = d.controlid 
    inner join af on af.objid = a.afid 
  where d.refdate >= $P{startdate} 
    and d.refdate <  $P{enddate} 
    and d.reftype = 'BEGIN_BALANCE'

  union all 

  select 
    a.afid, af.formtype, af.denomination, af.serieslength, 
    d.controlid, a.prefix, a.suffix, a.cost, 
    a.startseries, a.endseries, a.endseries+1 as nextseries, 
    d.receivedstartseries, d.receivedendseries, d.qtyreceived, 
    null as beginstartseries, null as beginendseries, 0 as qtybegin, 
    null as issuedstartseries, null as issuedendseries, 0 as qtyissued, 
    null as endingstartseries, null as endingendseries, 0 as qtyending, 
    d.qtycancelled 
  from af_control_detail d 
    inner join af_control a on a.objid = d.controlid 
    inner join af on af.objid = a.afid 
  where d.refdate >= $P{startdate} 
    and d.refdate <  $P{enddate} 
    and d.reftype = 'PURCHASE_RECEIPT'

  union all 

  select 
    a.afid, af.formtype, af.denomination, af.serieslength, 
    d.controlid, a.prefix, a.suffix, a.cost, 
    a.startseries, a.endseries, a.endseries+1 as nextseries, 
    null as receivedstartseries, null as receivedendseries, 0 as qtyreceived, 
    null as beginstartseries, null as beginendseries, 0 as qtybegin, 
    d.receivedstartseries as issuedstartseries, d.receivedendseries as issuedendseries, d.qtyreceived as qtyissued, 
    null as endingstartseries, null as endingendseries, 0 as qtyending, 
    d.qtycancelled 
  from af_control_detail d 
    inner join af_control a on a.objid = d.controlid 
    inner join af on af.objid = a.afid 
  where d.refdate >= $P{startdate} 
    and d.refdate <  $P{enddate} 
    and d.reftype in ('ISSUE','MANUAL_ISSUE')  
)t1 
group by 
  t1.afid, t1.formtype, t1.denomination, t1.serieslength, 
  t1.controlid, t1.prefix, t1.suffix, t1.cost, 
  t1.startseries, t1.endseries, t1.nextseries 
order by t1.afid, t1.prefix, t1.suffix, t1.startseries 
