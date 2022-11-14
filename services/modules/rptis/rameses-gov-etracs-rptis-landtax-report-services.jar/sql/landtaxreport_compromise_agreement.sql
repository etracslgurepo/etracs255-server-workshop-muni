[getActiveAgreements]
select 
    rc.txnno, rc.txndate, 
    rc.startyear, rc.startqtr, 
    rc.endyear, rc.endqtr,
    rc.amount,
    rc.downpayment,
    rc.amtforinstallment,
    rc.amtpaid,
    rc.numofinstallment,
    rc.term,
    rc.cypaymentoramount,
    rc.firstpartyname,
    rc.secondpartyname,
    rc.notarizeddate,
    rl.owner_name, 
    rl.administrator_name,
    rl.tdno,
    rl.fullpin,
    rl.cadastrallotno,
    rl.totalav,
    rl.totalmv, 
    rl.totalareaha,
    rl.totalareaha * 10000.0 as totalareasqm,
    rl.classcode
from rptcompromise rc 
inner join rptledger rl on rc.rptledgerid = rl.objid 
inner join barangay b on rl.barangayid = b.objid 
where rc.state = 'APPROVED'
and rl.barangayid like $P{barangayid}
and b.parentid in (
    select objid from municipality where objid like $P{lguid}
    union all 
    select d.objid from city c, district d where c.objid = d.parentid and c.objid like $P{lguid}
)
order by rc.txnno 