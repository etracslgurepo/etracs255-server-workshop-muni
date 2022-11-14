[getStandardReport]
select
  t.classname,
  t.orderno,
  t.special,
  sum(t.basiccurrent) as basiccurrent,
  sum(t.basicdisc) as basicdisc,
  sum(t.basicprev) as basicprev,
  sum(t.basiccurrentint) as basiccurrentint,
  sum(t.basicprevint) as basicprevint,
  sum(t.basicnet) as basicnet,
  sum(t.sefcurrent) as sefcurrent,
  sum(t.sefdisc) as sefdisc,
  sum(t.sefprev) as sefprev,
  sum(t.sefcurrentint) as sefcurrentint,
  sum(t.sefprevint) as sefprevint,
  sum(t.sefnet) as sefnet,
  sum(t.idlecurrent) as idlecurrent,
  sum(t.idleprev) as idleprev,
  sum(t.idledisc) as idledisc,
  sum(t.idleint) as idleint,
  sum(t.idlenet) as idlenet,
  sum(t.shcurrent) as shcurrent,
  sum(t.shprev) as shprev,
  sum(t.shdisc) as shdisc,
  sum(t.shint) as shint,
  sum(t.shnet) as shnet,
  sum(t.firecode) as firecode,
  t.levynet
from (
  select 
    classname,
    orderno,
    special,
    basiccurrent,
    basicdisc,
    basicprev,
    basiccurrentint,
    basicprevint,
    basicnet,
    sefcurrent,
    sefdisc,
    sefprev,
    sefcurrentint,
    sefprevint,
    sefnet,
    idlecurrent,
    idleprev,
    idledisc,
    idleint,
    idlenet,
    shcurrent,
    shprev,
    shdisc,
    shint,
    shnet,
    firecode,
    levynet
  from vw_landtax_collection_detail
  where ${filter} 
    and revperiod <> 'advance'
    and voided = 0

  union all 

  select 
    classname,
    orderno,
    special,
    basiccurrent,
    basicdisc,
    basicprev,
    basiccurrentint,
    basicprevint,
    basicnet,
    sefcurrent,
    sefdisc,
    sefprev,
    sefcurrentint,
    sefprevint,
    sefnet,
    idlecurrent,
    idleprev,
    idledisc,
    idleint,
    idlenet,
    shcurrent,
    shprev,
    shdisc,
    shint,
    shnet,
    firecode,
    levynet
  from vw_landtax_collection_detail_eor
  where ${filter} 
    and revperiod <> 'advance'
) t
group by 
  t.classname,
  t.orderno,
  t.special,
  t.levynet
order by t.orderno 


[getAdvanceReport]
select
  t.year,
  t.classname,
  t.orderno,
  t.special,
  sum(t.basic) as basic, 
  sum(t.basicdisc) as basicdisc, 
  sum(t.basicnet) as basicnet,
  sum(t.sef) as sef, 
  sum(t.sefdisc) as sefdisc, 
  sum(t.sefnet) as sefnet,
  sum(t.idle) as idle,
  sum(t.sh) as sh,
  sum(t.firecode) as firecode,
  sum(t.netgrandtotal) as netgrandtotal
