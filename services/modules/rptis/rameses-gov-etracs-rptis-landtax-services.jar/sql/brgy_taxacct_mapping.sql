[getUnmappedBarangays]
SELECT 
	b.objid AS barangayid, 
	CONCAT(b.name, ', ', CASE WHEN m.objid IS NULL THEN c.name ELSE m.name END ) AS name,
	b.indexno 
FROM barangay b
	INNER JOIN sys_org sb ON b.objid = sb.objid 
	LEFT JOIN sys_org sp ON sb.parent_objid = sp.objid 
	LEFT JOIN district d ON sp.objid = d.objid 
	LEFT JOIN city c ON sp.parent_objid= c.objid 
	LEFT JOIN municipality m ON sp.objid = m.objid 
	LEFT JOIN province p ON sp.parent_objid = p.objid 
WHERE NOT EXISTS(SELECT * FROM brgy_taxaccount_mapping WHERE barangayid = b.objid)
ORDER BY b.pin 

[getMappings]
SELECT 
	bm.*,
	CONCAT(b.name, ', ', CASE WHEN m.objid IS NULL THEN c.name ELSE m.name END ) AS name,
	b.indexno,
	prior.title AS basicprioracct_title, 
	priorint.title AS basicpriorintacct_title,
	prev.title AS basicprevacct_title, 
	prevint.title AS basicprevintacct_title,
	curr.title AS basiccurracct_title, 
	currint.title AS basiccurrintacct_title,
	adv.title AS basicadvacct_title
FROM brgy_taxaccount_mapping bm
	INNER JOIN barangay b ON bm.barangayid = b.objid 
	INNER JOIN sys_org sb ON b.objid = sb.objid 
	LEFT JOIN sys_org sp ON sb.parent_objid = sp.objid 
	LEFT JOIN district d ON sp.objid = d.objid 
	LEFT JOIN city c ON sp.parent_objid= c.objid 
	LEFT JOIN municipality m ON sp.objid = m.objid 
	LEFT JOIN province p ON sp.parent_objid = p.objid 
	LEFT JOIN itemaccount prior ON bm.basicprioracct_objid = prior.objid 
	LEFT JOIN itemaccount priorint ON bm.basicpriorintacct_objid = priorint.objid 
	LEFT JOIN itemaccount prev ON bm.basicprevacct_objid = prev.objid 
	LEFT JOIN itemaccount prevint ON bm.basicprevintacct_objid = prevint.objid 
	LEFT JOIN itemaccount curr ON bm.basiccurracct_objid = curr.objid 
	LEFT JOIN itemaccount currint ON bm.basiccurrintacct_objid = currint.objid 
	LEFT JOIN itemaccount adv ON bm.basicadvacct_objid = adv.objid 
ORDER BY b.name


[findBarangayStats]
select count(objid) as totalcount from barangay 


[buildItemAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select * from ( 
	select 
		concat(xx.objid,':brgy:',b.objid) as objid, 'APPROVED' as state, '-' as code, 
		concat('BRGY. ', b.name , ' ' , ia.title) as title, 
		concat('BRGY. ', b.name , ' ' , ia.title) as description, ia.type, 
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
	)xx 
		inner join itemaccount ia on xx.item_objid=ia.objid, barangay b 
	order by b.objid, xx.objid  
)xx 
where objid not in (select objid from itemaccount) 


[removeAccountMappings]
delete from brgy_taxaccount_mapping where 1=1


[buildAccountMappings]
insert into brgy_taxaccount_mapping ( 
	barangayid, basicadvacct_objid, basicprevacct_objid, basicprevintacct_objid, 
	basicprioracct_objid, basicpriorintacct_objid, basiccurracct_objid, basiccurrintacct_objid
) 
select 
	b.objid as barangayid, 
	(select objid from itemaccount where objid=concat('basicadvance:brgy:',b.objid)) as basicadvacct_objid,  
	(select objid from itemaccount where objid=concat('basicprev:brgy:',b.objid)) as basicprevacct_objid,  
	(select objid from itemaccount where objid=concat('basicprevint:brgy:',b.objid)) as basicprevintacct_objid,  
	(select objid from itemaccount where objid=concat('basicprior:brgy:',b.objid)) as basicprioracct_objid,  
	(select objid from itemaccount where objid=concat('basicpriorint:brgy:',b.objid)) as basicpriorintacct_objid,  
	(select objid from itemaccount where objid=concat('basiccurrent:brgy:',b.objid)) as basiccurracct_objid,  
	(select objid from itemaccount where objid=concat('basiccurrentint:brgy:',b.objid)) as basiccurrintacct_objid 
from barangay b 
where b.objid not in (select barangayid from brgy_taxaccount_mapping) 
