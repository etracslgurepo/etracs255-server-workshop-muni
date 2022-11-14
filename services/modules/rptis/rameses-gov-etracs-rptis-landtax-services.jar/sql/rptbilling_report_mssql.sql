[findLedgerbyId]
SELECT 
  rl.objid,
  rl.lastyearpaid,
  rl.lastqtrpaid,
  rl.faasid, 
  rl.nextbilldate AS expirydate,
  DATEADD(D, -1, rl.nextbilldate) AS validuntil,
  rl.tdno,
  rl.prevtdno,  
  rl.owner_name,
  f.administrator_name,
  f.administrator_address,
  rl.rputype,
  rl.fullpin,
  rl.totalareaha,
  rl.totalareaha * 10000 as totalareasqm,
  rl.totalav,
  b.name AS barangay,
  rl.cadastrallotno,
  rl.barangayid,
  rl.classcode,
  CASE WHEN rl.lastqtrpaid = 4 THEN rl.lastyearpaid + 1 ELSE rl.lastyearpaid END AS fromyear,
  CASE WHEN rl.lastqtrpaid = 4 THEN 1 ELSE rl.lastqtrpaid + 1 END AS fromqtr
FROM rptledger rl 
  INNER JOIN barangay b ON rl.barangayid = b.objid 
  INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
  LEFT JOIN faas f ON rl.faasid = f.objid 
WHERE rl.objid = $P{rptledgerid}
  AND rl.state = 'APPROVED'


[getBilledItems]
select x.* 
from (
  select
    rlf.objid, 
    rlf.tdno,
    rlf.assessedvalue as originalav,
    sum(bi.av) as assessedvalue,
    (convert(varchar(4),bi.year) + '-' + 
      case when min(bi.qtr) = max(bi.qtr) then convert(varchar(1),min(bi.qtr))
      else convert(varchar(1),min(bi.qtr)) + convert(varchar(1),max(bi.qtr))
      end 
    ) as period,
    sum(bi.basic - bi.basicpaid) as basic,
    sum(bi.basicint) as basicint,
    sum(bi.basicdisc) as basicdisc,
    sum(bi.basicint - bi.basicdisc) as  basicdp,
    sum(bi.basic - bi.basicpaid - bi.basicdisc + bi.basicint) as basicnet,

    sum(bi.basicidle - bi.basicidlepaid + bi.basicidleint - bi.basicidledisc) as basicidle,
    
    sum(bi.sef - bi.sefpaid) as sef, 
    sum(bi.sefint) as sefint, 
    sum(bi.sefdisc) as sefdisc, 
    sum(bi.sefint - bi.sefdisc) as  sefdp,
    sum(bi.sef - bi.sefpaid - bi.sefdisc + bi.sefint) as sefnet,
    
    sum(bi.firecode - bi.firecodepaid) as firecode,

    sum(bi.sh - bi.shpaid - bi.shdisc + bi.shint) as sh,
    
    sum( bi.basic - bi.basicpaid - bi.basicdisc + bi.basicint +
      bi.sef - bi.sefpaid - bi.sefdisc + bi.sefint + 
      bi.basicidle - bi.basicidlepaid + bi.basicidleint - bi.basicidledisc +
      bi.firecode - bi.firecodepaid +
      bi.sh - bi.shpaid - bi.shdisc + bi.shint) as total,
    rl.barangayid,
    rli.taxdifference
  from rptbill b 
  inner join rptbill_ledger bl on b.objid = bl.billid 
  inner join rptledger rl on bl.rptledgerid = rl.objid 
    inner join rptledgeritem_qtrly bi on rl.objid = bi.rptledgerid 
    inner join rptledgeritem rli on bi.parentid = rli.objid 
    inner join rptledgerfaas rlf on rli.rptledgerfaasid = rlf.objid
  where rl.objid = $P{rptledgerid}
    and rli.qtrly = 0
    and b.objid  = $P{objid}
    and ( bi.year < b.billtoyear or (bi.year = b.billtoyear and bi.qtr <= b.billtoqtr))
    and bi.fullypaid = 0 
  group by 
    rlf.objid, 
    rlf.tdno,
    rlf.assessedvalue,
    rl.barangayid,
    bi.year, 
    rli.taxdifference

  union all 

  select
    rlf.objid, 
    rlf.tdno,
    rlf.assessedvalue as originalav,
    bi.av as assessedvalue,
    (convert(varchar(4),bi.year)  + '-' + convert(varchar(1),bi.qtr)) as period,
    bi.basic - bi.basicpaid as basic,
    bi.basicint,
    bi.basicdisc,
    bi.basicint - bi.basicdisc as  basicdp,
    bi.basic - bi.basicpaid - bi.basicdisc + bi.basicint as basicnet,

    bi.basicidle - bi.basicidlepaid + bi.basicidleint - bi.basicidledisc as basicidle,
    
    bi.sef - bi.sefpaid as sef, 
    bi.sefint, 
    bi.sefdisc, 
    bi.sefint - bi.sefdisc as  sefdp,
    bi.sef - bi.sefpaid - bi.sefdisc + bi.sefint as sefnet,
    
    bi.firecode - bi.firecodepaid as firecode,

    bi.sh - bi.shpaid - bi.shdisc + bi.shint as sh,
    
    ( bi.basic - bi.basicpaid - bi.basicdisc + bi.basicint +
      bi.sef - bi.sefpaid - bi.sefdisc + bi.sefint + 
      bi.basicidle - bi.basicidlepaid + bi.basicidleint - bi.basicidledisc +
      bi.firecode - bi.firecodepaid + 
      bi.sh - bi.shpaid - bi.shdisc + bi.shint ) as total,
    rl.barangayid,
    rli.taxdifference
    from rptbill b 
  inner join rptbill_ledger bl on b.objid = bl.billid 
  inner join rptledger rl on bl.rptledgerid = rl.objid 
    inner join rptledgeritem_qtrly bi on rl.objid = bi.rptledgerid 
    inner join rptledgeritem rli on bi.parentid = rli.objid 
      inner join rptledgerfaas rlf on rli.rptledgerfaasid = rlf.objid
  where rl.objid = $P{rptledgerid}
    and rli.qtrly = 1
    and b.objid  = $P{objid}
    and ( bi.year < b.billtoyear or (bi.year = b.billtoyear and bi.qtr <= b.billtoqtr))
    and bi.fullypaid = 0
) x
order by x.period, x.objid 