from (
  select 
    year,
    classname,
    orderno,
    special,
    (case when revtype = 'basic' then amount else 0 end ) as basic, 
    (case when revtype = 'basic' then discount else 0 end ) as basicdisc, 
    (case when revtype = 'basic' then amount - discount else 0 end ) as basicnet,
    (case when revtype = 'sef' then amount else 0 end ) as sef, 
    (case when revtype = 'sef' then discount else 0 end ) as sefdisc, 
    (case when revtype = 'sef' then amount - discount else 0 end ) as sefnet,
    (case when revtype = 'basicidle' then amount - discount else 0 end ) as idle,
    (case when revtype = 'sh' then amount - discount else 0 end ) as sh,
    (case when revtype = 'firecode' then amount else 0 end ) as firecode,
    (amount - discount) as netgrandtotal
  from vw_landtax_collection_detail
  where ${filter} 
    and revperiod = 'advance'
    and voided = 0

  union all 

  select 
    year,
    classname,
    orderno,
    special,
    (case when revtype = 'basic' then amount else 0 end ) as basic, 
    (case when revtype = 'basic' then discount else 0 end ) as basicdisc, 
    (case when revtype = 'basic' then amount - discount else 0 end ) as basicnet,
    (case when revtype = 'sef' then amount else 0 end ) as sef, 
    (case when revtype = 'sef' then discount else 0 end ) as sefdisc, 
    (case when revtype = 'sef' then amount - discount else 0 end ) as sefnet,
    (case when revtype = 'basicidle' then amount - discount else 0 end ) as idle,
    (case when revtype = 'sh' then amount - discount else 0 end ) as sh,
    (case when revtype = 'firecode' then amount else 0 end ) as firecode,
    (amount - discount) as netgrandtotal
  from vw_landtax_collection_detail_eor
  where ${filter} 
    and revperiod = 'advance'
) t
group by 
  t.year,
  t.classname,
  t.orderno,
  t.special
order by t.year, t.orderno 



[findStandardDispositionReport]
select 
  sum( provcitybasicshare ) as provcitybasicshare, 
  sum( munibasicshare ) as munibasicshare, 
  sum( brgybasicshare ) as brgybasicshare, 
  sum( provcitysefshare ) as provcitysefshare, 
  sum( munisefshare ) as munisefshare, 
  sum( brgysefshare ) as brgysefshare 
from ( 
  select
    provcitybasicshare,
    munibasicshare,
    brgybasicshare,
    provcitysefshare,
    munisefshare,
    brgysefshare
  from vw_landtax_collection_disposition_detail
  where ${filter}  
    and revperiod <> 'advance' 
    and voided = 0

  union all

  select
    provcitybasicshare,
    munibasicshare,
    brgybasicshare,
    provcitysefshare,
    munisefshare,
    brgysefshare
  from vw_landtax_collection_disposition_detail_eor
  where ${filter}  
    and revperiod <> 'advance' 
)t 


[findAdvanceDispositionReport]
select 
  sum( provcitybasicshare ) as provcitybasicshare, 
  sum( munibasicshare ) as munibasicshare, 
  sum( brgybasicshare ) as brgybasicshare, 
  sum( provcitysefshare ) as provcitysefshare, 
  sum( munisefshare ) as munisefshare, 
  sum( brgysefshare ) as brgysefshare 
from ( 
  select
    provcitybasicshare,
    munibasicshare,
    brgybasicshare,
    provcitysefshare,
    munisefshare,
    brgysefshare
  from vw_landtax_collection_disposition_detail
  where ${filter}  
    and revperiod = 'advance' 
    and voided = 0

  union all

  select
    provcitybasicshare,
    munibasicshare,
    brgybasicshare,
    provcitysefshare,
    munisefshare,
    brgysefshare
  from vw_landtax_collection_disposition_detail_eor
  where ${filter}  
    and revperiod = 'advance' 
)t



[findAdvanceDispositionReport2]
select 
  sum(basic) as basic,
  sum(basicdisc) as basicdisc,
  sum(basicidle) as basicidle,
  sum(basicidledisc) as basicidledisc,
  sum(sef) as sef,
  sum(sefdisc) as sefdisc
from (
  select 
    (case when revtype = 'basic' then amount else 0 end) as basic,
    (case when revtype = 'basic' then discount else 0 end) as basicdisc,
    (case when revtype = 'basicidle' then amount else 0 end) as basicidle,
    (case when revtype = 'basicidle' then discount else 0 end) as basicidledisc,
    (case when revtype = 'sef' then amount else 0 end) as sef,
    (case when revtype = 'sef' then discount else 0 end) as sefdisc
  from vw_landtax_collection_detail
  where ${filter}  
    and revperiod = 'advance' 
    and voided = 0

  union all 
  select 
    (case when revtype = 'basic' then amount else 0 end) as basic,
    (case when revtype = 'basic' then discount else 0 end) as basicdisc,
    (case when revtype = 'basicidle' then amount else 0 end) as basicidle,
    (case when revtype = 'basicidle' then discount else 0 end) as basicidledisc,
    (case when revtype = 'sef' then amount else 0 end) as sef,
    (case when revtype = 'sef' then discount else 0 end) as sefdisc
  from vw_landtax_collection_detail_eor
  where ${filter}  
    and revperiod = 'advance' 
) t


