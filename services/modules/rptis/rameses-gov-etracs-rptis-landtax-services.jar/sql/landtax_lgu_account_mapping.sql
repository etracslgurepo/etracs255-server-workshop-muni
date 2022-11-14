[getLgus]
select o.objid, o.code, o.name, o.orgclass 
from sys_org o 
where o.orgclass in ('city', 'province', 'municipality', 'barangay')
order by o.code 

[deleteLandTaxAccountTags]
delete from itemaccount_tag where acctid like 'RPT_%'

[deleteLandTaxAccounts]
delete from itemaccount where objid like 'RPT_%'


[insertRevenueAccounts]
INSERT INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
)
SELECT 'RPT_BASIC_ADVANCE', 'ACTIVE', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_BASIC_CURRENT', 'ACTIVE', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_BASICINT_CURRENT', 'ACTIVE', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_BASIC_PREVIOUS', 'ACTIVE', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_BASICINT_PREVIOUS', 'ACTIVE', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_BASIC_PRIOR', 'ACTIVE', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_BASICINT_PRIOR', 'ACTIVE', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_SEF_ADVANCE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_SEF_CURRENT', 'ACTIVE', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_SEFINT_CURRENT', 'ACTIVE', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_SEF_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_SEFINT_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_SEF_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION
SELECT 'RPT_SEFINT_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL


[insertRevenueAccountTags]
insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE' as objid, 'RPT_BASIC_ADVANCE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT' as objid, 'RPT_BASIC_CURRENT' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT' as objid, 'RPT_BASICINT_CURRENT' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS' as objid, 'RPT_BASIC_PREVIOUS' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS' as objid, 'RPT_BASICINT_PREVIOUS' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR' as objid, 'RPT_BASIC_PRIOR' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR' as objid, 'RPT_BASICINT_PRIOR' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE' as objid, 'RPT_SEF_ADVANCE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT' as objid, 'RPT_SEF_CURRENT' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT' as objid, 'RPT_SEFINT_CURRENT' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS' as objid, 'RPT_SEF_PREVIOUS' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS' as objid, 'RPT_SEFINT_PREVIOUS' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR' as objid, 'RPT_SEF_PRIOR' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR' as objid, 'RPT_SEFINT_PRIOR' as acctid, 'rpt_sefint_prior' as tag




[insertProvinceSharePayableAccounts]
INSERT INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE PROVINCE SHARE', 'RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PROVINCE SHARE', 'RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PROVINCE SHARE', 'RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE PROVINCE SHARE', 'RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PROVINCE SHARE', 'RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PROVINCE SHARE', 'RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PROVINCE SHARE', 'RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL


[insertProvinceSharePayableAccountTags]
insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASIC_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASIC_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_SEF_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEF_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEF_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sefint_prior' as tag


[insertMunicipalitySharePayableAccounts]
INSERT INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_ADVANCE_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE MUNICIPALITY SHARE', 'RPT BASIC ADVANCE MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT MUNICIPALITY SHARE', 'RPT BASIC CURRENT MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PENALTY MUNICIPALITY SHARE', 'RPT BASIC CURRENT PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS MUNICIPALITY SHARE', 'RPT BASIC PREVIOUS MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PENALTY MUNICIPALITY SHARE', 'RPT BASIC PREVIOUS PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR MUNICIPALITY SHARE', 'RPT BASIC PRIOR MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PENALTY MUNICIPALITY SHARE', 'RPT BASIC PRIOR PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_ADVANCE_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE MUNICIPALITY SHARE', 'RPT SEF ADVANCE MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT MUNICIPALITY SHARE', 'RPT SEF CURRENT MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEFINT_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PENALTY MUNICIPALITY SHARE', 'RPT SEF CURRENT PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS MUNICIPALITY SHARE', 'RPT SEF PREVIOUS MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEFINT_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PENALTY MUNICIPALITY SHARE', 'RPT SEF PREVIOUS PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEF_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR MUNICIPALITY SHARE', 'RPT SEF PRIOR MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_SEFINT_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PENALTY MUNICIPALITY SHARE', 'RPT SEF PRIOR PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL


[insertMunicipalitySharePayableAccountTags]
insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_ADVANCE_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_BASICINT_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_BASICINT_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_ADVANCE_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_SEFINT_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_SEFINT_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_SEFINT_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_sefint_prior' as tag;



[insertBrgySharePayableAccounts]
INSERT INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_ADVANCE_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASIC_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
UNION 
SELECT 'RPT_BASICINT_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL


[insertBrgySharePayableAccountTags]
insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_BRGY_SHARE' as objid, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_BRGY_SHARE' as objid, 'RPT_BASIC_CURRENT_BRGY_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_BRGY_SHARE' as objid, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_BRGY_SHARE' as objid, 'RPT_BASIC_PRIOR_BRGY_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_BRGY_SHARE' as objid, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as acctid, 'rpt_basicint_prior' as tag




[buildCityRevenueAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	concat(l.name , ' ' , ia.title) as title, 
	concat(l.name , ' ' , ia.title) as description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, ia.objid as parentid 
from itemaccount ia, city l 
where concat(ia.objid,':',l.objid) not in (select objid from itemaccount) 
and ia.type = 'REVENUE'
and ia.objid like 'rpt_%' 
and ia.objid not like 'RPT%SHARE%'



[buildMunicipalityRevenueAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	concat(l.name , ' ' , ia.title) as title, 
	concat(l.name , ' ' , ia.title) as description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, ia.objid as parentid 
from itemaccount ia, municipality l 
where concat(ia.objid,':',l.objid) not in (select objid from itemaccount) 
and ia.type = 'REVENUE'
and ia.objid like 'rpt_%' 
and ia.objid not like 'RPT%SHARE%'



[buildProvinceRevenueAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	concat(l.name , ' ' , ia.title) as title, 
	concat(l.name , ' ' , ia.title) as description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, ia.objid as parentid 
from itemaccount ia, province l 
where concat(ia.objid,':',l.objid) not in (select objid from itemaccount) 
and ia.type = 'REVENUE'
and ia.objid like 'rpt_%' 
and ia.objid not like 'RPT%SHARE%'



[buildBrgyShareAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	concat(l.name , ' ' , ia.title) as title, 
	concat(l.name , ' ' , ia.title) as description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, ia.objid as parentid 
from itemaccount ia, barangay l 
where concat(ia.objid,':',l.objid) not in (select objid from itemaccount) 
and ia.type = 'PAYABLE'
and ia.objid like 'rpt_%brgy_share'



[buildProvinceShareAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	concat(l.name , ' ' , ia.title) as title, 
	concat(l.name , ' ' , ia.title) as description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, ia.objid as parentid 
from itemaccount ia, province l 
where concat(ia.objid,':',l.objid) not in (select objid from itemaccount) 
and ia.type = 'PAYABLE'
and ia.objid like 'rpt_%province_share'


[buildMunicipalityShareAccounts]
insert into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	concat(l.name , ' ' , ia.title) as title, 
	concat(l.name , ' ' , ia.title) as description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, ia.objid as parentid 
from itemaccount ia, municipality l 
where concat(ia.objid,':',l.objid) not in (select objid from itemaccount) 
and ia.type = 'PAYABLE'
and ia.objid like 'rpt_%municipality_share'


