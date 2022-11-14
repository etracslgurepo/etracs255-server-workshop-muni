[getIdleLandSharesAbstract]
select 
    o.name as lgu,
    b.name as barangay,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' then cra.amount else 0 end) as brgycurr,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' then cra.amount else 0 end) as brgycurrpenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' then cra.amount else 0 end) as brgyprev,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' then cra.amount else 0 end) as brgyprevpenalty,
    sum(0.0) as brgypenalty,
    sum(case when cra.revperiod <> 'advance' and cra.revtype in ('basicidle','basicidleint') then cra.amount else 0 end) as brgytotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as citycurrshare,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' and cra.sharetype = 'city' then cra.amount else 0 end) as citycurrsharepenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as cityprevshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' and cra.sharetype = 'city' then cra.amount else 0 end) as cityprevsharepenalty,
    sum(0.0) as citypenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype in ('basicidle','basicidleint') and cra.sharetype = 'city' then cra.amount else 0 end) as citysharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as municurrshare,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' and cra.sharetype = 'municipality' then cra.amount else 0 end) as municurrsharepenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as muniprevshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' and cra.sharetype = 'municipality' then cra.amount else 0 end) as muniprevsharepenalty,
    sum(0.0) as munipenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype in ('basicidle','basicidleint') and cra.sharetype = 'municipality' then cra.amount else 0 end) as munisharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provcurrshare,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' and cra.sharetype = 'province' then cra.amount else 0 end) as provcurrsharepenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provprevshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' and cra.sharetype = 'province' then cra.amount else 0 end) as provprevsharepenalty,
    sum(0.0) as provpenaltyshare,
    sum(case when cra.revperiod <> 'advance' and  cra.revtype in ('basicidle','basicidleint') and cra.sharetype = 'province' then cra.amount else 0 end) as provsharetotal
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join rptledger rl on rp.refid = rl.objid
    left join sys_org o on rl.lguid = o.objid 
    left join barangay b on rl.barangayid = b.objid 
    left join cashreceipt_void crv on cr.objid = crv.receiptid 
where ${filter}   
    and cra.revtype in  ('basicidle', 'basicidleint') 
    and cra.amount > 0
    and crv.objid is null 
group by o.name, b.name 


