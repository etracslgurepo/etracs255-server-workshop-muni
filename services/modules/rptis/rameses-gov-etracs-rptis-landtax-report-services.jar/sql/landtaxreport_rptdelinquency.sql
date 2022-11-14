[getDelinquentLedgers]
SELECT 
	e.name AS taxpayername,
	e.address_text AS taxpayeraddress,
	rl.administrator_name, 
	rl.fullpin AS pin,
	rl.tdno,
	rl.classcode,
	rl.cadastrallotno,
	rl.rputype,
	rl.totalav, 
	rl.totalareaha,
	rl.totalareaha * 10000 as totalareasqm,
	b.name AS barangay, b.objid, 
	x.* 
FROM ( 
	SELECT 
		rptledgerid, MAX(dtgenerated) AS dtgenerated, 
		MIN(year) AS startyearpaid, MIN(qtr) as startqtrpaid, 
		MAX(year) AS lastyearpaid, MAX(4) AS lastqtrpaid,  
		SUM(basic - basicdisc) AS basic, SUM(sef - sefdisc) AS sef, 
		SUM(basicint) AS basicint, SUM(sefint) AS sefint, 
		SUM(basic - basicdisc + basicint) AS basicnet,
		SUM(sef - sefdisc + sefint) AS sefnet,
		SUM(basic - basicdisc + basicint  + sef - sefdisc + sefint ) AS total
	FROM vw_landtax_report_rptdelinquency_detail r
	INNER JOIN rptledger rl on r.rptledgerid = rl.objid 
	WHERE r.barangayid LIKE $P{barangayid} 
	AND rl.taxpayer_objid LIKE $P{taxpayerid}
	AND NOT EXISTS(select * from faas_restriction where ledger_objid = r.rptledgerid and state='ACTIVE')
	AND NOT EXISTS(select * from rptledger_subledger where objid = r.rptledgerid)
	${filter} 
	GROUP BY rptledgerid 
)x 
	INNER JOIN rptledger rl ON x.rptledgerid = rl.objid 
	INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
	INNER JOIN barangay b ON rl.barangayid = b.objid 
ORDER BY ${orderby} 


[getDelinquentLedgers2]
SELECT 
	e.name AS taxpayername,
	e.address_text AS taxpayeraddress,
	rl.administrator_name, 
	rl.fullpin AS pin,
	rl.tdno,
	rl.classcode,
	rl.cadastrallotno,
	rl.rputype,
	rl.totalav, 
	rl.totalareaha,
	rl.totalareaha * 10000 as totalareasqm,
	b.name AS barangay, b.objid, 
	x.endyear - x.startyear + 1 as numyears,
	x.* 
FROM ( 
	SELECT 
		rptledgerid, 
		MAX(dtgenerated) AS dtgenerated, 
		case when year = $P{year} then 'A. CURRENT' else 'B. PREVIOUS' end as revperiod, 
		MIN(year) AS startyear, 
		MAX(year) AS endyear,
		SUM(basic) AS basic, SUM(sef) AS sef, 
		SUM(basicint) AS basicint, SUM(sefint) AS sefint, 
		SUM(basicdisc) as basicdisc, SUM(sefdisc) as sefdisc,
		SUM(basic - basicdisc + basicint  + sef - sefdisc + sefint ) AS total
	FROM vw_landtax_report_rptdelinquency_detail r
	INNER JOIN rptledger rl on r.rptledgerid = rl.objid 
	WHERE r.barangayid LIKE $P{barangayid} 
	AND NOT EXISTS(select * from faas_restriction where ledger_objid = r.rptledgerid and state='ACTIVE')
	AND NOT EXISTS(select * from rptledger_subledger where objid = r.rptledgerid)
	AND rl.taxpayer_objid like $P{taxpayerid}
	${filter} 
	GROUP BY rptledgerid, case when year = $P{year} then 'A. CURRENT' else 'B. PREVIOUS' end
)x 
	INNER JOIN rptledger rl ON x.rptledgerid = rl.objid 
	INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
	INNER JOIN barangay b ON rl.barangayid = b.objid
ORDER BY b.name, x.revperiod, (x.endyear - x.startyear + 1) desc, e.name  



[getDelinquentLedgers3]
select 
	e.name as taxpayer_name, 
	t.* 
