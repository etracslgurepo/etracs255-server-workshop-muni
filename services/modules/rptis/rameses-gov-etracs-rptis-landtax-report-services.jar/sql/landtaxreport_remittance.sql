[getAbstractOfRPTCollection] 
select t.*
from (
    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    1 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'BASIC' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN rl.owner_name ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as basicidlecurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as basicidleprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' then rpi.amount else 0.0 end) as basicidlediscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as basicidlecurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as basicidlepreviouspenalty,

    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as shcurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as shprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' then rpi.discount else 0.0 end) as shdiscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as shcurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as shpreviouspenalty,

    sum(case when cv.objid is null AND rpi.revtype = 'firecode' then rpi.amount else 0.0 end) as firecode,
    sum(
        case 
            when cv.objid is null AND rpi.revtype in ('basic', 'basicidle', 'sh', 'firecode') 
            then rpi.amount - rpi.discount + rpi.interest 
            else 0.0 
        end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from remittance rem 
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where rem.objid = $P{objid} 
    and rpi.year <= $P{year} 
    and cr.collector_objid like $P{collectorid} 
    ${filter} 
  GROUP BY cr.objid, cr.receiptdate, rl.owner_name, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
  union all  

    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    2 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'SEF' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN rl.owner_name ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance') AND rpi.revtype = 'sef' THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior') AND rpi.revtype = 'sef'  THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL   AND rpi.revtype = 'sef' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    0 as basicidlecurrent,
    0 as basicidleprevious,
    0 as basicidlediscount,
    0 as basicidlecurrentpenalty,
    0 as basicidlepreviouspenalty,

    0 as shcurrent,
    0 as shprevious,
    0 as shdiscount,
    0 as shcurrentpenalty,
    0 as shpreviouspenalty,

    0 as firecode,
    sum(
        case when cv.objid is null and rpi.revtype in ('sef') then rpi.amount - rpi.discount + rpi.interest 
        else 0.0 end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from remittance rem 
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where rem.objid = $P{objid} 
    and rpi.year <= $P{year} 
    and cr.collector_objid like $P{collectorid} 
    ${filter} 
  GROUP BY cr.objid, cr.receiptdate, rl.owner_name, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
) t
order by t.municityname, t.idx, t.orno 





[getAbstractOfRPTCollectionAdvance] 
select t.*
from (
    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    1 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'BASIC' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN rl.owner_name ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as basicidlecurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as basicidleprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' then rpi.amount else 0.0 end) as basicidlediscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as basicidlecurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as basicidlepreviouspenalty,

    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as shcurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as shprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' then rpi.discount else 0.0 end) as shdiscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as shcurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as shpreviouspenalty,

    sum(case when cv.objid is null AND rpi.revtype = 'firecode' then rpi.amount else 0.0 end) as firecode,
    sum(
        case 
            when cv.objid is null AND rpi.revtype in ('basic', 'basicidle', 'sh', 'firecode') 
            then rpi.amount - rpi.discount + rpi.interest 
            else 0.0 
        end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from remittance rem
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join collectionvoucher liq on rem.collectionvoucherid = liq.objid 
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
where rem.objid = $P{objid} 
    and rpi.year > $P{year} 
    and cr.collector_objid like $P{collectorid} 
    ${filter} 
  GROUP BY cr.objid, cr.receiptdate, rl.owner_name, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
  union all  

    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    2 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'SEF' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN rl.owner_name ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance') AND rpi.revtype = 'sef' THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior') AND rpi.revtype = 'sef'  THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL   AND rpi.revtype = 'sef' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    0 as basicidlecurrent,
    0 as basicidleprevious,
    0 as basicidlediscount,
    0 as basicidlecurrentpenalty,
    0 as basicidlepreviouspenalty,

    0 as shcurrent,
    0 as shprevious,
    0 as shdiscount,
    0 as shcurrentpenalty,
    0 as shpreviouspenalty,

    0 as firecode,
    sum(
        case when cv.objid is null and rpi.revtype in ('sef') then rpi.amount - rpi.discount + rpi.interest 
        else 0.0 end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from remittance rem
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join collectionvoucher liq on rem.collectionvoucherid = liq.objid 
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where rem.objid = $P{objid} 
    and rpi.year > $P{year} 
    and cr.collector_objid like $P{collectorid} 
    ${filter} 
  GROUP BY cr.objid, cr.receiptdate, rl.owner_name, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
) t
order by t.municityname, t.idx, t.orno 

