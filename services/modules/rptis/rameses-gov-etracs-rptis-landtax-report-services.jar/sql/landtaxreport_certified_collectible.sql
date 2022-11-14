[getList]
select 
	x.*,
	case when x.rputype = 'land' then x.totalav else null end as landav,
	case when x.rputype = 'mach' then x.totalav else null end as machav,
	case when x.rputype not in ('land','mach') then x.totalav else null end as improvav
from (
	select 
		e.name as owner, 
		case when rp.pin is null then rl.fullpin else rp.pin end as pin, 
		rl.fullpin,
		rl.tdno,
		rl.classcode,
		rl.cadastrallotno,
		b.name as barangay, 
		rl.rputype, 
		r.suffix, 
		(select max(assessedvalue) from rptledgerfaas 
		 where rptledgerid = rl.objid 
			 and $P{year} >= fromyear 
			 and ($P{year} <= toyear or toyear = 0)
			and state = 'APPROVED' 
			and taxable = 1 
		 ) as totalav
	from rptledger rl 
		inner join entity e on rl.taxpayer_objid = e.objid 
		inner join barangay b on rl.barangayid = b.objid 
		left join faas f on rl.faasid = f.objid 
		left join rpu r on f.rpuid = r.objid 
		left join realproperty rp on f.realpropertyid = rp.objid 
	where rl.state = 'APPROVED' 
	and (f.objid is null or f.state = 'CURRENT')
    and rl.totalav > 0 
    and rl.taxable = 1
    and rl.barangayid like $P{barangayid}
    and not exists(select * from faas_restriction where ledger_objid = rl.objid and state='ACTIVE')
    and not exists(select * from rptledger_subledger where objid = rl.objid)
)x
where x.totalav > 0
order by x.pin, x.suffix 



[getBarangayCollectibles]
select 
	x.pin, 
	x.barangay, 
	sum(x.totalav) as totalav,
	0 as basicpmt,
	0 as basicdisctaken,
	0 as basicintpmt,
	0 as sefpmt,
	0 as sefdisctaken,
	0 as sefintpmt
from (
	select 
		b.pin, 
		b.name as barangay, 
		(select max(assessedvalue) from rptledgerfaas 
		 where rptledgerid = rl.objid 
			 and $P{year} >= fromyear 
			 and ($P{year} <= toyear or toyear = 0)
			and state = 'APPROVED' 
			and taxable = 1 
		 ) as totalav
	from rptledger rl 
		inner join entity e on rl.taxpayer_objid = e.objid 
		inner join barangay b on rl.barangayid = b.objid 
		left join faas f on rl.faasid = f.objid 
		left join rpu r on f.rpuid = r.objid 
		left join realproperty rp on f.realpropertyid = rp.objid 
	where rl.lguid = $P{lguid}
	and rl.state = 'APPROVED' 
	and (f.objid is null or f.state = 'CURRENT')
    and rl.totalav > 0 
    and rl.taxable = 1
    and rl.barangayid like $P{barangayid}
    and not exists(select * from faas_restriction where ledger_objid = rl.objid and state='ACTIVE')
    and not exists(select * from rptledger_subledger where objid = rl.objid)
)x
where x.totalav > 0
group by x.pin, x.barangay 
order by x.pin 


[getBarangayPayments]
select 
	x.pin, 
	x.barangay, 
	sum(x.basicpmt) as basicpmt,
	sum(x.basicdisctaken) as basicdisctaken,
	sum(x.basicintpmt) as basicintpmt,
	sum(x.sefpmt) as sefpmt,
	sum(x.sefdisctaken) as sefdisctaken,
	sum(x.sefintpmt) as sefintpmt
from (
	select 
		b.pin, 
		b.name as barangay, 
		(case when rpi.revtype = 'basic' then rpi.amount - rpi.discount else 0 end) as basicpmt,
		(case when rpi.revtype = 'basic' then rpi.discount else 0 end) as basicdisctaken,
		(case when rpi.revtype = 'basic' then rpi.interest else 0 end) as basicintpmt,
		(case when rpi.revtype = 'sef' then rpi.amount - rpi.discount else 0 end) as sefpmt,
		(case when rpi.revtype = 'sef' then rpi.discount else 0 end) as sefdisctaken,
		(case when rpi.revtype = 'sef' then rpi.interest else 0 end) as sefintpmt
	from rptledger rl 
		inner join barangay b on rl.barangayid = b.objid 
		inner join rptpayment rp on rl.objid = rp.refid
		inner join rptpayment_item rpi on rp.objid = rpi.parentid
	where rl.lguid = $P{lguid}
	and rl.state = 'APPROVED' 
	and rl.taxable = 1 
	and not exists(select * from faas_restriction where ledger_objid = rl.objid and state='ACTIVE')
	and not exists(select * from rptledger_subledger where objid = rl.objid)
	and rp.voided = 0
	and rpi.year = $P{year}
)x
group by x.pin, x.barangay 
order by x.pin 




