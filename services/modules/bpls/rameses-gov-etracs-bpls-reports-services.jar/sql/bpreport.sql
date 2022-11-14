[getBarangayList]
SELECT objid AS barangayid, name AS barangayname FROM barangay ORDER BY name

[getClassificationList]
SELECT objid AS classificationid, name AS classification FROM lobclassification ORDER BY name

[getLobListByAppid]
SELECT * FROM business_application_lob
WHERE businessid=$P{businessid} AND activeyear=$P{activeyear} 
ORDER BY name 

[getBPPaymentsByAppid]
SELECT p.refno, p.refdate, p.amount 
FROM business_application a 
	INNER JOIN business b ON a.business_objid=b.objid 
	INNER JOIN business_payment p ON a.objid=p.applicationid 
WHERE a.business_objid=$P{businessid} 
	AND a.appyear=$P{activeyear} 
	AND b.state NOT IN ('CANCELLED') 
	AND p.voided=0 
ORDER BY p.refno 

[getLobList]
SELECT classification_objid, name FROM lob
ORDER BY classification_objid, name


[getTaxpayerMasterList]
select 
	b.objid, tmp2.activeyear, tmp2.apptype, b.orgtype, b.tradename, 
	baddr.barangay_name, b.address_text as businessaddress, 
	b.owner_name, b.owner_address_text as owner_address, 
	tmp2.declaredcapital, tmp2.declaredgross, tmp2.capital, tmp2.gross, 
	(
		select permitno from business_permit 
		where businessid=b.objid and activeyear=tmp2.activeyear 
		order by version desc limit 1 
	) as permitno 
from ( 
	select 
		businessid, activeyear, apptype, 
		ifnull(sum(declaredcapital), 0) as declaredcapital, 
		ifnull(sum(declaredgross), 0) as declaredgross, 
		ifnull(sum(capital), 0) as capital, 
		ifnull(sum(gross), 0) as gross  
	from ( 
		select 
			ba.business_objid as businessid, ba.appyear as activeyear, ba.apptype, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and attribute_objid='DECLARED_CAPITAL') as declaredcapital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and attribute_objid='DECLARED_GROSS') as declaredgross,  
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and attribute_objid='CAPITAL') as capital, 
			(select sum(decimalvalue) from business_application_info where applicationid=ba.objid and attribute_objid='GROSS') as gross 
		from business_application ba 
			inner join business b on ba.business_objid=b.objid 
		where ba.appyear in (YEAR($P{startdate}), YEAR($P{enddate}))
			and ba.dtfiled >= $P{startdate} 
			and ba.dtfiled <  $P{enddate} 
			and ba.apptype in ( ${apptypefilter} ) 
			and ba.state in ( ${appstatefilter} ) 
			and b.permittype = $P{permittypeid} 
	)tmp1 
	group by businessid, activeyear, apptype 
)tmp2 
	inner join business b on b.objid=tmp2.businessid 
	left join business_address baddr on b.address_objid=baddr.objid 
order by b.tradename 


[getLOBCountList]
select 
	a.appyear, lob.name, 
	SUM(CASE 
		WHEN a.apptype='NEW' THEN 1 
		WHEN a.apptype='RENEW' AND bal.assessmenttype='NEW' THEN 1 
		ELSE 0 
	END) as newcount, 
	SUM(CASE WHEN a.apptype='RENEW' AND bal.assessmenttype='RENEW' THEN 1 ELSE 0 END) AS renewcount,
	SUM(CASE WHEN a.apptype='ADDITIONAL' THEN 1 ELSE 0 END) AS addlobcount,
	SUM(CASE WHEN bal.assessmenttype='RETIRE' THEN 1 ELSE 0 END) AS retirecount	
from business_application a 
	inner join business_application_lob bal on a.objid=bal.applicationid 
	inner join lob on bal.lobid=lob.objid 
	inner join business b on a.business_objid=b.objid 
	left join business_address baddr on b.address_objid=baddr.objid 
where a.appyear in (YEAR($P{startdate}), YEAR($P{enddate})) 
	and a.dtfiled >= $P{startdate} 
	and a.dtfiled <  $P{enddate}  
	${filter} 
group by a.appyear, lob.name 


