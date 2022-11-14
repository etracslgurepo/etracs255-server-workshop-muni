[getBarangays]
select 
	x.objid,
	x.barangay, 
	sum(x.forpostingcount) as forpostingcount,
	sum(x.errorcount) as errorcount,
	sum(x.postedcount) as postedcount
from (

	select 
		b.objid, 
		b.name as barangay, 
		sum(case when br.state <> 'ERROR' then 1 else 0 end ) as forpostingcount, 
		sum(case when br.state = 'ERROR' then 1 else 0 end ) as errorcount, 
		0 as postedcount
	from batch_rpttaxcredit_ledger br
	inner join rptledger rl on rl.objid = br.objid
	inner join barangay b on b.objid = rl.barangayid
	where br.parentid = $P{objid}
	group by b.objid, b.name

	union all 

	select 
		b.objid, 
		b.name as barangay, 
		0 as forpostingcount, 
		0 as errorcount,
		count(*) as postedcount
	from batch_rpttaxcredit_ledger_posted br
	inner join rptledger rl on rl.objid = br.objid
	inner join barangay b on b.objid = rl.barangayid
	where br.parentid = $P{objid}
	group by b.objid, b.name
) x 
where x.barangay is not null
group by x.objid, x.barangay 
order by x.barangay


[insertLedgersForCredits]
insert into batch_rpttaxcredit_ledger (
	objid, parentid, state, barangayid
)
select 
	rl.objid,
	$P{objid} as parentid,
	'FORPROCESS' as state,
	rl.barangayid
from rptledger rl
where rl.state = 'APPROVED'
and rl.totalav > 0
and rl.taxable = 1
and not exists (
	select * from rpttaxcredit 
	where type = 'TAX_ADJUSTMENT' 
	and state = 'DRAFT'
	and rptledger_objid = rl.objid
)
and not exists(
	select * from batch_rpttaxcredit_ledger_posted where objid = rl.objid 
)

