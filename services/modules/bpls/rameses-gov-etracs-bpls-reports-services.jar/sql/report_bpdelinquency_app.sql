[build]
insert into report_bpdelinquency_app ( 
	objid, parentid, applicationid, appdate, appyear 
) 
select 
	UUID() as objid, $P{reportid} as parentid, 
	t0.applicationid, t0.appdate, t0.appyear 
from ( 
	select 
		r.applicationid, a.dtfiled as appdate, a.appyear, 
		sum(r.amount-r.amtpaid) as balance 
	from business_receivable r 
		inner join business_application a on a.objid = r.applicationid 
		inner join business b on b.objid = a.business_objid 
	where a.state in ('PAYMENT','RELEASE','COMPLETED') 
	group by r.applicationid, a.dtfiled, a.appyear 
	having sum(r.amount-r.amtpaid) > 0 
)t0 
order by t0.appyear, t0.appdate 


[lockForUpdate]
update 
	report_bpdelinquency_app aa, 
	( 
		select objid 
		from report_bpdelinquency_app 
		where parentid = $P{parentid} 
			and lockid IS NULL 
		order by appyear, appdate 
		limit 20
	)bb 
set 
	aa.lockid = $P{lockid} 
where 
	aa.objid = bb.objid 


[getLockedItems]
select a.* 
from report_bpdelinquency_app a 
where a.parentid = $P{parentid} 
	and a.lockid = $P{lockid} 
order by a.appyear, a.appdate 


[findLedger]
select 
	applicationid, appyear, appno, tradename, apptype, 
	sum(amount) as amount, sum(amtpaid) as amtpaid, 
	sum(tax) as tax, sum(regfee) as regfee, sum(othercharge) as othercharge 
from ( 
	select 
		r.applicationid, a.appyear, a.appno, a.tradename, a.apptype, r.amount, r.amtpaid, 
		(case when r.taxfeetype = 'TAX' then r.amount-r.amtpaid else 0.0 end) as tax, 
		(case when r.taxfeetype = 'REGFEE' then r.amount-r.amtpaid else 0.0 end) as regfee, 
		(case when r.taxfeetype = 'OTHERCHARGE' then r.amount-r.amtpaid else 0.0 end) as othercharge  
	from business_receivable r 
		inner join business_application a on a.objid = r.applicationid 
	where r.applicationid = $P{applicationid} 
)t0 
group by applicationid, appyear, appno, tradename, apptype 
