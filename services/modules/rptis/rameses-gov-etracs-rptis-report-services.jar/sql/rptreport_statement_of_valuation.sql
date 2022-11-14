[getList]
select 
	x.isitem,
	x.idx,
	x.title,
	sum(x.rpucount) as rpucount,
	sum(x.totalav) as totalav, 
	sum(x.totalmv) as totalmv
from (
	select 
		0 as isitem, 
		1 as idx,
		'A. NEW DISCOVERY' as title,
		null as rpucount,
		null as totalav, 
		null as totalmv 

	union all 

	select 
		1 as isitem, 
		case 
			when r.rputype = 'land' then 2
			when r.rputype = 'bldg' and r.totalmv <= 175000 then 3
			when r.rputype = 'bldg' and r.totalmv > 175000 then 4
			when r.rputype = 'mach' then 5
			when r.rputype = 'misc' then 6
			else  7
		end as idx, 
		case 
			when r.rputype = 'land' then 'LAND' 
			when r.rputype = 'bldg' and r.totalmv <= 175000 then 'BLDG. LESS THAN OR EQUAL 175000' 
			when r.rputype = 'bldg' and r.totalmv > 175000 then 'BLDG. GREATER THAN 175000' 
			when r.rputype = 'mach' then 'MACHINERY' 
			when r.rputype = 'misc' then 'MISCELLANEOUS' 
			else 'PLANTS' 
		end as title,
		1 as rpucount,
		r.totalav,
		r.totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid = 'ND' 
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}

	union all 

	select 
		0 as isitem, 
		21 as idx, 
		'B. SUBDIVISION' as title,
		sum(1) as rpucount,
		sum(r.totalav) as totalav,
		sum(r.totalmv) as totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid = 'SD'
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}
		
	union all 

	select 
		0 as isitem, 
		31 as idx, 
		'C. TRANSFER' as title,
		1 as rpucount,
		r.totalav,
		r.totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid in ('TR') 
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}

	union all 

	select 
		0 as isitem, 
		32 as idx, 
		'D. TRANSFER WITH REASSESSMENT' as title,
		1 as rpucount,
		r.totalav,
		r.totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid in ('TRE') 
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}

	union all 

	select 
		0 as isitem, 
		33 as idx, 
		'E. TRANSFER WITH CORRECTION' as title,
		1 as rpucount,
		r.totalav,
		r.totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid in ('TRC') 
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}


	union all 

	select 
		0 as isitem, 
		41 as idx, 
		'F. CONSOLIDATION' as title,
		sum(1) as rpucount,
		sum(r.totalav) as totalav,
		sum(r.totalmv) as totalmv 
	from consolidation c
		inner join faas f on c.newfaasid = f.objid 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
	where c.lguid LIKE $P{lguid}
		and c.state = 'APPROVED' 
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}

	union all 

	select 
		0 as isitem, 
		50 as idx,
		'G. REASSESSMENT' as title,
		null as rpucount,
		null as totalav, 
		null as totalmv 

	union all 

	select 
		1 as isitem, 
		51 as idx, 
		ft.name as title,
		1 as rpucount,
		r.totalav,
		r.totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
		inner join faas_txntype ft on f.txntype_objid = ft.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid not in ('ND', 'TR', 'TRC', 'TRE', 'SD', 'CS', 'GR', 'DC')
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}

	union all 


	select 
		0 as isitem, 
		55 as idx, 
		'H. GENERAL REVISION' as title,
		1 as rpucount,
		r.totalav,
		r.totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
		inner join faas_txntype ft on f.txntype_objid = ft.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid in ('GR')
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}

	union all 


	select 
		0 as isitem, 
		60 as idx, 
		'I. DATA CAPTURE' as title,
		1 as rpucount,
		r.totalav,
		r.totalmv 
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
		inner join faas_txntype ft on f.txntype_objid = ft.objid 
	where f.lguid LIKE $P{lguid}
		and f.txntype_objid in ('DC')
		and f.dtapproved >= $P{startdate} and f.dtapproved < $P{enddate}

	union all 

	select 
		0 as isitem, 
		70 as idx,
		'J. CANCELLATIONS' as title,
		null as rpucount,
		null as totalav, 
		null as totalmv 

	union all 

	select 
		1 as isitem, 
		71 as idx, 
		IFNULL(case when ft.objid is not null then  ft.name else ctd.name end, 'OTHER') as title,
		-1 as rpucount,
		(r.totalav * -1) as totalav,
		(r.totalmv * -1) as totalmv  
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
		left join faas_txntype ft on f.cancelreason = ft.objid 
		left join canceltdreason ctd on f.cancelreason = ctd.code
	where f.lguid LIKE $P{lguid}
	 	and not (ft.objid = 'SD' or ctd.code = 'SD')
		and f.canceldate >= $P{startdate} and f.canceldate < $P{enddate}		

	union all 

	select 
		1 as isitem, 
		72 as idx, 
		'SUBDIVISION - Land 'as title,
		-1 as rpucount,
		(r.totalav * -1) as totalav,
		(r.totalmv * -1) as totalmv  
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
		left join faas_txntype ft on f.cancelreason = ft.objid 
		left join canceltdreason ctd on f.cancelreason = ctd.code
	where f.lguid LIKE $P{lguid}
		and (ft.objid = 'SD' or ctd.code = 'SD')
		and r.rputype = 'land'
		and f.canceldate >= $P{startdate} and f.canceldate < $P{enddate}		

	union all

	select 
		1 as isitem, 
		73 as idx, 
		'SUBDIVISION - Improvement 'as title,
		-1 as rpucount,
		(r.totalav * -1) as totalav,
		(r.totalmv * -1) as totalmv  
	from faas f 
		inner join rpu r on f.rpuid = r.objid
		inner join realproperty rp on f.realpropertyid = rp.objid 
		left join faas_txntype ft on f.cancelreason = ft.objid 
		left join canceltdreason ctd on f.cancelreason = ctd.code
	where f.lguid LIKE $P{lguid}
		and (ft.objid = 'SD' or ctd.code = 'SD')
		and r.rputype <> 'land'
		and f.canceldate >= $P{startdate} and f.canceldate < $P{enddate}	
) x 
group by x.isitem, x.idx, x.title 
order by x.idx 