[getBusinessTopList]
select  
	xx.businessid, xx.appyear, b.tradename, b.address_text as businessaddress, 
	b.owner_name as ownername, b.owner_address_text as owneraddress, xx.amount, 
	(
		select permitno from business_permit 
		where businessid=xx.businessid and activeyear=xx.appyear and state='ACTIVE' 
		order by version desc limit 1 
	) as permitno 
from ( 
	select businessid, appyear, sum(amount) as amount, sum(paymentcount) as paymentcount 
	from ( 
		select  
			ba.business_objid as businessid, ba.appyear, decimalvalue as amount, 
			(select count(objid) from business_payment where applicationid = ba.objid and voided = 0) as paymentcount 
		from business_application ba 
			inner join business b on b.objid = ba.business_objid 
			inner join business_application_info bai on bai.applicationid = ba.objid 
			inner join lob on lob.objid = bai.lob_objid 
		where ba.appyear = $P{year} 
			and b.permittype = $P{permittypeid} 
			and ba.state in ( ${appstatefilter} ) 
			and ba.apptype in ( ${apptypefilter} ) 
			and bai.attribute_objid in ('CAPITAL','GROSS') 
			and lob.classification_objid like $P{classificationid} 
	)t0 
	where 1=1 ${filter} 
	group by businessid, appyear 
)xx 
	inner join business b on b.objid = xx.businessid 
order by xx.amount desc, b.tradename  
limit ${topsize} 


[getQtrlyPaidBusinessList]
select 
	t2.businessid, b.bin, b.tradename, b.businessname, b.address_text as businessaddress, 
	sum(t2.amtdue) as amtdue, sum(t2.amtpaid) as amtpaid, sum(t2.balance) as balance, 
	sum(t2.q1) as q1, sum(t2.q2) as q2, sum(t2.q3) as q3, sum(t2.q4) as q4, sum(t2.q1+t2.q2+t2.q3+t2.q4) as totalpaidqtr 
from ( 
	select 
		tt1.businessid, sum(br.amount) as amtdue, sum(br.amtpaid) as amtpaid, 
		sum(br.amount-br.amtpaid) as balance, 0.0 as q1, 0.0 as q2, 0.0 as q3, 0.0 as q4 
	from ( 
		select 
			b.objid as businessid, ba.objid as applicationid, count(*) as icount 
		from business_payment p 
			inner join business_application ba on ba.objid = p.applicationid 
			inner join business b on (b.objid = ba.business_objid and b.permittype='BUSINESS') 
			inner join business_receivable br on br.applicationid = ba.objid 
		where p.refdate >= $P{startdate} 
			and p.refdate <  $P{enddate} 
			and p.voided = 0 ${filter} ${taxfeetypefilter} 
		group by b.objid, ba.objid 
	)tt1  
		inner join business_receivable br on br.applicationid = tt1.applicationid 
	group by tt1.businessid 

	union all 

	select 
		tt1.businessid, 0.0 as amtdue, 0.0 as amtpaid, 0.0 as balance,  
		sum(case when tt1.imonth between 1 and 3 then tt1.amount else 0.0 end) as q1, 
		sum(case when tt1.imonth between 4 and 6 then tt1.amount else 0.0 end) as q2, 
		sum(case when tt1.imonth between 7 and 9 then tt1.amount else 0.0 end) as q3, 
		sum(case when tt1.imonth between 10 and 12 then tt1.amount else 0.0 end) as q4 
	from ( 
		select 
			b.objid as businessid, month(p.refdate) as imonth, 
			sum(pp.amount + pp.surcharge + pp.interest) as amount 
		from business_payment p 
			inner join business_application ba on ba.objid = p.applicationid 
			inner join business b on (b.objid = ba.business_objid and b.permittype='BUSINESS') 
			inner join business_payment_item pp on pp.parentid = p.objid 
			left join business_receivable br on br.objid = pp.receivableid 
		where p.refdate >= $P{startdate} 
			and p.refdate <  $P{enddate} 
			and p.voided = 0 ${filter} ${taxfeetypefilter} 
		group by b.objid, month(p.refdate) 
	)tt1 
	group by tt1.businessid 

)t2, business b 
where b.objid = t2.businessid 
group by t2.businessid, b.bin, b.tradename, b.businessname, b.address_text 
order by b.businessname   


