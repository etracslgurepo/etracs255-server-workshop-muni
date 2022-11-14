[getReport]
select 
	activeyear, imonth, 
	case  
		when imonth=1 then 'JANUARY'
		when imonth=2 then 'FEBRUARY'
		when imonth=3 then 'MARCH'
		when imonth=4 then 'APRIL'
		when imonth=5 then 'MAY'
		when imonth=6 then 'JUNE'
		when imonth=7 then 'JULY'
		when imonth=8 then 'AUGUST'
		when imonth=9 then 'SEPTEMBER'
		when imonth=10 then 'OCTOBER'
		when imonth=11 then 'NOVEMBER'
		when imonth=12 then 'DECEMBER' 
		else null 
	end as strmonth,
	case 
		when imonth between 1 and 3 then 1 
		when imonth between 4 and 6 then 2 
		when imonth between 7 and 9 then 3 
		when imonth between 10 and 12 then 4 
		else 0 
	end as iqtr,
	sum(amount) as total, 
	sum(newcount) as newcount, sum(renewcount) as renewcount, sum(retirecount) as retirecount, 
	sum(newamount) as newamount, sum(renewamount) as renewamount, sum(retireamount) as retireamount, 
	sum(tax) as tax, sum(regfee) as fee, sum(othercharge) as othercharge, 
	sum(capital) as capital, sum(gross) as gross 
from ( 
	select 
		bper.activeyear, month(bper.dtissued) as imonth, 0.0 as amount, 
		(case when app.apptype = 'NEW' then 1 else 0 end) as newcount,  
		(case when app.apptype = 'RENEW' then 1 else 0 end) as renewcount,  
		(case when app.apptype = 'RETIRE' then 1 else 0 end) as retirecount,
		0.0 as newamount, 0.0 as renewamount, 0.0 as retireamount, 
		0.0 as tax, 0.0 as regfee, 0.0 as othercharge, 
		0.0 as capital, 0.0 as gross 
	from ( 
		select businessid, activeyear, appid, max(iver) as maxver 
		from ( 
			select 
				t1.businessid, t1.activeyear, t1.version as iver, 
				(case when t2.parentapplicationid is null then t2.objid else t2.parentapplicationid end) as appid 
			from business_permit t1  
				inner join business_application t2 on t2.objid = t1.applicationid 
				inner join business t3 on t3.objid = t1.businessid 
			where t1.activeyear = $P{year}  
				and t1.activeyear = t2.appyear 
				and t1.state = 'ACTIVE' 
		)tmp1 
		group by businessid, activeyear, appid 
	)tmp2 
		inner join business_permit bper on (bper.businessid = tmp2.businessid and bper.activeyear = tmp2.activeyear and bper.version = tmp2.maxver) 
		inner join business_application app on app.objid = tmp2.appid 
		inner join business_application ba on ba.objid = bper.applicationid 
		inner join business b on (b.objid = bper.businessid and b.permittype = $P{permittypeid}) 
	where bper.state = 'ACTIVE' 
		and ba.state = 'COMPLETED' 
		
	union all 

	select 
		bper.activeyear, month(bper.dtissued) as imonth, (bpayi.amount + bpayi.surcharge + bpayi.interest) as amount, 
		0 as newcount, 0 as renewcount, 0 as retirecount,
		(case when app.apptype = 'NEW' then (bpayi.amount + bpayi.surcharge + bpayi.interest) else 0.0 end) as newamount,  
		(case when app.apptype = 'RENEW' then (bpayi.amount + bpayi.surcharge + bpayi.interest) else 0.0 end) as renewamount,  
		(case when app.apptype = 'RETIRE' then (bpayi.amount + bpayi.surcharge + bpayi.interest) else 0.0 end) as retireamount,
		(case when br.taxfeetype = 'TAX' then bpayi.amount else 0.0 end) as tax,
		(case when br.taxfeetype = 'REGFEE' then bpayi.amount else 0.0 end) as regfee,
		(case when br.taxfeetype = 'OTHERCHARGE' then bpayi.amount else 0.0 end) as othercharge, 
		0.0 as capital, 0.0 as gross 
	from ( 
		select t1.objid, 
			(case when t2.parentapplicationid is null then t2.objid else t2.parentapplicationid end) as mainappid 
		from business_permit t1  
			inner join business_application t2 on t2.objid = t1.applicationid 
			inner join business t3 on (t3.objid = t1.businessid and t3.permittype = $P{permittypeid}) 
		where t1.activeyear = $P{year}  
			and t1.activeyear = t2.appyear 
			and t1.state = 'ACTIVE' 
	)tmp1 
		inner join business_permit bper on bper.objid = tmp1.objid 
		inner join business_application app on app.objid = tmp1.mainappid 
		inner join business_application ba on ba.objid = bper.applicationid 
		inner join business b on (b.objid = bper.businessid and b.permittype = $P{permittypeid}) 
		inner join business_payment bpay on bpay.applicationid = bper.applicationid 
		inner join business_payment_item bpayi on bpayi.parentid = bpay.objid 
		inner join business_receivable br on br.objid = bpayi.receivableid 
	where bper.activeyear = year(bpay.refdate)  
		and ba.state = 'COMPLETED'
		and bpay.voided = 0 

	union all 

	select 
		bper.activeyear, month(bper.dtissued) as imonth, 0.0 as amount, 
		0 as newcount, 0 as renewcount, 0 as retirecount,
		0.0 as newamount, 0.0 as renewamount, 0.0 as retireamount, 
		0.0 as tax, 0.0 as regfee, 0.0 as othercharge, 
		sum(cap.decimalvalue) as capital, sum(gro.decimalvalue) as gross 
	from ( 
		select t1.businessid, t1.activeyear, max(t1.version) as maxver 
		from business_permit t1 
			inner join business_application t2 on t2.objid = t1.applicationid
			inner join business t3 on (t3.objid = t1.businessid and t3.permittype = $P{permittypeid})
		where t1.activeyear = $P{year}  
			and t1.activeyear = t2.appyear 
			and t1.state = 'ACTIVE' 
			and t2.state = 'COMPLETED' 
		group by t1.businessid, t1.activeyear 
	)tmp1 
		inner join business_permit bper on (bper.businessid = tmp1.businessid and bper.activeyear = tmp1.activeyear and bper.version = tmp1.maxver) 
		inner join business_application app on app.objid = bper.applicationid 
		inner join business_application ba on (ba.business_objid = bper.businessid and ba.appyear = bper.activeyear and ba.txndate <= app.txndate) 
		inner join business b on (b.objid = bper.businessid and b.permittype = $P{permittypeid})
		left join business_application_info cap on (cap.applicationid = ba.objid and cap.attribute_objid = 'CAPITAL')
		left join business_application_info gro on (gro.applicationid = ba.objid and gro.attribute_objid = 'GROSS')
	where ba.state = 'COMPLETED' 
		and ba.apptype in ('NEW','RENEW','ADDITIONAL') 
	group by bper.activeyear, month(bper.dtissued) 

)tmp01 
group by activeyear, imonth 
