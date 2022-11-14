[getList]
select 
	b.name as barangay,
	fl.owner_name,
	fl.owner_address,
	fl.tdno,
	fl.displaypin as pin,
  fl.cadastrallotno,
	a.assessmentyear
from assessmentnotice a 
	inner join assessmentnoticeitem ai on ai.assessmentnoticeid = a.objid
	inner join faas_list fl on fl.objid = ai.faasid
	inner join rpu r on r.objid = fl.rpuid 
	inner join barangay b on fl.barangayid = b.objid 
where a.txndate >= $P{startdate}
and a.txndate < $P{enddate}
and r.taxable = 1
order by b.name, fl.owner_name, fl.tdno
