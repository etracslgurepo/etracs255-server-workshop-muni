[findInfo]
SELECT * FROM rpttaxclearance WHERE objid = $P{objid}

[insertTaxClearance]
INSERT INTO rpttaxclearance 
	(objid, year, qtr, reporttype)
VALUES 
	($P{objid}, $P{year}, $P{qtr}, $P{reporttypename})


[getItems]
SELECT 
	rci.*,
	rl.objid as rptledgerid, 
	rl.faasid,
	rl.tdno,
	rl.rputype,
	rl.fullpin ,
	rl.totalareaha,
	rl.totalareaha * 10000 as totalareasqm,
	rl.totalmv,
	rl.totalav,
	rl.cadastrallotno,
	rl.blockno,
	rl.administrator_name,
	f.administrator_address, 
	case when m.objid is not null then m.name else c.name end as lguname, 
	b.name AS barangay,
	rl.classcode,
	pc.name as classification, 
	rl.titleno,
	rl.taxable,
	rp.surveyno,
	f.effectivityyear
FROM rptcertificationitem rci 
	INNER JOIN rptledger rl ON rci.refid = rl.objid 
	INNER JOIN barangay b ON rl.barangayid = b.objid
	left JOIN propertyclassification pc ON rl.classification_objid = pc.objid  
	LEFT JOIN municipality m on b.parentid = m.objid
	LEFT JOIN district d on b.parentid = d.objid 
	LEFT JOIN city c on d.parentid = c.objid 
	LEFT JOIN faas f on rl.faasid = f.objid 
	LEFT JOIN realproperty rp on f.realpropertyid = rp.objid 
WHERE rci.rptcertificationid = $P{rptcertificationid}



[getClearedLedgers]
SELECT 
	rl.objid AS refid,
	rl.lastyearpaid,
	rl.lastqtrpaid,
	rl.tdno,
	rl.rputype,
	rl.fullpin ,
	rl.taxable,
	rl.totalareaha,
	rl.totalmv,
	rl.totalav,
	rl.cadastrallotno,
	b.name AS barangay,
	rl.classcode,
	rl.titleno
FROM rptledger rl
	INNER JOIN barangay b ON rl.barangayid = b.objid 
WHERE rl.state = 'APPROVED'
  AND rl.taxpayer_objid = $P{taxpayerid}
  AND ( rl.lastyearpaid > $P{year} OR (rl.lastyearpaid = $P{year} AND rl.lastqtrpaid >= $P{qtr}))
  AND not exists(select * from rptledger_subledger where objid = rl.objid)
  AND not exists(select * from rptcompromise where rptledgerid = rl.objid and state = 'APPROVED')



[getPaymentInfo]
SELECT 
    rl.objid AS rptledgerid, 
    rp.receiptno AS orno,
    rp.receiptdate AS ordate,
    SUM(ri.amount + ri.interest - ri.discount) AS oramount,
    SUM(CASE WHEN ri.revtype = 'basic' THEN ri.amount ELSE 0 END) AS basic,
    SUM(CASE WHEN ri.revtype = 'basic' THEN ri.discount ELSE 0 END) AS basicdisc,
    SUM(CASE WHEN ri.revtype = 'basic' THEN ri.interest ELSE 0 END) AS basicint,
    SUM(CASE WHEN ri.revtype = 'sef' THEN ri.amount ELSE 0 END) AS sef,
    SUM(CASE WHEN ri.revtype = 'sef' THEN ri.discount ELSE 0 END) AS sefdisc,
    SUM(CASE WHEN ri.revtype = 'sef' THEN ri.interest ELSE 0 END) AS sefint,
    MIN(case when ri.qtr is null then 1 else ri.qtr end) as minqtr,
    MAX(case when ri.qtr is null then 4 else ri.qtr end) as maxqtr,
    ri.year
FROM rptcertificationitem rci 
    INNER JOIN rptledger rl ON rci.refid = rl.objid 
    INNER JOIN rptpayment rp ON rl.objid = rp.refid
    INNER JOIN rptpayment_item ri ON rp.objid = ri.parentid
    LEFT JOIN cashreceipt_void cv ON rp.receiptid = cv.receiptid 
WHERE rci.rptcertificationid = $P{rptcertificationid}
    AND rl.objid =  $P{rptledgerid}
   and (ri.year = $P{year} and (ri.qtr <= $P{qtr} or ri.qtr is null))
  AND cv.objid IS NULL 
GROUP BY rl.objid, rp.receiptno, rp.receiptdate, ri.year


[findPaidClearance]
select objid, txnno
from rptcertification 
where orno = $P{orno}


[getTaxClearancesIssued]
select 
	c.objid,
	c.txnno,
	c.txndate,
	c.taxpayer_objid,
	c.requestedby,
	c.requestedbyaddress,
	c.purpose,
	c.official,
	c.orno,
	c.ordate,
	c.oramount,
	t.year, 
	t.qtr 
from rpttaxclearance t 
inner join rptcertification c on t.objid = c.objid 
inner join rptcertificationitem i on c.objid = i.rptcertificationid
where i.refid = $P{objid}
order by c.txndate desc 

