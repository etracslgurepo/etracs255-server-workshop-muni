[getAbstractOfRPTCollection] 
select t.*
from (
    select 
      1 as idx,
      'BASIC' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(basiccurrentyear) as currentyear,
      sum(basicpreviousyear) as previousyear,
      sum(basicdiscount) as discount,
      sum(basicpenaltycurrent) as penaltycurrent,
      sum(basicpenaltyprevious) as penaltyprevious,
      sum(basicidlecurrent) as basicidlecurrent,
      sum(basicidleprevious) as basicidleprevious,
      sum(basicidlediscount) as basicidlediscount,
      sum(basicidlecurrentpenalty) as basicidlecurrentpenalty,
      sum(basicidlepreviouspenalty) as basicidlepreviouspenalty,
      sum(shcurrent) as shcurrent,
      sum(shprevious) as shprevious,
      sum(shdiscount) as shdiscount,
      sum(shcurrentpenalty) as shcurrentpenalty,
      sum(shpreviouspenalty) as shpreviouspenalty,
      sum(firecode) as firecode,
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and revtype <> 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue

  union all  

  select 
      1 as idx,
      'BASIC' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(basiccurrentyear) as currentyear,
      sum(basicpreviousyear) as previousyear,
      sum(basicdiscount) as discount,
      sum(basicpenaltycurrent) as penaltycurrent,
      sum(basicpenaltyprevious) as penaltyprevious,
      sum(basicidlecurrent) as basicidlecurrent,
      sum(basicidleprevious) as basicidleprevious,
      sum(basicidlediscount) as basicidlediscount,
      sum(basicidlecurrentpenalty) as basicidlecurrentpenalty,
      sum(basicidlepreviouspenalty) as basicidlepreviouspenalty,
      sum(shcurrent) as shcurrent,
      sum(shprevious) as shprevious,
      sum(shdiscount) as shdiscount,
      sum(shcurrentpenalty) as shcurrentpenalty,
      sum(shpreviouspenalty) as shpreviouspenalty,
      sum(firecode) as firecode,
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail_eor 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and revtype <> 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue

  union all  

    select 
      2 as idx,
      'SEF' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(sefcurrentyear) as currentyear,
      sum(sefpreviousyear) as previousyear,
      sum(sefdiscount) as discount,
      sum(sefpenaltycurrent) as penaltycurrent,
      sum(sefpenaltyprevious) as penaltyprevious,
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
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and revtype = 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue

  union all 

select 
      2 as idx,
      'SEF' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(sefcurrentyear) as currentyear,
      sum(sefpreviousyear) as previousyear,
      sum(sefdiscount) as discount,
      sum(sefpenaltycurrent) as penaltycurrent,
      sum(sefpenaltyprevious) as penaltyprevious,
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
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail_eor 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and revtype = 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue        
) t
order by t.municityname, t.idx, t.orno 