from (
	select 
		rd.dtgenerated,
		b.name as barangay, 
		rl.taxpayer_objid, 
		rl.objid as rptledgerid,
		rl.rputype, 
		rlf.tdno, 
		pc.code as classcode, 
		rlf.assessedvalue as av, 
		min(rlf.fromyear) as fromyear, 
		max(case when rlf.toyear = 0 then $P{toyear} else rlf.toyear end) as toyear,
		sum(basic) as basic, 
		sum(basicint) as basicint, 
		sum(basic + basicint - basicdisc) as basicnet,
		sum(sef) as sef, 
		sum(sefint) as sefint,
		sum(sef + sefint - sefdisc) as sefnet 
	from vw_landtax_report_rptdelinquency_detail rd 
		inner join rptledger rl on rd.rptledgerid = rl.objid 
		inner join barangay b on rl.barangayid = b.objid 
		inner join rptledgerfaas rlf on rd.rptledgerid = rlf.rptledgerid
		inner join propertyclassification pc on rlf.classification_objid = pc.objid 
	where rd.barangayid LIKE $P{barangayid} 
	 and not exists(select * from faas_restriction where ledger_objid = rd.rptledgerid and state='ACTIVE')
	 AND NOT EXISTS(select * from rptledger_subledger where objid = rd.rptledgerid)
	 and rd.year >= rlf.fromyear 
	 and (rd.year <= rlf.toyear or rlf.toyear = 0 )
	 and rlf.state = 'APPROVED' 
	 and rl.classification_objid like $P{classificationid}
	 and rl.taxpayer_objid like $P{taxpayerid}
	 ${filter} 
	group by 
		rd.dtgenerated,
		b.name, 
		rl.taxpayer_objid, 
		rl.objid,
		rl.rputype, 
		rlf.tdno, 
		pc.code,
		rlf.assessedvalue
) t 
	inner join entity e on t.taxpayer_objid = e.objid 
order by 
	e.name, t.fromyear 


[getDelinquentLedgersSummary]
SELECT 
	dtgenerated, barangayid, barangay_name, barangay_pin, 
	SUM(basic) as basic, SUM(sef) as sef, 
	SUM(basicint) AS basicint, SUM(sefint) AS sefint, 
	SUM(basicnet) AS basicnet, SUM(sefnet) AS sefnet, 
	SUM(total) AS total 
FROM ( 
	SELECT 
		barangayid, year, MAX(dtgenerated) AS dtgenerated, 
		SUM(basic - basicdisc) AS basic, SUM(sef - sefdisc) AS sef, 
		SUM(basicint) AS basicint, SUM(sefint) AS sefint, 
		SUM(basic - basicdisc + basicint) AS basicnet, 
		SUM(sef - sefdisc + sefint) AS sefnet, 
		SUM(basic - basicdisc + basicint  + sef - sefdisc + sefint ) AS total, 
		(select name from barangay where objid=rr.barangayid) as barangay_name, 
		(select pin from barangay where objid=rr.barangayid) as barangay_pin 
	FROM vw_landtax_report_rptdelinquency_detail rr 
	WHERE NOT EXISTS(select * from faas_restriction where ledger_objid = rr.rptledgerid and state='ACTIVE')
	AND NOT EXISTS(select * from rptledger_subledger where objid = rr.rptledgerid)
	${filter} 
	GROUP BY barangayid, year  
)x 
GROUP BY dtgenerated, barangayid, barangay_name, barangay_pin 
ORDER BY barangay_pin  


[getDelinquentLedgersByClassification]
SELECT 
	max(x.dtgenerated) as dtgenerated, 
	x.barangayid, 
	x.barangay_name,
	x.classification,
	x.idx,
	sum(amount) as amount 
FROM ( 
	SELECT 
		rr.barangayid, 
		(select name from barangay where objid=rr.barangayid) as barangay_name, 
		case when pc.special = 0 then pc.name else 'SPECIAL' end as classification,
		case when pc.special = 0 then pc.orderno else 1000 end as idx,
		year, dtgenerated,
		(basic - basicdisc + basicint  + sef - sefdisc + sefint) AS amount
	FROM vw_landtax_report_rptdelinquency_detail rr 
		inner join rptledger rl on rr.rptledgerid = rl.objid 
		inner join propertyclassification pc on rl.classification_objid = pc.objid 
	where NOT EXISTS(select * from faas_restriction where ledger_objid = rr.rptledgerid and state='ACTIVE')
	and  NOT EXISTS(select * from rptledger_subledger where objid = rr.rptledgerid )
	${filter} 
)x 
GROUP BY dtgenerated, barangayid, barangay_name, classification, idx 
ORDER BY barangay_name, idx 


[getDelinquentLedgersByClassificationDetailed]
SELECT 
	x.dtgenerated, 
	x.classification,
	x.idx,
	x.barangayid, 
	x.barangay_pin,
	x.barangay_name,
	sum(x.landav) as landav,
	sum(x.improvav) as improvav,
	sum(x.machav) as machav,
	sum(basic - basicdisc) as basic, 
	sum(basicint) as basicint, 
	sum(sef - sefdisc) as sef, 
	sum(sefint) as sefint
