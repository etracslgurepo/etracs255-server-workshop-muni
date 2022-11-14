[getClassifications]
select * from propertyclassification order by orderno 

[getList]
select
    rrd.dtgenerated,
    b.name as barangay,
    b.pin, 
    count(distinct rptledgerid) as rpucount,
    sum(rrd.basic) as basic, 
    sum(rrd.basicdisc) as basicdisc,
    sum(rrd.basicint) as basicint,
    sum(rrd.sef) as sef,
    sum(rrd.sefdisc) as sefdisc,
    sum(rrd.sefint) as sefint,
    sum(rrd.basic - rrd.basicdisc + rrd.basicint + rrd.sef - rrd.sefdisc + rrd.sefint) as total 
from vw_landtax_report_rptdelinquency rrd 
    inner join rptledger rl on rrd.rptledgerid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
where rl.classification_objid like $P{classid}
and rl.rputype like $P{type}
and rl.taxable = 1 
group by rrd.dtgenerated, b.name, b.pin  
order by b.pin 