[getCollectionSummaryByMonth]
select 
  $P{year} as cy, 
  x.revtype,
  x.mon, 
  sum(x.cytax) as cytax,
  sum(x.cydisc) as cydisc,
  sum(x.cynet) as cynet,
  sum(x.cyint) as cyint,
  sum(x.immediatetax) as immediatetax,
  sum(x.immediateint) as immediateint,
  sum(x.priortax) as priortax,
  sum(x.priorint) as priorint,
  sum(x.subtotaltax) as subtotaltax,
  sum(x.subtotalint) as subtotalint,
  sum(x.total) as total,
  sum(x.gross) as gross
from (
  select 
    revtype, 
    month(receiptdate) as imon, 
    case 
      when month(receiptdate) = 1 then 'JANUARY'
      when month(receiptdate) = 2 then 'FEBRUARY'
      when month(receiptdate) = 3 then 'MARCH'
      when month(receiptdate) = 4 then 'APRIL'
      when month(receiptdate) = 5 then 'MAY'
      when month(receiptdate) = 6 then 'JUNE'
      when month(receiptdate) = 7 then 'JULY'
      when month(receiptdate) = 8 then 'AUGUST'
      when month(receiptdate) = 9 then 'SEPTEMBER'
      when month(receiptdate) = 10 then 'OCTOBER'
      when month(receiptdate) = 11 then 'NOVEMBER'
      else 'DECEMBER' 
    end as mon, 
    case when $P{year} = year then amount else 0 end as cytax,
    case when $P{year} = year then discount else 0 end as cydisc,
    case when $P{year} = year then amount - discount else 0 end as cynet,
    case when $P{year} = year then interest else 0 end as cyint,

    case when $P{year} - 1 = year then amount else 0 end as immediatetax,
    case when $P{year} - 1 = year then interest else 0 end as immediateint,
    
    case when $P{year} > year then amount else 0 end as subtotaltax,
    case when $P{year} > year then interest else 0 end as subtotalint,

    case when $P{year} - 1 > year then amount else 0 end as priortax,
    case when $P{year} - 1 > year then interest else 0 end as priorint,
    
    amount - discount + interest as total,
    amount + interest as gross

  from vw_landtax_collection_detail
  where ${filter} 
    and revperiod <> 'advance'
    and voided = 0

  union all 

  select 
    revtype, 
    month(receiptdate) as imon, 
    case 
      when month(receiptdate) = 1 then 'JANUARY'
      when month(receiptdate) = 2 then 'FEBRUARY'
      when month(receiptdate) = 3 then 'MARCH'
      when month(receiptdate) = 4 then 'APRIL'
      when month(receiptdate) = 5 then 'MAY'
      when month(receiptdate) = 6 then 'JUNE'
      when month(receiptdate) = 7 then 'JULY'
      when month(receiptdate) = 8 then 'AUGUST'
      when month(receiptdate) = 9 then 'SEPTEMBER'
      when month(receiptdate) = 10 then 'OCTOBER'
      when month(receiptdate) = 11 then 'NOVEMBER'
      else 'DECEMBER' 
    end as mon, 
    case when $P{year} = year then amount else 0 end as cytax,
    case when $P{year} = year then discount else 0 end as cydisc,
    case when $P{year} = year then amount - discount else 0 end as cynet,
    case when $P{year} = year then interest else 0 end as cyint,

    case when $P{year} - 1 = year then amount else 0 end as immediatetax,
    case when $P{year} - 1 = year then interest else 0 end as immediateint,
    
    case when $P{year} > year then amount else 0 end as subtotaltax,
    case when $P{year} > year then interest else 0 end as subtotalint,

    case when $P{year} - 1 > year then amount else 0 end as priortax,
    case when $P{year} - 1 > year then interest else 0 end as priorint,
    
    amount - discount + interest as total,
    amount + interest as gross

  from vw_landtax_collection_detail_eor
  where ${filter} 
    and revperiod <> 'advance'
) x 
group by 
  x.revtype,
  x.imon,
  x.mon 
