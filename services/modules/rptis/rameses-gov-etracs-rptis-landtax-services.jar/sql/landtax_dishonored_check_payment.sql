[getSummarizedPaidItems]
select 
	rptledgerfaasid, 
	rlf.assessedvalue,
	year, 
	revtype, 
	priority,
	min(qtr) as minqtr,
	max(qtr) as maxqtr,
	max(partialled) as partialled,
	sum(amount) as amount 
from rptpayment_item rpi 
left join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
where rpi.parentid = $P{objid}
group by rptledgerfaasid, rlf.assessedvalue, year, revtype
order by year, revtype, priority

