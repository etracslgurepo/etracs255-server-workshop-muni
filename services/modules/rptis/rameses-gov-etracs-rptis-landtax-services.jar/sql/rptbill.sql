[findOpenLedger]
SELECT 
  rl.objid,
  rl.lastyearpaid,
  rl.lastqtrpaid,
  rl.undercompromise,
  rl.faasid, 
  rl.tdno,
  rl.prevtdno,
  rl.taxpayer_objid, 
  e.name AS taxpayer_name, 
  e.address_text AS taxpayer_address, 
  rl.owner_name,
  rl.administrator_name,
  f.administrator_address, 
  rl.rputype,
  rl.fullpin,
  rl.totalareaha,
  rl.totalareaha * 10000 AS totalareasqm,
  rl.totalmv,
  rl.totalav,
  rl.taxable,
  b.name AS barangay,
  b.objid AS barangayid,
  m.name as lguname,
  rl.cadastrallotno,
  rl.barangayid,
  rl.classcode,
  rl.blockno,
  rp.surveyno,
  pc.name as classification,
  rl.titleno,
    rl.nextbilldate,
    case when m.objid is not null then m.parentid else null end as parentlguid,
    case when m.objid is not null then m.objid else d.parentid end as lguid
FROM rptledger rl 
  INNER JOIN barangay b ON rl.barangayid = b.objid 
  INNER JOIN entity e ON rl.taxpayer_objid = e.objid
  left join propertyclassification pc on rl.classification_objid = pc.objid 
  left join faas f on rl.faasid = f.objid 
  left join municipality m on b.parentid = m.objid 
  left join district d  on b.parentid = d.objid
  left join realproperty rp on f.realpropertyid = rp.objid
WHERE rl.objid = $P{rptledgerid}
AND rl.state = 'APPROVED'
AND (
  ( rl.lastyearpaid < $P{billtoyear} OR (rl.lastyearpaid = $P{billtoyear} AND rl.lastqtrpaid < $P{billtoqtr}))
  or 
  (exists(select * from rptledger_item where parentid = rl.objid))
)


[getBilledLedgers]
SELECT x.*
FROM (
  SELECT 
    rl.objid,
    rl.lastyearpaid,
    rl.lastqtrpaid,
    rl.tdno,
    rl.titleno,
    rl.rputype,
    rl.fullpin,
    rl.totalareaha,
    rl.totalareaha * 10000 AS totalareasqm,
    rl.totalav,
    rl.owner_name, 
    b.name AS barangay,
    rl.cadastrallotno,
    rl.classcode
  FROM rptledger rl 
    INNER JOIN barangay b ON rl.barangayid = b.objid 
    INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
  WHERE (rl.taxpayer_objid like $P{taxpayerid} or rl.beneficiary_objid like $P{taxpayerid})
   and rl.objid like $P{rptledgerid}
   AND rl.state = 'APPROVED'
   and rl.rputype like $P{rputype}
   and rl.barangayid like $P{barangayid}
   AND (rl.lastyearpaid < $P{billtoyear}
        OR ( rl.lastyearpaid = $P{billtoyear} AND rl.lastqtrpaid < $P{billtoqtr})
        or (exists(select * from rptledger_item where parentid = rl.objid  and year <= $P{billtoyear}))
   )

  UNION

  SELECT 
    rl.objid,
    rl.lastyearpaid,
    rl.lastqtrpaid,
    rl.tdno,
    rl.titleno,
    rl.rputype,
    rl.fullpin,
    rl.totalareaha,
    rl.totalareaha * 10000 AS totalareasqm,
    rl.totalav,
    rl.owner_name, 
    b.name AS barangay,
    rl.cadastrallotno,
    rl.classcode
  FROM rptledger rl 
    INNER JOIN barangay b ON rl.barangayid = b.objid 
    INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
    INNER JOIN propertypayer_item ppi ON ppi.rptledger_objid = rl.objid 
    INNER JOIN propertypayer pp on ppi.parentid = pp.objid 
  WHERE pp.taxpayer_objid like $P{taxpayerid}
   and rl.objid like $P{rptledgerid}
   AND rl.state = 'APPROVED'
   and rl.rputype like $P{rputype}
   and rl.barangayid like $P{barangayid}
   AND (rl.lastyearpaid < $P{billtoyear}
        OR ( rl.lastyearpaid = $P{billtoyear} AND rl.lastqtrpaid < $P{billtoqtr})
        or (exists(select * from rptledger_item where parentid = rl.objid and year <= $P{billtoyear}))
   )
) x
ORDER BY x.tdno 




[findLatestPayment]
select min(x.receiptdate) as receiptdate
from (
    select min(c.receiptdate) as receiptdate 
    from cashreceipt c
        inner join cashreceipt_rpt cr on c.objid = cr.objid 
        inner join rptpayment rp on c.objid = rp.receiptid 
        left join cashreceipt_void cv on c.objid = cv.receiptid
    where rp.refid = $P{objid}
    and $P{cy} >= rp.fromyear and $P{cy} <= rp.toyear 
    and cv.objid is null 

    union 

    select min(refdate) as receiptdate 
    from rptledger_credit cr 
    where cr.rptledgerid = $P{objid}
     and ((cr.fromyear = $P{cy} and cr.fromqtr = 1) 
                or (cr.toyear = $P{cy} and cr.toqtr >= 1)
                or ($P{cy} > cr.fromyear and $P{cy} < cr.toyear)
        )
)x


[getCurrentYearCredits] 
select x.* 
from (
    select c.receiptdate, min(cro.qtr) as fromqtr, max(cro.qtr) as toqtr
    from cashreceipt c 
    inner join rptpayment rp on c.objid = rp.receiptid 
    inner join rptpayment_item cro on rp.objid = cro.parentid
    left join cashreceipt_void cv on c.objid = cv.receiptid
    where rp.refid = $P{objid}
    and cro.year = $P{cy}
    and cv.objid is null 
    group by c.receiptdate, cro.year 

    union 

    select 
        rp.receiptdate, 
        case when $P{cy} = rp.fromyear then rp.fromqtr else 1 end as fromqtr,
        case when $P{cy} = rp.toyear then rp.toqtr else 4 end as toqtr
    from rptpayment rp
    where rp.refid = $P{objid}
    and $P{cy} >= rp.fromyear and $P{cy} <= rp.toyear 
    and type = 'capture'
)x 
order by x.fromqtr 