[getIdleLandShares]
select 
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as citycurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as cityprevshare,
    sum(0.0) as citypenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as citysharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as municurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as muniprevshare,
    sum(0.0) as munipenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as munisharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provcurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provprevshare,
    sum(0.0) as provpenaltyshare,
    sum(case when cra.revperiod <> 'advance' and  cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provsharetotal
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join cashreceipt_void crv on cr.objid = crv.receiptid 
where ${filter} 
    and crv.objid is null 


[getBasicSharesAbstract]
select 
  t.lgu,
  t.barangayid,
  t.barangay, 
  sum(t.brgycurr) as brgycurr,
  sum(t.brgyprev) as brgyprev,
  sum(t.brgypenalty) as brgypenalty,
  sum(t.brgycurrshare) as brgycurrshare,
  sum(t.brgyprevshare) as brgyprevshare,
  sum(t.brgypenaltyshare) as brgypenaltyshare,
  sum(t.citycurrshare) as citycurrshare,
  sum(t.cityprevshare) as cityprevshare,
  sum(t.citypenaltyshare) as citypenaltyshare,
  sum(t.provmunicurrshare) as provmunicurrshare,
  sum(t.provmuniprevshare) as provmuniprevshare,
  sum(t.provmunipenaltyshare) as provmunipenaltyshare
from (
  select 
      lgu,
      barangayid,
      barangay, 
      (case when revperiod = 'current' and revtype = 'basic' then amount else 0 end) as brgycurr,
      (case when revperiod in ('previous', 'prior') and revtype = 'basic' then amount else 0 end) as brgyprev,
      (case when revtype = 'basicint' then amount else 0 end) as brgypenalty,
      (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgycurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgyprevshare,
      (case when revtype = 'basicint' and sharetype = 'barangay' then amount else 0 end) as brgypenaltyshare,
      (case when revperiod = 'current' and revtype = 'basic' and sharetype in ('city') then amount else 0 end) as citycurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype in ('city') then amount else 0 end) as cityprevshare,
      (case when revtype = 'basicint' and sharetype in ('city') then amount else 0 end) as citypenaltyshare,
      (case when revperiod = 'current' and revtype = 'basic' and sharetype in ('province', 'municipality') then amount else 0 end) as provmunicurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype in ('province', 'municipality') then amount else 0 end) as provmuniprevshare,
      (case when revtype = 'basicint' and sharetype in ('province', 'municipality') then amount else 0 end) as provmunipenaltyshare
  from vw_landtax_collection_share_detail
  where ${filter} 
      and revperiod <> 'advance' 
      and revtype in ('basic', 'basicint')
      and voided = 0

    union all 

    select 
        lgu,
        barangayid,
        barangay, 
        (case when revperiod = 'current' and revtype = 'basic' then amount else 0 end) as brgycurr,
        (case when revperiod in ('previous', 'prior') and revtype = 'basic' then amount else 0 end) as brgyprev,
        (case when revtype = 'basicint' then amount else 0 end) as brgypenalty,
        (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgycurrshare,
        (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgyprevshare,
        (case when revtype = 'basicint' and sharetype = 'barangay' then amount else 0 end) as brgypenaltyshare,
        (case when revperiod = 'current' and revtype = 'basic' and sharetype in ('city') then amount else 0 end) as citycurrshare,
        (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype in ('city') then amount else 0 end) as cityprevshare,
        (case when revtype = 'basicint' and sharetype in ('city') then amount else 0 end) as citypenaltyshare,
        (case when revperiod = 'current' and revtype = 'basic' and sharetype in ('province', 'municipality') then amount else 0 end) as provmunicurrshare,
        (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype in ('province', 'municipality') then amount else 0 end) as provmuniprevshare,
        (case when revtype = 'basicint' and sharetype in ('province', 'municipality') then amount else 0 end) as provmunipenaltyshare
    from vw_landtax_collection_share_detail_eor
    where ${filter} 
        and revperiod <> 'advance' 
        and revtype in ('basic', 'basicint')
) t
group by 
  t.lgu,
  t.barangayid,
  t.barangay
order by 
  t.lgu, 
  t.barangay



[getBasicShares]
select
    t.lgu,
    t.barangay,
    sum(t.brgytotalshare) as brgytotalshare,
    sum(t.citycurrshare) as citycurrshare,
    sum(t.cityprevshare) as cityprevshare,
    sum(t.citypenaltyshare) as citypenaltyshare,
    sum(t.municurrshare) as municurrshare,
    sum(t.muniprevshare) as muniprevshare,
    sum(t.munipenaltyshare) as munipenaltyshare,
    sum(t.provcurrshare) as provcurrshare,
    sum(t.provprevshare) as provprevshare,
    sum(t.provpenaltyshare) as provpenaltyshare,
    sum(t.brgytotalshare + t.municurrshare + t.muniprevshare + t.munipenaltyshare +
            t.provcurrshare + t.provprevshare + t.provpenaltyshare + 
            t.citycurrshare + t.cityprevshare + t.citypenaltyshare 
    ) as grandtotal
from (
    select 
        lgu, 
        barangay,
        barangayid,
        case when sharetype = 'barangay' then amount else 0 end as brgytotalshare,

        case when revperiod = 'current' and revtype = 'basic' and sharetype = 'city' then amount else 0 end as citycurrshare,
        case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'city' then amount else 0 end as cityprevshare,
        case when revtype = 'basicint' and sharetype = 'city' then amount else 0 end as citypenaltyshare,

        case when revperiod = 'current' and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end as municurrshare,
        case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end as muniprevshare,
        case when revtype = 'basicint' and sharetype = 'municipality' then amount else 0 end as munipenaltyshare,

        case when revperiod = 'current' and revtype = 'basic' and sharetype = 'province' then amount else 0 end as provcurrshare,
        case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'province' then amount else 0 end as provprevshare,
        case when revtype = 'basicint' and sharetype = 'province' then amount else 0 end as provpenaltyshare
    from vw_landtax_collection_share_detail
    where ${filter} 
        and revperiod <> 'advance' 
        and revtype in ('basic', 'basicint')
        and voided = 0

    union all 

    select 
        lgu, 
        barangay,
        barangayid,
        case when sharetype = 'barangay' then amount else 0 end as brgytotalshare,

        case when revperiod = 'current' and revtype = 'basic' and sharetype = 'city' then amount else 0 end as citycurrshare,
        case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'city' then amount else 0 end as cityprevshare,
        case when revtype = 'basicint' and sharetype = 'city' then amount else 0 end as citypenaltyshare,

        case when revperiod = 'current' and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end as municurrshare,
        case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end as muniprevshare,
        case when revtype = 'basicint' and sharetype = 'municipality' then amount else 0 end as munipenaltyshare,

        case when revperiod = 'current' and revtype = 'basic' and sharetype = 'province' then amount else 0 end as provcurrshare,
        case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'province' then amount else 0 end as provprevshare,
        case when revtype = 'basicint' and sharetype = 'province' then amount else 0 end as provpenaltyshare
    from vw_landtax_collection_share_detail_eor
    where ${filter} 
        and revperiod <> 'advance' 
        and revtype in ('basic', 'basicint')
        
) t
group by t.lgu, t.barangay 


[getBasicSharesSummary]   
select tt.*, 
    (brgytotalshare + munitotalshare + provtotalshare + citytotalshare) as totalshare 
from ( 
    select 
        sum(t.brgycurrshare) as brgycurrshare,
        sum(t.brgyprevshare) as brgyprevshare,
        sum(t.brgypenaltyshare) as brgypenaltyshare,
        sum(t.brgytotalshare) as brgytotalshare,
        sum(t.citycurrshare) as citycurrshare,
        sum(t.cityprevshare) as cityprevshare,
        sum(t.citypenaltyshare) as citypenaltyshare,
        sum(t.citytotalshare) as citytotalshare,
        sum(t.municurrshare) as municurrshare,
        sum(t.muniprevshare) as muniprevshare,
        sum(t.munipenaltyshare) as munipenaltyshare,
        sum(t.munitotalshare) as munitotalshare,
        sum(t.provcurrshare) as provcurrshare,
        sum(t.provprevshare) as provprevshare,
        sum(t.provpenaltyshare) as provpenaltyshare,
        sum(t.provtotalshare) as provtotalshare
    from (
        select 
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgycurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgyprevshare,
            (case when revtype = 'basicint' and sharetype = 'barangay' then amount else 0 end) as  brgypenaltyshare,
            (case when sharetype = 'barangay' then amount else 0 end) as  brgytotalshare,
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'city' then amount else 0 end) as  citycurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'city' then amount else 0 end) as  cityprevshare,
            (case when revtype = 'basicint' and sharetype = 'city' then amount else 0 end) as  citypenaltyshare,
            (case when sharetype = 'city' then amount else 0 end) as  citytotalshare,
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end) as  municurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end) as  muniprevshare,
            (case when revtype = 'basicint' and sharetype = 'municipality' then amount else 0 end) as  munipenaltyshare,
            (case when sharetype = 'municipality' then amount else 0 end) as  munitotalshare,
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'province' then amount else 0 end) as  provcurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'province' then amount else 0 end) as  provprevshare,
            (case when revtype = 'basicint' and sharetype = 'province' then amount else 0 end) as  provpenaltyshare,
            (case when sharetype = 'province' then amount else 0 end) as  provtotalshare 
        from vw_landtax_collection_share_detail
        where ${filter}   
            and revperiod <> 'advance' 
            and revtype in ('basic', 'basicint')
            and voided = 0

        union all 

        select 
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgycurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'barangay' then amount else 0 end) as brgyprevshare,
            (case when revtype = 'basicint' and sharetype = 'barangay' then amount else 0 end) as  brgypenaltyshare,
            (case when sharetype = 'barangay' then amount else 0 end) as  brgytotalshare,
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'city' then amount else 0 end) as  citycurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'city' then amount else 0 end) as  cityprevshare,
            (case when revtype = 'basicint' and sharetype = 'city' then amount else 0 end) as  citypenaltyshare,
            (case when sharetype = 'city' then amount else 0 end) as  citytotalshare,
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end) as  municurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'municipality' then amount else 0 end) as  muniprevshare,
            (case when revtype = 'basicint' and sharetype = 'municipality' then amount else 0 end) as  munipenaltyshare,
            (case when sharetype = 'municipality' then amount else 0 end) as  munitotalshare,
            (case when revperiod = 'current' and revtype = 'basic' and sharetype = 'province' then amount else 0 end) as  provcurrshare,
            (case when revperiod in ('previous', 'prior') and revtype = 'basic' and sharetype = 'province' then amount else 0 end) as  provprevshare,
            (case when revtype = 'basicint' and sharetype = 'province' then amount else 0 end) as  provpenaltyshare,
            (case when sharetype = 'province' then amount else 0 end) as  provtotalshare 
        from vw_landtax_collection_share_detail_eor
        where ${filter}   
            and revperiod <> 'advance' 
            and revtype in ('basic', 'basicint')
    ) t
)tt


