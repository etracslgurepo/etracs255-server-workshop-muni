
[findById]
SELECT 
	mm.*,
	basicprior.title AS basicprioracct_title, 
	basicpriorint.title AS basicpriorintacct_title,
	basicprev.title AS basicprevacct_title, 
	basicprevint.title AS basicprevintacct_title,
	basiccurr.title AS basiccurracct_title, 
	basiccurrint.title AS basiccurrintacct_title,
	basicadv.title AS basicadvacct_title,
	basicidlecurr.title AS basicidlecurracct_title, 
	basicidlecurrint.title AS basicidlecurrintacct_title,
	basicidleprev.title AS basicidleprevacct_title, 
	basicidleprevint.title AS basicidleprevintacct_title,
	basicidleadv.title AS basicidleadvacct_title,

	sefprior.title AS sefprioracct_title, 
	sefpriorint.title AS sefpriorintacct_title,
	sefprev.title AS sefprevacct_title, 
	sefprevint.title AS sefprevintacct_title,
	sefcurr.title AS sefcurracct_title, 
	sefcurrint.title AS sefcurrintacct_title,
	sefadv.title AS sefadvacct_title
FROM province_taxaccount_mapping mm
	LEFT JOIN itemaccount basicprior ON mm.basicprioracct_objid = basicprior.objid 
	LEFT JOIN itemaccount basicpriorint ON mm.basicpriorintacct_objid = basicpriorint.objid 
	LEFT JOIN itemaccount basicprev ON mm.basicprevacct_objid = basicprev.objid 
	LEFT JOIN itemaccount basicprevint ON mm.basicprevintacct_objid = basicprevint.objid 
	LEFT JOIN itemaccount basiccurr ON mm.basiccurracct_objid = basiccurr.objid 
	LEFT JOIN itemaccount basiccurrint ON mm.basiccurrintacct_objid = basiccurrint.objid 
	LEFT JOIN itemaccount basicadv ON mm.basicadvacct_objid = basicadv.objid 
	LEFT JOIN itemaccount basicidlecurr ON mm.basicidlecurracct_objid = basicidlecurr.objid 
	LEFT JOIN itemaccount basicidlecurrint ON mm.basicidlecurrintacct_objid = basicidlecurrint.objid 
	LEFT JOIN itemaccount basicidleprev ON mm.basicidleprevacct_objid = basicidleprev.objid 
	LEFT JOIN itemaccount basicidleprevint ON mm.basicidleprevintacct_objid = basicidleprevint.objid 
	LEFT JOIN itemaccount basicidleadv ON mm.basicidleadvacct_objid = basicidleadv.objid 
	
	LEFT JOIN itemaccount sefprior ON mm.sefprioracct_objid = sefprior.objid 
	LEFT JOIN itemaccount sefpriorint ON mm.sefpriorintacct_objid = sefpriorint.objid 
	LEFT JOIN itemaccount sefprev ON mm.sefprevacct_objid = sefprev.objid 
	LEFT JOIN itemaccount sefprevint ON mm.sefprevintacct_objid = sefprevint.objid 
	LEFT JOIN itemaccount sefcurr ON mm.sefcurracct_objid = sefcurr.objid 
	LEFT JOIN itemaccount sefcurrint ON mm.sefcurrintacct_objid = sefcurrint.objid 
	LEFT JOIN itemaccount sefadv ON mm.sefadvacct_objid = sefadv.objid 


[findProvinceStats]
select count(objid) as totalcount from province


[buildItemAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select * from ( 
	select top 100 percent 
		(xx.objid + ':prov:' + b.objid) as objid, 'APPROVED' as state, '-' as code, 
		('PROV. ' + b.name + ' ' + ia.title) as title, 
		('PROV. ' + b.name + ' ' + ia.title) as description, ia.type, 
		ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
		ia.org_objid, ia.org_name, ia.objid as parentid 
	from ( 
		select 'basiccurrent' as objid, 'basic' as revtype, 'current' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_CURRENT'
		union 
		select 'basiccurrentint' as objid, 'basicint' as revtype, 'current' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_CURRENT_PENALTY'
		union 
		select 'basicprev' as objid, 'basic' as revtype, 'previous' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_PREVIOUS'
		union 
		select 'basicprevint' as objid, 'basicint' as revtype, 'previous' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_PREVIOUS_PENALTY'
		union 
		select 'basicprior' as objid, 'basic' as revtype, 'prior' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_PRIOR' 
		union 
		select 'basicpriorint' as objid, 'basicint' as revtype, 'prior' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_PRIOR_PENALTY' 
		union 
		select 'basicadvance' as objid, 'basic' as revtype, 'advance' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_ADVANCE' 
		union 
		select 'sefcurrent' as objid, 'sef' as revtype, 'current' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_SEF_CURRENT'
		union 
		select 'sefcurrentint' as objid, 'sefint' as revtype, 'current' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_SEF_CURRENT_PENALTY'
		union 
		select 'sefprev' as objid, 'sef' as revtype, 'previous' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_SEF_PREVIOUS'
		union 
		select 'sefprevint' as objid, 'sefint' as revtype, 'previous' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_SEF_PREVIOUS_PENALTY'
		union 
		select 'sefprior' as objid, 'sef' as revtype, 'prior' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_SEF_PRIOR' 
		union 
		select 'sefpriorint' as objid, 'sefint' as revtype, 'prior' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_SEF_PRIOR_PENALTY' 
		union 
		select 'sefadvance' as objid, 'sef' as revtype, 'advance' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_SEF_ADVANCE' 
		union 
		select 'basicidlecurrent' as objid, 'basic' as revtype, 'current' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_IDLE_CURRENT'
		union 
		select 'basicidlecurrentint' as objid, 'basicint' as revtype, 'current' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_IDLE_CURRENT_PENALTY'
		union 
		select 'basicidleprev' as objid, 'basic' as revtype, 'previous' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_IDLE_PREVIOUS'
		union 
		select 'basicidleprevint' as objid, 'basicint' as revtype, 'previous' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_IDLE_PREVIOUS_PENALTY'
		union 
		select 'basicidleadvance' as objid, 'basic' as revtype, 'advance' as revperiod, acctid as item_objid from itemaccount_tag where tag='RPT_BASIC_IDLE_ADVANCE' 		
	)xx 
		inner join itemaccount ia on xx.item_objid=ia.objid, province b 
	order by b.objid, xx.objid  
)xx 
where objid not in (select objid from itemaccount) 


[removeAccountMappings]
delete from province_taxaccount_mapping where 1=1


[buildAccountMappings]
insert into province_taxaccount_mapping ( 
	objid, basicadvacct_objid, basicprevacct_objid, basicprevintacct_objid, basicprioracct_objid, 
	basicpriorintacct_objid, basiccurracct_objid, basiccurrintacct_objid, sefadvacct_objid, 
	sefprevacct_objid, sefprevintacct_objid, sefprioracct_objid, sefpriorintacct_objid, 
	sefcurracct_objid, sefcurrintacct_objid, basicidlecurracct_objid, basicidlecurrintacct_objid, 
	basicidleprevacct_objid, basicidleprevintacct_objid, basicidleadvacct_objid
) 
select 
	b.objid as objid, 
	(select objid from itemaccount where objid=('basicadvance:prov:' + b.objid)) as basicadvacct_objid,  
	(select objid from itemaccount where objid=('basicprev:prov:' + b.objid)) as basicprevacct_objid,  
	(select objid from itemaccount where objid=('basicprevint:prov:' + b.objid)) as basicprevintacct_objid,  
	(select objid from itemaccount where objid=('basicprior:prov:' + b.objid)) as basicprioracct_objid,  
	(select objid from itemaccount where objid=('basicpriorint:prov:' + b.objid)) as basicpriorintacct_objid,  
	(select objid from itemaccount where objid=('basiccurrent:prov:' + b.objid)) as basiccurracct_objid,  
	(select objid from itemaccount where objid=('basiccurrentint:prov:' + b.objid)) as basiccurrintacct_objid, 

	(select objid from itemaccount where objid=('sefadvance:prov:' + b.objid)) as sefadvacct_objid,  
	(select objid from itemaccount where objid=('sefprev:prov:' + b.objid)) as sefprevacct_objid,  
	(select objid from itemaccount where objid=('sefprevint:prov:' + b.objid)) as sefprevintacct_objid,  
	(select objid from itemaccount where objid=('sefprior:prov:' + b.objid)) as sefprioracct_objid,  
	(select objid from itemaccount where objid=('sefpriorint:prov:' + b.objid)) as sefpriorintacct_objid,  
	(select objid from itemaccount where objid=('sefcurrent:prov:' + b.objid)) as sefcurracct_objid,  
	(select objid from itemaccount where objid=('sefcurrentint:prov:' + b.objid)) as sefcurrintacct_objid,

	(select objid from itemaccount where objid=('basicidlecurrent:prov:' + b.objid)) as basicidlecurracct_objid, 
	(select objid from itemaccount where objid=('basicidlecurrentint:prov:' + b.objid)) as basicidlecurrintacct_objid, 
	(select objid from itemaccount where objid=('basicidleprev:prov:' + b.objid)) as basicidleprevacct_objid, 
	(select objid from itemaccount where objid=('basicidleprevint:prov:' + b.objid)) as basicidleprevintacct_objid, 
	(select objid from itemaccount where objid=('basicidleadvance:prov:' + b.objid)) as basicidleadvacct_objid 
from province b 
where b.objid not in (select objid from province_taxaccount_mapping) 