[getEmployerList]
select 
	b.objid, b.bin, b.tradename, b.address_text as businessaddress, b.owner_name, b.owner_objid, 
	tmp2.numfemale, tmp2.nummale, tmp2.numresident, tmp2.numemployee, 
	(case when ei.gender='M' then 1 else 0 end) as malecount,
	(case when ei.gender='F' then 1 else 0 end) as femalecount,  
	(
		select idno from entityid 
		where entityid = b.owner_objid and idtype='TIN' 
		order by dtissued desc limit 1 
	) as tin, 
	(
		select idno from entityid 
		where entityid = b.owner_objid and idtype='SSS' 
		order by dtissued desc limit 1 
	) as sss, 
	case 
		when b.state='ACTIVE' then (
			select permitno from business_permit 
			where businessid=b.objid and activeyear=tmp2.appyear and state='ACTIVE' 
			order by version desc limit 1 
		) 
		else null 
	end as permitno 
from ( 
	select 
		businessid, appyear, 
		ifnull(sum(nummale),0) as nummale, 
		ifnull(sum(numfemale),0) as numfemale, 
		ifnull(sum(numresident),0) as numresident,  
		(ifnull(sum(nummale),0) + ifnull(sum(numfemale),0)) as numemployee 
	from ( 
		select 
			ba.business_objid as businessid, ba.appyear, 
			(select sum(intvalue) from business_application_info where applicationid=ba.objid and attribute_objid='NUM_EMPLOYEE_MALE') as nummale, 
			(select sum(intvalue) from business_application_info where applicationid=ba.objid and attribute_objid='NUM_EMPLOYEE_FEMALE') as numfemale, 
			(select sum(intvalue) from business_application_info where applicationid=ba.objid and attribute_objid='NUM_EMPLOYEE_RESIDENT') as numresident 
		from business_application ba 
			inner join business b on ba.business_objid=b.objid 
		where ba.appyear in (YEAR($P{startdate}), YEAR($P{enddate}))
			and ba.dtfiled >= $P{startdate} 
			and ba.dtfiled <  $P{enddate} 
			and ba.apptype in ( ${apptypefilter} ) 
			and ba.state in ( ${appstatefilter} ) 
			and b.permittype = $P{permittypeid} 
	)tmp1 
	group by businessid, appyear 
)tmp2 
	inner join business b on b.objid=tmp2.businessid 
	left join entityindividual ei on b.owner_objid=ei.objid 
order by b.tradename 


[getBusinessesByBarangay]
SELECT 
	b.objid as businessid, b.owner_objid, b.owner_name, b.owner_address_text as owner_address,
	b.tradename, b.address_text as businessaddress, a.appno, a.apptype, a.appyear
FROM business b
	INNER JOIN business_application a ON a.business_objid = b.objid
	LEFT JOIN business_address ba ON b.address_objid=ba.objid
WHERE ba.barangay_objid LIKE $P{barangayid} 
ORDER BY a.appyear, b.owner_name 


[getBPTaxFeeTopList]
select xx.*, (
		select permitno from business_permit 
		where businessid = xx.businessid and activeyear = xx.appyear and state = 'ACTIVE' 
		order by version desc limit 1 
	) as permitno 
from ( 
	select 
		businessid, appyear, tradename, businessaddress, ownername, owneraddress, 
		sum(tax) as tax, sum(regfee) as regfee, sum(othercharge) as othercharge, 
		(sum(tax) + sum(regfee) + sum(othercharge)) as total, sum(paymentcount) as paymentcount 
	from ( 
		select 
			ba.business_objid as businessid, ba.appyear, ba.tradename, 
			ba.businessaddress, ba.ownername, ba.owneraddress, 
			(case when br.taxfeetype='TAX' then br.amount else 0.0 end) as tax, 
			(case when br.taxfeetype='REGFEE' then br.amount else 0.0 end) as regfee, 
			(case when br.taxfeetype='OTHERCHARGE' then br.amount else 0.0 end) as othercharge, 
			(select count(objid) from business_payment where applicationid = ba.objid and voided = 0) as paymentcount 
		from business_application ba  
			inner join business b on b.objid = ba.business_objid 
			inner join business_receivable br on br.applicationid = ba.objid 
		where ba.appyear = $P{year} 
			and b.permittype = $P{permittypeid} 
			and ba.state in ( ${appstatefilter} ) 
			and ba.apptype in ( ${apptypefilter} ) 
	)t0 
	where 1=1 ${filter} 
	group by businessid, appyear, tradename, businessaddress, ownername, owneraddress 
)xx 
order by total desc, tradename 
limit ${topsize}  