[getSefShares]
select 
  sum(t.citycurrshare) as citycurrshare,
  sum(t.cityprevshare) as cityprevshare,
  sum(t.citypenaltyshare) as citypenaltyshare,
  sum(t.citysharetotal) as citysharetotal,
  sum(t.municurrshare) as municurrshare,
  sum(t.muniprevshare) as muniprevshare,
  sum(t.munipenaltyshare) as munipenaltyshare,
  sum(t.munisharetotal) as munisharetotal,
  sum(t.provcurrshare) as provcurrshare,
  sum(t.provprevshare) as provprevshare,
  sum(t.provpenaltyshare) as provpenaltyshare,
  sum(t.provsharetotal) as provsharetotal
from (
  select 
      (case when revperiod = 'current' and revtype = 'sef' and sharetype = 'city' then amount else 0 end) as citycurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'sef' and sharetype = 'city' then amount else 0 end) as cityprevshare,
      (case when revtype = 'sefint' and sharetype = 'city' then amount else 0 end) as citypenaltyshare,
      (case when revtype in ('sef', 'sefint') and sharetype = 'city' then amount else 0 end) as citysharetotal,
      (case when revperiod = 'current' and revtype = 'sef' and sharetype = 'municipality' then amount else 0 end) as municurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'sef' and sharetype = 'municipality' then amount else 0 end) as muniprevshare,
      (case when revtype = 'sefint' and sharetype = 'municipality' then amount else 0 end) as munipenaltyshare,
      (case when revtype in ('sef', 'sefint') and sharetype = 'municipality' then amount else 0 end) as munisharetotal,
      (case when revperiod = 'current' and revtype = 'sef' and sharetype = 'province' then amount else 0 end) as provcurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'sef' and sharetype = 'province' then amount else 0 end) as provprevshare,
      (case when revtype = 'sefint' and sharetype = 'province' then amount else 0 end) as provpenaltyshare,
      (case when revtype in ('sef', 'sefint') and sharetype = 'province' then amount else 0 end) as provsharetotal
  from vw_landtax_collection_share_detail
  where ${filter} 
      and revperiod <> 'advance'
      and revtype in ('sef', 'sefint')
      and voided = 0

    union all 

  select 
      (case when revperiod = 'current' and revtype = 'sef' and sharetype = 'city' then amount else 0 end) as citycurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'sef' and sharetype = 'city' then amount else 0 end) as cityprevshare,
      (case when revtype = 'sefint' and sharetype = 'city' then amount else 0 end) as citypenaltyshare,
      (case when revtype in ('sef', 'sefint') and sharetype = 'city' then amount else 0 end) as citysharetotal,
      (case when revperiod = 'current' and revtype = 'sef' and sharetype = 'municipality' then amount else 0 end) as municurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'sef' and sharetype = 'municipality' then amount else 0 end) as muniprevshare,
      (case when revtype = 'sefint' and sharetype = 'municipality' then amount else 0 end) as munipenaltyshare,
      (case when revtype in ('sef', 'sefint') and sharetype = 'municipality' then amount else 0 end) as munisharetotal,
      (case when revperiod = 'current' and revtype = 'sef' and sharetype = 'province' then amount else 0 end) as provcurrshare,
      (case when revperiod in ('previous', 'prior') and revtype = 'sef' and sharetype = 'province' then amount else 0 end) as provprevshare,
      (case when revtype = 'sefint' and sharetype = 'province' then amount else 0 end) as provpenaltyshare,
      (case when revtype in ('sef', 'sefint') and sharetype = 'province' then amount else 0 end) as provsharetotal
  from vw_landtax_collection_share_detail_eor
  where ${filter} 
      and revperiod <> 'advance'
      and revtype in ('sef', 'sefint')
) t