[getAbstractOfRPTCollectionAdvance] 
select t.*
from (
    select 
      1 as idx,
      'BASIC' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(basiccurrentyear) as currentyear,
      sum(basicpreviousyear) as previousyear,
      sum(basicdiscount) as discount,
      sum(basicpenaltycurrent) as penaltycurrent,
      sum(basicpenaltyprevious) as penaltyprevious,
      sum(basicidlecurrent) as basicidlecurrent,
      sum(basicidleprevious) as basicidleprevious,
      sum(basicidlediscount) as basicidlediscount,
      sum(basicidlecurrentpenalty) as basicidlecurrentpenalty,
      sum(basicidlepreviouspenalty) as basicidlepreviouspenalty,
      sum(shcurrent) as shcurrent,
      sum(shprevious) as shprevious,
      sum(shdiscount) as shdiscount,
      sum(shcurrentpenalty) as shcurrentpenalty,
      sum(shpreviouspenalty) as shpreviouspenalty,
      sum(firecode) as firecode,
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and year > $P{year}
        and revtype <> 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue

  union all  

    select 
      2 as idx,
      'SEF' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(sefcurrentyear) as currentyear,
      sum(sefpreviousyear) as previousyear,
      sum(sefdiscount) as discount,
      sum(sefpenaltycurrent) as penaltycurrent,
      0 as penaltyprevious,
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
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and year > $P{year}
        and revtype = 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue

      union all 

select 
      1 as idx,
      'BASIC' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(basiccurrentyear) as currentyear,
      sum(basicpreviousyear) as previousyear,
      sum(basicdiscount) as discount,
      sum(basicpenaltycurrent) as penaltycurrent,
      sum(basicpenaltyprevious) as penaltyprevious,
      sum(basicidlecurrent) as basicidlecurrent,
      sum(basicidleprevious) as basicidleprevious,
      sum(basicidlediscount) as basicidlediscount,
      sum(basicidlecurrentpenalty) as basicidlecurrentpenalty,
      sum(basicidlepreviouspenalty) as basicidlepreviouspenalty,
      sum(shcurrent) as shcurrent,
      sum(shprevious) as shprevious,
      sum(shdiscount) as shdiscount,
      sum(shcurrentpenalty) as shcurrentpenalty,
      sum(shpreviouspenalty) as shpreviouspenalty,
      sum(firecode) as firecode,
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail_eor 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and year > $P{year}
        and revtype <> 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue

  union all  

    select 
      2 as idx,
      'SEF' as type,
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue,
      min(year) as minyear,
      min(fromqtr) as minqtr,
      max(year) as maxyear,
      max(toqtr) as maxqtr,
      sum(sefcurrentyear) as currentyear,
      sum(sefpreviousyear) as previousyear,
      sum(sefdiscount) as discount,
      sum(sefpenaltycurrent) as penaltycurrent,
      0 as penaltyprevious,
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
      sum(total) as total,
      max(partialled) as partialled
    from vw_landtax_abstract_of_collection_detail_eor 
    where ${filter} 
        and collectorid LIKE $P{collectorid} 
        and year > $P{year}
        and revtype = 'SEF'
    group by 
      liquidationid,
      liquidationdate,
      remittanceid,
      remittancedate,
      receiptid,
      ordate,
      orno,
      collectorid,
      rptledgerid,
      fullpin,
      titleno,
      cadastrallotno,
      rputype,
      totalmv,
      barangay,
      taxpayername,
      tdno,
      municityname,
      classification,
      assessvalue,
      assessedvalue
) t
order by t.municityname, t.idx, t.orno 





[getMuniCityByRemittance]
select 
  distinct t.* 
 from (
  select
    case when m.name is null then c.name else m.name end as municityname 
  from remittance rem 
    inner join cashreceipt cr on rem.objid = cr.remittanceid 
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on cr.objid = rp.receiptid
    inner join rptpayment_item cri on rp.objid = cri.parentid
    inner join rptledger rl on rp.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where rem.objid =  $P{remittanceid} 
 ) t 


[getAbstractOfRPTCollectionDetail]
select 
  c.objid,
  c.receiptno,
  c.receiptdate as ordate,
  case when cv.objid is null then c.paidby else '*** VOIDED ***' end as taxpayername, 
  case when cv.objid is null then c.amount else 0.0 end AS amount 
from cashreceipt c 
  inner join cashreceipt_rpt crpt on crpt.objid = c.objid
  left join cashreceipt_void cv on cv.receiptid  = c.objid 
where c.remittanceid=$P{remittanceid} 
  and cv.objid is null 
order by c.receiptno  


