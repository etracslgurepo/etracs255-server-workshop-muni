[insertForProcess]
insert into report_rptdelinquency_forprocess(
	objid, barangayid
)
select rl.objid, rl.barangayid 
from rptledger rl 
where rl.state = 'APPROVED' 
and rl.barangayid = $P{barangayid}
and (rl.lastyearpaid < $P{cy} or (rl.lastyearpaid = $P{cy} and rl.lastqtrpaid < 4))
and exists(select * from rptledgerfaas where state = 'APPROVED' and taxable = 1 and assessedvalue > 0)


[rescheduleError]
insert into report_rptdelinquency_forprocess(
	objid, barangayid
)
select objid, barangayid 
from report_rptdelinquency_error
where objid = $P{objid}


[findCount]
select count(*) as count from report_rptdelinquency_forprocess where barangayid = $P{barangayid}


[deleteErrors]
delete from report_rptdelinquency_error

[deleteForProcess]
delete from report_rptdelinquency_forprocess

[deleteItems]
delete from report_rptdelinquency_item

[deleteBarangays]
delete from report_rptdelinquency_barangay

[deleteDelinquency]
delete from report_rptdelinquency


[getBarangayCountInfo]
select 
	barangayid,
	sum(case when ignored = 0 then 1 else 0 end) as errors,
	sum(case when ignored = 1 then 1 else 0 end) as ignored
from report_rptdelinquency_error
group by barangayid



[deleteTaxpayerSummary]
delete from report_rptdelinquency_total_bytaxpayer

[insertTaxpayerSummary]
insert into report_rptdelinquency_total_bytaxpayer (
	taxpayer_objid,
	parentid,
	amount,
	ledgercount
)
SELECT 
	rl.taxpayer_objid,
	rr.parentid,
	SUM(rr.basic - rr.basicdisc + rr.basicint  + rr.sef - rr.sefdisc + rr.sefint ) AS amount,
	count( distinct rr.rptledgerid) as ledgercount
FROM vw_landtax_report_rptdelinquency_detail rr 
	inner join rptledger rl on rr.rptledgerid = rl.objid 
WHERE rl.taxable = 1
AND NOT EXISTS(select * from faas_restriction where ledger_objid = rr.rptledgerid and state='ACTIVE')
GROUP BY rl.taxpayer_objid, rr.parentid
