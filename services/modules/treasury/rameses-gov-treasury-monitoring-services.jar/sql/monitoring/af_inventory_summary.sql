[getReportA]
select 
	refid, refno, refdate, reftype, txntype, user_objid, user_name, 
	sum(opencount) as opencount, sum(issuedcount) as issuedcount, 
	sum(soldcount) as soldcount, sum(opencount + issuedcount + soldcount) as totalcount 
from ( 
	select 
		d.refid, d.refno, d.refdate, d.reftype, d.txntype, 
		aftxn.user_objid, aftxn.user_name, 
		(case when a.state = 'OPEN' then 1 else 0 end) as opencount, 
		(case when a.state = 'ISSUED' then 1 else 0 end) as issuedcount, 
		(case when a.state = 'SOLD' then 1 else 0 end) as soldcount 
	from ( 
		select distinct 
			d.refid, d.reftype 
		from af_control a 
			inner join af_control_detail d on d.objid = a.currentdetailid 
		where a.state = 'OPEN' 
	)t0 
		inner join af_control_detail d on d.refid = t0.refid 
		inner join af_control a on a.objid = d.controlid 
		left join aftxn on aftxn.objid = t0.refid 
)t1 
group by refid, refno, refdate, reftype, txntype, user_objid, user_name 
order by refdate, refno 


[getReportA_Items]
select 
	afid, title, formindexno, serieslength, 
	sum(opencount) as opencount, sum(issuedcount) as issuedcount, 
	sum(soldcount) as soldcount, sum(opencount + issuedcount + soldcount) as totalcount 
from ( 
	select 
		a.afid, af.title, af.serieslength, 
		(case when af.formtype = 'serial' then 0 else 1 end) as formindexno, 
		(case when a.state = 'OPEN' then 1 else 0 end) as opencount, 
		(case when a.state = 'ISSUED' then 1 else 0 end) as issuedcount, 
		(case when a.state = 'SOLD' then 1 else 0 end) as soldcount 
	from ( 
		select distinct 
			d.refid, d.reftype 
		from af_control a 
			inner join af_control_detail d on d.objid = a.currentdetailid 
		where a.state = 'OPEN' 
	)t0 
		inner join af_control_detail d on d.refid = t0.refid 
		inner join af_control a on a.objid = d.controlid 
		left join af on af.objid = a.afid 
)t1 
group by afid, title, formindexno, serieslength
order by formindexno, serieslength, afid 


[getReportB]
select 
	refid, refno, refdate, reftype, afid, title, serieslength, formindexno, 
	sum(opencount) as opencount, sum(issuedcount) as issuedcount, 
	sum(soldcount) as soldcount, sum(opencount + issuedcount + soldcount) as totalcount 
from ( 
	select 
		d.refid, d.refno, d.refdate, d.reftype, a.afid, af.title, af.serieslength, 
		(case when af.formtype = 'serial' then 0 else 1 end) as formindexno, 
		(case when a.state = 'OPEN' then 1 else 0 end) as opencount, 
		(case when a.state = 'ISSUED' then 1 else 0 end) as issuedcount, 
		(case when a.state = 'SOLD' then 1 else 0 end) as soldcount 
	from ( 
		select distinct 
			d.refid, d.reftype 
		from af_control a 
			inner join af_control_detail d on d.objid = a.currentdetailid 
		where a.state = 'OPEN' 
	)t0 
		inner join af_control_detail d on d.refid = t0.refid 
		inner join af_control a on a.objid = d.controlid 
		inner join af on af.objid = a.afid 
)t1 
group by refid, refno, refdate, reftype, afid, title, serieslength, formindexno 
order by refdate, refno, refid, formindexno, serieslength, afid 
