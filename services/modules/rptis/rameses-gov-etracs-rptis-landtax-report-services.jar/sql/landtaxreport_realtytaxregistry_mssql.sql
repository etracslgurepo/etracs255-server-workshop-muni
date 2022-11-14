[findLedgerInfo]
select 
    e.entityno, e.name, e.address_text AS address,  
    pc.code AS classcode, 
    rl.*
from rptledger rl 
    left join entity e on rl.taxpayer_objid = e.objid 
    left join propertyclassification pc on rl.classification_objid = pc.objid 
where rl.objid = $P{objid}



[getLedgerCredits]
select 
    rp.receiptno as refno,
    rp.receiptdate as refdate,
    case when cr.collector_name is null then rp.postedby else cr.collector_name end as collector_name,
    case when cr.paidby is null then convert(varchar(800), rp.paidby_name) else cr.paidby end as paidby_name,
    rp.fromyear,
    rp.fromqtr,
    rp.toyear,
    rp.toqtr,
    rp.type as mode,
    rpi.partialled,
    case when rlf.objid is null then rl.tdno else rlf.tdno end as tdno,
    rlf.assessedvalue,
    sum(rpi.basic) as basic,
    sum(rpi.basicint) as basicint,
    sum(rpi.basicdisc) as basicdisc,
    sum(rpi.basicidle - rpi.basicidledisc + rpi.basicidleint) as basicidle,
    sum(rpi.sef) as sef,
    sum(rpi.sefint) as sefint,
    sum(rpi.sefdisc) as sefdisc,
    sum(rpi.firecode) as firecode,
    sum(rpi.sh - rpi.shdisc + rpi.shint) as sh,
    sum(rpi.basic+ rpi.basicint - rpi.basicdisc + 
        rpi.basicidle - rpi.basicidledisc + rpi.basicidleint +
        rpi.sef + rpi.sefint - rpi.sefdisc + 
        rpi.sh + rpi.shint - rpi.shdisc + rpi.firecode) as amount
from rptpayment rp 
    inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
    inner join rptledger rl on rp.refid = rl.objid 
    left join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
    left join cashreceipt cr on rp.receiptid = cr.objid 
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
where rp.refid = $P{objid}
    and cv.objid is null    
    and rp.voided = 0
group by 
    rp.receiptno,
    rp.receiptdate,
    rlf.objid,
    rl.tdno, 
    cr.collector_name,
    cr.paidby,
    rp.fromyear,
    rp.fromqtr,
    rp.toyear,
    rp.toqtr,
    rp.type,
    rpi.partialled,
    rlf.tdno,
    rlf.assessedvalue,
    rp.postedby,
    convert(varchar(800), rp.paidby_name)
order by rp.receiptdate
    

[findRptar]    
select 
    rl.fullpin,
    rl.titleno,
    rl.cadastrallotno,
    rl.blockno,
    rl.classcode,
    rl.rputype,
    rl.totalmv,
    rl.totalav,
    rl.totalareaha,
    rl.totalareaha * 10000 as totalareasqm,
    rl.administrator_name,
    f.administrator_address,
    b.name as barangay,
    case when c.objid is not null then c.name else m.name end as lgu,
    p.name as province,
    rp.street
from rptledger rl 
left join faas f on rl.faasid = f.objid 
left join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rl.barangayid = b.objid 
left join municipality m on b.parentid = m.objid 
left join province p on m.parentid = p.objid 
left join district d on b.parentid = d.objid 
left join city c on d.parentid = c.objid 
where rl.objid = $P{objid}


[getOwnerships]
select distinct 
    f.owner_name,
    f.owner_address,
    f.dtapproved
from rptledger rl 
inner join rptledgerfaas rlf on rl.objid = rlf.rptledgerid 
inner join faas f on rlf.faasid = f.objid 
where rl.objid = $P{objid}
order by f.dtapproved 


[getPayments]
select 
    x.tdno, 
    x.assessedvalue,
    x.taxyear,
    x.receiptno,
    x.receiptdate,
    x.paidby_name,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.firecode) as firecode,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc
from ( 
    select 
        rlf.tdno,
        rlf.assessedvalue,
        rpi.year as taxyear,
        rp.receiptno,
        rp.receiptdate,
        convert(varchar(800), rp.paidby_name) as paidby_name,
        rpi.basic,
        rpi.basicint,
        rpi.basicdisc,
        rpi.sef, 
        rpi.sefint,
        rpi.sefdisc,
        rpi.basicidle,
        rpi.basicidleint,
        rpi.basicidledisc,
        rpi.firecode,
        rpi.sh,
        rpi.shint,
        rpi.shdisc
    from rptledger rl 
    inner join rptpayment rp on rl.objid = rp.refid 
    inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
    inner join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
    where rl.objid = $P{objid} 
    and rp.voided = 0
) x 
group by 
    x.tdno, 
    x.assessedvalue,
    x.taxyear,
    x.receiptno,
    x.receiptdate,
    x.paidby_name
order by x.taxyear 

