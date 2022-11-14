[getLedgerIdsByBrgy]
select 
	rl.objid, rl.tdno, rl.taxpayer_objid, e.name as taxpayer_name, e.address_text as taxpayer_address
from rptledger rl
	inner join entity e on rl.taxpayer_objid = e.objid 
where rl.barangayid = $P{barangayid}
	and rl.state = 'APPROVED'
	and (rl.lastyearpaid < $P{billtoyear} or 
		(rl.lastyearpaid = $P{billtoyear} and rl.lastqtrpaid = $P{billtoqtr})
	)
order by rl.tdno 


[getLedgerIdsBySection]
select 
	rl.objid, rl.tdno, rl.taxpayer_objid, e.name as taxpayer_name, e.address_text as taxpayer_address
from rptledger rl
	inner join entity e on rl.taxpayer_objid = e.objid 
	inner join faas f on rl.faasid = f.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
where rl.barangayid = $P{barangayid}
    and rl.state = 'APPROVED'
	and (rl.lastyearpaid < $P{billtoyear} or 
		(rl.lastyearpaid = $P{billtoyear} and rl.lastqtrpaid = $P{billtoqtr})
	)
	and rp.section = $P{section}
order by rl.tdno 