[getBrgyShares]
select
  t.lgu,
  t.barangay as brgyname,
  sum(t.basiccurrentamt) as basiccurrentamt,
  sum(t.basiccurrentdiscamt) as basiccurrentdiscamt,
  sum(t.basiccurrentintamt) as basiccurrentintamt,
  sum(t.basicprevamt) as basicprevamt,
  sum(t.basicprevintamt) as basicprevintamt,
  sum(t.total  ) as total
from (
  select  
      lgu,
      barangay, 
      (case when revperiod='current' and revtype='basic' then amount + discount else 0.0 end ) as basiccurrentamt,     
      (case when revperiod='current' and revtype='basic' then discount else 0.0 end ) as basiccurrentdiscamt,     
      (case when revperiod = 'current' and revtype ='basicint' then amount else 0.0 end)  as basiccurrentintamt,
      (case when revperiod in ('previous', 'prior') and revtype ='basic' then amount else 0.0 end)  as basicprevamt,    
      (case when revperiod in ('previous', 'prior') and revtype ='basicint' then amount else 0.0 end)  as basicprevintamt,
      (case when revtype like 'basic%' then amount else 0.0 end)  as total
  from vw_landtax_collection_share_detail
  where ${filter} 
      and sharetype ='barangay'
      and revperiod <> 'advance'
      and voided = 0

    union all 

    select  
        lgu,
        barangay, 
        (case when revperiod='current' and revtype='basic' then amount + discount else 0.0 end ) as basiccurrentamt,     
        (case when revperiod='current' and revtype='basic' then discount else 0.0 end ) as basiccurrentdiscamt,     
        (case when revperiod = 'current' and revtype ='basicint' then amount else 0.0 end)  as basiccurrentintamt,
        (case when revperiod in ('previous', 'prior') and revtype ='basic' then amount else 0.0 end)  as basicprevamt,    
        (case when revperiod in ('previous', 'prior') and revtype ='basicint' then amount else 0.0 end)  as basicprevintamt,
        (case when revtype like 'basic%' then amount else 0.0 end)  as total
    from vw_landtax_collection_share_detail_eor
    where ${filter} 
        and sharetype ='barangay'
        and revperiod <> 'advance'
) t
group by t.lgu, t.barangay

