[getList]
select 
	pp.*, 
	e.entityno as taxpayer_acctno, 
	e.name as taxpayer_name,
	e.address_text as taxpayer_addresstext 
from propertypayer pp
	inner join entity e on pp.taxpayer_objid = e.objid 
where e.entityname like $P{searchtext}
order by e.entityname


[findById]
select 
	pp.*, 
	e.entityno as taxpayer_acctno, 
	e.name as taxpayer_name,
	e.address_text as taxpayer_addresstext 
from propertypayer pp
	inner join entity e on pp.taxpayer_objid = e.objid 
where pp.objid = $P{objid}


[findByTaxpayer]
select * from propertypayer where taxpayer_objid = $P{objid}



[deleteItems]
delete from propertypayer_item where parentid = $P{objid}


[getItems]
select 
	ppi.*,
	rl.tdno as rptledger_tdno, 
	rl.owner_name, 
	rl.prevtdno as rptledger_prevtdno, 
	rl.fullpin as rptledger_fullpin,
	rl.rputype as rptledger_rputype,
	rl.cadastrallotno as rptledger_cadastrallotno,
	rl.titleno as rptledger_titleno,
	rl.classcode as rptledger_classcode,
	rl.totalareaha as rptledger_totalareaha,
	rl.totalmv as rptledger_totalmv,
	rl.totalav as rptledger_totalav,
	rl.lastyearpaid as rptledger_lastyearpaid,
	rl.lastqtrpaid as rptledger_lastqtrpaid,
	b.name as rptledger_barangay_name
from propertypayer_item ppi 
	inner join rptledger rl on ppi.rptledger_objid = rl.objid 
	inner join barangay b on rl.barangayid = b.objid 
where ppi.parentid = $P{objid}
order by rl.tdno 


[findItemByLedger]
select * from propertypayer_item where rptledger_objid = $P{rptledgerid}