FROM ( 
	SELECT 
		year, dtgenerated,
		rr.barangayid, 
		b.pin as barangay_pin, 
		b.name as barangay_name, 
		case when pc.objid is null then 'UNMAPPED' else pc.name end as classification,
		case when pc.objid is null then 10000 else pc.orderno end as idx, 
		case when rl.rputype = 'land' then rl.totalav else 0 end as landav,
		case when rl.rputype not in ('land', 'mach') then rl.totalav else 0 end as improvav,
		case when rl.rputype = 'mach' then rl.totalav else 0 end as machav,
		rr.basic,
		rr.basicdisc,
		rr.basicint, 
		rr.sef, 
		rr.sefdisc,
		rr.sefint
	FROM vw_landtax_report_rptdelinquency_detail rr 
		inner join rptledger rl on rr.rptledgerid = rl.objid 
		inner join barangay b on rl.barangayid = b.objid 
		left join propertyclassification pc on rl.classification_objid = pc.objid 
	where 1=1 ${filter}
	and NOT EXISTS(select * from faas_restriction where ledger_objid = rr.rptledgerid and state='ACTIVE')
	and NOT EXISTS(select * from rptledger_subledger where objid = rr.rptledgerid)
)x 
GROUP BY x.dtgenerated, x.classification, x.idx, x.barangayid, x.barangay_pin, x.barangay_name
ORDER BY x.idx, x.barangay_pin


[findLatestPayment]
select x.*
from (
    select c.receiptno, c.receiptdate
    from cashreceipt c 
        inner join rptpayment rp on c.objid = rp.receiptid 
        left join cashreceipt_void cv on c.objid = cv.receiptid
    where rp.refid = $P{rptledgerid}
    and cv.objid is null 
    and c.receiptdate < $P{dtgenerated}

    union 

    select refno as receiptno, refdate as receiptdate
    from rptledger_credit 
    where rptledgerid = $P{rptledgerid}
    and refdate < $P{dtgenerated}
)x
order by x.receiptdate desc 



[getCertifiedList]
select 
	dtgenerated, classid, classname, 
	case when special=0 then classname else concat('SPECIAL CLASS - ',classname) end as classification,  
	special, classindexno, barangayid, barangayname, barangayindexno, 
	sum(landav) as landav, sum(machav) as machav, sum(impav) as impav, sum(annualtax) as annualtax, 
	sum(basic) as basic, sum(basicint) as basicint, sum(basictotal) as basictotal, 
	sum(sef) as sef, sum(sefint) as sefint, sum(seftotal) as seftotal, sum(grandtotal) as grandtotal 
from ( 
	select 
		xx.dtgenerated, rl.classification_objid as classid, pc.name as classname, pc.orderno as classindexno, pc.special, 
		xx.barangayid, brgy.name as barangayname, brgy.indexno as barangayindexno, 
		xx.annualtax, xx.basic, xx.basicint, xx.basictotal, xx.sef, xx.sefint, xx.seftotal, xx.grandtotal, 
		(case when rl.rputype='land' then rl.totalav else 0.0 end) as landav, 
		(case when rl.rputype='mach' then rl.totalav else 0.0 end) as machav, 
		(case when rl.rputype in ('bldg','misc','planttree') then rl.totalav else 0.0 end) as impav 
	from ( 
		select 
			rpt.dtgenerated, rpt.barangayid, rpt.rptledgerid, sum(rpt.basic - rpt.basicdisc + rpt.sef - rpt.sefdisc) as annualtax, 
			sum(rpt.basic - rpt.basicdisc) as basic, sum(rpt.basicint) as basicint, sum(rpt.basic - rpt.basicdisc + rpt.basicint) as basictotal,
			sum(rpt.sef - rpt.sefdisc) as sef, sum(rpt.sefint) as sefint, sum(rpt.sef - rpt.sefdisc + rpt.sefint) as seftotal,  
			sum(rpt.basic - rpt.basicdisc + rpt.basicint + rpt.sef - rpt.sefdisc + rpt.sefint) as grandtotal 
		from vw_landtax_report_rptdelinquency_detail rpt 
		where 1=1 ${filter} 
		and NOT EXISTS(select * from faas_restriction where ledger_objid = rpt.rptledgerid and state='ACTIVE')
		and NOT EXISTS(select * from rptledger_subledger where objid = rpt.rptledgerid)
		group by rpt.dtgenerated, rpt.barangayid, rpt.rptledgerid 
	)xx 
		inner join rptledger rl on xx.rptledgerid=rl.objid 
		inner join barangay brgy on xx.barangayid=brgy.objid 
		left join propertyclassification pc on rl.classification_objid=pc.objid 
	where rl.state='APPROVED' 
)xx 
group by dtgenerated, classid, classname, special, classindexno, barangayid, barangayname, barangayindexno 
order by special, classindexno, classname, barangayindexno 
