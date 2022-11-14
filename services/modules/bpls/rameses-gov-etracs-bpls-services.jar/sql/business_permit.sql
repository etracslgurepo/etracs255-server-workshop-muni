[getList]
SELECT DISTINCT bb.*  
FROM 
(
	SELECT bp.*, 
		b.businessname AS business_businessname, 
		b.address_text AS business_address_text, 
		b.bin AS business_bin,
		b.owner_name AS business_owner_name,
		ba.apptype
	FROM business_permit bp
	INNER JOIN business b ON bp.businessid=b.objid 
	INNER JOIN business_application ba ON bp.applicationid=ba.objid
	WHERE bp.expirydate >= $P{currentdate} 
    AND b.owner_name LIKE $P{searchtext} 

    UNION 

	SELECT bp.*, 
		b.businessname AS business_businessname, 
		b.address_text AS business_address_text, 
		b.bin AS business_bin,
		b.owner_name AS business_owner_name,
		ba.apptype
	FROM business_permit bp
	INNER JOIN business b ON bp.businessid=b.objid 
	INNER JOIN business_application ba ON bp.applicationid=ba.objid
	WHERE bp.expirydate >= $P{currentdate} 
    AND b.businessname LIKE $P{searchtext} 

    UNION 

	SELECT bp.*, 
		b.businessname AS business_businessname, 
		b.address_text AS business_address_text, 
		b.bin AS business_bin,
		b.owner_name AS business_owner_name,
		ba.apptype
	FROM business_permit bp
	INNER JOIN business b ON bp.businessid=b.objid 
	INNER JOIN business_application ba ON bp.applicationid=ba.objid
	WHERE bp.expirydate >= $P{currentdate} 
    AND b.bin LIKE $P{searchtext} 

) bb


[getExpiredList]
SELECT DISTINCT bb.*  
FROM 
(
	SELECT bp.*, 
		b.businessname AS business_businessname, 
		b.address_text AS business_address_text, 
		b.bin AS business_bin,
		b.owner_name AS business_owner_name,
		ba.apptype
	FROM business_permit bp
	INNER JOIN business b ON bp.businessid=b.objid
	INNER JOIN business_application ba ON bp.applicationid=ba.objid
	WHERE bp.expirydate < $P{currentdate}
	AND b.owner_name LIKE $P{searchtext} 

	UNION 

	SELECT bp.*, 
		b.businessname AS business_businessname, 
		b.address_text AS business_address_text, 
		b.bin AS business_bin,
		b.owner_name AS business_owner_name,
		ba.apptype
	FROM business_permit bp
	INNER JOIN business b ON bp.businessid=b.objid
	INNER JOIN business_application ba ON bp.applicationid=ba.objid
	WHERE bp.expirydate < $P{currentdate}
	AND b.businessname LIKE $P{searchtext} 

	UNION

	SELECT bp.*, 
		b.businessname AS business_businessname, 
		b.address_text AS business_address_text, 
		b.bin AS business_bin,
		b.owner_name AS business_owner_name,
		ba.apptype
	FROM business_permit bp
	INNER JOIN business b ON bp.businessid=b.objid
	INNER JOIN business_application ba ON bp.applicationid=ba.objid
	WHERE bp.expirydate < $P{currentdate}
	AND b.bin LIKE $P{searchtext} 

) bb


[findPermitByApplication]
select 
	bp.*, ba.appno, ba.apptype, ba.ownername, ba.owneraddress, ba.tradename, 
	ba.businessaddress, b.bin, b.pin, b.address_objid, b.owner_address_objid, 
	(SELECT photo FROM entityindividual WHERE objid=b.owner_objid) AS photo, 
	(select citizenship from entityindividual where objid=b.owner_objid) AS citizenship, 
	(select civilstatus from entityindividual where objid=b.owner_objid) AS civilstatus, 
	ba.parentapplicationid, b.orgtype   
from business_application ba 
	inner join business_permit bp on bp.objid=ba.permit_objid 
	inner join business b on bp.businessid=b.objid 
where ba.objid=$P{applicationid} 
	and bp.activeyear=ba.appyear 
	and bp.state='ACTIVE' 


[findPermitForReport]
select 
	bp.*, ba.appno, ba.apptype, ba.ownername, ba.owneraddress, ba.tradename, 
	ba.businessaddress, b.bin, b.pin, b.address_objid, b.owner_address_objid, ba.parentapplicationid, 
	(select apptype from business_application where objid=ba.parentapplicationid) as parentapptype,  
	(select photo from entityindividual where objid=b.owner_objid) AS photo, 
	(select citizenship from entityindividual where objid=b.owner_objid) AS citizenship, 
	(select civilstatus from entityindividual where objid=b.owner_objid) AS civilstatus, 
	b.orgtype  
from ( 
	select objid as appid from business_application 
	where objid=$P{applicationid} and state in (${statefilter})
	union 
	select objid as appid from business_application 
	where parentapplicationid=$P{applicationid} and state in (${statefilter}) 
)xx 
	inner join business_application ba on ba.objid=xx.appid 
	inner join business_permit bp on ba.objid=bp.applicationid 
	inner join business b on bp.businessid=b.objid 