[getBrgySharesAdvance]
select  
    o.name as lgu,
    b.name as brgyname, 
    sum(case when cra.revperiod='advance' and revtype='basic' then cra.amount else 0.0 end )as basiccurrentamt,     
    sum(case when cra.revperiod = 'advance' and revtype ='basicint' then cra.amount else 0.0 end) as basiccurrentintamt
from cashreceipt cr 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    left join rptledger rl on rp.refid = rl.objid
    left join sys_org o on rl.lguid = o.objid  
    left join barangay b on rl.barangayid = b.objid 
    inner join remittance r on r.objid = cr.remittanceid 
where cr.receiptdate >= $P{fromdate} and cr.receiptdate < $P{todate}
    and cra.sharetype ='barangay'
     and cv.objid is null  
     and cra.revperiod = 'advance'
group by o.name, b.name   





[getAdvanceCollectionsByBrgy]
select
  t.year,
  t.brgyid,
  sum(t.basic) as basic,     
  sum(t.disc) as disc,     
  sum(t.total) as total  
from (
  select  
      year, 
      barangayid as brgyid,
      (amount) as basic,     
      (discount) as disc,     
      (amount - discount) as total
  from vw_landtax_collection_detail
  where ${filter} 
      and revperiod = 'advance'
      and revtype like 'basic' 
      and voided = 0

    union all 

  select  
      year, 
      barangayid as brgyid,
      (amount) as basic,     
      (discount) as disc,     
      (amount - discount) as total
  from vw_landtax_collection_detail_eor
  where ${filter} 
      and revperiod = 'advance'
      and revtype like 'basic' 
) t 
group by t.year, t.brgyid

[getAdvanceBrgySharesAnnual]
select  
    rps.year, 
    b.objid as brgyid, 
    sum(rps.amount + rps.discount) as brgybasic,
    sum(rps.discount) as brgydisc,
    sum(rps.amount) as brgyshare
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share rps on rp.objid = rps.parentid
    inner join itemaccount ia on rps.item_objid = ia.objid 
    inner join barangay b on ia.org_objid = b.objid 
    left join cashreceipt_void crv on cr.objid = crv.receiptid 
where ${filter} 
    and rps.revperiod = 'advance'
    and rps.revtype in ('basic', 'basicint')
    and rps.sharetype = 'barangay'
    and crv.objid is null 
group by rps.year, b.objid 

[getAdvanceLguSharesAnnual]
select  
    rps.year, 
    b.objid as brgyid, 
    sum(rps.amount + rps.discount) as lgubasic,     
    sum(rps.discount) as lgudisc,     
    sum(rps.amount) as lgushare
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share rps on rp.objid = rps.parentid
    inner join rptledger rl on rp.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
    left join cashreceipt_void crv on cr.objid = crv.receiptid 
where ${filter} 
    and rps.revperiod = 'advance'
    and rps.revtype in ('basic', 'basicint')
    and rps.sharetype = $P{lgutype}
    and crv.objid is null 
group by rps.year, b.objid 