[getAbstractOfRPTCollectionDetailItem]
select
    b.name as barangay, rl.tdno, rl.cadastrallotno, rl.totalav as assessedavalue,
    rpi.year, rpi.qtr ,
    sum(rpi.basic) as basic, 
    sum(rpi.basicint) as basicint, 
    sum(rpi.basicdisc) as basicdisc, 
    sum(rpi.basicdp) as basicdp, 
    sum(rpi.basicnet) as basicnet,
    sum(rpi.sef) as sef, 
    sum(rpi.sefint) as sefint, 
    sum(rpi.sefdisc) as sefdisc, 
    sum(rpi.sefdp) as sefdp, 
    sum(rpi.sefnet) as sefnet,
    sum(rpi.basicidle) as basicidle, 
    sum(rpi.basicidleint) as basicidleint, 
    sum(rpi.basicidledisc) as basicidledisc, 
    sum(rpi.basicidledp) as basicidledp, 
    sum(rpi.basicidle + rpi.basicidledp) as basicidlenet,
    sum(rpi.basicidle + rpi.basicidledp) as idlenet,
    sum(rpi.sh) as sh, 
    sum(rpi.shint) as shint, 
    sum(rpi.shdisc) as shdisc, 
    sum(rpi.shdp) as shdp, 
    sum(rpi.shnet) as shnet,
    sum(rpi.firecode) as firecode,
    sum(rpi.amount) as total
from rptpayment rp
  inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
  inner join rptledger rl on rp.refid = rl.objid 
  inner join barangay b on b.objid = rl.barangayid 
where rp.receiptid = $P{objid}
group by 
    b.name, rl.tdno, rl.cadastrallotno, rl.totalav, rpi.year, rpi.qtr
order by b.name, rl.tdno, rl.cadastrallotno, rpi.year, rpi.qtr


[getAbstractOfRPTCollectionDetailItemAnnual]
select
    b.name as barangay, rl.tdno, rl.cadastrallotno, rl.totalav as assessedavalue,
    rpi.year, 0 as qtr, 
    sum(rpi.basic) as basic, 
    sum(rpi.basicint) as basicint, 
    sum(rpi.basicdisc) as basicdisc, 
    sum(rpi.basicdp) as basicdp, 
    sum(rpi.basicnet) as basicnet,
    sum(rpi.sef) as sef, 
    sum(rpi.sefint) as sefint, 
    sum(rpi.sefdisc) as sefdisc, 
    sum(rpi.sefdp) as sefdp, 
    sum(rpi.sefnet) as sefnet,
    sum(rpi.basicidle) as basicidle, 
    sum(rpi.basicidleint) as basicidleint, 
    sum(rpi.basicidledisc) as basicidledisc, 
    sum(rpi.basicidledp) as basicidledp, 
    sum(rpi.basicidle + rpi.basicidledp) as basicidlenet,
    sum(rpi.basicidle + rpi.basicidledp) as idlenet,
    sum(rpi.sh) as sh, 
    sum(rpi.shint) as shint, 
    sum(rpi.shdisc) as shdisc, 
    sum(rpi.shdp) as shdp, 
    sum(rpi.shnet) as shnet,
    sum(rpi.firecode) as firecode,
    sum(rpi.amount) as total
from rptpayment rp
  inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
  inner join rptledger rl on rp.refid = rl.objid 
  inner join barangay b on b.objid = rl.barangayid 
where rp.receiptid = $P{objid}
group by 
    b.name, rl.tdno, rl.cadastrallotno, rl.totalav, rpi.year
order by b.name, rl.tdno, rl.cadastrallotno, rpi.year


[getAbstractOfRPTCollectionSummary]
select 
	xx.*,
	case 
        when xx.basic > 0 and xx.basicint > 0 then round(xx.basicint / xx.basic, 2)
        when xx.basic > 0 and xx.basicdisc > 0 then round(xx.basicdisc / xx.basic, 2)
        else 0
    end as rate
