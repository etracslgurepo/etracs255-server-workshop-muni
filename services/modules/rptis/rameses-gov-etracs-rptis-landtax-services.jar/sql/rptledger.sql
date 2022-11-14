[getList]
SELECT 
    ${columns}
FROM rptledger rl 
    INNER JOIN barangay b ON rl.barangayid = b.objid 
    LEFT JOIN entity e ON rl.taxpayer_objid = e.objid 
    LEFT JOIN faas f on rl.faasid = f.objid 
WHERE 1=1
${fixfilters}
${filters}
${orderby}


[closePaidAvDifference]
update rptledger_avdifference set 
	paid = 1
where parent_objid = $P{refid}
  and not exists(
    select * from rptledger_item 
    where parentid = rptledger_avdifference.parent_objid
    and year = rptledger_avdifference.year 
    and taxdifference = 1 
  )


[findLastPayment]
select
  rpi.year,
  sum(case when rpi.revtype = 'basic' then rpi.amount else 0 end) as basic,
  sum(case when rpi.revtype = 'sef' then rpi.amount else 0 end) as sef
from rptpayment_item rpi
inner join rptpayment rp on rpi.parentid = rp.objid
where rp.refid  =   $P{objid}
and rpi.year = $P{year}
and rp.voided = 0 
group by year 

[getRpuAssessments]
select
  x.classification_objid,
  x.actualuse_objid,
  sum(x.assessedvalue) as assessedvalue 
from (
  select 
    r.classification_objid, 
    case 
      when l.objid is not null then l.classification_objid
      when b.objid is not null then b.classification_objid
      when m.objid is not null then m.classification_objid
      when p.objid is not null then p.classification_objid
      when mi.objid is not null then mi.classification_objid
      else r.actualuse_objid
    end as actualuse_objid,
    r.assessedvalue
  from faas f
  inner join rpu_assessment r on f.rpuid = r.rpuid 
  left join landassesslevel l on r.actualuse_objid = l.objid 
  left join bldgassesslevel b on r.actualuse_objid = b.objid 
  left join machassesslevel m on r.actualuse_objid = m.objid 
  left join planttreeassesslevel p on r.actualuse_objid = p.objid 
  left join miscassesslevel mi on r.actualuse_objid = mi.objid 
  where f.objid = $P{objid}
) x
group by 
  x.classification_objid,
  x.actualuse_objid


[getLedgerPayments]  
select 
  rp.*,
  (select max(partialled) from rptpayment_item where parentid = rp.objid) as partialled
from rptpayment rp 
left join cashreceipt_void cv on rp.receiptid = cv.receiptid
where refid = $P{objid}
and voided = 0
and cv.objid is null 
order by rp.fromyear desc, rp.fromqtr desc, rp.receiptno desc


[findSubledgerTotals]
select
  sum(rl.totalareaha) as totalareaha,
  sum(rl.totalmv) as totalmv,
  sum(rl.totalav) as totalav
from rptledger_subledger sl
inner join rptledger rl on sl.objid = rl.objid
where sl.parent_objid = $P{parentid}