where bp.activeyear=ba.appyear and bp.state='ACTIVE' 
order by bp.version desc


[findBusinessAddress]
SELECT * FROM business_address WHERE objid=$P{objid} 


[getApplicationLOBs]
select 
	bal.objid, bal.applicationid, bal.businessid, ba.txndate,  
	bal.lobid, bal.name, bal.assessmenttype 
from ( 
	select 
		bal.businessid, bal.activeyear, bal.lobid, max(ba.txndate) as txndate 
	from business_application o 
		inner join business_application_lob bal on o.business_objid=bal.businessid 
		inner join business_application ba on bal.applicationid=ba.objid 
	where o.objid=$P{applicationid} 
		and bal.activeyear=o.appyear  
		and ba.state in ('RELEASE','COMPLETED') 
	group by bal.businessid, bal.activeyear, bal.lobid 
)xx 
	inner join business_application_lob bal on xx.businessid=bal.businessid 
	inner join business_application ba on bal.applicationid=ba.objid 
where bal.activeyear=xx.activeyear 
	and bal.lobid=xx.lobid 
	and ba.txndate=xx.txndate 
	and bal.assessmenttype in ('NEW','RENEW') 
order by ba.txndate, bal.name 


[updatePlateno]
UPDATE business_permit SET plateno=$P{plateno} WHERE objid=$P{objid}


[findPermitCount]
select count(*) as icount from business_permit 
where businessid=$P{businessid} and activeyear=$P{activeyear}  


[findPermit]
select * from business_permit 
where businessid=$P{businessid} and applicationid=$P{applicationid} 
   and state = 'ACTIVE' 

[updateRemarks]
update business_permit set remarks=$P{remarks} where objid=$P{objid} 


[getAppLOBs]
select 
	alob.objid, alob.businessid, alob.applicationid, a.appyear, 
	a.apptype, a.txndate, a.dtfiled, alob.lobid, alob.name  
from business_permit p 
	inner join business_application pa on p.applicationid=pa.objid 
	inner join business_application a on (a.business_objid=p.businessid and a.appyear=pa.appyear)
	inner join business_application_lob alob on alob.applicationid=a.objid 
where p.objid = $P{permitid}  
	and a.state = 'COMPLETED' 
	and a.txndate <= pa.txndate 


[getBuildLobs]
select t2.lobid, t2.name, t2.txndate 
from ( 
	select 
		t1.lobid, t1.name, max(t1.txndate) as txndate, sum(t1.iflag) as iflag 
	from ( 
		select distinct 
			bac.txndate, bac.apptype, alob.assessmenttype, alob.lobid, lob.name, 
			(case when alob.assessmenttype in ('NEW','RENEW') then 1 else -1 end) as iflag 
		from business_permit bperm 
			inner join business_application ba on ba.objid = bperm.applicationid 
			inner join business_application bap on bap.objid = ba.parentapplicationid 
			inner join business_application bac on (bac.parentapplicationid = bap.objid or bac.objid = bap.objid) 
			inner join business_application_lob alob on alob.applicationid = bac.objid 
			inner join lob on lob.objid = alob.lobid  
		where bperm.objid = $P{permitid} 
			and bac.txndate < ba.txndate 
			and bac.state in (${statefilter})

		union all 

		select distinct 
			ba.txndate, ba.apptype, alob.assessmenttype, alob.lobid, lob.name, 
			(case when alob.assessmenttype in ('NEW','RENEW') then 1 else -1 end) as iflag 
		from business_permit bperm 
			inner join business_application ba on ba.objid = bperm.applicationid 
			inner join business_application_lob alob on alob.applicationid = ba.objid 
			inner join lob on lob.objid = alob.lobid  
		where bperm.objid = $P{permitid} 
			and ba.state in (${statefilter})

	)t1 
	group by t1.lobid, t1.name 
	having sum(t1.iflag) > 0 
)t2 
order by t2.txndate, t2.name 


[getPermits]
select p.*  
from business_permit p 
	inner join business_application pa on pa.objid=p.applicationid 
where p.businessid = $P{businessid} 
	and p.state = 'ACTIVE' 
order by pa.appyear, pa.txndate 


[getPayments]
select p.* from ( 

	select ba.objid as applicationid 
	from business_application a 
		inner join business_application ba on (ba.business_objid=a.business_objid and ba.appyear=a.appyear) 	
	where a.objid = $P{applicationid} 
		and ba.state='COMPLETED' 
		and ba.txndate <= a.txndate 

)tmp1, business_payment p 	
where p.applicationid=tmp1.applicationid 
	and p.voided = 0 
order by p.refdate, p.refno 


[getPendingRequirements]
select breq.reftype, breq.title  
from ( 
	select 
		(case when b.objid is null then a.objid else b.objid end) as appid 
	from business_application a 
		left join business_application b on b.objid = a.parentapplicationid 
	where a.objid = $P{applicationid}  
)tmp1 
	inner join business_requirement breq on breq.applicationid = tmp1.appid 
where (breq.completed is null or breq.completed <> 1) 
order by breq.title 