order by 
  x.revtype,
  x.imon
  

[getCollectionSummaryByBrgy]
select 
  x.brgyindex,
  x.barangay,
  $P{year} as cy, 
  x.revtype,
  sum(x.cytax) as cytax,
  sum(x.cydisc) as cydisc,
  sum(x.cynet) as cynet,
  sum(x.cyint) as cyint,
  sum(x.immediatetax) as immediatetax,
  sum(x.immediateint) as immediateint,
  sum(x.priortax) as priortax,
  sum(x.priorint) as priorint,
  sum(x.subtotaltax) as subtotaltax,
  sum(x.subtotalint) as subtotalint,
  sum(x.prevtotal) as prevtotal,
  sum(x.total) as total
from (
  select 
    brgyindex, 
    barangay,
    revtype, 
    case when $P{year} = year then amount else 0 end as cytax,
    case when $P{year} = year then discount else 0 end as cydisc,
    case when $P{year} = year then amount - discount else 0 end as cynet,
    case when $P{year} = year then interest else 0 end as cyint,
    case when $P{year} - 1 = year then amount else 0 end as immediatetax,
    case when $P{year} - 1 = year then interest else 0 end as immediateint,
    case when $P{year} > year then amount else 0 end as subtotaltax,
    case when $P{year} > year then interest else 0 end as subtotalint,
    case when $P{year} - 1 > year then amount else 0 end as priortax,
    case when $P{year} - 1 > year then interest else 0 end as priorint,
    0 as prevtotal,
    amount - discount + interest as total

  from vw_landtax_collection_detail
  where ${filter} 
      and revperiod <> 'advance'
      and voided = 0

  union all 

  select 
    brgyindex, 
    barangay,
    revtype, 
    case when $P{year} = year then amount else 0 end as cytax,
    case when $P{year} = year then discount else 0 end as cydisc,
    case when $P{year} = year then amount - discount else 0 end as cynet,
    case when $P{year} = year then interest else 0 end as cyint,
    case when $P{year} - 1 = year then amount else 0 end as immediatetax,
    case when $P{year} - 1 = year then interest else 0 end as immediateint,
    case when $P{year} > year then amount else 0 end as subtotaltax,
    case when $P{year} > year then interest else 0 end as subtotalint,
    case when $P{year} - 1 > year then amount else 0 end as priortax,
    case when $P{year} - 1 > year then interest else 0 end as priorint,
    0 as prevtotal,
    amount - discount + interest as total

  from vw_landtax_collection_detail_eor
  where ${filter} 
      and revperiod <> 'advance'
) x 
group by 
  x.brgyindex,
  x.barangay,
  x.revtype
order by 
  x.brgyindex,
  x.barangay, 
  x.revtype
  
  
[getPreviousCollectionSummaryByBrgy]
select 
  x.brgyindex,
  x.barangay,
  x.revtype,
  sum(x.total) as total
from (
  select 
    brgyindex, 
    barangay,
    revtype, 
    amount - discount + interest as total
  from vw_landtax_collection_detail
    where ${filter}
      and revperiod <> 'advance'
      and voided = 0

  union all 

  select 
    brgyindex, 
    barangay,
    revtype, 
    amount - discount + interest as total
  from vw_landtax_collection_detail_eor
    where ${filter}
      and revperiod <> 'advance'
) x 
group by 
  x.brgyindex,
  x.barangay,
  x.revtype
order by 
  x.brgyindex,
  x.barangay, 
  x.revtype
  
  