from (
	select 
			x.receiptno,
			x.receiptdate,
			x.amount,
			x.barangay,
			x.tdno,
			x.assessedvalue,
			x.taxpayername,
			min(x.year) as fromyear,
			max(x.year) as toyear,
			sum(x.basic) as basic,
			sum(x.basicint) as basicint,
			sum(x.basicdisc) as basicdisc,
			sum(x.basicdp) as basicdp,
			sum(x.basicnet) as basicnet,
			sum(x.sef) as sef,
			sum(x.sefdisc) as sefdisc,
			sum(x.sefint) as sefint,
			sum(x.sefdp) as sefdp,
			sum(x.sefnet) as sefnet,
			sum(x.total) as total, 
			sum(x.basicidle) as basicidle,
			sum(x.basicidledisc) as basicidledisc,
			sum(x.basicidleint) as basicidleint,
      sum(x.sh) as sh,
      sum(x.shdisc) as shdisc,
      sum(x.shint) as shint,
			sum(x.shdp) as shdp,
			sum(x.shnet) as shnet
	from (
			select 
					c.receiptno,
					c.receiptdate,
					case when cv.objid is null then c.amount else 0 end as amount, 
					b.name as barangay,
					rl.tdno,
					rlf.assessedvalue,
					case when cv.objid is null then rl.owner_name else '*** VOIDED ***' end as taxpayername, 
					rpi.year, 
					sum(case when cv.objid is null then rpi.year else null end) as fromyear,
					sum(case when cv.objid is null then rpi.year else null end) as toyear, 
					sum(case when cv.objid is null then rpi.basic else null end) as basic,
					sum(case when cv.objid is null then rpi.basicdisc else null end) as basicdisc,
					sum(case when cv.objid is null then rpi.basicint else null end) as basicint,
					sum(case when cv.objid is null then rpi.basicdp else null end) as basicdp,
					sum(case when cv.objid is null then rpi.basicnet else null end) as basicnet,
					sum(case when cv.objid is null then rpi.sef else null end ) as sef,
					sum(case when cv.objid is null then rpi.sefdisc else null end ) as sefdisc,
					sum(case when cv.objid is null then rpi.sefint else null end ) as sefint,
					sum(case when cv.objid is null then rpi.sefdp else null end) as sefdp,
					sum(case when cv.objid is null then rpi.sefnet else null end) as sefnet, 
					sum(case when cv.objid is null then rpi.basicidle else null end) as basicidle, 
					sum(case when cv.objid is null then rpi.basicidleint else null end) as basicidleint, 
					sum(case when cv.objid is null then rpi.basicidledisc else null end) as basicidledisc,
          sum(case when cv.objid is null then rpi.sh else null end ) as sh,
					sum(case when cv.objid is null then rpi.shdisc else null end ) as shdisc,
					sum(case when cv.objid is null then rpi.shint else null end ) as shint,
					sum(case when cv.objid is null then rpi.shdp else null end) as shdp,
					sum(case when cv.objid is null then rpi.shnet else null end) as shnet,
					sum(case when cv.objid is null then rpi.amount else null end) as total
			from cashreceipt c 
					inner join cashreceipt_rpt crpt on crpt.objid = c.objid
					inner join rptpayment rp on c.objid = rp.receiptid
					inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
					inner join rptledger rl on rp.refid = rl.objid 
					inner join barangay b on rl.barangayid = b.objid 
					inner join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
					left join cashreceipt_void cv on cv.receiptid  = c.objid 
			where c.remittanceid = $P{remittanceid} 
					and cv.objid is null 
			group by 
					c.receiptno,
					c.receiptdate,
					case when cv.objid is null then c.amount else 0 end, 
					b.name,
					rl.tdno,
					rlf.assessedvalue,
					rl.owner_name,
					rpi.year,
					cv.objid
	) x 
	group by 
			x.receiptno,
			x.receiptdate,
			x.amount,
			x.barangay,
			x.tdno,
			x.assessedvalue,
			x.taxpayername    
) xx
order by xx.receiptno, xx.tdno, xx.fromyear

