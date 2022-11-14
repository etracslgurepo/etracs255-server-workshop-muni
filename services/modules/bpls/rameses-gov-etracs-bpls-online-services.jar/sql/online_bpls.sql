[findBIN]
select * from business where bin = $P{bin}


[findUnpaidAppByBIN]
select 
	a.objid, a.appno, a.appyear, a.txndate, 
	sum(r.amount - r.amtpaid) as balance 
from business b 
	inner join business_application a on a.business_objid = b.objid 
	inner join business_receivable r on r.applicationid = a.objid 
where b.bin = $P{bin} 
	and a.state in ('PAYMENT','RELEASE','COMPLETED') 
group by a.objid, a.appno, a.appyear, a.txndate 
having sum(r.amount - r.amtpaid) > 0 
order by a.appyear, a.txndate
