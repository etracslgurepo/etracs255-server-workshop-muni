[getReport]
select 
	activeyear, imonth, sum(amount) as total, 
	sum(newcount) as newcount, sum(renewcount) as renewcount, sum(retirecount) as retirecount,
	sum(newamount) as newamount, sum(renewamount) as renewamount, sum(retireamount) as retireamount, 
	sum(tax) as tax, sum(fee) as fee, sum(othercharge) as othercharge, 
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
	end as iqtr 	
from ( 
	select 
		ba.appyear as activeyear, month(ba.dtfiled) as imonth, 0.0 as amount, 
		(case when ba.apptype in ('NEW','ADDITIONAL') then 1 else 0 end) as newcount, 
		(case when ba.apptype in ('RENEW') then 1 else 0 end) as renewcount, 
		(case when ba.apptype in ('RETIRE','RETIRELOB') then 1 else 0 end) as retirecount, 
		0.0 as newamount, 0.0 as renewamount, 0.0 as retireamount, 
		0.0 as tax, 0.0 as fee, 0.0 as othercharge 
	from business_application ba 
		inner join business b on (b.objid = ba.business_objid and b.permittype = $P{permittypeid}) 
	where ba.appyear = $P{year}   
		and ba.objid in ( 
			select applicationid from business_payment 
			where applicationid = ba.objid 
				and year(refdate) = ba.appyear 
				and voided = 0 
		) 

	union all 

	select 
		year(bpay.refdate) as activeyear, month(bpay.refdate) as imonth, (bpayi.amount + bpayi.surcharge + bpayi.interest) as amount, 
		0 as newcount, 0 as renewcount, 0 as retirecount, 
		(case when ba.apptype in ('NEW','ADDITIONAL') then (bpayi.amount + bpayi.surcharge + bpayi.interest) else 0.0 end) as newamount, 
		(case when ba.apptype in ('RENEW') then (bpayi.amount + bpayi.surcharge + bpayi.interest) else 0.0 end) as renewamount, 
		(case when ba.apptype in ('RETIRE','RETIRELOB') then (bpayi.amount + bpayi.surcharge + bpayi.interest) else 0.0 end) as retireamount, 
		(case when br.taxfeetype = 'TAX' then bpayi.amount else 0.0 end) as tax, 
		(case when br.taxfeetype = 'REGFEE' then bpayi.amount else 0.0 end) as fee, 
		(case when br.taxfeetype not in ('TAX','REGFEE') then bpayi.amount else 0.0 end) as othercharge  
	from business_payment bpay 
		inner join business_application ba on ba.objid = bpay.applicationid 
		inner join business b on (b.objid = ba.business_objid and b.permittype = $P{permittypeid}) 
		inner join business_payment_item bpayi on bpayi.parentid = bpay.objid 
		inner join business_receivable br on br.objid = bpayi.receivableid 
	where bpay.refdate >= $P{startdate} 
		and bpay.refdate <  $P{enddate}  
		and bpay.voided = 0 

)tmp1
group by activeyear, imonth 
