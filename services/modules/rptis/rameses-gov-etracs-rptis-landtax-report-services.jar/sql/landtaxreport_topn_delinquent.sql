[getTopNDelinquentAmounts]
SELECT distinct 
	amount 
from report_rptdelinquency_total_bytaxpayer
order by amount desc


[getTopNDelinquentTaxpayers]
SELECT 
	e.objid as taxpayer_objid,
	e.name as taxpayer_name,
	r.ledgercount as rpucount,
	r.amount 
FROM report_rptdelinquency_total_bytaxpayer r
	INNER JOIN entity e on r.taxpayer_objid = e.objid 
where amount = $P{amount}
order by taxpayer_name;