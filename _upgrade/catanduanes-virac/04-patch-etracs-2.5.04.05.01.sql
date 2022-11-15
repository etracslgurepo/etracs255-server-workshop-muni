-- ## 2022-07-11

CREATE TABLE sys_report_template (
  name varchar(100) NOT NULL,
  title varchar(255) NULL,
  filepath varchar(255) NOT NULL,
  master int NULL,
  icon mediumblob,
  constraint pk_sys_report_template PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index uix_filepath on sys_report_template (filepath)
;


CREATE TABLE sys_report_def (
  name varchar(100) NOT NULL,
  title varchar(255) NULL,
  category varchar(255) NULL,
  template varchar(255) NULL,
  reportheader varchar(100) NULL,
  role varchar(50) NULL,
  sortorder int NULL,
  statement longtext, 
  permission varchar(100) NULL,
  parameters longtext,
  querytype varchar(50) NULL,
  state varchar(10) NULL,
  description varchar(255) NULL,
  properties longtext,
  constraint pk_sys_report_def PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_template on sys_report_def (template)
;


CREATE TABLE sys_report_subreport_def (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NULL,
  reportid varchar(100) NULL,
  name varchar(50) NULL,
  querytype varchar(50) NULL,
  statement longtext,
  constraint pk_sys_report_subreport_def PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_reportid on sys_report_subreport_def (reportid)
;
alter table sys_report_subreport_def 
  add CONSTRAINT fk_sys_report_subreport_def_reportid 
  FOREIGN KEY (reportid) REFERENCES sys_report_def (name)
;


INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
VALUES ('ENTERPRISE.REPORT_EDITOR', 'ENTERPRISE REPORT_EDITOR', 'ENTERPRISE', NULL, NULL, 'REPORT_EDITOR');


CREATE TABLE barcode_launcher (
  objid varchar(50) NOT NULL,
  connection varchar(50) NULL,
  paymentorder int NULL,
  collectiontypeid varchar(50) NULL,
  title varchar(255) NULL,
  constraint pk_barcode_launcher PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS paymentorder_paid
;
DROP TABLE IF EXISTS paymentorder
;
DROP TABLE IF EXISTS paymentorder_type
;

CREATE TABLE paymentorder_type (
  objid varchar(50) NOT NULL,
  title varchar(150) NULL,
  collectiontype_objid varchar(50) NULL,
  collectiontype_name varchar(50) NULL,
  system int NULL,
  constraint pk_paymentorder_type PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_collectiontytpe_objid on paymentorder_type  (collectiontype_objid)
;

CREATE TABLE paymentorder (
  objid varchar(50) NOT NULL,
  txndate datetime NULL,
  typeid varchar(50) NULL,
  payer_objid varchar(50) NULL,
  payer_name text,
  paidby text,
  paidbyaddress varchar(150) NULL,
  particulars varchar(500) NULL,
  amount decimal(16,2) NULL,
  expirydate date NULL,
  refid varchar(50) NULL,
  refno varchar(50) NULL,
  params text,
  origin varchar(100) NULL,
  controlno varchar(50) NULL,
  locationid varchar(25) NULL,
  items longtext,
  state varchar(20) NULL,
  email varchar(255) NULL,
  mobileno varchar(50) NULL,
  issuedby_objid varchar(50) NULL,
  issuedby_name varchar(150) NULL,
  constraint pk_paymentorder PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_typeid on paymentorder (typeid)
;
alter table paymentorder 
  add CONSTRAINT fk_paymentorder_typeid 
  FOREIGN KEY (typeid) REFERENCES paymentorder_type (objid)
;


alter table collectiontype add `connection` varchar(150) NULL
;
alter table collectiontype add servicename varchar(255) NULL
;


DROP VIEW IF EXISTS vw_collectiontype
;
CREATE VIEW vw_collectiontype AS 
select 
  c.objid AS objid,
  c.state AS state,
  c.name AS name,
  c.title AS title,
  c.formno AS formno,
  c.handler AS handler,
  c.allowbatch AS allowbatch,
  c.barcodekey AS barcodekey,
  c.allowonline AS allowonline,
  c.allowoffline AS allowoffline,
  c.sortorder AS sortorder,
  o.org_objid AS orgid,
  c.fund_objid AS fund_objid,
  c.fund_title AS fund_title,
  c.category AS category,
  c.queuesection AS queuesection,
  c.system AS system,
  af.formtype AS af_formtype,
  af.serieslength AS af_serieslength,
  af.denomination AS af_denomination,
  af.baseunit AS af_baseunit,
  c.allowpaymentorder AS allowpaymentorder,
  c.allowkiosk AS allowkiosk,
  c.allowcreditmemo AS allowcreditmemo,
  c.connection AS connection,
  c.servicename AS servicename 
from collectiontype_org o 
  inner join collectiontype c on c.objid = o.collectiontypeid 
  inner join af on af.objid = c.formno 
where c.state = 'ACTIVE' 
union 
select 
  c.objid AS objid,
  c.state AS state,
  c.name AS name,
  c.title AS title,
  c.formno AS formno,
  c.handler AS handler,
  c.allowbatch AS allowbatch,
  c.barcodekey AS barcodekey,
  c.allowonline AS allowonline,
  c.allowoffline AS allowoffline,
  c.sortorder AS sortorder,NULL AS orgid,
  c.fund_objid AS fund_objid,
  c.fund_title AS fund_title,
  c.category AS category,
  c.queuesection AS queuesection,
  c.system AS system,
  af.formtype AS af_formtype,
  af.serieslength AS af_serieslength,
  af.denomination AS af_denomination,
  af.baseunit AS af_baseunit,
  c.allowpaymentorder AS allowpaymentorder,
  c.allowkiosk AS allowkiosk,
  c.allowcreditmemo AS allowcreditmemo,
  c.connection AS connection,
  c.servicename AS servicename 
from collectiontype c 
  inner join af on af.objid = c.formno 
  left join collectiontype_org o on c.objid = o.collectiontypeid 
where o.objid is null 
  and c.state = 'ACTIVE'
;


INSERT INTO barcode_launcher (objid, connection, paymentorder, collectiontypeid, title) 
VALUES ('PMO', 'default', '1', NULL, 'PAYMENT ORDER ETRACS');

INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
VALUES ('TREASURY.PO_MASTER', 'TREASURY PO MASTER', 'TREASURY', 'usergroup', NULL, 'PO_MASTER');

update 
  collectiontype aa, 
  ( 
    select ct.objid, p.connection, p.servicename 
    from collectiontype ct 
      inner join cashreceipt_plugin p on p.objid = ct.handler 
    where ct.servicename is null 
  )bb 
set
  aa.connection = bb.connection, 
  aa.servicename = bb.servicename 
where 
  aa.objid = bb.objid
;

drop table cashreceipt_plugin
;



update collectiontype set barcodekey=null where trim(barcodekey) = ''
;

insert into barcode_launcher (
  objid, collectiontypeid, title, paymentorder, `connection`
)
select 
  t1.barcodekey as objid, t1.collectiontypeid, ct.title, 
  0 as paymentorder, null as `connection`
from ( 
  select t0.*, 
    (
      select objid from collectiontype 
      where barcodekey = t0.barcodekey 
        and state = 'ACTIVE' 
      order by name limit 1 
    ) as collectiontypeid 
  from ( 
    select distinct barcodekey 
    from collectiontype 
    where barcodekey IS NOT NULL
      and state = 'ACTIVE' 
  )t0 
)t1, collectiontype ct 
where ct.objid = t1.collectiontypeid 
  and (select count(*) from barcode_launcher where objid = t1.barcodekey) = 0 
;

update collectiontype set barcodekey = null
; 

update barcode_launcher set paymentorder=0 where paymentorder is null 
;
alter table barcode_launcher modify paymentorder int not null default '0'
;



-- ## 2022-08-01

alter table paymentorder_type add accesstype int not null default '0'
; 
alter table paymentorder_type add barcodeid varchar(50) null 
; 
update paymentorder_type set barcodeid = 'PMO' where barcodeid is null 
; 
alter table paymentorder_type modify barcodeid varchar(50) not null 
; 

update paymentorder_type set 
  `system` = (case 
    when `system` is null then 0 
    when `system` > 1 then 1
    else 0 
  end)
; 
alter table paymentorder_type modify `system` int not null default '0'
;


alter table paymentorder_type add state varchar(10) null 
; 
update paymentorder_type set state = 'ACTIVE'
;
alter table paymentorder_type modify state varchar(10) not null 
; 


alter table paymentorder_type add dtcreated datetime null
;
update paymentorder_type set dtcreated = NOW() where dtcreated is null
;
alter table paymentorder_type modify dtcreated datetime not null
;
create index ix_dtcreated on paymentorder_type (dtcreated)
;


alter table paymentorder_type add createdby_objid varchar(50) null 
;
update paymentorder_type set createdby_objid = '-' where createdby_objid is null 
;
alter table paymentorder_type modify createdby_objid varchar(50) not null 
;
create index ix_createdby_objid on paymentorder_type (createdby_objid)
;


alter table paymentorder_type add createdby_name varchar(150) null
;
update paymentorder_type set createdby_name = '-' where createdby_name is null 
;
alter table paymentorder_type modify createdby_name varchar(150) not null
;
create index ix_createdby_name on paymentorder_type (createdby_name)
;


alter table barcode_launcher drop column title
; 
alter table barcode_launcher add state varchar(10) null 
;
update barcode_launcher set state = 'ACTIVE' where state IS NULL 
; 
alter table barcode_launcher modify state varchar(10) not null 
;


update paymentorder set state = 'OPEN' where state is NULL
;
alter table paymentorder modify state varchar(10) not null
;


alter table paymentorder drop column origin
;
alter table paymentorder drop column controlno
;
alter table paymentorder drop column locationid
;
alter table paymentorder add org_objid varchar(50) null 
;
alter table paymentorder add org_name varchar(255) null 
;
create index ix_org_objid on paymentorder (org_objid)
; 


create index ix_txndate on paymentorder (txndate)
;
create index ix_payer_objid on paymentorder (payer_objid)
;
create index ix_paidby on paymentorder (paidby(255))
;
create index ix_state on paymentorder (state)
;
create index ix_issuedby_objid on paymentorder (issuedby_objid)
;
create index ix_issuedby_name on paymentorder (issuedby_name)
;


alter table paymentorder_type add `domain` varchar(50) null
;
alter table paymentorder_type add `role` varchar(50) null
;
create index ix_state on paymentorder_type (state)
;
create index ix_domain_role on paymentorder_type (`domain`, `role`)
;


delete from paymentorder_type where objid = 'GENERAL' 
;

insert into paymentorder_type (
  objid, title, collectiontype_objid, collectiontype_name, 
  system, accesstype, barcodeid, state, 
  dtcreated, createdby_objid, createdby_name 
) 
select * 
from ( 
  select 
    'GENERAL' as objid, 'GENERAL' as title, 
    t0.objid as collectiontype_objid, t0.name as collectiontype_name, 
    0 as system, 0 as accesstype, 'PMO' as barcodeid, 'ACTIVE' as state, 
    NOW() as dtcreated, '-' as createdby_objid, '-' as createdby_name 
  from ( 
    select * from collectiontype 
    where state = 'ACTIVE' 
      and formno = '51'
      and `handler` = 'misc'
      and title like 'general %' 
    order by title limit 1 
  )t0 
)t1 
where ( select count(*) from paymentorder_type where objid = t1.objid ) = 0 
; 

update 
  collectiontype ct, 
  paymentorder_type pt 
set 
  ct.allowpaymentorder = 1 
where 
  ct.objid = pt.collectiontype_objid 
; 




CREATE TABLE `paymentorder_paid` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `typeid` varchar(50) NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) NULL,
  `particulars` varchar(500) NULL,
  `amount` decimal(16,2) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `params` text,
  `items` longtext,
  `state` varchar(10) NOT NULL,
  `email` varchar(255) NULL,
  `mobileno` varchar(50) NULL,
  `issuedby_objid` varchar(50) NULL,
  `issuedby_name` varchar(150) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(255) NULL,
  constraint pk_paymentorder_paid PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_typeid` on paymentorder_paid (`typeid`)
;
create index `ix_org_objid` on paymentorder_paid (`org_objid`)
;
create index `ix_paidby` on paymentorder_paid (`paidby`(255))
;
create index `ix_txndate` on paymentorder_paid (`txndate`)
;
create index `ix_payer_objid` on paymentorder_paid (`payer_objid`)
;
create index `ix_state` on paymentorder_paid (`state`)
;
create index `ix_issuedby_objid` on paymentorder_paid (`issuedby_objid`)
;
create index `ix_issuedby_name` on paymentorder_paid (`issuedby_name`)
;
alter table paymentorder_paid add CONSTRAINT fk_paymentorder_paid_typeid 
  FOREIGN KEY (`typeid`) REFERENCES `paymentorder_type` (`objid`)
;


alter table entity_address modify parentid varchar(50) null 
; 


alter table paymentorder_paid add receiptid varchar(50) not null
;
alter table paymentorder_paid add receiptno varchar(30) not null
;
alter table paymentorder_paid add receiptdate date not null
;
alter table paymentorder_paid add receipttype varchar(20) not null 
;


CREATE TABLE `paymentorder_cancelled` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `typeid` varchar(50) NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) NULL,
  `particulars` varchar(500) NULL,
  `amount` decimal(16,2) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `params` text,
  `items` longtext,
  `state` varchar(10) NOT NULL,
  `email` varchar(255) NULL,
  `mobileno` varchar(50) NULL,
  `issuedby_objid` varchar(50) NULL,
  `issuedby_name` varchar(150) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(255) NULL,
  `dtcancelled` datetime NOT NULL,
  `cancelledby_objid` varchar(50) NOT NULL,
  `cancelledby_name` varchar(150) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  constraint pk_paymentorder_cancelled PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 
create index `ix_typeid` on paymentorder_cancelled (`typeid`)
;
create index `ix_org_objid` on paymentorder_cancelled (`org_objid`)
;
create index `ix_paidby` on paymentorder_cancelled (`paidby`(255))
;
create index `ix_txndate` on paymentorder_cancelled (`txndate`)
;
create index `ix_payer_objid` on paymentorder_cancelled (`payer_objid`)
;
create index `ix_state` on paymentorder_cancelled (`state`)
;
create index `ix_issuedby_objid` on paymentorder_cancelled (`issuedby_objid`)
;
create index `ix_issuedby_name` on paymentorder_cancelled (`issuedby_name`)
;
create index `ix_dtcancelled` on paymentorder_cancelled (`dtcancelled`)
;
create index `ix_cancelledby_objid` on paymentorder_cancelled (`cancelledby_objid`)
;
create index `ix_cancelledby_name` on paymentorder_cancelled (`cancelledby_name`)
;
alter table paymentorder_cancelled add CONSTRAINT fk_paymentorder_cancelled_typeid
  FOREIGN KEY (`typeid`) REFERENCES `paymentorder_type` (`objid`)
; 




-- ## 2022-09-05

DROP TABLE IF EXISTS psic_subclass;
DROP TABLE IF EXISTS psic_class;
DROP TABLE IF EXISTS psic_group;
DROP TABLE IF EXISTS psic_division;
DROP TABLE IF EXISTS psic_section;


CREATE TABLE psic_section (
  code varchar(1) NOT NULL,
  title varchar(255) NULL,
  description text,
  constraint pk_psic_section PRIMARY KEY (code) 
)
;

CREATE TABLE psic_division (
  code varchar(2) NOT NULL,
  description varchar(500) NULL,
  details text,
  sectionid varchar(1) NULL,
  constraint pk_psic_division PRIMARY KEY (code) 
)
;
create index ix_sectionid on psic_division (sectionid)
;
alter table psic_division add CONSTRAINT fk_psic_division_sectionid 
  FOREIGN KEY (sectionid) REFERENCES psic_section (code)
;


CREATE TABLE psic_group (
  code varchar(3) NOT NULL,
  description varchar(500) NULL,
  details text,
  divisionid varchar(2) NULL,
  constraint pk_psic_group PRIMARY KEY (code) 
)
;
create index ix_divisionid on psic_group (divisionid)
;
alter table psic_group 
  add CONSTRAINT fk_psic_group_divisionid 
  FOREIGN KEY (divisionid) REFERENCES psic_division (code)
;

CREATE TABLE psic_class (
  code varchar(4) NOT NULL,
  description varchar(500) NULL,
  details varchar(5000) NULL,
  groupid varchar(3) NULL,
  constraint pk_psic_class PRIMARY KEY (code)
)
;
create index ix_groupid on psic_class (groupid)
;
alter table psic_class add CONSTRAINT fk_psic_class_groupid 
  FOREIGN KEY (groupid) REFERENCES psic_group (code)
;

CREATE TABLE psic_subclass (
  code varchar(5) NOT NULL,
  description varchar(500) NULL,
  details text,
  classid varchar(4) NULL,
  constraint pk_psic_subclass PRIMARY KEY (code) 
)
;
create index ix_classid on psic_subclass (classid)
;
alter table psic_subclass 
  add  CONSTRAINT fk_psic_subclass_classid 
  FOREIGN KEY (classid) REFERENCES psic_class (code)
;



-- SECTION
INSERT INTO psic_section (code, title, description) VALUES ('A', NULL, 'Agriculture, Forestry and Fishing');
INSERT INTO psic_section (code, title, description) VALUES ('B', NULL, 'Mining and Quarrying');
INSERT INTO psic_section (code, title, description) VALUES ('C', NULL, 'Manufacturing');
INSERT INTO psic_section (code, title, description) VALUES ('D', NULL, 'Electricity, Gas, Steam and Air Conditioning Supply');
INSERT INTO psic_section (code, title, description) VALUES ('E', NULL, 'Water Supply; Sewerage, Waste Management and Remediation Activities');
INSERT INTO psic_section (code, title, description) VALUES ('F', NULL, 'Construction');
INSERT INTO psic_section (code, title, description) VALUES ('G', NULL, 'Wholesale and Retail Trade; Repair of Motor Vehicles and Motorcycles');
INSERT INTO psic_section (code, title, description) VALUES ('H', NULL, 'Transportation and Storage');
INSERT INTO psic_section (code, title, description) VALUES ('I', NULL, 'Accommodation and Food Service Activities');
INSERT INTO psic_section (code, title, description) VALUES ('J', NULL, 'Information and Communication');
INSERT INTO psic_section (code, title, description) VALUES ('K', NULL, 'Financial and Insurance Activities');
INSERT INTO psic_section (code, title, description) VALUES ('L', NULL, 'Real Estate Activities');
INSERT INTO psic_section (code, title, description) VALUES ('M', NULL, 'Professional, Scientific and Technical Activities');
INSERT INTO psic_section (code, title, description) VALUES ('N', NULL, 'Administrative and Support Service Activities');
INSERT INTO psic_section (code, title, description) VALUES ('O', NULL, 'Public Administration and Defense; Compulsory Social Security');
INSERT INTO psic_section (code, title, description) VALUES ('P', NULL, 'Education');
INSERT INTO psic_section (code, title, description) VALUES ('Q', NULL, 'Human Health and Social Work Activities');
INSERT INTO psic_section (code, title, description) VALUES ('R', NULL, 'Arts, Entertainment and Recreation');
INSERT INTO psic_section (code, title, description) VALUES ('S', NULL, 'Other Service Activities');
INSERT INTO psic_section (code, title, description) VALUES ('T', NULL, 'Activities of Households as Employers; Undifferentiated Goods-and Services-producing Activities of Households for Own Use');
INSERT INTO psic_section (code, title, description) VALUES ('U', NULL, 'Activities of Extra-territorial Organizations and Bodies');


-- DIVISION
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('01', 'Crop and Animal Production, Hunting and Related Service Activities\n', 'The division involves the production of food and non-food crops; livestock and poultry production and animal products; hunting and trapping of animals and related support activities. This includes production for the market or for own subsistence use; organically and genetically modified crops and livestock.', 'A');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('02', 'Forestry and Logging\n', 'This division includes the production of roundwood for the forest-based manufacturing industries (Division 16 & 17) as well as the extraction and gathering of wild growing non-wood forest products. Besides the production of timber, forestry activities result in products that undergo little processing such as fire wood, charcoal, wood chips and roundwood used in an unprocessed form (e.g. pit-props, pulpwood, etc.). These activities can be carried out in natural or planted forests.', 'A');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('03', 'Fishing and Aquaculture\n', 'This division includes capture fishery and aquaculture, covering the use of fishery resources from marine, brackish or freshwater environments, with the goal of capturing or gathering fish, crustaceans, mollusks and other marine organisms and products (e.g. aquatic plants, pearls, sponges etc.).\nAlso included are activities that are normally integrated in the process of production for own account (e.g. seeding oysters for pearl production).\nThis division excludes building and repairing of ships and boats 3011, 3315; and sport or recreational fishing activities, 9319. Processing of fish, crustaceans or mollusks is excluded whether at land-based plants or on factory ships, 1020.', 'A');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('05', 'Mining of Coal and Lignite\n', 'This division includes the extraction of solid mineral fuels includes through underground or open-cast mining and includes operations (e.g. grading, cleaning, compressing and other steps necessary for transportation etc.) leading to a marketable product.\nThis division excludes coking (see 1910), services incidental to coal or lignite mining (see 0990) or the manufacture of briquettes (see 1920).', 'B');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('06', 'Extraction of Crude Petroleum and Natural Gas\n', 'This division includes the production of crude petroleum, the mining and extraction of oil from oil shale and oil sands, and the production of natural gas and recovery of hydrocarbon liquids. This division also includes the activities of operating and/or developing oil and gas field properties such as drilling, completing and equipping wells, operating separators, emulsion breakers, desilting equipment and field gathering lines for crude petroleum and all other activities in the preparation of oil and gas up to the point of shipment from the producing property.', 'B');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('07', 'Mining of Metal Ores\n', 'This division includes mining for metallic minerals (ores), performed through underground or open-cast extraction, seabed mining etc. Also included are ore dressing and beneficiating operations, such as crushing, grinding, washing, drying, sintering, calcining or leaching ore, gravity separation or flotation operations.', 'B');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('08', 'Other Mining and Quarrying\n', 'This division includes extraction from a mine or quarry, but also dredging of alluvial deposits, rock crushing and the use of salt marshes. The products are used most notably in construction (e.g. sands, stones, etc.), manufacture of materials (e.g. clay, gypsum, calcium etc.), manufacture of chemicals etc.\nThis division does not include processing (except crushing, grinding, cutting, cleaning, drying, sorting and mixing.) of the mineral extracted.', 'B');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('09', 'Mining Support Service Activities\n', 'This division includes specialized support services incidental to mining provided on a fee or contract basis. It includes exploration services through traditional prospecting methods such as taking core samples and making geological observations as well as drilling, test-drilling or redrilling for oil wells, metallic and non-metallic minerals, Other typical services cover building oil and gas well foundations, cementing oil and gas well casings, cleaning, bailing and swabbing oil and gas wells, draining and pumping mines, overburden removal services at mines, etc.', 'B');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('10', 'Manufacture of Food Products\n', 'This division includes the processing of the product of agriculture, forestry and fishing into human or animals food, and includes intermediate products that are not directly food products and may be of greater or lesser value. This division is organized by activities dealing with different kinds of food products. Production can be carried out for own account or by third party. Some activities are considered manufacturing even though there is retail sale of the products in the producerNULLs own shop. However, where the processing is minimal and does not lead to a real transformation, the unit is classified to Wholesale and retail trade (Section G).', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('11', 'Manufacture of Beverages\n', 'This division includes the manufacture of beverages, such as non-alcoholic beverages and mineral water, manufacture of alcoholic beverages mainly through fermentation, beer and wine, and the manufacture of distilled alcoholic beverages.\nThis division excludes the production of fruit and vegetable juices, milk-based drinks, and the manufacture of coffee, tea and mate products.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('12', 'Manufacture of Tobacco Products', NULL, 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('13', 'Manufacture of Textiles\n', 'This division includes preparation and spinning of textile fibers, weaving and finishing of textiles and wearing apparel, manufacture of made-up textile articles, except apparel (e.g. household linen, blankets, rugs, cordage etc.).\nThis division excludes the growing of natural fibers or the manufacture of synthetic fibers and manufacture of wearing apparel.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('14', 'Manufacture of Wearing Apparel\n', 'This division includes all tailoring (ready-to-wear or made-to-measure), in all materials (e.g. leather, fabric, knitted and crocheted fabrics etc.) of all items of clothing (e.g. outerwear, underwear for men, women or children; work, city or casual clothing etc. ) and accessories. There is no distinction made between between modern and traditional clothing. Division 14 also includes the fur industry (fur skin and wearing apparel).\nThis division includes manufacture of wearing apparel. The material used may be of any kind and may be coated, impregnated or rubberized. This includes leather or composition leather, woven, knitted or crocheted fabric, non-woven, footwear of textile material without applied soles, underwear and nightwear, work wear, T-shirts, dressing gowns, blouses, babies garments, sports wear, hats and caps and other clothing accessories (such as gloves, belts, shawls ties, cravats, hairnets etc.) for men, women and children. This class also includes custom tailoring, the manufacture of and the parts of the products as previously listed.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('15', 'Manufacture of Leather and Related Products\n', 'This division includes the transformation of hides into leather by tanning or curing and fabricating the leather into products for final consumption. It also includes the manufacture of similar products from other materials (imitation leathers or leather substitutes) such as rubber footwear, textile luggage etc. The products made from leather substitutes are included here, since they are made in ways similar to those in which leather products are made (e.g. luggage) and are often produced in the same unit.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('16', 'Manufacture of Wood and of Products of Wood and Cork, Except Furniture; Manufacture of Articles of Bamboo, Cane, Rattan and the Like; Manufacture of Articles of Straw and Plaiting Materials\n', 'This division includes the manufacture of wood products, mostly used for construction, and includes various processes from sawing, to shaping and assembling of wood products, and assembling into finished products, such as wood containers. With the exception of sawmilling, this division is subdivided mainly based on the specific products manufactured.\nThis does not include the manufacture of furniture, or the installation of wooden fittings and the like.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('17', 'Manufacture of Paper and Paper Products\n', 'This division includes the manufacture of pulp, paper and converted paper products. The manufacture of these products is grouped together because they constitute a series of vertically connected processes. More than one activity is often carried out in a single unit. There are essentially three activities : (a) The manufacture of pulp involves separating the cellulose fibers from other impurities in wood or used paper (b) The manufacture of paper involves matting these fibers into a sheet and (c) Converted paper products are made from paper and other materials by various cutting and shaping techniques, including costing and laminating activities. The paper articles may be printed (e.g. wallpaper, gift wrap etc.), as long as the printing of information is not the main purpose.\nThe production of pulp, paper and paperboard in bulk is included in class 1701, while the remaining classes include the production of further-processed paper and paper products.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('18', 'Printing and Reproduction of Recorded Media\n', '\nThis division includes printing of products, such as newspapers, books, periodicals, business forms, greeting cards, and other materials, and associated support activities, such as bookbinding, plate-making services, and data imaging. The support activities included here are an integral part of the printing industry, and a product (a printing plate, a bound book, or a computer disk or file) that is an integral part of the printing industry is almost always provided by these operations.\nProcesses used in printing include a variety of methods for transferring an image from a plate, screen, or computer file to a medium, such as paper, plastics, metal, textile articles, or wood. The most prominent of these methods entails the transfer of the image from a plate or screen to the medium through lithographic, gravure, screen or flexographic printing. Often a computer file is used to directly \"drive\" the printing mechanism to create the image or electrostatic and other types of equipment (digital or non-impact printing).\nThough printing and publishing can be carried out by the same unit (a newspaper, for example), it is less and less the case that these distinct activities are carried out in the same physical location.\nThis division also includes the reproduction of recorded media, such as compact discs, video recordings, software on discs or tapes, records, etc.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('19', 'Manufacture of Coke and Refined Petroleum Products\n', 'This division includes the transformation of crude petroleum and coal into usable products. The dominant process is petroleum refining which involves the separation of crude petroleum into component products through such techniques as cracking and distillation. This division also includes the manufacture for own account of characteristic products (e.g. coke, butane, propane, petrol, kerosene, fuel oil etc.) as well as processing services (e.g. custom refining).\nThis division includes the manufacture of gases such as ethane, propane and butane as products of petroleum refineries.\nThis division excludes the manufacture of such gases in other units (2011), manufacture of industrial gases (2011), extraction of natural gas (methane, ethane, butane or propane) (0620), and manufacture of fuel gas, other than petroleum gases (e.g. coal gas, water gas, producer gas, gasworks gas (1990).\nThe manufacture of petrochemicals from refined petroleum is classified in Division 20.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('20', 'Manufacture of Chemicals and Chemical Products\n', 'This division includes the transformation of organic and inorganic raw materials by a chemical process and the formation of products. It distinguishes the production of basic chemicals that constitute the first industry group from the production of intermediate and end products produced by further processing of basic chemicals that make up the remaining industry classes.\nManufacture of basic chemicals, fertilizers and nitrogen compounds, plastic and synthetic rubber in primary forms.\nThis group includes the manufacture of basic chemical products, fertilizers and associated nitrogen compounds, as well as plastics and synthetic rubber in primary forms.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('21', 'Manufacture of Basic Pharmaceutical Products and Pharmaceutical Preparations\n', 'This division includes the manufacture of basic pharmaceutical products and pharmaceutical preparations. It also includes the manufacture of medicinal chemical and botanical products.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('22', 'Manufacture of Rubber and Plastic Products\n', 'This division includes the manufacture of rubber and plastic products. This is characterized by the raw materials used in the manufacturing process. However, this does not imply that the manufacture of all products made of these materials is classified here.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('23', 'Manufacture of Other Non-metallic Mineral Products\n', 'This division includes manufacturing activities related to a single substance of mineral origin. This division includes the manufacture of glass and glass products (e.g. flat glass, hollow glass, fibers, technical glassware, etc.), ceramic products, tiles and baked clay products, and cement and plaster, from raw materials to finished articles. The manufacture of shaped and finished stone and other mineral products is also included in this division.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('24', 'Manufacture of Basic Metals\n', 'This division includes the activities of smelting and/or refining ferrous and non-ferrous metals from ore, pig or scrap, using electrometallurgic and other process metallurgic techniques. This division also includes the manufacture of metal alloys and super-alloys by introducing other chemical elements to pure metals. The output of smelting and refining, usually in ingot form, is used in rolling, drawing and extruding operations to make products, such as plate, sheet, strip, bars, rods, wire, tubes, pipes and hollow profiles, and in molten form to make castings and other basic metal products.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('25', 'Manufacture of Fabricated Metal Products, Except Machinery and Equipment\n', 'This division includes the manufacture of \"pure\" metal products (such as parts, containers and structures), usually with a static, immovable function, as opposed to the following divisions 26-30 which cover the manufacturing of combinations or assemblies of such metal products (sometimes with other materials) into more complex units that unless they are purely electrical, electronic or optical, work with moving parts. The manufacture of weapons and ammunition is also included in this division.\nThis division excludes :\nSpecialized repair and maintenance activities, see group 331;\nSpecialized installation of manufactured goods produced in this division in buildings, such as central heating boilers, see 4322.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('26', 'Manufacture of Computer, Electronic and Optical Products\n', 'This division includes the manufacture of computers, computer peripherals, communications equipment, and similar electronic products, as well as the manufacture of components for such products. Production processes of this division are characterized by the design and use of integrated circuits and the application of highly specialized miniaturization technologies.\nThe division also contains the manufacture of consumer electronics, measuring, testing, navigating, and control equipment, irradiation, electromedical and electrotherapeutic equipment, optical instruments and equipment and the manufacture of magnetic and optical media.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('27', 'Manufacture of Electrical Equipment\n', 'This division includes the manufacture of products that generate, distribute and use electrical power. Also included is the manufacture of electrical lighting, signalling equipment and electric household appliances.\nThis excludes the manufacture of electronic products (see division 26).', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('28', 'Manufacture of Machinery and Equipment, Nec\n', 'This division includes the manufacture of machinery and equipment that act independently on materials either mechanically or thermally or perform operation on materials (such as handling, spraying, weighing or packing), including their mechanical components that produce and apply force, and any specially manufactured primary parts. This category includes fixed and mobile or hand-held devices, regardless of whether they are designed for industrial, building and civil engineering , agricultural or home use. The manufacture of special equipment for passenger or freight transport within demarcated premises also belongs within this division.\nThis division also includes other special purpose machinery, not covered elsewhere in the classification, whether or nor used in a manufacturing process, such as fairground amusement equipment, automatic bowling alley equipment, etc.\nThis division excludes the manufacture of metal products for general use (division 25), associated control devices, computer equipment, measurement and testing equipment, electricity distribution and control apparatus (divisions 26 and 27) and general-purpose motor vehicles (divisions 29 and 30).', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('29', 'Manufacture of Motor Vehicles, Trailers and Semi-trailers\n', 'This division includes the manufacture of motor vehicles for transporting passengers or freight. The manufacture of various parts and accessories, as well as the manufacture of trailers and semi-trailers, is included here.\nThe maintenance and repair of vehicles produced in this division are classified in 4520.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('30', 'Manufacture of Other Transport Equipment\n', 'This division includes the manufacture of transportation equipment such as ship building and boat manufacturing, the manufacture of railroad rolling stock and locomotives, air and spacecraft and the manufacture of parts thereof.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('31', 'Manufacture of Furniture\n', 'This division includes the manufacture of furniture and related products of any material except stone, concrete and ceramic. The processes used in the manufacture of furniture are standard methods of forming materials and assembling components, including cutting, molding and laminating. The design of the article, for both aesthetic and functional qualities, is an important aspect of the production process.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('32', 'Other Manufacturing\n', 'This division includes the manufacture of a variety of goods not covered in other parts of the classification. Since this is a residual division, production processes, input materials and the use of the produced goods can vary widely and usual criteria for grouping classes into divisions have not been applied here.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('33', 'Repair and Installation of Machinery and Equipment\n', 'This division includes the specialized repair of goods produced in the manufacturing sector with the aim to restore machinery, equipment and other products to working order. The provision of general or routine maintenance (i.e. servicing) on such products to ensure they work efficiently and to prevent breakdown and unnecessary repairs is included.\nThis division does only include specialized repair and maintenance activities. A substantial amount of repair is also done by manufacturers of machinery, equipment and other goods, in which case the classification of units engaged in these repair and manufacturing activities is done according to the value-added principle which would often assign these combined activities to the manufacture of the good. The same principle is applied for combined trade and repair.\nThe rebuilding or remanufacturing of machinery and equipment is considered a manufacturing activity and included in other divisions of this section.\nRepair and maintenance of goods that are utilized as capital goods as well as consumer goods is typically classified as repair and maintenance of household goods (e.g. office and household furniture repair, see 9524).\nAlso included in this division is the specialized installation of machinery. However, the installation of equipment that forms an integral part of buildings or similar structures, such as installation of electrical wiring, installation of escalators or installation of air-conditioning systems, is classified as construction.\nThis division excludes cleaning of industrial machinery, see 8129; repair and maintenance of computers and communication equipment, see 951; repair and maintenance of household goods, see 952.', 'C');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('35', 'Electricity, Gas, Steam and Air Conditioning Supply', NULL, 'D');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('36', 'Water Collection, Treatment and Supply\n', 'This includes the collection, treatment and distribution of water for domestic and industrial needs. Collection of water from various sources, as well as distribution by various means is included.', 'E');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('37', 'Sewerage\n', 'This division includes the operation of sewer systems or sewage treatment facilities that collect, treat, and dispose of sewage.', 'E');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('38', 'Waste Collection, Treatment and Disposal Activities; Materials Recovery\n', 'This division includes the collection, treatment and disposal of waste materials. This also includes local hauling of waste materials and the operation of materials recovery facilities (i.e. those that sort recoverable materials from a waste stream).', 'E');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('39', 'Remediation Activities and Other Waste Management Services\n', 'This division includes the provision of remediation services, i.e. the cleanup of contaminated buildings and sites , soil, surface or ground water.', 'E');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('41', 'Construction of Buildings\n', 'This division includes general construction of buildings of all kinds. It includes new work, repair, additions and alterations, the erection of pre-fabricated buildings or structures on the site and also construction of temporary nature. Included is the construction of entire dwellings, office buildings, stores and other public and utility buildings, farm buildings, etc.', 'F');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('42', 'Civil Engineering\n', 'This division includes general construction for civil engineering objects which involves new work, repair, additions and alterations, the erection of pre-fabricated structures on the site and also construction of temporary nature.\nIncluded is the construction of heavy constructions such as motorways, streets, bridges, tunnels, railway, airfields, harbors and other water projects, irrigation systems, sewerage systems, industrial facilities, pipelines and electric lines, outdoor sports facilities, etc. This work can be carried out on own account or on a fee or contract basis. Portions of the work and sometimes even the whole practical work can be subcontracted out.', 'F');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('43', 'Specialized Construction Activities\n', 'This division includes specialized construction activities (special trades), i.e. the construction of parts of buildings and civil engineering works without responsibility for the entire project. These activities are usually specialized in one aspect common to different structures, requiring specialized skills or equipment, such as pile diving, foundation work, carcass work, concrete work, brick laying, stone setting, scaffolding, roof covering, etc. The erection of steel structures is included, provided that the parts not produced by the same unit. Specialized construction activities are mostly carried out under subcontract, but especially in repair construction it is done directly for the owner of the property.\nAlso included are building finishing and building completion activities.\nIncluded is the installation of all kind of utilities that make the construction function as such. These activities are usually performed at the site of the construction, although parts of the job may be carried out in a special shop. Included are activities such as plumbing, installation of heating and air-conditioning systems, antennas, alarm systems and other electrical work (water, heat, sound), sheet metal work, commercial refrigerating work, the installation of illumination and signalling systems for roads, railways, airports, harbors, etc.. Also included is the repair of the same type as the above-mentioned activities.\nBuilding completion activities encompass activities that contribute to the completion or finishing of a construction such as glazing, plastering, painting, floor and wall tiling or covering with other materials like parquet, carpets, wallpaper, etc. floor sanding, finish carpentry, acoustical work, cleaning of the exterior, etc. Also included is the repair of the same type as the above-mentioned activities.\nThe renting of construction equipment with operator is classified with the associated construction activity.', 'F');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('45', 'Wholesale and Retail Trade and Repair of Motor Vehicles and Motorcycles\n', 'This division includes all activities (except manufacture and renting) related to motor vehicles and motorcycles, including lorries and trucks, such as the wholesale and retail sale of new and second-hand vehicles, the repair and maintenance of vehicles and the wholesale and retail sale of parts and accessories for motor vehicles and motorcycles. Also included are activities of commission agents involved in wholesale or retail sale of vehicles. This division also includes activities such as washing, polishing of vehicles, etc.\nThis division does not include the retail sale of automotive fuel and lubricating or cooling products or the renting of motor vehicles or motorcycles.', 'G');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('46', 'Wholesale Trade, Except of Motor Vehicles and Motorcycles\n', 'This division includes wholesale trade on own account or on a fee or contract basis (commission trade) related to domestic wholesale trade as well as international wholesale trade (import/export).\nWholesale is the resale (sale without transformation) of new and used goods to retailers, business-to-business trade, such as to industrial, commercial, institutional or professional users, or resale to other wholesalers, or involves acting as an agent or broker in buying merchandise for, or selling merchandise to, such persons or companies. The principal types of businesses included are merchant wholesalers, i.e., wholesalers who take title to the goods they sell, such as wholesale merchants or jobbers, industrial distributors, exporters, importers, and cooperative buying associations, sales branches and sales offices (but not retail stores) that are maintained by manufacturing and mining units apart from their plants or mines for the purpose of marketing their products and that do not merely take orders to be filled by direct shipments from the plants or mines. Also included are merchandise and commodity brokers, commission merchants and agents and assemblers, buyers and cooperative associations engaged in the marketing of farm products.\nWholesalers frequently physically assemble, sort and grade goods in large lots, break bulk, repack and redistribute in smaller lots, for example pharmaceuticals; store, refrigerate, deliver and install goods, engage in sales promotion for their customers and label design.\nThis division excludes :\nWholesale of motor vehicles, caravans and motorcycles, see 4510, 4540;\nWholesale of motor vehicle accessories, see 4530, 4540;\nRenting and leasing of goods, see Division 77;\nPacking of solid goods and bottling of liquid or gaseous goods, including blending and filtering for third parties, see 8292.', 'G');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('47', 'Retail Trade, Except of Motor Vehicles and Motorcycles\n', '\nThis division includes the resale (sale without transformation) of new and used goods mainly to the general public, for personal or household consumption or utilization, by shops, department stores, stalls, mail-order houses, hawkers and peddlers, consumer cooperatives, etc.\nRetail trade is classified first by type of sale outlet (retail trade in stores: groups 471 to 477; retail trade not in stores: groups 478 and 479). Retail trade in stores includes the retail sale of used goods (class 4774). For retail sale in stores, there exists a further distinction between specialized retail sale (groups 472 to 477) and non-specialized retail sale (group 471). The above groups are further subdivided by the range of products sold. Sale not via stores is subdivided according to the forms of trade, such as retail sale via stalls and markets (group 478) and other non-store retail sale, e.g. mail order, door-to-door, by vending machines etc. (group 479).\nThe goods sold in this division are limited to goods usually referred to as consumer goods or retail goods. Therefore, goods not usually entering the retail trade, such as cereal grains, ores, industrial machinery, etc. are excluded. This division also includes units engaged primarily in selling to the general public, from displayed goods, products such as personal computers, stationery, paint or timber, although these sales may not be for personal or household use. Some processing of goods may be involved, but only incidental to selling, e.g. sorting or repacking of goods, installation of a domestic appliance, etc.\nThis division also includes the retail sale by commission agents and activities of retail auctioning houses.\nThis division excludes :\nSale of farmerNULLs products by farmers, see Division 01;\nManufacture and sale of goods, which is generally classified as manufacturing in divisions, 10-32;\nSale of motor vehicles, motorcycles and their parts, see Division 45;\nTrade in cereal grains, ores, crude petroleum, industrial chemicals, iron and steel and industrial machinery and equipment, see Division 46;\nSale of food and drinks for consumption on the premises and sale of take away food, see Division 56;\nRenting of personal and household goods to the general public, see Group 772.', 'G');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('49', 'Land Transport and Transport Via Pipelines\n', 'This division includes the transport of passengers and freight via road and rail, as well as freight transport via pipelines.', 'H');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('50', 'Water Transport\n', 'This division includes the transport of passengers or freight over water, whether scheduled or not. Also included are the operation of towing or pushing boats, excursion, cruise or sightseeing boats, ferries, water taxis etc. Although the location is an indicator for the separation between sea and inland water transport, the deciding factor is the type of vessel used. All transport on sea-going vessels is classified in group 501, while transport using other vessels is classified in group 502.\nThis division excludes restaurant and bar activities on board ships if carried out by separate units, see class 5610, 5630.', 'H');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('51', 'Air Transport\n', 'This division includes the transport of passengers or freight by air or via space.\nThis division excludes :\nOverhaul of aircraft or aircraft engines, see class 3315;\nSupport activities, such as the operation of airports, see class 5223;\nActivities that make use of aircraft, but not for the purpose of transportation, such as crop spraying, see class 015, aerial advertising, see class 7310 or aerial photography, see class 7420.', 'H');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('52', 'Warehousing and Support Activities for Transportation\n', 'This division includes warehousing and support activities for transportation, such as operating of transport infrastructure (e.g. airports, harbors, tunnels, bridges, etc.), the activities of transport agencies and cargo handling.', 'H');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('53', 'Postal and Courier Activities\n', 'This division includes postal and courier activities, such as pick-up, transport and delivery of letters and parcels under various arrangements. Local delivery and messenger services are also included.', 'H');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('55', 'Accommodation\n', 'This division includes the provision of short-stay accommodation for visitors and other travelers. Also included is the provision of longer-term accommodation for students, workers and similar individuals. Some units may provide only accommodation while others provide a combination of accommodation, meals and/or recreational facilities.\nThis division excludes activities related to the provision of long-term primary residences in facilities, such as apartments typically leased on a monthly or annual basis classified in Real Estate (Section L).', 'I');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('56', 'Food and Beverage Service Activities\n', 'This division includes food and beverage serving activities providing complete meals or drinks fit for immediate consumption, whether in traditional restaurants, self-service or take-away restaurants, whether as permanent or temporary stands with or without seating. Decisive is the fact that meals fit for immediate consumption are offered, not the kind of facility providing them.\nExcluded is the production of meals not fit for immediate consumption or not planned to be consumed immediately or of prepared food which is not considered to be a meal (see Division 10: Manufacture of food products and Division 11 : Manufacture of beverages). Also excluded is the sale of not self-manufactured food that is not considered to be a meal or of meals which are not fit for immediate consumption (see Section G: Wholesale and retail trade and repair of motor vehicles and motorcycles).', 'I');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('58', 'Publishing Activities\n', 'This division includes the publishing of books, brochures, leaflets, dictionaries, encyclopedias, atlases, maps and charts; publishing of newspapers, journals and periodicals; directory and mailing list and other publishing as well as software publishing.\nThis division excludes publishing of motion pictures, videotapes and movies on DVD or similar media (division 59) and the production of master copies for records or audio material (division 59). Also excluded is printing (see 1811) and the mass reproduction of recorded media (see 1820).', 'J');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('59', 'Motion Picture, Video and Television Programme Production, Sound Recording and Music Publishing Activities\n', 'This division includes production of theatrical and non-theatrical motion pictures whether on film, video tape or disc for direct projection in theatres or for broadcasting on television; supporting activities such as film editing, cutting, dubbing, etc.; distribution of motion pictures and other film productions to other industries; as well as motion picture or other film productions projection. Buying and selling of motion picture or other film productions distribution rights is also included.\nThis division also includes the sound recording activities, i.e. production of original sound master recordings, releasing, promoting and distributing them, publishing of music as well as sound recording service activities in a studio or elsewhere.', 'J');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('60', 'Programming and Broadcasting Activities\n', 'This division includes the activities of creating content or acquiring the right to distribute content and subsequently broadcasting that content, such as radio, television and data programs of entertainment, news, talk, and the like. Also included is data broadcasting, typically integrated with radio or TV broadcasting. The broadcasting can be performed using different technologies, over-the-air, via satellite, via a cable network or via internet. This division also includes the production of programs that are typically narrowcast in nature (limited format, such as news, sports, education, and youth-oriented programming) on a subscription or fee basis, to a third party, for subsequent broadcasting to the public.\nThis excludes the distribution of cable and other subscription programming (see division 61).', 'J');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('61', 'Telecommunications\n', 'This division includes the activities of providing telecommunications and related service activities, that is transmitting voice, data, text, sound and video. The transmission facilities that carry out these activities may be based on a single technology or a combination of technologies. The commonality of activities classified in this division is the transmission of content, without being involved in its creation. The breakdown in this division is based on the type of infrastructure operated.\nIn the case of transmission of television signals, this may include the bundling of complete programming channels (produced in division 60) to programme packages for distribution.', 'J');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('62', 'Computer Programming, Consultancy and Related Activities\n', 'This division includes the following activities of providing expertise in the field of information technologies: writing, modifying, testing and supporting software; planning and designing computer systems that integrate computer hardware, software and communication technologies; on-site management and operation of clientsNULL computer systems and/or data processing facilities; and other professional and technical computer-related activities.', 'J');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('63', 'Information Service Activities\n', 'This division includes the activities of web search portals, data processing and hosting activities, as well as other activities that primarily supply information.', 'J');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('64', 'Financial Service Activities, Except Insurance and Pension Funding\n', 'This division includes the activities of obtaining and redistributing funds other than for the purpose of insurance or pension funding or compulsory social security.\nNote: National institutional arrangements are likely to play a significant role in determining the classification within this division.', 'K');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('65', 'Insurance, Reinsurance and Pension Funding, Except Compulsory Social Security\n', 'This division includes the underwriting annuities and insurance policies and investing premiums to build up a portfolio of financial assets to be used against future claims. Provision of direct insurance and reinsurance is included.', 'K');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('66', 'Activities Auxiliary to Financial Service and Insurance Activities\n', 'This division includes the provision of services involved in or closely related to financial service activities, but not themselves providing financial services. The primary breakdown of this division is according to the type of financial transaction of funding served.', 'K');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('68', 'Real Estate Activities', NULL, 'L');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('69', 'Legal and Accounting Activities\n', 'This division includes legal representation of one partyNULLs interest against another party, whether or not before courts or other judicial bodies by, or under supervision of, persons who are members of the bar, such as advice and representation in civil cases, advice and representation in criminal actions, advice and representation in connection with labor disputes. It also includes preparation of legal documents such as articles of incorporation, partnership agreements or similar documents in connection with company formation, patents and copyrights, preparation of deeds, wills, trusts, etc. as well as other activities of notaries public, civil law notaries, bailiffs, arbitrators, examiners and referees. It also includes accounting and bookkeeping services such as auditing of accounting records, preparing financial statement and bookkeeping.', 'M');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('70', 'Activities of Head Offices; Management Consultancy Activities\n', 'This division includes the provision of advice and assistance to businesses and other organizations on management issues, such as strategic and organizational planning; financial planning and budgeting; marketing objectives and policies; human resource policies, practices, and planning; production scheduling; and control planning. It also includes the overseeing and managing of other units of the same company or enterprise, i.e. the activities of head offices.', 'M');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('71', 'Architectural and Engineering Activities; Technical Testing and Analysis\n', 'This division includes the provision of architectural services, engineering services, drafting services, building inspection services and surveying and mapping services. It also includes the performance of physical, chemical, and other analytical testing services.', 'M');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('72', 'Scientific Research and Development\n', 'This division includes the activities of three types of research and development : 1) basic research: experimental or theoretical work undertaken primarily to acquire new knowledge of the underlying foundations of phenomena and observable facts, without particular application or use in view; 2) applied research: original investigation undertaken in order to acquire new knowledge, directed primarily towards a specific practical aim or objective and 3) experimental development: systematic work, drawing on existing knowledge gained from research and/or practical experience, directed to producing new materials, products and devices, to installing new processes, systems and services, and to improving substantially those already produced or installed.\nResearch and experimental development activities in this division are subdivided into two categories: natural sciences and engineering; social sciences and the humanities.\nThis division excludes market research, see 7320.', 'M');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('73', 'Advertising and Market Research\n', 'This division includes the creation of advertising campaigns and placement of such advertising in periodicals, newspapers, radio and television, or other media as well as the design of display structures and sites.', 'M');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('74', 'Other Professional, Scientific and Technical Activities\n', 'This division includes the provision of professional, scientific and technical services (except legal and accounting activities; architecture and engineering activities; technical testing and analysis; management and management consultancy activities; research and development and advertising activities).', 'M');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('75', 'Veterinary Activities\n', 'This division includes the provision of animal health care and control activities for farm animals or pet animals. These activities are carried out by qualified veterinarians in veterinary hospitals as well as when visiting farms, kennels or homes, in own consulting and surgery rooms or elsewhere. It also includes animal ambulance activities.', 'M');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('77', 'Rental and Leasing Activities\n', 'This division includes the rental and leasing of tangible and non-financial intangible assets, including a wide array of tangible goods, such as automobiles, computers, consumer goods and industrial machinery and equipment to customers in return for a periodic rental or lease payment. It is subdivided into: (1) renting and leasing of motor vehicles, (2) renting and leasing of personal and household goods, (3) renting and leasing of other machinery, equipment and tangible goods, n.e.c. and (4) leasing of intellectual property products and similar products.\nOnly the provision of operating leases is included in this division.\nThis division excludes financial leasing, see 6491; renting of real estate, see Section L; and renting of equipment with operator. The latter is classified according to the activities carried out with this equipment, e.g. construction (F) or transportation (H).', 'N');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('78', 'Employment Activities\n', 'This division includes activities of listing employment vacancies and referring or placing applicants for employment, where the individuals referred or placed are not employees of the employment agencies, supplying workers to clientNULLs businesses for limited periods of time to supplement the working force of the client, and the activities of providing human resources and human resource management services for others on a contract or fee basis. This division also includes executive search and placement activities, including activities of theatrical casting agencies.\nThis division excludes activities of agents for individual artists, see 7490.', 'N');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('79', 'Travel Agency, Tour Operator, Reservation Service and Related Activities\n', 'This division includes the activity of selling travel, tour, transportation and accommodation services to the general public and commercial client and the activity of arranging and assembling tours that are sold through travel agencies or directly by agents such as tour operators as well as other travel-related services, including reservation services. The activities of tourist guides and tourism promotion activities are also included.', 'N');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('80', 'Security and Investigation Activities\n', 'This division includes security-related services such as: investigation and detective services; guard and patrol services; picking up and delivering money, receipts, or other valuable items with personnel and equipment to protect such properties while in transit; operation of electronic security alarm systems, such as burglar and fire alarms, where the activity focuses on remote monitoring these systems, but often involves also sale, installation and repair services. If the latter components are provided separate, they are excluded from this division and classified in retail sale, construction etc.', 'N');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('81', 'Services to Buildings and Landscape Activities\n', 'This division includes the provision of a number of general support services, such as the provision of a combination of support services within a clientNULLs facilities, the interior and exterior cleaning of buildings of all types, cleaning of industrial machinery, cleaning of trains, buses, planes, etc., cleaning of the inside of road and sea tankers, disinfecting and exterminating activities for buildings, ships, trains, etc., bottle cleaning, street sweeping, provision of landscape care and maintenance services and provision of these services along with the design of landscape plans and/or the construction (i.e. installation) of walkways, retaining walls, decks, fences, ponds, and similar structures.', 'N');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('82', 'Office Administrative, Office Support and Other Business Support Activities\n', 'This division includes the provision of a range of day to day office administrative services, as well as ongoing routine business support functions for others, on a contract or fee basis.\nThis division also includes all support service activities, typically provided to businesses not elsewhere classified.\nUnits classified in this division do not provide operating staff to carry out the complete operations of a business.', 'N');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('84', 'Public Administration and Defense; Compulsory Social Security', NULL, 'O');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('85', 'Education\n', 'This division includes public and private education of all types, provided by institutions as a full time education or on a part-time or intensive basis, at day time or in the evening and at any level or for any profession. The first three groups cover education that may be included under \"the regular school system\", i.e. a system of progressive school education for children and young people from the pre-school level through the university level. The breakdown of the categories is primarily based on the level of education offered.\nEducation can be provided in rooms, radio, television broadcast, Internet, correspondence or at home.', 'P');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('86', 'Human Health Activities\n', 'This division includes activities of short-or long-term hospitals, general or specialty medical, surgical, psychiatric and substance abuse hospitals, sanitaria, preventoria, medical nursing homes, asylums, mental hospital institutions, rehabilitation centers, leprosaria and other human health institutions which have accommodation facilities and which engage in providing diagnostic and medical treatment to inpatients with any of a wide variety of medical conditions. It also includes medical consultations and treatment in the field of general and specialized medicines by general practitioners and medical specialists and surgeons. It includes dental practice activities of a general or specialized nature and orthodontic activities. Likewise, this division includes activities for human health not performed by hospitals or by practicing medical doctors but by paramedical practitioners legally recognized to treat patients.', 'Q');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('87', 'Residential Care Activities\n', 'This division includes the provision of residential care combined with either nursing, supervisory or other types of care as required by the residents. Facilities are a significant part of the production process and the care provided is a mix of health and social services with the health services being largely some level of nursing services.', 'Q');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('88', 'Social Work Activities without Accommodation\n', 'This division includes the provision of a variety of social assistance services directly to clients. The activities in this division do not include accommodation services, except on a temporary basis.', 'Q');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('90', 'Creative, Arts and Entertainment Activities', NULL, 'R');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('91', 'Libraries, Archives, Museums and Other Cultural Activities\n', 'This division includes activities of and the operation of libraries, archives, museums of all kinds, botanical and zoological gardens and the operation of historical sites and nature reserves activities. It also includes the preservation and exhibition of objects, sites and natural wonders of historical, cultural or educational interest (e.g. world heritage sites, etc.).\nThis division excludes sports activities and amusement and recreation activities such as the operation of bathing beaches and recreation parks (see division 93).', 'R');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('92', 'Gambling and Betting Activities\n', 'This division includes the operation of gambling facilities such as casinos, bingo halls and video gaming terminals and the provision of gambling services, such as lotteries and off-track betting.', 'R');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('93', 'Sports Activities and Amusement and Recreation Activities\n', 'This division includes the provision of recreational, amusement and sports activities (except museums activities, preservation of historical sites, botanical and zoological gardens and nature reserves activities; and gambling and betting activities).\nExcluded from this division are dramatic arts, music and other arts and entertainment such as the production of live theatrical presentations, concerts and opera or dance productions and other stage productions, see division 90.', 'R');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('94', 'Activities of Membership Organizations\n', 'This division includes activities of organizations representing interests of special groups or promoting ideas to the general public. These organizations usually have a constituency of members, but their activities may involve and benefit non-members as well. The primary breakdown of this division is determined by the purpose that these organizations serve, namely interests of employers, self-employed individuals and the scientific community (group 941), interests of employees (group 942) or promotion of religious, political, cultural, educational or recreational ideas and activities (group 949).', 'S');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('95', 'Repair of Computers and Personal and Household Goods\n', 'This division includes the repair and maintenance of computers peripheral equipment such as desktops, laptops, computer terminals, storage devices and printers. It also includes the repair of communications equipment such as fax machines, two-way radios and consumer electronics such as radios and TVNULLs, home and garden equipment such as lawn-movers and blowers, footwear and leather goods, furniture and home furnishings, clothing and clothing accessories, sporting goods, musical instruments, hobby articles and other personal and household goods.\nExcluded from this division is the repair of medical and diagnostic imaging equipment, measuring and surveying instruments, laboratory instruments, radar and sonar equipment, see 3313.', 'S');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('96', 'Other Personal Service Activities\n', 'This division includes all service activities not mentioned elsewhere in the classification. Notably it includes types of services such as washing and dry cleaning of textiles and fur products, hairdressing and other beauty treatment, funeral and related activities.', 'S');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('97', 'Activities of Households as Employers of Domestic Personnel', NULL, 'T');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('98', 'Undifferentiated Goods-and Services-producing Activities of Private Households for Own Use\n', 'This division contains the undifferentiated subsistence goods-producing and services-producing activities of households.\nHouseholds should be classified here only if it is impossible to identify a primary activity for the subsistence activities of the household. If the household engages in market activities, it should be classified according to the primary market activity carried out.', 'T');
INSERT INTO psic_division (code, description, details, sectionid) VALUES ('99', 'Activities of Extra-territorial Organizations and Bodies', NULL, 'U');


-- GROUP
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('011', 'Growing of Non-perennial Crops\n', 'This group includes the growing of non-perennial crops, i.e. plants that do not last for more than two growing seasons. Included is the growing of these plants for the purpose of seed production.', '01');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('012', 'Growing of Perennial Crops\n', 'This group includes the growing of perennial crops, i.e. plants that last for more than two growing seasons, either each season or growing continuously. Included is the growing of these plants for the purpose of seed production.', '01');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('013', 'Plant Propagation', NULL, '01');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('014', 'Animal Production\n', 'This group includes raising (farming) and breeding of all animals, except aquatic animals.\nIt includes raising (farming) of domestic animals, such as carabao, cattle, sheep, goats, deer, horses, asses, mules or hinnies, etc.; raising (farming) of poultry such as chicken, ducks, quails, etc., provision of feed lot services; production of raw milk, bovine semen; production of butter, cheese, other dairy products in the farm; sheep shearing by the sheep owner; and stud farming.', '01');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('015', 'Support Activities to Agriculture and Post-harvest Crop Activities\n', 'This group includes activities incidental to agricultural production and activities similar to agriculture not undertaken for production purposes, done on a fee or contract basis. Also included are post-harvest crop activities, aimed at preparing agricultural products for the primary market.', '01');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('017', 'Hunting, Trapping and Related Service Activities', NULL, '01');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('021', 'Silviculture and Other Forestry Activities\n', 'This class includes :\nGrowing of standing timber : planting, replanting, transplanting, thinning and conserving of forests and timber tracts\nGrowing of coppice, pulpwood and fire wood\nOperation of forest tree nurseries\nThese activities can be carried out in natural or planted forests.\nThis class excludes :\nGrowing of Christmas tree, see 0129;\nGathering of wild growing non-wood forest products, see 0230;\nProduction of wood chips and particles, see 1610.', '02');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('022', 'Logging', NULL, '02');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('023', 'Gathering of Non-wood Forest Products', NULL, '02');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('024', 'Support Services to Forestry', NULL, '02');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('031', 'Fishing\n', 'This group includes capture fishery, i.e. the hunting, collecting and gathering activities directed at removing or collecting live wild aquatic organisms (predominantly fish, mollusks and crustaceans) including plants from the oceanic, coastal or inland waters for human consumption and other purposes by hand or more usually by various types of fishing gear such as nets, lines and stationary traps. Such activities can be conducted on the intertidal shoreline (e.g. collection of mollusks such as mussels and oysters) or shore based netting, or from home-made dugouts or more commonly using commercially made boats in inshore, coastal waters or offshore waters.\nUnlike in aquaculture (group 032), the aquatic resource being captured is usually common property resource irrespective of whether the harvest from this resource is undertaken with or without exploitation rights. Such activities also include fishing restocked water bodies.', '03');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('032', 'Aquaculture\n', 'This group includes aquaculture (or aquafarming), i.e. the production process involving the culturing or farming (including harvesting) of aquatic organisms (fish, mollusks, crustaceans, plants, crocodile, alligators and amphibians) using techniques designed to increase the production of the organisms in question beyond the natural capacity of the environment (for example regular stocking, feeding and protection from predators).\nCulturing/farming refers to the rearing up to their juvenile and/or adult phase under captive conditions of the above organisms. In addition, aquaculture also encompasses individual, corporate or state ownership of the individual organisms throughout the rearing or culture stage, up to and including harvesting.', '03');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('051', 'Mining of Hard Coal', NULL, '05');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('052', 'Mining of Lignite', NULL, '05');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('061', 'Extraction of Crude Petroleum', NULL, '06');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('062', 'Extraction of Natural Gas', NULL, '06');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('071', 'Mining of Iron Ores', NULL, '07');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('072', 'Mining of Non-ferrous Metal Ores\n', 'This group includes mining and preparation of non-ferrous metal ores.', '07');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('081', 'Quarrying of Stone, Sand and Clay', NULL, '08');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('089', 'Mining and Quarrying, N.e.c.', NULL, '08');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('091', 'Support Activities for Petroleum and Gas Extraction', NULL, '09');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('099', 'Support Activities for Other Mining and Quarrying', NULL, '09');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('101', 'Processing and Preserving of Meat', NULL, '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('102', 'Processing and Preserving of Fish, Crustaceans and Mollusks', NULL, '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('103', 'Processing and Preserving of Fruits and Vegetables', NULL, '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('104', 'Manufacture of Vegetable and Animal Oils and Fats\n', 'This class includes:\nManufacture of oils and fats from vegetable or animal materials, except rendering and refining of lard and other edible animal fats\nProcessing of vegetable oils: boiling, dehydration, hydrogenation, compression such as virgin coconut oil etc.\nManufacture of crude vegetable oils: olive oil, soya-bean oil, palm oil, sunflower-seed oil, cotton-seed oil, rape, colza or mustard oil, linseed oil, etc.\nManufacture of non-defatted flour or meal of oilseeds, oil nuts or oil kernels\nManufacture of refined vegetable oils: olive oil, soya-bean oil, etc.\nManufacture of margarine\nManufacture of melanges and similar spreads\nProduction of partly hydrogenated oils, margarine or other table oils or cooking fats\nManufacture of compound cooking fats\nManufacture of non-edible animal oils and fats\nExtraction of oil from fish or fish livers and marine mammal oils\nProduction of cotton linters, oilcakes and other residual products of oil production\nThis class excludes :\nRendering and refining of lard and other edible animal fats, see 1012;\nWet corn milling, see 1063;\nProduction of essential oils, see 2029;\nTreatment of oil and fats by chemical processes, see 2029.', '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('105', 'Manufacture of Dairy Products\n', '\nThis class includes :\nManufacture of fresh liquid milk, pasteurized, sterilized, homogenized and/or ultra heat treated\nManufacture of milk-based drinks\nManufacture of cream from fresh liquid milk, pasteurized, sterilized, homogenized\nManufacture of yoghurt\nManufacture of dried or concentrated milk whether or not sweetened\nManufacture of milk or cream in solid form\nManufacture of butter\nManufacture of yoghurt\nManufacture of cheese and curd\nManufacture of milk-based drinks\nManufacture of whey\nManufacture of casein or lactose such as manufacture of ice cream and other edible ice such as sorbet\nThis class excludes :\nProduction of raw milk (cattle, 0141) (sheep, goats, horses, assess, etc. 0142; 0143)\nManufacture of non-dairy milk and cheese substitutes, see 1079;\nActivities of ice cream parlors, see 5610.', '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('106', 'Manufacture of Grain Mill Products, Starches and Starch Products\n', 'This group includes the milling of flour or meal from grains or vegetables, the milling, cleaning and polishing of rice, as well as the manufacture of flour mixes or doughs from these products. Also included in this group is the wet milling of corn and vegetables and the manufacture of starch and starch products.', '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('107', 'Manufacture of Other Food Products', NULL, '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('108', 'Manufacture of Prepared Animal Feeds', NULL, '10');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('110', 'Manufacture of Beverages\n', 'The group includes the manufacture and blending of alcoholic beverage such as whisky, brandy, gin, distilled spirits and neutral spirits; wines, fermented but not distilled alcoholic beverage; malt liquors such as beer, ale etc. including manufacture of low alcohol or non-alcohol. This also includes manufacture of soft drinks, mineral waters and other bottled waters.', '11');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('120', 'Manufacture of Tobacco Products\n', 'This group includes :\nManufacture of tobacco products and products of tobacco substitutes :\ncigarettes\ncigars\npipe tobacco\ncigarette tobacco; chewing tobacco; snuff\nManufacture of \"homogenized\" or \"reconstituted\" tobacco\nStemming and redrying of tobacco\nThis group excludes growing or preliminary processing of tobacco, see 0115, 0157.', '12');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('131', 'Spinning, Weaving and Finishing of Textiles\n', 'This group includes preparatory operations, spinning, weaving and finishing of textiles and the weaving of textiles. This can be done from varying raw materials, such as silk, wool, other animal, vegetable or manmade fibers, paper or glass etc. Also included is the finishing of textiles and wearing apparel such as bleaching, dyeing, and similar activities.', '13');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('139', 'Manufacture of Other Textiles\n', 'This group includes the manufacture of products produced from textiles, except wearing apparel, such as knitted and crocheted fabrics, made-up textile articles, carpets and rugs; cordage, rope, twine and netting, coated fabrics, narrow woven fabrics, trimmings, curtains, blinds, tents, camping goods, sails and loose covers of cars, flags, life jackets and parachutes.', '13');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('141', 'Manufacture of Wearing Apparel, Except Fur Apparel\n', '\nThis class includes :\nManufacture of wearing apparel made of leather or composition leather including leather industrial work accessories as welderNULLs leather aprons\nManufacture of work wear\nManufacture of other outerwear made of woven, knitted or crocheted fabric, lace etc. for men, women and children; coat, suits, ensembles, jackets, trousers, skirts, etc.\nManufacture of underwear and nightwear made of woven, knitted or crocheted fabric, lace etc. for men, women and children: shirts, T-shirts, underpants, briefs, pajamas, nightdresses, dressing gowns, blouses, slips, brassieres, corsets, etc.\nManufacture of babiesNULL garments, tracksuits, ski suits, swimwear, etc.\nManufacture of hats and caps\nManufacture of other clothing accessories: gloves, belts, shawls, ties, cravats, hairnets, etc.\nCustom tailoring\nManufacture of headgear of fur skins\nManufacture of footwear of textile material without applied soles\nManufacture of parts of the products listed\nThis class excludes :\nManufacture of wearing apparel of fur skins (except headgear), see 1440;\nManufacture of footwear, see 152;\nManufacture of wearing apparel of rubber or plastic not assembled by stitching but merely sealed together, see 2219, 2220;\nManufacture of leather sports gloves and sports headgear, see 3230;\nManufacture of safety headgear (except sports headgear), see 3299;\nManufacture of fire-resistant and protective safety clothing, see 329;\nRepair of wearing apparel, see 9529.', '14');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('142', 'Custom Tailoring and Dressmaking', NULL, '14');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('143', 'Manufacture of Knitted and Crocheted Apparel', NULL, '14');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('144', 'Manufacture of Articles of Fur', NULL, '14');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('151', 'Tanning and Dressing of Leather; Manufacture of Luggage and Handbags\n', 'This group includes the manufacture of leather and fur and products thereof.', '15');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('152', 'Manufacture of Footwear\n', 'This class includes :\nManufacture of footwear for all purposes, of any material, by any process, including molding (see below for exceptions)\nManufacture of leather parts of footwear: manufacture of uppers and parts of uppers, outer and inner soles, heels, etc.\nManufacture of gaiters, leggings and similar articles\nThis class excludes :\nManufacture of footwear of textile material without applied soles, see 141;\nManufacture of plastic footwear parts, see 2220;\nManufacture of rubber boot and shoe heels and soles and other rubber footwear parts, see 2219.\nManufacture of wooden shoe parts (e.g. heels and lasts), see 1629.', '15');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('161', 'Sawmilling and Planing of Wood', NULL, '16');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('162', 'Manufacture of Products of Wood, Cork, Straw and Plaiting Materials', NULL, '16');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('170', 'Manufacture of Paper and Paper Products', NULL, '17');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('181', 'Printing and Service Activities Related to Printing\n', 'This group includes printing of products, such as newspapers, books, periodicals, business forms, greeting cards, and other materials, and associated support activities, such as bookbinding, plate-making services, and data imaging. Printing can be done using various techniques and on different materials.', '18');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('182', 'Reproduction of Recorded Media', NULL, '18');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('191', 'Manufacture of Coke Oven Products', NULL, '19');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('192', 'Manufacture of Refined Petroleum Products', NULL, '19');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('199', 'Manufacture of Other Fuel Products', NULL, '19');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('201', 'Manufacture of Basic Chemicals', NULL, '20');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('202', 'Manufacture of Other Chemical Products, N.e.c.\n', 'This group includes the manufacture of chemical products other than basic chemicals and man-made fibers. It also includes the manufacture of a variety of goods such as pesticides, paints, varnish and similar coatings, printing inks, and mastics; soap and detergents, cleaning preparations, perfumes and toilet preparations; and other chemical products such as explosives and pyrotechnic products, glue, chemical preparations for photographic uses (including film and sensitized paper), gelatins, composite diagnostic preparations, etc.', '20');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('203', 'Manufacture of Man-made Fibers', NULL, '20');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('210', 'Manufacture of Pharmaceuticals, Medicinal Chemical and Botanical Products', NULL, '21');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('221', 'Manufacture of Rubber Products', NULL, '22');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('222', 'Manufacture of Plastics Products', NULL, '22');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('231', 'Manufacture of Glass and Glass Products', NULL, '23');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('239', 'Manufacture of Non-metallic Mineral Products, N.e.c.\n', 'This group includes the manufacture of intermediate and final products from mined or quarried non-metallic minerals, such as sand, gravel, stone or clay.', '23');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('241', 'Manufacture of Basic Iron and Steel\n', '\nThis class includes operations of conversion by reduction of iron ore in blast furnaces and oxygen converters or of ferrous waste and scrap in electric are furnaces or by direct reduction of iron ore without fusion to obtain crude steel which is smelted and refined in a ladle furnace and then poured and solidified in a continuous caster in order to produce semi-finished flat or long products, which are used, after reheating, in rolling, drawing and extruding operations to manufacture finished products such as plate, sheet, strip, bars, rods, wire, tubes, pipes and hollow profiles.\nThis class includes :\nOperation of blast furnaces, steel converters, rolling and finishing mills\nProduction of pig iron and spiegeleisen in pigs, blocks or other primary forms\nProduction of ferro-alloys\nProduction of ferrous products by direct reduction of iron and other spongy ferrous products\nProduction of iron of exceptional purity by electrolysis or other chemical processes\nProduction of granular iron and iron powder\nProduction of steel in ingots or other primary forms\nRemelting of scrap ingots of iron or steel\nProduction of semi-finished products of steel\nManufacture of hot-rolled and cold-rolled flat rolled products of steel\nManufacture of hot-rolled bars and rods of steel\nManufacture of hot-rolled open sections of steel\nManufacture of steel bars and solid sections of steel by cold drawing, grinding or turning\nManufacture of open sections by progressive cold forming on a roll mill or folding on a press of flat-rolled products of steel\nManufacture of wire of steel by cold drawing or stretching\nManufacture of sheet piling of steel, and welded open sections of steel\nManufacture of railway track materials (unassembled rails) of steel\nManufacture of seamless tubes, pipes and hollow profiles of steel, by hot rolling, hot extrusion or hot drawing, or by cold drawing or cold rolling\nManufacture of welded tubes and pipes of steel, by cold or hot forming and welding, delivered as welded or further processed by cold drawing or cold rolling or manufactured by hot forming, welding and reducing\nManufacture of tube fittings of steel, such as flat flanges and flanges with forged collars, butt-welded fittings, threaded fittings and socket-welded fittings\nThis class excludes :\nManufacture of tubes, pipes and hollow profiles and of tube or pipe fittings of cast-iron, see 2431;\nManufacture of seamless tubes and pipes of steel by centrifugal casting, see 2431;\nManufacture of tube or pipe fittings of cast-steel, see 2431.', '24');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('242', 'Manufacture of Basic Precious and Other Non-ferrous Metals\n', '\nThis class includes :\nProduction of basic precious metals : production and refining of unwrought or wrought precious metals - gold, silver, platinum, etc. from ore and scrap\nProduction of precious metal alloys\nProduction of precious metal semi-products\nProduction of silver rolled onto base metals\nProduction of gold rolled onto base metals or silver\nProduction of platinum and platinum group metals rolled onto gold, silver or base metals\nProduction of aluminum from alumina\nProduction of aluminum from electrolytic refining of aluminum waste and scrap\nProduction of aluminum alloys\nSemi-manufacturing of aluminum\nProduction of lead, zinc and tin from ores\nProduction of lead, zinc and tin from electrolytic refining of lead, zinc and tin waste and scrap\nProduction of lead, zinc and tin alloys\nSemi-manufacturing of lead, zinc and tin\nProduction of copper from ores\nProduction of copper from electrolytic refining of copper waste and scrap\nProduction of copper alloys\nManufacture of fuse wire or strip\nSemi-manufacturing of copper\nProduction of chrome, manganese, nickel etc. from ores or oxides\nProduction of chrome, manganese, nickel, etc. from electrolytic and aluminothermic refining of chrome, manganese, nickel etc. from waste and scrap\nProduction of alloys of chrome, manganese, nickel, etc.\nSemi-manufacturing of chrome, manganese, nickel, etc.\nProduction of mattes of nickel\nProduction of uranium metal from pitchblende or other ores\nSmelting and refining of uranium\nThis class also includes :\nManufacture of wire of these metals by drawing\nProduction of aluminum oxide (alumina)\nProduction of aluminum wrapping foil\nManufacture of aluminum (tin) foil laminates made from aluminum (tin) foil as primary component\nManufacture of precious metal foil laminates\nThis class excludes :\nCasting of non-ferrous metals, see 2432;\nManufacture of precious metal jewelry, see 3211.', '24');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('243', 'Casting of Metals\n', 'This group includes the manufacture of semi-finished products and various castings by a casting process.', '24');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('251', 'Manufacture of Structural Metal Products, Tanks, Reservoirs and Steam Generators\n', 'This group includes the manufacture of structural metal products (such as metal frameworks or parts for construction), as well as metal container-type objects (such as reservoirs, tanks, central heating boilers) and steam generators.', '25');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('252', 'Manufacture of Weapons and Ammunition', NULL, '25');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('259', 'Manufacture of Other Fabricated Metal Products; Metal Working Service Activities\n', 'This group includes general activities for the treatment of metal, such as forging or pressing, plaiting, coating engraving, boring polishing, welding, etc., which are typically carried out on a fee or contract basis. This group also includes the manufacture of a variety of metal products, such as cutlery; metal hand tools and general hardware; cans and buckets; nails, bolts and nuts; metal household articles; metal fixtures; ships propellers and anchors; assembled railway track fixtures, etc. for a variety of household and industrial uses.', '25');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('261', 'Manufacture of Electronic Components\n', '\nThis class includes :\nManufacture of electron tubes\nManufacture of capacitors, electronic\nManufacture of resistors, electronic\nManufacture of microprocessors\nManufacture of bare printed circuit boards\nManufacture of electronic connectors\nManufacture of integrated circuits (analog, digital or hybrid)\nManufacture of diodes, transistors, and related discrete devices\nManufacture of inductors (e.g. chokes, coils, transformers), electronic component type\nManufacture of electronic crystals and crystal assemblies\nManufacture of solenoids, switches, and transducers for electronic applications\nManufacture of dice or wafers, semiconductor, finished or semi-finished\nManufacture of interface cards (e.g. sound video, controllers, network, modems)\nLoading of components onto printed circuit boards\nManufacture of display components (plasma, polymer, LCD)\nManufacture of light emitting diodes (LED)\nManufacture of printer cables, monitor cables, USB cables, connectors, etc.\nThis class excludes :\nPrinting of smart cards, see 1811;\nManufacture of modems (carrier equipment), see 2630;\nManufacture of computer and television displays, see 2620, 2640;\nManufacture of X-ray tubes and similar irradiation devices, see 2660;\nManufacture of optical equipment and instruments, see 2670;\nManufacture of similar devices for electrical applications, see division 27;\nManufacture of lighting ballasts, see 2712;\nManufacture of electrical relays, see 2712;\nManufacture of electrical wiring devices, see 2733;\nManufacture of complete equipment is classified elsewhere based on complete equipment classification.', '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('262', 'Manufacture of Computers and Peripheral Equipment and Accessories', NULL, '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('263', 'Manufacture of Communication Equipment', NULL, '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('264', 'Manufacture of Consumer Electronics', NULL, '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('265', 'Manufacture of Measuring, Testing, Navigating and Control Equipment; Watches and Clocks\n', 'This group includes the manufacture of measuring, testing, navigating and control equipment for various industrial and non-industrial purposes, including time-based measuring devices such as watches and clocks and related devices.', '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('266', 'Manufacture of Irradiation, Electromedical and Electrotherapeutic Equipment', NULL, '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('267', 'Manufacture of Optical Instruments and Photographic Equipment', NULL, '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('268', 'Manufacture of Magnetic and Optical Media', NULL, '26');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('271', 'Manufacture of Electric Motors, Generators, Transformers and Electricity Distribution and Control Apparatus\n', '\nThis class includes the manufacture of power, distribution and specialty transformers; electric motors, generators and motor generator sets; switchgear and switchboard apparatus, relays and industrial controls. The electrical equipment manufactured in this class is for distribution level voltages.\nThis class includes :\nManufacture of distribution transformers, electric\nManufacture of arc-welding transformers\nManufacture of fluorescent ballasts (i.e. transformers)\nManufacture of substation transformers for electric power distribution\nManufacture of transmission and distribution voltage regulators\nManufacture of electric motors (except internal combustion engine starting motors)\nManufacture of power generators (except battery charging alternators for internal combustion engines)\nManufacture of motor generator sets (except turbine generator set units)\nManufacture of power circuit breakers\nManufacture of control panels for electric power distribution\nManufacture of electrical relays\nManufacture of duct for electrical switchboard apparatus\nManufacture of electric fuses\nManufacture of power switching equipment\nManufacture of electric power switches (except pushbutton, snap, solenoid, tumbler)\nManufacture of prime mover generator sets\nRewinding of armatures on a factory basis\nManufacture of surge suppressors (for distribution level voltage)\nThis class excludes :\nManufacture of electronic component-type transformers and switches, see 2612;\nManufacture of environmental controls and industrial process control instruments, see 2651;\nManufacture of switches for electrical circuits, such as pushbutton and snap switches, see 2733;\nManufacture of electric welding and soldering equipment, see 2790;\nManufacture of solid state inverters, rectifiers and converters, see 2790;\nManufacture of turbine-generator sets, see 2811;\nManufacture of starting motors and generators for internal combustion engines, see 2930.', '27');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('272', 'Manufacture of Batteries and Accumulators', NULL, '27');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('273', 'Manufacture of Wiring and Wiring Devices\n', 'This group includes the manufacture of current-carrying wiring devices and non current-carrying wiring devices for wiring electrical circuits regardless of material. This group also includes the insulating of wire and the manufacture of fiber optic cables.', '27');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('274', 'Manufacture of Electric Lighting Equipment', NULL, '27');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('275', 'Manufacture of Domestic Appliances', NULL, '27');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('279', 'Manufacture of Other Electrical Equipment', NULL, '27');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('281', 'Manufacture of General Purpose Machinery\n', 'This group includes the manufacture of general-purpose machinery, i.e. machinery that is being used in a wide range of PSIC industries. This can include the manufacture of components used in the manufacture of a variety of other machinery or the manufacture of machinery that support the operation of other businesses.', '28');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('282', 'Manufacture of Special Purpose Machinery\n', 'This group includes the manufacture of special-purpose machinery, i.e. machinery for exclusive use in an PSIC industry or a small cluster of PSIC industries. While most of these are used in other manufacturing processes, such as food manufacturing or textile manufacturing, this group also includes the manufacture of machinery specific for other (non-manufacturing industries), such as aircraft launching gear or amusement park equipment.', '28');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('291', 'Manufacture of Motor Vehicles', NULL, '29');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('292', 'Manufacture of Bodies (Coachwork) for Motor Vehicles; Manufacture of Trailers and Semi-trailers', NULL, '29');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('293', 'Manufacture of Parts and Accessories for Motor Vehicles', NULL, '29');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('301', 'Building of Ships and Boats\n', 'This group includes the building of ships, boats and other floating structures for transportation and other commercial purposes, as well as for special recreational purposes.', '30');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('302', 'Manufacture of Railway Locomotive and Rolling Stock', NULL, '30');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('303', 'Manufacture of Air and Spacecraft and Related Machinery', NULL, '30');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('304', 'Manufacture of Military Fighting Vehicles', NULL, '30');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('309', 'Manufacture of Transport Equipment, N.e.c.\n', 'This group includes the manufacture of transport equipment other than motor vehicles and rail water, air or space transport equipment and military vehicles.', '30');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('310', 'Manufacture of Furniture\n', '\nThis class includes manufacture of furniture of any kind, any material (except stone, concrete or ceramic) for any place and various purposes.\nThis class includes :\nManufacture of chairs and seats for offices, workrooms, hotels, restaurants, public and domestic premises\nManufacture of chairs and seats for theaters, cinemas and the like\nManufacture of sofas, sofa beds and sofa sets\nManufacture of garden chairs and seats\nManufacture of special furniture for shops, counters, display cases, shelves, etc.\nManufacture of furniture for churches, schools, restaurants\nManufacture of office furniture\nManufacture of kitchen furniture\nManufacture of furniture for bedrooms, living rooms, gardens, etc.\nManufacture of cabinets for sewing machines, televisions, etc.\nManufacture of laboratory benches, stools and other laboratory seating, laboratory furniture (e.g. cabinets and tables)\nThis class also includes :\nFinishing such as upholstery of chairs and seats\nFinishing of furniture such as spraying, painting, polishing and upholstering\nManufacture of mattress supports\nManufacture of mattresses : mattresses fitted with springs or stuffed or internally fitted with a supporting material; uncovered cellular rubber or plastic mattresses\nDecorative restaurant carts, such as a dessert cart, food wagons\nThis class excludes :\nManufacture of pillows, pouffes, cushions, quilts and eiderdowns, see 1392;\nManufacture of inflatable rubber mattresses, see 2219;\nManufacture of furniture of ceramics, concrete and stone, see 2393, 2395, 2396;\nManufacture of lighting fittings or lamps, see 2740;\nBlackboard, see 2817;\nManufacture of car seats, railway seats, aircraft seats, see 2930, 3020, 3030;\nModular furniture attachment and installation, partition installation, laboratory equipment furniture installation, see 4330.', '31');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('321', 'Manufacture of Jewelry, Bijouterie and Related Articles\n', 'This group includes the manufacture of jewelry and imitation jewelry articles.', '32');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('322', 'Manufacture of Musical Instruments', NULL, '32');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('323', 'Manufacture of Sports Goods', NULL, '32');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('324', 'Manufacture of Games and Toys', NULL, '32');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('325', 'Manufacture of Medical and Dental Instruments and Supplies', NULL, '32');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('329', 'Other Manufacturing, N.e.c.\n', 'This class includes :\nManufacture of protective safety equipment :\nmanufacture of fire-resistant and protective safety clothing\nmanufacture of linemenNULLs safety belts and other belts for occupational use\nmanufacture of cork life preservers\nmanufacture of plastic hard hats and other personal safety equipment of plastic (e.g. athletic helmets)\nmanufacture of fire-fighting protection suits\nmanufacture of metal safety headgear and other metal safety devices\nmanufacture of ear and noise plugs (e.g. for swimming and noise protection)\nmanufacture of gas masks\nManufacture of brooms and brushes, including brushes constituting parts of machines, hand-operated mechanical floor sweepers, mops and feather dusters, paint brushes, paint pads and rollers, squeezers and other brushes, brooms, mops, etc.\nManufacture of shoe and clothes brushes\nManufacture of pens and pencils of all kinds whether or not mechanical\nManufacture of pencil leads\nManufacture of date, sealing or numbering stamps, hand-operated devices for printing, or embossing labels, hand printing sets, prepared typewriters ribbons and inked pads\nManufacture of globes\nManufacture of umbrellas, sun-umbrellas, walking sticks, seat-sticks\nManufacture of buttons, press-fasteners, snap-fasteners, press-studs, slide fasteners\nManufacture of cigarette lighters\nManufacture of articles of personal use : smoking pipes, combs, hair slides, scent sprays, vacuum flasks and other vacuum vessels for personal or household use, wigs, false beards, eyebrows\nManufacture of miscellaneous articles : candles, tapers and the like, bouquets, wreaths and floral baskets, artificial flowers, fruit and foliage, jokes and novelties, hand sieves and hand riddles, tailorsNULL dummies, burial caskets, etc.\nTaxidermy activities\nThis class excludes :\nManufacture of lighter wicks, see 1399;\nManufacture of workwear and service apparel (e.g. laboratory costs, work overalls, uniforms), see 1419;\nManufacture of paper novelties, see 1709.\nManufacture of plastic novelties, see 2220.', '32');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('331', 'Repair of Fabricated Metal Products, Machinery and Equipment\n', 'This group includes the specialized repair of goods produced in the manufacturing sector with the aim to restore these metal products, machinery, equipment and other products to working order. The provision of general or routine maintenance (i.e. servicing) on such products to ensure they work efficiently and to prevent breakdown and unnecessary repair is included.\nThis group excludes :\nRebuilding or remanufacturing of machinery and equipment, see corresponding class in division 25-31;\nCleaning of industrial machinery, see 8129;\nRepair and maintenance of computers and communication equipment, see 951;\nRepair and maintenance of household goods, see 952.', '33');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('332', 'Installation of Industrial Machinery and Equipment', NULL, '33');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('351', 'Electric Power Generation, Transmission and Distribution', NULL, '35');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('352', 'Manufacture of Gas; Distribution of Gaseous Fuels Through Mains', NULL, '35');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('353', 'Steam, Air Conditioning Supply and Production of Ice', NULL, '35');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('360', 'Water Collection, Treatment and Supply', NULL, '36');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('370', 'Sewerage', NULL, '37');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('381', 'Waste Collection\n', 'This group includes the collection of waste from households and businesses by means of refuse bins, wheeled bins, containers, etc. It includes collection of non-hazardous waste and hazardous waste, e.g. waste from households, used batteries, used cooking oils and fats, waste oil from ships and used oil from garages, as well as construction and demolition waste.', '38');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('382', 'Waste Treatment and Disposal\n', 'This group includes the disposal and treatment prior to disposal of various forms of waste by different means, such as waste treatment of organic waste with the aim of disposal; treatment and disposal of toxic live or dead animals and other contaminated waste; treatment and disposal of transition radioactive waste from hospitals, etc.; dumping of refuse on land or in water; burial or ploughing under of refuse; disposal of used goods such as refrigerators to eliminate harmful waste by incineration or combustion.\nIncluded also is the generation of electricity resulting from waste incineration processes.', '38');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('383', 'Materials Recovery', NULL, '38');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('390', 'Remediation Activities and Other Waste Management Services', NULL, '39');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('410', 'Construction of Buildings', NULL, '41');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('421', 'Construction of Roads and Railways', NULL, '42');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('422', 'Construction of Utility Projects', NULL, '42');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('429', 'Construction of Other Civil Engineering Projects', NULL, '42');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('431', 'Demolition and Site Preparation\n', 'This group includes activities of preparing a site for subsequent construction activities, including the removal of previously existing structures.', '43');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('432', 'Electrical, Plumbing and Other Construction Installation Activities\n', 'This group includes installation activities that support the functioning of a building as such, including installation of electrical systems, plumbing (water, gas and sewage systems), heat and air-conditioning systems, elevators, etc.', '43');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('433', 'Building Completion and Finishing', NULL, '43');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('439', 'Other Specialized Construction Activities', NULL, '43');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('451', 'Sale of Motor Vehicles', NULL, '45');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('452', 'Maintenance and Repair of Motor Vehicles', NULL, '45');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('453', 'Sale of Motor Vehicle Parts and Accessories', NULL, '45');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('454', 'Sale, Maintenance and Repair of Motorcycles and Related Parts and Accessories', NULL, '45');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('461', 'Wholesale on a Fee or Contract Basis', NULL, '46');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('462', 'Wholesale of Agricultural Raw Materials and Live Animals', NULL, '46');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('463', 'Wholesale of Food, Beverages and Tobacco', NULL, '46');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('464', 'Wholesale of Household Goods\n', 'This group includes the wholesale of households goods, including textiles.', '46');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('465', 'Wholesale of Machinery, Equipment and Supplies\n', 'This group includes the wholesale of computers, telecommunications equipment, specialized machinery for all kinds of industries and general-purpose machinery.', '46');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('466', 'Other Specialized Wholesale\n', 'This group includes other specialized wholesale activities not classified in other groups of this division. This group includes the wholesale of intermediate products, except agricultural, typically not for household use.', '46');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('469', 'Non-specialized Wholesale Trade', NULL, '46');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('471', 'Retail Sale in Non-specialized Stores\n', 'This group includes the retail sale of a variety of product lines in the same unit (non-specialized stores), such as supermarkets or department stores.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('472', 'Retail Sale of Food, Beverages and Tobacco in Specialized Stores\n', 'This group includes retail sale in stores specialized in selling food, beverage or tobacco products.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('473', 'Retail Sale of Automotive Fuel in Specialized Stores', NULL, '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('474', 'Retail Sale of Information and Communications Equipment in Specialized Stores\n', 'This group includes retail sale of information and communications equipment, such as computers and peripheral equipment, telecommunications equipment and consumer electronics, by specialized stores.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('475', 'Retail Sale of Other Household Equipment in Specialized Stores\n', 'This group includes the retail sale of household equipment, such as textiles, hardware, floor coverings, electrical appliances or furniture, in specialized stores. This includes the retail sale of articles for lighting, household utensils and glassware, musical instruments, security systems, and other household articles and equipment, n.e.c.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('476', 'Retail Sale of Cultural and Recreation Goods in Specialized Stores\n', 'This group includes the retail sale in specialized stores of cultural and recreation goods, such as books, newspapers, music and video recordings, sporting equipment, games and toys.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('477', 'Retail Sale of Other Goods in Specialized Stores\n', 'This group includes the sale in specialized stores carrying a particular line of products not included in other parts of the classification, such as clothing, footwear and leather articles, pharmaceutical and medical goods, watches, souvenirs, cleaning materials, weapons, flowers and pets and others. Also included is the retail sale of used goods in specialized stores.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('478', 'Retail Sale Via Stalls and Markets\n', 'This group includes the retail sale of any kind of new or second hand product in a usually movable stall either along a public road or at a fixed marketplace.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('479', 'Retail Trade Not in Stores, Stalls or Markets\n', 'This group includes retail sale activities by mail order houses, over the internet, through door-to-door sales, vending machines, etc.', '47');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('491', 'Transport Via Railways\n', 'This group comprises rail transportation of passengers and/or freight using railroad rolling stock on mainline networks, usually spread over an extensive geographic area. Freight rail transport over short-line railroads is included here.\nThis group excludes :\nUrban and suburban passenger land transport, see 4931;\nRelated articles such as switching and shunting, see 5221;\nOperation of railroad infrastructure, see 5221.', '49');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('492', 'Transport Via Buses', NULL, '49');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('493', 'Other Land Transport\n', 'This group includes all land-based transport activities other than rail and bus transport.', '49');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('494', 'Transport Via Pipeline', NULL, '49');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('501', 'Sea and Coastal Water Transport\n', 'This group includes the transport of passengers or freight on vessels designed for operating on sea or coastal waters. Also included is the transport of passengers or freight on great lakes, etc. when similar types of vessel are used.', '50');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('502', 'Inland Water Transport\n', 'This group includes the transport of passengers or freight on inland waters, involving vessels that are not suitable for sea transport.', '50');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('511', 'Passenger Air Transport', NULL, '51');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('512', 'Freight Air Transport', NULL, '51');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('521', 'Warehousing and Storage', NULL, '52');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('522', 'Support Activities for Transportation\n', 'This group includes activities supporting the transport of passengers or freight, such as operation of parts of the transport infrastructure or activities related to handling freight immediately before or after transport or between transport segments. The operation and maintenance of all transport facilities is also included.', '52');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('531', 'Postal Activities', NULL, '53');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('532', 'Courier Activities', NULL, '53');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('551', 'Short Term Accommodation Activities', NULL, '55');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('559', 'Other Accommodation', NULL, '55');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('561', 'Restaurants and Mobile Food Service Activities', NULL, '56');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('562', 'Event Catering and Other Food Service Activities\n', 'This group includes catering activities for individual events or for a specified period of time and the operation of food concessions, such as sports or similar facilities.', '56');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('563', 'Beverage Serving Activities', NULL, '56');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('581', 'Publishing of Books, Periodicals and Other Publishing Activities\n', 'This group includes activities of publishing books, newspapers, magazines and other periodicals, directories and mailing lists, and other works such as photos, engravings, postcards, timetables, forms, posters and reproductions of works of art. These works are characterized by the intellectual creativity required in their development and are usually protected by copyright.', '58');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('582', 'Software Publishing', NULL, '58');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('591', 'Motion Picture, Video and Television Programme Production Activities', NULL, '59');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('592', 'Sound Recording and Music Publishing Activities', NULL, '59');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('601', 'Radio Broadcasting', NULL, '60');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('602', 'Television Programming and Broadcasting Activities', NULL, '60');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('611', 'Wired Telecommunications Activities', NULL, '61');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('612', 'Wireless Telecommunications Activities', NULL, '61');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('613', 'Satellite Telecommunications Activities', NULL, '61');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('619', 'Other Telecommunications Activities', NULL, '61');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('620', 'Computer Programming, Consultancy and Related Activities', NULL, '62');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('631', 'Data Processing, Hosting and Related Activities; Web Portals\n', 'This group includes the activities of providing infrastructure for hosting, data processing services and related activities, as well as the provision of search facilities and other portals for the internet.', '63');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('639', 'Other Information Service Activities\n', 'This group includes the activities of news agencies, libraries and archives and all other remaining information service activities., such as telephone based information services, information search services on a contract or fee basis, news clipping services, press clipping services, etc.', '63');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('641', 'Monetary Intermediation\n', 'This group includes the obtaining of funds in the form of transferable deposits, i.e. funds that are fixed in money terms, and obtained on a day-to-day basis and, apart from central banking, obtained from financial sources.', '64');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('642', 'Activities of Holding Companies', NULL, '64');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('643', 'Trusts, Funds and Other Financial Vehicles', NULL, '64');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('649', 'Other Financial Service Activities, Except Insurance and Pension Funding Activities\n', 'This group includes financial service activities, other than that conducted by monetary institutions.\nThis group excludes insurance and pension funding activities, see Division 65.', '64');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('651', 'Insurance\n', 'This group includes life insurance and life insurance with or without a substantial savings element and other non-life insurance.', '65');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('652', 'Reinsurance', NULL, '65');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('653', 'Pension Funding', NULL, '65');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('661', 'Activities Auxiliary to Financial Service, Except Insurance and Pension Funding\n', 'This group includes the furnishing of physical or electronic marketplaces for the purpose of facilitating the buying and selling of stocks, stock options, bonds or commodity contracts.', '66');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('662', 'Activities Auxiliary to Insurance and Pension Funding\n', 'This group includes activities of those acting as agents (i.e. broker) in selling annuities and insurance policies or providing other employee benefits and insurance and pension related services such as claims adjustment and third party administration.', '66');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('663', 'Fund Management Activities', NULL, '66');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('681', 'Real Estate Activities with Own or Leased Property\n', 'This group includes :\nBuying, selling, renting and operating of self-owned or leased real estate such as :\napartment buildings and dwellings\nnon-residential buildings, including exhibition halls, self-storage facilities, malls and shopping centers\nland\nProvision of homes and furnished or unfurnished flats or apartments for more permanent use, typically on a monthly or annual basis\nThis group also includes :\nDevelopment of building projects for own operation, i.e. for renting of space in these buildings\nSubdividing real estate into lots, without land improvement\nOperation of residential mobile home sites\nDevelopment and sale of land and cemetery lots and operation of apartelles.\nThis group excludes :\nDevelopment of building projects for sale, see 4100;\nSubdividing and improving of land, see 4290;\nOperation of hotels, suite hotels and similar accommodations, see 5510;\nOperation of campgrounds, trailer parks and similar accommodation, see 5510;\nOperation of workers hostels, rooming houses and similar accommodations, see 5590.', '68');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('682', 'Real Estate Activities on a Fee or Contract Basis', NULL, '68');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('691', 'Legal Activities', NULL, '69');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('692', 'Accounting, Bookkeeping and Auditing Activities; Tax Consultancy', NULL, '69');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('701', 'Activities of Head Offices', NULL, '70');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('702', 'Management Consultancy Activities', NULL, '70');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('711', 'Architectural and Engineering Activities and Related Technical Consultancy', NULL, '71');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('712', 'Technical Testing and Analysis', NULL, '71');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('721', 'Research and Experimental Development on Natural Sciences and Engineering', NULL, '72');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('722', 'Research and Experimental Development on Social Sciences and Humanities', NULL, '72');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('723', 'Research and Experimental Development in Information Technology', NULL, '72');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('731', 'Advertising', NULL, '73');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('732', 'Market Research and Public Opinion Polling', NULL, '73');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('741', 'Specialized Design Activities', NULL, '74');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('742', 'Photographic Activities', NULL, '74');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('749', 'Other Professional, Scientific and Technical Activities, N.e.c.', NULL, '74');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('750', 'Veterinary Activities', NULL, '75');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('771', 'Renting and Leasing of Motor Vehicles (Except Motorcycle, Caravans, Campers)', NULL, '77');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('772', 'Renting and Leasing of Personal and Household Goods\n', 'This group includes the renting of personal and household goods as well as renting of recreational and sports equipment and video tapes. Activities generally include short-term renting of goods although in some instances, the goods may be leased for longer periods of time.', '77');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('773', 'Renting and Leasing of Other Machinery, Equipment and Tangible Goods', NULL, '77');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('774', 'Leasing of Intellectual Property and Similar Products, Except Copyrighted Works', NULL, '77');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('781', 'Activities of Employment Placement Agencies', NULL, '78');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('782', 'Temporary Employment Agency Activities', NULL, '78');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('783', 'Other Human Resources Provision', NULL, '78');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('791', 'Travel Agency and Tour Operator Activities\n', 'This group includes the activities of agencies, primarily engaged in selling travel, tour, transportation and accommodation services to the general public and commercial clients and the activity of arranging and assembling tours that are sold through travel agencies or directly by agents such as tour operators.', '79');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('799', 'Other Reservation Service and Related Activities', NULL, '79');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('801', 'Private Security Activities', NULL, '80');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('802', 'Security Systems Service Activities', NULL, '80');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('803', 'Investigation Activities', NULL, '80');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('811', 'Combined Facilities Support Activities', NULL, '81');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('812', 'Cleaning Activities\n', 'This group includes the activities of general interior cleaning of all types of buildings, exterior cleaning of buildings, specialized cleaning activities for buildings or other specialized cleaning activities, cleaning of industrial machinery, cleaning of the inside of road and sea tankers, disinfecting and extermination activities for buildings and industrial machinery, bottle cleaning, street sweeping.\nThis group excludes :\nAgricultural pest control, see 0153;\nCleaning of new buildings immediately after construction, see 4330.\nSteam-cleaning, sand blasting and similar activities for building exteriors, see 4390.\nCarpet and rug shampooing, drapery and curtain cleaning, see 9621.', '81');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('813', 'Landscape Care and Maintenance Service Activities', NULL, '81');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('821', 'Office Administrative and Support Activities\n', 'This group includes the provision of a range of day-to-day office administrative services, such as financial planning, billing and record keeping, personnel and physical distribution and logistics for others on a contract or fee basis.\nThis group includes also support activities for others on a contract or fee basis, that are ongoing routine business support functions that businesses and organizations traditionally do for themselves.\nUnits classified in this group do not provide operating staff to carry out the complete operations of a business. Units engaged in one particular aspect of these activities are classified according to that particular activity.', '82');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('822', 'Call Centers and Other Related Activities', NULL, '82');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('823', 'Organization of Conventions and Trade Shows', NULL, '82');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('829', 'Business Support Service Activities, N.e.c.\n', 'This group includes the activities of collection agencies, credit bureaus and all support activities typically provided to businesses not elsewhere classified.', '82');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('841', 'Education\n', 'This group includes general administration (e.g. executive, legislative, financial administration etc. at all levels of government) and supervision in the field of social and economic life.', '84');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('842', 'Provision of Services to the Community as a Whole\n', 'This group includes foreign affairs, defense and public order and safety activities.', '84');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('843', 'Compulsory Social Security Activities', NULL, '84');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('851', 'Pre-primary/pre-school Education\n', 'This group include activities to prepare young children to the first level of education, second stage. Such programs are directed mainly towards children becoming accustomed to group activities such as singing, dancing, participation in rhythm groups and group games to promote healthy and socially desirable habits. Also stressed is the development of skills in handling coloring, molding, lettering and similar materials as well as simple tools. Introduction to basic educational programs includes readiness in the learning areas. The entry to this level of education may begin at age three or four. The pre-primary/pre-school level may last from one to four years.\nAlso included in this group are programs covering the initial stages of organized instruction for special children including the gifted and those who, due to mental, psycho-social or physical handicaps, are unable to participate in the same groups along with other children. Programs for the differently-abled children while having the same objectives as the core program, may be given in hospitals or in special schools or training centers or special classes in regular schools. Age of entry at this level cannot be specified for special children and the differently-abled.', '85');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('852', 'Primary/elementary Education\n', 'Elementary education refers to the stage of compulsory formal education primarily concerned with providing basic education, and usually corresponding to six or seven grades.\nThe core at this level consists of education for children, the customary or normal age of entrance to which is seven years. Programs in this level are designed to give the pupils a sound basic education in reading, writing, and arithmetic along with an elementary understanding of other subject areas such as social studies, science, arts and music, practical arts, and values education.\nThis group also includes special education for children with special needs, e.g., the gifted and the mentally, psycho-socially and differently-abled.', '85');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('853', 'Secondary/high School Education\n', 'This group includes formal education following the elementary education level usually corresponding to four years of high school, concerned primarily with continuing basic education and expanding it to prepare the students for higher education and/or the world of work through the acquisition of employable/gainful skills. The students at this level normally begin at age 13.\nAlso included is the special education for exceptional students including the gifted, the mentally, psycho-socially and differently-abled which is similar to that at the first level but more advanced in terms of subject matter.', '85');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('854', 'Higher Education', NULL, '85');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('855', 'Other Education Services\n', 'This group includes general continuing education and continuing vocational education and training for any profession. Instruction my be oral or written and may be provided in classrooms or by radio, television, Internet, correspondence or other means of communication. This group also includes the provision of instruction in athletic activities to groups or individuals, foreign language instructions, instruction in the arts, drama or music or other instruction or specialized training, not comparable to the education in groups 851-853.\nThis group excludes provision of primary education, secondary education or higher education, see group 852, 853 and 854.', '85');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('856', 'Educational Support Services', NULL, '85');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('861', 'Hospital Activities\n', 'This class includes :\nShort-or long-term hospital activities, i.e. medical, diagnostic and treatment activities, of general hospitals (e.g. community and regional hospitals, hospital of non-profit organizations, university hospitals, military-base and prison hospitals) and specialized hospitals (e.g. mental health and substance abuse hospitals, hospitals for infectious diseases, maternity hospitals, specialized sanitaria).\nThe activities which are chiefly directed to inpatients are carried out under the direct supervision of medical doctors and include :\nservices of medical and paramedical staff\nservices of laboratory and technical facilities, including radiologic and anaesthesiologic services\nemergency room services\nprovision of operating room services, pharmacy services, food and other hospital services\nservices of family planning centers providing medical treatment such as sterilization and termination of pregnancy, with accommodation.\nThis class excludes :\nLaboratory testing and inspection of all types of materials and products, except medical, see 7120;\nVeterinary activities, see 7500;\nHealth activities for military personnel in the field, see 8422;\nDental practice activities of a general or specialized nature, e.g. dentistry, endodontic and pediatric dentistry; oral pathology, orthodontic activities, see 862;\nPrivate consultantNULLs services to inpatients, see 862;\nMedical laboratory testing, see 8690;\nAmbulance transport activities, see 8690.', '86');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('862', 'Medical and Dental Practice Activities\n', 'This group includes :\nMedical consultation and treatment in the field of general and specialized medicine by general practitioners and medical specialists and surgeons\nDental practice activities of a general or specialized nature, e.g. dentistry, endodontic and pediatric dentistry; oral pathology\nOrthodontic activities\nFamily planning centers providing medical treatment such as sterilization and termination of pregnancy, without accommodation.\nThese activities can be carried out in private practice, group practices and in hospital outpatient clinics, and in clinics such as those attached to firms, schools, homes for the aged, labor organizations and fraternal organizations, as well as in patientNULLs home.\nThis class also includes :\nDental activities in operating rooms\nPrivate consultants services to inpatients\nThis class excludes :\nProduction of artificial teeth, denture and prosthetic appliances by dental laboratories, see 3250;\nInpatient hospital activities, see 861;\nParamedical activities such as those of midwives, nurses and physiotherapists, see 8690.', '86');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('869', 'Other Human Health Activities', NULL, '86');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('871', 'Residential Nursing Care Facilities', NULL, '87');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('872', 'Residential Care Activities for Mental Retardation, Mental Health and Substance Abuse', NULL, '87');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('873', 'Residential Care Activities for the Elderly and Disabled', NULL, '87');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('879', 'Other Residential Care Activities, N.e.c.', NULL, '87');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('881', 'Social Work Activities without Accommodation for the Elderly and Disabled', NULL, '88');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('889', 'Other Social Work Activities without Accommodation, N.e.c.', NULL, '88');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('900', 'Creative, Arts and Entertainment Activities', NULL, '90');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('910', 'Libraries, Archives, Museums and Other Cultural Activities', NULL, '91');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('920', 'Gambling and Betting Activities', NULL, '92');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('931', 'Sports Activities\n', 'This group includes the operation of sports facilities; activities of sports teams or clubs primarily participating in live sports events before a paying audience; independent athletes engaged in participating in live sporting or racing events before a paying audience; owners of racing participants such as cars, dogs, horses, etc. primarily engaged in entering them in racing events or other spectator sports events; sports trainers providing specialized services to support participants in sports events or competitions; operators of arenas and stadiums; other activities of organizing, promoting or managing sports events, n.e.c.', '93');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('932', 'Other Amusement and Recreation Activities\n', 'This group includes the activities of a wide range of units that operate facilities or provide services to meet the varied recreational interests of their patrons, including the operation of a variety of attractions, such as mechanical rides, water rides, games, shows, theme exhibits and picnic grounds.\nThis group excludes :\nSports activities, see group 931;\nDramatic arts, music and other arts and entertainment activities, see 9000.', '93');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('941', 'Activities of Business, Employers and Professional Membership Organizations\n', 'This group includes the activities of units that promote the interests of the members of business and employers organization. In the case of professional membership organizations, it also includes the activities of promoting the professional interests of members of the profession.', '94');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('942', 'Activities of Trade Unions', NULL, '94');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('949', 'Activities of Other Membership Organizations\n', 'This group includes the activities of units (except business and employers organizations, professional organizations, trade unions) that promote the interests of their members.', '94');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('951', 'Repair of Computers and Communications Equipment\n', 'This group includes the repair and maintenance of computers and peripheral equipment and communications equipment.', '95');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('952', 'Repair of Personal and Household Goods\n', 'This group includes the repair and servicing of personal and household goods.', '95');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('961', 'Personal Services for Wellness, Except Sports Activities', NULL, '96');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('962', 'Laundry Services', NULL, '96');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('963', 'Funeral and Related Activities', NULL, '96');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('964', 'Domestic Services', NULL, '96');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('969', 'Other Personal Service Activities, N.e.c.', NULL, '96');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('970', 'Activities of Households as Employers of Domestic Personnel', NULL, '97');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('981', 'Undifferentiated Goods-producing Activities of Private Households for Own Use', NULL, '98');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('982', 'Undifferentiated Services-producing Activities of Private Households for Own Use', NULL, '98');
INSERT INTO psic_group (code, description, details, divisionid) VALUES ('990', 'Activities of Extra-territorial Organizations and Bodies', NULL, '99');


-- CLASS
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0111', 'Growing of Cereals (Except Rice and Corn), Leguminous Crops and Oil Seeds', NULL, '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0112', 'Growing of Paddy Rice\n', 'This class includes the growing of palay, including organic and the growing of genetically modified rice.', '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0113', 'Growing of Corn, Except Young Corn (Vegetable)', NULL, '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0114', 'Growing of Sugarcane Including Muscovado Sugar-making in the Farm', NULL, '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0115', 'Growing of Tobacco', NULL, '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0116', 'Growing of Fiber Crops', NULL, '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0117', 'Growing of Leafy and Fruit Bearing Vegetables', NULL, '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0118', 'Growing of Other Vegetables, Melons, Roots and Tubers', NULL, '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0119', 'Growing of Other Non-perennial Crops\n', 'This class includes growing of flowers, including production of cut flowers and flower buds.', '011');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0121', 'Growing of Banana', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0122', 'Growing of Pineapple', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0123', 'Growing of Citrus Fruits', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0124', 'Growing of Mango', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0125', 'Growing of Papaya', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0126', 'Growing of Coconut, Including Copra-making, Tuba Gathering and Coco-shell Charcoal and Coconut Sap Syrup Making in the Farm', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0127', 'Growing of Beverage Crops', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0128', 'Growing of Spices, Aromatic, Drugs and Pharmaceutical Crops', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0129', 'Growing of Other Fruits and Perennial Crops', NULL, '012');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0130', 'Plant Propagation', NULL, '013');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0141', 'Raising of Cattle and Buffaloes', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0142', 'Raising of Horses and Other Equines', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0143', 'Dairy Farming', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0144', 'Raising of Sheep and Goats', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0145', 'Hog Raising', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0146', 'Raising (Farming) of Chicken (Including Operation Chicken Hatcheries), in Confined and Free-range Environment', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0147', 'Raising of Poultry (Except Chicken)', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0148', 'Egg Production', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0149', 'Raising of Other Animals', NULL, '014');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0151', 'Operation of Irrigation Systems Through Cooperatives and Non-cooperatives', NULL, '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0152', 'Planting, Transplanting and Other Related Activities', NULL, '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0153', 'Services to Establish Crops, Promote Their Growth and Protect Them from Pests and Diseases', NULL, '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0154', 'Harvesting, Threshing, Grading, Bailing and Related Services', NULL, '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0155', 'Rental of Farm Machinery with Drivers and Crew', NULL, '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0156', 'Support Activities for Animal Production', NULL, '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0157', 'Post-harvest Crop Activities', NULL, '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0158', 'Seed Processing for Propagation\n', 'This class includes all post-harvest activities aimed at improving the propagation quality of seed through the removal of non-seed materials, undersized, mechanically or insect-damaged and immature seeds as well as removing the seed moisture to a safe level for seed storage. This activity includes the drying, cleaning, grading and treating of seeds until they are marketed. The treatment of genetically modified seeds is included here.\nThis class excludes :\nGrowing of seeds, see groups 011 and 012;\nProcessing of seeds to obtain oil, see 104;\nResearch of seeds or modify new forms of seeds, see 7210', '015');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0170', 'Hunting, Trapping and Related Service Activities\n', 'This class includes :\nHunting and trapping on a commercial basis\nTaking of animals (dead or alive) for food, fur, skin, or for use in research, in zoos or as pets\nProduction of fur skins, reptile, or bird skins from hunting or trapping activities\nThis class excludes :\nProduction of fur skins, reptile or bird skins from ranching operations, see group 014;\nRaising of game animals on ranching operations, see 0149;\nCatching of whales, see 0311;\nProduction of hides and skins originating from slaughterhouses, see 1011;\nHunting for sport or recreation and related service activities, see 9319;\nService activities to promote hunting and trapping, see 9499.', '017');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0211', 'Growing of Timber Forest Species (E.g. Gmelina, Eucalyptus, Etc.), Planting, Replanting, Transplanting, Thinning and Conserving of Forest and Timber Tracts', NULL, '021');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0212', 'Operation of Forest Tree Nurseries', NULL, '021');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0220', 'Logging\n', 'This class includes :\nProduction of roundwood for forest-based manufacturing industries\nProduction of roundwood use in an unprocessed form such as pit-props, fence posts and utility poles\nGathering and production of fire wood\nProduction of charcoal in the forest (using traditional method)\nThe output of this activity can take the form of logs, chips or fire wood.\nThis class excludes :\nGrowing of Christmas trees, see 0129;\nGrowing of standing timber; planting, replanting , transplanting, thinning and conserving of forests and timber tracts; see 0211;\nGathering of wild growing non-wood forest products, 0230;\nProduction of wood chips and particles, see 1610;\nProduction of charcoal through distillation of wood, see 2011.', '022');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0230', 'Gathering of Non-wood Forest Products', NULL, '023');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0240', 'Support Services to Forestry', NULL, '024');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0311', 'Marine Fishing\n', 'This class includes :\nFishing on a commercial basis in ocean and coastal water\nTaking of marine crustaceans and mollusks\nWhale catching\nTaking of marine aquatic animals : turtles, sea squirts, tunicates, sea urchins, etc.\nThis class also includes :\nActivities of vessels engaged in both fishing and in processing and preserving of fish\nGathering of other marine organisms and materials: natural pearls, sponges, coral and algae.\nThis class excludes :\nCapturing of marine mammals, except whales, e.g. walruses, seals, see 0170;\nProcessing of fish, crustaceans and mollusks on factory ships or in factories ashore, see 1020;\nRental of pleasure boats with crew for sea and coastal water transport (e.g. for fishing cruises), see 5011;\nFishing inspection for sport or recreation and related services, see 9319;\nFishing practiced for sport or recreation and related services, see 9319;\nOperation of sport fishing preserves, see 9319.', '031');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0312', 'Freshwater Fishing\n', 'This class includes :\nFishing on a commercial basis in inland waters\nTaking of freshwater crustaceans and mollusks\nTaking of freshwater aquatic animals\nGathering of freshwater materials\nThis class excludes :\nProcessing of fish, crustaceans and mollusks, see 1020;\nFishing inspection, protection and patrol services, see 8423;\nFishing practiced for sport or recreation and related services, see 9319;\nOperation of sport fishing preserves, see 9319.', '031');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0313', 'Support Service Activities Incidental to Fishing', NULL, '031');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0321', 'Operation of Freshwater Fish Pond, Fish Pens, Cage and Hatcheries', NULL, '032');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0322', 'Operation of Marine or Sea Water Fish Tanks, Pens, Cage and Hatcheries', NULL, '032');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0323', 'Prawn Culture in Brackish Water', NULL, '032');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0324', 'Culture of Mollusks, Bivalves and Other Crustaceans (Except Prawn Culture)', NULL, '032');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0325', 'Pearl Culture and Pearl Shell Gathering', NULL, '032');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0326', 'Seaweeds Farming and Gathering', NULL, '032');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0329', 'Other Aquaculture Activities', NULL, '032');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0510', 'Mining of Hard Coal', NULL, '051');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0520', 'Mining of Lignite', NULL, '052');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0610', 'Extraction of Crude Petroleum', NULL, '061');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0620', 'Extraction of Natural Gas', NULL, '062');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0710', 'Mining of Iron Ores', NULL, '071');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0721', 'Mining of Uranium and Thorium Ores', NULL, '072');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0722', 'Mining of Precious Metals\n', 'This class covers the mining of precious metals such as gold, silver, platinum and other precious metals. This also includes activities processing of to remove non-metallic parts.', '072');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0729', 'Mining of Other Non-ferrous Metal Ores\n', 'This class includes :\nMining and preparation of ores valued chiefly for non-ferrous meral content : aluminum (bauxite), copper, lead, zinc, tin, manganese, chrome, nickel, cobalt, molybdenum, tantalum, vanadium, etc.', '072');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0810', 'Quarrying of Stone, Sand and Clay\n', 'This class includes :\nQuarrying, rough trimming and sawing of monumental and building stone such as marble, granite, sandstone etc.\nQuarrying, crushing and breaking of limestone\nBreaking and crushing of stone\nMining of clays, refractory clays and kaolin\nQuarrying of sand; breaking and crushing of gravel; extraction and dredging of sand for construction and gravel\nExtraction and dredging of industrial sand\nMining of gypsum and anhydrite\nMining of chalk and uncalcined dolomite\nThis class excludes :\nMining of bituminous sand, see 0610;\nMining of chemical and fertilizer minerals, see 0891;\nProduction of calcined dolomite, see 2394;\nCutting, shaping and finishing of stone outside quarries, see 2396.', '081');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0891', 'Mining of Chemical and Fertilizer Minerals\n', 'This class includes :\nMining of natural phosphates and natural potassium salts\nMining of native sulphur\nExtraction and preparation of pyrites and pyrrhotite, except roasting\nMining of natural barium sulphate and carbonate (barytes and whiterite), natural borates, natural magnesium sulphates (kieserite)\nMining of earth colors, fluorspar and other minerals valued chiefly as a source of chemicals\nGuano mining\nThis class excludes :\nExtraction of salt, see 0893;\nRoasting of iron and pyrites, see 2011;\nManufacture of synthetic fertilizers and nitrogen compounds, see 2012.', '089');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0892', 'Extraction of Peat', NULL, '089');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0893', 'Extraction of Salt', NULL, '089');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0899', 'Other Mining and Quarrying, N.e.c.', NULL, '089');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0910', 'Support Activities for Petroleum and Gas Extraction\n', 'This class includes :\nOil and gas extraction service activities provided on a fee or contract basis such as:\nexploration services in connection with petroleum or gas extraction, e,g, traditional prospecting methods, such as making geological observations at prospective sites\ndirectional drilling and redrilling; \"spudding inn\"; derrick erection in situ, repairing and dismantling; cementing oil and gas well casings; pumping of wells; plugging and abandoning wells, etc.\nliquefaction and regasification of natural gas for purpose of transport, done at the mine site\ndraining and pumping services, on a fee or contract basis\ntest drilling in connection with petroleum or gas extraction\nThis class also includes oil and gas field fire fighting services.\nThis class excludes:\nService activities performed by operators of oil & gas fields, see 0610, 0620;\nSpecialized repair of mining machinery, see 3312;\nLiquefaction and regasification of natural gas for purpose of transport, done off the mine site, see 5221;\nGeophysical, geologic and seismic surveying, see 7110.', '091');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('0990', 'Support Activities for Other Mining and Quarrying', NULL, '099');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1011', 'Slaughtering and Meat Packing', NULL, '101');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1012', 'Production, Processing and Preserving of Meat and Meat Products\n', 'This class includes :\nProduction of fresh, chilled or frozen meat or poultry\nPreservation and preparation of meat and meat products by such processes as drying, smoking, salting, immersing in brine or canning\nProduction of meat products (tocino, tapa, ham, bacon, sausage, longanisa, corned beef, hotdog, meat loaf, salami, bolognas, pates and paste, rillettes)\nRendering of lard and other edible fats of animal origin\nThis class excludes:\nManufacture of prepared frozen meat and poultry dishes, see 1075;\nManufacture of soup containing meat, see 1079;\nWholesale trade of meat, see 4630;\nPackaging of meat, see 8292.', '101');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1020', 'Processing and Preserving of Fish, Crustaceans and Mollusks\n', 'This class includes :\nProduction of fish, crustaceans and mollusks products: cooked fish, fish fillets, roes, caviar, caviar substitutes, shrimp paste, crab paste, milkfish paste, etc.\nProduction of fishmeal for human consumption and animal feed\nProduction of fermented fish, fish paste or fish balls\nPreparation and preserving of fish, crustaceans and mollusks : freezing, deep-freezing, drying, smoking, salting, immersing in brine, canning, etc.\nProduction of meals and solubles from fish and other aquatic animals unfit for human consumption\nThis class also includes :\nActivities of vessels engaged only in the processing and preserving of fish\nProcessing of seaweeds, agar-agar or carrageenan\nThis class excludes :\nProcessing of whales on land or specialized vessels, see 1011;\nProduction of oils and fats from marine material, see 1049;\nManufacture of prepared frozen fish dishes, see 1075;\nManufacture of fish soups, see 1079.', '102');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1030', 'Processing and Preserving of Fruits and Vegetables\n', 'This class includes :\nManufacture of food consisting chiefly of fruit or vegetables, except ready-made dishes in frozen or canned form\nPreserving of fruit, nuts, beans or vegetables: freezing, drying, immersing /cooking in oil or in vinegar, sugar or sweetening matter, canning or in bottles\nManufacture of fruit or vegetable food products\nManufacture of fruit or vegetable juices\nManufacture of jams, marmalades and table jellies\nProcessing and preserving of potatoes:\nManufacture of prepared frozen potatoes\nManufacture of dehydrated mashed potatoes\nManufacture of potato snacks\nManufacture of potato crisps\nManufacture of potato flour and meal\nRoasting of nuts\nManufacture of nut foods and pastes\nIndustrial peeling of potatoes\nProduction of concentrates from fresh fruits and vegetables\nManufacture of perishable prepared foods of fruit and vegetables, such as : salads, peeled or cut vegetables, tofu (bean curd)\nThis class excludes :\nManufacture of flour or meal of dried leguminous vegetables, see 1062;\nPreservation of fruit and nuts in sugar, see 1073;\nManufacture of prepared vegetables dishes, see 1075;\nManufacture of artificial concentrates, see 1079.', '103');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1041', 'Manufacture of Virgin Coconut Oil', NULL, '104');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1044', 'Production of Crude Vegetable Oil, Cake and Meals, Other Than Virgin Coconut Oil (See Class 1041)', NULL, '104');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1045', 'Manufacture of Refined Coconut and Other Vegetable Oil (Including Corn Oil) and Margarine', NULL, '104');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1046', 'Manufacture of Fish Oil and Other Marine Animal Oils', NULL, '104');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1047', 'Manufacture of Unprepared Animal Feeds from Vegetable, Animal Oils and Fats', NULL, '104');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1049', 'Manufacture of Vegetable and Animal Oil and Fats, N.e.c.', NULL, '104');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1051', 'Processing of Fresh Milk and Cream', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1052', 'Manufacture of Powdered Milk (Except for Infants) and Condensed or Evaporated Milk (Filled, Combined or Reconstituted)', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1053', 'Manufacture of Infantsnull Powdered Milk', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1054', 'Manufacture of Butter, Cheese and Curd', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1055', 'Manufacture of Ice Cream and Sherbet, Ice Drop, Ice Candy and Other Flavored Ices', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1056', 'Manufacture of Milk-based Infantsnull and Dietetic Foods', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1057', 'Manufacture of Yoghurt', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1058', 'Manufacture of Whey', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1059', 'Manufacture of Dairy Products, N.e.c.', NULL, '105');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1061', 'Rice/corn Milling', NULL, '106');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1062', 'Manufacture of Grain and Vegetable Mill Products Except Rice and Corn\n', 'This class includes :\nGrain milling : production of flour, groats, meal or pellets of (wheat, rye, oats) or other cereal grains\nVegetable milling; production of flour or meal of dried leguminous vegetables, of roots or tubers, or of edible nuts\nManufacture of cereal breakfast foods\nManufacture of flour mixes and prepared blended flour and dough for bread, cakes, biscuits or pancakes.\nThis class excludes :\nManufacture of potato flour and meal, see 1030;\nWet corn milling, see 1063.', '106');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1063', 'Manufacture of Starches and Starch Products', NULL, '106');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1071', 'Manufacture of Bakery Products\n', 'This class includes :\nManufacture of fresh, frozen or dry bakery products\nManufacture of bread and rolls\nManufacture of fresh pastry, cakes, pies, tarts, etc.\nManufacture of preserved pastry goods and cakes\nManufacture of frozen bakery products: pancakes, waffles, rolls, etc.\nManufacture of rusks, biscuits and other \"dry\" bakery products\nManufacture of snack products (cookies, crackers, pretzels, etc.) whether sweet or salted\nManufacture of tortillas\nThis class excludes :\nManufacture of farinaceous products (pastas), see 1074;\nManufacture of potato snacks, see 1030;\nHeating of bakery items for immediate consumption, see division 56.', '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1072', 'Manufacture of Sugar\n', 'This class includes :\nManufacture or refining of sugar (sucrose) and sugar substitutes from the juice of cane, beet, maple, coconut and palm\nManufacture of sugar syrups\nManufacture of molasses\nProduction of maple syrup and sugar\nThis class excludes manufacture of glucose, glucose syrup, maltose, see 1063.', '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1073', 'Manufacture of Cocoa, Chocolate and Sugar Confectionery\n', 'This class includes :\nManufacture of cocoa, cocoa butter, cocoa fat, cocoa paste, cocoa oil\nManufacture of chocolate and chocolate confectionery\nManufacture of sugar confectionery: caramels, cachous, nougats, fondant (white chocolate)\nManufacture of chewing gum\nPreserving in sugar of fruit, nuts, fruit peels and other parts of plants\nManufacture of confectionery lozenges and pastilles\nThis class excludes manufacture of sucrose sugar, see 1072.', '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1074', 'Manufacture of Macaroni, Noodles, Couscous and Similar Farinaceous Products', NULL, '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1075', 'Manufactured of Prepared Meals and Dishes', NULL, '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1076', 'Manufacture of Food Supplements from Herbs and Other Plants', NULL, '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1077', 'Coffee Roasting and Processing', NULL, '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1078', 'Manufacturing of Nata De Coco and Native Delicacies or \"kakanin\" E.g., Bibingka, Puto, Suman, Kalamay, Binagol, Moron and Other Similar Products', NULL, '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1079', 'Manufacture of Other Food Products, N.e.c.\n', 'This class includes :\nBlending of tea and mate\nManufacture of extracts and preparation based on tea or mate\nManufacture of soup and broths\nManufacture of special foods, such as: infant formula, follow up milks and other follow up foods and baby foods\nFoods containing homogenized ingredients\nManufacture of spices, sauces and condiments : mayonnaise, mustard flour and meal and soya sauce etc.\nManufacture of vinegar\nManufacture of artificial honey and caramel\nManufacture of perishable prepared foods such as: sandwiches, fresh (uncooked) pizza\nThis class also includes :\nManufacture of herb infusions (mint, vervain, chamomile, etc.)\nManufacture of yeast\nManufacture of extracts and juices of meat, fish, crustaceans or mollusks\nManufacture of non-dairy milk and cheese substitutes\nManufacture of artificial concentrates\nManufacture of egg products, egg albumin\nProcessing of salt into food-grade salt, e.g. iodized salt.\nThis class excludes :\nGrowing of spice crops, see 0128;\nManufacture of inulin, see 1063;\nManufacture of frozen pizza, see 1075;\nManufacture of spirits, beer, wine and soft drinks, see division 11;\nPreparation of botanical products for pharmaceutical use, see 2100.', '107');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1080', 'Manufacture of Prepared Animal Feeds', NULL, '108');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1101', 'Distilling, Rectifying and Blending of Spirits', NULL, '110');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1102', 'Manufacture of Wines\n', 'This class includes :\nManufacture of wine from fruits (mango wine), sugarcane (basi), vegetables and root crops (ube wine), coconut (lambanog) and rice\nManufacture of sparkling wine\nManufacture of wine from concentrated grape must\nManufacture of fermented but not distilled alcoholic beverages: sake, cider, perry, mead, other fruit wines and mixed beverages containing alcohol\nBlending of wine\nManufacture of low alcohol or non-alcoholic wine\nThis class excludes :\nManufacture of vinegar, see 1079;\nMerely bottling and labeling , see 4630 (if performed as part of wholesale) and 8292 (if performed on a fee or contract basis)', '110');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1103', 'Manufacture of Malt Liquors and Malt', NULL, '110');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1104', 'Manufacture of Soft Drinks\n', 'This class includes :\nManufacture of soft drinks : non-alcoholic flavored and/or sweetened waters: lemonade, orangeade, cola, fruit drinks, tonic waters, etc.\nThis class excludes :\nProduction of fruit and vegetable juice, see 1030;\nManufacture of milk-based drinks, see 1059;\nManufacture of coffee, tea and mate products, see 1079;\nManufacture of alcohol-based drinks, see 1101,1102,1103;\nManufacture of non-alcoholic wine, see 1102;\nManufacture of non-alcoholic beer, see 1103;\nMerely bottling and labeling , see 4630 (if performed as part of wholesale) and 8292 (if performed on a fee or contract basis).', '110');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1105', 'Manufacture of Drinking Water and Mineral Water', NULL, '110');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1106', 'Manufacture of Sports and Energy Drink', NULL, '110');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1109', 'Manufacture of Other Beverages, N.e.c.', NULL, '110');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1201', 'Manufacture of Cigarettes', NULL, '120');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1202', 'Manufacture of Cigars', NULL, '120');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1203', 'Manufacture of Chewing and Smoking Tobacco, Snuff', NULL, '120');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1204', 'Curing and Redrying Tobacco Leaves', NULL, '120');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1209', 'Tobacco Manufacturing, N.e.c.', NULL, '120');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1311', 'Preparation and Spinning of Textile Fibers\n', 'This class includes :\nPreparatory operations on textile fibers: reeling and washing of silk; degreasing and carbonizing of wool and dyeing of wool fleece; carding and combing of all kinds of animal, vegetable and man-made fibers\nSpinning and manufacture of yarn or thread for weaving or sewing, for the trade or for further processing :\nTexturizing, twisting, folding, cabling and dipping of synthetic or artificial filament yarns\nManufacture of paper yarn\nThis class excludes :\nPreparatory operations carried out in combination with agriculture or farming, see 01;\nRetting of plants bearing vegetable textile fibers(jute, flax, coir etc.), see 0116;\nCotton ginning, see 0157;\nManufacture of synthetic or artificial fibers and tows, manufacture of single yarns (including high tenacity yarn and yarn for carpets) of synthetic or artificial fibers see 2030;\nManufacture of glass fibers, see 2310.', '131');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1312', 'Weaving of Textiles', NULL, '131');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1313', 'Finishing of Textiles', NULL, '131');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1314', 'Preparation and Finishing of Textiles (Integrated)', NULL, '131');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1391', 'Manufacture of Knitted and Crocheted Fabrics', NULL, '139');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1392', 'Manufacture of Made-up Textile Articles, Except Wearing Apparel\n', 'This class includes :\nManufacture of made-up textile articles except wearing apparel, including of knitted or crocheted fabrics: blankets, including travelling rugs; bed, table, toilet or kitchen linen; quilts, eiderdowns, cushions, pouffes, pillows, sleeping bags, etc.\nManufacture of made-up furnishing articles :\ncurtains, valances, blinds, bedspreads, furniture or machine covers, etc.\ntarpaulins, tents, camping goods, sails, sun blinds, loose covers for cars, machines or furniture, etc.\nflags, banners, pennants, etc.\ndust cloths, dishcloths and similar articles, life jackets, parachutes etc.\nManufacture of hand-woven tapestries\nManufacture of tire covers.\nThis class excludes :\nManufacture of textile articles for technical use, see 1399.', '139');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1393', 'Manufacture of Carpet and Rugs\n', 'This class includes :\nManufacture of textile floor coverings : carpets, rugs and mats, tiles\nManufacture of needle-loom felt floor coverings\nThis class excludes :\nManufacture of mats and matting of plaiting materials, see 1629;\nManufacture of floor coverings of cork, see 1629;\nManufacture of resilient floor coverings, such as vinyl, linoleum, see 2220.', '139');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1394', 'Manufacture of Cordage, Rope, Twine and Netting\n', 'This class includes:\nManufacture of twine, cordage, rope and cables of textile fibers or strip or the like, whether or not impregnated, coated, covered or sheathed with rubber or plastic\nManufacture of products of rope or netting\nFishing nets, shipsNULL fenders, unloading cushions, loading slings, rope or cable fitted with metal rings, etc.\nManufacture of knotted netting of twine, cordage or rope\nThis class excludes :\nManufacture of hairnets, see 1419;\nManufacture of wire rope, see 2599.', '139');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1395', 'Manufacture of Embroidered Fabrics', NULL, '139');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1399', 'Manufacture of Other Textiles, N.e.c.\n', 'This class includes all activities related to textiles or textile products, not specified elsewhere in division 13 (Manufacture of textiles) or 14 (Manufacture of wearing apparel), involving a large number of processes and a great variety of goods produced.\nThis class includes :\nManufacture of narrow woven fabrics, including fabrics consisting of warp without weft assembled by means of an adhesive\nManufacture of labels, badges etc.\nManufacture of ornamental trimmings : braids, tassels, pompons etc.\nManufacture of felt\nManufacture of tulles and other net fabrics, and of lace and embroidery, in piece, in strips or in motifs\nManufacture of fabrics impregnated, coated, covered or laminated with plastic\nManufacture of metallized yarn or gimped yarn, rubber thread and cord covered with textile material, textile yarn or strip covered, impregnated, coated or sheathed with rubber or plastic\nManufacture of tire cord fabric of high-tenacity man made yarn\nManufacture of other treated or coated fabrics; tracing cloth, canvas prepared for use by painters, buckram and similar stiffened textile fabrics, fabrics coated with gum or amylaceous substances\nManufacture of diverse textile articles; textile wicks, incandescent gas mantles and tubular gas mantle fabric, hosepiping, transmission or conveyor belts or belting (whether or not reinforced with metal or other material, bolting cloth, straining cloth)\nManufacture of automotive trimmings\nManufacture of pressure sensitive cloth-tape\nManufacture of artistNULLs canvas boards and tracing cloth\nManufacture of shoe-lace, of textiles\nManufacture of powder puffs and mints\nThis class excludes :\nManufacture of needle-loom felt floor coverings, see 1322;\nManufacture of textile wadding and articles of wadding: sanitary towels, tampons etc., see 1709;\nManufacture of transmission or conveyor belts of textile fabric, yarn or cord impregnated, coated, covered or laminated with rubber, where rubber is the chief constituent, see 2219;\nManufacture of plates or sheets of cellular rubber or plastic combined with textiles for reinforcing purposes only, see 2219, 2220;\nManufacture of cloth of woven metal wire, see 2599.', '139');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1411', 'Mennulls and Boynulls Garment Manufacturing', NULL, '141');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1412', 'Womennulls and Girlnulls Garment Manufacturing', NULL, '141');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1413', 'Ready-made Embroidered Garments Manufacturing', NULL, '141');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1414', 'Babiesnull Garment Manufacturing', NULL, '141');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1419', 'Manufacture of Wearing Apparel, N.e.c', NULL, '141');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1421', 'Custom Tailoring', NULL, '142');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1422', 'Custom Dressmaking', NULL, '142');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1430', 'Manufacture of Knitted and Crocheted Apparel\n', 'This includes the manufacture of knitted or crocheted wearing apparel and other made-up articles directly into shape (such as pullovers, cardigans, jerseys, waistcoats and similar articles), and hosiery, including socks, tights and pantyhose.\nThis excludes the manufacture of knitted and crocheted textiles.\nThis class includes :\nManufacture of knitted or crocheted wearing apparel and other made-up articles directly into shape: pullovers, cardigans, jerseys, waistcoats and similar articles\nManufacture of hosiery, including socks, tights and pantyhose.\nThis class excludes manufacture of knitted and crocheted textiles, see 1391.', '143');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1440', 'Manufacture of Articles of Fur', NULL, '144');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1511', 'Tanning and Dressing of Leather', NULL, '151');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1512', 'Manufacture of Products of Leather and Imitation Leather\n', 'This class includes :\nManufacture of luggage, handbags and the like, of leather, composition leather or any other material, (mostly imitation leathers) such as plastic sheeting, textile materials, vulcanized fiber or paperboard, where the same technology is used as for leather.\nManufacture of non-metallic watch bands (e.g. fabric, leather, plastic)\nManufacture of diverse articles of leather or composition leather: driving belts, packings, etc.\nManufacture of shoe-lace, of leather\nManufacture of horse whips and riding crops\nThis class excludes :\nManufacture of leather wearing apparel, see 141;\nManufacture of leather gloves and hats, see 141;\nManufacture of footwear, see 152;\nManufacture of saddles for bicycles, see 3092;\nManufacture of precious metal watch straps, see 3211;\nManufacture of non-precious metal watch straps, see 3212;\nManufacture of linemenNULLs safety belts and other belts for occupational use, see 3299.', '151');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1521', 'Manufacture of Leather Shoes', NULL, '152');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1522', 'Manufacture of Rubber Shoes', NULL, '152');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1523', 'Manufacture of Plastic Shoes', NULL, '152');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1524', 'Manufacture of Shoes Made of Textile Materials with Applied Soles', NULL, '152');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1525', 'Manufacture of Wooden Footwear and Accessories', NULL, '152');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1529', 'Manufacture of Footwear, N.e.c.', NULL, '152');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1610', 'Sawmilling and Planing of Wood\n', 'This class includes :\nSawing, planing and machining of wood\nSlicing, peeling or chipping logs\nManufacture of wooden railway sleepers\nManufacture of unassembled wood flooring including parquet flooring\nImpregnation or chemical treatment of wood with preservatives or other materials, manufacture of wood wool, wood flour, chips, particles, when done as a primary activity\nOperation of sawmills and planing mill, whether or not mobile, in the forest or elsewhere\nSawing rough lumber or timber from logs and bolts or resawing cants and flitches into lumber\nPlaning combined with sawing or separately, producing surfaced lumber and timber and standard workings or patterns of lumber\nThis class excludes :\nLogging and production of wood in the rough, see 0220;\nManufacture of veneer sheets thin enough for use in plywood boards and panels, see 1621;\nManufacture shingles and shakes, beadings and moldings, see 1622.', '161');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1621', 'Manufacture of Veneer Sheets; Manufacture of Plywood, Laminboard, Particle Board and Other Panels and Board\n', 'This class includes :\nManufacture of veneer sheets thin enough to be used for veneering, making plywood or other purposes: smoothed dyed, coated, impregnated reinforced (with paper or fabric backing)\n made in the form of motifs\nManufacture of particle board and fiberboard\nManufacture of densified wood\nManufacture of plywood, veneer panels and similar laminated wood boards and sheets\nManufacture of glue laminated wood, laminated veneer wood', '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1622', 'Manufacture of Wooden Window and Door Screens, Shades and Venetian Blinds', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1623', 'Manufacture of Other Buildersnull Carpentry and Joinery; Millworking', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1624', 'Manufacture of Wooden Containers', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1625', 'Manufacture of Wood Carvings', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1626', 'Manufacture of Charcoal Outside the Forest', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1627', 'Manufacture of Wooden Wares', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1628', 'Manufacture of Products of Bamboo, Cane, Rattan and the Like, and Plaiting Materials Except Furniture', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1629', 'Manufacture of Other Products of Wood; Manufacture of Articles of Cork and Plaiting Materials, Except Furniture, N.e.c.', NULL, '162');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1701', 'Manufacture of Pulp, Paper and Paperboard\n', 'This class includes :\nManufacture of bleached, semi-bleached or unbleached paper pulp by mechanical, chemical (dissolving or non-dissolving) or semi-chemical processes\nManufacture of cotton-linters pulp\nRemoval of ink and manufacture of pulp from waste paper\nManufacture of paper and paperboard intended for further industrial processing\nThis class also includes :\nFurther processing of paper and paperboard:\ncoating, covering and impregnation of paper and paperboard\nmanufacture of creped or crinkled paper\nmanufacture of laminates and foils, if laminated with paper and paperboard\nManufacture of hand-made paper\nManufacture of newsprint and other printing or writing paper\nManufacture of cellulose wadding and webs of cellulose fibers\nManufacture of carbon paper or stencil paper in rolls or large sheets\nThis class excludes :\nManufacture of corrugated paper and paperboard, see 1702;\nManufacture of further-processed articles of paper, paperboard or pulp, see 1709;\nManufacture of coated or impregnated paper, where the coating or impregnant is the main ingredient, see class in which the manufacture of the coating or impregnated is classified;\nManufacture of abrasive paper, see 2399;\nManufacture of cork life preservers, see 329.', '170');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1702', 'Manufacture of Corrugated Paper and Paperboard and of Containers of Paper and Paperboard', NULL, '170');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1709', 'Manufacture of Other Articles of Paper and Paperboard\n', 'This class includes :\nManufacture of household and personal hygiene paper and cellulose wadding products :\ncleansing tissues\nhandkerchiefs, towels, serviettes\ntoilet paper\nsanitary towels and tampons, napkins and napkin liners for babies\ncups, dishes and trays\nManufacture of textile wadding and articles of wadding : sanitary towels, tampons etc.\nManufacture of printing and writing paper ready for use\nManufacture of computer printout paper ready for use\nManufacture of self-copy paper ready for use\nManufacture of duplicator stencils and carbon paper ready for use\nManufacture of gummed or adhesive paper ready for use\nManufacture of envelopes and letter-cards\nManufacture of registers, accounting books, binders, albums and similar educational and commercial stationery\nManufacture of boxes, pouches, wallets and writing compendium containing an assortment of paper stationery\nManufacture of wallpaper and similar wall coverings, including vinyl-coated and textile wallpaper\nManufacture of labels, whether printed or not\nManufacture of filter paper and paperboard\nManufacture of paper and paperboard bobbins, spools, cops, etc.\nManufacture of egg trays and other molded pulp packaging products, etc.\nManufacture of paper novelties\nThis class excludes :\nManufacture of paper or paperboard in bulk, see 1701;\nPrinting on paper products, see 1811;\nManufacture of playing cards, see 3240;\nManufacture of games and toys of paper or paperboard, see 3240.', '170');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1811', 'Printing', NULL, '181');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1812', 'Service Activities Related to Printing\n', 'This class includes :\nBinding of printed sheets, e.g. into books, brochures, magazines, catalogues etc. by folding, assembling, stitching, glueing, collating, basting, adhesive binding, trimming, gold stamping, etc.\nComposition, typesetting, phototypesetting, pre-press data input including scanning and optical character recognition, electronic make-up\nPlate-making services including imagesetting and platesetting (for the printing processes letterpress and offset)\nEngraving or etching of cylinders for gravure\nPlate processes direct to plate (also photopolymer plates)\nPreparation of plates and dies for relief stamping or printing\nProduction of proofs\nArtistic work including preparation of litho stones and prepared woodblocks\nProduction of reprographic products\nDesign of printing products e.g. sketches, layouts, dummies etc.\nOther graphic activities such as die-sinking or die-stamping, Braille copying, punching and drilling, embossing, varnishing and laminating, collating and insetting, creasing', '181');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1820', 'Reproduction of Recorded Media\n', 'This class includes :\nReproduction from master copies of gramophone records, compact discs and tapes with music or other sound recordings from master copies of records\nReproduction from master copies of records, compact discs and tapes with motion pictures and other video recordings\nReproduction from master copies of software and data on discs and tapes\nThis class excludes :\nReproduction of printed matter, see 1811;\nPublishing of software, see 5820;\nProduction and distribution of motion pictures, videotapes and movies on DVD or similar media, see 5911, 5912, 5913;\nReproduction of motion picture films for theatrical distribution, see 5912;\nProduction of master copies for records or audio material, see 5920.', '182');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1910', 'Manufacture of Coke Oven Products', NULL, '191');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1920', 'Manufacture of Refined Petroleum Products', NULL, '192');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('1990', 'Manufacture of Other Fuel Products', NULL, '199');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2011', 'Manufacture of Basic Chemicals\n', 'This class includes the manufacture of chemicals using basic processes, such as thermal cracking and distillation. The output of these processes are usually separate chemical elements or separate chemically-defined compounds.\nThis class includes :\nManufacture of liquefied or compressed inorganic industrial or medical gases :\nelemental gases\nliquid or compressed air\nrefrigerant gases\nmixed industrial gases\ninert gases such as carbon dioxide\nisolating gases\nManufacture of dyes and pigments from any source in basic form or as concentrate\nManufacture of chemical elements\nManufacture of inorganic acids except nitric acid\nManufacture of alkalis, lyes and other inorganic bases except ammonia\nManufacture of other inorganic compounds\nManufacture of basic organic chemicals :\nacyclic hydrocarbons, saturated and unsaturated\ncyclic hydrocarbons, saturated and unsaturated\nacyclic and cyclic alcohols\nmono-and polycarboxylic acids, including acetic acid\nother oxygen-function compounds, including aldehydes, ketones, quinones and dual or poly oxygen-function compounds\nsynthetic glycerol; nitrogen-function organic compounds, including amines\nfermentation of sugarcane, cassava, corn or similar to produce alcohol and esters\nother organic compounds, including wood distillation products (e.g. charcoal) etc.\nManufacture of distilled water\nManufacture of synthetic aromatic products\nRoasting of iron pyrites\nManufacture of products of a kind used as fluorescent brightening agents or as luminophores\nEnrichment of uranium and thorium ores and production of fuel elements for nuclear reactors\nThis class excludes :\nExtraction of methane, ethane, butane or propane, see 0620;\nManufacture of fuel gases, such as ethane, butane or propane in a petroleum refinery, see 1920;\nManufacture of nitrogenous fertilizers and nitrogen compounds, see 2012;\nManufacture of ammonia, see 2012;\nManufacture of ammonium chloride, see 2012;\nManufacture of nitrites and nitrates of potassium, see 2012;\nManufacture of ammonium carbonates, see 2012;\nManufacture of plastics in primary forms, see 2013;\nManufacture of synthetic rubber in primary forms, see 2013;\nManufacture of prepared dyes and pigments, see 2022;\nManufacture of crude glycerol, see 2023;\nManufacture of natural essential oils, see 2029;\nManufacture of aromatic distilled waters, see 2029;\nManufacture of salicylic and O-acetylsalicylic acids, see 2100.', '201');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2012', 'Manufacture of Fertilizers and Nitrogen Compounds', NULL, '201');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2013', 'Manufacture of Plastics and Synthetic Rubber in Primary Forms\n', 'This class includes the manufacture of resins, plastic materials, and non-vulcanizable thermoplastic elastomers and mixing and blending resins on a custom basis as well as the manufacture of non-customized synthetic resins.\nThis class includes :\nManufacture of plastics in primary forms :\npolymers, including those of ethylene, propylene, styrene, vinyl chloride, vinyl acetate and acrylics\npolyamides\nphenolic and epoxide resins and polyurethanes\nalkyd and polyester resins and polyethers\nsilicones\nion-exchangers based on polymers\nManufacture of synthetic rubber in primary forms: synthetic rubber, factice\nManufacture of mixtures of synthetic rubber and natural rubber or rubber-like gums (e.g. balata)\nManufacture of cellulose and its chemical derivatives\nThis class excludes :\nManufacture of artificial and synthetic fibers, filaments and yarn, see 2030;\nShredding of plastic products, see 3830.', '201');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2021', 'Manufacture of Pesticides and Other Agro-chemical Products', NULL, '202');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2022', 'Manufacture of Paints, Varnishes and Similar Coatings, Printing Ink and Mastics\n', 'This class includes :\nManufacture of paints and varnishes, enamels or lacquers\nManufacture of prepared pigments and dyes, opacifiers and colors\nManufacture of vitrifiable enamels and glazes and engobes and similar preparations\nManufacture of mastics\nManufacture of caulking compounds and similar non-refractory filling or surfacing preparations\nManufacture of organic composite solvents and thinners\nManufacture of prepared paint or varnish removers\nManufacture of printing ink\nThis class excludes :\nManufacture of dyestuffs and pigments, see 2011;\nManufacture of writing and drawing ink, see 2029.', '202');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2023', 'Manufacture of Soap and Detergents, Cleaning and Polishing Preparations, Perfumes and Toilet Preparations\n', 'This class includes :\nManufacture of organic surface-active agents\nManufacture of soap\nManufacture of paper, wadding, felt etc., coated or covered with soap or detergent\nManufacture of crude glycerol\nManufacture of surface-active preparations: washing powders in solid or liquid form and detergents, dishwashing preparations and textile softeners\nManufacture of cleaning and polishing products :\npreparations for perfuming or deodorizing rooms\nartificial waxes and prepared waxes\npolishes and creams for leather\npolishes and creams for wood\npolishes for coachwork, glass and metal\nscouring pastes and powders, including paper, wadding etc. coated or covered with these\nManufacture of perfumes and toilet preparations :\nperfumes and toilet water\nbeauty and make-up preparations\nsunburn prevention and suntan preparations\nmanicure and pedicure preparations\nshampoos, hair lacquers, waxing and straightening preparations\ndentifrices and preparations for oral hygiene, including denture fixative preparations\nshaving preparations, including pre-shave and aftershave preparations\ndeodorants and bath salts and depilatories\nThis class excludes :\nManufacture of separate, chemically-defined compounds, see 2011;\nManufacture of glycerol, synthesized from petroleum products, see 2011;\nExtraction and refining of natural essential oils, see 2029.', '202');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2029', 'Manufacture of Other Chemical Products, N.e.c.\n', 'This class includes :\nManufacture of propellant powders\nManufacture of explosives and pyrotechnic products, including percussion caps, detonators, signalling flares, etc.\nManufacture of gelatine and its derivatives, glues and prepared adhesives, including rubber-based glues and adhesives\nManufacture of extracts of natural aromatic products\nManufacture of resinoids\nManufacture of aromatic distilled waters\nManufacture of mixtures of odoriferous products for the manufacture of perfumes or food\nManufacture of photographic plates, films, sensitized paper and other sensitized unexposed materials\nManufacture of chemical preparations for photographic uses\nManufacture of various chemical products :\npeptones, peptone derivatives other protein substances and their derivatives, n.e.c.\nessentials oils\nchemically-modified oils and fats\nmaterials used in the finishing of textiles and leather\npowders and pastes used in soldering, brazing or welding\nsubstances used to pickle metal\nprepared additives for cements\nactivated carbon, lubricating oil additives, prepared rubber accelerators, catalysts and other chemical products for industrial use\nanti-knock preparations, anti-freeze preparations\ncomposite diagnostic or laboratory reagents\nThis class also includes :\nManufacture of writing and drawing ink\nManufacture of matches\nThis class excludes :\nManufacture of chemically defined products in bulk, see 2011;\nManufacture of distilled water, see 2011;\nManufacture of synthetic aromatic products, see 2011;\nManufacture of printing ink, see 2022;\nManufacture of perfumes and toilet preparations, see 2023;\nManufacture of asphalt-based adhesives, see 2399.', '202');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2030', 'Manufacture of Man-made Fibers\n', 'This class includes :\nManufacture of synthetic or artificial filament tow\nManufacture of synthetic or artificial staple fibers, not carded, combined or otherwise processed for spinning\nManufacture of synthetic or artificial filament yarn, including high-tenacity yarn\nManufacture of synthetic or artificial mono-filament or strip\nThis class excludes :\nSpinning of synthetic or artificial fibers, see 1311;\nManufacture of yarns made of man-made staple, see 1311.', '203');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2100', 'Manufacture of Pharmaceuticals, Medicinal Chemical and Botanical Products\n', 'This class includes :\nManufacture of medicinal active substances to be used for their pharmacological properties in the manufacture of medicaments: antibiotics, basic vitamins, salicylic and O-acetylsalicylic acids, etc.\nManufacture of medicaments: antisera and other blood fractions, vaccines and diverse medicaments, including homeopathic preparations\nManufacture of chemical contraceptive products for external use and hormonal contraceptive medicaments\nManufacture of radioactive in-vivo diagnostic substances\nManufacture of biotech pharmaceuticals\nManufacture of medical diagnostic preparations, including pregnancy tests\nManufacture of chemically pure sugars\nProcessing of blood\nProcessing of glands and manufacture of extracts of glands, etc.\nManufacture of medical impregnated wadding, gauze, bandages, dressings, surgical gut string, etc.\nPreparation of botanical products (grinding, grading, milling) for pharmaceutical use\nThis class excludes :\nManufacture of herb infusions (mint, vervain, chamomile etc.), see 1079;\nManufacture of dental fillings, manufacture of dental cement, see 3250;\nManufacture of bone reconstruction cements, see 3250;\nWholesale of pharmaceuticals, see 4649;\nRetail sale of pharmaceuticals, see 4772;\nResearch and development for pharmaceuticals and biotech pharmaceuticals, see 7210;\nPackaging of pharmaceuticals, see 8292.', '210');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2211', 'Manufacture of Rubber Tires and Tubes; Retreading and Rebuilding of Rubber Tires\n', 'This class includes :\nManufacture of rubber tires for vehicles, equipment, mobile machinery, aircraft, toy, furniture and other uses: pneumatic tires and solid or cushion tires\nManufacture of inner tubes for tires\nManufacture of interchangeable tire treads, tire flaps, \"camelback\" strips for retreading tires, etc.\nTire rebuilding and retreading.\nThis class excludes :\nManufacture of tube repair materials, see 2219;\nTire and tube repair, fitting or replacement, see 4520.', '221');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2219', 'Manufacture of Other Rubber Products\n', 'This class includes :\nManufacture of other products of natural or synthetic rubber, unvulcanized, vulcanized or hardened :\nrubber plates, sheets, strips, rods, profile shapes\ntubes, pipes and hoses\nrubber conveyor or transmission belts or belting\nrubber hygienic articles, sheath contraceptives, teats, hot water bottles etc.\nrubber articles of apparel (if only seated together, not sewn)\nrubber thread and rope\nrubberized yarn and fabrics\nrubber rings, fittings and seals\nrubber roller coverings\ninflatable rubber mattresses\ninflatable balloons\nManufacture of rubber brushes\nManufacture of hard rubber pipe stems\nManufacture of hard rubber combs, hair pins, hair rollers, and similar\nThis class also includes :\nManufacture of rubber repair materials\nManufacture of textile fabric impregnated, coated, covered or laminated with rubber, where rubber is the chief constituent\nManufacture of rubber waterbed mattresses\nManufacture of rubber bathing caps and apron\nManufacture of rubber wet suits and diving suits\nThis class excludes :\nManufacture of tire cord fabrics, see 1399;\nManufacture of apparel of elastic fabrics, see 1419;\nManufacture of rubber footwear, see 152;\nManufacture of glues and adhesives based on rubber, see 2029;\nManufacture of \"camelback\" strips, see 2211;\nManufacture of inflatable rafts and boats, see 3011, 3012;\nManufacture of mattresses or uncovered cellular rubber, see 310;\nManufacture of rubber sports requisites, except apparel, see 3230;\nManufacture of rubber games and toys (including childrenNULLs wading pools, inflatable children rubber boats, inflatable rubber animals, balls and the like), see 3240;\nReclaiming of rubber, see 3830.', '221');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2220', 'Manufacture of Plastics Products\n', 'This includes processing of new or spent (i.e. recycled) plastics resins into intermediate or final products, using such processes as compression molding, extrusion molding, injection molding, blow molding and casting. For most of these, the production process is such that a wide variety of products can be made.\nThis class includes :\nManufacture of semi-manufactures of plastic products : plastic plates, sheets, blocks, films, foil, strip etc. (whether self-adhesive or not)\nManufacture of finished plastic products: plastic tubes, pipes and hoses; hose and pipe fittings\nManufacture of plastic articles for the packing of goods: plastic bags, sacks, containers, boxes, cases, carboys, bottles etc.\nManufacture of buildersNULL plastics ware : plastic doors, windows, frames, shutters, blinds, skirting boards; tanks, reservoirs; plastic floor, wall or ceiling coverings in rolls or in the form of tiles, etc; plastic sanitary ware like plastic baths, shower-baths, washbasins, lavatory pans, flushing cisterns etc.\nManufacture of plastic tableware, kitchenware and toilet articles\nManufacture of cellophane film or sheet\nManufacture of resilient floor coverings, such as vinyl, linoleum etc.\nManufacture of artificial stone (e.g. cultured marble)\nManufacture of plastic signs (non-electrical)\nManufacture of diverse plastic products: plastic headgear, insulating fittings, parts of lighting fittings, office or school supplies, articles of apparel (if only sealed together, not sewn), fittings for furniture, statuettes, transmission and conveyer belts, self-adhesive tapes of plastic, plastic wallpaper plastic shoe lasts, plastic cigar and cigarettes holders, combs, plastic hair curlers, plastic novelties, etc.\nThis class excludes :\nManufacture of plastic luggage, see 1512;\nManufacture of plastic footwear, see 152;\nManufacture of plastics in primary forms, see 2013;\nManufacture of articles of synthetic or natural rubber, see 221;\nManufacture of plastic furniture, see 3105;\nManufacture of mattresses of uncovered cellular plastic, see 3109;\nManufacture of plastic sports requisites, see 3230;\nManufacture of plastic games and toys, see 3240;\nManufacture of plastic medical and dental appliances, see 3250;\nManufacture of plastic ophthalmic goods, see 3250;\nManufacture of plastic hard hats and other personal safety equipment of plastic, see 3299;\nManufacture of plastic non-current carrying wiring devices (e.g. junction boxes, face plates etc.), see 2733.', '222');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2310', 'Manufacture of Glass and Glass Products\n', 'This class includes the manufacture of glass in all forms, made by any process and the manufacture of articles of glass.\nThis class includes :\nManufacture of flat glass, including wired, colored or tinted flat glass\nManufacture of toughened or laminated flat glass\nManufacture of glass in rods or tubes\nManufacture of glass paving blocks\nManufacture of glass mirrors\nManufacture of multiple-walled insulating units of glass\nManufacture of bottles and other containers of glass or crystal\nManufacture of drinking glasses and other domestic glass or crystal articles\nManufacture of glass fibers, including glass wool and non-woven products thereof\nManufacture of laboratory, hygienic or pharmaceutical glassware\nManufacture of clock or watch glasses, optical glass and optical elements not optically worked\nManufacture of glassware used in imitation jewelry\nManufacture of glass insulators and glass insulating fittings\nManufacture of glass envelopes for lamps\nManufacture of glass figurines\nThis class excludes :\nManufacture of woven fabrics of glass yarn, see 1312;\nManufacture of optical elements optically worked, see 2670;\nManufacture of fiber optic cable for data transmission or live transmission of images, see 2731;\nManufacture of glass toys, see 3240;\nManufacture of syringes and other medical laboratory equipment, see 3250.', '231');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2391', 'Manufacture of Refractory Products', NULL, '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2392', 'Manufacture of Clay Building Materials', NULL, '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2393', 'Manufacture of Other Porcelain and Ceramic Products\n', 'This class includes :\nManufacture of ceramic tableware and other domestic or toilet articles\nManufacture of statuettes and other ornamental ceramic articles\nManufacture of electrical insulators and insulating fittings of ceramics\nManufacture of ceramic and ferrite magnets\nManufacture of ceramic laboratory, chemical and industrial products\nManufacture of ceramic pots, jars and similar articles of a kind used for conveyance or packing of goods\nManufacture of ceramic furniture\nManufacture of ceramic products, n.e.c.\nThis class excludes:\nManufacture of artificial stone (e.g. cultured marble), see 2220;\nManufacture of refractory ceramic goods, see 2391;\nManufacture of ceramic building materials, see 2392;\nManufacture of ceramic sanitary fixtures, see 2392;\nManufacture of permanent metallic magnets, see 2599;\nManufacture of imitation jewelry, see 3212;\nManufacture of ceramic toys, see 3240;\nManufacture of artificial teeth, see 3250.', '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2394', 'Manufacture of Cement', NULL, '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2395', 'Manufacture of Lime and Plaster\n', 'This class includes :\nManufacture of quicklime, slaked lime and hydraulic lime\nManufacture of plasters of calcined gypsum or calcined sulfate\nManufacture of calcined dolomite', '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2396', 'Manufacture of Articles of Concrete, Cement and Plaster\n', 'This class includes :\nManufacture of precast concrete, cement or artificial stone articles for use in construction: tiles, flagstones, bricks, boards, sheets, panels, pipes, posts, etc.\nManufacture of prefabricated structural components for building or civil engineering of cement, concrete or artificial stone\nManufacture of plaster articles for use in construction: boards, sheets, panels, etc.\nManufacture of building materials of vegetable substances (wood wool, straw, reeds, rushes) agglomerated with cement, plaster or other mineral binder\nManufacture of articles of asbestos-cement or cellulose fiber-cement or the like: corrugated sheets, other sheets, panels, tiles, tubes, pipes, reservoirs, troughs, basins, sinks, jars, furniture, window frames, etc.\nManufacture of other articles of concrete, plaster, cement or artificial stone: statuary, furniture, bas-and haut-reliefs, vases, flowerpots, etc.\nManufacture of powdered mortars\nManufacture of ready-mix and dry-mix concrete and mortars\nThis class excludes manufacture of refractory cements and mortars, see 2391.', '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2397', 'Cutting, Shaping and Finishing of Stone', NULL, '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2399', 'Manufacture of Other Non-metallic Mineral Products, N.e.c.\n', 'This class includes :\nManufacture of millstones, sharpening or polishing stones and natural or artificial abrasive products, including abrasive products on a soft base (e.g. sandpaper)\nManufacture of friction material and unmounted articles thereof with a base of mineral substances or of cellulose\nManufacture of mineral insulating materials: slag wool, rock wool and similar mineral wools; exfoliated vermiculite, expanded clays and similar heat-insulating, sound-insulating or sound absorbing materials\nManufacture of articles of diverse mineral substances: worked mica and articles of mica, of peat, of graphite (other than electrical articles), etc.\nManufacture of articles of asphalt or similar materials, e.g. asphalt-based adhesives, coal tar pitch, etc.\nCarbon and graphite fibers and products (except electrodes and electrical applications)\nThis class excludes:\nManufacture of glass wool and non-woven glass wool products, see 2310;\nManufacture of carbon or graphite gaskets, see 2819.', '239');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2411', 'Operation of Blast Furnaces and Steel Making Furnaces', NULL, '241');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2412', 'Operation of Steel Works and Rolling Mills', NULL, '241');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2421', 'Gold and Other Precious Metal Refining', NULL, '242');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2422', 'Non-ferrous Smelting and Refining , Except Precious Metals', NULL, '242');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2423', 'Non-ferrous Rolling, Drawing and Extrusion Mills', NULL, '242');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2424', 'Manufacture of Pipe Fittings of Non-ferrous Metals', NULL, '242');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2429', 'Manufacture of Basic Precious and Other Non-ferrous Metals, N.e.c.', NULL, '242');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2431', 'Casting of Iron and Steel\n', 'This class includes the casting of iron and steel, i.e. the activities of iron and steel foundries.\nThis class includes :\nCasting of semi-finished iron products\nCasting of grey iron castings\nCasting of spheroidal graphite iron castings\nCasting of malleable cast-iron products\nManufacture of tubes, pipes and hollow profiles and of tube or pipe fittings of cast-iron\nCasting of semi-finished steel products\nCasting of steel castings\nManufacture of seamless tubes and pipes of steel by centrifugal casting\nManufacture of tube or pipe fittings of cast-steel', '243');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2432', 'Casting of Non-ferrous Metals\n', 'This class includes :\nCasting of semi-finished products of aluminum, magnesium, titanium, zinc, etc.\nCasting of light metal castings\nCasting of heavy metal castings\nCasting of precious metal castings\nDie-casting of non-ferrous metal castings', '243');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2511', 'Manufacture of Structural Metal Products\n', 'This class includes :\nManufacture of metal frameworks or skeletons for construction and parts thereof (towers, masts, trusses, bridges, etc)\nManufacture of industrial frameworks in metal (frameworks for blast furnaces, lifting and handling equipment, etc)\nManufacture of prefabricated buildings mainly of metal: site huts, modular exhibition elements, etc.\nManufacture of metal doors, windows and their frames, shutters and gates\nMetal room partitions for floor attachment.\nThis class excludes :\nManufacture of parts for marine or power boilers, see 2513;\nManufacture of assembled railway track fixtures, see 2599;\nManufacture of sections of ships, see 3011.', '251');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2512', 'Manufacture of Tanks, Reservoirs and Containers of Metal', NULL, '251');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2513', 'Manufacture of Steam Generators, Except Central Heating Hot Water Boilers', NULL, '251');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2520', 'Manufacture of Weapons and Ammunition\n', 'This class includes :\nManufacture of heavy weapons (artillery, mobile guns, rocket launchers, torpedo tubes, heavy machine guns)\nManufacture of small arms (revolvers, shotguns, light machine guns)\nManufacture of air or gas guns and pistols\nManufacture of war ammunition\nManufacture of hunting sporting or protective firearms and ammunition\nManufacture of explosive devices such as bombs, mines and torpedoes\nThis class excludes :\nManufacture of percussion caps, detonators or signalling flares, see 2029;\nManufacture of cutlasses, swords, bayonets, etc., see 2593;\nManufacture of armored vehicles for the transport of banknotes or valuables, see 2910;\nManufacture of space vehicles, see 3030;\nManufacture of tanks and other fighting vehicles, see 3040.', '252');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2591', 'Forging, Pressing, Stamping and Roll-forming of Metal; Powder Metallurgy\n', 'This class includes :\nForging, pressing, stamping and roll forming of metal\nPowder metallurgy: production of metal objects directly from metal powders by heat treatment (sintering) or under pressure\nThis class excludes production of metal powder, see 241, 242.', '259');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2592', 'Treatment and Coating of Metals; Machining', NULL, '259');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2593', 'Manufacture of Cutlery, Hand Tools and General Hardware\n', 'This class includes :\nManufacture of domestic cutlery, such as knives, forks, spoons, etc.\nManufacture of other articles of cutlery: cleavers and choppers, razors and razor blades, scissors and hair clippers\nManufacture of knives and cutting blades for machines or for mechanical appliances\nManufacture of hand tools such as pliers, screwdrivers, etc.\nManufacture of non-power-driven agricultural hand tools\nManufacture of saws and saw blades, including circular saw blades and chainsaw blades\nManufacture of interchangeable tools for hand tools, whether or not power-operated, or for machine tools, drills, punches, milling cutters, etc.\nManufacture of press tools\nManufacture of blacksmithsNULL tools: forges, anvils, etc.\nManufacture of molding boxes and molds (except ingot molds)\nManufacture of vices, clamps\nManufacture of padlocks, locks, key, hinges and the like, hardware for buildings, furniture, vehicles, etc.\nManufacture of cutlasses, swords, bayonets, etc.\nThis class excludes :\nManufacture of hollowware (pots, kettles, etc.), dinnerware (bowls, platters, etc.) or flatware (plates, saucers, etc.), see 2599;\nManufacture of power-driven hand tools, see 2818;\nManufacture of ingot molds, see 2823;\nManufacture of cutlery of precious metals, see 3211.', '259');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2599', 'Manufacture of Other Fabricated Metal Products, N.e.c.\n', 'This class includes :\nManufacture of pails, cans, drums, buckets, boxes\nManufacture of tins and cans for food products, collapsible tubes and boxes\nManufacture of metallic closures\nManufacture of metal cable, plaited bands and similar articles\nManufacture of uninsulated, metal cable or insulated cable not capable of being used as a conductor of electricity\nManufacture of articles made of wire, barbed wire, wire fencing, grill, netting, cloth, etc.\nManufacture of nails and pins\nManufacture of rivets, washers and similar non-threaded products\nManufacture of screw machine products\nManufacture of bolts, screws, nuts and similar threaded products\nManufacture of springs (except watch springs) : leaf springs, helical springs, torsion bar springs; leave for springs\nManufacture of chain, except power transmission chain\nManufacture of metal household articles : flatware - plates, saucers, etc.; hollowware - pots, kettles, etc.; dinnerware - bowls, platters, etc.; saucepans, frying pans and other non-electrical utensils for use at the table or in the kitchen; small hand-operated kitchen appliances and accessories; metal scouring pads\nManufacture of baths, sinks, washbasins and similar articles\nManufacture of metal goods for office use, except furniture\nManufacture of safes, strongboxes, armored doors, etc.\nManufacture of various metal articles : ship propellers and blades thereof; anchors; bells; assembled railway track fixtures; clasps, buckles, hooks\nManufacture of foil bags\nManufacture of permanent metallic magnets\nManufacture of metal vacuum jugs and bottles\nManufacture of metal signs (non-electrical)\nManufacture of metal badges and metal military insignia\nManufacture of metal hair curlers, metal umbrella handles and frames, combs\nThis class excludes :\nManufacture of ceramic and ferrite magnets, see 2393;\nManufacture of tanks and reservoirs, see 2512;\nManufacture of swords, bayonets, see 2593;\nManufacture of clock or watch springs, see 2652;\nManufacture of wire and cable for electricity transmission, see 2732;\nManufacture of power transmission chain, see 2814;\nManufacture of shopping carts, see 3099;\nManufacture of metal furniture, see 3106;\nManufacture of sports goods, see 3230;\nManufacture of games and toys, see 3240.', '259');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2611', 'Manufacture of Electronic Valves and Tubes', NULL, '261');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2612', 'Manufacture of Semi-conductor Devices and Other Electronic Components', NULL, '261');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2620', 'Manufacture of Computers and Peripheral Equipment and Accessories', NULL, '262');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2630', 'Manufacture of Communication Equipment', NULL, '263');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2640', 'Manufacture of Consumer Electronics', NULL, '264');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2651', 'Manufacture of Measuring, Testing, Navigating and Control Equipment\n', 'This class includes manufacture of search, detection, navigation, guidance, aeronautical and nautical systems and instruments; automatic controls and regulators for applications, such as heating, air-conditioning, refrigeration and appliances; instruments and devices for measuring, displaying, indicating, recording, transmitting and controlling industrial process variables, such as temperature, humidity, pressure, vacuum, combustion, flow, level, viscosity, density, acidity, concentration and rotation totalizing (i.e. registering) fluid meters and counting devices; instruments for measuring and testing the characteristics of electricity and electrical signals; instruments and instrumentation systems for laboratory analysis of the chemical or physical composition or concentration of samples of solid, fluid, gaseous or composite material and other measuring and testing instruments and parts thereof.\nThe manufacture of non-electric measuring, testing, navigating and control equipment (except simple mechanical tools) is included here.\nThis class includes :\nManufacture of aircraft engine instruments\nManufacture of automotive emissions testing equipment\nManufacture of meteorological instruments\nManufacture of physical properties testing and inspection equipment\nManufacture of polygraph machines\nManufacture of instruments for measuring and testing electricity and electrical signals (including for telecommunications)\nManufacture of radiation detection and monitoring instruments\nManufacture of surveying instruments\nManufacture of electron and proton microscopes\nManufacture of thermometers liquid-in-glass and bimetal types (except medical)\nManufacture of humidistats\nManufacture of hydronic limit controls\nManufacture of flame and burner control\nManufacture of spectrometers\nManufacture of pneumatic gauges\nManufacture of consumption meters (e.g. water, gas)\nManufacture of flow meters and counting devices\nManufacture of tally counters\nManufacture of mine detectors, pulse (signal) generators; metal detectors\nManufacture of search, detection, navigation, aeronautical and nautical equipment, including sonobuoys\nManufacture of radar equipment\nManufacture of GPS devices\nManufacture of environmental controls and automatic controls for appliances\nManufacture of measuring and recording equipment (e.g. flight recorders)\nManufacture of motion detectors\nManufacture of laboratory analytical instruments (e.g. blood analysis equipment)\nManufacture of laboratory scales, balances, incubators, and miscellaneous laboratory apparatus for measuring testing, etc.\nThis class excludes :\nManufacture of telephone answering machines, see 2630;\nManufacture of irradiation equipment, see 2660;\nManufacture of optical measuring and checking devices and instrument (e.g. fire control equipment, photographic light meters, range finders) see 2670;\nManufacture of optical positioning equipment, see 2670;\nManufacture of dictating machines, see 2817;\nManufacture of levels, tape measures and similar hand tools, machinists precision tools, see 2819;\nManufacture of medical thermometers, see 3250;\nInstallation of industrial process control equipment, see 3320.', '265');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2652', 'Manufacture of Watches and Clocks\n', 'This class includes the manufacture of watches, clocks and timing mechanisms and parts thereof.\nThis class includes :\nManufacture of watches and clocks of all kinds, including instrument panel clocks\nManufacture of watch and clock cases, including cases of precious metals\nManufacture of time-recording equipment and equipment for measuring, recording and otherwise displaying intervals of time with a watch or clock movement or with synchronous motor, such as: parking meters, time clocks, time/date stamps, process timers\nManufacture of time switches and other releases with a watch or clock movement or with synchronous motor: time locks\nManufacture of components for clocks and watches: movement of all kinds for watches and clocks, spring, jewels, dials, hands, plates, bridges and other parts\nThis class excludes :\nManufacture of non-metal watch bands (textile, leather, plastic), see 1512;\nManufacture of watch bands of precious metal, see 3211;\nManufacture of watch bands of non-precious metal, see 3212.', '265');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2660', 'Manufacture of Irradiation, Electromedical and Electrotherapeutic Equipment\n', 'This class includes :\nManufacture of irradiation apparatus and tubes (e.g. industrial, medical diagnostic, medical therapeutic, research, scientific) : beta, gamma, X-ray or other radiation equipment\nManufacture of CT scanners\nManufacture of PET scanners\nManufacture of magnetic resonance imaging (MRI) equipment\nManufacture of medical ultrasound equipment\nManufacture of electrocardiographs\nManufacture of electromedical endoscopic equipment\nManufacture of medical laser equipment\nManufacture of pacemakers\nManufacture of hearing aids\nManufacture of food and milk irradiation equipment\nThis class excludes :\nManufacture of laboratory analytical instruments (e.g. blood analysis equipment), see 2651;\nManufacture of tanning beds, see 2790.', '266');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2670', 'Manufacture of Optical Instruments and Photographic Equipment\n', 'This class includes the manufacture of optical instruments and lenses, such as binoculars, microscopes (except electron, proton), telescopes, prisms, and lenses (except ophthalmic)\n coating or polishing lenses (except ophthalmic)\n mounting of lenses (except ophthalmic)\n and the manufacture of photographic equipment such as cameras and light meters.\nThis class includes :\nManufacture of lenses and prisms\nManufacture of optical mirrors\nManufacture of optical gun sighting equipment\nManufacture of optical positioning equipment\nManufacture of optical magnifying instruments\nManufacture of optical machinistNULLs precision tools\nManufacture of optical comparators\nManufacture of film cameras and digital cameras\nManufacture of motion picture and slide projectors\nManufacture of overhead transparency projectors\nManufacture of optical measuring and checking devices and instruments (e.g. fire control equipment, photographic light meters, range finders)\nManufacture of optical microscopes, binoculars and telescopes\nManufacture of laser assemblies\nAlso includes coating, polishing and mounting of lenses.\nThis class excludes :\nManufacture of computer projections, see 2620;\nManufacture of commercial TV and video cameras, see 2630;\nManufacture of household-type video cameras, see 2640;\nManufacture of electron and proton microscopes, see 2651;\nManufacture of complete equipment using laser components, see manufacturing class by type of machinery (e.g. medical laser equipment, see 2660)\n Manufacture of photocopy machinery, see 2817;\nManufacture of ophthalmic goods, see 3250.', '267');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2680', 'Manufacture of Magnetic and Optical Media', NULL, '268');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2711', 'Manufacture of Electric Motors, Generators, Transformers and Electric Generating Sets', NULL, '271');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2712', 'Manufacture of Electricity Distribution and Control Apparatus', NULL, '271');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2720', 'Manufacture of Batteries and Accumulators\n', 'This class includes the manufacture of non-rechargeable and rechargeable batteries.\nThis class includes :\nManufacture of primary cells and primary batteries: cells containing manganese dioxide, mercuric dioxide, silver oxide, etc.\nManufacture of electric accumulators, including parts thereof : separators, containers, covers\nManufacture of lead acid batteries\nManufacture of NiCad batteries\nManufacture of NiMH batteries\nManufacture of lithium batteries\nManufacture of dry cell batteries\nManufacture of wet cell batteries', '272');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2731', 'Manufacture of Fiber Optic Cables', NULL, '273');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2732', 'Manufacture of Other Electronic and Electric Wires and Cables', NULL, '273');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2733', 'Manufacture of Wiring Devices', NULL, '273');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2740', 'Manufacture of Electric Lighting Equipment\n', 'This class includes the manufacture of electric light bulbs and tubes and parts and components thereof (except glass blanks for electric light bulbs), electric lighting fixtures and lighting fixture components (except current-carrying wiring devices).\nThis class includes :\nManufacture of discharge, incandescent, fluorescent, ultra-violet, infra-red etc., lamps, fixtures and bulbs\nManufacture of ceiling lighting fixtures\nManufacture of chandeliers\nManufacture of table lamps (i.e. lighting fixture)\nManufacture of Christmas tree lighting sets\nManufacture of electric fireplace logs\nManufacture of flashlights\nManufacture of electric insect lamps\nManufacture of lanterns (e.g. carbide, electric, gas, gasoline, kerosene)\nManufacture of spotlights\nManufacture of street lighting fixtures (except traffic signals)\nManufacture of lighting equipment for transportation equipment (e.g. for motor vehicles, aircraft, boats)\nThis class also includes manufacture of non-electrical lighting equipment\nThis class excludes :\nManufacture of glassware and glass parts for lighting fixtures, see 2310;\nManufacture of current-carrying wiring devices for lighting fixtures, see 2733;\nManufacture of ceiling fans or bath fans with integrated lighting fixtures, see 2750;\nManufacture of electrical signalling equipment such as traffic lights and pedestrian signalling equipment, see 2790.', '274');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2750', 'Manufacture of Domestic Appliances\n', 'This class includes the manufacture of small electric appliances and electric housewares, household-type fans, vacuum cleaners, electric floor care machines, cooking appliances, laundry equipment, refrigerators, upright and chest freezers and other electrical and non-electrical household appliances, such as dishwashers, water heaters and garbage disposal units. This class includes the manufacture of appliances with electric, gas or other fuel sources.\nThis class includes :\nManufacture of domestic electric appliances :\nrefrigerators, freezers, dishwashers, washing and drying machines, vacuum cleaners, floor polishers, waste disposers, grinders, blenders, juice squeezers, tin openers, electric shavers, electric toothbrushes, and other electric personal care device, knife sharpeners, ventilating or recycling hoods\nManufacture of domestic electrothermic appliances:\nelectric water heaters, electric blankets, electric dryers, combs, brushes, curlers, electric smoothing irons, space heaters and household-type fans, portable, electric oven, microwave ovens, cookers, hotplates, toasters, coffee or tea makers, fry pans, roasters, grills, hoods, electric heating resistors, etc.\nManufacture of domestic non-electric cooking and heating equipment: non-electric space heaters, cooking ranges, grates, stoves, water heaters, cooking appliances, plate warmers.\nThis class excludes :\nManufacture of commercial and industrial refrigerators and freezers, room air-conditioners, attic fans, permanent mount space heaters, and commercial ventilation and exhaust fans, commercial-type, cooking equipment; commercial-type laundry, dry-cleaning and pressing equipment, commercial, industrial and institutional vacuum cleaners, see division 28;\nManufacture of household-type sewing machines, see 2826;\nInstallation of central vacuum cleaning systems, see 4329.', '275');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2790', 'Manufacture of Other Electrical Equipment\n', 'This class includes the manufacture of miscellaneous electrical equipment other than motors, generators and transformers, batteries and accumulators, wires and wiring devices, lighting equipment or domestic appliances.\nThis class includes :\nManufacture of battery chargers, solid-state\nManufacture of door opening and closing devices, electrical\nManufacture of electric bells\nManufacture of ultrasonic cleaning machines (except laboratory and dental)\nManufacture of tanning beds\nManufacture of solid state inverters, rectifying apparatus, fuel cells, regulated and unregulated power supplies\nManufacture of uninterruptible power supplies (UPS)\nManufacture of surge suppressors (except for distribution level voltage)\nManufacture of appliance cords, extension cords, and other electrical cord sets with insulated wire and connectors\nManufacture of carbon and graphite electrodes, contacts, and other electrical carbon and graphite products\nManufacture of particle accelerators\nManufacture of electrical capacitors, resistors, condensers, and similar components\nManufacture of electromagnets\nManufacture of sirens\nManufacture of electronic scoreboards\nManufacture of electrical signs\nManufacture of electrical signalling equipment such as traffic lights and pedestrian signalling equipment\nManufacture of electrical insulators (except glass or porcelain)\nManufacture of electrical welding and soldering equipment, including hand-held soldering irons\nThis class excludes :\nManufacture of non-electrical signs, see class according to material (plastic signs 2220, metal signs 2599)  \nManufacture of porcelain electrical insulators, see 2393;\nManufacture of carbon and graphite fibers and products (except electrodes and electrical applications), see 2399;\nManufacture of electronic component-type rectifiers, voltage regulating integrated circuits, power converting integrated circuits, electronic capacitors, electronic resistors, and similar devices, see 2612;\nManufacture of transformers, motors, generators, switch gear, relays, and industrial controls, see 2712;\nManufacture of batteries, see 2720;\nManufacture of communication and energy wire, current-carrying and non current-carrying wiring devices, see 2733;\nManufacture of lighting equipment, see 2740;\nManufacture of household-type appliances, see 2750;\nManufacture of non-electrical welding and soldering equipment, see 2819;\nManufacture of motor vehicle electrical equipment, such as generators, alternators, spark plugs, ignition wiring harnesses, power window and door systems, voltage regulators, see 2930;\nManufacture of mechanical and electromechanical signalling equipment, safety and traffic control equipment for railways, tramways, inland waterways, roads, parking facilities, airfields, see 3020.', '279');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2811', 'Manufacture of Engines and Turbines, Except Aircraft, Vehicle and Cycle Engines\n', 'This class includes :\nManufacture of internal combustion piston engines, except motor vehicle, aircraft and cycle propulsion engines: marine engines, railway engines\nManufacture of pistons, piston rings, carburetors and such for all internal combustion engines, diesel engines, etc.\nManufacture of inlet and exhaust valves of internal combustion engines\nManufacture of turbines and parts thereof: steam turbines and other vapor turbines, hydraulic turbines, waterwheels and regulators thereof, wind turbines, gas turbines, except turbo jets or turbo propellers for aircraft propulsion\nManufacture of boiler-turbine sets\nManufacture of turbine-generator sets\nThis class excludes :\nManufacture of electric generators (except turbine generator sets), see 2711;\nManufacture of prime mover generator sets (except turbine generator sets), see 2711;\nManufacture of electrical equipment and components of internal combustion engines, see 2790;\nManufacture of motor vehicle, aircraft or cycle propulsion engines, see 2910, 3030, 3091;\nManufacture of turbojets and turbo propellers, see 3030.', '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2812', 'Manufacture of Fluid Power Equipment', NULL, '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2813', 'Manufacture of Other Pumps, Compressors, Taps and Valves\n', 'This class includes :\nManufacture of air or vacuum pumps, air or other gas compressors\nManufacture of pumps for liquid whether or not fitted with a measuring device\nManufacture of pumps designed for fitting to internal combustion engines: oil, water and fuel pumps for motor vehicles, etc.\nThis class also includes :\nManufacture of industrial taps and valves, including regulating valves and intake taps\nManufacture of sanitary taps and valves\nManufacture of heating taps and valves\nManufacture of hand pumps.\nThis class excludes :\nManufacture of valves of unhardened vulcanized rubber, glass or of ceramic materials, see 2219, 2310 or 2393.\nManufacture of hydraulic transmission equipment, see 2812;\nManufacture of inlet and exhaust of internal combustion engines, see 2811.', '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2814', 'Manufacture of Bearings, Gears and Driving Elements', NULL, '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2815', 'Manufacture of Ovens, Furnaces and Furnace Burners', NULL, '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2816', 'Manufacture of Lifting and Handling Equipment\n', 'This class includes :\nManufacture of hand-operated or power-driven lifting, handling, loading or unloading machinery :\npulley tackle and hoists, winches, capstans and jacks\nderricks, cranes, mobile lifting frames, straddle carriers etc.\nworks trucks, whether or not fitted with lifting or handling equipment, whether or not self-propelled, of the type used in factories (including hand trucks and wheelbarrows)\nmechanical manipulators and industrial robots specifically designed for lifting, handling, loading or unloading\nManufacture of conveyors, telfers, etc.\nManufacture of lifts, escalators and moving walkways\nManufacture of parts specialized for lifting and handling equipment\nThis class excludes :\nManufacture of continuous-action elevators and conveyors for underground use, see 2824;\nManufacture of mechanical shovels, excavators and shovel loaders, see 2824;\nManufacture of industrial robots for multiple uses, see 2829;\nManufacture of crane-lorries, floating cranes, railway cranes, see 2910,3011,3020;\nInstallation of lifts and elevators, see 4329.', '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2817', 'Manufacture of Office Machinery and Equipment (Except Computers and Peripheral Equipment)\n', 'This class includes :\nManufacture of calculating machines\nManufacture of adding machines, cash registers\nManufacture of calculators, electronic or not\nManufacture of postage meters, mail handling machines (envelope stuffing, sealing and addressing machinery; opening, sorting, scanning), collating machinery\nManufacture of typewriters\nManufacture of stenography machines\nManufacture of office-type binding equipment (I.e. plastic or tape binding)\nManufacture of cheque writing machines\nManufacture of coin counting and coin wrapping machinery\nManufacture of pencil sharpeners\nManufacture of staplers and staple removers\nManufacture of voting machines\nManufacture of tape dispensers\nManufacture of hole punches\nManufacture of cash registers, mechanically operated\nManufacture of photocopy machines\nManufacture of toner cartridges\nManufacture of blackboards, white boards and marker boards\nManufacture of dictating machines\nThis class excludes manufacture of computers and peripheral equipment, see 2620.', '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2818', 'Manufacture of Power-driven Hand Tools', NULL, '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2819', 'Manufacture of Other General-purpose Machinery\n', 'This class includes :\nManufacture of industrial refrigerating or freezing equipment, including assemblies of major components\nManufacture of air-conditioning machines, including for motor vehicles\nManufacture of non-domestic fans\nManufacture of weighing machinery (other than sensitive laboratory balances): household and shop scales, platform scales, scales for continuous weighing, weighbridges, weights, etc.\nManufacture of filtering or purifying machinery and apparatus for liquids\nManufacture of equipment for projecting, dispersing or spraying liquids or powders: spray guns, fire extinguishers, sandblasting machines, steam cleaning machines, etc.\nManufacture of packing and wrapping machinery: filling, closing, sealing, capsulling or labeling machines, etc.\nManufacture of machinery for cleaning or drying bottles and for aerating beverages\nManufacture of distilling or rectifying plant for petroleum refineries, chemical industries, beverage industries, etc.\nManufacture of heat exchangers\nManufacture of machinery for liquefying air or gas\nManufacture of gas generators\nManufacture of calendering or other rolling machines and cylinders thereof (except for metal and glass)\nManufacture of centrifuges (except cream separators and clothes dryers)\nManufacture of gaskets and similar joints made of a combination of materials or layers of the same material\nManufacture of automatic goods vending machines\nManufacture of parts for general-purpose machinery\nManufacture of attic ventilation fans (gable fans, roof ventilators, etc.)\nManufacture of levels, tape measures and similar hand tools, machinistsNULL precision tools (except optical)\nManufacture of non-electrical welding and soldering equipment\nThis class excludes :\nManufacture of sensitive (laboratory-type) balances, see 2651;\nManufacture of domestic refrigerating or freezing equipment, see 2750;\nManufacture of domestic fans, see 2750;\nManufacture of electrical welding and soldering equipment, see 2790;\nManufacture of agricultural spraying machinery, see 2821;\nManufacture of metal or glass rolling machinery and cylinders thereof, see 2823, 2829;\nManufacture of agricultural dryers, machinery for filtering or purifying food and cream separators see 2825;\nManufacture of commercial clothes dryers and textile printing machinery see 2826.', '281');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2821', 'Manufacture of Agricultural and Forestry Machinery\n', 'This class includes :\nManufacture of tractors used in agriculture and forestry\nManufacture of walking (pedestrian-controlled) tractors\nManufacture of mowers, including lawnmowers\nManufacture of agricultural self-loading or self-unloading trailers or semi-trailers\nManufacture of agricultural machinery for soil preparation, planning or fertilizing: ploughs, manure spreaders, seeders, harrows, etc.\nManufacture of harvesting or threshing machinery: harvesters, threshers, sorters, etc.\nManufacture of milking machines\nManufacture of spraying machinery for agricultural use\nManufacture of diverse agricultural machinery: poultry-keeping machinery, bee-keeping machinery, equipment for preparing fodder, etc.; machines for cleaning, sorting or grading eggs, fruits, etc.\nThis class excludes :\nManufacture of non-power-driven agricultural hand tools, see 2593;\nManufacture of conveyors for farm use, see 2816;\nManufacture of power-driven hand tools, see 2818;\nManufacture of cream separators, see 2825;\nManufacture of machinery to clean, sort or grade seed, grain or dried leguminous vegetables, see 2825;\nManufacture of road tractors for semi-trailers, see 2910;\nManufacture of road trailers or semi-trailers, see 2920.', '282');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2822', 'Manufacture of Metal-forming Machinery and Machine Tools\n', 'This class includes :\nManufacture of machine tools for working metals and other materials (wood, bone, stone, hard rubber, hard plastic, cold glass, etc.), including those using a laser beam, ultrasonic waves, plasma arc, magnetic pulse etc.\nManufacture of machine tools for turning, drilling, milling, shaping, planning, boring, grinding, etc.\nManufacture of stamping or pressing machine tools\nManufacture of punch presses, hydraulic presses, hydraulic brakes, drop hammers, forging machines, etc.\nManufacture of draw-benches, thread rollers or machines for working wires\nManufacture of stationary machines for nailing, stapling, glueing or otherwise assembling wood, cork, bone, hard rubber or plastics, etc.\nManufacture of stationary rotary or rotary percussions drills, filing machines, riveters, sheet metal cutters etc.\nManufacture of presses for the manufacture of particle board and the like\nManufacture of electroplating machinery\nThis class also includes the manufacture of parts and accessories for the machine tools listed above: work holders, dividing heads and other special attachments for machine tools\nThis class excludes :\nManufacture of interchangeable tools for hand tools or machine tools (drills, punches, dies, taps, milling cutters, turning tools, saw blades, cutting knives, etc., see 2593;\nManufacture of electric hand-held soldering irons and soldering guns, see 2790;\nManufacture of power-driven hand tools, see 2818;\nManufacture of machinery used in metal mills or foundries, see 2823;\nManufacture of machinery for mining and quarrying, see 2824.', '282');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2823', 'Manufacture of Machinery for Metallurgy', NULL, '282');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2824', 'Manufacture of Machinery for Mining, Quarrying and Construction\n', 'This class includes :\nManufacture of continuous-action elevators and conveyors for underground use\nManufacture of boring, cutting, sinking and tunneling machinery (whether or not for underground use)\nManufacture of machinery for treating minerals by screening, sorting, separation, washing, crushing, etc.\nManufacture of concrete and mortar mixers\nManufacture of earth-moving machinery: bulldozers, angle-dozers, graders, scrapers, levelers, mechanical shovels, shovel loaders, etc.\nManufacture of pile drivers and pile-extractors, mortar spreaders, bitumen spreaders, concrete surfacing machinery, etc.\nManufacture of tracklaying tractors and tractors used in construction or mining\nManufacture of bulldozers and angle-dozer blades\nManufacture of off-road dumping trucks\nThis class excludes :\nManufacture of lifting and handling equipment, see 2816;\nManufacture of other tractors, see 2821, 2910;\nManufacture of machine tools for working stone, including machines for splitting or clearing stone, see 2822;\nManufacture of concrete-mixer lorries, see 2910;\nManufacture of mining locomotives and mining rail cars, see 3020.', '282');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2825', 'Manufacture of Machinery for Food Beverage and Tobacco Processing\n', 'This class includes :\nManufacture of agricultural dryers\nManufacture of machinery for the dairy industry :\ncream separators\nmilk processing machinery (e.g. homogenizers)\nmilk converting machinery (e.g. butter chums, butter workers and molding machines)\ncheese-making machines (e.g. homogenizers, molders, presses) etc.\nManufacture of machinery for the grain milling industry :\nmachinery to clean, sort or grade seeds, grain or dried leguminous vegetables (winnowers, sieving belts, separators, grain brushing machines, etc.)\nmachinery to produce flour and meal etc. (grinding mills, feeders, sifters, bran cleaners, blenders, rice hullers, pea splitters)\nManufacture of presses, crushers, etc. used to make wine, cider, fruit juices, etc.\nManufacture of machinery for the bakery industry or for making macaroni, spaghetti or similar products : bakery ovens, dough mixers, dough-dividers, molders, slicers, cake depositing machines, etc.\nManufacture of machines and equipment to process diverse foods :\nmachinery to make confectionary, cocoa or chocolate; to manufacture sugar; for breweries; to process meat or poultry, to prepare fruit, nuts or vegetables; to prepare fish, shellfish or other seafood\nmachinery for filtering and purifying\nother machinery for the industrial preparation or manufacture of food or drink\nManufacture of machinery for the extraction or preparation of animal or vegetable fats or oils\nManufacture of machinery for the preparation of tobacco and for the making of cigarettes or cigars, or pipe or chewing tobacco or snuff\nManufacture of machinery for the preparation of food in hotels and restaurants.\nThis class excludes :\nManufacture of food and milk irradiation equipment, see 2660;\nManufacture of packing, wrapping and weighing machinery, see 2819;\nManufacture of cleaning, sorting or grading machinery for eggs, fruit or other crops (except seeds, grains and dried leguminous vegetables), see 2821.', '282');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2826', 'Manufacture of Machinery for Textile, Apparel and Leather Production\n', 'This class includes :\nManufacture of textile machinery :\nmachines for preparing, producing, extruding, drawing, texturizing or cutting man-made textile fibers, materials or yarns\nmachines for preparing textile fibers: cotton gins, bale breakers, garnetters, cotton spreaders, wool scourers, wool carbonizers, combs, carders, roving frames, etc.\nspinning machines\nmachines for preparing textile yarns: reelers; warpers and related machines\nweaving machines (looms), including hand looms\nknitting machines\nmachines for making knotted net, tulle, lace, braid, etc.\nManufacture of auxiliary machines or equipment for textile machinery: dobbies, jacquards, automatic stop motions, shuttle changing mechanisms, spindles and spindle flyers, etc.\nManufacture of textile printing machines\nManufacture of machinery for fabric processing :\nmachinery for washing, bleaching, dyeing, dressing, finishing, coating or impregnating textile fabrics\nmanufacture of machines for reeling, unreeling, folding, cutting or pinking textile fabrics;\nManufacture of laundry machinery :\nironing machines, including fusing presses\ncommercial washing and drying machines\ndry-cleaning machines\nManufacture of sewing machines, sewing machine heads and sewing machine needles (whether or not for household use)\nManufacture of machines for producing or finishing felt or non-wovens\nManufacture of leather machines :\nmachinery for preparing, tanning or working hides, skins or leather\nmachinery for making or repairing footwear or other articles of hides, skins, leather or fur skins\nThis class excludes :\nManufacture of paper or paperboard cards for use on jacquard machines, see 1709;\nManufacture of domestic washing and drying machines, see 2750;\nManufacture of calendering machines, see 2819;\nManufacture of machines used in bookbinding, see 2829.', '282');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2829', 'Manufacture of Other Special-purpose Machinery\n', 'This class includes the manufacture of special-purpose machinery not elsewhere classified.\nThis class includes :\nManufacture of machinery for making paper pulp\nManufacture of paper and paperboard making machinery\nManufacture of dryers for wood, paper pulp, paper or paperboard\nManufacture of machinery producing articles of paper and paperboard\nManufacture of machinery for working soft rubber or plastics or for the manufacture of products of these materials: extruders, molders, pneumatic tire making or retreading machines and other machines for making a specific rubber or plastic product\nManufacture of printing and bookbinding machines and machines for activities supporting printing on a variety of materials\nManufacture of machinery for producing tiles, bricks, shaped ceramic pastes, pipes, graphite electrodes, blackboard chalk, foundry molds, etc.\nManufacture of semi-conductor manufacturing machinery\nManufacture of industrial robots performing multiple tasks for special purposes\nManufacture of diverse special machinery and equipment :\nmachines to assemble electric or electronic lamps, tubes (valves) or bulbs\nmachines for production or hot-working of glass or glassware, glass fiber or yarn\nmachinery or apparatus for isotopic separation\nManufacture of tire alignment and balancing equipment; balancing equipment (except wheel balancing)\nManufacture of central greasing systems\nManufacture of aircraft launching gear, aircraft carrier catapults and related equipment\nManufacture of automatic bowling alley equipment (e.g. pin-setters)\nManufacture of roundabouts, swings, shooting galleries and other fairground amusements\nThis class excludes :\nManufacture of household appliances, see 2750;\nManufacture of photocopy machines, etc., see 2817;\nManufacture of machinery or equipment to work hard rubber, hard plastics or cold glass, see 2822;\nManufacture of ingot molds, see 2823;\nManufacture of textile printing machinery, see 2826.', '282');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2910', 'Manufacture of Motor Vehicles', NULL, '291');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2920', 'Manufacture of Bodies (Coachwork) for Motor Vehicles; Manufacture of Trailers and Semi-trailers\n', 'This class includes :\nManufacture of bodies, including cabs of motor vehicles\nOutfitting of all types of motor vehicles, trailers and semi-trailers\nManufacture of trailers and semi-trailers :\nfor transport of goods : tankers, removal trailers, etc.\nfor transport of passengers: caravan trailers, etc.\nManufacture of containers for carriage by one or more modes of transport\nThis class excludes :\nManufacture of trailers and semi-trailers specially designed for use in agriculture, see 2821;\nManufacture of parts and accessories of bodies for motor vehicles, see 2930;\nManufacture of vehicles drawn by animals, see 3099.', '292');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('2930', 'Manufacture of Parts and Accessories for Motor Vehicles\n', 'This class includes :\nManufacture of diverse parts and accessories for motor vehicles : brakes, gearboxes, axles, road wheels, suspension shock absorbers, radiators, silencers, exhaust pipes, catalytic converters, clutches, steering wheels, steering columns and steering boxes\nManufacture of parts and accessories of bodies for motor vehicles : safety belts, airbags, doors, bumpers\nManufacture of car seats\nManufacture of motor vehicle electrical equipment, such as generators, alternators, spark plugs, ignition, wiring harnesses, power window and door systems, assembly of purchased gauges into instrument panels, voltage regulators, etc.\nThis class excludes :\nManufacture of tires, see 2211;\nManufacture of rubber hoses and belts and other rubber products, see 2219;\nManufacture of plastic hoses and belts and other plastic products, see 2220;\nManufacture of batteries for vehicles, see 2720;\nManufacture of lighting equipment for motor vehicles, see 2740;\nManufacture of pistons, piston rings and carburetors, see 2811;\nManufacture of pumps for motor vehicles and engines, see 2813;\nManufacture, repair and alteration of motor vehicles, see 4520.', '293');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3011', 'Building of Ships and Floating Structures\n', 'This class includes the building of ships, except vessels for sports or recreation and construction of floating structures.\nThis class includes:\nBuilding of commercial vessels: passenger vessels, ferry-boats, cargo ships, tankers, tugs etc.\nBuilding of warships\nBuilding of fishing boats and fish-processing factory vessel\nThis class also includes :\nBuilding of hovercraft (except recreation-type hovercraft)\nConstruction of drilling platforms, floating or submersible\nConstruction of floating structures: floating docks, pontoons, coffer-dams, floating landing stages, buoys, floating tanks, barges, lighters, floating cranes, non-recreational inflatable rafts, etc.\nManufacture of sections for ships and floating structures\nThis class excludes :\nManufacture of parts of vessels, other than major hull assemblies: manufacture of sails, see 1392; manufacture of iron or steel anchors, see 2599; manufacture of marine engines, see 2811;\nManufacture of navigational instruments, see 2651;\nManufacture of lighting equipment for ships, see 2740;\nManufacture of amphibious motor vehicles, see 2910;\nManufacture of inflatable boats or rafts for recreation, see 3012;\nSpecialized repair and maintenance of ships and floating structures, see 3315;\nShip-breaking, see 3830;\nInterior installation of boats, see 4330.', '301');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3012', 'Building of Pleasure and Sporting Boats\n', 'This class includes :\nManufacture of inflatable boats and raft\nBuilding of sailboats with or without auxiliary motor\nBuilding of motor boats\nBuilding of recreation-type hovercraft\nManufacture of personal watercraft\nManufacture of other pleasure and sporting boats: canoes, kayaks, rowing boats, skiffs\nThis class excludes :\nManufacture of parts of pleasure and sporting boats: manufacture of sails, see 1392; manufacture of iron or steel anchors, see 2599; manufacture of marine engines, see 2811;\nManufacture of sailboards and surfboards, see 3230;\nMaintenance, repair or alteration of pleasure boats, see 3315.', '301');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3020', 'Manufacture of Railway Locomotive and Rolling Stock\n', 'This class includes :\nManufacture of electric, diesel, steam and other rail locomotives\nManufacture of self-propelled railway or tramway coaches, vans and trucks, maintenance or service vehicles\nManufacture of railway or tramway rolling stock, not self-propelled: passenger coaches, goods vans, tank wagons, self-discharging vans and wagons, workshop vans, crane vans, tenders, etc.\nManufacture of specialized parts or railway or tramway locomotives or of rolling stock : bogies, axles and wheels, brakes and parts of brakes; hooks and coupling devices, buffers and buffer parts; shock absorbers; wagon and locomotive frames; bodies; corridor connections, etc.\nThis class also includes :\nManufacture of mechanical and electromechanical signalling, safety and traffic control equipment for railways, tramways, inland waterways, roads, parking facilities, airfields, etc.\nManufacture of mining locomotives and mining rail cars\nManufacture of railway car seats\nThis class excludes :\nManufacture of unassembled rails, see 241;\nManufacture of assembled railway track fixtures, see 2599;\nManufacture of electric motors, see 2711;\nManufacture of electrical signalling, safety or traffic-control equipment, see 2790;\nManufacture of engines and turbines, see 2811.', '302');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3030', 'Manufacture of Air and Spacecraft and Related Machinery\n', 'This class includes :\nManufacture of airplanes for the transport of goods or passengers, for use by the defense forces, for sport or other purposes\nManufacture of helicopters\nManufacture of gliders, hang gliders\nManufacture of dirigibles and hot air balloons\nManufacture of unmanned aerial vehicles (UAV)\nManufacture of parts and accessories of the aircraft of this class :\nmajor assemblies such as fuselages, wings, doors, control surfaces, landing gear, fuel tanks, nacelles, etc.\nairscrews, helicopter rotors and propelled rotor blades\nmotors and engines of a kind typically found on aircraft\nparts of turbojets and turbo propellers for aircraft\nManufacture of ground flying trainers\nManufacture of spacecraft and launch vehicles, satellites, planetary probes, orbital, shuttles\nManufacture of intercontinental ballistic (ICBM), and similar missiles\nThis class also includes overhaul and conversion of aircraft or aircraft engines.\nThis class excludes :\nManufacture of parachutes, see 1392;\nManufacture of military ordinance and ammunitions, see 2520;\nManufacture of telecommunication equipment for satellites, see 2630;\nManufacture of aircraft instrumentation and aeronautical instruments, see 2651;\nManufacture of air navigation systems, see 2651;\nManufacture of lighting equipment for aircraft, see 2740;\nManufacture of ignition parts and other electrical parts for internal combustion engines, see 2790;\nManufacture of pistons, piston rings and carburetors, see 2811;\nManufacture of aircraft launching gear, aircraft carrier catapults and related equipment, see 2829.', '303');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3040', 'Manufacture of Military Fighting Vehicles', NULL, '304');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3091', 'Manufacture of Motorcycles\n', 'This class includes :\nManufacture of motorcycles, mopeds and cycles fitted with an auxiliary engine\nManufacture of engines for motorcycles\nManufacture of sidecars\nManufacture of parts and accessories for motorcycles\nThis class excludes manufacture of bicycles and invalid carriages see 3092.', '309');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3092', 'Manufacture of Bicycles and Invalid Carriages\n', 'This class includes :\nManufacture of non-motorized bicycles and other cycles, including (delivery) tricycles, tandems, childrenNULLs bicycles and tricycles\nManufacture of parts and accessories of bicycles\nManufacture of invalid carriages with or without motor\nManufacture of parts and accessories of invalid carriages\nManufacture of baby carriages\nThis class excludes :\nManufacture of bicycles with auxiliary motor, see 3091;\nManufacture of wheeled toys designed to be ridden, including plastic bicycles and tricycles, see 3240.', '309');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3099', 'Manufacture of Other Transport Equipment, N.e.c\n', 'This class includes :\nManufacture of hand-propelled vehicles : luggage trucks, handcarts, sledges, shopping carts, etc.\nManufacture of vehicles drawn by animals, sulkies, donkey-carts, hearses etc.\nThis class excludes :\nWorks trucks, whether or not fitted with lifting or handling equipment, whether or not self-propelled, of the type used in factories (including hand trucks and wheelbarrows), see 2816;\nDecorative restaurants carts, such as a dessert cart, food wagons, see 3109.', '309');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3101', 'Manufacture of Wood Furniture', NULL, '310');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3102', 'Manufacture of Rattan Furniture (Reed, Wicker, and Cane)', NULL, '310');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3103', 'Manufacture of Box Beds and Mattresses', NULL, '310');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3104', 'Manufacture of Partitions, Shelves, Lockers and Office and Store Fixtures', NULL, '310');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3105', 'Manufacture of Plastic Furniture', NULL, '310');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3106', 'Manufacture of Furniture and Fixtures of Metal', NULL, '310');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3109', 'Manufacture of Other Furniture and Fixtures, N.e.c.', NULL, '310');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3211', 'Manufacture of Jewelry and Related Articles\n', 'This class includes :\nProduction of worked pearls\nProduction of precious and semi-precious stones in the worked state, including the working of industrial quality stones and synthetic or reconstructed precious or semi-precious stone\nWorking of diamonds\nManufacture of jewelry of precious metal or of base metals clad with precious metals or precious or semi-precious stones or of combinations of precious metal or semi-precious stones or of other materials\nManufacture of goldsmithNULLs articles or precious metals or of base metals clad with precious metals : dinnerware, flatware, hollowware, toilet articles, office or desk articles, articles for religious use, etc.\nManufacture of technical or laboratory articles of precious metal (except instruments and parts thereof) crucible, spatulas, electroplating anodes, etc.\nManufacture of precious metal watch bands, wristbands, watch straps and cigarette cases\nManufacture of coins, including coins for use as legal tender, whether or not of precious metal\nThis class also includes engraving of personal precious and non-precious metal products.\nThis class excludes :\nManufacture of non-metal watch bands (fabric, leather, plastic etc.), see 1512;\nManufacture of articles of base metal plated with precious metal (except imitation jewelry), see division 25;\nManufacture of watchcases, see 2652;\nManufacture of (non-precious) metal watch bands, see 3212;\nManufacture of imitation jewelry, see 3212.', '321');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3212', 'Manufacture of Imitation of Jewelry and Related Articles', NULL, '321');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3220', 'Manufacture of Musical Instruments\n', 'This class includes :\nManufacture of string instruments\nManufacture of keyboard string instruments, including automatic pianos\nManufacture of keyboard pipe organs, including harmoniums and similar keyboard instruments with free metal reeds\nManufacture of accordions and similar instruments, including mouth organs\nManufacture of wind instruments; manufacture of percussions musical instruments\nManufacture of musical instruments, the sound of which is produced electronically\nManufacture of musical boxes, fairground organs calliopes, etc.\nManufacture of instrument parts and accessories : metronomes, tuning forks, pitch pipes, cards, discs and rolls for automatic mechanical instruments, etc.\nThis class also includes manufacture of whistles, call horns and other mouth-blown sound signalling instruments\nThis class excludes :\nReproduction of pre-recorded sound and video tapes and discs, see 1820;\nManufacture of microphones, amplifiers, loudspeakers, headphones and similar components, see 2640;\nManufacture of record players, tape recorders and the like, see 2640;\nManufacture of toy musical instruments, see 3240;\nRestoring of organs and other historic musical instruments, see 3319;\nPublishing of pre-recorded sound and video tapes and discs, see 5920;\nPiano tuning, see 9529.', '322');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3230', 'Manufacture of Sports Goods\n', 'This class includes the manufacture of sporting and athletic goods (except apparel and footwear).\nThis class includes :\nManufacture of articles and equipment for sports, outdoor and indoor games, of any material :\nhard, soft and inflatable balls\nrackets, bats and clubs\nskis, bindings and poles;\nski-boots; sailboards and surfboards\nrequisites for sport fishing, including land nets\nrequisites for hunting, mountain climbing, etc.\nleather sports, gloves and sports headgear; ice skates, roller skates, etc.\nbows and crossbows; gymnasium, fitness center or athletic equipment\nThis class excludes :\nManufacture of boat sails, see 1392;\nManufacture of sports apparel, see 1419;\nManufacture of saddlery and harness, see 1512;\nManufacture of whips and riding crops, see 1512;\nManufacture of sports footwear, see 1529;\nManufacturing of sporting weapons and ammunitions, see 2520;\nManufacture of metal weights as used for weightlifting, see 2599;\nManufacture of automatic bowling alley equipment (e.g. pin-setters), see 2829;\nManufacture of sports vehicles other than toboggans and the like, see divisions 29 and 30;\nManufacture of boats, see 3012;\nManufacture of billiard tables, see 3240;\nManufacture of ear and noise plugs (e.g. for swimming and noise protection), see 3299.', '323');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3240', 'Manufacture of Games and Toys\n', 'This class includes the manufacture of dolls, toys and games (including electronic games), scale models and childrenNULLs vehicles (except metal bicycles and tricycles).\nThis class includes :\nManufacture of dolls and doll garments, parts and accessories\nManufacture of action figures\nManufacture of toy animals\nManufacture of toy musical instruments\nManufacture of playing cards\nManufacture of board games and similar games\nManufacture of electronic games, chess, etc.\nManufacture of reduced-size (\"scale\") models and similar recreational models, electrical trains, construction sets, etc.\nManufacture of coin-operated games, billiards, special tables for casino games, etc.\nManufacture of articles for funfair, table or parlor games\nManufacture of wheeled toys designed to be ridden, including plastic bicycles and tricycles\nManufacture of puzzles and similar articles\nThis class excludes :\nManufacture of video game consoles, see 2640;\nManufacture of bicycles, see 3092;\nWriting and publishing of software for video games consoler, see 5820, 6201.', '324');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3250', 'Manufacture of Medical and Dental Instruments and Supplies\n', 'This class includes the manufacture of laboratory apparatus, surgical and medical instruments, surgical appliances and supplies, dental equipment and supplies, orthodontic goods, dentures and orthodontic appliances. Included is the manufacture of medical, dental and similar furniture where the additional specific functions determines the purpose of the product, such as dentistNULLs chairs with built-in hydraulic functions.\nThis class includes :\nManufacture of surgical drapes and sterile string and tissue\nManufacture of dental fillings and cements (except denture adhesive dental wax) and other dental plaster preparations\nManufacture of bone reconstruction cements\nManufacture of dental laboratory furnaces\nManufacture of laboratory ultrasonic cleaning machinery\nManufacture of laboratory sterilizers\nManufacture of laboratory type distilling apparatus, laboratory centrifuges\nManufacture of medical, surgical , dental or veterinary furniture, such as :\noperating tables\nexamination tables\nhospital beds with mechanical fittings\ndentistNULLs chairs\nManufacture of bone plates and screws, syringes, needles, catheters, cannulae, etc.\nManufacture of dental instruments (including dentistNULLs chairs incorporating dental equipment)\nManufacture of artificial teeth, bridges, etc. made in dental labs\nManufacture of orthopedic and prosthetic devices\nManufacture of glass eyes\nManufacture of medical thermometers\nManufacture of ophthalmic goods, eyeglasses, sunglasses, lenses ground to prescription, contact lenses, safety goggles\nThis class excludes :\nManufacture of denture adhesives, see 2023;\nManufacture of medical impregnated wadding, dressings, etc. see 2100;\nManufacture of electromedical and electrotherapeutic equipment, see 2660;\nManufacture of wheelchairs, see 3092.', '325');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3291', 'Manufacture of Pens and Pencils of All Kinds', NULL, '329');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3292', 'Manufacture of Umbrellas, Walking Sticks, Canes, Whips and Riding Crops', NULL, '329');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3293', 'Manufacture of Articles for Personal Use, E.g. Smoking Pipes, Combs, Slides and Similar Articles', NULL, '329');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3294', 'Manufacture of Candles', NULL, '329');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3295', 'Manufacture of Artificial Flowers, Fruits and Foliage', NULL, '329');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3296', 'Manufacture of Burial Coffin', NULL, '329');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3299', 'Manufacture of Other Miscellaneous Articles, N.e.c.', NULL, '329');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3311', 'Repair of Fabricated Metal Products', NULL, '331');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3312', 'Repair of Machinery', NULL, '331');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3313', 'Repair of Electronic and Optical Equipment', NULL, '331');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3314', 'Repair of Electrical Equipment', NULL, '331');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3315', 'Repair of Transport Equipment, Except Motor Vehicles\n', 'This class includes the repair and maintenance of transport equipment of division 30, except motorcycles and bicycles. However, the factory rebuilding or overhaul of ships, locomotives, railroad cars and aircraft is classified in division 30.\nThis class includes :\nRepair and maintenance of ships\nRepair and maintenance of pleasure boats\nRepair and maintenance of locomotives and railroad cars (except factory rebuilding or factory conversion)\nRepair and maintenance of aircraft (except factory conversion, factory overhaul, factory rebuilding)\nRepair and maintenance of aircraft engines\nRepair and maintenance of drawn buggies and wagons\nThis class excludes :\nFactory rebuilding of ships, see 301;\nFactory rebuilding of locomotives and railroad cars, see 3020;\nFactory rebuilding of aircraft, see 3030;\nRepair of ship or rail engines, see 3312;\nShip scaling and dismantling, see 3830;\nRepair and maintenance of motorcycles, see 4540;\nRepair of bicycles and invalid carriages, see 9529.', '331');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3319', 'Repair of Other Equipment', NULL, '331');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3320', 'Installation of Industrial Machinery and Equipment', NULL, '332');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3510', 'Electric Power Generation, Transmission and Distribution\n', 'This includes the generation of bulk electric power, transmission and distribution to end users.\nThis class includes :\nOperation of generation facilities that produce electric energy, including thermal, nuclear, hydroelectric, gas turbine, diesel and renewable\nOperation of transmission systems that convey the electricity from the generation facility to the distribution system\nOperation of distribution systems (i.e. consisting of lines, poles, meters, and wiring) that convey electric power received from the generation facility or the transmission system to the final consumer\nSale of electricity to the user\nActivities of electric power brokers or agents that arrange the sale of electricity via power distribution systems operated by others\nOperation of electricity and transmission capacity exchanges for electric power\nThis class excludes production of electricity through incineration of waste, see 3821', '351');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3520', 'Manufacture of Gas; Distribution of Gaseous Fuels Through Mains', NULL, '352');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3530', 'Steam, Air Conditioning Supply and Production of Ice', NULL, '353');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3600', 'Water Collection, Treatment and Supply', NULL, '360');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3700', 'Sewerage', NULL, '370');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3811', 'Collection of Non-hazardous Waste', NULL, '381');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3812', 'Collection of Hazardous Waste', NULL, '381');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3821', 'Treatment and Disposal of Non-hazardous Waste', NULL, '382');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3822', 'Treatment and Disposal of Hazardous Waste', NULL, '382');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3830', 'Materials Recovery', NULL, '383');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('3900', 'Remediation Activities and Other Waste Management Services', NULL, '390');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4100', 'Construction of Buildings\n', 'This class includes the construction of complete residential or non-residential buildings, on own account for sale or on a fee or contract basis. Outsourcing parts or even the whole construction process is possible. If only specialized parts of the construction process are carried out, the activity is classified in division 43.\nThis class includes :\nConstruction of all types of residential buildings: single-family houses; multi-family buildings, mass housing, including high-rise buildings\nConstruction of all types of non-residential buildings:\nbuildings for industrial production, e.g. factories, workshops, assembly plants, etc.\nhospitals, schools, office buildings\nhotels, stores, shopping malls, restaurants\nairport buildings\nindoor sports facilities\nparking garages, including underground parking garages\nwarehouses\nreligious buildings\nAssembly and erection of prefabricated construction on the site\nThis class also includes remodeling or renovating existing residential structures\nThis class excludes :\nErection of complete prefabricated constructions from self-manufactured parts not of concrete, see divisions 16 and 25;\nConstruction of industrial facilities, except buildings, see 4290;\nArchitectural and engineering activities, see 7110;\nProject management activities related to construction, see 7110.', '410');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4210', 'Construction of Roads and Railways', NULL, '421');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4220', 'Construction of Utility Projects\n', 'This includes the construction of distribution lines and related buildings and structures that are integral part of these systems.\nThis class includes :\nConstruction of civil engineering construction for :\nlong-distance pipelines, communication and power lines\nurban pipelines, urban communication and power lines, ancillary urban works\nwater main and line construction\nirrigation systems (canals)\nreservoirs\nConstruction of: sewer systems, including repair; sewage disposal plants; pumping stations and power plants.\nWater well drilling\nThis class excludes :\nProject management activities related to civil engineering works, see 7110.', '422');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4290', 'Construction of Other Civil Engineering Projects', NULL, '429');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4311', 'Demolition', NULL, '431');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4312', 'Site Preparation', NULL, '431');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4321', 'Electrical Installation', NULL, '432');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4322', 'Plumbing, Heat and Air-conditioning Installation', NULL, '432');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4329', 'Other Construction Installation', NULL, '432');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4330', 'Building Completion and Finishing\n', 'This class includes :\nApplication in buildings or other construction projects of interior and exterior plaster or stucco, including related lathing materials\nInstallation of doors (except automated and revolving), windows, door and window frames, fitted kitchens, staircases, shop fittings and the like, of wood or other materials\nInstallation of fitted kitchens, staircases, shop fittings and the like\nInstallation of furniture\nInterior completion such as ceilings, wooden wall coverings, movable partitions, etc.\nInterior installation of shops, mobile homes, boats, etc.\nInterior and exterior painting of buildings\nPainting of civil engineering structures\nLaying, tiling, hanging or fitting in buildings or other construction projects of :\nceramic, concrete or cut stone wall or floor tiles, ceramic stove fitting\nparquet and other wooden floor coverings\ncarpets and linoleum floor coverings, including of rubber or plastic\nterrazzo, marble, granite or slate floor or wall coverings\nwall paper\nInterior and exterior painting of buildings\nPainting of civil engineering structures\nInstallation of glass, mirrors, etc.\nCleaning of new buildings after construction\nOther building completion work, n.e.c.\nThis class also includes interior installation of shops, mobile homes, boats etc.\nThis class excludes :\nGeneral interior cleaning of buildings and other structures, see 8121;\nSpecialized interior and exterior cleaning of buildings, see 8129;\nActivities of interior decoration designers, see 7410.\nAssembly of self-standing furniture, see 9524;\nPainting of roads, see 4210;\nInstallation of automated and revolving doors, see 4329.', '433');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4390', 'Other Specialized Construction Activities', NULL, '439');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4510', 'Sale of Motor Vehicles\n', 'This class includes :\nWholesale and retail sale of new and used vehicles :\npassenger motor vehicles, including specialized passenger motor vehicles such as ambulances and minibuses, etc.\nlorries, trailers and semi-trailers\ncamping vehicles such as caravans and motor homes\nThis class also includes :\nWholesale and retail sale of off-road motor vehicles (jeeps, etc)\nWholesale and retail sale by commission agents\nCar auctions\nThis class excludes :\nWholesale and retail sale of parts and accessories for motor vehicles, see 4530;\nRenting of motor vehicles with driver, see 4932;\nRenting of trucks with driver, see 4933;\nRenting of motor vehicles and trucks without driver, see 7710.', '451');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4520', 'Maintenance and Repair of Motor Vehicles\n', 'This class includes :\nMaintenance and repair of motor vehicles :\nmechanical repairs\nelectrical repairs\nelectronic injection system repair\nordinary servicing\nbodywork repair\nrepair of motor vehicle parts\nwashing, polishing, etc.\nspraying and painting\nrepair of screens and windows\nrepair of motor vehicle seats\nTire and tube repair, fitting or replacement\nAnti-rust treatment\nInstallation of parts and accessories not as part of the manufacturing process\nThis class excludes retreading and rebuilding of tires, see 2211.', '452');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4530', 'Sale of Motor Vehicle Parts and Accessories\n', 'This class includes :\nWholesale and retail sale of all kinds of parts, components, supplies, tools and accessories for motor vehicles, such as :\nrubber tires and inner tubes for tires\nspark plugs, batteries, lighting equipment and electrical parts\nThis class excludes : retail sale of automotive fuel, see 4730.', '453');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4540', 'Sale, Maintenance and Repair of Motorcycles and Related Parts and Accessories\n', 'This class includes :\nWholesale and retail sale of motorcycles including mopeds\nWholesale and retail sale of parts and accessories for motorcycles (including by commission agents and mail order houses)\nMaintenance and repair of motorcycles.\nThis class excludes :\nWholesale of bicycles and related parts and accessories, see 4649;\nRetail sale of bicycles and related parts and accessories, see 4763;\nRenting of motorcycles, see 7730;\nRepair and maintenance of bicycles, see 9529.', '454');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4610', 'Wholesale on a Fee or Contract Basis\n', 'This class includes :\nActivities of commission agents, commodity brokers and all other wholesalers who trade on behalf and on the accounts of others\nActivities of those involved in bringing sellers and buyers together or undertaking commercial transactions on behalf of a principal, including in the internet\nSuch agents involved in the sale of :\nagricultural raw materials, live animals, textile raw materials and semi-finished goods\nfuels ores, metals and industrial chemicals, including fertilizers\nfood, beverage and tobacco\ntextiles, clothing, fur, footwear and leather goods\ntimber and building materials\nmachinery, including office machinery and computers, industrial equipment, ships and aircraft\nfurniture, household goods and hardware\nThis class also includes activities of wholesale auctioneering houses.\nThis class excludes :\nWholesale trade in own name, see Groups 462 to 469;\nActivities of commission agents for motor vehicles, see 4510;\nAuctions of motor vehicles, see 4510;\nRetail sale by non-store commission agents, see 4799;\nActivities of insurance agents, see 6622;\nActivities of real estate agents, see 6820.', '461');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4620', 'Wholesale of Agricultural Raw Materials and Live Animals\n', 'This class includes :\nWholesale of grains and seeds\nWholesale of oleaginous fruits\nWholesale of unmanufactured tobacco\nWholesale of live animals\nWholesale of hides and skins\nWholesale of leather\nWholesale of agricultural material, waste, residues and by-products used for animal feed\nThis class excludes wholesale of textile fibers, see 4669.', '462');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4630', 'Wholesale of Food, Beverages and Tobacco\n', 'This class includes:\nWholesale of fruit and vegetables\nWholesale of dairy products\nWholesale of eggs and egg products\nWholesale of edible oils and fats of animal or vegetable origin\nWholesale of meat and meat products\nWholesale of fishery products\nWholesale of sugar, chocolate and sugar confectionery\nWholesale of bakery products\nWholesale of beverages\nWholesale of coffee, tea, cocoa and spices\nWholesale of tobacco products\nThis class also includes :\nBuying of wine in bulk and bottling without transformation\nWholesale of feed for pet animals.\nThis class excludes blending of wine or distilled spirits, see 1101, 1102.', '463');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4641', 'Wholesale of Textiles, Clothing and Footwear\n', 'This class includes :\nWholesale of yarn\nWholesale of fabrics\nWholesale of household linen, etc.\nWholesale of haberdashery: needles, sewing thread, etc.\nWholesale of clothing, including sports clothes\nWholesale of clothing accessories such as gloves, ties and braces\nWholesale of footwear\nWholesale of fur articles\nWholesale of umbrellas\nThis class excludes wholesale of jewelry and leather goods, see 4649 and wholesale of textile fibers, see 4669.', '464');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4642', 'Wholesale of Miscellaneous Consumer Goods', NULL, '464');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4649', 'Wholesale of Other Household Goods', NULL, '464');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4651', 'Wholesale of Computers, Computer Peripheral Equipment and Software', NULL, '465');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4652', 'Wholesale of Electronic and Telecommunications Equipment and Parts\n', 'This class includes :\nWholesale of electronic valves and tubes\nWholesale of semi-conductor devices\nWholesale micro-chips and integrated circuits\nWholesale of printed circuits\nWholesale of blank audio and video tapes and diskettes, magnetic and optical disks (CDs, DVDs)\nWholesale of telephone and communications equipment\nThis class excludes :\nWholesale of recorded audio and video tapes, CDs, DVDs, see 4649;\nWholesale of consumer electronics, see 4649;\nWholesale of computers and computer peripheral equipment, see 4651.', '465');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4653', 'Wholesale of Agricultural Machinery, Equipment and Supplies', NULL, '465');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4659', 'Wholesale of Other Machinery and Equipment\n', 'This class includes :\nWholesale of office machinery and equipment, except computers and computer peripheral equipment\nWholesale of office furniture\nWholesale of transport equipment except motor vehicles, motorcycles and bicycles\nWholesale of production-line robots\nWholesale of wires and switches and other installation equipment for industrial use\nWholesale of other electrical materials such as electrical motors, transformers\nWholesale of machine tools of any type and for any material\nWholesale of other machinery, n.e.c. for use in industry, trade and navigation and other services\nThis class also includes :\nWholesale of computer-controlled machine tools\nWholesale of computer-controlled machinery for the textile industry and of computer-controlled sewing and knitting machines', '465');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4661', 'Wholesale of Solid, Liquid and Gaseous Fuels and Related Products', NULL, '466');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4662', 'Wholesale of Metals and Metal Ores', NULL, '466');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4663', 'Wholesale of Construction Materials, Hardware, Plumbing and Heating Equipment and Supplies\n', 'This class includes :\nWholesale of wood in the rough\nWholesale of products of primary processing of wood\nWholesale of paint and varnish\nWholesale of construction materials: sand and gravel\nWholesale of wallpaper and floor coverings\nWholesale of flat glass\nWholesale of hardware and locks\nWholesale of fittings and fixtures\nWholesale of hot water heaters\nWholesale of sanitary equipment: baths, washbasins, toilets and other sanitary porcelain\nWholesale of sanitary installation equipment: tubes, pipes, fittings, taps, T-pieces, connections, rubber pipes, etc.\nWholesale of tools such as hammers, saws, screwdrivers and other hand tools', '466');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4669', 'Wholesale of Waste and Scrap and Other Products, N.e.c.\n', 'This class includes :\nWholesale of industrial chemicals :\naniline, printing ink, essential oils, industrial gases, chemical glues, coloring matter, synthetic resin, methanol, paraffin, scents and flavorings, soda, industrial salt, acids and sulfurs, starch derivative, etc.\nWholesale of fertilizers and agro-chemical products\nWholesale of plastic materials in primary forms\nWholesale of rubber\nWholesale of textile fibers, etc.\nWholesale of paper in bulk\nWholesale of precious stones\nWholesale of metal and non-metal waste and scrap and materials for recycling, including collecting, sorting, separating, stripping of used goods such as cars in order to obtain reusable parts, packing and repacking, storage and delivery, but without a real transformation process. Additionally, the purchased and sold waste has a remaining value.\nThis class also includes:\nDismantling of automobiles, computers, televisions and other equipment to obtain and re-sell usable parts.\nThis class excludes :\nCollection of household and industrial waste, see 381;\nTreatment of waste, not for further use in an industrial manufacturing process, but with the aim of disposal, see 382;\nProcessing of waste and scrap and other articles into secondary raw material when a real transformation process is required (the resulting secondary raw material is fit for direct use in an industrial manufacturing process, but is not a final product), see 3830;\nDismantling of automobiles, computers, televisions and other equipment for materials recovery, see 3830;\nShredding of cars by means of a mechanical process, see 3830;\nShip-breaking, see 3830;\nRetail sale of second-hand goods, see 4774.', '466');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4690', 'Non-specialized Wholesale Trade', NULL, '469');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4711', 'Retail Sale in Non-specialized Stores with Food, Beverages or Tobacco Predominating\n', 'This class includes :\nRetail sale of a large variety of goods of which, however, food products, beverages or tobacco should be predominant, such as :\nretail sale activities of general stores that have, apart from their main sales of food products, beverages or tobacco, several other lines of merchandise such as wearing apparel, furniture, appliances, hardware, cosmetics, etc.\nThis class excludes :\nRetail sale of fuel in combination with food, beverages, etc. with fuel sales dominating, see 4730.', '471');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4719', 'Other Retail Sale in Non-specialized Stores\n', 'This class includes :\nRetail sale of a large variety of goods of which food products, beverages or tobacco are not predominant, such as :\nretail sale activities of department stores carrying a general line of merchandise, including wearing apparel, furniture, appliances, hardware, cosmetics, jewelry, toys, sports goods, etc.', '471');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4721', 'Retail Sale of Food in Specialized Stores', NULL, '472');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4722', 'Retail Sale of Beverages in Specialized Stores', NULL, '472');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4723', 'Retail Sale of Tobacco Products in Specialized Stores', NULL, '472');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4730', 'Retail Sale of Automotive Fuel in Specialized Stores', NULL, '473');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4741', 'Retail Sale of Computers, Peripheral Units, Software and Telecommunications Equipment in Specialized Stores\n', 'This class includes :\nRetail sale of computers, computer peripheral equipment, video game consoles, non-customized software, including video games and retail sale of telecommunications equipment.\nThis class excludes retail sale of blank tapes and disks, see 4762.', '474');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4742', 'Retail Sale of Audio and Video Equipment in Specialized Stores', NULL, '474');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4751', 'Retail Sale of Textiles in Specialized Stores\n', 'This class includes retail sale of fabrics, knitting yarn, basic materials for rug, tapestry or embroidery making, textiles, haberdashery (needles, and sewing thread, etc.).\nThis class excludes retail sale of clothing, see 4771.', '475');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4752', 'Retail Sale of Hardware, Paints and Glass in Specialized Stores', NULL, '475');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4753', 'Retail Sale of Carpets, Rugs, Wall and Floor Coverings in Specialized Stores', NULL, '475');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4759', 'Retail Sale of Electrical Household Appliances, Furniture, Lighting Equipment and Other Household Articles in Specialized Stores', NULL, '475');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4761', 'Retail Sale of Books, Newspapers and Stationery in Specialized Stores', NULL, '476');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4762', 'Retail Sale of Music and Video Recordings in Specialized Stores', NULL, '476');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4763', 'Retail Sale of Sporting Equipment in Specialized Stores\n', 'This class includes retail sale of sports goods, fishing gear, camping goods and bicycles.', '476');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4764', 'Retail Sale of Games and Toys in Specialized Stores', NULL, '476');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4771', 'Retail Sale of Clothing, Footwear and Leather Articles in Specialized Stores\n', 'This class includes :\nRetail sale of articles of clothing\nRetail sale of articles of fur\nRetail sale of clothing accessories such as gloves, ties, braces, etc.\nRetail sale of umbrellas\nRetail sale of footwear\nRetail sale of leather goods\nRetail sale of travel accessories of leather and leather substitutes\nThis class excludes retail sale of textiles, see 4751.', '477');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4772', 'Retail Sale of Pharmaceutical and Medical Goods, Cosmetic and Toilet Articles in Specialized Stores\n', 'This class includes :\nRetail sale of pharmaceuticals\nRetail sale of medical and orthopedic goods\nRetail sale of perfumery, cosmetic articles and toilet articles', '477');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4773', 'Other Retail Sale of New Goods in Specialized Stores', NULL, '477');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4774', 'Retail Sale of Second-hand Goods\n', 'This class includes retail sale of second-hand clothing, footwear and leather articles, books and other goods, antiques and activities of auctioning houses.\nThis class excludes retail sale of second-hand motor vehicles, see 4510; activities of internet auctions and other non-store auction (retail), see 4791, 4799; activities of pawnshop, see 6493.', '477');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4775', 'Retail Sale of Liquefied Petroleum Gas and Other Fuel Products', NULL, '477');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4776', 'Retail Sale of Pet and Pet Supplies (Pet Shop)', NULL, '477');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4781', 'Retail Sale Via Stalls and Markets of Food, Beverages and Tobacco Products', NULL, '478');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4782', 'Retail Sale Via Stalls and Markets of Textiles, Clothing and Footwear', NULL, '478');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4789', 'Retail Sale Via Stalls and Markets of Other Goods\n', 'This class includes retail sale of other goods via stalls or markets.', '478');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4791', 'Retail Sale Via Mail/telephone Order Houses or Via Internet\n', 'This class includes retail sale activities via mail order houses of internet, i.e., retail sale activities where the buyer makes his choice on the basis of advertisements, catalogues, information provided on a website, models or any other means of advertising and places his order by mail, phone or over the internet (usually through special means provided by a website). The products purchased can be either directly downloaded from the internet or physically delivered to the customer.', '479');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4799', 'Other Retail Sale Not in Stores, Stalls or Markets\n', 'This class includes :\nRetail sale of any kind of product in any way that is not included in previous classes :\nby direct sales or door-to-door sales persons;\nthrough vending machines, etc.\nDirect selling of fuel (heating oil, fire wood, etc), drinking water, delivered directly to the customer\nActivities of non-store auction, (retail)\nRetail sale by (non-store) commission agents\nThis class excludes delivery of products by stores, see Groups 471-477.', '479');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4911', 'Passenger Rail Transport, Inter-urban\n', 'This class includes :\nPassenger transport by inter-urban railways\nOperation of sleeping cars or dining cars as an integrated operation of railway companies\nThis class excludes :\nPassenger terminal activities, see 5221;\nOperation of sleeping cars or dining cars when operated by separate units, see 5590, 5610.', '491');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4912', 'Freight Rail Transport', NULL, '491');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4920', 'Transport Via Buses\n', 'This class includes transport of scheduled buses at short or long distances. It also includes tourism and sightseeing buses, which are scheduled or chartered and operation of school and employee buses.', '492');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4931', 'Urban or Suburban Passenger Land Transport, Except Railway or Bus', NULL, '493');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4932', 'Other Passenger Land Transport\n', 'This class includes :\nOther passenger road transport :\ncharters, excursions and other occasional coach services\ntaxi operations\nairport shuttles\nOperations of telfers, funiculars, ski and cable lifts if not part of urban or suburban transit systems\nThis class also includes :\nRental of cars and trucks with driver\nPassenger transport by man-or animal-drawn vehicles\nThis class excludes ambulance transport, see 8690.', '493');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4933', 'Freight Transport by Road', NULL, '493');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('4940', 'Transport Via Pipeline', NULL, '494');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5011', 'Sea and Coastal Passenger Water Transport\n', 'This class includes :\nTransport of passengers over seas and coastal waters, whether scheduled or not :\noperation of excursion, cruise or sightseeing boats;\noperation of ferries, water taxis, etc\nThis class excludes :\nRestaurant and bar activities on board ships, when provided by separate units, see 5610, 5630;\nOperation of \"floating casinos\", see 9200.', '501');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5012', 'Sea and Coastal Freight Water Transport\n', 'This class includes :\nTransport of freight over seas and coastal waters, whether scheduled or not\nTransport by towing or pushing of barges, oil rigs, etc.\nThis class excludes :\nStorage of freight, see 5210;\nHarbor operation and other auxiliary activities such as docking, pilotage, lighterage, vessel salvage, see 5222.\nCargo handling, see 5224.', '501');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5021', 'Inland Passenger Water Transport', NULL, '502');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5022', 'Inland Freight Water Transport', NULL, '502');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5110', 'Passenger Air Transport\n', 'This class includes :\nTransport of passengers by air over regular routes and on regular schedules\nCharter flights for passengers\nScenic and sightseeing flights.\nThis class also includes :\nRenting of air-transport equipment with operator for the purpose of passenger transportation\nGeneral aviation activities, such as: transport of passengers by aero clubs for instruction or pleasure.', '511');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5120', 'Freight Air Transport\n', 'This class includes :\nTransport freight by air over regular routes and on regular schedules\nNon-scheduled transport of freight by air\nLaunching of satellites and space vehicles\nSpace transport\nThis class also includes renting of air transport equipment with operator for the purpose of freight transportation.', '512');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5210', 'Warehousing and Storage\n', 'This class includes :\nOperation of storage and warehouse facilities for all kind of goods :\noperation of grain silos, general merchandise warehouses, refrigerated warehouses, storage tanks, etc.\nThis class also includes storage of goods in foreign trade zones and blast freezing.\nThis class excludes :\nParking facilities for motor vehicles, see 5221;\nOperation of self storage facilities, see 6819;\nRental of vacant space, see 6819.', '521');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5221', 'Service Activities Incidental to Land Transportation\n', 'This class includes :\nActivities related to land transport of passengers, animals or freight :\noperation of terminal facilities such as railway stations, bus stations, stations for the handling of goods\noperation of railroad infrastructure\noperation of roads, bridges, tunnels, car parks or garages, bicycle parkings\nSwitching and shunting\nTowing and road side assistance\nThis class also includes liquefaction of gas for transportation purposes.\nThis class excludes cargo handling, see 5224.', '522');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5222', 'Service Activities Incidental to Water Transportation', NULL, '522');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5223', 'Service Activities Incidental to Air Transportation', NULL, '522');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5224', 'Cargo Handling\n', 'This class includes :\nLoading and unloading of goods or passengersNULL luggage irrespective of the mode of transport used for transportation\nStevedoring\nLoading and unloading of freight railway cars.\nThis class excludes operation of terminal facilities, see 5221; 5222 and 5223.', '522');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5229', 'Other Transportation Support Activities\n', 'This class includes :\nForwarding of freight\nArranging or organizing of transport operations by rail, road, sea or air\nOrganization of group or individual consignments (including pickup and delivery of goods and grouping of consignments)\nLogistics activities, i.e. planning, designing and supporting operations of transportation, warehousing and distribution\nIssue and procurement of transport documents and waybills\nActivities of customs agents\nActivities of sea-freight forwarders and air-cargo agents\nBrokerage for ship and aircraft space\nGoods-handling operations, e.g. temporary crafting for the sole purpose of protecting the goods during transit, uncrating, sampling, weighing of goods\nThis class excludes :\nCourier activities, see 5320;\nProvision of motor, marine, aviation and transport insurance, see 6512;\nActivities of travel agencies, see 7911;\nActivities of tour operators, see 7912;\nTourist assistance activities, see 7990.', '522');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5310', 'Postal Activities', NULL, '531');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5320', 'Courier Activities\n', 'This class includes :\nPickup, sorting, transport and delivery (domestic or international) of letter-post and (mail-type) parcels and packages by firms not operating under a universal service obligation. One or more modes of transport may be involved and the activity may be carried out with either self-owned (private) transport or via public transport\nDistribution and delivery of mail and parcels\nThis class also includes home delivery services.\nThis class excludes transport of freight, see according to mode of transport 4912, 4933, 5012, 5022, 5120.', '532');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5510', 'Short Term Accommodation Activities\n', 'This class includes the provision of accommodation, typically on a daily or weekly basis, principally for short stay by visitors. This includes the provision of furnished accommodation in guest rooms and suites or complete self-contained units with kitchens, with or without daily or other regular housekeeping services, and may often include a range of additional services such as food and beverage services, parking, laundry services, swimming pools and exercise rooms, recreational facilities and conference and convention facilities.\nThis class includes the provision of short-term accommodation provided by : hotels; motels; resort hotels; suite/apartment hotels; condotels; inns; guesthouses; youth hostels; pensions; visitor flats and bungalows; chalets, housekeeping cottages and cabins; holiday homes; time-share units.\nThis class excludes provision of homes and furnished or unfurnished flats or apartments for more permanent use, typically on a monthly or annual basis, see Division 68.', '551');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5590', 'Other Accommodation\n', 'This class includes the provision of temporary or long-term lodging in single or shared rooms or dormitories for students, migrant (seasonal) workers and other individuals.', '559');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5610', 'Restaurants and Mobile Food Service Activities\n', 'This class includes the activity of providing food services to customers, whether they are served while seated or serve themselves from a display of items, whether they eat the prepared meals on the premises, take them out or have them delivered. This includes the preparation and serving of meals for immediate consumption from motorized vehicles or non-motorized carts.\nThis class includes activities of :\nRestaurants\nCafeterias\nFast-food restaurants\nPizza delivery\nTake-out eating places\nIce cream truck vendors\nMobile food carts\nFood preparation in market stalls\nThis class also includes restaurant and bar activities connected to transportation, when carried out by separate units.\nThis class excludes concession operation of eating facilities, see 5629.', '561');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5621', 'Event Catering', NULL, '562');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5629', 'Other Food Service Activities', NULL, '562');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5630', 'Beverage Serving Activities\n', 'This class includes the activity of preparing and serving beverages for immediate consumption on the premises.\nThis class includes :\nBars\nTaverns\nCocktail lounge\nDiscotheques (with beverage serving predominantly)\nBeer parlors and pubs\nCoffee shops\nFruit juice bars\nMobile beverage vendors\nThis class excludes :\nReselling packaged/prepared beverages, see 4711, 4722, 4781, 4799;\nOperation of discotheques and dance floors without beverage serving, see 9329.', '563');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5811', 'Book Publishing', NULL, '581');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5812', 'Publishing of Directories and Mailing Lists', NULL, '581');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5813', 'Publishing of Newspapers, Journals and Periodicals', NULL, '581');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5819', 'Other Publishing Activities', NULL, '581');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5820', 'Software Publishing', NULL, '582');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5911', 'Motion Picture, Video and Television Programme Production Activities\n', 'This class includes production of theatrical and non-theatrical motion pictures whether on film, video tape, DVD or other media, including digital distribution, for direct projection in theatres or for broadcasting on television; supporting activities such as film editing, cutting, dubbing etc.; distribution of motion pictures or other film productions (video tapes, DVDNULLs etc.) to other industries; as well as their projection. Buying and selling of motion picture or any other film production distribution rights is also included.\nIt also includes production of motion pictures, videos, television programs or television commercials.\nThis class excludes :\nFilm duplication (except reproduction of motion picture film for theatrical distribution ) as well as audio and video tape, CD or DVD reproduction from master copies, see 1820;\nWholesale of recorded video tapes, CDNULLs, DVDNULLs, see 4649;\nRetail trade of video tapes, CDNULLs, DVDNULLs, see 4762;\nPost-production activities, see 5912;\nSound recording and recording of books on tape, see 5920;\nTelevision broadcasting, see 6020;\nFilm processing other than for the motion picture industry, see 7420;\nActivities of personal theatrical or artistic agents or agencies, see 7490;\nRenting of video tapes, DVDNULLs to the general public, see 7722;\nReal-time (i.e. simultaneous) closed captioning of live television performances of meetings, conferences, see 8299;\nActivities of own account actors, cartoonists, directors, stage designers and technical specialists, see 9000.', '591');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5912', 'Motion Picture, Video and Television Programme Post-production Activities\n', 'This class includes :\nPost production activities such as:\nediting, film/tape transfers, titling, subtitling, credits\nclosed captioning\ncomputer-produced graphics, animation and special effects\nfilm/tape transfers\nActivities of motion pictures film laboratories and activities of special laboratories for animated films:\ndeveloping and processing motion picture film, activities of motion picture film\nreproduction of motion picture film for theatrical distribution\nThis class excludes :\nFilm duplicating (except reproduction of motion picture film for theatrical distribution) as well as audio and video tape, CD or DVD reproduction from master copies, see 1820;\nWholesale of recorded video tapes, CDNULLs, DVDNULLs, see 4649;\nRetail trade of video tapes, CDs, DVDs, see 4762;\nRenting of video tapes, DVDNULLs to the general public, see 7722;\nActivities of own account actors, cartoonists, directors, stage designers and technical specialists, see 9000.', '591');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5913', 'Motion Picture, Video and Television Programme Distribution Activities', NULL, '591');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5914', 'Motion Picture Projection Activities', NULL, '591');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('5920', 'Sound Recording and Music Publishing Activities\n', 'This class includes :\nProduction of original (sound) master recording, such as tapes, CDs\nSound recording service activities in a studio or elsewhere, including the production of taped (i.e. non-live) radio programming, audio for film, television, etc.\nMusic publishing, i.e. activities of :\nacquiring and registering copyrights for musical compositions\npromoting, authorizing and using these compositions, in recordings, radio, television, motion pictures, live performances, print and other media\ninclude on-line and other media\ndistributing sound recordings to wholesalers, retailers of directly to the public.\nUnits engaged in these activities may own the copyright or act as administrator of the music copyrights on behalf of the copyrights owners.\nPublishing of music and sheet books\nThis class excludes :\nReproduction from master copies of music or other sound recordings, see 1820;\nWholesale of recorded audio tapes and disks, see 4649.', '592');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6010', 'Radio Broadcasting\n', 'This class includes broadcasting audio signals through radio broadcasting studios and facilities for the transmission of aural programming to the public, to affiliates or to subscribers.\nThis class also includes :\nActivities of radio networks, i.e. assembling and transmitting aural programming to the affiliates or subscribers via over-the-air broadcasts, cable or satellite\nRadio broadcasting activities over the Internet (Internet radio stations)\nData broadcasting integrated with radio broadcasting\nThis class excludes the production of taped radio programming, see class 5920.', '601');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6020', 'Television Programming and Broadcasting Activities\n', 'This class includes :\nCreation of a complete television channel programme, from purchased programme components (e.g., movies, documentaries, etc.), self produced programme components (e.g., local news, live reports) or a combination thereof.\nThis complete television programme can be either broadcast by the producing unit or produced from transmission by third party distributors, such as cable companies or satellite providers.\nThe programming may be of a general or specialized nature (e.g. limited formats such as news, sports, education or youth oriented programming), may be made freely available to users or may be available only on a subscription basis.\nThis class also includes :\nProgramming of video-on-demand channels\nData broadcasting integrated with television broadcasting\nThis class excludes :\nProduction of television programme elements (e.g. movies, documentaries, commercials) see 5911;\nAssembly of a package of channels and distribution of that package via cable or satellite to viewers, see division 61.', '602');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6110', 'Wired Telecommunications Activities\n', 'This class includes :\nOperating, maintaining or providing access to facilities for the transmission of voice, data, text, sound and video using a wired telecommunications infrastructure, including :\noperating and maintaining switching and transmission facilities to provide point-to-point communications via landlines, microwave or a combination of landlines and satellite linkups\noperating of cable distribution systems (e.g. for distribution of data and television signals)\nfurnishing telegraph and other non-vocal communications using own facilities\nThe transmission facilities that carry out these activities may be based on a single technology or a combination of technologies.\nThis class also includes :\nPurchasing access and network capacity from owners and operators of networks and providing telecommunications services using this capacity to businesses and households\nProvision of Internet access by the operator of the wired infrastructures.\nThis class excludes telecommunications resellers, see 6190.', '611');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6120', 'Wireless Telecommunications Activities\n', 'This class includes :\nActivities of operating, maintaining or providing access to facilities for the transmission of voice, data, text, sound and video using a wireless telecommunications infrastructure\nMaintaining and operating paging as well as cellular and other wireless telecommunications networks\nThe transmission facilities provide omni-directional via airwaves and they may be based on a single technology or a combination of technologies.\nThis class also includes :\nPurchasing access and network capacity from owners and operators of networks and providing wireless telecommunications services (except satellite) using this capacity to businesses and households.\nProvision of Internet access by the operator of the wireless infrastructure.\nThis class excludes telecommunications resellers, see 6190.', '612');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6130', 'Satellite Telecommunications Activities', NULL, '613');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6190', 'Other Telecommunications Activities\n', 'This class includes :\nProvision of specialized telecommunications applications, such as satellite tracking, communication telemetry, and radar station operations\nOperation of satellite terminal stations and associated facilities operationally connected with one or more terrestrial communications systems and capable of transmitting telecommunications to or receiving telecommunications from satellite systems\nProvision of Internet access over networks between the client and the Internet Service Provider (ISP) not owned or controlled by the ISP, such as dial-up Internet access, etc.\nProvision of telephone and internet access in facilities open to the public\nProvision of telecommunications services over existing telecom connections: VOIP (Voice Over Internet Protocol) provision\nThis class excludes provision of Internet access by operators of telecommunications infrastructure, see 6110, 6120, 6130.', '619');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6201', 'Computer Programming Activities\n', 'This class includes the activities of writing, modifying, testing, and supporting software.\nThis class includes :\nDesigning the structure and content of, and/or writing the computer code necessary to create and implement :\nsystems software (including updates and patches)\nsoftware applications (including updates and patches)\ndatabases\nweb pages\nCustomizing of software, i.e. modifying and configuring an existing application so that it is functional within the clientNULLs information system environment.\nThis class excludes :\nPublishing packaged software, see 5820;\nPlanning and designing computer systems that integrate computer hardware, software, and communication technologies, even though providing software might be an integral part, see 6202.', '620');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6202', 'Computer Consultancy and Computer Facilities Management Activities', NULL, '620');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6209', 'Other Information Technology and Computer Service Activities', NULL, '620');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6311', 'Data Processing, Hosting and Related Activities\n', 'This class includes :\nProvision of infrastructure for hosting, data processing services and related activities\nSpecialized hosting activities such as :\nweb hosting\nstreaming services\napplication hosting\nApplication service provisioning\nGeneral time-share provision of mainframe to clients\nData processing activities :\ncomplete processing of data supplied by clients\ngeneration of specialized reports from data supplied by clients\nProvision of data entry services', '631');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6312', 'Web Portals', NULL, '631');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6391', 'News Agency Activities', NULL, '639');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6399', 'Other Information Service Activities, N.e.c.', NULL, '639');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6411', 'Central Banking', NULL, '641');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6419', 'Other Monetary Intermediation\n', 'This class includes the receiving of deposits and/or close substitutes for deposits and extending of credit or lending funds. The granting of credit can take a variety of forms, such as loans, mortgages, credit cards etc. These activities are generally carried out by monetary institutions other than central banks, such as: banks; savings banks; and credit unions.\nThis class also includes postal giro and postal savings bank activities; credit granting for house purchase by specialized deposits-taking institutions.\nThis class excludes:\nCredit granting for house purchase by specialized non-depository institutions, see 6492;\nCredit card transaction processing and settlement activities, see 6619.', '641');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6420', 'Activities of Holding Companies', NULL, '642');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6430', 'Trusts, Funds and Other Financial Vehicles\n', 'This class includes legal entities organized to pool securities or other financial assets, without managing, on behalf of shareholders or beneficiaries. The portfolio is customized to achieve specific investment characteristics, such as diversification, risks, rate of return, and price volatility. These entities earn interest, dividends, and other property income, but have little or no employment and no revenue from the sale of services.\nThis class excludes :\nFunds and trusts that earn revenue from the sale of goods or services, see PSIC class according to their principal activity;\nActivities of holding companies, see 6420;\nPension funding, see 6530; management of funds, see 6630.', '643');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6491', 'Financial Leasing', NULL, '649');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6492', 'Other Credit Granting\n', 'This class includes :\nFinancial service activities primarily concerned with making loans by institutions not involved in monetary intermediation, where the granting of credit can take a variety of forms, such as loans, mortgages, credit cards etc., providing the following types of services :\ngranting of consumer credit\ninternational trade financing\nprovision of long-term finance to industry by industrial banks\nmoney lending outside the banking system\ncredit granting for house purchase by specialized non-depository institutions\nThis class excludes :\nCredit granting for house purchased by specialized institutions that also take deposits, see 6419;\nOperational leasing, see division 77, according to type of goods leased;\nGrant-giving activities by membership organization, see 9499.', '649');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6493', 'Pawnshop Operations', NULL, '649');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6499', 'Other Financial Service Activities, Except Insurance and Pension Funding Activities, N.e.c.\n', 'This class includes :\nOther financial intermediation primarily concerned with distributing funds other than by making loans:\nfactoring activities\nwriting of swaps, options and other hedging arrangements\nactivities of viatical settlement companies\nThis class excludes :\nFinancial leasing, see 6491;\nSecurity dealing on behalf of others, see 6612;\nTrade, leasing and renting of real estate property, see division 68;\nBill collection without debt buying up, see 8291;\nGrant-giving activities by membership organization, see 9499.', '649');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6511', 'Life Insurance', NULL, '651');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6512', 'Non-life Insurance', NULL, '651');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6520', 'Reinsurance\n', 'This class includes the activities of assuming all or part of the risk associated with existing insurance policies originally underwritten by other insurance carriers.', '652');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6530', 'Pension Funding', NULL, '653');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6611', 'Administration of Financial Markets', NULL, '661');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6612', 'Security and Commodity Contracts Brokerage', NULL, '661');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6619', 'Other Activities Auxiliary to Financial Service Activities', NULL, '661');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6621', 'Risk and Damage Evaluation', NULL, '662');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6622', 'Activities of Insurance Agents and Brokers', NULL, '662');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6623', 'Pre-need Plan Activities\n', 'This class includes pre-need plans for health, education, memorial, interment, pension and travel.', '662');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6629', 'Other Activities Auxiliary to Insurance and Pension Funding', NULL, '662');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6630', 'Fund Management Activities', NULL, '663');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6811', 'Real Estate Buying, Selling, Renting, Leasing and Operating of Self-owned/leased Apartment Buildings, Non-residential and Dwellings', NULL, '681');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6812', 'Real Estate Buying, Developing, Subdividing and Selling, of Residential Including Mass Housing', NULL, '681');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6813', 'Cemetery and Columbarium Development, Selling, Renting, Leasing and Operating of Self-owned Cemetery/columbarium (Including Burial Crypt)', NULL, '681');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6814', 'Renting or Leasing Services of Residential Properties', NULL, '681');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6819', 'Other Real Estate Activities with Own or Leased Property', NULL, '681');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6820', 'Real Estate Activities on a Fee or Contract Basis', NULL, '682');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6910', 'Legal Activities', NULL, '691');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('6920', 'Accounting, Bookkeeping and Auditing Activities; Tax Consultancy', NULL, '692');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7010', 'Activities of Head Offices', NULL, '701');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7020', 'Management Consultancy Activities', NULL, '702');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7110', 'Architectural and Engineering Activities and Related Technical Consultancy\n', 'This class includes the provision of architectural services, engineering services, drafting services, building inspection services and surveying and mapping services and the like.\nThis class includes :\nArchitectural consulting activities :\nbuilding design and drafting\ntown and the city planning and landscape architecture\nEngineering design (i.e. applying physical laws and principles of engineering in the design of machines, materials, instruments, structures, processes and systems) and consulting activities for :\nmachinery, industrial processes and industrial plant\nprojects involving civil engineering, hydraulic engineering, traffic engineering\nwater management projects\nprojects elaboration and realization relative to electrical and electronic engineering, mining engineering, chemical engineering, mechanical, industrial and systems engineering, safety engineering\nproject management activities related to construction\nElaboration of projects using air conditioning, refrigeration, sanitary and pollution control engineering, acoustical engineering, etc.;\nGeophysical, geologic and seismic surveying\nGeodetic surveying activities :\nland and boundary surveying activities\nhydrologic surveying activities\nsubsurface surveying activities\ncartographic and spatial information activities\nThis class also includes environmental engineering activities such as: management and provision of anti-pollution technologies covering wastewater treatment or pollution control and solid and hazardous waste management, etc.\nThis class excludes :\nTest drilling in connection with mining operations, see 0910,0990;\nDevelopment or publishing of associated software, see 5820,6201;\nActivities of computer consultants, see 6202,6209;\nTechnical testing, see 7120;\nResearch and development activities related to engineering, see 7210;\nIndustrial design, see 7410;\nInterior decorating, see 7410;\nAerial photography, see 7420.', '711');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7120', 'Technical Testing and Analysis', NULL, '712');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7210', 'Research and Experimental Development on Natural Sciences and Engineering\n', 'This class includes :\nresearch and development on natural sciences\nresearch and development on biotechnology\nresearch and development on engineering and technology\nresearch and development on medical sciences\nresearch and development on agricultural sciences\ninterdisciplinary research and development, predominantly on natural sciences and engineering', '721');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7220', 'Research and Experimental Development on Social Sciences and Humanities', NULL, '722');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7230', 'Research and Experimental Development in Information Technology', NULL, '723');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7310', 'Advertising\n', 'This class includes the provision of a full range of advertising services (i.e. through in-house capabilities or subcontracting), including advice, creative services, production of advertising material, media planning, and buying.\nThis class includes :\nCreation and realization of advertising campaigns:\ncreating and placing advertising in newspapers, periodicals, radio, television, the internet and other media\ncreating and placing of outdoor advertising, e.g. billboards, panels, bulletins and frames, window dressing , showroom design, car and bus carding, etc.\nmedia representation, i.e. sale of time and space for various media soliciting advertising\naerial advertising\ndistribution or delivery of advertising material or samples\nprovision of advertising space on billboards, etc.\ncreation of stands and other display structures and sites\nConducting marketing campaigns and other advertising services aimed at attracting and retaining customers :\npromotion of products\npoint-of-sale marketing\ndirect mail advertising\nmarketing consulting\nThis class excludes :\nPublishing of advertising material, see 5819;\nProduction of commercial messages for radio, television and film, see 5911;\nPublic-relations activities, see 7020;\nMarket research, see 7320;\nGraphic design activities, see 7410;\nAdvertising photography, see 7420;\nConvention and trade show organizers, see 8230;\nMailing activities, see 8219.', '731');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7320', 'Market Research and Public Opinion Polling', NULL, '732');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7410', 'Specialized Design Activities\n', 'This class includes :\nFashion design related to textiles, wearing apparel, shoes, jewelry, furniture and other interior decoration and other fashion goods as well as other personal or household goods.\nIndustrial design, i.e. creating and developing designs and specifications that optimize the use, value and appearance of products, including the determination of the materials, construction, mechanism, shape, color and surface finishes of the product, taking into consideration human characteristics and needs, safety, market appeal and efficiency in production, distribution, use and maintenance.\nActivities of graphic designers\nActivities of interior decorators\nThis class excludes :\nDesign and programming of web pages, see 6201;\nArchitectural design, see 7110;\nEngineering design, i.e. applying physical laws and principles of engineering in the design of machines, materials, instruments, structures, processes and systems, see 7110.\nTheatrical stage-set design, see 9000.', '741');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7420', 'Photographic Activities\n', 'This class includes the commercial and consumer photograph production such as :\ndigital photograph processing\nportrait photography for passport, schools, weddings, etc.\nphotography for commercial, publishers, fashion, real estate or tourism purposes\naerial photography\nvideotaping of events: weddings, meetings, etc.\nFilm processing :\ndeveloping, printing and enlarging from client-taken negatives or cine-films\nfilm developing and photo printing laboratories\none hour photo shops (not part of camera stores)\nmounting slides\ncopying and restoring or transparency retouching in connections with photographs\nActivities of photojournalists\nThis class also includes microfilming of documents.\nThis class excludes :\nProcessing motion picture film related to the motion picture and television industries, see 5912;\nCartographic and spatial information activities, see 7110.', '742');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7490', 'Other Professional, Scientific and Technical Activities, N.e.c.\n', 'This class includes a great variety of service activities generally delivered to commercial clients. It includes those activities for which more advanced professional, scientific and technical skill levels are required, but does not include ongoing, routine business functions that are generally of short duration.\nThis class includes :\nTranslation and interpretation activities\nBusiness brokerage activities, i.e. arranging for the purchase and sale of small and medium-sized businesses, including professional practices, but not including real estate brokerage\nPatent brokerage activities (arranging for the purchase and sale of patents)\nAppraisal activities other than for real estate and insurance (for antiques, jewelry, etc.)\nBill auditing and freight rate information\nActivities of quantity surveyors\nWeather forecasting activities\nSecurity consulting\nAgronomy consulting\nEnvironmental consulting\nOther technical consulting\nActivities of consultants other than architecture, engineering and management consultants\nThis class also includes :\nActivities carried on by agents and agencies on behalf of individuals usually involving the obtaining of engagements in motion picture, theatrical production or other entertainment or sports attractions and the placement of books, plays, artworks, photographs etc., with publishers, producers, etc.\nThis class excludes :\nWholesale of used motor vehicles by auctioning, see 4510;\nOnline auction activities (retail), see 4791;\nActivities of auctioning houses (retail), see 4799;\nActivities of real estate brokers, see 6820;\nBookkeeping activities, see 6920;\nActivities of management consultants, see 7020;\nActivities of architecture and engineering consultants, see 7110;\nEngineering design activities, see 7110;\nIndustrial and machinery design activities, see 7110;\nDisplay of advertisement and other advertising design, see 7310;\nCreation of stands and other display structures and sites, see 7310;\nActivities of convention and trade show organizers, see 8230;\nActivities of independent auctioneers, see 8299;\nAdministration of loyalty programs, see 8299;\nConsumer credit and debt counseling, see 8890;\nActivities of authors of scientific and technical books, see 9000;\nActivities of independent journalists, see 9000.', '749');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7500', 'Veterinary Activities', NULL, '750');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7710', 'Renting and Leasing of Motor Vehicles (Except Motorcycle, Caravans, Campers)', NULL, '771');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7721', 'Renting and Leasing of Recreational and Sports Goods', NULL, '772');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7722', 'Renting of Video Tapes and Disks', NULL, '772');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7729', 'Renting and Leasing of Other Personal and Household Goods\n', 'This class includes :\nRenting of all kinds of household or personal goods, to households or industries (except recreational and sports equipment) :\ntextiles, wearing apparel and footwear\nfurniture, pottery and glass, kitchen and tableware, electrical appliances and housewares\njewelry, musical instruments, scenery and costumes\nbooks, journals and magazines\nflowers and plants\nelectronic equipment for household use\nmachinery and equipment used by amateurs or as a hobby, e.g. tools for home repairs.\nThis class excludes :\nRenting of cars, trucks, trailers and recreational vehicles without driver, see 7710;\nRenting of recreational and sports goods, see 7721;\nRental of video tapes and disks, see 7722;\nRenting of motorcycles and caravans without driver, see 7730;\nRenting of office furniture, see 7730;\nProvision of linen, work uniforms and related items by laundries, see 9601.', '772');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7730', 'Renting and Leasing of Other Machinery, Equipment and Tangible Goods\n', 'This class includes :\nRenting and operational leasing, without operator, of other machinery and equipment that are generally used as capital goods by industries :\nengine and turbines\nmachine tools\nmining and oil field equipment\nprofessional radio, television and communication equipment\nmotion picture production equipment\nmeasuring and controlling equipment\nother scientific, commercial and industrial machinery\nRenting and operational leasing of land-transport equipment (other than motor vehicles) without drivers:\nmotorcycles, caravans and campers, etc.\nrailroad vehicles\nRenting and operational leasing of water-transport equipment without operator : commercial boats and ships\nRenting and operational leasing of air transport equipment without operator :\nairplanes\nhot-air balloons\nRenting and operational leasing of agricultural and forestry machinery and equipment without operator\nRenting of products produced by class 2821 (Manufacture of agricultural and forestry machinery), such as agricultural tractors, etc.\nRenting and operational leasing of construction and civil-engineering machinery and equipment without operator :\ncrane lorries\nscaffolds and work platforms, without erection and dismantling\nRenting and operational leasing of office machinery and equipment without operator :\ncomputers and computer peripheral equipment\nduplicating machines, typewriters and word-processing machines\naccounting machinery and equipment: cash registers, electronic calculators etc., and office furniture\nThis class also includes :\nRenting of accommodation or office containers\nRenting of containers\nRenting of pallets\nRenting of animals (e.g. herds, race horses)\nThis class excludes :\nRenting of agricultural and forestry machinery or equipment with operator, see 015, 0240;\nRenting of construction and civil engineering machinery or equipment with operator, see division 43;\nRenting of water-transport equipment with operator, see division 50;\nRenting of air-transport with operator, see division 51;\nFinancial leasing, see 6491;\nRenting of pleasure boats, see 7721;\nRenting of bicycles, see 7721.', '773');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7740', 'Leasing of Intellectual Property and Similar Products, Except Copyrighted Works', NULL, '774');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7810', 'Activities of Employment Placement Agencies\n', 'This class includes listing employment vacancies and referring or placing applicants for employment, where the individuals referred or placed are not employees of the employment agencies.\nThis class includes :\nPersonnel search, selection referral and placement activities, including executive placement and search activities\nActivities of casting agencies and bureaus, such as theatrical casting agencies\nActivities of on-line employment placement agencies\nThis class excludes activities of personal theatrical or artistic agents or agencies, see 7490.', '781');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7820', 'Temporary Employment Agency Activities\n', 'This class includes activities of supplying workers to clientNULLs businesses for limited periods of time to temporarily supplement the working force of the client, where the individuals provided are employees of the temporary help service unit.\nUnits classified here do not provide direct supervision of their employees at the clientNULLs work sites.', '782');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7830', 'Other Human Resources Provision', NULL, '783');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7911', 'Travel Agency Activities', NULL, '791');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7912', 'Tour Operator Activities', NULL, '791');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('7990', 'Other Reservation Service and Related Activities\n', 'This class includes :\nProvision of other travel-related reservation services :\nreservations for transportation, hotels, restaurants, car rentals, entertainment and sport etc.\nProvision of time-share exchange services\nTicket sales activities for theatrical, sports and other amusement and entertainment events\nProvision of visitor assistance services :\nprovision of travel information to visitors\nactivities of tourist guides\nTourism promotion activities\nThis class excludes :\nActivities of travel agencies and tour operators, see 7911, 7912;\nOrganization and management of events such as meetings, conventions and conferences, see 8230.', '799');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8010', 'Private Security Activities', NULL, '801');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8020', 'Security Systems Service Activities', NULL, '802');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8030', 'Investigation Activities', NULL, '803');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8110', 'Combined Facilities Support Activities', NULL, '811');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8121', 'General Cleaning of Buildings', NULL, '812');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8129', 'Other Building and Industrial Cleaning Activities\n', 'This class includes :\nExterior cleaning of buildings of all types, including offices, factories, shops, institutions and other business and professional premises and multiunit residential buildings\nSpecialized cleaning activities for buildings such as window cleaning, chimney cleaning and cleaning of fireplaces, stoves, furnaces, incinerators, boilers, ventilation ducts and exhaust units\nSwimming pool cleaning and maintenance services\nCleaning of industrial machinery\nBottle cleaning\nCleaning of trains, buses, planes, etc.\nCleaning of the inside of road and sea tankers\nDisinfecting and exterminating activities\nStreet sweeping\nOther building and industrial cleaning activities, n.e.c.\nThis class excludes :\nAgriculture pest control, see 0153;\nCleaning of sewers and drains, see 3700;\nAutomobile cleaning, car wash, see 4520.', '812');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8130', 'Landscape Care and Maintenance Service Activities', NULL, '813');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8211', 'Combined Office Administrative Service Activities', NULL, '821');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8219', 'Photocopying, Document Preparation and Other Specialized Office Support Activities\n', 'This class includes a variety of copying, document preparation and specialized office support activities. The document copying/printing activities included here cover only short-run type printing activities.\nThis class includes :\nDocument preparation\nDocument editing or proofreading\nTyping, word processing, or desktop publishing\nSecretarial support services\nTranscription of documents, and other secretarial services\nLetter or resume writing\nProvision of mailbox rental and other postal and mailing services (except direct mail advertising)\nDuplicating\nMailing services.\nBlueprinting\nWord processing services\nPhotocopying\nOther document copying services without also providing printing services, such as offset printing, quick printing, digital printing, prepress services\nThis class excludes :\nPrinting of documents (offset printing, quick printing etc.), see 1811;\nDirect mail advertising, see 7310;\nSpecialized stenotype services such as court reporting, see 8299;\nPublic stenography services, 8299.', '821');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8221', 'Call Centers Activities (Voice)\n', 'This class includes :\nInbound call centers, answering calls from clients by using human operators, automatic call distribution, computer telephone integration, interactive voice response systems or similar methods to receive orders, provide product information, deal with customer request for assistance or address customer complaints.\nOutbound call centers using similar methods to sell or market goods or services to potential customers, undertake market research or public opinion polling and similar activities for clients.', '822');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8222', 'Back-office Operations Activities (Non-voice)\n', 'This class includes the export of business process services that are not primarily delivered through live, spoken interaction by frontline customer-service agents directly to customers or clients', '822');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8229', 'Other Non-voice Related Activities', NULL, '822');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8230', 'Organization of Conventions and Trade Shows\n', 'This class includes the organization, promotion and/or management of events, such as business and trade shows, conventions, conferences and meetings, whether or not including the management and provision of the staff to operate the facilities in which these events take place.', '823');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8291', 'Activities of Collection Agencies and Credit Bureaus', NULL, '829');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8292', 'Packaging Activities', NULL, '829');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8299', 'Other Business Support Service Activities, N.e.c.', NULL, '829');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8411', 'General Public Administration Activities\n', 'This class includes :\nExecutive and legislative administration of central, regional and local bodies\nAdministration and supervision of fiscal affairs :\noperation of taxation schemes\nduty/tax collection on goods and tax violation investigation\ncustoms administration\nBudget implementation and management of public funds and public debt : raising and receiving of moneys and control of their disbursement\nAdministration of overall (civil) R&D policy and associated funds\nAdministration and operation of overall economic and social planning and statistical services at the various levels of government\nThis class excludes :\nOperation of government owned or occupied buildings, see 681, 6820;\nAdministration of R&D policies intended to increase personal well-being and of associated funds, see 8412;\nAdministration of R&D policies intended to improve economic performance and competitiveness, see 8413;\nAdministration of defense-related R&D policies and of associated funds, see 8422;\nOperation of government archives, see 9101.', '841');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8412', 'Regulation of the Activities of Providing Health Care, Education, Cultural Services and Other Social Services, Excluding Social Security', NULL, '841');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8413', 'Regulation of and Contribution to More Efficient Operation of Businesses', NULL, '841');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8421', 'Foreign Affairs', NULL, '842');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8422', 'Defense Activities', NULL, '842');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8423', 'Public Order and Safety Activities', NULL, '842');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8430', 'Compulsory Social Security Activities', NULL, '843');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8511', 'Pre-primary/pre-school Education (For Children without Special Needs)', NULL, '851');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8512', 'Pre-primary Education for Children with Special Needs', NULL, '851');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8521', 'Primary/elementary Education (For Children without Special Needs)', NULL, '852');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8522', 'Primary/elementary Education for Children with Special Needs', NULL, '852');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8531', 'General Secondary Education for Children without Special Needs', NULL, '853');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8532', 'General Secondary Education for Children with Special Needs', NULL, '853');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8533', 'Technical and Vocational Secondary Education for Children without Special Needs\n', 'This class includes programs that prepare students both for higher education and for employment in specific vocational pursuits. While academic subjects are offered, emphasis is placed on vocational/technical subjects either as preparation for a range of more advanced vocational/technical programs or for a specific occupation.\nThe programs consist of the following areas of concern: (a) trade, craft and industries, (b) agriculture, and (c) fisheries. The principal subject-matter content of these programs include the regular school curriculum at this level but with more attention and time to elementary drafting, blueprint reading, and a range of technical subjects depending on the studentNULLs interests.', '853');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8534', 'Technical and Vocational Secondary Education for Children with Special Needs', NULL, '853');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8540', 'Higher Education\n', 'This class includes the provision of post-secondary non-tertiary and tertiary education, including granting of degrees at baccalaureate, graduate or post-graduate level. The requirements for admission is at least a high school diploma or equivalent general academic training.\nEducation can be provided in classrooms or through radio, television broadcast, Internet or correspondence.', '854');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8551', 'Sports and Recreation Education', NULL, '855');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8552', 'Cultural Education', NULL, '855');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8559', 'Other Education\n', 'This class includes the provision of instruction and specialized training, generally for adults, not comparable to the general education in groups 851-853. This class does not include activities of academic schools, colleges, and universities. Instruction may be provided in diverse settings, such as the unitNULLs or clientNULLs training facilities, educational institutions, the workplace, or the home, and through correspondence, radio, television, Internet, in classrooms or by other means. Such instruction does not lead to a high school diploma, baccalaureate or graduate degree.\nThis class includes :\nEducation that is not definable by level\nAcademic tutoring services\nPreparation for college entrance examination\nLearning centers offering remedial courses\nProfessional examination review courses\nLanguage instruction and conversational skills instruction\nSpeed reading instruction\nReligious instruction\nThis class also includes :\nAutomobile driving schools\nFlying schools\nLifeguard training\nSurvival training\nPublic speaking training\nComputer training', '855');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8560', 'Educational Support Services\n', 'This class includes :\nProvision of non-instructional services that support educational processes or systems :\nEducational consulting\nEducational guidance counseling services\nEducational testing evaluation services\nEducational testing services\nOrganization of students exchange programs\nThis class excludes scientific research and development, see division 72.', '856');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8611', 'Public Hospitals, Sanitaria and Other Similar Activities', NULL, '861');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8612', 'Private Hospitals, Sanitaria and Other Similar Activities', NULL, '861');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8621', 'Public Medical, Dental and Other Health Activities', NULL, '862');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8622', 'Private Medical, Dental and Other Health Activities', NULL, '862');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8690', 'Other Human Health Activities', NULL, '869');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8710', 'Residential Nursing Care Facilities', NULL, '871');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8720', 'Residential Care Activities for Mental Retardation, Mental Health and Substance Abuse\n', 'This class includes the provision of residential care (but not licensed hospital care) to people with mental retardation, mental illness, or substance abuse problems. Facilities provide room, board, protective supervision and counseling and some health care. It also includes provision of residential care and treatment for patients with mental health and substance abuse illnesses.\nThis class includes activities of :\nFacilities for treatment of alcoholism and drug addiction\nPsychiatric convalescent homes\nResidential group homes for the emotionally disturbed\nMental retardation facilities\nMental health halfway houses\nThis class excludes social work activities with accommodation, such as temporary homeless shelters, see 8790.', '872');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8730', 'Residential Care Activities for the Elderly and Disabled', NULL, '873');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8790', 'Other Residential Care Activities, N.e.c.\n', 'This class includes the provision of residential and personal care services for persons, except the elderly and disabled, who are unable to fully care for themselves or who do not desire to live independently.\nThis class includes :\nActivities provided on a round-the-clock basis directed to provide social assistance to children and special categories of persons with some limits on ability for self-care, but where medical treatment or education are nor important elements:\norphanages\nchildrenNULLs boarding homes and hostels\ntemporary homeless shelters\ninstitutions that take care of unmarried mothers and their children.\nThe activities may be carried out by public or private organizations.\nThis class also includes activities of :\nHalfway group homes for persons with social or personal problems\nHalfway homes for delinquents and offenders\nDisciplinary camps\nThis class excludes :\nFunding and administration of compulsory social security programs, see 8430;\nActivities of nursing care facilities, see 8710;\nResidential care activities for the elderly or disabled, see 8730;\nAdoption activities, see 8890;\nShort-term shelter activities for disaster victims, see 8890.', '879');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8810', 'Social Work Activities without Accommodation for the Elderly and Disabled\n', 'This class includes :\nSocial, counseling, welfare, referral and similar services which aimed at the elderly and disabled in their homes or elsewhere and carried out by government offices or by private organizations, national or local self-help organizations and by specialists providing counseling services :\nvisiting of the elderly and disabled\nday-care activities for the elderly or for handicapped adults\nvocational rehabilitation and habilitation activities for disabled persons provided that the education component is limited.\nThis class excludes :\nFunding and administration of compulsory social security programs, see 8430;\nActivities similar to those described in this class, but including accommodation, see 8730;\nDay-care activities for handicapped children, see 8890.', '881');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('8890', 'Other Social Work Activities without Accommodation, N.e.c.\n', 'This class includes :\nSocial, counseling, welfare, refugee and referral and similar services which are delivered to individuals and families in their homes or elsewhere and carried out by government offices or by private organizations, disaster relief organizations and national or local self-help organizations and by specialists providing counseling services :\nwelfare and guidance activities for children and adolescents\nadoption activities, activities for the prevention of cruelty to children and others\nmarriage and family guidance, credit and debt counseling services, household budget counseling\ncommunity and neighborhood activities\nactivities for the disaster victims, refugees, immigrants, etc., including temporary or extended shelter for them\nvocational rehabilitation and habilitation activities for unemployed persons provided that the education component is limited\neligibility determination in connection with welfare aid, rent supplements or food stamps\nchild day-care activities including for handicapped children\nday facilities for the homeless and other socially weak groups\ncharitable activities like fund-raising or other supporting activities aimed at social work.\nThis class excludes :\nFunding and administration of compulsory social security programs, see 8430;\nActivities similar to those described in this class, but including accommodation, see 8790.', '889');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9000', 'Creative, Arts and Entertainment Activities\n', 'This class includes the operation of facilities and provision of services to meet the cultural and entertainment interests of their customers. This includes the production and promotion of, and participation in, live performances, events or exhibits intended for public viewing; the provision of artistic, creative or technical skills for the production of artistic production of artistic products and live performances.\nThis class includes :\nProduction of live theatrical presentations, concerts and opera or dance productions and other stage productions :\nactivities of groups, circuses or companies, orchestras or bands\nactivities of individual artists such as authors, actors, directors, musicians, lecturers or speakers, stage-set designers and builders, etc.\nOperation of concert and theatre halls and other arts facilities\nActivities of sculptors, painters, cartoonists, engravers, etchers, etc.\nActivities of individual writers, for all subjects including fictional writing, technical writing, etc.\nActivities of independent journalists\nRestoring of works of art such as paintings, etc.\nThis class also includes activities of producers or entrepreneurs of arts live events, with or without facilities.\nThis class excludes :\nRestoring of stained glass windows, see 2310;\nManufacture of statues, other than artistic originals, see 2397;\nRestoring of organs and other historical musical instruments, see 3319;\nRestoring of historical sites and buildings, see 4100;\nMotion picture and video production, see 5911, 5912;\nOperation of cinemas, see 5914;\nActivities of personal theatrical or artistic agents or agencies, see 7490;\nCasting activities, see 7810;\nActivities of ticket agencies, see 7990;\nOperation of museums of all kinds, see 9102;\nSports and amusement and recreation activities, see division 93;\nRestoring of furniture (except museum type of restoration), see 9524.', '900');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9101', 'Library and Archives Activities', NULL, '910');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9102', 'Museums Activities and Operation of Historical Sites and Buildings', NULL, '910');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9103', 'Botanical and Zoological Gardens and Nature Reserves Activities', NULL, '910');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9200', 'Gambling and Betting Activities', NULL, '920');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9311', 'Operation of Sports Facilities', NULL, '931');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9312', 'Activities of Sports Clubs', NULL, '931');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9319', 'Other Sports Activities', NULL, '931');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9321', 'Activities of Amusement Parks and Theme Parks', NULL, '932');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9329', 'Other Amusement and Recreation Activities, N.e.c.\n', 'This class includes :\nActivities of recreation parks, beaches, including renting of facilities such as bathhouses, lockers, chairs etc.\nOperation of recreational transport facilities\nRenting of leisure and pleasure equipment as an integral part of recreational facilities\nOperation of fairs and shows of a recreational nature\nOperation of discotheques and dance floors\nOperation of (exploitation) of coin-operated games\nOther amusement and recreation activities (except amusement parks and theme parks, see 9321) not elsewhere classified.\nThis class also includes activities of producers or entrepreneurs of live events other than arts or sports events, with or without facilities.\nThis class excludes\nFishing cruises, see 5011, 5021;\nProvision of space and facilities for short stay by visitors in recreational parks and forests and campgrounds, see 5510;\nBeverage serving activities of discotheques, see 5630;\nTrailer parks, campgrounds, recreational camps, hunting and fishing camps, campsites and campgrounds, see 5510;\nSeparate renting of leisure and pleasure equipment, see 7721;\nOperation (exploitation) of coin-operated gambling machines, see 9200;\nActivities of amusement parks and theme parks, see 9321.', '932');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9411', 'Activities of Business and Employers Membership Organizations', NULL, '941');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9412', 'Activities of Professional Membership Organizations', NULL, '941');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9420', 'Activities of Trade Unions', NULL, '942');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9491', 'Activities of Religious Organizations', NULL, '949');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9492', 'Activities of Political Organizations', NULL, '949');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9499', 'Activities of Other Membership Organizations, N.e.c.', NULL, '949');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9511', 'Repair of Computers and Peripheral Equipment', NULL, '951');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9512', 'Repair of Communications Equipment', NULL, '951');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9521', 'Repair of Consumer Electronics', NULL, '952');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9522', 'Repair of Household Appliances and Home and Garden Equipment\n', 'This class includes:\nRepair and servicing of household appliances:\nrefrigerators, stoves, washing machines, clothes dryers, room air conditioners\nRepair and servicing of home and garden equipment:\nlawnmowers, edgers, snow-and leaf-blowers, trimmers, etc.\nThis class excludes:\nrepair of hand held power tools, see 3312\nrepair of central air conditioning systems, see 4322.', '952');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9523', 'Repair of Footwear and Leather Goods\n', 'This class includes:\nRepair and maintenance of footwear: shoes, boots etc.\nFitting of heels\nRepair and maintenance of leather goods: luggage and the like', '952');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9524', 'Repair of Furniture and Home Furnishings\n', 'This class includes :\nReupholstering , refinishing, repairing and restoring of furniture and home furnishing\nAssembly of self-standing furniture\nThis class excludes installation of fitted kitchen, shop fittings and the like, see 4330.', '952');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9529', 'Repair of Other Personal and Household Goods\n', 'This class includes repair of personal and household goods :\nRepair of bicycles\nRepair and alteration of clothing\nRepair and alteration of jewelry\nRepair of watches, clocks and their parts such as watch cases and housings of all materials; movements, chronometers, etc.\nRepair of sporting goods (except sporting guns)\nRepair of books\nRepair of musical instruments\nRepair of toys and similar articles\nRepair of other personal and household goods\nPiano - tuning\nThis class excludes :\nIndustrial engraving of metals, see 2592;\nRepair of sporting and recreational guns, see 3311;\nRepair of hand held power tools, see 3312;\nRepair of time clocks, time/date stamps, time locks and similar time keeping devices, see 3313.', '952');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9610', 'Personal Services for Wellness, Except Sports Activities\n', 'This includes activities providing services for wellness such as hairdressing and other beauty treatment, activities of spa, steam bath, sauna, solarium, reducing and slendering saloon, massage saloon and Turkish bath.', '961');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9621', 'Washing and Dry Cleaning of Textile and Fur Products', NULL, '962');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9630', 'Funeral and Related Activities', NULL, '963');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9640', 'Domestic Services', NULL, '964');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9690', 'Other Personal Service Activities, N.e.c.\n', 'Social activities such as escort services, dating services, services of marriage bureau\nPet care services such as boarding, grooming, sitting and training pets\nAstrological and spiritualistsNULL activities\nGenealogical organizations\nShoe shiners, porters, valet car parkers etc.\nConcession operation of coin-operated personal service machines (photo booths, weighing machines, machines for checking blood pressure, coin-operated lockers, etc.\nThis class excludes veterinary activities, see 7500.', '969');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9700', 'Activities of Households as Employers of Domestic Personnel', NULL, '970');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9810', 'Undifferentiated Goods-producing Activities of Private Households for Own Use', NULL, '981');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9820', 'Undifferentiated Services-producing Activities of Private Households for Own Use', NULL, '982');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9901', 'Activities of Extra-territorial Organizations and Bodies\n', 'This class includes the activities of international organizations, such as the United Nations and its specialized agencies, regional bodies, etc.; the Association of Southeast Asian Nations (ASEAN)\nthe International Committee of the Red Cross (ICRC)\nthe International Labor Organization (ILO), the International Finance Corporation (IFC)\nthe International Monetary Fund (IMF)\nthe World Bank; the Japan International Cooperation Agency (JICA)\nthe Joint United States Military Assistance Group (JUSMAG)\netc.\nThis class also includes :\nActivities of diplomatic and consular mission when being determined by the country of their location rather than by the country they represent.', '990');
INSERT INTO psic_class (code, description, details, groupid) VALUES ('9909', 'Activities of Other International Organizations', NULL, '990');


-- SUBCLASS
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01111', 'Growing of Leguminous Crops such As: Mongo, String Beans (Sitao), Pigeon Peas, Gisantes, Garbanzos, Bountiful Beans (Habichuelas), Peas (Sitsaro)', NULL, '0111');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01112', 'Growing of Groundnuts', NULL, '0111');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01113', 'Growing of Oil Seeds (Except Groundnuts) such as Soya Beans, Sunflower and Growing of Other Oil Seeds, N.e.c.', NULL, '0111');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01114', 'Growing of Sorghum, Wheat', NULL, '0111');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01119', 'Growing of Other Cereals (Except Rice and Corn), Leguminous Crops and Oil Seeds, N.e.c.', NULL, '0111');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01121', 'Growing of Paddy Rice, Lowland, Irrigated', NULL, '0112');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01122', 'Growing of Paddy Rice, Lowland, Rainfed', NULL, '0112');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01123', 'Growing of Paddy Rice, Upland/kaingin', NULL, '0112');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01130', 'Growing of Corn, Except Young Corn (Vegetable)', NULL, '0113');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01140', 'Growing of Sugarcane Including Muscovado Sugar-making in the Farm', NULL, '0114');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01151', 'Growing of Virginia Tobacco Including Flue-curing Done in the Farm', NULL, '0115');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01152', 'Growing of Native Tobacco Including Flue-curing Done in the Farm', NULL, '0115');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01161', 'Growing of Abaca', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01162', 'Growing of Cotton', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01163', 'Growing of Kapok', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01164', 'Growing of Maguey', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01165', 'Growing of Ramie', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01166', 'Growing of Piña', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01167', 'Growing of Jute', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01168', 'Growing of Kenaf', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01169', 'Growing of Other Fiber Crops, N.e.c.', NULL, '0116');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01171', 'Growing of Leafy and Stem Vegetables such as : Cabbage, Broccoli, Cauliflower, Lettuce, Asparagus, Pechay, Kangkong and Other Leafy or Stem Vegetables', NULL, '0117');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01172', 'Growing of Fruit Bearing Vegetables such As: Tomato, Eggplant, Cucumber, Ampalaya, Squash, Gourd and Other Fruit Bearing Vegetables, N.e.c.', NULL, '0117');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01179', 'Growing of Other Leafy and Fruit Bearing Vegetables, N.e.c.', NULL, '0117');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01181', 'Growing of Onion', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01182', 'Growing of Garlic', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01183', 'Growing of Carrot', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01184', 'Growing of Potato', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01185', 'Growing of Cassava', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01186', 'Growing of Sweet Potato (Camote)', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01187', 'Growing of Melons and Watermelons', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01188', 'Growing of Yams (Ube)', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01189', 'Growing of Other Roots, Bulbs, Tuberous Crops and Vegetables Including Mushroom', NULL, '0118');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01191', 'Growing of Orchids', NULL, '0119');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01192', 'Growing of Flowers or Flower Buds, (Except Orchids), Cut Flowers', NULL, '0119');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01193', 'Production or Growing of Horticultural Specialties Including Nursery Products and Ornamental Plants', NULL, '0119');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01194', 'Growing of Plant Materials Used Chiefly in Medicinal/ Pharmaceutical or for Insecticidal, Fungicidal or Similar Purposes', NULL, '0119');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01195', 'Growing of Crops Chiefly for Construction, Furniture and Other Purposes (E.g., Bamboo, Buri, Nipa, Etc.)', NULL, '0119');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01196', 'Growing of Forage Crops and Other Grasses', NULL, '0119');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01199', 'Growing of Other Non-perennial Crops, N.e.c.', NULL, '0119');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01211', 'Growing of Banana, Cavendish', NULL, '0121');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01212', 'Growing of Other Banana', NULL, '0121');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01220', 'Growing of Pineapple', NULL, '0122');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01231', 'Growing of Calamansi', NULL, '0123');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01232', 'Growing of Dalandan', NULL, '0123');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01233', 'Growing of Mandarin (Dalanghita)', NULL, '0123');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01234', 'Growing of Pomelo (Suha)', NULL, '0123');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01235', 'Growing of Citrus Fruits, N.e.c.', NULL, '0123');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01240', 'Growing of Mango', NULL, '0124');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01250', 'Growing of Papaya', NULL, '0125');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01260', 'Growing of Coconut, Including Copra-making, Tuba Gathering and Coco-shell Charcoal and Coconut Sap Syrup Making in the Farm', NULL, '0126');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01271', 'Growing of Coffee Plant', NULL, '0127');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01272', 'Growing of Cacao', NULL, '0127');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01273', 'Growing of Tea Plant', NULL, '0127');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01279', 'Growing of Other Beverage Crops', NULL, '0127');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01281', 'Growing of Perennial Spices and Aromatic Crops such As: Ginger, Pepper, Chili, Achuete, Laurel, Etc.', NULL, '0128');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01282', 'Growing of Plants Used Primarily in Medical/ Pharmaceutical Purposes such as : Lagundi, Banaba, Ginseng, Oregano, Etc.', NULL, '0128');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01283', 'Growing of Plants for Insecticidal, Fungicidal or Similar Purposes', NULL, '0128');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01284', 'Growing of Crops Used Primarily in Perfumery or Similar Purposes', NULL, '0128');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01289', 'Growing of Other Spices, Aromatic, Drug and Pharmaceutical Crops, N.e.c.', NULL, '0128');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01291', 'Growing of Other Tropical Fruits, E.g. Jackfruit, Guavas, Avocados, Lanzones, Durian, Rambutan, Chico, Atis, Mangosteen, Makopa, Dragon Fruit Etc.', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01292', 'Growing of Perennial Trees with Edible Nuts, E.g. Pili Nuts, Cashew Nuts, Etc', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01293', 'Growing of Rubber Tree', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01294', 'Growing of Jatropha Tree', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01295', 'Growing of Ornamental or Decorative Trees such as Christmas or Pine Trees, Fire Trees, Etc.', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01296', 'Growing of Oleaginous Fruits, Except Coconut', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01297', 'Growing of Bush Fruits, Including Strawberries', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01299', 'Growing of Other Fruits and Perennial Crops, N.e.c.', NULL, '0129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01300', 'Plant Propagation\n\nThis class includes the production of vegetative planting materials including cuttings, suckers and seedlings for direct plant propagation or to create plant grafting stock into which selected scion is grafted for eventual planting to produce crops.', NULL, '0130');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01411', 'Beef Cattle Farming (Including Feed Lot Fattening)', NULL, '0141');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01412', 'Carabao Farming', NULL, '0141');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01420', 'Raising of Horses and Other Equines\n', 'This class includes raising and breeding of horses (including racing horses), asses, mules or hinnies.', '0142');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01430', 'Dairy Farming\n', 'This class includes processing of dairy products done in the farm such as milk, butter, cottage, cheese, etc.', '0143');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01441', 'Sheep Farming Including Sheep Shearing by the Owner', NULL, '0144');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01442', 'Goat Farming', NULL, '0144');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01443', 'Deer Faming', NULL, '0144');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01450', 'Hog Raising', NULL, '0145');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01461', 'Raising (Farming) of Chicken, Broiler', NULL, '0146');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01462', 'Raising (Farming) of Chicken, Layer', NULL, '0146');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01463', 'Raising (Farming) of Chicken, Native', NULL, '0146');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01471', 'Raising of Duck Broiler', NULL, '0147');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01472', 'Raising of Quail', NULL, '0147');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01473', 'Raising of Turkey', NULL, '0147');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01474', 'Raising of Pigeon', NULL, '0147');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01475', 'Raising of Game Fowl', NULL, '0147');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01476', 'Raising of Duck Layer', NULL, '0147');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01479', 'Raising of Poultry (Except Chicken), N.e.c.', NULL, '0147');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01481', 'Chicken Egg Production', NULL, '0148');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01482', 'Duck Egg Production', NULL, '0148');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01483', 'Quail Egg Production', NULL, '0148');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01489', 'Production of Eggs, N.e.c.', NULL, '0148');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01491', 'Sericulture (Silkworm Culture for the Production of Cocoon)', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01492', 'Apiary (Bee Culture for the Production of Honey)', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01493', 'Vermiculture', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01494', 'Crocodile/alligator Farming', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01495', 'Rabbit Farming', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01496', 'Raising of Semi-domesticated or Wild Animals Including Birds, Reptiles, Insects (E.g. Butterfly) and Turtles', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01497', 'Raising and Breeding of Cats and Dogs', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01498', 'Game Propagation and Breeding Activities', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01499', 'Raising of Other Animals, N.e.c.', NULL, '0149');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01511', 'Operation of Irrigation Systems Through Cooperatives', NULL, '0151');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01512', 'Operation of Irrigation Systems Through Non-cooperatives', NULL, '0151');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01520', 'Planting, Transplanting and Other Related Activities', NULL, '0152');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01531', 'Plowing, Seeding, Weeding, Thinning, Pruning and Similar Services', NULL, '0153');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01532', 'Fertilizer Applications', NULL, '0153');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01533', 'Chemical and Mechanical Weed Control, Disease and Pest Control Services', NULL, '0153');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01534', 'Services to Establish Crops, Promote Their Growth and Protect Them from Pests and Diseases, N.e.c.', NULL, '0153');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01540', 'Harvesting, Threshing, Grading, Bailing and Related Services', NULL, '0154');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01550', 'Rental of Farm Machinery with Drivers and Crew', NULL, '0155');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01561', 'Artificial Insemination Services', NULL, '0156');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01562', 'Contract Animal Growing Services on a Fee Basis', NULL, '0156');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01563', 'Egg-hatching, Sex Determination and Other Poultry Services', NULL, '0156');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01564', 'Services to Promote Propagation, Growth and Output of Animals', NULL, '0156');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01565', 'Farm Management Services', NULL, '0156');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01569', 'Other Support Activities for Animal Production, N.e.c.', NULL, '0156');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01571', 'Preparation of Crops for Primary Markets, I.e. Cleaning, Trimming, Grading, Disinfecting', NULL, '0157');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01572', 'Cotton Ginning', NULL, '0157');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01573', 'Preparation of Tobacco Leaves', NULL, '0157');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01574', 'Preparation of Coffee, Cacao and Cocoa Beans', NULL, '0157');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01575', 'Preparation of Abaca Fiber Including Stripping and Drying', NULL, '0157');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01581', 'Seed Processing for Propagation, Paddy Rice', NULL, '0158');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01589', 'Seed Processing for Propagation, Other Crops', NULL, '0158');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01701', 'Hunting and Trapping Wild Animals in the Forest', NULL, '0170');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01702', 'Production of Reptile Skins or Bird Skins and Other Animal Skins from Hunting Activities', NULL, '0170');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('01709', 'Hunting, Trapping and Other Related Activities, N.e.c.', NULL, '0170');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('02110', 'Growing of Timber Forest Species (E.g. Gmelina, Eucalyptus, Etc.), Planting, Replanting, Transplanting, Thinning and Conserving of Forest and Timber Tracts', NULL, '0211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('02120', 'Operation of Forest Tree Nurseries', NULL, '0212');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('02201', 'Production of Roundwood for Forest-based Manufacturing Industries', NULL, '0220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('02202', 'Production of Roundwood Used in an Unprocessed Form such as Pit-props, Fence Posts and Utility Poles', NULL, '0220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('02203', 'Firewood Cutting & Charcoal Making in the Forest', NULL, '0220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('02300', 'Gathering of Non-wood Forest Products\n', 'This class includes gathering of non-wood forest products and other plants growing in the wild.\nThis class includes :\nGathering of wild growing materials :\nmushrooms, truffles\nberries\nnuts\ncork\nlac and resins\nbalsams\nvegetable hair\neelgrass\nacorns, horse, chestnuts\nmosses and lichens\nThis class excludes :\nManaged production of any of these products (except of cork trees), see division 01;\nGrowing of mushrooms or truffles, see 0118;\nGrowing of berries and nuts, see 0129;\nGathering of fire wood, see 0220.', '0230');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('02400', 'Support Services to Forestry\n', '\nThis includes the activities in support of forestry operation on a fee or contract basis :\nThis class includes :\nForestry service activities :\nforestry inventories\nforest management consulting services\ntimber evaluation\nforest fire fighting and protection\nforest pest control\nLogging service activities : transport of logs within the forest\nThis class excludes operation of forest tree nurseries, see 021.', '0240');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03111', 'Ocean Fishing, Commercial (Using Vessels Over 3 Tons)', NULL, '0311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03112', 'Coastal Fishing, Municipal (Using Vessels of Less Than 3 Tons)', NULL, '0311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03113', 'Fish Corral Fishing', NULL, '0311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03121', 'Catching Fish, Crabs and Crustaceans in Inland Waters', NULL, '0312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03122', 'Gathering Shells and Clams, Edible, in Inland Waters', NULL, '0312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03129', 'Other Freshwater Fishing Activities, N.e.c.', NULL, '0312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03130', 'Support Service Activities Incidental to Fishing', NULL, '0313');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03211', 'Operation of Freshwater Fishpond, Except Fish Breeding Farms and Nurseries', NULL, '0321');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03212', 'Operation of Freshwater Fish Pens and Fish Cage', NULL, '0321');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03213', 'Operation of Freshwater Fish Breeding Farms and Nurseries', NULL, '0321');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03214', 'Culture of Freshwater Ornamental Fish', NULL, '0321');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03219', 'Other Freshwater Fish Farming Activities', NULL, '0321');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03221', 'Operation of Marine Fish Tanks, Pens, Cage Except Fish Breeding Farms and Nurseries in Sea Water', NULL, '0322');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03222', 'Operation of Marine Fish Breeding Farms and Nurseries', NULL, '0322');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03223', 'Catching and Culturing Ornamental (Aquarium) Fish', NULL, '0322');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03224', 'Gathering of Fry', NULL, '0322');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03229', 'Other Marine Fish Farming Activities', NULL, '0322');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03230', 'Prawn Culture in Brackish Water', NULL, '0323');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03241', 'Culture of Freshwater Crustaceans (Except Prawns), Bivalves, and Other Mollusks', NULL, '0324');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03242', 'Culture of Oysters, Other Bivalves and Other Mollusks in Sea Water', NULL, '0324');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03251', 'Pearl Culture', NULL, '0325');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03252', 'Pearl Shell Gathering', NULL, '0325');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03261', 'Seaweeds Farming', NULL, '0326');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03262', 'Gathering of Laver and Other Seaweeds', NULL, '0326');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03291', 'Frog Farming', NULL, '0329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03292', 'Operation of Marine Worm Farms', NULL, '0329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('03299', 'Other Aquaculture Activities, N.e.c', NULL, '0329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('05100', 'Mining of Hard Coal\n', '\nThis class includes :\nMining of hard coal : underground or surface mining, including mining through liquefaction methods\nCleaning, sizing, grading, pulverizing, compressing etc. of coal to classify, improve quality or facilitate transport\nThis class also includes recovery of hard coal from culm banks.\nThis class excludes :\nLignite mining, see 0520;\nPeat digging and agglomeration of peat, see 0892;\nTest drilling for coal mining, see 0990;\nSupport activities for hard coal mining, see 0990;\nCoke ovens producing solid fuels, see 1910;\nManufacture of hard coal briquettes, see 1920;\nWork performed to develop or prepare properties for coal mining, see 4312', '0510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('05200', 'Mining of Lignite\n', 'This class includes :\nMining of lignite (brown coal): underground or surface mining, including mining through liquefaction methods\nWashing, dehydrating, pulverizing, compressing of lignite to improve quality, facilitate, transport or storage\nThis class excludes :\nHard coal mining, see 0510;\nPeat digging and agglomeration of peat, see 0892;\nTest drilling for coal mining, see 0990;\nSupport activities for hard coal mining, see 0990;\nCoke ovens producing solid fuels, see 1910;\nManufacture of hard coal briquettes, see 1920;\nWork performed to develop or prepare properties for coal mining, see 4312.', '0520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('06100', 'Extraction of Crude Petroleum\n', 'This class includes :\nExtraction of crude petroleum oils\nExtraction of bituminous or oil shale and tar sand\nProduction of crude petroleum from bituminous shale and sand\nProcess to obtain crude oils; decantation, desalting, dehydration, stabilization, etc.\nThis class excludes :\nSupport activities for oil and gas extraction, see 0910;\nOil and gas exploration, see 0910;\nManufacture of refined petroleum products, see 1920;\nRecovery of liquified petroelum gases in the refining of petroleum, see 1920;\nOperation of pipelines, see 4930', '0610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('06200', 'Extraction of Natural Gas\n', '\nThis class includes :\nProduction of crude gaseous hydrocarbon (natural gas)\nExtraction of condensates\nDraining and separation of liquid hydrocarbon fractions\nGas desulphurization\nThis class also includes mining of hydrocarbon liquids, obtained through liquefaction or pyrolysis\nThis class excludes :\nSupport activities for oil and gas extraction, see 0910;\nOil and gas exploration, see 0910;\nManufacture of refined petroleum products, see 1920;\nRecovery of liquified petroelum gases in the refining of petroleum, see 1920;\nManufacture of industrial gases, see 2011;\nOperation of pipelines, see 4930.', '0620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07100', 'Mining of Iron Ores\n', '\nThis class includes :\nMining of ores valued chiefly for iron content\nBeneficiation and agglomeration of iron ores\nThis class excludes extraction and preparation of pyrites and pyrrhotite (except roasting), see 0891.', '0710');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07210', 'Mining of Uranium and Thorium Ores\n', '\nThis class includes :\nMining of ores chiefly valued for uranium and thorium content: pitchblende etc.\nConcentration of such ores\nProduction of yellow cake\nThis class excludes:\nEnrichment of uranium and thorium ores, see 2011;\nProduction of uranium metal from pitchblende or other ores, see 2420;\nSmelting and refining of uranium, see 2420.', '0721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07221', 'Gold Ore Mining', NULL, '0722');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07222', 'Silver Ore Mining', NULL, '0722');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07229', 'Mining of Other Precious Metal Ores', NULL, '0722');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07291', 'Copper Ore Mining', NULL, '0729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07292', 'Chromite Ore Mining', NULL, '0729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07293', 'Manganese Ore Mining', NULL, '0729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07294', 'Nickel Ore Mining', NULL, '0729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('07299', 'Mining of Other Non-ferrous Metal Ores, N.e.c.', NULL, '0729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08101', 'Marble Quarrying', NULL, '0810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08102', 'Limestone Quarrying', NULL, '0810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08103', 'Stone Quarrying, Except Limestone and Marble', NULL, '0810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08104', 'Clay Quarrying', NULL, '0810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08105', 'Sand and Gravel Quarrying', NULL, '0810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08106', 'Silica Sand and Silica Stone Quarrying', NULL, '0810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08109', 'Stone Quarrying, Clay and Sand Pits, N.e.c.', NULL, '0810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08911', 'Baryte Mining', NULL, '0891');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08912', 'Guano Gathering', NULL, '0891');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08913', 'Pyrite Mining', NULL, '0891');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08914', 'Rock Phosphate Mining', NULL, '0891');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08915', 'Sulphur Mining', NULL, '0891');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08919', 'Other Chemical and Fertilizer Mineral Mining', NULL, '0891');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08920', 'Extraction of Peat\n', 'This class includes :\nPeat digging\nPeat agglomeration\nPreparation of peat to improve quality or facilitate transport or storage\nThis class excludes :\nService activities incidental to peat mining, see 0990;\nManufacture of articles of peat, see 2399', '0892');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08930', 'Extraction of Salt\n', 'This class includes :\nExtraction of salt from underground including by dissolving and pumping\nSalt production by evaporation of sea water or other saline waters\nCrushing, purification and refining of salt by the producer\nThis class excludes :\nProcessing of salt into food-grade salt, e.g. iodized salt, see 1079;\nPotable water production by evaporation of saline water, see 3600.', '0893');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('08990', 'Other Mining and Quarrying, N.e.c.\n', 'This class includes mining and quarrying of various minerals and materials : abrasive materials, asbestos, siliceous fossil meals, natural graphite, steatite (talc), feldspar etc.; gemstones, quartz, mica, etc.', '0899');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('09101', 'Oil and Gas Extraction Activities on a Fee or Contract Basis', NULL, '0910');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('09102', 'Oil and Gas Extraction Activities Not Performed on a Fee or Contract Basis', NULL, '0910');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('09900', 'Support Activities for Other Mining and Quarrying\n', '\nThis class includes :\nSupport services on a fee or contract basis, required for mining activities of divisions 05, 07 & 08 :\nexploration services, e.g. traditional prospecting methods, such as taking core samples and making geological observations as prospective sites\ndraining and pumping services, on a fee or contract basis\ntest drilling and test hole boring\nThis class excludes :\nOperating mines or quarries on a contract or fee basis, see division 05,07,08;\nSpecialized repair of mining machinery, see 3312;\nGeophysical surveying services, on a contract or fee basis, see 7110.', '0990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10110', 'Slaughtering and Meat Packing\n', '\nThis class includes :\nOperation of slaughterhouses engaged in killing, dressing or packing meat of cattle, hogs, sheep, goats, horses, poultry, rabbits, game or other animals including whales processed on land or on vessels specialized for this work\nProduction or by-products such as raw hides and skins\nProduction of pulled wool\nProduction of feathers and down', '1011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10121', 'Production, Processing and Preserving of Meat and Meat Products Including Tocino, Tapa, Ham, Bacon, Sausage, Longanisa, Corned Beef, Hotdog, Meat Loaf, and Bologna', NULL, '1012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10122', 'Production of Fresh, Chilled or Frozen Meat or Poultry', NULL, '1012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10123', 'Rendering of Lard and Other Edible Fats of Animal Origin', NULL, '1012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10124', 'Production of Flours and Meals of Meat or Meat Offal', NULL, '1012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10129', 'Production, Processing and Preserving of Meat and Meat Products, N.e.c.', NULL, '1012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10201', 'Canning/packing of Fish and Other Marine Products', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10202', 'Drying of Fish and Other Marine Products', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10203', 'Smoking of Fish (Tinapa) and Other Marine Products', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10204', 'Manufacture of Fish Paste (Bagoong) and Fish Sauce (Patis)', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10205', 'Processing of Seaweeds; Manufacture of Agar-agar or Carrageenan', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10206', 'Production of Fishmeal/prawn Feeds', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10207', 'Manufacture of Unprepared Animal Feeds from Fish, Crustaceans and Mollusks and Other Aquatic Animals', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10209', 'Processing, Preserving and Canning of Fish, Crustacean and Mollusks, N.e.c.', NULL, '1020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10301', 'Canning/packing and Preserving of Fruits and Fruit Juices', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10302', 'Canning/packing and Preserving of Vegetables and Vegetable Juices', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10303', 'Manufacture of Fruit and Vegetable Sauces (E.g. Tomato Sauce and Paste)', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10304', 'Quick-freezing of Fruits and Vegetables', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10305', 'Manufacture of Potato Flour and Meal', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10306', 'Roasting of Nut or Manufacture of Nut Foods and Pastes', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10307', 'Manufacture of Perishable Prepared Foods of Fruit and Vegetables, such As: Salad, Peeled or Cut Vegetables, Tofu (Bean Curd)', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10308', 'Manufacture of Desiccated Coconut', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10309', 'Processing and Preserving of Fruits and Vegetables, N.e.c.', NULL, '1030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10410', 'Manufacture of Virgin Coconut Oil', NULL, '1041');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10440', 'Production of Crude Vegetable Oil, Cake and Meals, Other Than Virgin Coconut Oil (See Class 1041)', NULL, '1044');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10450', 'Manufacture of Refined Coconut and Other Vegetable Oil (Including Corn Oil) and Margarine', NULL, '1045');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10460', 'Manufacture of Fish Oil and Other Marine Animal Oils', NULL, '1046');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10470', 'Manufacture of Unprepared Animal Feeds from Vegetable, Animal Oils and Fats', NULL, '1047');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10490', 'Manufacture of Vegetable and Animal Oil and Fats, N.e.c.', NULL, '1049');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10510', 'Processing of Fresh Milk and Cream', NULL, '1051');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10520', 'Manufacture of Powdered Milk (Except for Infants) and Condensed or Evaporated Milk (Filled, Combined or Reconstituted)', NULL, '1052');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10530', 'Manufacture of Infantsnull Powdered Milk', NULL, '1053');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10540', 'Manufacture of Butter, Cheese and Curd', NULL, '1054');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10550', 'Manufacture of Ice Cream and Sherbet, Ice Drop, Ice Candy and Other Flavored Ices', NULL, '1055');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10560', 'Manufacture of Milk-based Infantsnull and Dietetic Foods', NULL, '1056');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10570', 'Manufacture of Yoghurt', NULL, '1057');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10580', 'Manufacture of Whey', NULL, '1058');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10590', 'Manufacture of Dairy Products, N.e.c.', NULL, '1059');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10610', 'Rice/corn Milling\n', 'This includes rice milling, husked, milled, polished, glazed, parboiled or converted; production of rice flour, and corn milling.', '1061');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10621', 'Cassava Flour Milling', NULL, '1062');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10622', 'Flour Milling Except Cassava Flour Milling', NULL, '1062');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10623', 'Manufacture of Cereal Breakfast Foods Obtained by Roasting or Swelling, Etc.', NULL, '1062');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10624', 'Manufacture of Unprepared Animal Feeds from Grain Milling Residues', NULL, '1062');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10625', 'Manufacture of Flour Mixes and Prepared Blended Flour and Dough for Bread, Cakes, Biscuits or Pancakes', NULL, '1062');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10629', 'Manufacture of Grain and Vegetable Mill Products, N.e.c.', NULL, '1062');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10630', 'Manufacture of Starches and Starch Products\n', 'This class includes :\nManufacture of starches from rice, potatoes, maize, etc.\nWet corn milling\nManufacture of glucose, glucose syrup, maltose, inulin, etc.\nManufacture of gluten\nManufacture of tapioca and tapioca substitutes prepared from starch\nManufacture of corn oil\nThis class excludes :\nManufacture of lactose milk (milk sugar), see 1059;\nProduction of cane or beet sugar, see 1072.', '1063');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10711', 'Baking of Bread, Cakes, Pastries, Pies and Similar \"perishable\" Bakery Products, Including Hopia and Doughnut Making', NULL, '1071');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10712', 'Baking of Biscuits Cookies, Crackers, Pretzels and Similar Dry Bakery Products', NULL, '1071');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10713', 'Manufacture of Ice Cream Cones (Apa) and Wafers (Barquillos)', NULL, '1071');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10714', 'Manufacture of Snack Products such as Corn Curls, Wheat Crunchies and Similar Products', NULL, '1071');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10721', 'Sugarcane Milling', NULL, '1072');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10722', 'Sugar Refining', NULL, '1072');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10723', 'Manufacture of Muscovado Sugar Not Carried on in the Farm', NULL, '1072');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10724', 'Manufacture of Molasses', NULL, '1072');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10725', 'Manufacture of Coconut Sap Sugar', NULL, '1072');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10726', 'Manufacture of Palm Sugar (Buri, Nipa), Except Coconut', NULL, '1072');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10729', 'Manufacture of Sugar, N.e.c.', NULL, '1072');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10731', 'Manufacture of Chocolate and Cocoa Products Including Chocolate Candies', NULL, '1073');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10732', 'Manufacture of Candies (Excluding Chocolate Candies) and Chewing Gum', NULL, '1073');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10733', 'Manufacture of Popcorn and Poprice', NULL, '1073');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10739', 'Manufacture of Chocolate and Sugar Confectionery Products, N.e.c.', NULL, '1073');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10740', 'Manufacture of Macaroni, Noodles, Couscous and Similar Farinaceous Products\n', '\nThis class includes :\nManufacture of pastas such as macaroni, spaghetti, etc. and noodles including instant noodles, misua, bihon, vermicelli (sotanghon), whether or not cooked or stuffed\nManufacture of couscous\nManufacture of canned or frozen pasta products\nThis class excludes :\nManufacture of prepared couscous dishes, see 1075;\nManufacture of soup containing pasta, see 1079.', '1074');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10750', 'Manufactured of Prepared Meals and Dishes\n', '\nThis class includes manufacture of ready-made (i.e. prepared, seasoned and cooked) meals and dishes, in frozen or canned form. These dishes are usually packaged and labeled for re-sale, i.e. this class does not include the preparation of meals for immediate consumption, such as in restaurants.\nThis class includes :\nManufacture of fresh or frozen meat or poultry dishes\nManufacture of canned stews, canned or bottled vegetables and vacuum prepared meals\nManufacture of other prepared meals (such as \"TV dinners\", etc.)\nManufacture of frozen fish dishes, including fish and chips\nManufacture of prepared dishes of vegetables\nManufacture of frozen pizza\nThis class excludes :\nPreparation of meals and dishes for immediate consumption, see division 56;\nActivities of food service contractors, see 5629.', '1075');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10760', 'Manufacture of Food Supplements from Herbs and Other Plants', NULL, '1076');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10770', 'Coffee Roasting and Processing\n', '\nThis class includes :\nCoffee roasting, grinding, decaffeinating or packing\nManufacture of coffee substitutes containing coffee\nManufacture of extracts, essences or concentrates of coffee and preparations with a basis of these products\nChicory roasting and preparation of other roasted coffee substitutes and their essences, extracts or concentrates', '1077');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10781', 'Manufacture of Nata De Coco', NULL, '1078');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10782', 'Manufacturing of Native Delicacies or \"kakanin\" E.g., Bibingka, Puto, Suman, Kalamay, Binagol, Moron and Other Similar Products', NULL, '1078');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10791', 'Manufacture of Herb from Drying and Further Extraction (E.g. Banaba, Ampalaya, Moringa (Malunggay), Sambong, Lagundi Etc.)', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10792', 'Manufacture of Ice, Except Dry Ice', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10793', 'Manufacture of Soup Containing Meat, Fish, Crustaceans, Mollusks or Pasta', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10794', 'Manufacture of Infant or Dietetic Foods Containing Homogenized Ingredients', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10795', 'Egg Processing Including Fertilized Egg (Balut) and Salted Eggs', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10796', 'Manufacture of Flavoring Extracts and Food Coloring', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10797', 'Manufacture of Mayonnaise, Salad Dressing, Sandwich Spread and Similar Products', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10798', 'Manufacture of Vinegar', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10799', 'Manufacture of Food Products, N.e.c.', NULL, '1079');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('10800', 'Manufacture of Prepared Animal Feeds\n', '\nThis class includes :\nManufacture of prepared feeds for pets, including dogs, cats, birds, fish, etc.\nManufacture of prepared feeds for farm animals, including animal feed concentrated and feed supplements\nPreparation consisting of mixtures of materials or of materials specially treated or packaged to make them suitable as feed for dogs, cats, birds, fish or other pet animals\nPreparation of unmixed (single) feeds for farm animals\nTreatment of slaughter waste to produce animal feeds\nThis class excludes :\nProduction of fishmeal for animal, see 1020;\nProduction of oilseed cake, see 1041;\nActivities resulting in by-products usable as animal feed without special treatment, e.g. oil seeds (see 1040), grain milling residues (see 1062).', '1080');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11010', 'Distilling, Rectifying and Blending of Spirits\n', '\nThis class includes :\nManufacture of distilled, potable, alcoholic beverages: whisky, brandy, gin, liquors, \"mixed drinks\", etc.\nBlending of distilled spirits\nProduction of neutral spirits\nThis class excludes :\nManufacture of ethyl alcohol, see 2011;\nManufacture of non-distilled alcoholic beverages, see 1102, 1103;\nMerely bottling and labeling , see 4630 (if performed as part of wholesale) and 8292 (if performed on a fee or contract basis).', '1101');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11021', 'Fruit Wine Manufacturing', NULL, '1102');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11029', 'Wine Manufacturing, N.e.c.', NULL, '1102');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11030', 'Manufacture of Malt Liquors and Malt\n', '\nThis class includes :\nManufacture of malt liquors, such as beer, ale, porter and stout\nManufacture of malt\nManufacture of low alcohol or non-alcoholic beer', '1103');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11041', 'Manufacture of Soft Drinks Except Drinks Flavored with Fruit Juices, Syrups or Other Materials', NULL, '1104');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11042', 'Manufacture of Drinks Flavored with Fruit Juices, Syrups or Other Materials', NULL, '1104');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11051', 'Manufacture of Bottled Drinking Water', NULL, '1105');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11052', 'Manufacture of Carbonated Water', NULL, '1105');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11053', 'Water Purifying and Refilling Station', NULL, '1105');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11059', 'Manufacture of Drinking Water and Mineral Water, N.e.c.', NULL, '1105');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11060', 'Manufacture of Sports and Energy Drink', NULL, '1106');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('11090', 'Manufacture of Other Beverages, N.e.c.', NULL, '1109');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('12010', 'Manufacture of Cigarettes', NULL, '1201');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('12020', 'Manufacture of Cigars', NULL, '1202');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('12030', 'Manufacture of Chewing and Smoking Tobacco, Snuff', NULL, '1203');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('12040', 'Curing and Redrying Tobacco Leaves', NULL, '1204');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('12090', 'Tobacco Manufacturing, N.e.c.', NULL, '1209');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13111', 'Spinning', NULL, '1311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13112', 'Texturizing', NULL, '1311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13113', 'Manufacture of Paper Yarn', NULL, '1311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13119', 'Preparation of Textiles, N.e.c.', NULL, '1311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13120', 'Weaving of Textiles\n', '\nThis class includes :\nManufacture of broad woven cotton-type, woolen type, worsted-type or silk-type fabrics, including from mixtures or artificial or synthetic yarns\nManufacture of other broad woven fabrics, using flax, ramie, hemp, jute, bast fibers and special yarns\nManufacture of woven pile or chenille fabrics, terry toweling, gauze etc.\nManufacture of woven fabrics of glass fibers\nManufacture of woven carbon and aramid threads\nManufacture of imitation fur by weaving\nThis class excludes :\nManufacture of textile floor coverings, see 1393;\nManufacture of non-woven fabrics and felts, see 1399;\nManufacture of narrow fabrics, see 1399;\nManufacture of knitted and crocheted fabrics, see 1391.', '1312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13130', 'Finishing of Textiles\n', '\nThis class includes :\nBleaching and dyeing of textile fibers, yarns, fabrics and textile articles, including wearing apparel\nDressing, drying, steaming, shrinking, mending, Sanforizing, mercerizing of textiles and textile articles, including wearing apparel\nBleaching of jeans\nPleating and similar work on textiles\nWaterproofing, coating, rubberizing, or impregnating purchased garments\nSilk screen- printing on textiles and wearing apparel\nThis class excludes :\nManufacture of textile fabric impregnated, coated, covered or laminated with rubber, where the rubber is the chief constituent, see 2219.', '1313');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13140', 'Preparation and Finishing of Textiles (Integrated)', NULL, '1314');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13910', 'Manufacture of Knitted and Crocheted Fabrics\n', '\nThis class includes :\nManufacture and processing of knitted or crocheted fabrics : pile and terry fabrics; net and window furnishing type fabrics knitted on Raschel or similar machines, other knitted or crocheted fabrics\nManufacture of imitation fur by knitting\nThis class excludes :\nManufacture of net and window furnishing type fabrics of lace knitted on Raschel or similar machines, see 1399;\nManufacture of knitted and crocheted apparel, see 1430.', '1391');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13921', 'Manufacture of Textile Industrial Bags', NULL, '1392');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13922', 'Manufacture of Made-up Textile Goods for House Furnishings', NULL, '1392');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13923', 'Manufacture of Canvas Products', NULL, '1392');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13929', 'Manufacture of Made-up Textile Articles, Except Wearing Apparel, N.e.c.', NULL, '1392');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13931', 'Manufacture of Carpets and Rugs, Except Mats of Textile Materials', NULL, '1393');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13932', 'Manufacture of Mats (Including Mattings) of Textile Materials', NULL, '1393');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13941', 'Manufacture of Cordage, Rope, and Twine', NULL, '1394');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13942', 'Manufacture of Fishing Nets and Other Nettings, (Excluding Mosquito and Hairnets)', NULL, '1394');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13943', 'Manufacture of Products of Cordage, Rope and Twine', NULL, '1394');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13950', 'Manufacture of Embroidered Fabrics', NULL, '1395');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13991', 'Manufacture of Narrow Fabrics, Laces, Tulles and Other Net Fabrics', NULL, '1399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13992', 'Manufacture of Felt and Non-woven Fabrics', NULL, '1399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13993', 'Manufacture of Fabrics, Impregnated, Coated, Covered or Laminated with Plastic', NULL, '1399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13994', 'Manufacture of Fabrics, Impregnated, Coated, Covered or Laminated Other Than with Plastic and Rubber', NULL, '1399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13995', 'Manufacture of Fabrics for Industrial Use (Wicks and Gas Mantles)', NULL, '1399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13996', 'Manufacture of Fiber Batting, Padding and Upholstery Filling Including Coir', NULL, '1399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('13999', 'Manufacture of Miscellaneous Textiles, N.e.c.', NULL, '1399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14110', 'Mennulls and Boynulls Garment Manufacturing', NULL, '1411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14120', 'Womennulls and Girlnulls Garment Manufacturing', NULL, '1412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14130', 'Ready-made Embroidered Garments Manufacturing', NULL, '1413');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14140', 'Babiesnull Garment Manufacturing', NULL, '1414');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14191', 'Manufacture of Raincoats by Cutting or Sewing Except Rubber or Plastics', NULL, '1419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14192', 'Manufacture of Hats, Gloves, Handkerchiefs, Neckwear and Belts Regardless of Material', NULL, '1419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14193', 'Manufacture of Sportswear', NULL, '1419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14199', 'Manufacture of Wearing Apparel, N.e.c', NULL, '1419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14210', 'Custom Tailoring', NULL, '1421');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14220', 'Custom Dressmaking', NULL, '1422');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14301', 'Manufacture of Knitted and Crocheted Apparel', NULL, '1430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14302', 'Manufacture of Knitted or Crocheted Hosiery, Underwear and Outerwear When Knitted or Crocheted Directly Into Shape', NULL, '1430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14309', 'Manufacture of Knitted and Crocheted Articles, N.e.c.', NULL, '1430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('14400', 'Manufacture of Articles of Fur', NULL, '1440');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15110', 'Tanning and Dressing of Leather\n', '\nThis class includes :\nManufacture of chamois dressed, parchment dressed, patent or metallized leathers\nManufacture of composition leather, i.e. slabs, sheets or strip of a material with a basis of leather or leather fiber\nThis class excludes :\nProduction of hides and skins as part of ranching, see 014;\nProduction of hides and skins as part of slaughtering, see 1011;\nManufacture of leather apparel, see 141;\nManufacture of imitation leather not based on natural leather, see 2219, 2220.', '1511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15121', 'Manufacture of Luggage, Handbags and Wallets of Leather and Imitation Leather', NULL, '1512');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15129', 'Manufacture of Products of Leather and Imitation Leather, N.e.c.', NULL, '1512');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15210', 'Manufacture of Leather Shoes', NULL, '1521');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15220', 'Manufacture of Rubber Shoes', NULL, '1522');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15230', 'Manufacture of Plastic Shoes', NULL, '1523');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15240', 'Manufacture of Shoes Made of Textile Materials with Applied Soles', NULL, '1524');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15250', 'Manufacture of Wooden Footwear and Accessories', NULL, '1525');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15291', 'Manufacture of Rubber Slippers', NULL, '1529');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15292', 'Manufacture of Slippers and Sandals, Other Than Rubber', NULL, '1529');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15293', 'Manufacture of Leather Parts of Footwear', NULL, '1529');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('15299', 'Manufacture of Other Footwear, N.e.c.', NULL, '1529');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16101', 'Manufacture of Rough Lumber', NULL, '1610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16102', 'Manufacture of Worked Lumber', NULL, '1610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16103', 'Wood Preserving and Drying', NULL, '1610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16109', 'Sawmilling and Planing of Wood Products, N.e.c.', NULL, '1610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16211', 'Manufacture of Veneer Sheets and Plywood', NULL, '1621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16212', 'Manufacture of Laminboard, Particle Board and Other Panels and Board', NULL, '1621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16220', 'Manufacture of Wooden Window and Door Screens, Shades and Venetian Blinds', NULL, '1622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16230', 'Manufacture of Other Buildersnull Carpentry and Joinery; Millworking', NULL, '1623');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16240', 'Manufacture of Wooden Containers\n', '\nThis class includes :\nManufacture of packing cases, boxes, crated, drums and similar packings of wood\nManufacture of pallets, box pallets and other load boards of wood\nManufacture of barrels, vats, tubs and other cooperNULLs products of wood\nManufacture of wooden cable-drums.\nThis class excludes :\nManufacture of luggage, see 1512;\nManufacture of cases of plaiting material, see 1629.', '1624');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16250', 'Manufacture of Wood Carvings', NULL, '1625');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16260', 'Manufacture of Charcoal Outside the Forest', NULL, '1626');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16270', 'Manufacture of Wooden Wares', NULL, '1627');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16281', 'Manufacture of Rattan and Cane Containers', NULL, '1628');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16282', 'Manufacture of Sawali, Nipa and Split Canes', NULL, '1628');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16283', 'Manufacture of Mats, Matting or Screen', NULL, '1628');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16284', 'Manufacture of Small Cane Wares', NULL, '1628');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16285', 'Manufacture of Articles of Cork, Straw and Plaiting Materials', NULL, '1628');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16289', 'Manufacture of Other Products of Bamboo, Cane, Rattan and the Like, and Plaiting Materials Except Furniture, N.e.c.', NULL, '1628');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('16290', 'Manufacture of Other Products of Wood; Manufacture of Articles of Cork and Plaiting Materials, Except Furniture, N.e.c.', NULL, '1629');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17011', 'Integrated Pulp, Paper and Paperboard Milling', NULL, '1701');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17012', 'Pulp Milling', NULL, '1701');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17013', 'Paper and Paperboard Milling', NULL, '1701');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17014', 'Manufacture of Hand-made Paper', NULL, '1701');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17019', 'Manufacture of Pulp, Paper and Paperboard, N.e.c.', NULL, '1701');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17020', 'Manufacture of Corrugated Paper and Paperboard and of Containers of Paper and Paperboard\n', '\nThis class includes :\nManufacture of corrugated paper and paperboard\nManufacture of containers of corrugated paper and paperboard\nManufacture of folding paperboard containers\nManufacture of containers of solid board\nManufacture of other containers of paper and paperboard\nManufacture of sacks and bags of paper\nManufacture of office box files and similar articles\nThis class excludes :\nManufacture of envelopes, see 1709;\nManufacture of molded or pressed articles of paper pulp (e.g. boxes for packing eggs, molded pulp paper plates), see 1709.', '1702');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17091', 'Manufacture of Household and Personal Hygiene Paper and Cellulose Wadding Products', NULL, '1709');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17092', 'Manufacture of Wadding of Textile Materials and Articles of Wadding (E.g. Sanitary Towels, Tampons, Etc.)', NULL, '1709');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17093', 'Manufacture of Other Articles of Paper', NULL, '1709');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('17099', 'Manufacture of Other Articles of Paperboard', NULL, '1709');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('18110', 'Printing\n', '\nThis class includes :\nPrinting of newspapers, magazines and other periodicals, books and brochures, music and music manuscripts, maps, atlases, posters, advertising catalogues, prospectuses and other printed advertising, postage stamps, taxation stamps, documents of title, cheques and other security papers, registers, albums, diaries, calendars, business forms and other commercial printed matter, personal stationery and other printed matter by letterpress, offset, photogravure, flexographic and other printing presses, duplication machines, computer printers, embossers, etc., including quick printing.\nPrinting directly into textiles, plastic, glass, metal, wood and ceramics (except silk-screen printing on textiles and wearing apparel).\nThe material printed is typically copyrighted.\nThis class also includes :\nPrinting on labels or tags (lithographic, gravure printing, flexographic printing, others).\nThis class excludes :\nSilk screen-printing on textiles and wearing apparel, see 1313;\nManufacture of paper articles, such as binders, see 1709;\nPublishing of printed matter, see 581;\nPhotocopying of documents, see 8219.', '1811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('18121', 'Electrotyping, Stereotyping and Photoengraving', NULL, '1812');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('18122', 'Bookbinding and Related Work', NULL, '1812');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('18129', 'Service Activities Related to Printing, N.e.c.', NULL, '1812');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('18201', 'Reproduction of Video and Computer Tapes from Master Copies', NULL, '1820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('18202', 'Reproduction of Floppy, Hard or Compact Disks', NULL, '1820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('18203', 'Film and Video Reproduction', NULL, '1820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('19100', 'Manufacture of Coke Oven Products\n', '\nThis class includes :\nOperation of coke ovens\nProduction of coke and semi-coke\nProduction of pitch and pitch coke\nProduction coke oven gas\nProduction of crude coal and lignite tars\nAgglomeration of coke', '1910');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('19200', 'Manufacture of Refined Petroleum Products\n', '\nThis class includes the manufacture of liquid or gaseous fuels or other products from crude petroleum, bituminous minerals or their fractionation products. Petroleum refining involves one or more of the following activities: fractionation, straight distillation of crude oil, and cracking.\nThis class includes :\nProduction of motor fuel : gasoline, kerosene, etc.\nProduction of fuel: light, medium and heavy fuel oil, refinery gases such as ethane, propane, butane etc.\nManufacture of oil-based lubricating oils or greases, including from waste oil\nManufacture of products for the petrochemical industry and for the manufacture of road coverings\nManufacture of various products : white spirit, vaseline, paraffin wax, petroleum jelly, etc.\nManufacture of hard-coal and lignite fuel briquettes\nManufacture of petroleum briquettes\nBlending of biofuels, i.e. blending of alcohols with petroleum (e.g. gasohol)', '1920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('19900', 'Manufacture of Other Fuel Products', NULL, '1990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20111', 'Manufacture of Ethanol', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20112', 'Manufacture of Industrial (Compressed and Liquefied) Gases', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20113', 'Manufacture of Inorganic Salts and Compounds', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20114', 'Manufacture of Ethyl Alcohol', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20115', 'Manufacture of Alcohol Except Ethyl', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20116', 'Manufacture of Inorganic Acids, Alkalis and Chlorine', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20117', 'Manufacture of Organic Acids and Organic Compounds', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20119', 'Manufacture of Basic Chemicals, Except Fertilizers and Nitrogen Compounds, N.e.c.', NULL, '2011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20120', 'Manufacture of Fertilizers and Nitrogen Compounds\n', '\nThis class includes :\nManufacture of fertilizers : straight or complex nitrogenous, phosphatic or potassic fertilizers, urea, crude natural phosphates and crude natural potassium salts\nManufacture of associated nitrogen products : nitric and sulfonitric acids, ammonia, ammonium chloride, ammonium carbonate, nitrites and nitrates of potassium\nManufacture of potting soil with peat as main constituent\nManufacture of potting soil mixtures of natural soil, sand, clays and minerals\nThis class excludes :\nMining of guano, see 0891;\nManufacture of agro-chemical products, such as pesticides, see 2021;\nOperation of compost dumps, see 3821.', '2012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20131', 'Manufacture of Synthetic Rubber and Factice Derived from Oils, in Primary Forms', NULL, '2013');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20132', 'Production of Mixtures of Synthetic Rubber and Natural Rubber or Rubber-like Gums (E.g., Balata), in Primary Forms', NULL, '2013');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20133', 'Manufacture of Plastic Synthetic Resins', NULL, '2013');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20134', 'Manufacture of Plastic Materials Except Man-made Fiber and Glass Fiber', NULL, '2013');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20210', 'Manufacture of Pesticides and Other Agro-chemical Products\n', '\nThis class includes :\nManufacture of insecticides, rodenticides, fungicides, herbicides\nManufacture of anti-sprouting products, plant growth regulators\nManufacture of disinfectants (for agricultural and other use)\nManufacture of other agro-chemical products, n.e.c.\nThis class excludes manufacture of fertilizers and nitrogen compounds, see 2012.', '2021');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20221', 'Manufacture of Paints', NULL, '2022');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20222', 'Manufacture of Varnishes, Lacquers, Shellac and Stains', NULL, '2022');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20223', 'Manufacture of Paint Removers, Thinners, and Brush Cleaners', NULL, '2022');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20224', 'Manufacture of Pigments and Other Coloring Matter of a Kind Used in the Manufacture of Paints or by Artists or Other Painters', NULL, '2022');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20225', 'Manufacture of Printing Ink', NULL, '2022');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20229', 'Manufacture of Paint Products, N.e.c.', NULL, '2022');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20231', 'Manufacture of Soap and Detergents', NULL, '2023');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20232', 'Manufacture of Cleaning Preparations, Except Soap and Detergents', NULL, '2023');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20233', 'Manufacture of Waxes and Polishing Preparations', NULL, '2023');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20234', 'Manufacture of Perfumes, Cosmetics and Other Toilet Preparations', NULL, '2023');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20291', 'Manufacture of Explosives, Fireworks and Firecrackers', NULL, '2029');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20292', 'Manufacture of Matches', NULL, '2029');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20293', 'Manufacture of Writing and Drawing Ink', NULL, '2029');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20294', 'Manufacture of Glues and Adhesives', NULL, '2029');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20295', 'Manufacture of Activated Carbon', NULL, '2029');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20299', 'Manufacture of Miscellaneous Chemical Products, N.e.c.', NULL, '2029');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20301', 'Manufacture of Synthetic or Artificial Filament Yarn', NULL, '2030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('20302', 'Manufacture of Man-made Filament Tow or Staple Fibers, Except Glass Fiber', NULL, '2030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('21001', 'Manufacture of Drugs and Medicines Including Biological Products such as Bacterial and Virus Vaccines, Sera and Plasma', NULL, '2100');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('21002', 'Manufacture of Surgical Dressings, Medicated Wadding , Fracture Bandages, Catgut, and Other Prepared Sutures', NULL, '2100');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22111', 'Manufacture of Rubber Tires (Including Parts) and Tubes', NULL, '2211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22112', 'Retreading and Rebuilding of Tires', NULL, '2211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22191', 'Manufacture of Rubber Garments', NULL, '2219');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22192', 'Manufacture of Industrial and Other Molded Rubber Products, Excluding Tires and Tubes', NULL, '2219');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22199', 'Manufacture of Other Rubber Products, N.e.c.', NULL, '2219');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22201', 'Manufacture of Plastic Articles for Packing Goods (E.g. Boxes, Bags, Sacks, Etc)', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22202', 'Manufacture of Plastic Household Wares', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22203', 'Manufacture of Plastic Furniture Fittings', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22204', 'Manufacture of Plastic Pipes and Tubes', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22205', 'Manufacture of Other Plastic, Industrial /office/school Supplies', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22206', 'Manufacture of Primary Plastic Products (E.g. Sheets, Film, Plates, Etc.)', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22207', 'Manufacture of Linoleum and Hard Surface Floor Coverings', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22208', 'Manufacture of Plastic Window and Doorscreen, Shades and Venetian Blinds', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('22209', 'Manufacture of Plastics Products, N.e.c.', NULL, '2220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23101', 'Manufacture of Flat Glass (Including Float Glass)', NULL, '2310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23102', 'Manufacture of Glass Containers', NULL, '2310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23103', 'Manufacture of Glass Fibers (Including Glass Wool) and Yarn of Glass Fibers', NULL, '2310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23109', 'Manufacture of Glass and Glass Products, N.e.c.', NULL, '2310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23910', 'Manufacture of Refractory Products\n', '\nThis class includes :\nManufacture of refractory mortars, concretes etc.\nManufacture of refractory ceramic goods :\nheat-insulating ceramic goods of siliceous fossil meals\nrefractory bricks, blocks and tiles, etc.\nretorts, crucibles, muffles, nozzles, tubes, pipes, etc.\nManufacture of refractory articles containing magnesite, dolomite or chromite', '2391');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23920', 'Manufacture of Clay Building Materials\n', '\nThis class includes :\nManufacture of non-refractory ceramic hearth or wall tiles, mosaic cubes, etc.\nManufacture of non-refractory ceramic flags and paving\nManufacture of structural non-refractory clay building materials :\nceramic bricks, roofing tiles, chimney pots, pipes, conduits, etc.\nManufacture of flooring blocks in baked clay\nManufacture of ceramic sanitary fixtures\nThis class excludes :\nManufacture of artificial stone (e.g. cultured marble), see 2220;\nManufacture of refractory ceramic products, see 2391.', '2392');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23931', 'Manufacture of Vitreous China Tableware and Other Kitchen Articles of a Kind Commonly Used for Domestic or Toilet Purposes', NULL, '2393');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23932', 'Manufacture of Articles of Porcelain or China, Stoneware, Earthenware, Imitation Porcelain or Common Pottery', NULL, '2393');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23933', 'Manufacture of Coarse Clay Products', NULL, '2393');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23934', 'Manufacture of Sanitary Ware, Vitreous China Plumbing Fittings and Fixtures', NULL, '2393');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23939', 'Manufacture of Other Porcelain and Ceramic Products, N.e.c.', NULL, '2393');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23940', 'Manufacture of Cement\n', '\nThis group includes manufacture of clinkers and hydraulic cements, including Portland, aluminous cement, slag cement and superphosphate cements.\nThis class excludes :\nManufacture of refractory mortars, concrete, etc. see 2391;\nManufacture of cements used in dentistry, see 3250;\nManufacture of articles of cement, see 2396;\nManufacture of ready-mix and dry-mix concrete and mortars, see 2396.', '2394');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23951', 'Manufacture of Lime', NULL, '2395');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23952', 'Manufacture of Plaster', NULL, '2395');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23961', 'Manufacture of Structural Concrete Products', NULL, '2396');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23969', 'Manufacture of Articles of Concrete, Cement and Plaster, N.e.c.', NULL, '2396');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23970', 'Cutting, Shaping and Finishing of Stone\n', '\nThis class includes :\nCutting, shaping and finishing of stone for use in construction, in cemeteries, on roads, as roofing, etc.\nManufacture of stone furniture\nThis class excludes :\nProduction of rough cut stone, i.e. quarrying activities, see 0810;\nProduction of millstones, abrasives stones and similar products, see 2399;\nActivities of sculptors, see 9000.', '2397');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23991', 'Manufacture of Asphalt Products', NULL, '2399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23992', 'Manufacture of Asbestos Products', NULL, '2399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23993', 'Manufacture of Marble Products', NULL, '2399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23994', 'Manufacture of Abrasive Products', NULL, '2399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('23999', 'Manufacture of Miscellaneous Non-metallic Mineral Products, N.e.c.', NULL, '2399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24110', 'Operation of Blast Furnaces and Steel Making Furnaces', NULL, '2411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24121', 'Operation of Rolling Mills', NULL, '2412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24122', 'Pipes and Tubes Manufacturing, Iron or Steel', NULL, '2412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24123', 'Manufacture of Pipe Fittings of Iron or Steel', NULL, '2412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24124', 'Manufacture of Galvanized Steel Sheets, Tinplates and Other Coated Metal Products Made in Steel Works or Rolling Mills', NULL, '2412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24129', 'Operation of Steel Works and Rolling Mills, N.e.c.', NULL, '2412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24210', 'Gold and Other Precious Metal Refining', NULL, '2421');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24220', 'Non-ferrous Smelting and Refining , Except Precious Metals', NULL, '2422');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24230', 'Non-ferrous Rolling, Drawing and Extrusion Mills', NULL, '2423');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24240', 'Manufacture of Pipe Fittings of Non-ferrous Metals', NULL, '2424');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24290', 'Manufacture of Basic Precious and Other Non-ferrous Metals, N.e.c.', NULL, '2429');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24311', 'Casting/foundry of Iron', NULL, '2431');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24312', 'Casting/foundry of Steel', NULL, '2431');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24321', 'Aluminum and Aluminum Base Alloy Casting', NULL, '2432');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24322', 'Copper and Copper Base Alloy (Brass, Bronze) Casting', NULL, '2432');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24323', 'Zinc and Zinc Alloy Casting', NULL, '2432');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('24329', 'Casting of Non-ferrous Metal, N.e.c.', NULL, '2432');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25111', 'Manufacture of Structural Steel Products and Metal Components of Bridges, Smoke Stacks and Buildings', NULL, '2511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25112', 'Manufacture of Other Architectural and Related Metal Work (E.g., Doors, Windows, Shutters, Gates, Etc.)', NULL, '2511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25119', 'Manufacture of Structural Metal Products, N.e.c.', NULL, '2511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25120', 'Manufacture of Tanks, Reservoirs and Containers of Metal\n', '\nThis class includes :\nManufacture of reservoirs, tanks and similar containers of metal, of types normally installed as fixtures for storage or manufacturing use\nManufacture of metal containers for compressed or liquified gas\nManufacture of central heating boilers and radiators\nThis class excludes :\nManufacture of metal casks, drums, cans, pails, boxes, etc. of a kind normally used for carrying and packing of goods (irrespective of size), see 2599;\nManufacture of transport containers, see 2920;\nManufacture of tanks (armored military vehicles), see 3040.', '2512');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25130', 'Manufacture of Steam Generators, Except Central Heating Hot Water Boilers\n', '\nThis class includes :\nManufacture of steam or other vapor generators\nManufacture of auxiliary plant for use with steam generators: condensers, economizers, superheaters, steam collectors and accumulators\nManufacture of nuclear reactors, except isotope separators\nThe term \"nuclear reactor \" covers, in general, all the apparatus and appliances inside the area screened off by the biological shield, including , where appropriate the shield itself. The term also includes any other apparatus or appliances outside the area provided they form an integral part of those contained inside the screen.\nManufacture of parts for marine or power boilers\nThis class excludes :\nManufacture of central heating hot-water boilers and radiators, see 2512;\nManufacture of boiler-turbine sets, see 2811;\nManufacture of isotope separators, see 2829.', '2513');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25201', 'Manufacture of Small Arms and Accessories', NULL, '2520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25209', 'Manufacture of Weapons and Ammunitions, N.e.c.', NULL, '2520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25911', 'Forging, Pressing, Stamping and Roll-forming of Metal Products', NULL, '2591');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25912', 'Powder Metallurgy', NULL, '2591');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25920', 'Treatment and Coating of Metals; Machining\n', '\nThis class includes :\nPlating, anodizing, etc. of metals\nHeat treatment of metals\nDeburring, sandblasting, tumbling, cleaning of metals\nColoring and engraving of metals\nNon-metallic coating of metals: plasticizing, enamelling, lacquering, etc.\nHardening, buffing of metals\nBoring, turning, milling, eroding, planing, lapping, broaching, leveling, sawing, grinding, sharpening, polishing, welding, splicing, etc. of metalwork pieces\nCutting of and writing on metals by means of laser beams\nThis class excludes :\nActivities of farriers, see 0156;\nRolling precious metal onto base metals or other metals, see 242.', '2592');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25931', 'Manufacture of Cutlery', NULL, '2593');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25932', 'Manufacture of Hand Tools', NULL, '2593');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25933', 'Manufacture of General Hardware', NULL, '2593');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25934', 'Manufacture of Blacksmithing Tools and Welding Shop Operation', NULL, '2593');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25935', 'Manufacture of Molding Boxes for Metal Foundry', NULL, '2593');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25991', 'Manufacture of Metal Containers Used for the Packing or Conveyance of Goods', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25992', 'Manufacture of Wire Nails, Not in Steel Rolling', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25993', 'Manufacture of Fabricated Wire Products', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25994', 'Manufacture of Small Hand-operated Kitchen Appliances', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25995', 'Manufacture of Metal Sanitary Ware and Plumbing Fixtures', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25996', 'Manufacture of Needles (Except for Knitting and Sewing Machines), Pins and Fasteners Including Zippers', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25997', 'Manufacture of Aluminum Window and Door Screens, Shades and Venetian Blinds', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('25999', 'Manufacture of Miscellaneous Fabricated Metal Products, N.e.c.', NULL, '2599');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26110', 'Manufacture of Electronic Valves and Tubes', NULL, '2611');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26121', 'Manufacture of Sensors', NULL, '2612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26122', 'Manufacture of Actuators', NULL, '2612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26123', 'Manufacture of Oscillators', NULL, '2612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26124', 'Manufacture of Resonators', NULL, '2612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26129', 'Manufacture of Semi-conductor Devices and Other Electronic Components, N.e.c.', NULL, '2612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26200', 'Manufacture of Computers and Peripheral Equipment and Accessories\n', '\nThis includes the manufacture and/or assembly of various electronic computers, and computer peripheral equipment, such as storage devices and input/output devices (printers, monitors, keyboards). Computers can be analog, digital, or hybrid. Digital computers, the most common type, are devices that do all the following : (1) store the processing program or programs and the data immediately necessary for the execution of the program, (2) can be freely programmed in accordance with the requirements of the user, (3) perform arithmetical computations specified by the user and (4) execute, without human intervention, a processing program that requires the computer to modify its execution by logical decision during the processing run. Analog computers are capable of simulating mathematical models and comprise at least analog control and programming elements.\nThis class includes :\nManufacture of desktop computers\nManufacture of laptop computers\nManufacture of main frame computers\nManufacture of hand-held computers (e.g. PDA)\nManufacture of magnetic disk drives, flash drives and other storage devices\nManufacture of optical (e.g. CD-RW, CD-ROM, DVD-ROM, DVD-RW) disk drive\nManufacture of printers\nManufacture of monitors\nManufacture of keyboards\nManufacture of all types of mice, joysticks and trackball accessories\nManufacture of dedicated computer terminals\nManufacture of computer servers\nManufacture of scanners, including bar code scanners\nManufacture of smart card readers\nManufacture of virtual reality helmets\nManufacture of computer projectors (video beamers)\nManufacture of computer terminals, like automatic teller machines (ATMNULLs), point-of-scale (POS) terminals, not mechanically operated\nManufacture of multi-function office equipment, such as fax-scanner-copier combinations\nThis class excludes :\nReproduction of recorded media (computer media, sound, video, etc.), see 1820;\nManufacture of electronic components and electronic assemblies used in computers and peripherals, see 261;\nManufacture of internal/external computer modems, see 261;\nManufacture of interface cards, modules and assemblies, see 261;\nManufacture of modems, carrier equipment, see 2630;\nManufacture of digital communication switches, data communications equipment (e.g. bridges, routers, gateways, see 2630;\nManufacture of consumer electronic devices, such as CD players and DVD players, see 2640;\nManufacture of television monitors and displays, see 2640;\nManufacture of video game consoles, see 2640;\nManufacture of blank optical and magnetic media for use with computers or other devices, see 2680.', '2620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26300', 'Manufacture of Communication Equipment\n', '\nThis class includes the manufacture of telephone and data communications equipment used to move signals electronically over wires or through the air such as radio and television broadcast and wireless communications equipment.\nThis class includes :\nManufacture of central office switching equipment\nManufacture of cordless telephones\nManufacture of private branch exchange (PBX) equipment\nManufacture of telephone and facsimile equipment including telephone answering machines\nManufacture of data communications equipment, such as bridges, routers, and gateways\nManufacture of transmitting and receiving antenna\nManufacture of cable television equipment\nManufacture of pagers\nManufacture of cellular phones\nManufacture of mobile communication equipment\nManufacture of radio and television studio and broadcasting equipment, including television cameras\nManufacture of modems, carrier equipment\nManufacture of burglar and fire alarm systems, sending signals to a control station\nManufacture of radio and television transmitters\nManufacture of infrared devices (e.g. remote controls)\nThis class excludes :\nManufacture of computers and computer peripheral equipment, see 2620;\nManufacture of consumer audio and video equipment, see 2640;\nManufacture of electronic components and subassemblies used in communications equipment, see 261;\nManufacture of internal/external computer modems (PC-type), see 261;\nManufacture of electronic scoreboards, see 2790;\nManufacture of traffic lights, see 2790.', '2630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26400', 'Manufacture of Consumer Electronics\n', '\nThis class includes the manufacture of electronic audio and video equipment for home entertainment, motor vehicle, public address systems and musical instrument amplification.\nThis class includes :\nManufacture of video cassette recorders and duplicating equipment\nManufacture of televisions\nManufacture of television monitors and displays\nManufacture of audio recording and duplicating systems\nManufacture of stereo equipment\nManufacture of radio receivers\nManufacture of speaker systems\nManufacture of household-type video cameras\nManufacture of jukeboxes\nManufacture of amplifiers for musical instruments and public address systems\nManufacture of microphones\nManufacture of CD and DVD players\nManufacture of karaoke machines\nManufacture of headphones (e.g. radio, stereo, computer)\nManufacture of video game consoles\nThis class excludes :\nReproduction of recorded media (computer media, sound, video, etc), see 1820;\nManufacture of computer peripheral devices and computer monitors, see 2620;\nManufacture of telephone answering machines, see 2630;\nManufacture of paging equipment, see 2630;\nManufacture of remote control devices (radio and infrared), see 2630;\nManufacture of broadcast studio equipment such as reproduction equipment, transmitting and receiving antennas, commercial video cameras, see 2630;\nManufacture of electronic games with fixed (non-replaceable) software, see 3240.', '2640');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26511', 'Manufacture of Radar Equipment, Radio Remote Control Apparatus', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26512', 'Manufacture of Electrical Quantities Measuring and Controlling Instruments', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26513', 'Manufacture of Temperature Measuring and Controlling Hygrometric Instruments', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26514', 'Manufacture of Pressure Measuring and Controlling Instruments and Gauges', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26515', 'Manufacture of Flow of Liquids or Gases Measuring and Controlling Instruments', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26516', 'Manufacture of Mechanical Motion, Measuring and Controlling, Timing and Cycle Instruments', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26517', 'Manufacture of Industrial Process Control Equipment', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26519', 'Manufacture of Professional and Scientific and Measuring and Controlling Equipment, N.e.c.', NULL, '2651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26521', 'Manufacture of Watches and Clocks of All Kinds Including Cases of Precious Metals', NULL, '2652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26529', 'Manufacture of Other Watch and Clocks Parts, N.e.c.', NULL, '2652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26601', 'Manufacture of X-ray Apparatus', NULL, '2660');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26602', 'Manufacture of Electrotherapeutic Apparatus', NULL, '2660');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26603', 'Manufacture of Medical Laser Equipment', NULL, '2660');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26604', 'Manufacture of Computerized Tomography (Ct) Scanner, Positron Emission Tomography (Pet) Scanner', NULL, '2660');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26605', 'Manufacture of Mri Equipment', NULL, '2660');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26606', 'Manufacture of Medical Ultrasound Equipment', NULL, '2660');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26609', 'Manufacture of Other Irradiation, Electromedical and Electrotherapeutic Equipment, N.e.c.', NULL, '2660');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26701', 'Manufacture of Optical Instruments and Lenses', NULL, '2670');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26702', 'Manufacture of Photographic Equipment and Accessories', NULL, '2670');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('26800', 'Manufacture of Magnetic and Optical Media\n', '\nThis class includes the manufacture of magnetic and optical recording media, such as : blank magnetic audio and video tapes and cassettes, blank diskettes, blank optical discs and hard drive media.\nThis class excludes reproduction of recorded media (computer media, sound, video, etc.), see 1820.', '2680');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27111', 'Manufacture of Electric Motors and Generators', NULL, '2711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27112', 'Manufacture of Electrical Transformers', NULL, '2711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27113', 'Manufacture of Electric Generating Sets', NULL, '2711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27121', 'Manufacture of Switch Gear and Switchboard Apparatus', NULL, '2712');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27122', 'Manufacture of Electricity Distribution Equipment', NULL, '2712');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27123', 'Manufacture of Switches, Fuses, Sockets, Plugs, Conductors and Lightning Arresters and Other Control Apparatus', NULL, '2712');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27201', 'Manufacture of Accumulators (Storage Batteries) Including Parts', NULL, '2720');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27202', 'Manufacture of Primary Cells and Batteries', NULL, '2720');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27310', 'Manufacture of Fiber Optic Cables\n', '\nThis class includes manufacture of fiber optic cable for data transmission or live transmission of images\nThis class excludes :\nManufacture of glass fibers or strand, see 2310;\nManufacture of optical cable sets or assemblies with connectors or other attachments, see depending on application, e.g. 261.', '2731');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27320', 'Manufacture of Other Electronic and Electric Wires and Cables\n', '\nThis class includes manufacture of insulated wire and cable, made of steel, copper and aluminum.\nThis class excludes :\nManufacture (drawing) of wire, see 241, 242;\nManufacture of computer cables, printer cables, USB cables and similar cable sets or assemblies, see 2612;\nManufacture of extension cords, see 2790;\nManufacture of cable sets, wiring harnesses and similar cable sets or assemblies for automotive applications, see 2930.', '2732');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27330', 'Manufacture of Wiring Devices\n', '\nThis class includes the manufacture of current-carrying and non current-carrying wiring devices for electrical circuits regardless of material.\nThis class includes :\nManufacture of bus bars, electrical conductors (except switchgear-type)\nManufacture of GFCI (ground fault circuit interrupters)\nManufacture of lamp holders\nManufacture of lightning arrestors and coils\nManufacture of switches for electrical wiring (e.g. pressure, pushbutton, snap, tumbler switches)\nManufacture of electrical outlets and sockets\nManufacture of boxes for electrical wiring (e.g. junction outlet, switch boxes)\nManufacture of electrical conduit and fitting\nManufacture of transmission pole and line hardware\nManufacture of plastic non current - carrying wiring devices including plastic junction boxes, face plates, and similar, plastic pole line fittings\nThis class excludes :\nManufacture of ceramic insulators; see 2393;\nManufacture of electronic component-type connectors sockets, and switches, see 261.', '2733');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27401', 'Manufacture of Electric Lamps Fluorescent and Fixtures', NULL, '2740');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27402', 'Manufacture of Lighting Equipment and Parts Except for Use on Cycle and Motor Equipment', NULL, '2740');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27403', 'Manufacture of Motor Vehicle Lighting Equipment', NULL, '2740');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27404', 'Manufacture of Bicycle Lighting Equipment', NULL, '2740');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27405', 'Manufacture of Lighting Sets Used for Christmas Trees and the Like', NULL, '2740');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27501', 'Manufacture of Domestic Electric Fans', NULL, '2750');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27502', 'Manufacture of Domestic-type Refrigerators and Laundry Equipment (E.g. Clothes Washers, Washer-dryers, Dryers)', NULL, '2750');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27503', 'Manufacture of Domestic Cooking Appliances (E.g. Ovens, Ranges, Cookers, Stoves, Grillers, Etc.)', NULL, '2750');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27504', 'Manufacture of Electrothermic Domestic Appliances (E.g. Hair Dressing Appliances, Electric Instantaneous Storage, Heaters, Flat-irons, Plate Warmers, Coffee or Tea Makers)', NULL, '2750');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27505', 'Manufacture of Domestic-type Water Filters And/or Purifiers', NULL, '2750');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27509', 'Manufacture of Domestic Appliances, N.e.c.', NULL, '2750');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27901', 'Manufacture of Battery Chargers, Solid State', NULL, '2790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27902', 'Manufacture of Uninterruptible Power Supplies (Ups)', NULL, '2790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27903', 'Manufacture of Appliance Cords, Extension Cords, and Other Electrical Cord', NULL, '2790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27904', 'Manufacture of Accelerators (Cyclotrons, Betatrons)', NULL, '2790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27905', 'Manufacture of Electrical Signalling Equipment such as Traffic Lights and Pedestrian Signalling Equipment', NULL, '2790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('27909', 'Manufacture of Other Electrical Equipment, N.e.c.', NULL, '2790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28111', 'Manufacture of Internal Combustion Engines (Gas and Diesel)', NULL, '2811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28112', 'Manufacture of Engines and Turbines for Marine Propulsion', NULL, '2811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28113', 'Manufacture of Parts of Engines and Turbines, Except for Aircraft, Vehicle and Cycle Engines', NULL, '2811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28119', 'Manufacture of Engines and Turbines, Except for Transport, N.e.c.', NULL, '2811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28120', 'Manufacture of Fluid Power Equipment\n', '\nThis class includes :\nManufacture of hydraulic and pneumatic components (including hydraulic pumps, hydraulic and pneumatic cylinders, hydraulic and pneumatic valves, hydraulic and pneumatic hose and fittings)\nManufacture of air preparation equipment for use in pneumatic systems\nManufacture of fluid power systems\nManufacture of hydraulic transmission equipment\nThis class excludes :\nManufacture of compressors, see 2813;\nManufacture of pumps and valves for non-fluid power applications, see 2813;\nManufacture of mechanical transmission equipment, see 2814.', '2812');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28131', 'Manufacture of Pumps for Liquids, Vacuum Pumps, Air or Other Gas Compressors', NULL, '2813');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28132', 'Manufacture of Taps, Cocks, Valves and Similar Appliances for Pipes, Boiler Shells, Tanks, Vats or the Like', NULL, '2813');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28140', 'Manufacture of Bearings, Gears and Driving Elements\n', '\nThis class includes :\nManufacture of ball and roller bearings and parts thereof\nManufacture of mechanical power transmission equipment: transmission shafts and cranks: camshafts, crankshafts, cranks etc., bearing housings and plain shaft bearings\nManufacture of gears, gearing and gear boxes and other speed changers\nManufacture of clutches and shaft couplings\nManufacture of flywheels and pulleys\nManufacture of articulated link chain\nManufacture of power transmission chain\nThis class excludes :\nManufacture of other chain, see 2599;\nManufacture of (electromagnetic) clutches, see 2930;\nManufacture of sub-assemblies of power transmission equipment identifiable as parts of vehicles or aircraft, see divisions 29 and 30.', '2814');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28150', 'Manufacture of Ovens, Furnaces and Furnace Burners\n', '\nThis class includes :\nManufacture of electrical and other industrial and laboratory furnaces and ovens, including incinerators\nManufacture of burners\nManufacture of permanent mount electric space heaters, electric swimming pool heaters\nManufacture of permanent mount non-electric household heating equipment, such as solar heating, steam heating, oil heat and similar furnaces and heating equipment\nManufacture of electric household-type furnaces (electric forced air furnaces, heat pumps, etc.), non-electric household forced air furnaces\nThis class also includes the manufacture of mechanical stokers, grates, ash discharges, etc.\nThis class excludes :\nManufacture of household ovens, see 2750;\nManufacture of agricultural dryers, see 2825;\nManufacture of bakery ovens, see 2825;\nManufacture of dryers for wood, paper pulp, paper or paperboard, see 2829;\nManufacture of medical, surgical or laboratory sterilizers, see 3250;\nManufacture of (dental) laboratory furnaces, see 3250.', '2815');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28161', 'Manufacture of Lifting and Hoisting Machinery, Cranes, Elevators, Industrial Trucks, Tractors, Stackers, Specialized Ports for Lifting and Handling Equipment', NULL, '2816');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28162', 'Manufacture of Derricks, Lifting and Handling Equipment for Construction and Mining', NULL, '2816');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28163', 'Manufacture of Marine Capstans, Pulley Tackle and Hoists, Etc.', NULL, '2816');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28169', 'Manufacture of Other Lifting and Handling Equipment, N.e.c.', NULL, '2816');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28171', 'Manufacture of Calculating Machines, Adding Machines, Cash Registers, Calculators', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28172', 'Manufacture of Bills/coin Counting and Coin Wrapping Machinery', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28173', 'Manufacture of Postage Meters, Mail Handling Machines (Envelope Stuffing, Sealing and Addressing Machinery, Opening, Sorting, Scanning), Collating Machinery', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28174', 'Manufacture of Typewriters', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28175', 'Manufacture of Duplicating Machines', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28176', 'Manufacture of Photo-copying Apparatus Incorporating an Optical System or of the Contact Type and Thermo Copying Apparatus', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28177', 'Manufacture of Other Office and Accounting Machineries', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28179', 'Manufacture of Other Office Machinery and Equipment (Except Computers and Peripheral Equipment), N.e.c.', NULL, '2817');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28180', 'Manufacture of Power-driven Hand Tools\n', '\nThis class includes the manufacture of hand tools, with self-contained electric or non-electric motor or pneumatic drive, such as : circular or reciprocating saws, drills and hammer drills, hand held power sanders, pneumatic nailers, buffers, routers, grinders, staplers, pneumatic rivet guns, planers, shears and nibblers, impact wrenches, and powder actuated nailers.\nThis class excludes the manufacture of electrical hand-held soldering and welding equipment, see 2790.', '2818');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28191', 'Manufacture of Weighing Machines Except Scientific Weighing Apparatus Used for Laboratories', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28192', 'Manufacture of Refrigerating or Freezing Equipment for Commercial Purposes', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28193', 'Manufacture of Unit Air-conditioners', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28194', 'Manufacture of Packing and Wrapping Machinery', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28195', 'Manufacture of Machinery for Cleaning or Drying Bottles or Other Containers or for Aerating Beverages', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28196', 'Manufacture of Fans Intended for Industrial Applications, Exhaust Hoods for Commercial, Laboratory or Industrial Use', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28197', 'Manufacture of Calendering or Other Rolling Machines Other Than for Metals or Glass', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28198', 'Manufacture of Gas or Electric Welding, Brazing or Soldering Machines', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28199', 'Manufacture of Other General-purpose Machinery, N.e.c. (Including Manufacture of Specialized Parts for General Purpose Machinery and Equipment)', NULL, '2819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28211', 'Manufacture of Farm Tractors', NULL, '2821');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28212', 'Manufacture of Mechanical Implements for Crop Production', NULL, '2821');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28213', 'Manufacture of Animal Husbandry Machinery and Equipment', NULL, '2821');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28219', 'Manufacture of Agricultural and Forestry Machinery and Equipment, N.e.c.', NULL, '2821');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28221', 'Manufacture of Machine Tools for Working Metal', NULL, '2822');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28222', 'Manufacture of Machine Tools and Accessories Including Precision Measuring Tools', NULL, '2822');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28223', 'Parts and Accessories for the Machine Tools Classified in This Group', NULL, '2822');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28224', 'Manufacture of Apparatus for Electroplating, Electrolysis and Electrophoresis', NULL, '2822');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28229', 'Manufacture of Metal-forming Machinery and Machine Tools, N.e.c.', NULL, '2822');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28230', 'Manufacture of Machinery for Metallurgy\n', '\nThis class includes :\nManufacture of machines and equipment for handling hot metals : converters, ingot molds, ladles, casting machines\nManufacture of metal-rolling mills and rolls for such mills\nThis class excludes :\nManufacture of draw-benches, see 2822;\nManufacture of molding boxes and molds (except ingot molds), see 2593;\nManufacture of machines for forming foundry molds, see 2829.', '2823');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28241', 'Manufacture of Heavy Machinery and Equipment Used for Mining and Quarrying', NULL, '2824');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28242', 'Manufacture of Heavy Machinery and Equipment Used for Construction', NULL, '2824');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28251', 'Manufacture of Machinery for Food Processing', NULL, '2825');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28252', 'Manufacture of Presses, Crushers and Similar Machinery Used to Make Wine, Cider, Fruit Juices or Similar Beverages', NULL, '2825');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28253', 'Manufacture of Machinery for the Preparation of Tobacco and for the Making of Cigarettes or Cigars, or Pipe or Chewing Tobacco or Snuff', NULL, '2825');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28261', 'Manufacture of Textile Machinery', NULL, '2826');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28262', 'Manufacture of Machineries for Man-made Textile Fibers or Yarns', NULL, '2826');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28263', 'Manufacture of Sewing Machines', NULL, '2826');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28264', 'Manufacture of Commericial Washing, Laundry, Dry-cleaning and Pressing Machines', NULL, '2826');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28265', 'Manufacture of Needles for Knitting, Sewing Machines', NULL, '2826');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28269', 'Manufacture of Machinery for Textile Apparel and Leather Production, N.e.c.', NULL, '2826');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28291', 'Manufacture of Machinery for Pulp, Paper and Paperboard Industries', NULL, '2829');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28292', 'Manufacture of Machinery for Working Rubber or Plastic or for the Manufacture of Products of These Materials', NULL, '2829');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28293', 'Manufacture of Printing-trade Machinery and Equipment', NULL, '2829');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28294', 'Manufacture of Machinery for Producing Tiles, Bricks, Shaped Ceramic Pastes, Pipes, Graphite, Electrodes, Blackboard Chalk, Foundry Molds, Etc.', NULL, '2829');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28295', 'Manufacture of Machines for Production or Hot-working of Glass; Glassware or Yarn', NULL, '2829');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28296', 'Manufacture of Centrifugal Clothes Driers', NULL, '2829');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('28299', 'Manufacture of Other Special-purpose Machinery, N.e.c.', NULL, '2829');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('29100', 'Manufacture of Motor Vehicles\n', '\nThis class includes :\nManufacture of passenger cars\nManufacture of commercial vehicles : vans, lorries, over-the-road tractors for semi-trailers, etc.\nManufacture of buses, trolley-buses and coaches\nManufacture of motor vehicle engines\nManufacture of chassis fitted with engines\nManufacture of other motor vehicles : snowmobiles, golf carts, amphibious vehicles; fire engines, street sweepers, travelling libraries, armored cars, etc.; concrete-mixer lorries\nThis class also includes factory rebuilding of motor vehicle engines\nThis class excludes :\nManufacture of lighting equipment for motor vehicles, see 2740;\nManufacture of pistons, piston rings and carburetors, see 2811;\nManufacture of agricultural tractors, see 2821;\nManufacture of tractors used in construction and mining, see 2824;\nManufacture of off-road dumping trucks, see 2824;\nManufacture of bodies for motor vehicles, see 2920;\nManufacture of electrical parts for motor vehicles, see 2930;\nManufacture of parts and accessories for motor vehicles, see 2930;\nManufacture of tanks and other military fighting vehicles, see 3040;\nMaintenance, repair and alteration of motor vehicles, see 4520.', '2910');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('29201', 'Manufacture of Bodies (Coachwork) for Motor Vehicles', NULL, '2920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('29202', 'Manufacture of Trailers and Semi-trailers', NULL, '2920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('29301', 'Manufacture of Electric Ignition or Starting Equipment for Internal Combustion Engines', NULL, '2930');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('29302', 'Manufacture of Parts and Accessories for Motor Vehicles and Their Engines', NULL, '2930');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30111', 'Building of Ships and Boats Other Than Sports and Pleasure Boats', NULL, '3011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30112', 'Manufacture of Floating or Submersible Drilling Platforms', NULL, '3011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30113', 'Manufacture of Inflatable Rafts', NULL, '3011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30114', 'Manufacture of Metal Sections for Ships and Barges', NULL, '3011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30121', 'Manufacture of Inflatable Boats', NULL, '3012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30129', 'Manufacture of Other Pleasure and Sporting Boats, N.e.c.', NULL, '3012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30201', 'Building and Rebuilding of Locomotives of Any Type of Gauge, and Railroad and Tramway Cars for Freight and Passenger Service', NULL, '3020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30202', 'Production of Specialized Parts for Locomotives, Railroad and Tramway', NULL, '3020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30301', 'Manufacture of Airplanes for the Transport of Goods or Passengers, for Use by the Defense Forces, for Sport or Other Purposes', NULL, '3030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30302', 'Manufacture of Spacecraft and Launch Vehicles, Satellites, Planetary Probes, Orbital, Shuttles', NULL, '3030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30303', 'Conversion, Modification and Overhaul of Aircrafts', NULL, '3030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30309', 'Manufacture of Other Air and Spacecraft and Related Machinery, N.e.c.', NULL, '3030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30400', 'Manufacture of Military Fighting Vehicles\n', '\nThis class includes :\nManufacture of tanks\nManufacture of armored amphibious military vehicles\nManufacture of other military fighting vehicles\nThis class excludes manufacture of weapons and ammunitions, see 2520.', '3040');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30911', 'Manufacture and Assembly of Motorcycles', NULL, '3091');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30912', 'Manufacture of Motorcycle Engines and Parts Thereof', NULL, '3091');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30913', 'Manufacture of Tricycles and Parts Thereof', NULL, '3091');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30914', 'Manufacture of Side Cars', NULL, '3091');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30915', 'Manufacture of Parts and Accessories of Motorcycles', NULL, '3091');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30921', 'Manufacture of Bicycles and Bicycle Parts', NULL, '3092');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30922', 'Manufacture of Invalid Carriages, Motorized and Non-motorized', NULL, '3092');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30923', 'Manufacture of Baby Carriages', NULL, '3092');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30991', 'Manufacture of Hand-propelled Vehicles', NULL, '3099');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('30992', 'Manufacture of Animal Drawn Vehicles', NULL, '3099');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('31010', 'Manufacture of Wood Furniture', NULL, '3101');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('31020', 'Manufacture of Rattan Furniture (Reed, Wicker, and Cane)', NULL, '3102');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('31030', 'Manufacture of Box Beds and Mattresses', NULL, '3103');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('31040', 'Manufacture of Partitions, Shelves, Lockers and Office and Store Fixtures', NULL, '3104');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('31050', 'Manufacture of Plastic Furniture', NULL, '3105');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('31060', 'Manufacture of Furniture and Fixtures of Metal', NULL, '3106');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('31090', 'Manufacture of Other Furniture and Fixtures, N.e.c.', NULL, '3109');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32111', 'Manufacture of Jewelry Made of Precious and Semi-precious Stones', NULL, '3211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32112', 'Manufacture of Silverware and Plated Ware', NULL, '3211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32113', 'Manufacture of Watchbands and Bracelets of Precious Metals', NULL, '3211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32119', 'Manufacture of Articles Related to Jewelry', NULL, '3211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32120', 'Manufacture of Imitation of Jewelry and Related Articles\n', '\nThis class includes :\nManufacture of costume or imitation jewelry :\nrings, bracelets, necklaces, and similar articles of jewelry made from base metals plated with precious metals; jewelry containing imitation stones such as imitation gems stones, imitation diamonds, and similar articles\nManufacture of metal watch bands (except precious metals)\nThis class excludes :\nManufacture of jewelry made from precious metals or clad with precious metals, see 3211;\nManufacture of jewelry containing genuine gem stones, see 3211;\nManufacture of precious metal watch bands, see 3211.', '3212');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32201', 'Manufacture of Guitars', NULL, '3220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32202', 'Manufacture of String Instruments, Other Than Guitars', NULL, '3220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32203', 'Manufacture of Pianos', NULL, '3220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32204', 'Manufacture of Musical Organs (All Types)', NULL, '3220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32205', 'Manufacture of Wind and Percussion Instruments', NULL, '3220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32206', 'Manufacture of Musical Instrument Parts and Accessories', NULL, '3220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32209', 'Manufacture of Musical Instruments, N.e.c.', NULL, '3220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32301', 'Manufacture of Sporting Gloves and Mitts', NULL, '3230');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32302', 'Manufacture of Sporting Balls', NULL, '3230');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32309', 'Manufacture of Sporting and Athletic Goods, N.e.c.', NULL, '3230');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32401', 'Manufacture of Dolls and Doll Garments', NULL, '3240');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32402', 'Manufacture of Wheeled Toys', NULL, '3240');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32403', 'Manufacture of Billiard, Pool, Bowling Alley and Similar Games Equipment', NULL, '3240');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32404', 'Manufacture of Electronic Games (Video Games, Checkers)', NULL, '3240');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32409', 'Manufacture of Toys and Games, N.e.c.', NULL, '3240');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32501', 'Manufacture of Medical, Surgical, Dental Furniture and Fixtures', NULL, '3250');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32502', 'Manufacture of Ophthalmic Goods, Eyeglasses, Sunglasses, Lenses Ground to Prescription, Contact Lenses, Safety Goggles', NULL, '3250');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32503', 'Manufacture of Prosthetic Appliances, Artificial Teeth Made to Order', NULL, '3250');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32504', 'Manufacture of Medical and Precision Instruments', NULL, '3250');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32505', 'Manufacture of Medical Thermometers', NULL, '3250');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32506', 'Manufacture of Cement Used in Dentistry', NULL, '3250');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32509', 'Manufacture of Other Medical and Dental Instruments and Supplies, N.e.c.', NULL, '3250');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32910', 'Manufacture of Pens and Pencils of All Kinds', NULL, '3291');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32920', 'Manufacture of Umbrellas, Walking Sticks, Canes, Whips and Riding Crops', NULL, '3292');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32930', 'Manufacture of Articles for Personal Use, E.g. Smoking Pipes, Combs, Slides and Similar Articles', NULL, '3293');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32940', 'Manufacture of Candles', NULL, '3294');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32950', 'Manufacture of Artificial Flowers, Fruits and Foliage', NULL, '3295');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32961', 'Manufacture of Wooden Coffin', NULL, '3296');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32962', 'Manufacture of Metal Coffin', NULL, '3296');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32991', 'Manufacture of Buttons, Except Plastic', NULL, '3299');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32992', 'Manufacture of Brooms, Brushes and Fans', NULL, '3299');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32993', 'Manufacture of Identification Plates, Badges, Emblems and Tags', NULL, '3299');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32994', 'Manufacture of Signs and Advertising Displays', NULL, '3299');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32995', 'Manufacture of Cigarette Lighters', NULL, '3299');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('32999', 'Manufacture of Miscellaneous Articles, N.e.c.', NULL, '3299');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33110', 'Repair of Fabricated Metal Products\n', '\nThis class includes repair and maintenance of fabricated metal products of division 25.\nThis class includes :\nRepair of metal tanks, reservoirs and containers\nRepair and maintenance for pipes and pipelines\nMobile welding repair\nRepair of steel shipping drums\nRepair and maintenance of steam or other vapor generators\nRepair and maintenance of auxiliary plant for use with steam generators : condensers, economizers, superheaters, steam collectors and accumulators\nRepair and maintenance of nuclear reactors, except isotope separators\nRepair and maintenance of parts for marine or power boilers\nPlatework repair of central heating boilers and radiators\nRepair and maintenance of fire arms and ordinance (including repair of sporting and recreational guns)\nThis class excludes :\nRepair of central heating systems, etc., see 4322;\nRepair of mechanical locking devices, safe, etc., see 8020.', '3311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33120', 'Repair of Machinery\n', '\nThis class includes repair and maintenance of industrial machinery and equipment like sharpening or installing commercial and industrial machinery blades and saws or the provision of welding (e.g. automotive, general) repair services; the repair of agricultural and other heavy and industrial machinery and equipment (e.g. forklifts and other materials handling equipment, machine tools, commercial refrigeration equipment, construction equipment and mining machinery), comprising machinery and equipment of division 28.\nThis class includes :\nRepair and maintenance of non-automotive engines, e.g. ship or rail engines\nRepair and maintenance of pumps and related equipment\nRepair and maintenance of fluid power equipment\nRepair of valves\nRepair of gearing and driving elements\nRepair and maintenance of industrial process furnaces\nRepair and maintenance of materials handling equipment\nRepair and maintenance of commercial refrigeration equipment and air purifying equipment\nRepair and maintenance of commercial-type general purpose machinery\nRepair of other power-driven hand-tools\nRepair and maintenance of metal cutting and metal forming machine tools and accessories\nRepair and maintenance of other machine tools\nRepair and maintenance of agricultural tractors\nRepair and maintenance of agricultural machinery and forestry and logging machinery\nRepair and maintenance of metallurgy machinery\nRepair and maintenance of mining, construction and oil and gas field machinery\nRepair and maintenance of food, beverage, and tobacco processing machinery\nRepair and maintenance of textile apparel, and leather production machinery\nRepair and maintenance of papermaking machinery\nRepair and maintenance of other special purpose machinery of division 28\nRepair and maintenance of weighing equipment\nRepair and maintenance of vending machines\nRepair and maintenance of cash registers\nRepair and maintenance of photocopy machines\nRepair of calculators, electronic or not\nRepair of typewriters\nThis class excludes installation, repair and maintenance of furnace and other heating equipment, see 4322.', '3312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33130', 'Repair of Electronic and Optical Equipment\n', '\nThis class includes repair and maintenance of goods produced in groups 265, 266 and 267, except those that are considered household goods.\nThis class includes the repair and maintenance of the measuring, testing, navigating and control equipment of group 265, such as:\naircraft engine instruments\nautomotive emissions testing equipment\nmeteorological instruments\nphysical, electrical and chemical properties testing and inspection equipment\nsurveying instruments\nradiation detection and monitoring instruments\nRepair and maintenance of irradiation, electromedical and electrotherapeutic equipment of class 2660 such as:\nmagnetic resonance imaging equipment\nmedical ultrasound equipment\npacemakers\nhearing aids\nelectrocardiographs\nelectromedical endoscopic equipment\nirradiation apparatus\nRepair and maintenance of optical instruments and equipment of class 2670, if the use is mainly commercial, such as:\nbinoculars\nmicroscopes (except electron and proton microscopes)\ntelescopes\nprisms and lenses (except ophthalmic)\nphotographic equipment\nThis class includes the repair of optical instruments and equipment of class 2670, such as: binoculars, microscopes (except electron proton) telescopes, prisms, and lenses (except ophthalmic) and photographic equipment, if the use is mainly commercial.\nThis class excludes :\nRepair and maintenance of photocopy machines, see 3312;\nRepair and maintenance of computers and peripheral equipment, see 9511;\nRepair and maintenance of computer projectors, see 9511;\nRepair and maintenance of communication equipment, see 9512;\nRepair and maintenance of commercial TV and video cameras, see 9512;\nRepair of household-type video cameras, see 9521;\nRepair of watches and clocks, see 9529.', '3313');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33140', 'Repair of Electrical Equipment\n', '\nThis class includes the repair and maintenance of goods of division 27, except in class 2750 (domestic appliances).\nThis class includes :\nRepair and maintenance of power, distribution, and specialty transformers\nRepair and maintenance of electric motors, generators, and motor generator sets\nRepair and maintenance of switchgear and switchboard apparatus\nRepair and maintenance of relays and industrial controls\nRepair and maintenance of primary and storage batteries\nRepair and maintenance of electric lighting equipment\nRepair and maintenance of current-carrying wiring and non current-carrying wiring devices for wiring electrical circuits\nThis class excludes :\nRepair and maintenance of computers and peripheral computer equipment, see 9511;\nRepair and maintenance of telecommunications equipment, see 9512;\nRepair and maintenance of consumer electronics, see 9521;\nRepair of watches and clocks, see 9529.', '3314');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33151', 'Repairing of Ships and Boats Other Than Sports and Pleasure Boats', NULL, '3315');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33152', 'Repairing of Sports and Pleasure Boats', NULL, '3315');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33153', 'Repairing of Aircraft', NULL, '3315');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33154', 'Repair and Maintenance of Aircraft Engines', NULL, '3315');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33159', 'Repair of Transport Equipment, Except Motor Vehicles, N.e.c.', NULL, '3315');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33190', 'Repair of Other Equipment\n', '\nThis class includes the repair and maintenance of equipment not covered in other groups of this division.\nThis class includes :\nRepair or ropes, riggings, canvas and tarps\nRepair of fertilizer and chemical storage bags\nRepair or reconditioning of wooden pallets, shipping drums or barrels, and similar items\nRepair of pinball machines and other coin-operated games\nRestoring of organs and other historical musical instruments\nThis class excludes :\nRepair of household and office type furniture, furniture restoration, see 9524;\nRepair of bicycles and invalid carriages, see 9529;\nRepair and alteration of clothing, see 9529.', '3319');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('33200', 'Installation of Industrial Machinery and Equipment\n', '\nThis class includes the specialized installation of machinery. However, the installation of equipment that forms an integral part of building or similar structures, such as installation of escalators, electrical wiring, burglar alarm systems or air-conditioning systems, is classified as construction.\nThis class includes :\nInstallation of industrial machinery in industrial plant\nInstallation of industrial process control equipment\nInstallation of other industrial equipment, e.g. :\ncommunication equipment\nmainframe and similar computers\nirradiation and electromedical equipment, etc.\nDismantling large-scale machinery and equipment\nActivities of millwrights\nInstallation of bowling alley equipment\nMachine rigging\nThis class excludes:\nInstallation of electrical wiring, burglar alarm systems, see 4321;\nInstallation of air-conditioning system, see 4322;\nInstallation of elevators, escalators, automated doors, vacuum cleaning systems etc., see 4329;\nInstallation of doors, staircases, shop fittings, furniture, etc., see 4330;\nInstallation (setting-up) of personal computers, see 6209.', '3320');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('35101', 'Electric Power Generation', NULL, '3510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('35102', 'Electric Power Transmission', NULL, '3510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('35103', 'Electric Power Distribution', NULL, '3510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('35200', 'Manufacture of Gas; Distribution of Gaseous Fuels Through Mains\n', '\nThis class includes the manufacture of gas and the distribution of natural or synthetic gas to the consumer through a system of mains. Gas marketers or brokers, which arrange the sale of natural gas over distribution systems operated by others, are included.\nThe separate operation of gas pipelines, typically done over long distances, connecting producers, with distribution of gas, or between urban centers, is excluded from this class and classified with other pipeline transport activities.\nThis class includes :\nProduction of gas for the purpose of gas supply by carbonation of coal, from by-products of agriculture or from waste\nManufacture of gaseous fuels with a specified calorific value, by purification, blending and other processes from gases of various types including natural gas\nTransportation, distribution and supply of gaseous fuels of all kinds through a system of mains\nSale of gas to the user through mains\nActivities of gas brokers or agents that arrange the sale of gas over gas distribution systems operated by others\nCommodity and transport capacity exchanges gaseous fuels\nThis class excludes :\nOperation of coke ovens, see 1910;\nManufacture of refined petroleum products, see 1920;\nManufacture of industrial gases, see 2011;\nWholesale of gaseous fuels, see 4661;\nRetail sale of bottled gas, see 4773;\nDirect selling of fuel, see 4799;\n(Long distance) tranportation of gases by pipelines, see 4930.', '3520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('35300', 'Steam, Air Conditioning Supply and Production of Ice\n', '\nThis class includes :\nProduction, collection and distribution of steam and hot water for heating, power and other purposes\nProduction and distribution of cooled air\nProduction of ice for cooling purposes\nThis excludes production of ice for human consumption, see 1079.', '3530');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('36000', 'Water Collection, Treatment and Supply\n', '\nThis class includes water collection from various sources, treatment and distribution activities by various means of domestic and industrial needs. Collection of water from various sources, as well as distribution by various means is included.\nThe operation of irrigation canals is also included, however the provision of irrigation services through sprinklers, and similar agricultural support services, is not included.\nThis class includes :\nCollection of water from rivers, lakes, wells, etc.\nCollection of rain water\nPurification of water from water supply purposes\nTreatment of water for industrial and other purposes\nDistribution of water through mains, by trucks or other means\nDesalting of sea or ground water to produce water as the principal product of interest\nOperation of irrigation canals\nThis class excludes :\nOperation of irrigation equipment for agricultural purposes, see 0151;\nTreatment of wastewater in order to prevent pollution, see 3700;\n(Long distance) transport of water via pipelines, see 4940.', '3600');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('37000', 'Sewerage\n', '\nThis class includes :\nOperation of sewer systems or sewer treatment facilities\nCollecting and transporting of human or industrial wastewater from one or several users, as well as rain water by means of sewerage networks, collectors, tanks and other means of transport (sewage vehicles, etc.)\nEmptying and cleaning of cesspools and septic tanks, sinks and pits from sewage; servicing of chemicals toilets\nTreatment of wastewater (including human and industrial wastewater, water from swimming pool, etc.) by means of physical, chemical and biological processes like, dilution, screening, filtering, sedimentation etc.\nMaintenance and cleaning of sewers and drains, including sewer rodding', '3700');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('38110', 'Collection of Non-hazardous Waste\n', '\nThis class includes :\nCollection of non-hazardous solid waste (i.e. garbage) within a local area, such as collection of waste from households and businesses by means of refuse bins, wheeled bins, containers, etc. may include mixed recoverable materials.\nCollection of recyclable materials\nCollection of used cooking oils and fats\nCollection of refuse in litter-bins in public places\nCollection of construction and demolition waste\nCollection and removal of debris such as brush and rubble\nCollection of waste output of textile mills\nOperation of waste transfer stations for non-hazardous waste\nThis class excludes :\nCollection of hazardous waste, see 3812;\nOperation of landfills for the disposal of non-hazardous waste, see 3821;\nOperation of facilities where commingled recoverable materials such as paper, plastics, etc. are sorted into distinct categories, see 3830', '3811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('38120', 'Collection of Hazardous Waste\n', '\nThis class includes the collection of solid and non-solid hazardous waste, i.e., explosive, oxidizing, flammable, toxic, irritant, carcinogenic, corrosive, infectious and other substances and preparations harmful for human health and environment. It may also entail identification, treatment, packaging and labeling of waste for purposes of transport.\nThis class includes :\nCollection of hazardous waste such as :\nused oil from shipment or garages\nbio hazardous waste\nused batteries\nOperation of waste transfer stations for hazardous waste\nThis class excludes remediation and clean up of contaminated buildings, mine sites, soil, ground water, e.g. asbestos removal, see 3900.', '3812');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('38210', 'Treatment and Disposal of Non-hazardous Waste\n', '\nThis class includes the disposal, treatment prior to disposal and other treatment of solid or non-solid non-hazardous waste.\nThis class includes :\nOperation of landfills for the disposal of non-hazardous waste\nDisposal of non-hazardous waste by combustion or incineration or other methods, with or without the resulting production of electricity or steam, substitute fuels, biogas, ashes or other by-products for further use, etc.\nTreatment of organic waste for disposal\nProduction of compost from organic waste\nThis class excludes :\nIncineration and combustion of hazardous waste, see 3822;\nOperation of facilities where commingled recoverable materials such as paper, plastics, used beverage cans and metals, are sorted into distinct categories, see 3830;\nDecontamination, clean up of land, water; toxic material abatement, see 3900.', '3821');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('38220', 'Treatment and Disposal of Hazardous Waste\n', '\nThis class includes the disposal and treatment prior to disposal of solid or non-solid hazardous waste, including waste that is explosive, oxidizing, flammable, toxic, irritant, carcinogenic, corrosive or infectious and other substances and preparations harmful for human health and environment.\nThis class includes :\nOperation of facilities for treatment of hazardous waste\nTreatment and disposal of toxic live or dead animals and other contaminated waste\nIncineration of hazardous waste\nDisposal of used goods such as refrigerators to eliminate harmful waste\nTreatment disposal and storage of radioactive nuclear waste including treatment and disposal of transition radio active waste, i.e. decaying within the period of transport, from hospitals; encapsulation, preparation and other treatment of nuclear waste for storage\nThis class excludes :\nIncineration of non-hazardous waste, see 3821;\nDecontamination, clean up of land, water, toxic material abatement, see 3900;\nReprocessing of nuclear fuels, see 2011.', '3822');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('38300', 'Materials Recovery\n', '\nThis class includes :\nProcessing of metal and non-metal waste and scrap and other articles into secondary raw materials, usually involving a mechanical or chemical transformation process\nRecovery of materials from waste streams in the form of :\nseparating and sorting recoverable materials from non-hazardous waste streams (i.e. garbage)  \nseparating and sorting of commingled recoverable materials, such as paper, plastics, used beverage cans and metals, into distinct categories.\nThis class excludes the manufacture of new final products from secondary raw materials, as this is covered by corresponding sub-classes in Manufacturing.', '3830');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('39000', 'Remediation Activities and Other Waste Management Services\n', '\nThis class includes :\nDecontamination of soils and groundwater at the place of pollution, either in situ or ex situ, using e.g. mechanical, chemicals or biological methods\nDecontamination of industrial plants or sites, including nuclear plants and sites\nDecontamination and cleaning up of surface water following accidental pollution, e.g. through collection of pollutants or through application of chemicals\nCleaning up of oil spills and other pollutions on land, in surface water, in ocean and seas, including coastal areas\nAsbestos, lead paint, and other toxic material abatement\nClearing of landmines and the like (including detonation)\nOther specialized pollution-control activities\nThis class excludes :\nTreatment and disposal of non-hazardous waste, see 3821;\nTreatment and disposal of hazardous waste, see 3822;\nOutdoor sweeping and watering of streets, etc, see 8129.', '3900');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('41001', 'Residential (Dwelling) Building Constructions', NULL, '4100');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('41002', 'Non-residential Building Constructions', NULL, '4100');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('42100', 'Construction of Roads and Railways\n', '\nThis class includes :\nConstruction of motorways, streets, roads, other vehicular and pedestrian ways\nSurface work on streets, roads, highways, bridges or tunnels :\nasphalt paving of roads\nroad painting and other marking\ninstallation of crash barriers, traffic signs and the like\nConstruction of bridges, including those for elevated highways\nConstruction of tunnels\nConstruction of railways and subways\nConstruction of airfield runways\nThis class excludes :\nInstallation of street lighting and electrical signals, see 4321;\nArchitectural and engineering activities, see 7110;\nProject management activities related to civil engineering works, see 7110.', '4210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('42201', 'Construction of Telecommunication Lines and Pipelines', NULL, '4220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('42202', 'Water Main and Line Construction', NULL, '4220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('42203', 'Construction of Gas and Energy Pipelines', NULL, '4220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('42204', 'Construction of Electric Power Lines', NULL, '4220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('42209', 'Other Construction of Utility Projects, N.e.c.', NULL, '4220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('42900', 'Construction of Other Civil Engineering Projects\n', '\nThis class includes :\nConstruction of industrial facilities, except buildings, such as: refineries and chemical plants\nConstruction of: waterways, harbor and river works, pleasure ports (marinas), locks, etc.; dams and dikes\nDredging of waterways\nConstruction work, other than buildings, such as: outdoor sports facilities\nLand subdivision with land improvement (e.g. adding of roads, utility infrastructure etc.)\nThis class excludes project management activities related to civil engineering works, see 7110.', '4290');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43110', 'Demolition\n', 'This class includes demolition or wrecking of buildings and other structures.', '4311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43120', 'Site Preparation\n', '\nThis class includes preparation of sites for subsequent construction activities.\nThis class includes :\nClearing of building sites\nEarth moving : excavation, landfill, leveling and grading of construction sites, trench digging, rock removal, blasting, etc.\nDrilling, boring and core sampling for construction, geophysical, geological or similar purposes\nThis class also includes:\nSite preparation for mining : overburden removal and other development and preparation of mineral properties and sites, except oil and gas sites\nBuilding site drainage\nDrainage of agricultural or forestry land\nThis class excludes :\nDrilling of production oil or gas wells, see 0610, 0620;\nTest drilling and test hole boring for mining operations (other than oil and gas extraction), see 0990;\nDecontamination of soil, see 3900;\nWater well drilling, see 4220;\nShaft sinking, see 4390;\nOil and gas field exploration, geophysical, geological and seismic surveying, see 7110.', '4312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43210', 'Electrical Installation\n', '\nThis class includes the installation in all kinds of buildings and civil engineering structures of electrical systems.\nThis class includes :\nInstallation of:\nelectrical wiring and fittings\ntelecommunications wiring\ncomputer network and cable television wiring, including fiber optic\nsatellite dishes\nlighting systems\nfire alarms\nburglar alarm systems\nstreet lighting and electrical signals\nairport runway lighting\nclosed-circuit television camera wirings\nThis class also includes connecting of electric appliances and household equipment, including baseboard heating.\nThis class excludes :\nConstruction of communications and power transmission lines, see 4220;\nMonitoring or remote monitoring of electronic security alarm systems, such as burglar and fire alarms, including their maintenance, see 8020.', '4321');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43220', 'Plumbing, Heat and Air-conditioning Installation\n', '\nThis class includes the installation of plumbing, heating and air-conditioning systems, including additions, alterations, maintenance and repair.\nThis class includes installation in buildings or other construction projects of :\nheating systems (electric, gas and oil)\nfurnaces, cooling towers\nnon-electric solar energy collectors\nplumbing and sanitary equipment\nventilation, refrigeration or air-conditioning equipment and ducts\ngas fittings\nsteam piping\nfire sprinkler systems\nlawn sprinkler systems\nDuct work installation\nThis class excludes installation of electric baseboard heating, see 4321.', '4322');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43290', 'Other Construction Installation\n', '\nThis class includes the installation of equipment other than electrical, plumbing, heating and air-conditioning systems or industrial machinery in buildings and civil engineering structures, including maintenance and repair.\nThis class includes :\nInstallation in buildings or other construction projects of :\nelevators, escalators\nautomated and revolving doors\nlightning conductors\nvacuum cleaning systems\nthermal, sound or vibration insulation\nThis class excludes installation of industrial machinery, see 3320.', '4329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43301', 'Painting and Related Work', NULL, '4330');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43302', 'Floor and Wall Tiling or Covering with Other Material', NULL, '4330');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43303', 'Carpentry', NULL, '4330');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43309', 'Other Building Completion and Finishing Activities', NULL, '4330');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('43900', 'Other Specialized Construction Activities\n', '\nThis class includes :\nConstruction activities specializing in one aspect common to different kind of structures, requiring specialized skill or equipment :\nconstruction of foundations, including pile driving\ndamp proofing and water proofing works\nde-humidification of buildings\nshaft sinking\nerection of non-self - manufactured steel elements\nsteel bending\nbricklaying and stone setting\nroof covering for residential buildings\nscaffolds and work platform erecting and dismantling, excluding renting of scaffolds and work platforms\nerection of chimneys and industrial ovens\nwork with specialist access requirements necessitating climbing skills and the use of related equipment, e.g.; working at height on tall structures\nSubsurface work\nConstruction of outdoor swimming pools\nSteam cleaning, sand blasting and similar activities for building exteriors\nRenting of cranes with operator\nThis class excludes renting of construction machinery and equipment without operator, see 7730.', '4390');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45101', 'Sale of Passenger Motor Vehicles', NULL, '4510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45102', 'Sale of Lorries, Trailers and Semi-trailers', NULL, '4510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45109', 'Sale of Other Motor Vehicles', NULL, '4510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45201', 'Repair of Motor Vehicles, Including Overhauling', NULL, '4520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45202', 'Repair of Batteries for Motor Vehicles', NULL, '4520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45203', 'Vulcanizing or Preparing of Tires for Motor Vehicles', NULL, '4520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45204', 'Car Washing and Auto-detailing Services', NULL, '4520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45209', 'Maintenance of Motor Vehicles, N.e.c.', NULL, '4520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45301', 'Wholesale of Motor Vehicles Parts and Accessories', NULL, '4530');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45302', 'Retail Sale of Motor Vehicles Parts and Accessories', NULL, '4530');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45303', 'Wholesale of Motor Vehicles Tires and Batteries', NULL, '4530');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45304', 'Retail Sale of Motor Vehicles Tires and Batteries', NULL, '4530');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45309', 'Sale of Motor Vehicle Parts and Accessories, N.e.c.', NULL, '4530');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45401', 'Sale of Motorcycles', NULL, '4540');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45402', 'Maintenance and Repair of Motorcycles and Their Parts and Components', NULL, '4540');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('45403', 'Sale of Motorcycles Parts and Components', NULL, '4540');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46101', 'Wholesale on a Fee or Contract Basis, of Agricultural Raw Materials and Live Animals', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46102', 'Wholesale on a Fee or Contract Basis, of Food, Beverages and Tobacco', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46103', 'Wholesale on a Fee or Contract Basis, of Textile, Clothing, and Footwear', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46104', 'Wholesale on a Fee or Contract Basis, of Household Appliances, Articles and Equipment', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46105', 'Wholesale on a Fee or Contract Basis, of Miscellaneous Consumer Goods', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46106', 'Wholesale on a Fee or Contract Basis, of Construction Materials and Hardware', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46107', 'Wholesale on a Fee or Contract Basis, of Chemical and Pharmaceutical Products', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46108', 'Wholesale on a Fee or Contract Basis, of Machinery, Equipment and Supplies', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46109', 'Wholesale on a Fee or Contract Basis, of Other Products', NULL, '4610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46201', 'Wholesale of Palay, Corn (Unmilled) and Other Grains', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46202', 'Wholesale of Abaca and Other Fibers, Except Synthetic Fibers', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46203', 'Wholesale of Coconut, Coconut-based Products, and Coconut By-products (E.g., Copra, Macapuno, Coconut Husk, Coconut Shell)', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46204', 'Wholesale of Oleaginous Fruits (E.g., Oil Seeds, Palm Oil, Sunflower Seeds, Etc.)', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46205', 'Wholesale of Tobacco Leaf', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46206', 'Wholesale of Flowers and Plants', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46207', 'Wholesale of Livestock and Poultry and Unprocessed Animal Products', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46208', 'Wholesale of Fish and Other Seafood', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46209', 'Wholesale of Farm, Forest and Marine Products, Including Seeds and Animal Feeds, Hides and Skins, Leather, Etc. N.e.c.', NULL, '4620');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46301', 'Wholesale of Fruits, Nuts and Vegetables', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46302', 'Wholesale of Sugar, Confectionery and Bakery Products and Other Processed Foods', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46303', 'Wholesale of Meat and Poultry Products, Including Eggs', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46304', 'Wholesale of Rice, Corn and Other Cereals', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46305', 'Wholesale of Fishery Products', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46306', 'Wholesale of Drinking Water, Juices (Including Powder), Coffee, Tea, Cocoa, Soft Drinks, Energy and Sports Drinks, Alcoholic and Other Beverages', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46307', 'Wholesale of Tobacco Products', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46308', 'Wholesale of Spices', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46309', 'Wholesale of Food, Beverage and Tobacco, N.e.c.', NULL, '4630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46411', 'Wholesale of Textile Fabrics, All Kinds, Including Man-made Fibers', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46412', 'Wholesale of Wearing Apparel, Except Footwear', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46413', 'Wholesale of Made-up Textile Goods, Except Wearing Apparel', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46414', 'Wholesale of Articles of Clothing, Including Accessories', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46415', 'Wholesale of Footwear, All Kinds of Materials', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46416', 'Wholesale of Embroideries', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46417', 'Wholesale of Cordage, Rope and Twine', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46418', 'Wholesale of Leather and Leather Goods, Including Man-made Leather, Except Footwear', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46419', 'Wholesale of Textiles, Clothing and Footwear, N.e.c.', NULL, '4641');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46421', 'Wholesale of Medicinal and Pharmaceutical Products', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46422', 'Wholesale of Surgical and Orthopedic Instruments and Devices', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46423', 'Wholesale of Photographic and Optical Goods', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46424', 'Wholesale of Musical Instruments/sporting Goods (Including Bicycles), and Games and Toys', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46425', 'Wholesale of Paper and Paper Products (Including Stationeries)', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46426', 'Wholesale of Books, Magazines and Newspapers', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46427', 'Wholesale of Perfumeries, Cosmetics and Soaps', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46428', 'Wholesale of Watches, Clocks and Jewelries', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46429', 'Wholesale of Miscellaneous Consumer Goods, N.e.c.', NULL, '4642');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46491', 'Wholesale of Household-type Appliances, Except Radio and Television Equipment, Cd and Dvd Players/recorders', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46492', 'Wholesale of Household Furniture, Furnishing and Fixtures', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46493', 'Wholesale of Recorded Audio and Video Tapes, Cds, Dvds', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46494', 'Wholesale of Chinaware, Glassware, Earthenware, Woodenware, Wickerware, Corkware, Plasticware, Cutlery and Utensils', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46495', 'Wholesale of Handicraft Products', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46496', 'Wholesale of Lighting Equipment', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46497', 'Wholesale of Radio and Television Including Parts and Accessories', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46499', 'Wholesale of Other Household Goods, N.e.c.', NULL, '4649');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46510', 'Wholesale of Computers, Computer Peripheral Equipment and Software\n', '\nThis class includes :\nWholesale of computers and computer peripheral equipment\nWholesale of software.\nThis class excludes :\nWholesale of electronic parts, see 4652;\nWholesale of office machinery and equipment, (except computers and peripheral equipment), see 4659;\nWholesale of computer-controlled machinery, see 4659.', '4651');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46521', 'Wholesale of Electronic Valves and Tubes', NULL, '4652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46522', 'Wholesale of Semi-conductor Devices', NULL, '4652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46523', 'Wholesale Micro-chips and Integrated Circuits', NULL, '4652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46524', 'Wholesale of Printed Circuits', NULL, '4652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46525', 'Wholesale of Telephone and Communications Equipment Including Parts and Accessories', NULL, '4652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46526', 'Wholesale of Blank Audio and Video Tapes and Diskettes, Magnetic and Optical Disks (Cds, Dvds)', NULL, '4652');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46530', 'Wholesale of Agricultural Machinery, Equipment and Supplies\n', '\nThis class includes :\nWholesale of agricultural machinery and equipment :\nploughs, manure spreaders, seeders\nharvesters\nthreshers\nmilking machines\npoultry-keeping machines, bee-keeping machines\ntractors used in agriculture and forestry\nThis class also includes lawn mowers however operated', '4653');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46591', 'Wholesale of Commercial Machinery and Equipment', NULL, '4659');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46592', 'Wholesale of Industrial Machinery and Equipment', NULL, '4659');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46593', 'Wholesale of Office Machinery Equipment Including Office Furniture, Furnishings, Appliances and Vases', NULL, '4659');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46594', 'Wholesale of Professional and Scientific and Measuring and Controlling Equipment', NULL, '4659');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46595', 'Wholesale of Transport Equipment and Supplies, Except Land Motor Vehicles, Motorcycles and Bicycles', NULL, '4659');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46599', 'Wholesale of Other Machinery and Equipment, N.e.c.', NULL, '4659');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46610', 'Wholesale of Solid, Liquid and Gaseous Fuels and Related Products\n', '\nThis class includes :\nWholesale of automotive fuels, greases, lubricants, oils, such as :\ncharcoal, coal, coke, fuel wood, naphtha\ncrude petroleum, crude oil, diesel fuel, gasoline, fuel oil, heating oil, kerosene\nliquefied petroleum gases, butane and propane gas\nlubricating oils and greases, refined petroleum products', '4661');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46620', 'Wholesale of Metals and Metal Ores\n', '\nThis class includes :\nWholesale of ferrous and non-ferrous metal ores\nWholesale of ferrous and non-ferrous metals in primary forms\nWholesale of ferrous and non-ferrous semi-finished metal products, n.e.c\nWholesale of gold and other precious metals.\nThis class excludes wholesale of metal scrap, see 4669.', '4662');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46631', 'Wholesale of Lumber and Planing Mill Products, Wood in the Rough', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46632', 'Wholesale of Cement, Hydraulic', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46633', 'Wholesale of Masonry Materials, Except Cement', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46634', 'Wholesale of Flat Glass', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46635', 'Wholesale of Hardware, Paints, Varnishes and Lacquers, and Plumbing Materials, Including Fittings and Fixtures', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46636', 'Wholesale of Electrical Materials', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46637', 'Wholesale of Wallpaper and Floor Coverings', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46639', 'Wholesale of Construction Materials and Supplies, N.e.c.', NULL, '4663');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46691', 'Wholesale of Industrial Chemical Products', NULL, '4669');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46692', 'Wholesale of Fertilizers and Agro-chemical Products', NULL, '4669');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46693', 'Wholesale of Non-metallic Products Except Cement, Sand and Gravel', NULL, '4669');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46694', 'Wholesale of Scrap Metals, Waste and Junk', NULL, '4669');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46695', 'Wholesale of Scraps, Except Metal', NULL, '4669');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46699', 'Wholesale of Other Waste and Scrap and Other Products, N.e.c.', NULL, '4669');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('46900', 'Non-specialized Wholesale Trade\n', '\nThis class includes wholesale of a variety of goods without any particular specialization', '4690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47111', 'Retail Selling in Groceries', NULL, '4711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47112', 'Retail Selling in Supermarkets', NULL, '4711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47113', 'Retail Selling in Sari-sari Stores', NULL, '4711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47114', 'Retail Selling in Convenience Stores', NULL, '4711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47115', 'Retail Selling in Hypermarkets', NULL, '4711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47116', 'Retail Selling of Food Products in Pasalubong Store/center', NULL, '4711');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47191', 'Retail Selling in Department Stores', NULL, '4719');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47199', 'Retail Selling in Non-specialized Stores, N.e.c.', NULL, '4719');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47211', 'Retail Sale of Fruits and Vegetables', NULL, '4721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47212', 'Retail Sale of Eggs and Dairy Products', NULL, '4721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47213', 'Retail Sale of Meat and Poultry Products', NULL, '4721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47214', 'Retail Sale of Bakery Products', NULL, '4721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47215', 'Retail Sale of Fish and Other Seafood (Fresh and Dried)', NULL, '4721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47216', 'Retail Sale of Rice, Corn and Other Cereals', NULL, '4721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47219', 'Retail Sale of Food Products, N.e.c.', NULL, '4721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47221', 'Retail Sale of Alcoholic Beverages (Not Consumed on the Spot)', NULL, '4722');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47222', 'Retail Sale of Non-alcoholic Beverages (Not Consumed on the Spot)', NULL, '4722');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47230', 'Retail Sale of Tobacco Products in Specialized Stores', NULL, '4723');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47300', 'Retail Sale of Automotive Fuel in Specialized Stores\n', '\nThis includes the retail sale of fuel for motor vehicles and motorcycles, including lubricating products and cooling products for motor vehicles.\nThis class excludes :\nWholesale of fuels, see 4661;\nRetail sale of fuel in combination with food, beverages, etc., with food and beverage sales dominating, see 4711;\nRetail sale of liquefied petroleum gas for cooking or heating, see 4775.', '4730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47411', 'Retail Sale of Computers', NULL, '4741');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47412', 'Retail Sale of Computer Peripheral Equipment', NULL, '4741');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47413', 'Retail Sale of Computer Software', NULL, '4741');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47414', 'Retail Sale of Mobile Phones and Other Handheld Mobile Devices (E.g. Cellular Phones, Smart Phones, Tablets)', NULL, '4741');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47415', 'Retail Sale of Parts and Accessories of Cellular Phones and Other Handheld Mobile Devices', NULL, '4741');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47419', 'Retail Sale of Other Telecommunications Equipment, N.e.c.', NULL, '4741');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47421', 'Retail Sale of Radio and Television, Including Parts and Accessories', NULL, '4742');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47422', 'Retail Sale of Audio and Video Equipment', NULL, '4742');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47423', 'Retail Sale of Stereo Equipment, Cd and Dvd Players and Equipment', NULL, '4742');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47429', 'Retail Sale of Audio and Video Equipment, N.e.c.', NULL, '4742');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47511', 'Retail Sale of Textiles, All Kinds', NULL, '4751');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47512', 'Retail Sale of Modistesnull Supplies', NULL, '4751');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47521', 'Retail Sale of Hardware Materials', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47522', 'Retail Sale of Glass and Mirror', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47523', 'Retail Sale of Lumber', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47524', 'Retail Sale of Construction Materials', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47525', 'Retail Sale of Masonry Materials', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47526', 'Retail Sale of Nipa, Bamboo and Rattan', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47527', 'Retail Sale of Paints, Varnishes and Lacquers', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47529', 'Retail Sale of Construction Supplies, N.e.c.', NULL, '4752');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47530', 'Retail Sale of Carpets, Rugs, Wall and Floor Coverings in Specialized Stores\n', '\nThis subclass includes carpets and rugs, curtains and net curtains, wallpaper and floor coverings.\nThis excludes retail sale of cork floor tiles, see 4752.', '4753');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47591', 'Retail Sale of Home Furnishing, Furniture and Fixtures, Including Lamps and Lamp Shades', NULL, '4759');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47592', 'Retail Sale of Chinaware, Glassware, Earthenware and Utensils', NULL, '4759');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47593', 'Retail Sale of Household Appliances, Articles and Equipment', NULL, '4759');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47594', 'Retail Sale of Musical Instruments and Records, Tapes and Cartridges', NULL, '4759');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47595', 'Retail Sale of Handicrafts', NULL, '4759');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47599', 'Retail Sale of Electrical Household Appliances, Furniture, Lighting Equipment and Other Household Articles in Specialized Stores, N.e.c.', NULL, '4759');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47610', 'Retail Sale of Books, Newspapers and Stationery in Specialized Stores\n', '\nThis class includes retail sale of books of all kinds, newspapers and stationery. It also includes retail sale of office supplies such as pens, pencils, paper, etc.\nThis class excludes retail sale of second-hand or antique books, see 4774.', '4761');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47620', 'Retail Sale of Music and Video Recordings in Specialized Stores\n', '\nThis class includes retail sale of musical records, audio tapes, compact discs and cassettes, video tapes and DVDs. This class also includes retail sale of blank tapes and discs.', '4762');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47631', 'Retail Sale of Sporting Goods and Athletic Supplies', NULL, '4763');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47632', 'Retail Sale of Marine Supplies, Including Nets and Gears', NULL, '4763');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47633', 'Retail Sale of Camping Goods and Bicycles', NULL, '4763');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47640', 'Retail Sale of Games and Toys in Specialized Stores\n', 'This class includes retail sale of games and toys, made of all materials.\nThis class excludes retail sale of video game consoles; and non-customized software, including video games, see 4741.', '4764');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47711', 'Retail Sale of Wearing Apparel, Except Footwear', NULL, '4771');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47712', 'Retail Sale of Made-up Textile Goods', NULL, '4771');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47713', 'Retail Sale of Footwear, All Kinds', NULL, '4771');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47714', 'Retail Sale of Leather and Artificial Leather Goods and Travel Accessories, Except Footwear', NULL, '4771');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47719', 'Retail Sale of Other Clothing, Footwear and Leather Articles in Specialized Stores, N.e.c.', NULL, '4771');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47721', 'Retail Sale of Drugs and Pharmaceutical Goods', NULL, '4772');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47722', 'Retail Sale of Medical, Surgical and Orthopedic Goods/instruments and Dental Supplies', NULL, '4772');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47723', 'Retail Sale of Perfumery, Cosmetic and Toilet Articles', NULL, '4772');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47731', 'Retail Sale of Feeds, Fertilizers and Insecticides', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47732', 'Retail Sale of Gifts and Novelty Goods', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47733', 'Retail Sale of Office Machines and Equipment, Excluding Computers and Computer Peripheral Equipment', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47734', 'Retail Sale of Jewelry, Watches and Clocks', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47735', 'Retail Sale of Fresh and Artificial Flowers and Plants', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47736', 'Retail Sale of Beauty Parlor Supplies and Equipment', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47737', 'Retail Sale of Art Goods, Marble Products, Painting and Artistsnull Supplies', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47738', 'Retail Sale of Optical Goods and Supplies', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47739', 'Other Retail Sale of New Goods in Specialized Stores, N.e.c.', NULL, '4773');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47741', 'Retail Sale of Second-hand Clothing, Footwear and Leather Articles', NULL, '4774');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47742', 'Retail Sale of Books and Other Goods', NULL, '4774');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47743', 'Retail Sale of Antiques and Auctioning Houses', NULL, '4774');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47749', 'Retail Sale of Second-hand Goods, N.e.c.', NULL, '4774');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47750', 'Retail Sale of Liquefied Petroleum Gas and Other Fuel Products', NULL, '4775');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47761', 'Retail Sale of Pet', NULL, '4776');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47762', 'Retail Sale of Pet Supplies', NULL, '4776');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47810', 'Retail Sale Via Stalls and Markets of Food, Beverages and Tobacco Products\n', 'This class includes retail sale of food, beverages and tobacco products via stalls or markets.\nThis class excludes retail sale of prepared food for immediate consumption (mobile food vendors), see 5610.', '4781');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47820', 'Retail Sale Via Stalls and Markets of Textiles, Clothing and Footwear', NULL, '4782');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47891', 'Retail Sale of Prepaid Cards', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47892', 'Retail Sale of Internet Card', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47893', 'Retail Sale of Electronic Load', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47894', 'Retail Sale of Music and Video Recordings', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47895', 'Retail Sale of Household Appliances and Consumer Electronics', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47896', 'Retail Sale of Books', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47897', 'Retail Sale of Games and Toys', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47898', 'Retail Sale of Carpets and Rugs', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47899', 'Other Retail Sale Via Stalls and Markets of Other Goods, N.e.c.', NULL, '4789');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47911', 'Retail Sale Via Mail Order', NULL, '4791');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47912', 'Retail Sale Via Telephone Order', NULL, '4791');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47913', 'Retail Sale Via Internet', NULL, '4791');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47991', 'Door-to-door Retailing', NULL, '4799');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47992', 'Selling by Vending Machine', NULL, '4799');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47993', 'Retail Sale of Health Products, Non-store', NULL, '4799');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47994', 'Retail Sale of Water (Including Distribution)', NULL, '4799');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('47999', 'Other Retail Sale Not in Stores, Stalls or Markets, N.e.c', NULL, '4799');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49111', 'Inter-urban Passenger Railway Transport', NULL, '4911');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49112', 'Urban and Suburban Passenger Railway Transport', NULL, '4911');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49120', 'Freight Rail Transport\n', 'This class includes freight transport by inter-urban, suburban and urban railways.\nThis class excludes :\nStorage and warehousing, see 5210;\nFreight terminal activities, see 5221;\nCargo handling, see 5224.', '4912');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49201', 'Inter-urban Bus Line Operation', NULL, '4920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49202', 'Urban and Suburban Bus Line Operation', NULL, '4920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49203', 'Local Bus Line Operation', NULL, '4920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49204', 'Chartered Buses Operation (E.g. Tourist Buses, Renting of Bus)', NULL, '4920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49205', 'Operation of School Buses/shuttle', NULL, '4920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49209', 'Transport Via Buses, N.e.c.', NULL, '4920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49310', 'Urban or Suburban Passenger Land Transport, Except Railway or Bus\n', '\nThis class includes :\nLand transport of passengers by urban or suburban transport systems except by buses and railways. This may include different modes of street land transport. The transport is carried out on scheduled routes, on a fixed time schedule at normally fixed stops.\nThis class also includes :\nTown-to-airport or town-to-station lines\nOperation of funicular railways, aerial cableways etc.\nThis class excludes passenger transport by inter-urban railways, see 4911.', '4931');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49321', 'Jeepney and Uv Express Operation', NULL, '4932');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49322', 'Tricycles and Pedicabs Operation', NULL, '4932');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49323', 'Public Utility Cars and Taxicabs Operation', NULL, '4932');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49324', 'Chartered Cars (Rent-a-car)', NULL, '4932');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49325', 'Operations of Vehicles for Transportation Network Service (Ride-sharing Services)', NULL, '4932');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49326', 'Public Utility Electric Vehicle (Ev) Operation such as Plug-in Electric Vehicle (Pev), Battery Electric Vehicle (Bev) and Hybrid Electric Vehicle (Hev)', NULL, '4932');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49329', 'Other Land Transport Operation, N.e.c.', NULL, '4932');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49331', 'Truck-for-hire Operation (With Driver)', NULL, '4933');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49332', 'Freight Truck Operation', NULL, '4933');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49333', 'Tank Truck Delivery Services', NULL, '4933');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49339', 'Freight Transport Operation, by Road, N.e.c.', NULL, '4933');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('49400', 'Transport Via Pipeline\n', 'This class includes transport of gases, liquids, water, slurry and other commodities via pipelines. It also includes operation of pump stations.\nThis class excludes distribution of natural or manufactured gas, water or steam, see 3520,3530,3600; transport of water, liquids, etc, by trucks, see 4933.', '4940');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50111', 'Ocean Passenger Transport', NULL, '5011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50112', 'Interisland Water Passenger Transport', NULL, '5011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50113', 'Renting of Ship with Operator', NULL, '5011');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50121', 'Ocean Freight Transport', NULL, '5012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50122', 'Interisland Water Freight Transport', NULL, '5012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50123', 'Towing and Pushing Services on Coastal and Trans-oceanic Waters', NULL, '5012');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50210', 'Inland Passenger Water Transport\n', '\nThis class includes transport of passenger via rivers, canals, lakes and other inland waterways, including inside harbors and ports. It also includes rental of pleasure boats with crew for inland water transport.', '5021');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('50220', 'Inland Freight Water Transport\n', '\nThis class includes transport of freight via rivers, canals, lakes and other inland waterways, including inside harbor and ports.', '5022');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('51101', 'Domestic Air Passenger Transport', NULL, '5110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('51102', 'International Air Passenger Transport', NULL, '5110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('51103', 'Non-scheduled Air Passenger Transport', NULL, '5110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('51201', 'Domestic Air-freight Transport', NULL, '5120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('51202', 'International Air Freight Transport', NULL, '5120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('51203', 'Non-scheduled Air Freight Transport', NULL, '5120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52101', 'General Bonded Warehouses Except Grain Warehouse', NULL, '5210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52102', 'Grain Warehouses', NULL, '5210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52103', 'Customs Bonded Warehouses', NULL, '5210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52104', 'Cold Storage', NULL, '5210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52109', 'Storage and Warehousing, N.e.c.', NULL, '5210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52211', 'Freight Terminal Facilities for Trucking Companies', NULL, '5221');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52212', 'Operation of Parking Lots', NULL, '5221');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52213', 'Operation of Toll Roads and Bridges', NULL, '5221');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52219', 'Other Supporting Land Transport Activities, Including Towing Services and Truck Weighing Services, N.e.c.', NULL, '5221');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52220', 'Service Activities Incidental to Water Transportation\n', '\nThis class includes :\nActivities related to water transport of passengers, animals or freight :\noperation of terminal facilities such as harbors and piers\noperation of waterway locks, etc\nnavigation, pilotage and berthing activities\nlighterage, salvage activities\nlighthouse activities\nThis class excludes :\nCargo handling, see 5224;\nOperation of marinas, see 9329.', '5222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52230', 'Service Activities Incidental to Air Transportation\n', '\nThis class includes :\nActivities related to air transport of passengers, animals or freight:\noperation of terminal facilities such as airway terminals, etc.\nairport and air-traffic-control activities\nground service activities on airfields, etc.\nThis class also includes firefighting and fire-prevention services at airports.\nThis class excludes :\nCargo handling, see 5224;\nOperation of flying schools, see 8559.', '5223');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52241', 'Containerized Cargo Handling, Auxiliary Activity to Land Transport', NULL, '5224');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52242', 'Non- Containerized Cargo Handling, Auxiliary Activity to Land Transport', NULL, '5224');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52243', 'Cargo Handling, Auxiliary Activity to Water Transport', NULL, '5224');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52244', 'Cargo Handling, Auxiliary Activity to Air Transport', NULL, '5224');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52291', 'Freight Forwarding Services', NULL, '5229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52292', 'Customs Brokerage (Ship and Aircraft)', NULL, '5229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52293', 'Logistics Services', NULL, '5229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('52299', 'Activities of Other Transport Agencies, N.e.c.', NULL, '5229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('53100', 'Postal Activities\n', '\nThis class includes :\nPickup, sorting, transport and delivery (domestic or international) of letter-post and (mail-type) parcels and packages by postal services operating under a universal service obligation. One or more modes of transport may be involved and the activity may be carried out with either self-owned (private) transport or via public transport.\nCollection of letter-mail and parcels from public letter-boxes or from post offices\nDistribution and delivery of mail and parcels\nThis class excludes postal giro, postal savings activities and money order activities, see 6419.', '5310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('53201', 'Private Postal Service', NULL, '5320');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('53202', 'Messenger Service', NULL, '5320');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('53203', 'Delivery of Food', NULL, '5320');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('53209', 'Other Courier Activities, N.e.c.', NULL, '5320');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55101', 'Hotels', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55102', 'Resort Hotels', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55103', 'Condotels', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55104', 'Pension Houses', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55105', 'Camping Sites/facilities', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55106', 'Motels', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55107', 'Tourist Inn', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55109', 'Other Short Term Accommodation Activities, N.e.c', NULL, '5510');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55901', 'Dormitories/boarding Houses', NULL, '5590');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('55909', 'Other Accommodation, N.e.c.', NULL, '5590');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56101', 'Restaurants (Full-service)', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56102', 'Fast-food Restaurants/ Quick Service Restaurant', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56103', 'Cafeterias', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56104', 'Refreshment Stands, Kiosks and Counters', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56105', 'Mobile Food Services E.g., Truck, Van and Other Motorized Vehicles and Non-motorized Carts', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56106', 'Buffet and Eat-all-you-can Restaurants', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56107', 'Carinderia or Eatery', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56108', 'Food-to-go Counter (E.g., Fried/lechon/grilled Chicken, Pork, Beef or Fish and Other Related Products)', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56109', 'Other Restaurants and Mobile Food Service Activities, N.e.c.', NULL, '5610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56210', 'Event Catering\n', '\nThis class includes the provision of food services based on contractual arrangements with the customer, at the location specified by the customer, for a specific event.\nThis class excludes manufacture of perishable food items for resale, see 1079; retail sale of perishable food items, see division 47.', '5621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56290', 'Other Food Service Activities\n', '\nThis class includes industrial catering, i.e., the provision of food services based on contractual arrangements with the customer, for a specific period of time.\nAlso included is the operation of food concessions at sports and similar facilities. The food is often prepared in a central unit.\nThis class includes :\nActivities of food service contractors (e.g. for transportation companies)\nOperation of food concessions at sports and similar facilities\nOperation of canteens or cafeterias (e.g. for factories, offices, hospitals or schools) on a concession basis\nThis class excludes :\nManufacture of perishable food items for resale, see 1079;\nRetail sale of perishable food items, see division 47.', '5629');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56301', 'Night Clubs', NULL, '5630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56302', 'Bars and Cocktail Lounges', NULL, '5630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56303', 'Café or Coffee Shops', NULL, '5630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56304', 'Tea Shops', NULL, '5630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('56309', 'Other Beverage Serving Activities, N.e.c.', NULL, '5630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('58110', 'Book Publishing\n', '\nThis class includes the activities of publishing books in print, electronic (CD, electronic displays, etc.) or audio form or on the Internet.\nThis class includes :\nPublishing of books, brochures, leaflets and similar publications, including publishing of dictionaries and encyclopedia\nPublishing of atlases, maps and charts\nPublishing of audio books\nPublishing of encyclopedias, etc. on CD-ROM\nThis class excludes :\nProduction of globes, see 329;\nPublishing of advertising material, see 5819;\nPublishing of music and sheet books, see 5920;\nActivities of independent authors, see 9000.', '5811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('58120', 'Publishing of Directories and Mailing Lists\n', '\nThis class includes the publishing of lists of facts/information (databases), that are protected in their form, but not in their content. These lists can be published in printed or electronic form.\nThis class includes :\nPublishing of mailing lists\nPublishing of telephone books\nPublishing of other directories and compilations, such as case law, pharmaceutical compendia, etc.', '5812');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('58130', 'Publishing of Newspapers, Journals and Periodicals\n', '\nThis class includes the activities of publishing newspapers, including advertising newspapers as well as periodicals and other journals. This information can be published in print or electronic form, including on the Internet. Publishing of radio and television schedules is included here.', '5813');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('58190', 'Other Publishing Activities\n', '\nThis class includes:\nPublishing (including on-line) of :\ncatalogs\nphotos, engravings and postcards\ngreeting cards\nforms\nposters, reproduction of works of art\nadvertising material\nother printed matter\nThis class also includes on-line publishing of statistics or other information.\nThis class excludes :\nRetail sale of software, see 4741;\nPublishing of advertising newspapers, see 5813;\nOn-line provision of software (application hosting and application service provisioning), see 6311.', '5819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('58200', 'Software Publishing\n', '\nThis class includes :\nPublishing of ready-made (non-customized) software :\noperating systems\nbusiness and other applications\ncomputer games for all platforms\nThis class excludes :\nReproduction of software, see 1820;\nRetail sale of non-customized software, see 4741;\nProduction of software not associated with publishing, see 6201;\nOn-line provision of software (application hosting and application software provisioning), see 6311.', '5820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59111', 'Complete Production of Motion Picture, Video and Television Programme Activities', NULL, '5911');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59112', 'Pre and Main Production of Traditional and 2d Animation', NULL, '5911');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59113', 'Pre and Main Production of 3d Animation', NULL, '5911');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59119', 'Pre and Main Production of Other Motion Films and Etc.', NULL, '5911');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59121', 'Post Production of Traditional and 2d Animation', NULL, '5912');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59122', 'Post Production of 3d Animation', NULL, '5912');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59129', 'Post Production of Other Motion Films and Etc.', NULL, '5912');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59130', 'Motion Picture, Video and Television Programme Distribution Activities\n', '\nThis class includes distributing film, video tapes, DVDs and similar productions to motion picture theatres, television networks and stations and exhibitors.\nThis class also includes acquiring film, video tape and DVD distribution rights.\nThis class excludes :\nFilm duplicating (except reproduction of motion picture film for theatrical distribution ) as well as reproduction of audio and video tapes, CDs or DVDs from master copies, see 1820;\nReproduction of motion picture film for theatrical distribution, see 5912.', '5913');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59140', 'Motion Picture Projection Activities\n', '\nThis class includes the motion picture or video tape projection in cinemas, in the open air or in other projection facilities.', '5914');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59201', 'Sound Recording Activities', NULL, '5920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('59202', 'Publishing of Music', NULL, '5920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('60101', 'Radio Broadcasting and Relay Station and Studios', NULL, '6010');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('60102', 'Radio Program Production', NULL, '6010');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('60103', 'Radio Broadcasting Activities Over the Internet (Internet Radio Stations)', NULL, '6010');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('60201', 'Television Broadcasting and Relay Stations and Studios Including Closed Circuit Television Services', NULL, '6020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('60202', 'Television Program Production', NULL, '6020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('60203', 'Television Broadcasting Activities Over the Internet (Internet Television Stations)', NULL, '6020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61101', 'Wired (Landline) Services', NULL, '6110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61102', 'Wired Internet Access Service Activities (E.g. Dsl, Leased Line, Dial-up)', NULL, '6110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61103', 'Telegraph, Facsimile/telefax, and Telex Services', NULL, '6110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61109', 'Other Wired Telecommunications Activities', NULL, '6110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61201', 'Wireless Landline Services', NULL, '6120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61202', 'Mobile Telecommunications Services', NULL, '6120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61203', 'Wireless Internet Access Services (E.g. Internet Service Provider, Broadband)', NULL, '6120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61209', 'Other Wireless Telecommunication Services, N.e.c.\n', '\nThis class excludes telecommunications resellers, see 6190.', '6120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61300', 'Satellite Telecommunications Activities\n', '\nThis class includes :\nOperating, maintaining or providing access to facilities for the transmission of voice, data, text, sound and video using a satellite telecommunications infrastructure\nDelivery of visual, aural or textual programming received from cable networks, local television stations, or radio networks to consumers via direct-to-home satellite systems. ( The units classified here do not generally originate programming material)\nThis class also includes provision of Internet access by the operator of the satellite infrastructure\nThis class excludes telecommunications resellers, see 6190.', '6130');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61901', 'Telephone Access in Facilities Open to the Public Service Activities', NULL, '6190');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61902', 'Internet Access in Facilities Open to the Public Service Activities', NULL, '6190');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61903', 'Voice Over Internet Protocol (Voip) Service Activities', NULL, '6190');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('61909', 'Other Telecommunications Service Activities, N.e.c.', NULL, '6190');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('62011', 'Game Design and Development', NULL, '6201');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('62019', 'Other Computer Programming Activities', NULL, '6201');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('62020', 'Computer Consultancy and Computer Facilities Management Activities\n', '\nThis class includes the planning and designing of computer systems that integrate computer hardware, software and communication technologies.\nThe units classified in this class may provide the hardware and software components of the system as part of their integrated services or these components may be provided by third parties or vendors. The units classified in this class often install the system and train and support the users of the system.\nThis class also includes the provision of on-site management and operation of clientsNULL computer systems and/or data processing facilities, as well as related support services.\nThis class excludes :\nSeparate sale of computer hardware or software, see 4651,4741.\nSeparate installation of mainframe and similar computers, see 3320.\nSeparate installation (setting-up) of personal computers, see 6209.\nSeparate software installation, see 6209.', '6202');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('62090', 'Other Information Technology and Computer Service Activities\n', '\nThis class includes other information and computer related activities not elsewhere classified, such as :\ncomputer disaster recovery\ninstallation (setting-up) of personal computers\nsoftware installation\nThis class excludes :\nInstallation of mainframe and similar computers, see 3320;\nComputer programming, see 6201;\nComputer consultancy, see 6202;\nComputer facilities management, see 6202;\nData processing and hosting, see 6311.', '6209');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('63111', 'Data Processing', NULL, '6311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('63112', 'Website Hosting Services', NULL, '6311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('63113', 'Application Hosting Services', NULL, '6311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('63120', 'Web Portals\n', '\nThis class includes :\nOperation of web sites that use a search engine to generate and maintain extensive databases of Internet addresses and content in an easily searchable format\nOperation of other web sites that act as portals to the Internet, such as media sites providing periodically updated content', '6312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('63910', 'News Agency Activities\n', '\nThis class includes news syndicate and news agency activities furnishing news, pictures and features to the media.\nThis class excludes activities of independent photo journalists, see 7420; activities of independent journalists, see 9000.', '6391');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('63990', 'Other Information Service Activities, N.e.c.\n', '\nThis class includes other information service activities not elsewhere classified such as :\ntelephone base information services\ninformation search services on a contract or fee basis\nnews clipping services, press clipping services, etc.\nThis class excludes activities of call centers, see 8221.', '6399');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64110', 'Central Banking\n', '\nThis class includes :\nIssuing and managing the countryNULLs currency\nMonitoring and control of the money supply\nTaking deposits that are used for clearance between financial institutions\nSupervising banking operations\nHolding the countryNULLs international reserves\nActing as banker to the government\nThe activities of central banks will vary for institutional reasons.', '6411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64191', 'Universal Banking', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64192', 'Commercial Banking', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64193', 'Thrift Banking', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64194', 'Private Development Banking', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64195', 'Stock Savings and Loan Activities', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64196', 'Rural Banking', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64197', 'Cooperative Banking', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64198', 'Specialized Government Banking', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64199', 'Other Monetary Intermediation I.e., Islamic Banking, N.e.c.', NULL, '6419');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64200', 'Activities of Holding Companies\n', '\nThis class includes the activities of holding companies, i.e. units that hold the assets (owning, controlling-levels of equity) of a group of subsidiary corporations and whose principal activity is owning the group. The holding companies in this class do not provide any other service to the businesses in which the equity is held, i.e. they do not administer or manage other units.\nThis class excludes active management of companies and enterprises, strategic planning and decision making of the company, see 7010.', '6420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64301', 'Investment Company Operation', NULL, '6430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64302', 'Investment House Operation', NULL, '6430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64303', 'Securities Dealership, Own Account', NULL, '6430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64304', 'Trust Corporation Operation', NULL, '6430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64305', 'Mutual Fund Company Operation', NULL, '6430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64910', 'Financial Leasing\n', '\nThis refers to the business of extending credit through a non-cancelable lease contract under which the lessor purchases or acquires, at the instance of the lessee, machinery, equipment, motor vehicles, appliances, business and office machines, and other movable or immovable property in consideration of the periodic payment by the lessee of a fixed amount of money sufficient to amortize at least seventy percent (70%) of the purchase price or acquisition cost, including any incidental expenses and a margin of profit over an obligatory period of not less than two (2) years during which the lessee has the right to hold and use the leased property with the right to expense the lease rentals paid to the lessor and bears the cost of repairs, maintenance, insurance and preservation thereof, but with no obligation or option on his part to purchase the leased property from the owner-lessor at the end of the lease contract.\nThis class excludes operational leasing, see division 77, according to type of goods leased.', '6491');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64921', 'Credit Card Activities', NULL, '6492');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64922', 'Lending Company Operation', NULL, '6492');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64923', 'Financing Company Operations', NULL, '6492');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64924', 'Venture Capital Corporation Operation', NULL, '6492');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64925', 'Credit Granting Entity Operation', NULL, '6492');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64929', 'Other Credit Granting, N.e.c', NULL, '6492');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64930', 'Pawnshop Operations\n', '\nThis group refers to the business of lending money on personal property physically delivered to the control and possession of the pawnshop operator as loan collateral. Allowable corollary activities of those engaged in pawnshop operations shall include money changing and/or performing as remittance agent, as may be registered with the Bangko Sentral ng Pilipinas.\nThis category covers pawnshop with single activity and those whose primary activity is lending money on personal property.\nPawnshops may also engage in other business activities such as acting as bills payment agent for utility companies and other entities, ticketing agent for airline companies, and other similar business activities provided that the appropriate department of the BSP shall be notified within five (5) working days from the date of actual engagement of the pawnshop in such business activity.', '6493');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64991', 'Mutual Building and Loan Association Operation', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64992', 'Non-stock Savings and Loan Association Operation', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64993', 'Credit Cooperative Activities', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64994', 'Mutual Benefit Association Operation', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64995', 'Foreign Exchange Dealing/ Money Changing (Money Service Businesses (Msbs))', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64996', 'Remittance and Transfer Operations (Msbs)', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64997', 'Other Msbs, I.e., Virtual Currency Exchange Dealing', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('64999', 'Non-bank Thrift Institution Operations, N.e.c.', NULL, '6499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('65110', 'Life Insurance\n', '\nThis class includes :\nUnderwriting annuities and life insurance policies, disability income insurance policies, and accidental death and dismemberment insurance policies (with or without a substantial savings element)', '6511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('65120', 'Non-life Insurance\n', '\nThis class includes :\nProvision of insurance services other than life insurance: accident and fire insurance, health insurance, travel insurance, property insurance, motor, marine, aviation and transport insurance and pecuniary loss and liability insurance.', '6512');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('65201', 'Reinsurance for Life Insurance', NULL, '6520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('65202', 'Reinsurance for Non-life Insurance', NULL, '6520');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('65300', 'Pension Funding\n', '\nThis class includes legal entities (i.e. funds, plans and/or programs) organized to provide retirement income benefits exclusively for the sponsorNULLs employees or members. This includes pension plans with defined benefits, as well as individual plans where benefits are simply defined through the memberNULLs contribution.\nThis class includes :\nEmployee benefit plans\nPension funds\nRetirement plans\nThis class excludes :\nManagement of pension funds, see 6630;\nCompulsory social security schemes, see 8430.', '6530');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66110', 'Administration of Financial Markets\n', '\nThis class includes the operation and supervision of financial markets other than by public authorities, such as :\nCommodity contracts exchanges\nFutures commodity contracts exchanges\nSecurities exchanges\nStock exchanges and stock or commodity options exchanges.', '6611');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66120', 'Security and Commodity Contracts Brokerage\n', '\nThis class includes :\nDealing in financial markets on behalf of others (e.g. stock broking) and related activities;\nSecurities brokerage\nCommodity contracts brokerage\nActivities of bureaux de change etc.\nThis class excludes :\nDealing in markets on own account, see 6499;\nPortfolio management, on a fee or contract basis, see 6630.', '6612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66190', 'Other Activities Auxiliary to Financial Service Activities\n', '\nThis class includes activities auxiliary to financial service activities not elsewhere classified, such as :\nfinancial transaction processing and settlement activities, including for credit card transactions\ninvestment advisory services\nactivities of mortgage advisers and brokers\nThis class also includes trustee, fiduciary and custody services on a fee or contract basis.\nThis class excludes :\nActivities of insurance agents and brokers, see 6622;\nManagement of funds, see 6630.', '6619');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66210', 'Risk and Damage Evaluation\n', '\nThis includes the provision of administration services of insurance, such as assessing and settling insurance claims.\nThis class includes :\nAssessing insurance claims: claims adjusting, risk assessing, risk and damage evaluation and average and loss adjusting.\nSettling insurance claims\nThis class excludes :\nAppraisal of real estate, see 6820;\nAppraisal for other purposes, see 7490;\nInvestigation activities, see 8030.', '6621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66220', 'Activities of Insurance Agents and Brokers\n', '\nThis class includes the activities of insurance agents and brokers (insurance intermediaries) in selling, negotiating or soliciting of annuities and insurance and reinsurance policies.', '6622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66231', 'Pre-need Plan for Health', NULL, '6623');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66232', 'Pre-need Plan for Education', NULL, '6623');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66233', 'Pre-need Plan for Memorial and Interment', NULL, '6623');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66234', 'Pre-need Plan for Pension', NULL, '6623');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66239', 'Pre-need Plan Activities, N.e.c.', NULL, '6623');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66290', 'Other Activities Auxiliary to Insurance and Pension Funding\n', '\nThis class includes :\nActivities involved in or closely related to insurance and pension funding (except financial intermediation, claims adjusting and activities of insurance agents) :\nsalvage administration\nactuarial services\nThis class excludes marine salvage activities, see 5222.', '6629');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('66300', 'Fund Management Activities\n', '\nThis class includes portfolio and fund management activities on a fee or contract basis, for individuals, businesses and others.\nThis class includes :\nManagement of mutual funds\nManagement of other investment funds\nManagement of pension funds', '6630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('68110', 'Real Estate Buying, Selling, Renting, Leasing and Operating of Self-owned/leased Apartment Buildings, Non-residential and Dwellings', NULL, '6811');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('68120', 'Real Estate Buying, Developing, Subdividing and Selling, of Residential Including Mass Housing', NULL, '6812');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('68131', 'Cemetery Development, Selling, Renting, Leasing and Operating of Self-owned Cemetery', NULL, '6813');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('68132', 'Columbarium Development, Selling, Renting, Leasing and Operating of Self-owned Columbarium (Including Burial Crypt)', NULL, '6813');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('68140', 'Renting or Leasing Services of Residential Properties', NULL, '6814');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('68190', 'Other Real Estate Activities with Own or Leased Property', NULL, '6819');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('68200', 'Real Estate Activities on a Fee or Contract Basis\n', '\nThis class includes the provision of real estate activities on a fee or contract basis including real estate related services.\nThis class includes :\nActivities or real estate agents and brokers\nIntermediation in buying, selling and renting of real estate on a fee or contract basis\nManagement of real estate on a fee or contract basis\nAppraisal services for real estate\nActivities of real estate escrow agents\nThis class excludes :\nLegal activities, see 6910;\nFacilities support services, see 8110;\nManagement of facilities, such as military bases, prisons, and other facilities (except computer facilities management), see 8110.', '6820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('69100', 'Legal Activities\n', '\nThis class includes :\nLegal representation of one partyNULLs interest against another party, whether or not before courts or other judicial bodies by, or under supervision of, persons who are members of the bar :\nadvice and representation in civil cases\nadvice and representation in criminal cases\nadvice and representation in connection with labor disputes\nGeneral counseling and advising, preparation of legal documents :\narticles of incorporation, partnership agreements or similar documents in connection with company formation\npatents and copyrights\npreparation of deeds, wills, trusts, etc.\nOther activities of notaries public, civil law notaries, bailiffs, arbitrators, examiners and referees.\nThis class excludes law court activities, see 8423.', '6910');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('69200', 'Accounting, Bookkeeping and Auditing Activities; Tax Consultancy\n', '\nThis class includes :\nRecording of commercial transactions from businesses or others\nPreparation or auditing of financial accounts\nExamination of accounts and certification of their accuracy\nPreparation of personal and business income tax returns\nAdvisory activities and representation on behalf of clients before tax authorities\nThis class excludes :\nData processing and tabulation activities, see 6311;\nManagement consultancy activities, such as design of accounting systems, cost accounting programs, budgetary control procedures, see 7020;\nBill collection, see 8291.', '6920');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('70100', 'Activities of Head Offices\n', '\nThis class includes the overseeing and managing of other units of the company or enterprise; undertaking the strategic or organizational planning and decision making role of the company or enterprise. Units in this class exercise operational control and manage the day-to-day operations of their related units.\nThis class also includes activities of head offices, centralized administrative offices, corporate offices, district, regional offices/operating headquarters, subsidiary management offices.\nThis class excludes activities of holding companies, not engaged in managing, see 6420.', '7010');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('70200', 'Management Consultancy Activities\n', '\nThis class includes the provision of advice, guidance and operational assistance to businesses and other organizations on management issues, such as strategic and organizational planning; decision areas that are financial in nature; marketing objectives and policies; human resource policies, practices and planning; production scheduling and control planning.\nThis provision of business services may include advice, guidance or operational assistance to businesses and the public service regarding :\npublic relations and communication\nlobbying activities\ndesign of accounting methods or procedures, cost accounting programs, budgetary control procedures\nadvice and help to business and public services in planning, organization, efficiency and control, management information etc.\nThis class excludes :\nDesign of computer software for accounting systems, see 6201;\nLegal advice and representation, see 6910;\nAccounting, bookkeeping and auditing activities, tax consulting, see 6920;\nArchitectural, engineering and other technical advisory activities, see 7110, 7490;\nAdvertising activities, see 7310;\nMarket research and public opinion polling, see 7320;\nExecutive placement or search consulting services, see 7810;\nEducational consulting activities, see 8560.', '7020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('71101', 'Environmental Engineering Activities', NULL, '7110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('71102', 'Architectural and Other Engineering Activities', NULL, '7110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('71103', 'Land Surveying Services', NULL, '7110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('71109', 'Other Technical Activities Related to Architectural and Engineering', NULL, '7110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('71200', 'Technical Testing and Analysis\n', '\nThis class includes the performance of physical, chemical and other analytical testing of all types of materials and products, including :\nacoustics and vibration testing\ntesting of composition and purity of minerals etc.\ntesting activities in the field of food hygiene, including veterinary testing and control in relation to food production\ntesting of physical characteristics and performance of materials, such as strength, thickness, durability, radioactivity, etc.\nqualification and reliability testing\nperformance testing of complete machinery: motors, automobiles, electronic equipment, etc.\nradiographic testing of welds and joints\nfailure analysis\ntesting and measuring of environmental indicators: air and water pollution, etc.\nCertification of products, including consumer goods, motor vehicles, aircraft, pressurized containers, nuclear plants, etc.\nPeriodic road-safety testing of motor vehicles\nTesting with use of models or mock-ups (e.g. of aircraft, ships, dams, etc)\nOperation of police laboratories\nThis class excludes :\nTesting of animal specimens, see 7500;\nMedical laboratory testing, see 8690.', '7120');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('72101', 'Research and Experimental Development in Natural Sciences', NULL, '7210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('72102', 'Research and Experimental Development in Engineering and Technology', NULL, '7210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('72103', 'Research and Experimental Development in Health Sciences', NULL, '7210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('72104', 'Research and Experimental Development in Agricultural Sciences', NULL, '7210');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('72200', 'Research and Experimental Development on Social Sciences and Humanities\n', '\nThis class includes :\nResearch and development on social sciences\nResearch and development on humanities\nInterdisciplinary research and development, predominantly on social sciences and humanities\nThis class excludes market research, see 7320.', '7220');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('72300', 'Research and Experimental Development in Information Technology\n', '\nThis subclass includes Research and Development (R & D) in :\nHuman interface technologies, which are largely graphical in structure, facilitate communication between computer systems and their users; communication technologies which comprise the information infrastructure for improving computer-to-computer communication.\nSystems support technologies which include development of software programmed to carry out specific tasks in a system.', '7230');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('73101', 'Advertising Agency, Except Billboard and Outdoor Advertising', NULL, '7310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('73102', 'Billboard and Outdoor Advertising Services', NULL, '7310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('73103', 'Media Representation', NULL, '7310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('73104', 'Commercial Art Services', NULL, '7310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('73109', 'Advertising Services, N.e.c.', NULL, '7310');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('73200', 'Market Research and Public Opinion Polling\n', '\nThis subclass includes :\nInvestigation into market potential, acceptance and familiarity of products and buying habits of consumers for the purpose of sales promotion and development of new products, including statistical analyses of the results.\nInvestigation into collective opinions of the public about political, economic and social issues and statistical analysis thereof.', '7320');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74101', 'Fashion Design', NULL, '7410');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74102', 'Interior Decoration Services Other Than Those in Class 4330', NULL, '7410');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74201', 'Digital Photograph Processing', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74202', 'Commercial and Consumer Photograph Production (Except Aerial Photography)', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74203', 'Photograph and Motion Pictures Processing (Not Related to Motion Pictures and Tv Industries)', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74204', 'Film Developing and Printing and Photograph Enlarging', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74205', 'Aerial Photography', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74206', 'Microfilming Activities', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74207', 'Underwater Photography', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74209', 'Photographic Activities, N.e.c.', NULL, '7420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74901', 'Business Brokerage Activities', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74902', 'Weather Forecasting and Meteorological Services', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74903', 'Translation and Interpretation Services', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74904', 'Environmental Consulting Services', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74905', 'Statistical and Data Analytics Consulting Services', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74906', 'Food Safety Consulting Services', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74907', 'Halal Consulting Services', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('74909', 'Other Professional, Scientific and Technical Activities, N.e.c.', NULL, '7490');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('75000', 'Veterinary Activities\n', '\nThis class includes animal health care and control activities for farm and pet animals.\nThis activities are carried out by qualified veterinarians when working in veterinary hospitals as well as when visiting farms, kennels or homes, in own consulting and surgery rooms or elsewhere.\nThis class also includes :\nActivities of veterinary assistants or other auxiliary veterinary personnel\nClinico-pathological and other diagnostic activities pertaining to animals\nAnimal ambulance activities\nThis class excludes :\nFarm animal boarding activities without health care, see 0156;\nSheep shearing, see 0156;\nHerd testing services, droving services, agistment services, poultry caponizing, see 0156;\nActivities related to artificial insemination, see 0156;\nPet animal boarding activities without health care, see 9690.', '7500');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77100', 'Renting and Leasing of Motor Vehicles (Except Motorcycle, Caravans, Campers)\n', '\nThis class includes :\nRenting and operational leasing of the following types of vehicles:\npassenger cars (without drivers)\ntrucks, utility trailers and recreational vehicles\nThis class excludes :\nRenting or leasing of vehicles or trucks with driver, see 4932, 4933;\nFinancial leasing, see 6491;\nRenting and operational leasing of land-transport equipment (other than motor vehicles) without drivers, see 773.', '7710');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77210', 'Renting and Leasing of Recreational and Sports Goods\n', '\nThis class includes renting of recreational and sports equipment :\npleasure boats, canoes, sailboats\nbicycles\nbeach chairs and umbrellas\nother sports equipment\nThis class excludes :\nRenting of video tapes and disks, see 7722;\nRenting of other personal and household goods n.e.c., see 7729;\nRenting of leisure and pleasure equipment as an integral part of recreational facilities, see 9329.', '7721');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77220', 'Renting of Video Tapes and Disks\n', '\nThis class includes the renting of videotapes, record, CDNULLs DVDNULLs, etc.', '7722');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77291', 'Renting of Wearing Apparel', NULL, '7729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77292', 'Renting of Furniture', NULL, '7729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77293', 'Renting of Books, Journals and Magazines', NULL, '7729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77294', 'Renting of Ornamental Plants', NULL, '7729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77295', 'Renting of Electrical Appliances', NULL, '7729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77296', 'Renting of Audio-video Machines', NULL, '7729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77299', 'Renting of Personal and Household Goods, N.e.c.', NULL, '7729');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77301', 'Renting of Land Transport Equipment', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77302', 'Renting of Water Transport Equipment', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77303', 'Renting of Air Transport Equipment', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77304', 'Renting of Agricultural Machinery and Equipment', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77305', 'Renting of Construction and Civil Engineering Machinery and Equipment', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77306', 'Renting of Computers and Computer Peripherals Equipment', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77307', 'Renting of Office Machinery and Equipment (Excluding Computers)', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77309', 'Renting and Leasing of Other Machinery, Equipment and Tangible Goods, N.e.c.', NULL, '7730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('77400', 'Leasing of Intellectual Property and Similar Products, Except Copyrighted Works\n', '\nThis class includes the activities of allowing others to use of intellectual property products and similar products for which a royalty payment or licensing fee is paid to the owner of the product (i.e. the asset holder). The leasing of these product can take various forms, such as permission for reproduction, use in subsequent processes or products, operating businesses under a franchise etc. The current owners may or may not have created these products.\nThis class includes :\nLeasing of intellectual property products (except copyrighted works, such as books or software)\nReceiving royalties or licensing fee for the use of :\npatented entities\ntrademarks or service marks\nbrand names\nmineral exploration and evaluation\nfranchise agreements\nThis class excludes :\nAcquisition of rights and publishing, see divisions 58, 59;\nProducing, reproducing and distributing copyrighted works (books, software, film), see division 58, 59;\nLeasing of real estate, see group 681;\nLeasing of tangible products (assets), see groups 771, 772, 773;\nRenting of video tapes and disks, see 7722;\nRenting of books, see 7729.', '7740');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78101', 'Labor Recruitment and Provision of Personnel, Local', NULL, '7810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78102', 'Labor Recruitment and Provision of Personnel, Overseas', NULL, '7810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78103', 'On-line Employment Placement Agencies', NULL, '7810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78104', 'Casting Agencies Activities', NULL, '7810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78109', 'Other Activities of Employment Placement Agencies, N.e.c.', NULL, '7810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78201', 'Temporary Labor Recruitment and Provision of Personnel, Local', NULL, '7820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78202', 'Temporary Labor Recruitment and Provision of Personnel, Overseas', NULL, '7820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('78300', 'Other Human Resources Provision\n', '\nThis class includes provision of human resources for client businesses.\nThis provision of human resources is typically done on a long-term or permanent basis and the units classified here may perform a wide range of human resource and personnel management duties associated with this provision.\nThe units classified here represent the employer of record for the employees on matters relating to payroll, taxes, and other fiscal and human resource issues, but they are not responsible for direction and supervision of employees.\nThis class excludes :\nProvision of human resources functions together with supervision or running of the business, see the class in the respective economic activity of that business;\nProvision of human resources to temporarily replace or supplement the workforce of the client, see 7820.', '7830');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79110', 'Travel Agency Activities\n', '\nThis class includes the activities of agencies primarily engaged in selling travel, tour, transportation and accommodation services to the general public and commercial clients.', '7911');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79120', 'Tour Operator Activities\n', '\nThis class includes :\nArranging and assembling tours that are sold through travel agencies or directly by tour operators. The tours may include any or all of the following :\ntransportation\naccommodation\nfood\nvisits to museums, historical or cultural sites, theatrical, musical or sporting events', '7912');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79901', 'Activities of Booking Offices', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79902', 'Accommodation Reservation Activities', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79903', 'Transportation Reservation Activities', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79904', 'Package Tour Reservation Activities', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79905', 'Tourist Assistance Activities (E.g. Tourist Guides)', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79906', 'Tickets Sales/booking, for Theatrical, Entertainment and Recreational Reservation Activities', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79907', 'Visitor Information Activities', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79908', 'Activities of Transportation Network Service', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('79909', 'Other Reservation Service and Related Activities, N.e.c.', NULL, '7990');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('80100', 'Private Security Activities\n', '\nThis class includes the provision of one or more of the following : guard and patrol services, picking up and delivering money, receipts, or other valuable items with personnel and equipment to protect such properties while in transit.\nThis class includes :\narmored car services\nbodyguard services\npolygraph services\nfingerprinting services\nsecurity guard services\nThis class excludes public order and safety activities, see 8423.', '8010');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('80200', 'Security Systems Service Activities\n', '\nThis class includes :\nMonitoring or remote monitoring of electronic security alarm systems, such as burglar and fire alarms, including their maintenance\nInstalling, repairing, rebuilding, and adjusting mechanical or electronic locking devices, safes and security vaults\nThe units carrying out these activities may also engage in selling such security systems, mechanical or electronic locking devices, safes and security vaults\nThis class excludes :\nInstallation of security systems, such as burglar and fire alarms, without later monitoring, see 4321.\nSelling security systems, mechanical or electronic locking devices, safes and security vaults, without monitoring, installation or maintenance services, see 4759;\nSecurity consultants, see 7490;\nPublic order and safety activities, see 8423;\nProviding key duplication services, see 9529.', '8020');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('80300', 'Investigation Activities\n', '\nThis class includes:\nInvestigation and detective service activities\nActivities of all private investigators, independent of the type of client or purpose of investigation', '8030');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('81100', 'Combined Facilities Support Activities\n', '\nThis class includes :\nProvision of a combination of support services within a clientNULLs facility, such as general interior cleaning, maintenance, trash disposal, guard and security, mail routing, reception, laundry and related services to support operations within facilities.\nUnits classified here provide operating staff to carry out these support activities, but are not involved with or responsible for the core business or activities of the client.\nThis class excludes :\nProvision of only one of the support services (e.g. general interior cleaning services) or addressing only a single function (e.g. heating), see the appropriate class according to the service provided;\nProvision of management and operating staff for the complete operation of a clientNULLs establishment, such as a hotel, restaurant, mine or hospital, see the class of the unit operated;\nProvision of on site management and operation of a clientNULLs computer systems and/or data processing facilities, see 6202;\nOperation of correctional facilities on a contract or fee basis, see 8423.', '8110');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('81210', 'General Cleaning of Buildings\n', '\nThis class includes :\nGeneral (non-specialized) cleaning activities of all types of buildings, such as :\noffices\nhouses or apartments\nfactories\nshops\ninstitutions\nGeneral (non-specialized) cleaning of other business and professional premises and multiunit residential buildings\nThese activities cover mostly interior cleaning although they may include the cleaning of associated exterior areas such as windows or passageways.\nThis class excludes :\nSpecialized interior cleaning activities, such as chimney cleaning, cleaning of fireplaces, stoves, furnaces, incinerators, boilers, ventilation ducts, exhaust units, see 8129.', '8121');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('81291', 'Industrial Cleaning Activities', NULL, '8129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('81292', 'Pest Control Services, Non-agricultural', NULL, '8129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('81299', 'Other Building and Industrial Cleaning Activities, N.e.c.', NULL, '8129');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('81300', 'Landscape Care and Maintenance Service Activities\n', '\nThis class includes :\nPlanting, care and maintenance of :\nParks and gardens for :\nprivate and public housing\npublic and semi-public buildings (schools, hospitals, administrative buildings, church buildings, etc)\nmunicipal grounds (parks, green areas, cemeteries, etc.)\nhighway greenery (roads, train lines and tramlines, waterways, ports)\nindustrial and commercial buildings\nGreenery for :\nbuildings (roof gardens, facade greenery, indoor gardens)\nsports grounds (e.g. football fields, golf courses etc.) play grounds, lawns for sunbathing and other recreational parks\nstationary and flowing water (basins, alternating wet areas, ponds, swimming pools, ditches, watercourses, plant sewage systems)\nPlants for protection against noise, wind, erosion, visibility and dazzling\nThis class also includes maintenance of land in order to keep it in good ecological condition\nThis class excludes :\nCommercial production and planting for commercial production of plants, trees, see division 01, 02;\nTree nurseries (except forest tree nurseries), see 0130;\nMaintenance of land to keep it in good condition for agricultural use, see 015;\nConstruction activities for landscaping purposes, see Section F;\nLandscape design and architecture activities, see 7110;\nOperation of botanical gardens, see 9103.', '8130');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82110', 'Combined Office Administrative Service Activities\n', '\nThis class includes the provision of a combination of day-to-day office administrative services, such as reception, financial planning, billing and record keeping, personnel and physical distribution (mail services) and logistics for others on a contract or fee basis.\nThis class excludes :\nProvision of operating staff to carry out the complete operations of a business, see class according to the business/activity performed;\nProvision of only one particular aspect of these activities, see class according to that particular activity.', '8211');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82191', 'Photocopying Service Activities', NULL, '8219');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82192', 'Duplicating and Mailing Activities', NULL, '8219');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82199', 'Other Specialized Office Support Activities', NULL, '8219');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82211', 'Customer Relationship Management Activities', NULL, '8221');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82212', 'Sales and Marketing (Including Telemarketing) Activities', NULL, '8221');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82219', 'Other Call Centers Activities (Voice), N.e.c.', NULL, '8221');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82221', 'Finance and Accounting Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82222', 'Human Resources and Training Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82223', 'Administrative Support Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82224', 'Document Processes Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82225', 'Payroll Maintenance and Other Transaction Processing Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82226', 'Medical Transcription Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82227', 'Legal Services Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82228', 'Supply Chain Management Activities', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82229', 'Other Back Office Operations Activities, N.e.c', NULL, '8222');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82291', 'Engineering Outsourcing Activities', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82292', 'Product Development Activities', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82293', 'Publishing Outsourcing Activities', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82294', 'Research and Analysis Activities', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82295', 'Intellectual Property Research and Documentation Activities', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82296', 'Security Outsourcing Activities', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82297', 'Knowledge Process Outsourcing (Kpo) Activities', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82299', 'Other Non-voice Related Activities, N.e.c.', NULL, '8229');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82301', 'Conventions, Trade Shows, Exhibits, Conferences and Meetings Activities', NULL, '8230');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82309', 'Other Organization of Conventions and Trade Shows, N.e.c.\r', NULL, '8230');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82910', 'Activities of Collection Agencies and Credit Bureaus\n', '\nThis class includes :\nCollection of payments for claims and remittance of payments collected to the clients, such as bill or debt collection services (e.g. bills payment center)\nActivities of compiling information, such as credit and employment histories on individuals and credit histories on businesses and providing the information to financial institutions, retailers and others who have a need to evaluate the creditworthiness of these persons and businesses.', '8291');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82920', 'Packaging Activities\n', '\nThis class includes :\nPackaging activities on a fee or contract basis, whether or not these involve an automated process:\nbottling of liquids, including beverages and food\npackaging of solids (blister packaging, foil covered etc.)\nsecurity packaging of pharmaceutical preparations\nlabeling, stamping and imprinting\nparcel-packing and gift wrapping\nThis class excludes :\nManufacture of soft drinks and production of mineral water, see 1104 and 1105;\nPackaging activities incidental to transport, see 5229.', '8292');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('82990', 'Other Business Support Service Activities, N.e.c.\n', '\nThis class includes support activities, such as :\nProviding verbatim reporting and stenotype recording of live legal proceedings and transcribing subsequent recorded materials, such as :\ncourt reporting or stenotype recording services\npublic stenography services\nReal-time (i.e. simultaneous) closed captioning of live television performances of meetings, conferences\nAddress bar coding services\nBar code imprinting services\nFundraising organization services on a contract or fee basis\nMail presorting services\nRepossession services\nParking meter coin collection services\nActivities of independent auctioneers\nAdministration of loyalty programmers\nOther support activities typically provided to businesses not elsewhere classified.\nThis class excludes :\nProvision of document transcription services, see 8219;\nProviding film or tape captioning or subtitling services, see 5912.', '8299');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84111', 'National Executive and Legislative Administration', NULL, '8411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84112', 'Public Administration, Regional Government', NULL, '8411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84113', 'Public Administration, Local Government', NULL, '8411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84114', 'Public Administration and Supervision of Financial and Fiscal Affairs; Operation of Taxation Schemes', NULL, '8411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84115', 'Ancillary Service Activities for the Government as a Whole', NULL, '8411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84119', 'General Public Administration Activities, N.e.c.', NULL, '8411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84120', 'Regulation of the Activities of Providing Health Care, Education, Cultural Services and Other Social Services, Excluding Social Security\n', '\nThis class includes:\nPublic administration of programs aimed to increase personal well-being :\nhealth\neducation\nculture\nsport\nrecreation\nenvironment\nhousing\nsocial services\nPublic administration of R&D policies and associated funds for these areas.\nThis class also includes :\nSponsoring of recreational and cultural activities\nDistribution of public grants to artists\nAdministration of potable water supply programs\nAdministration of waste collection and disposal operations\nAdministration of environmental protection programs\nAdministration of housing programs\nThis class excludes :\nSewage, refuse disposal and remediation activities, see division 37, 38 39;\nCompulsory social security activities, see 8430;\nEducation activities, see division 85;\nHuman health-related activities, see division 86;\nActivities of libraries and public archives, (private, public or government operated) see 9101;\nOperation of museums and other cultural institutions, see 9102;\nSporting or other recreational activities, see division 93.', '8412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84130', 'Regulation of and Contribution to More Efficient Operation of Businesses\n', '\nThis class includes :\nPublic administration and regulation, including subsidy allocation, for different economic sectors:\nagriculture\nland use\nenergy and mining resources\ninfrastructure\ntransport\ncommunication\nhotels and tourism\nwholesale and retail trade\nAdministration of R&D policies and associated funds to improve economic performance\nAdministration of general labor affairs\nImplementation of regional development policy measures, e.g. to reduce unemployment\nThis class excludes scientific research and development, see division 72.', '8413');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84210', 'Foreign Affairs\n', '\nThis class includes :\nAdministration and operation of the ministry of foreign affairs and diplomatic and consular missions stationed abroad or at offices of international organizations\nAdministration, operation and support for information and cultural services intended for distribution beyond national boundaries\nAid to foreign countries, whether or not routed through international organizations\nProvision of military aid to foreign countries\nManagement of foreign trade, international financial and foreign technical affairs.\nThis class excludes international disaster or conflict refugee services, see 8890.', '8421');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84220', 'Defense Activities\n', '\nThis class includes :\nAdministration, supervision and operation of military defense affairs and land, sea, air and space defense forces such as :\ncombat forces of army, navy and air force\nengineering, transport, communications, intelligence, material, personnel and other non-combat forces and commands\nreserve and auxiliary forces of the defense establishment\nmilitary logistics (provision of equipment, structures, supplies, etc.)\nhealth activities for military personnel in the field\nAdministration, operation and support of civil defense forces\nSupport for the working out of contingency plans and the carrying out of exercises in which civilian institutions and populations are involved\nAdministration of defense-related R&D policies and related funds\nThis class excludes :\nScientific research and development, see division 72;\nProvision of military aid to foreign countries, see 8421;\nActivities of military tribunals, see 8423;\nProvision of supplies for domestic emergency use in case of peacetime disasters, see 8423;\nEducational activities of military schools, colleges and academies, see 8540;\nActivities of military hospitals, see 8610.', '8422');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84230', 'Public Order and Safety Activities\n', '\nThis class includes :\nAdministration and operation of regular and auxiliary police forces supported by public authorities and of port, border, coastguards and other special police forces, including traffic regulation, alien registration, maintenance of arrest records\nFirefighting and fire prevention : administration and operation of regular and auxiliary fire brigades in fire prevention, firefighting, rescue of persons and animals, assistance in civic disasters, floods, road accidents, etc.\nAdministration and operation of administrative civil and criminal law courts, military tribunals and the judicial system, including legal representation and advice on behalf of the government or when provided by the government in cash or services\nRendering of judgements and interpretations of the law\nArbitration of civil actions\nPrison administration and provision of correctional services, including rehabilitation services, regardless of whether their administration and operation is done by government units or by private units on a contract or fee basis\nProvision of supplies for domestic emergency use in case of peacetime disasters\nThis class excludes :\nForestry fire-protection and fire-fighting services, see 0240;\nOil and gas field fire fighting, see 0910;\nFirefighting and fire-prevention services at airports provided by non-specialized units, see 5223;\nAdvice and representation in civil, criminal and other cases, see 6910;\nOperation of police laboratories, see 7120;\nAdministration and operation of military armed forces, see 8422;\nActivities of prison schools, see division 85;\nActivities of prison hospitals, see 8610.', '8423');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('84300', 'Compulsory Social Security Activities\n', '\nThis class includes :\nFunding and administration of government-provided social security programs:\nsickness, work-accident and unemployment insurance\nretirement pensions\nprogrammes covering losses of income due to maternity and temporary disablement, widowhood, etc.\nThis class excludes :\nNon-compulsory social security, see 6530;\nProvision of welfare services and social work (without accommodation), see 8810, 8890.', '8430');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85111', 'Public Pre-primary/pre-school Education', NULL, '8511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85112', 'Private Pre-primary/pre-school Education', NULL, '8511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85121', 'Public Pre-primary Education for Children with Special Needs', NULL, '8512');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85122', 'Private Pre-primary and Primary Education for Children with Special Needs', NULL, '8512');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85211', 'Public Primary/elementary Education', NULL, '8521');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85212', 'Private Primary/elementary Education', NULL, '8521');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85221', 'Public Primary/elementary Education for Children with Special Needs', NULL, '8522');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85222', 'Private Primary/elementary Education for Children with Special Needs', NULL, '8522');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85311', 'Public General Secondary Education', NULL, '8531');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85312', 'Private General Secondary Education', NULL, '8531');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85321', 'Public General Secondary Education for Children with Special Needs', NULL, '8532');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85322', 'Private General Secondary Education for Children with Special Needs', NULL, '8532');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85331', 'Public Technical and Vocational Secondary Education', NULL, '8533');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85332', 'Private Technical and Vocational Secondary Education', NULL, '8533');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85341', 'Public Technical and Vocational Secondary Education for Children with Special Needs', NULL, '8534');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85342', 'Private Technical and Vocational Secondary Education for Children with Special Needs', NULL, '8534');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85401', 'Public Higher Education', NULL, '8540');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85402', 'Private Higher Education', NULL, '8540');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85510', 'Sports and Recreation Education\n', '\nThis class includes the provision of instruction in athletic activities to groups or individuals, such as by camps and schools. Overnight and day sports instruction camps, are also included.\nThis class does not include activities of academic schools, colleges and universities. Instruction may be provided in diverse settings, such as the unitNULLs or clientNULLs training facilities, educational institutions or by other means. Instructions provided in this class is formally organized.\nThis class includes :\nSports, instruction (basketball, volleyball, baseball, football, crickets, etc.)\nCamps, sports instruction\nCheerleading instruction\nGymnastics instruction\nRiding instruction, academies or school\nSwimming instruction\nProfessional sports, instructors, teachers, coaches\nMartial arts instruction\nCard game instruction, (such as bridge)\nYoga instruction\nThis class excludes cultural education, see 8552.', '8551');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85520', 'Cultural Education\n', '\nThis class includes provision of instruction in the arts, drama and music. Units giving this type of instructions might be named \"schools\", \"studies\", \"classes\", etc. They provide formally organized instruction, mainly for hobby , recreational or self-development purposes, but such instruction does not lead to a professional diploma, baccalaureate or graduate degree.\nThis class includes :\nPiano instruction and other music instruction\nArt instruction\nDance instruction and dance studios\nDrama schools (except academic)\nFine arts schools (except academic)\nPerforming arts schools (except academic)\nPhotography schools (except commercial)', '8552');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85591', 'Professional and Licensure Review Services', NULL, '8559');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85592', 'Training Centers and Facilities Activities Including Culinary, Caregiving, Language Proficiency', NULL, '8559');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85593', 'Online Tutorial Services', NULL, '8559');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85594', 'Driving Schools', NULL, '8559');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85599', 'Other Education, N.e.c.', NULL, '8559');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85601', 'Public Educational Support Services', NULL, '8560');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('85602', 'Private Educational Support Services', NULL, '8560');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86111', 'Public General Hospitals Activities', NULL, '8611');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86112', 'Public Sanitaria and Other Similar Activities', NULL, '8611');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86113', 'Public Mental Health and Substance Abuse Hospitals Activities', NULL, '8611');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86114', 'Public Maternity Hospitals Activities', NULL, '8611');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86119', 'Other Public Hospitals, Sanitaria and Other Similar Activities, N.e.c.', NULL, '8611');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86121', 'Private General Hospitals Activities', NULL, '8612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86122', 'Private Sanitaria and Other Similar Activities', NULL, '8612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86123', 'Private Mental Health and Substance Abuse Hospitals Activities', NULL, '8612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86124', 'Private Maternity Hospitals Activities', NULL, '8612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86129', 'Other Private Hospitals, Sanitaria and Other Similar Activities, N.e.c.', NULL, '8612');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86211', 'Public Medical Activities (Including Puericulture and Laboratory Services)', NULL, '8621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86212', 'Public Dental and Laboratory Services', NULL, '8621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86219', 'Public Medical, Dental and Other Health Activities, N.e.c.', NULL, '8621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86221', 'Private Medical Activities', NULL, '8622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86222', 'Private Dental and Laboratory Services', NULL, '8622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86223', 'Child Care/pediatric Clinic Services', NULL, '8622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86224', 'Medical and Diagnostic Laboratory Services', NULL, '8622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86225', 'Dialysis Center Activities', NULL, '8622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86229', 'Private Medical, Dental and Other Health Activities, N.e.c.', NULL, '8622');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('86900', 'Other Human Health Activities\n', '\nThis class includes :\nActivities for human health not performed by hospitals or by medical doctors or dentists :\nactivities of nurses, midwives, physiotherapists or other paramedical practitioners in the field of optometry, hydrotherapy, medical massage, occupational therapy, speech therapy, chiropody, homeopathy, chiropractic, acupuncture, etc..\nThese activities may be carried out in health clinics such as those attached to firms, schools, homes for the aged, labor organizations and fraternal organizations and in residential health facilities other than hospitals, as well as in own consulting rooms, patientNULLs homes or elsewhere. These activities do not involve medical treatment.\nThis class also includes :\nActivities of dental paramedical personnel such as dental therapists, school dental nurses and dental hygienists, who may work remote from, but are periodically supervised by the dentist\nActivities of medical laboratories such as: X-ray laboratories and other diagnostic imaging centers; blood analysis laboratories\nActivities of blood banks, sperm banks, transplant organ banks, etc.\nAmbulance transport of patients by any mode of transport including airplanes. These services are often provided during a medical emergency\nActivities of maternity and lying-in clinics\nThis class excludes :\nProduction of artificial teeth, denture and prosthetic appliances by dental laboratories, see 3250;\nTransfer of patients, with neither equipment for lifesaving nor medical personnel, see divisions 49, 50, 51;\nNon-medical laboratory testing, see 7120;\nTesting activities in the field of food hygiene, see 7120;\nHospital activities, see 861;\nMedical and dental practice activities, see 862;\nNursing care facilities, see 8710.', '8690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87100', 'Residential Nursing Care Facilities\n', '\nThis class includes activities of :\nhomes for the elderly with nursing care\nconvalescent homes\nrest homes with nursing care\nnursing care facilities\nnursing homes\nThis class excludes :\nIn-home services provided by health care professionals, see division 86;\nActivities of homes for the elderly without or with minimal nursing care, see 8730;\nSocial work activities with accommodation, such as orphanages, childrenNULLs boarding homes and hostels, temporary homeless shelters, see 8790.', '8710');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87201', 'Rehabilitation of People Addicted to Drugs or Alcohol', NULL, '8720');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87202', 'Caring for the Mentally and Physically Handicapped', NULL, '8720');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87209', 'Other Residential Care Activities for Mental Retardation, Mental Health and Substance Abuse, N.e.c.', NULL, '8720');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87300', 'Residential Care Activities for the Elderly and Disabled\n', '\nThis class includes the provision of residential and personal care services for the elderly and disabled who are unable to fully care for themselves and/or who do not desire to live independently. The care typically includes room, board, supervision and assistance in daily living, such as housekeeping services. In some instances these units provide skilled nursing care for residents in separate on-site facilities.\nThis class includes activities of :\nAssisted-living facilities\nContinuing care retirement communities\nHomes for the elderly with minimal nursing care\nRest homes without nursing care\nThis class excludes :\nActivities of homes for the elderly with nursing care, see 8710;\nSocial work activities with accommodation where medical treatment or accommodation are not important elements, see 8790.', '8730');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87901', 'Child Care Services', NULL, '8790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87902', 'Caring for Unwed Mothers and Children', NULL, '8790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87903', 'Caring for the Orphans', NULL, '8790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('87909', 'Other Residential Care Activities, N.e.c.', NULL, '8790');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88101', 'Welfare and Guidance Counseling Activities (Elderly and Disabled)', NULL, '8810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88102', 'Day-care Activities for the Elderly or for Handicapped Adults', NULL, '8810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88103', 'Vocational Rehabilitation and Habilitation Activities for Disabled Adults', NULL, '8810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88901', 'Welfare and Guidance Counseling Activities for Children and Adolescents', NULL, '8890');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88902', 'Child-care Activities (Including for the Handicapped)', NULL, '8890');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88903', 'Vocational Rehabilitation and Habilitation Activities for Unemployed Persons', NULL, '8890');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88904', 'Charitable Activities', NULL, '8890');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('88909', 'Other Social Work Activities without Accommodation, N.e.c.', NULL, '8890');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('90001', 'Concerts and Opera or Dance Production', NULL, '9000');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('90002', 'Live Theatrical Presentations and Other Stage Productions', NULL, '9000');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('90003', 'Individual Artists Activities', NULL, '9000');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('90004', 'Ancillary Theatrical Activities', NULL, '9000');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('90005', 'Art Galleries', NULL, '9000');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('90006', 'Operation of Concert and Theatre Halls and Other Arts Facilities', NULL, '9000');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('90009', 'Other Creative, Arts and Entertainment Activities, N.e.c.', NULL, '9000');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('91010', 'Library and Archives Activities\n', '\nThis class includes :\nDocumentation and information activities of libraries of all kinds, reading, listening and viewing rooms, public archives providing service to the general public or to a special clientele, such as students, scientists, staff, members as well as operation of government archives :\norganization of a collection, whether specialized or not\ncataloguing collections\nlending and storage of books, maps, periodicals, films, records, tapes, works of art, etc.\nretrieval activities in order to comply with information requests, etc.\nStock photo libraries and services', '9101');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('91020', 'Museums Activities and Operation of Historical Sites and Buildings\n', '\nThis class includes :\nOperation of museums of all kinds :\nart museums, museums of jewelry, furniture, costumes, ceramics, silverware\nnatural history, science and technological museums, historical museums, including military museums\nother specialized museums\nopen-air museums\nOperation of historical sites and buildings\nThis class excludes :\nRenovation and restoration of historical sites and buildings, see section F;\nRestoration of works of art and museum collection objects, see 9000;\nActivities of libraries and archives, see 9101.', '9102');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('91030', 'Botanical and Zoological Gardens and Nature Reserves Activities\n', '\nThis class includes :\nOperation of botanical and zoological gardens, including childrenNULLs zoos\nOperation of nature reserves, including wildlife preservation, etc.\nThis class excludes :\nLandscaping and gardening services, see 8130;\nOperation of sport fishing and hunting preserves, see 9319.', '9103');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('92000', 'Gambling and Betting Activities\n', '\nThis class includes :\nBookmaking and other betting operations\nOff-track betting\nOperation of casinos, including \"floating casinos\"\nSale of lottery tickets\nOperation (exploitation) of coin-operated gambling machines\nOperation of virtual gambling web sites\nThis class excludes : Operation (exploitation) of coin-operated games, see 9329.', '9200');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93110', 'Operation of Sports Facilities\n', '\nThis class includes :\nOperation of facilities for indoor or outdoor sports events (open, closed or covered, with or without spectator seating) :\nbasketball, volleyball, football, baseball\nracetracks for auto, dog, horse races\nswimming pools and stadiums\ntrack and field stadiums\nboxing arenas\ngolf courses\nbowling lanes\nfitness centers\nbadminton courts\nbilliard halls\nOrganization and operation of outdoor or indoor sports events for professionals or amateurs by organizations with own facilities.\nThis class includes managing and providing the staff to operate these facilities.\nThis class excludes :\nRenting of recreation and sports equipment, see 7721;\nPark and beach activities, see 9329.', '9311');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93120', 'Activities of Sports Clubs\n', '\nThis class includes the activities of sports clubs, which, whether professional, semi-professional or amateur clubs, give their members the opportunity to engage in sporting activities.\nThis class includes :\nOperation of sports clubs :\nbasketball clubs\nvolleyball clubs\nbadminton clubs\nfootball clubs\nbowling clubs\nswimming clubs\ngolf clubs\nboxing clubs\nbody-building clubs\nchess clubs\ntrack and field clubs\nshooting clubs, etc.\nThis class excludes :\nSports instruction by individual teachers, trainers, see 8551;\nOperation of sports facilities, see 9311;\nOrganization and operation of outdoor or indoor sports events for professionals or amateurs by sports clubs with their own facilities, see 9311.', '9312');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93190', 'Other Sports Activities\n', '\nThis class includes :\nActivities of producers or promoters of sports events, with or without facilities\nActivities of individual own-account sportsmen and athletes, referees, judges, timekeepers, etc.\nActivities of sports leagues and regulating bodies\nActivities related to promotion of sporting events\nActivities of racing stables, kennels and garages\nOperation of sport fishing and hunting preserves\nSupport activities for sport or recreational hunting and fishing\nThis class excludes :\nBreeding of racing horses, see 0142;\nRenting of sports equipment, see 7721;\nActivities of sports and game schools, see 8551;\nActivities of sports instructors, teachers, coaches, see 8541;\nOrganization and operation of outdoor or indoor sports events for professionals or amateurs by sports clubs with/without own facilities, see 9311,9312;\nPark and beach activities, see 9329.', '9319');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93210', 'Activities of Amusement Parks and Theme Parks\n', '\nThis class includes activities of amusement parks or theme parks. It includes the operation of a variety of attractions, such as mechanical rides, water rides, games, shows, theme exhibits and picnic grounds.', '9321');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93291', 'Operation of Ballrooms, Discotheques (Disconulls)', NULL, '9329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93292', 'Operation of Recreation Parks, Beaches, Including Renting of Facilities such as Bathhouses, Lockers, Chairs Etc.;', NULL, '9329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93293', 'Token, Coin or Cash-basis and Card-operated Games (Arcade)', NULL, '9329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93294', 'Indoor Playground and Playhouse Operations for Children', NULL, '9329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93295', 'Light And/or Sound System Operation for Fair and Shows, Discotheques and Dance Floor', NULL, '9329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('93299', 'Other Amusement and Recreation Activities, N.e.c.', NULL, '9329');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('94110', 'Activities of Business and Employers Membership Organizations\n', '\nThis class includes :\nActivities of organizations whose members interests center on the development and prosperity of enterprises in a particular line of business or trade, including farming, or on the economic growth and climate of a particular geographical area or political subdivision without regard for the line of business.\nActivities of federations of such associations\nActivities of chambers of commerce, guilds and similar organizations\nDissemination of information, representation before government agencies, public relations and labor negotiations of business and employer organizations\nThis class excludes activities of trade unions, see 9420.', '9411');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('94120', 'Activities of Professional Membership Organizations\n', '\nThis class includes :\nActivities of organizations whose membersNULL interests centre chiefly on a particular scholarly discipline or professional practice or technical field, such as medical associations, legal associations, accounting associations, engineering associations, architects associations, etc.\nActivities of associations of specialists engaged in scientific, academic or cultural activities, such as associations of writers, painters, performers of various kinds, journalists, etc.\nDissemination of information, the establishment and supervision of standards of practice, representation before government agencies and public relations of professional organizations\nThis class also includes activities of learned societies.\nThis class excludes education provided by these organizations, see division 85.', '9412');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('94200', 'Activities of Trade Unions\n', '\nThis class includes promoting of the interests of organized labor and union employees.\nThis class also includes :\nActivities of associations whose members are employees interested chiefly in the representation of their views concerning the salary and work situation, and in concerted action through the organization\nActivities of single plant unions, of unions composed of affiliated branches and of labor organizations composed of affiliated unions on the basis of trade, region, organizational structure or other criteria\nThis class excludes education provided by these organizations, see division 85.', '9420');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('94910', 'Activities of Religious Organizations\n', '\nThis class includes :\nActivities of religious organizations or individuals providing services directly to worshippers in churches, mosques, temples, synagogues or other places\nActivities of organizations providing monastery and convent services\nReligious retreat activities\nThis class also includes :\nReligious funeral service activities\nThis class excludes :\nEducation provided by such organizations, see division 85;\nHealth activities by such organizations, see division 86;\nSocial work activities by such organizations, see divisions 87and 88.', '9491');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('94920', 'Activities of Political Organizations\n', '\nThis class includes :\nActivities of political organizations and auxiliary organizations such as young peopleNULLs auxiliaries associated with a political party. These organizations chiefly engage in influencing decision-taking in public governing bodies by placing members of the party or those sympathetic to the party in political office and involve the dissemination of information, public relations, fund raising etc.', '9492');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('94990', 'Activities of Other Membership Organizations, N.e.c.\n', '\nThis class includes :\nActivities of organizations not directly affiliated to a political party furthering a public cause or issue by means of public education, political influence, fund raising etc.:\ncitizenNULLs initiative or protest movements\nenvironmental and ecological movements\norganizations supporting community and educational facilities n.e.c.\norganizations for the protection and betterment of special groups, e.g. ethnic and minority groups\nassociations for patriotic purposes, including war veteransNULL associations\nConsumer associations\nAutomobile associations\nAssociations for the purpose of social acquaintanceship such as rotary clubs, lodges etc.\nAssociations of youth, young personsNULL associations, student associations, clubs and fraternities etc.\nAssociations for the pursuit of a cultural or recreational activity or hobby (other than sports or games), e.g. poetry, literature and book clubs, historical clubs, gardening clubs, film and photo clubs, music and art clubs, craft and collectors clubs, social clubs, carnival clubs etc.\nThis class also includes grant giving activities by membership organizations or others\nThis class excludes :\nActivities of professional artistic groups or organizations, see 9000.\nActivities of sports clubs, see 9312;\nActivities of professional associations, see 9412.', '9499');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95110', 'Repair of Computers and Peripheral Equipment\n', '\nThis class includes the repair of electronic equipment, such as computers and computing machinery and peripheral equipment.\nThis class includes the repair and maintenance of:\nDesktop and laptop computers\nMagnetic disk drives, flash drives and other storage devices\nOptical disk drives (CD-RW, CD-ROM, DVD-ROM, DVD-RW)\nPrinters, monitors, keyboards\nMice, joysticks and trackball accessories\nInternal and external computer modems\nDedicated computer terminals\nComputer servers, scanners, including bar code scanners\nSmart cards readers, virtual reality helmets\nComputer projectors\nThis class also includes the repair and maintenance of:\nComputer terminals like automatic teller machines (ATMNULLs) point-of-sale (POS) terminals, not mechanically operated\nHand-held computers (PDANULLs)\nThis class excludes the repair and maintenance of carrier equipment modems, see 9512.', '9511');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95120', 'Repair of Communications Equipment\n', '\nThis class includes repair and maintenance of communications equipment such as :\nCordless telephones, mobile phones and other handheld mobile devices (e.g., cellular phones, smart phones, tablets) carrier equipment modems\nFax machines\nCommunications transmission equipment (e.g. routers, bridges, modems)\nTwo-way radios\nCommercial TV and video cameras', '9512');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95210', 'Repair of Consumer Electronics\n', '\nThis class includes repair and maintenance of consumer electronics including smart electronics:\nTelevision, radio receivers\nVideo cassette recorders (VCR)\nCD/DVD players\nHousehold-type video cameras\nDigital recorder, CCTVs, remote control devices, and other similar electronic devices.', '9521');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95221', 'Repair and Servicing of Household Appliances', NULL, '9522');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95222', 'Repair and Servicing of Home and Garden Equipment', NULL, '9522');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95231', 'Repair of Boots and Shoes', NULL, '9523');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95232', 'Repair of Luggage and Handbags', NULL, '9523');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95241', 'Repair of Wood Furniture', NULL, '9524');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95242', 'Repair of Rattan Furniture (Reed, Wicker and Cane)', NULL, '9524');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95243', 'Repair of Furniture and Fixtures of Metal', NULL, '9524');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95249', 'Repair of Other Furniture and Fixtures, N.e.c.', NULL, '9524');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95291', 'Repair and Alteration of Jewelry', NULL, '9529');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95292', 'Repair of Watches', NULL, '9529');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('95299', 'Other Repair of Personal and Household Goods, N.e.c.', NULL, '9529');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96101', 'Spa Activities', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96102', 'Steam and Bath Activities', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96103', 'Slendering and Body Building Activities', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96104', 'Beauty Treatment and Personal Grooming Activities', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96105', 'Beauty Parlor/salon Activities', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96106', 'Barber Shop Activities', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96107', 'Massage Parlor', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96109', 'Other Personal Services for Wellness Activities, N.e.c.', NULL, '9610');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96210', 'Washing and Dry Cleaning of Textile and Fur Products\n', '\nThis class includes :\nLaundering and dry-cleaning, pressing etc. of all kinds of clothing (including fur) and textiles, provided by mechanical equipment, by hand or by self-service coin-operated machines, whether for the general public or for industrial or commercial clients\nLaundry collection and delivery\nCarpet and rug shampooing and drapery and curtain cleaning, whether on clientsNULL premises or not\nProvision of linens, work uniforms and related items by laundries\nThis class also includes repair and minor alteration of garments or other textile articles when done in connection with cleaning.\nThis class excludes :\nRenting of clothing other than work uniforms, even if cleaning of these goods is an integral part of the activity, see 7730;\nRepair and alteration of clothing etc., as an independent activity, see 9529.', '9621');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96300', 'Funeral and Related Activities\n', '\nThis class includes :\nBurial and incineration of human or animal corpses and related activities :\npreparing the dead for burial or cremation and embalming and morticiansNULL services\nproviding burial or cremation services\nrental of equipped space in funeral parlors\nRental or sale of graves\nMaintenance of graves and mausoleums.\nThis class excludes religious funeral service activities, see 9491.', '9630');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96400', 'Domestic Services\n', '\nThis class includes maids, drivers, cooks, houseboys, gardeners, including governesses, tutors and personal secretaries, etc. employed in private households.', '9640');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96901', 'Social Escort Service Activities (Excluding Tourist Guides)', NULL, '9690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96902', 'Pet Boarding Activities', NULL, '9690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96903', 'Astrological and Spiritualist Activities', NULL, '9690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96904', 'Shoe Shiner, Porter, Valet Car Parker Activities', NULL, '9690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96905', 'Coin/bill/card-operated Machine Activities', NULL, '9690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96906', 'Event Planning/organizing Activities (E.g., Wedding, Birthday, Debut, Baptismal)', NULL, '9690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('96909', 'Miscellaneous Service Activities, N.e.c.', NULL, '9690');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('97000', 'Activities of Households as Employers of Domestic Personnel\n', '\nThis class includes :\nActivities of households as employers of domestic personnel such as maids, cooks, waiters, valets, butlers, laundresses, gardeners, gatekeepers, stable-lads, chauffeurs, caretakers, governesses, babysitters, tutors, secretaries, etc.\nIt allows the domestic personnel employed to state the activity of their employers in censuses or studies, even though the employer is an individual. The product produced by this activity is consumed by the employing household.\nThis class excludes :\nProvision of services such as cooking, gardening, etc. by independent service providers (companies or individuals), see PSIC class according to type of service.', '9700');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('98100', 'Undifferentiated Goods-producing Activities of Private Households for Own Use\n', '\nThis class includes :\nUndifferentiated subsistence goods - producing activities of households, i.e., the activities of households that are engaged in a variety of activities that produce goods for their own subsistence. These activities include hunting and gathering, farming, the production of shelter and clothing and other goods produced by the household for its own subsistence.\nIf households are also engaged in the production of marketed goods, they are classified to the appropriate goods-producing industry of PSIC.\nIf households are principally engaged in a specific goods-producing subsistence activity, they are classified to the appropriate goods-producing industry of PSIC.', '9810');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('98200', 'Undifferentiated Services-producing Activities of Private Households for Own Use\n', '\nThis class includes :\nUndifferentiated subsistence services-producing activities of households. These activities include cooking, teaching, caring for household members and other services produced by the household for its own subsistence.\nIf households are also engaged in the production of multiple goods for subsistence purposes, they are classified to the undifferentiated goods-producing subsistence activities of households.', '9820');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('99011', 'Foreign Diplomatic Missions', NULL, '9901');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('99012', 'International Organizations', NULL, '9901');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('99019', 'International Organizations and Extra-territorial Organizations and Bodies, N.e.c.', NULL, '9901');
INSERT INTO psic_subclass (code, description, details, classid) VALUES ('99090', 'Activities of Other International Organizations\n', '\nThis class includes activities of other international organizations mostly located and funded in the Philippines such as: Asia Pacific Economic Cooperation Center (APEC-Center), Southeast Asian Ministers of Education Organization (SEAMEO), SEAMEO Regional Center for Educational Innovation Technology and Regional Center for Graduate Study and Research in Agriculture (SEARCA).', '9909');


alter table lob change psic _psic varchar(255) null 
;
alter table lob change psic_objid _psic_objid varchar(50) null 
;
alter table lob add psicid varchar(50) NULL
;
DROP TABLE psic
;


update 
  lob aa, 
  ( 
    select lob.objid, s.code as psicid 
    from lob 
      inner join psic_subclass s on s.code = lob._psic_objid 
  )bb 
set 
  aa.psicid = bb.psicid 
where 
  aa.objid = bb.objid 
;

insert into sys_rule_fact_field (
  objid, parentid, name, title, datatype, 
  sortorder, handler, lookuphandler, lookupkey, lookupvalue, multivalued 
) 
select * 
from ( 
  select 
    concat(ff.parentid, '.psicid') as objid, ff.parentid, 
    'psicid' as name, 'PSIC' as title, 'string' as datatype, 
    5 as sortorder, 'lookup' as handler, 'psic:lookup' as lookuphandler, 
    'code' as lookupkey, 'description' as lookupvalue, 1 as multivalued 
  from sys_rule_fact f 
    inner join sys_rule_fact_field ff on ff.parentid = f.objid 
  where f.factclass = 'bpls.facts.LOB' 
    and ff.name = 'lobid' 
)t0 
where (
  select count(*) from sys_rule_fact_field 
  where parentid = t0.parentid and name = t0.name 
) = 0
;




-- ## 2022-09-19

CREATE TABLE `migrated_business` (
  `objid` varchar(50) NOT NULL,
  `applicationid` varchar(50) NOT NULL,
  constraint pk_migrated_business PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_applicationid` on migrated_business (`applicationid`)
; 
alter table migrated_business 
  add CONSTRAINT fk_migrated_business_objid 
  FOREIGN KEY (`objid`) REFERENCES `business` (`objid`)
;
alter table migrated_business 
  add CONSTRAINT fk_migrated_business_applicationid 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`)
;

insert into migrated_business (
  objid, applicationid 
) 
select 
  b.objid, a.objid as applicationid  
from business b 
  inner join business_application a on a.objid = b.currentapplicationid 
where b.state = 'PROCESSING' 
  and a.state = 'FOR-APPROVAL' 
  and a.txnmode = 'CAPTURE' 
  and (
    select count(*) from migrated_business 
    where objid = b.objid 
  ) = 0 
; 


drop table if exists vw_migrated_business
;
drop view if exists vw_migrated_business
;
create view vw_migrated_business as 
select 
  b.objid as objid, 
  b.state as state, 
  b.bin AS bin, 
  b.tradename AS tradename, 
  b.businessname AS businessname, 
  b.address_text AS address_text, 
  b.address_objid AS address_objid, 
  b.owner_name AS owner_name, 
  b.owner_address_text AS owner_address_text, 
  b.owner_address_objid AS owner_address_objid, 
  b.yearstarted AS yearstarted, 
  b.orgtype AS orgtype, 
  b.permittype AS permittype, 
  b.officetype AS officetype, 
  a.objid as applicationid, 
  a.state as appstate,
  a.appyear as appyear,
  a.apptype as apptype,
  a.appno as appno, 
  a.dtfiled as dtfiled,
  a.txndate as txndate, 
  a.txnmode as txnmode 
from migrated_business mb 
  inner join business b on b.objid = mb.objid 
  inner join business_application a on a.objid = mb.applicationid 
;




-- ## 2022-09-22

INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('ENTERPRISE.REPORT', 'ENTERPRISE REPORT', 'ENTERPRISE', NULL, NULL, 'REPORT');


insert into sys_usergroup_member (
  objid, usergroup_objid, user_objid, 
  user_username, user_firstname, user_lastname 
) 
select * 
from ( 
  select 
    concat('UGM-',MD5(CONCAT(u.objid, ug.objid))) objid, 
    ug.objid as usergroup_objid, u.objid as user_objid, 
    u.username as user_username, u.firstname as user_firstname, u.lastname as user_lastname 
  from ( 
    select distinct user_objid  
    from sys_usergroup_member 
    where usergroup_objid = 'ADMIN.SYSADMIN' 
  )t0, sys_user u, sys_usergroup ug  
  where u.objid = t0.user_objid 
    and ug.objid = 'ENTERPRISE.REPORT' 
)t1 
where (
  select count(*) from sys_usergroup_member 
  where objid = t1.objid 
) = 0 
;




-- ## 2022-09-28

alter table migrated_business add ( 
  dtapproved datetime NULL, 
  approvedby_objid varchar(50) NULL, 
  approvedby_name varchar(150) NULL 
)
; 
create index ix_dtapproved on migrated_business (dtapproved)
;
create index ix_approvedby_objid on migrated_business (approvedby_objid)
;
create index ix_approvedby_name on migrated_business (approvedby_name)
;





drop table if exists sys_user_role ;
drop table if exists vw_af_control_detail ;
drop table if exists vw_af_inventory_summary ;
drop table if exists vw_afunit ;
drop table if exists vw_cashreceipt_itemaccount ;
drop table if exists vw_cashreceipt_itemaccount_collectiontype ;
drop table if exists vw_cashreceiptpayment_noncash ;
drop table if exists vw_cashreceiptpayment_noncash_liquidated ;
drop table if exists vw_collectiongroup ;
drop table if exists vw_collectiontype ;
drop table if exists vw_collectiontype_account ;
drop table if exists vw_remittance_cashreceipt ;
drop table if exists vw_remittance_cashreceipt_af ;
drop table if exists vw_remittance_cashreceipt_afsummary ;
drop table if exists vw_remittance_cashreceiptitem ;
drop table if exists vw_remittance_cashreceiptpayment_noncash ;
drop table if exists vw_remittance_cashreceiptshare ;
drop table if exists vw_collectionvoucher_cashreceiptitem ;
drop table if exists vw_collectionvoucher_cashreceiptshare ;
drop table if exists vw_deposit_fund_transfer ;
drop table if exists vw_entityindividual ;
drop table if exists vw_entity_relation ;
drop table if exists vw_entityindividual_lookup ;
drop table if exists vw_entityrelation_lookup ;
drop table if exists vw_income_ledger ;
drop table if exists vw_afunit ;
drop table if exists vw_income_ledger ;
drop table if exists vw_account_item_mapping ;
drop table if exists vw_account_income_summary ;
drop table if exists vw_cashbook_cashreceipt ;
drop table if exists vw_cashbook_cashreceipt_share ;
drop table if exists vw_cashbook_cashreceiptvoid ;
drop table if exists vw_cashbook_remittance ;
drop table if exists vw_cashreceipt_itemaccount_collectiongroup ;
drop table if exists vw_account_mapping ;
drop table if exists vw_income_summary ;
drop table if exists sys_user_role ;
drop table if exists vw_account_incometarget ;
drop table if exists vw_business_application_lob_retire ;
drop table if exists vw_entity_mapping ;
drop table if exists vw_fund ;
drop table if exists vw_cashbook_cashreceipt ;
drop table if exists vw_cashbook_cashreceipt_share ;
drop table if exists vw_cashbook_cashreceipt_share_payable ;
drop table if exists vw_cashbook_remittance ;
drop table if exists vw_cashbook_remittance_share ;
drop table if exists vw_cashbook_remittance_share_payable ;
drop table if exists vw_cashbook_cashreceiptvoid ;
drop table if exists vw_cashbook_cashreceiptvoid_share ;
drop table if exists vw_cashbook_cashreceiptvoid_share_payable ;
drop table if exists vw_remittance_cashreceiptitem ;
drop table if exists vw_collectionvoucher_cashreceiptitem ;
drop table if exists vw_af_inventory_summary ;
drop table if exists vw_remittance_cashreceiptitem ;
drop table if exists vw_collectionvoucher_cashreceiptitem ;
drop table if exists vw_remittance_cashreceiptshare ;
drop table if exists vw_collectionvoucher_cashreceiptshare ;
drop table if exists vw_remittance_cashreceiptpayment_noncash ;
drop table if exists vw_online_business_application ;
drop table if exists vw_remittance_cashreceiptshare ;
drop table if exists vw_collectionvoucher_cashreceiptshare ;
drop table if exists vw_cashbook_cashreceipt ;
drop table if exists vw_cashbook_cashreceipt_share ;
drop table if exists vw_cashbook_cashreceipt_share_payable ;
drop table if exists vw_cashbook_cashreceiptvoid ;
drop table if exists vw_cashbook_cashreceiptvoid_share ;
drop table if exists vw_cashbook_cashreceiptvoid_share_payable ;
drop table if exists vw_cashbook_remittance ;
drop table if exists vw_cashbook_remittance_share ;
drop table if exists vw_cashbook_remittance_share_payable ;
drop table if exists vw_collectiontype ;

-- 
-- VIEWS
-- 
drop view if exists sys_user_role
;
create view sys_user_role AS 
select 
  u.objid AS objid, 
  u.lastname AS lastname, 
  u.firstname AS firstname, 
  u.middlename AS middlename, 
  u.username AS username, 
  concat(u.lastname,', ',u.firstname,(case when isnull(u.middlename) then '' else concat(' ',u.middlename) end)) AS name, 
  ug.role AS role, 
  ug.domain AS domain, 
  ugm.org_objid AS orgid, 
  u.txncode AS txncode, 
  u.jobtitle AS jobtitle, 
  ugm.objid AS usergroupmemberid, 
  ugm.usergroup_objid AS usergroup_objid  
from sys_usergroup_member ugm 
  join sys_usergroup ug on ug.objid = ugm.usergroup_objid 
  join sys_user u on u.objid = ugm.user_objid 
; 

drop view if exists vw_af_control_detail 
; 
create view vw_af_control_detail AS 
select 
  afd.objid AS objid, 
  afd.state AS state, 
  afd.controlid AS controlid, 
  afd.indexno AS indexno, 
  afd.refid AS refid, 
  afd.aftxnitemid AS aftxnitemid, 
  afd.refno AS refno, 
  afd.reftype AS reftype, 
  afd.refdate AS refdate, 
  afd.txndate AS txndate, 
  afd.txntype AS txntype, 
  afd.receivedstartseries AS receivedstartseries, 
  afd.receivedendseries AS receivedendseries, 
  afd.beginstartseries AS beginstartseries, 
  afd.beginendseries AS beginendseries, 
  afd.issuedstartseries AS issuedstartseries, 
  afd.issuedendseries AS issuedendseries, 
  afd.endingstartseries AS endingstartseries, 
  afd.endingendseries AS endingendseries, 
  afd.qtyreceived AS qtyreceived, 
  afd.qtybegin AS qtybegin, 
  afd.qtyissued AS qtyissued, 
  afd.qtyending AS qtyending, 
  afd.qtycancelled AS qtycancelled, 
  afd.remarks AS remarks, 
  afd.issuedto_objid AS issuedto_objid, 
  afd.issuedto_name AS issuedto_name, 
  afd.respcenter_objid AS respcenter_objid, 
  afd.respcenter_name AS respcenter_name, 
  afd.prevdetailid AS prevdetailid, 
  afd.aftxnid AS aftxnid, 
  afc.afid AS afid, 
  afc.unit AS unit, 
  af.formtype AS formtype, 
  af.denomination AS denomination, 
  af.serieslength AS serieslength, 
  afu.qty AS qty, 
  afu.saleprice AS saleprice, 
  afc.startseries AS startseries, 
  afc.endseries AS endseries, 
  afc.currentseries AS currentseries, 
  afc.stubno AS stubno, 
  afc.prefix AS prefix, 
  afc.suffix AS suffix, 
  afc.cost AS cost, 
  afc.batchno AS batchno, 
  afc.state AS controlstate, 
  afd.qtyending AS qtybalance  
from af_control_detail afd 
  join af_control afc on afc.objid = afd.controlid 
  join af on af.objid = afc.afid 
  join afunit afu on (afu.itemid = af.objid and afu.unit = afc.unit) 
;

drop view if exists vw_af_inventory_summary
;
create view vw_af_inventory_summary AS 
select 
  af.objid AS objid, 
  af.title AS title, 
  u.unit AS unit, 
  (select count(0) from af_control where afid = af.objid and state = 'OPEN') AS countopen,
  (select count(0) from af_control where afid = af.objid and state = 'ISSUED') AS countissued,
  (select count(0) from af_control where afid = af.objid and state = 'CLOSED') AS countclosed,
  (select count(0) from af_control where afid = af.objid and state = 'SOLD') AS countsold,
  (select count(0) from af_control where afid = af.objid and state = 'PROCESSING') AS countprocessing 
from af 
  join afunit u on af.objid = u.itemid 
;

drop view if exists vw_afunit
;
create view vw_afunit AS 
select 
  u.objid AS objid, 
  af.title AS title, 
  af.usetype AS usetype, 
  af.serieslength AS serieslength, 
  af.system AS system, 
  af.denomination AS denomination, 
  af.formtype AS formtype, 
  u.itemid AS itemid, 
  u.unit AS unit, 
  u.qty AS qty, 
  u.saleprice AS saleprice, 
  u.interval AS `interval`, 
  u.cashreceiptprintout AS cashreceiptprintout, 
  u.cashreceiptdetailprintout AS cashreceiptdetailprintout  
from afunit u 
  join af on af.objid = u.itemid 
; 


drop view if exists vw_cashreceipt_itemaccount
;
create view vw_cashreceipt_itemaccount AS 
select 
  objid AS objid, 
  state AS state, 
  code AS code, 
  title AS title, 
  description AS description, 
  type AS type, 
  fund_objid AS fund_objid, 
  fund_code AS fund_code, 
  fund_title AS fund_title, 
  defaultvalue AS defaultvalue, 
  valuetype AS valuetype, 
  sortorder AS sortorder, 
  org_objid AS orgid, 
  hidefromlookup AS hidefromlookup 
from itemaccount 
where state = 'ACTIVE' 
  and type in ('REVENUE','NONREVENUE','PAYABLE') 
  and ifnull(generic, 0) = 0 
; 


drop view if exists vw_cashreceipt_itemaccount_collectiontype
;
create view vw_cashreceipt_itemaccount_collectiontype AS 
select 
  ia.objid AS objid, 
  ia.state AS state, 
  ia.code AS code, 
  ia.title AS title, 
  ia.description AS description, 
  ia.type AS type, 
  ia.fund_objid AS fund_objid, 
  ia.fund_code AS fund_code, 
  ia.fund_title AS fund_title, 
  ca.defaultvalue AS defaultvalue, 
  (case when ca.valuetype is null then 'ANY' else ca.valuetype end) AS valuetype, 
  (case when ca.sortorder is null then 0 else ca.sortorder end) AS sortorder, 
  NULL AS orgid, 
  ca.collectiontypeid AS collectiontypeid, 
  0 AS hasorg, 
  ia.hidefromlookup AS hidefromlookup   
from collectiontype ct 
  inner join collectiontype_account ca on ca.collectiontypeid = ct.objid 
  inner join itemaccount ia on ia.objid = ca.account_objid 
  left join collectiontype_org o on o.collectiontypeid = ca.objid 
where o.objid is null 
  and ia.state = 'ACTIVE' 
  and ia.type in ('REVENUE','NONREVENUE','PAYABLE') 
union all 
select 
  ia.objid AS objid, 
  ia.state AS state, 
  ia.code AS code, 
  ia.title AS title, 
  ia.description AS description, 
  ia.type AS type, 
  ia.fund_objid AS fund_objid, 
  ia.fund_code AS fund_code, 
  ia.fund_title AS fund_title, 
  ca.defaultvalue AS defaultvalue, 
  (case when ca.valuetype is null then 'ANY' else ca.valuetype end) AS valuetype, 
  (case when ca.sortorder is null then 0 else ca.sortorder end) AS sortorder, 
  o.org_objid AS orgid, 
  ca.collectiontypeid AS collectiontypeid, 
  1 AS hasorg, 
  ia.hidefromlookup AS hidefromlookup  
from collectiontype ct 
  inner join collectiontype_org o on o.collectiontypeid = ct.objid 
  inner join collectiontype_account ca on ca.collectiontypeid = ct.objid 
  inner join itemaccount ia on ia.objid = ca.account_objid 
where ia.state = 'ACTIVE' 
  and ia.type in ('REVENUE','NONREVENUE','PAYABLE') 
;


drop view if exists vw_cashreceiptpayment_noncash
;
create view vw_cashreceiptpayment_noncash AS 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  nc.reftype AS reftype, 
  nc.amount AS amount, 
  nc.particulars AS particulars, 
  nc.account_objid AS account_objid, 
  nc.account_code AS account_code, 
  nc.account_name AS account_name, 
  nc.account_fund_objid AS account_fund_objid, 
  nc.account_fund_name AS account_fund_name, 
  nc.account_bank AS account_bank, 
  nc.fund_objid AS fund_objid, 
  nc.refid AS refid, 
  nc.checkid AS checkid, 
  nc.voidamount AS voidamount, 
  v.objid AS void_objid, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  c.receiptno AS receipt_receiptno, 
  c.receiptdate AS receipt_receiptdate, 
  c.amount AS receipt_amount, 
  c.collector_objid AS receipt_collector_objid, 
  c.collector_name AS receipt_collector_name, 
  c.remittanceid AS remittanceid, 
  rem.objid AS remittance_objid, 
  rem.controlno AS remittance_controlno, 
  rem.controldate AS remittance_controldate  
from cashreceiptpayment_noncash nc 
  inner join cashreceipt c on c.objid = nc.receiptid 
  left join cashreceipt_void v on v.receiptid = c.objid 
  left join remittance rem on rem.objid = c.remittanceid 
;


drop view if exists vw_cashreceiptpayment_noncash_liquidated
;
create view vw_cashreceiptpayment_noncash_liquidated AS 
select 
nc.objid AS objid, 
nc.receiptid AS receiptid, 
nc.refno AS refno, 
nc.refdate AS refdate, 
nc.reftype AS reftype, 
nc.amount AS amount, 
nc.particulars AS particulars, 
nc.account_objid AS account_objid, 
nc.account_code AS account_code, 
nc.account_name AS account_name, 
nc.account_fund_objid AS account_fund_objid, 
nc.account_fund_name AS account_fund_name, 
nc.account_bank AS account_bank, 
nc.fund_objid AS fund_objid, 
nc.refid AS refid, 
nc.checkid AS checkid, 
nc.voidamount AS voidamount, 
v.objid AS void_objid, 
(case when v.objid is null then 0 else 1 end) AS voided, 
c.receiptno AS receipt_receiptno, 
c.receiptdate AS receipt_receiptdate, 
c.amount AS receipt_amount, 
c.collector_objid AS receipt_collector_objid, 
c.collector_name AS receipt_collector_name, 
c.remittanceid AS remittanceid, 
r.objid AS remittance_objid, 
r.controlno AS remittance_controlno, 
r.controldate AS remittance_controldate, 
r.collectionvoucherid AS collectionvoucherid, 
cv.objid AS collectionvoucher_objid, 
cv.controlno AS collectionvoucher_controlno, 
cv.controldate AS collectionvoucher_controldate, 
cv.depositvoucherid AS depositvoucherid  
from collectionvoucher cv 
  inner join remittance r on r.collectionvoucherid = cv.objid 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_collectiongroup
;
create view vw_collectiongroup AS 
select 
  cg.objid AS objid, 
  cg.name AS name, 
  cg.sharing AS sharing, 
  NULL AS orgid  
from collectiongroup cg 
  left join collectiongroup_org co on co.collectiongroupid = cg.objid 
where cg.state = 'ACTIVE' 
  and co.objid is null 
union 
select 
  cg.objid AS objid, 
  cg.name AS name, 
  cg.sharing AS sharing, 
  co.org_objid AS orgid  
from collectiongroup cg 
  inner join collectiongroup_org co on co.collectiongroupid = cg.objid 
where cg.state = 'ACTIVE' 
;


drop view if exists vw_collectiontype
;
create view vw_collectiontype AS 
select 
  c.objid AS objid, 
  c.state AS state, 
  c.name AS name, 
  c.title AS title, 
  c.formno AS formno, 
  c.handler AS handler, 
  c.allowbatch AS allowbatch, 
  c.barcodekey AS barcodekey, 
  c.allowonline AS allowonline, 
  c.allowoffline AS allowoffline, 
  c.sortorder AS sortorder, 
  o.org_objid AS orgid, 
  c.fund_objid AS fund_objid, 
  c.fund_title AS fund_title, 
  c.category AS category, 
  c.queuesection AS queuesection, 
  c.system AS system, 
  af.formtype AS af_formtype, 
  af.serieslength AS af_serieslength, 
  af.denomination AS af_denomination, 
  af.baseunit AS af_baseunit, 
  c.allowpaymentorder AS allowpaymentorder, 
  c.allowkiosk AS allowkiosk, 
  c.allowcreditmemo AS allowcreditmemo  
from collectiontype_org o 
  inner join collectiontype c on c.objid = o.collectiontypeid 
  inner join af on af.objid = c.formno 
where c.state = 'ACTIVE' 
union 
select 
  c.objid AS objid, 
  c.state AS state, 
  c.name AS name, 
  c.title AS title, 
  c.formno AS formno, 
  c.handler AS handler, 
  c.allowbatch AS allowbatch, 
  c.barcodekey AS barcodekey, 
  c.allowonline AS allowonline, 
  c.allowoffline AS allowoffline, 
  c.sortorder AS sortorder, 
  NULL AS orgid, 
  c.fund_objid AS fund_objid, 
  c.fund_title AS fund_title, 
  c.category AS category, 
  c.queuesection AS queuesection, 
  c.system AS system, 
  af.formtype AS af_formtype, 
  af.serieslength AS af_serieslength, 
  af.denomination AS af_denomination, 
  af.baseunit AS af_baseunit, 
  c.allowpaymentorder AS allowpaymentorder, 
  c.allowkiosk AS allowkiosk, 
  c.allowcreditmemo AS allowcreditmemo  
from collectiontype c 
  inner join af on af.objid = c.formno 
  left join collectiontype_org o on c.objid = o.collectiontypeid 
where c.state = 'ACTIVE' 
  and o.objid is null 
;


drop view if exists vw_collectiontype_account
;
create view vw_collectiontype_account AS 
select 
  ia.objid AS objid, 
  ia.code AS code, 
  ia.title AS title, 
  ia.fund_objid AS fund_objid, 
  fund.code AS fund_code, 
  fund.title AS fund_title, 
  cta.collectiontypeid AS collectiontypeid, 
  cta.tag AS tag, 
  cta.valuetype AS valuetype, 
  cta.defaultvalue AS defaultvalue  
from collectiontype_account cta 
  inner join itemaccount ia on ia.objid = cta.account_objid 
  inner join fund on fund.objid = ia.fund_objid 
;


drop view if exists vw_remittance_cashreceipt
;
create view vw_remittance_cashreceipt AS 
select 
    r.objid AS remittance_objid, 
    r.controldate AS remittance_controldate, 
    r.controlno AS remittance_controlno, 
    c.remittanceid AS remittanceid, 
    r.collectionvoucherid AS collectionvoucherid, 
    c.controlid AS controlid, 
    af.formtype AS formtype, 
    (case when (af.formtype = 'serial') then 0 else 1 end) AS formtypeindexno, 
    c.formno AS formno, 
    c.stub AS stubno, 
    c.series AS series, 
    c.receiptno AS receiptno, 
    c.receiptdate AS receiptdate, 
    c.amount AS amount, 
    c.totalnoncash AS totalnoncash,( 
        c.amount - c.totalnoncash) AS totalcash, 
    (case when v.objid is null then 0 else 1 end) AS voided, 
    (case when v.objid is null then 0 else c.amount end) AS voidamount, 
    c.paidby AS paidby, 
    c.paidbyaddress AS paidbyaddress, 
    c.payer_objid AS payer_objid, 
    c.payer_name AS payer_name, 
    c.collector_objid AS collector_objid, 
    c.collector_name AS collector_name, 
    c.collector_title AS collector_title, 
    c.objid AS receiptid, 
    c.collectiontype_objid AS collectiontype_objid, 
    c.org_objid AS org_objid 
from remittance r 
    inner join cashreceipt c on c.remittanceid = r.objid 
    inner join af on af.objid = c.formno 
    left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_remittance_cashreceipt_af
;
create view vw_remittance_cashreceipt_af AS 
select 
    cr.remittanceid AS remittanceid, 
    cr.collector_objid AS collector_objid, 
    cr.controlid AS controlid, 
    min(cr.receiptno) AS fromreceiptno, 
    max(cr.receiptno) AS toreceiptno, 
    min(cr.series) AS fromseries, 
    max(cr.series) AS toseries, 
    count(cr.objid) AS qty, 
    sum(cr.amount) AS amount, 
    0 AS qtyvoided, 
    0.0 AS voidamt, 
    0 AS qtycancelled, 
    0.0 AS cancelledamt, 
    af.formtype AS formtype, 
    af.serieslength AS serieslength, 
    af.denomination AS denomination, 
    cr.formno AS formno, 
    afc.stubno AS stubno, 
    afc.startseries AS startseries, 
    afc.endseries AS endseries, 
    afc.prefix AS prefix, 
    afc.suffix AS suffix  
from cashreceipt cr 
    inner join remittance rem on rem.objid = cr.remittanceid 
    inner join af_control afc on cr.controlid = afc.objid 
    inner join af on afc.afid = af.objid 
group by 
    cr.remittanceid,cr.collector_objid,cr.controlid,af.formtype,
    af.serieslength,af.denomination,cr.formno,afc.stubno,
    afc.startseries,afc.endseries,afc.prefix,afc.suffix 
union all 
select 
    cr.remittanceid AS remittanceid, 
    cr.collector_objid AS collector_objid, 
    cr.controlid AS controlid, 
    NULL AS fromreceiptno, 
    NULL AS toreceiptno, 
    NULL AS fromseries, 
    NULL AS toseries, 
    0 AS qty, 
    0.0 AS amount, 
    count(cr.objid) AS qtyvoided, 
    sum(cr.amount) AS voidamt, 
    0 AS qtycancelled, 
    0.0 AS cancelledamt, 
    af.formtype AS formtype, 
    af.serieslength AS serieslength, 
    af.denomination AS denomination, 
    cr.formno AS formno, 
    afc.stubno AS stubno, 
    afc.startseries AS startseries, 
    afc.endseries AS endseries, 
    afc.prefix AS prefix, 
    afc.suffix AS suffix  
from cashreceipt cr 
    inner join cashreceipt_void cv on cv.receiptid = cr.objid 
    inner join remittance rem on rem.objid = cr.remittanceid 
    inner join af_control afc on cr.controlid = afc.objid 
    inner join af on afc.afid = af.objid 
group by 
    cr.remittanceid,cr.collector_objid,cr.controlid,af.formtype,
    af.serieslength,af.denomination,cr.formno,afc.stubno,
    afc.startseries,afc.endseries,afc.prefix,afc.suffix 
union all 
select 
    cr.remittanceid AS remittanceid, 
    cr.collector_objid AS collector_objid, 
    cr.controlid AS controlid, 
    NULL AS fromreceiptno, 
    NULL AS toreceiptno, 
    NULL AS fromseries, 
    NULL AS toseries, 
    0 AS qty, 
    0.0 AS amount, 
    0 AS qtyvoided, 
    0.0 AS voidamt, 
    count(cr.objid) AS qtycancelled, 
    sum(cr.amount) AS cancelledamt, 
    af.formtype AS formtype, 
    af.serieslength AS serieslength, 
    af.denomination AS denomination, 
    cr.formno AS formno, 
    afc.stubno AS stubno, 
    afc.startseries AS startseries, 
    afc.endseries AS endseries, 
    afc.prefix AS prefix, 
    afc.suffix AS suffix  
from cashreceipt cr 
    inner join remittance rem on rem.objid = cr.remittanceid 
    inner join af_control afc on cr.controlid = afc.objid 
    inner join af on afc.afid = af.objid 
where cr.state = 'CANCELLED' 
group by 
    cr.remittanceid,cr.collector_objid,cr.controlid,af.formtype,
    af.serieslength,af.denomination,cr.formno,afc.stubno,
    afc.startseries,afc.endseries,afc.prefix,afc.suffix
;


drop view if exists vw_remittance_cashreceipt_afsummary
;
create view vw_remittance_cashreceipt_afsummary AS 
select 
    concat(v.remittanceid,'|',v.collector_objid,'|',v.controlid) AS objid, 
    v.remittanceid AS remittanceid, 
    v.collector_objid AS collector_objid, 
    v.controlid AS controlid, 
    min(v.fromreceiptno) AS fromreceiptno, 
    max(v.toreceiptno) AS toreceiptno, 
    min(v.fromseries) AS fromseries, 
    max(v.toseries) AS toseries, 
    sum(v.qty) AS qty, 
    sum(v.amount) AS amount, 
    sum(v.qtyvoided) AS qtyvoided, 
    sum(v.voidamt) AS voidamt, 
    sum(v.qtycancelled) AS qtycancelled, 
    sum(v.cancelledamt) AS cancelledamt, 
    v.formtype AS formtype, 
    v.serieslength AS serieslength, 
    v.denomination AS denomination, 
    v.formno AS formno, 
    v.stubno AS stubno, 
    v.startseries AS startseries, 
    v.endseries AS endseries, 
    v.prefix AS prefix, 
    v.suffix AS suffix  
from vw_remittance_cashreceipt_af v 
group by 
    v.remittanceid,v.collector_objid,v.controlid,v.formtype,
    v.serieslength,v.denomination,v.formno,v.stubno,
    v.startseries,v.endseries,v.prefix,v.suffix
;


drop view if exists vw_remittance_cashreceiptitem
;
create view vw_remittance_cashreceiptitem AS 
select 
    c.remittanceid AS remittanceid, 
    r.controldate AS remittance_controldate, 
    r.controlno AS remittance_controlno, 
    r.collectionvoucherid AS collectionvoucherid, 
    c.collectiontype_objid AS collectiontype_objid, 
    c.collectiontype_name AS collectiontype_name, 
    c.org_objid AS org_objid, 
    c.org_name AS org_name, 
    c.formtype AS formtype, 
    c.formno AS formno, 
    (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex, 
    cri.receiptid AS receiptid, 
    c.receiptdate AS receiptdate, 
    c.receiptno AS receiptno, 
    c.paidby AS paidby, 
    c.paidbyaddress AS paidbyaddress, 
    c.collector_objid AS collectorid, 
    c.collector_name AS collectorname, 
    c.collector_title AS collectortitle, 
    cri.item_fund_objid AS fundid, 
    cri.item_objid AS acctid, 
    cri.item_code AS acctcode, 
    cri.item_title AS acctname, 
    cri.remarks AS remarks, 
    (case when isnull(v.objid) then cri.amount else 0.0 end) AS amount, 
    (case when isnull(v.objid) then 0 else 1 end) AS voided, 
    (case when isnull(v.objid) then 0.0 else cri.amount end) AS voidamount  
from remittance r 
    inner join cashreceipt c on c.remittanceid = r.objid 
    inner join cashreceiptitem cri on cri.receiptid = c.objid 
    left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_remittance_cashreceiptpayment_noncash
; 
create view vw_remittance_cashreceiptpayment_noncash AS 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  nc.reftype AS reftype, 
  nc.particulars AS particulars, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  cp.bankid AS bankid, 
  cp.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'CHECK') 
  inner join checkpayment cp on cp.objid = nc.refid 
  left join cashreceipt_void v on v.receiptid = c.objid 
union all 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  'EFT' AS reftype, 
  nc.particulars AS particulars, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  ba.bank_objid AS bankid, 
  ba.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'EFT') 
  inner join eftpayment eft on eft.objid = nc.refid 
  inner join bankaccount ba on ba.objid = eft.bankacctid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_remittance_cashreceiptshare
;
create view vw_remittance_cashreceiptshare AS 
select 
    c.remittanceid AS remittanceid, 
    r.controldate AS remittance_controldate, 
    r.controlno AS remittance_controlno, 
    r.collectionvoucherid AS collectionvoucherid, 
    c.formno AS formno, 
    c.formtype AS formtype, 
    cs.receiptid AS receiptid, 
    c.receiptdate AS receiptdate, 
    c.receiptno AS receiptno, 
    c.paidby AS paidby, 
    c.paidbyaddress AS paidbyaddress, 
    c.org_objid AS org_objid, 
    c.org_name AS org_name, 
    c.collectiontype_objid AS collectiontype_objid, 
    c.collectiontype_name AS collectiontype_name, 
    c.collector_objid AS collectorid, 
    c.collector_name AS collectorname, 
    c.collector_title AS collectortitle, 
    cs.refitem_objid AS refacctid, 
    ia.fund_objid AS fundid, 
    ia.objid AS acctid, 
    ia.code AS acctcode, 
    ia.title AS acctname, 
    (case when v.objid is null then cs.amount else 0.0 end) AS amount, 
    (case when v.objid is null then 0 else 1 end) AS voided, 
    (case when v.objid is null then 0.0 else cs.amount end) AS voidamount  
from remittance r 
    inner join cashreceipt c on c.remittanceid = r.objid 
    inner join cashreceipt_share cs on cs.receiptid = c.objid 
    inner join itemaccount ia on ia.objid = cs.payableitem_objid 
    left join cashreceipt_void v on v.receiptid = c.objid 
; 

drop view if exists vw_collectionvoucher_cashreceiptitem
;
create view vw_collectionvoucher_cashreceiptitem AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.remittanceid AS remittanceid, 
  v.remittance_controldate AS remittance_controldate, 
  v.remittance_controlno AS remittance_controlno, 
  v.collectionvoucherid AS collectionvoucherid, 
  v.collectiontype_objid AS collectiontype_objid, 
  v.collectiontype_name AS collectiontype_name, 
  v.org_objid AS org_objid, 
  v.org_name AS org_name, 
  v.formtype AS formtype, 
  v.formno AS formno, 
  v.formtypeindex AS formtypeindex, 
  v.receiptid AS receiptid, 
  v.receiptdate AS receiptdate, 
  v.receiptno AS receiptno, 
  v.paidby AS paidby, 
  v.paidbyaddress AS paidbyaddress, 
  v.collectorid AS collectorid, 
  v.collectorname AS collectorname, 
  v.collectortitle AS collectortitle, 
  v.fundid AS fundid, 
  v.acctid AS acctid, 
  v.acctcode AS acctcode, 
  v.acctname AS acctname, 
  v.amount AS amount, 
  v.voided AS voided, 
  v.voidamount AS voidamount  
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptitem v on v.collectionvoucherid = cv.objid 
;


drop view if exists vw_collectionvoucher_cashreceiptshare
;
create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.remittanceid AS remittanceid, 
  v.remittance_controldate AS remittance_controldate, 
  v.remittance_controlno AS remittance_controlno, 
  v.collectionvoucherid AS collectionvoucherid, 
  v.formno AS formno, 
  v.formtype AS formtype, 
  v.receiptid AS receiptid, 
  v.receiptdate AS receiptdate, 
  v.receiptno AS receiptno, 
  v.paidby AS paidby, 
  v.paidbyaddress AS paidbyaddress, 
  v.org_objid AS org_objid, 
  v.org_name AS org_name, 
  v.collectiontype_objid AS collectiontype_objid, 
  v.collectiontype_name AS collectiontype_name, 
  v.collectorid AS collectorid, 
  v.collectorname AS collectorname, 
  v.collectortitle AS collectortitle, 
  v.refacctid AS refacctid, 
  v.fundid AS fundid, 
  v.acctid AS acctid, 
  v.acctcode AS acctcode, 
  v.acctname AS acctname, 
  v.amount AS amount, 
  v.voided AS voided, 
  v.voidamount AS voidamount  
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
; 


drop view if exists vw_deposit_fund_transfer
;
create view vw_deposit_fund_transfer AS 
select 
  dft.objid AS objid, 
  dft.amount AS amount, 
  dft.todepositvoucherfundid AS todepositvoucherfundid, 
  tof.objid AS todepositvoucherfund_fund_objid, 
  tof.code AS todepositvoucherfund_fund_code, 
  tof.title AS todepositvoucherfund_fund_title, 
  dft.fromdepositvoucherfundid AS fromdepositvoucherfundid, 
  fromf.objid AS fromdepositvoucherfund_fund_objid, 
  fromf.code AS fromdepositvoucherfund_fund_code, 
  fromf.title AS fromdepositvoucherfund_fund_title  
from deposit_fund_transfer dft 
  inner join depositvoucher_fund todv on dft.todepositvoucherfundid = todv.objid 
  inner join fund tof on todv.fundid = tof.objid 
  inner join depositvoucher_fund fromdv on dft.fromdepositvoucherfundid = fromdv.objid 
  inner join fund fromf on fromdv.fundid = fromf.objid 
; 


drop view if exists vw_entityindividual
;
create view vw_entityindividual AS 
select 
  ei.objid AS objid, 
  ei.lastname AS lastname, 
  ei.firstname AS firstname, 
  ei.middlename AS middlename, 
  ei.birthdate AS birthdate, 
  ei.birthplace AS birthplace, 
  ei.citizenship AS citizenship, 
  ei.gender AS gender, 
  ei.civilstatus AS civilstatus, 
  ei.profession AS profession, 
  ei.tin AS tin, 
  ei.sss AS sss, 
  ei.height AS height, 
  ei.weight AS weight, 
  ei.acr AS acr, 
  ei.religion AS religion, 
  ei.photo AS photo, 
  ei.thumbnail AS thumbnail, 
  ei.profileid AS profileid, 
  e.entityno AS entityno, 
  e.type AS type, 
  e.name AS name, 
  e.entityname AS entityname, 
  e.mobileno AS mobileno, 
  e.phoneno AS phoneno, 
  e.address_objid AS address_objid, 
  e.address_text AS address_text  
from entityindividual ei 
  inner join entity e on e.objid = ei.objid 
; 


drop view if exists vw_entity_relation
;
create view vw_entity_relation AS 
select 
  er.objid AS objid, 
  er.entity_objid AS ownerid, 
  ei.objid AS entityid, 
  ei.entityno AS entityno, 
  ei.name AS name, 
  ei.firstname AS firstname, 
  ei.lastname AS lastname, 
  ei.middlename AS middlename, 
  ei.birthdate AS birthdate, 
  ei.gender AS gender, 
  er.relation_objid AS relationship  
from entity_relation er 
  inner join vw_entityindividual ei on er.relateto_objid = ei.objid 
union all 
select 
  er.objid AS objid, 
  er.relateto_objid AS ownerid, 
  ei.objid AS entityid, 
  ei.entityno AS entityno, 
  ei.name AS name, 
  ei.firstname AS firstname, 
  ei.lastname AS lastname, 
  ei.middlename AS middlename, 
  ei.birthdate AS birthdate, 
  ei.gender AS gender, 
  (case 
    when (ei.gender = 'M') then et.inverse_male 
    when (ei.gender = 'F') then et.inverse_female 
    else et.inverse_any 
  end) AS relationship  
from entity_relation er 
  inner join vw_entityindividual ei on er.entity_objid = ei.objid 
  inner join entity_relation_type et on er.relation_objid = et.objid 
;


drop view if exists vw_entityindividual_lookup
;
create view vw_entityindividual_lookup AS 
select 
  e.objid AS objid, 
  e.entityno AS entityno, 
  e.name AS name, 
  e.address_text AS addresstext, 
  e.type AS type, 
  ei.lastname AS lastname, 
  ei.firstname AS firstname, 
  ei.middlename AS middlename, 
  ei.gender AS gender, 
  ei.birthdate AS birthdate, 
  e.mobileno AS mobileno, 
  e.phoneno AS phoneno  
from entity e 
  inner join entityindividual ei on ei.objid = e.objid 
;


drop view if exists vw_entityrelation_lookup
;
create view vw_entityrelation_lookup AS 
select 
  er.objid AS objid, 
  er.entity_objid AS entity_objid, 
  er.relateto_objid AS relateto_objid, 
  er.relation_objid AS relation_objid, 
  e.entityno AS entityno, 
  e.name AS name, 
  e.address_text AS addresstext, 
  e.type AS type, 
  ei.lastname AS lastname, 
  ei.firstname AS firstname, 
  ei.middlename AS middlename, 
  ei.gender AS gender, 
  ei.birthdate AS birthdate, 
  e.mobileno AS mobileno, 
  e.phoneno AS phoneno  
from entity_relation er 
  inner join entityindividual ei on ei.objid = er.relateto_objid 
  inner join entity e on e.objid = ei.objid 
;


drop view if exists vw_income_ledger
;
create view vw_income_ledger AS 
select 
  month(jev.jevdate) AS month, 
  year(jev.jevdate) AS year, 
  jev.fundid AS fundid, 
  il.itemacctid AS itemacctid, 
  il.cr AS amount  
from income_ledger il 
  inner join jev on jev.objid = il.jevid 
union 
select 
  month(jev.jevdate) AS month, 
  year(jev.jevdate) AS year, 
  jev.fundid AS fundid, 
  pl.refitemacctid AS refitemacctid, 
  (pl.cr - pl.dr) AS amount  
from payable_ledger pl 
  inner join jev on jev.objid = pl.jevid 
;


drop view if exists vw_afunit
;
create view vw_afunit AS 
select 
  u.objid AS objid, 
  af.title AS title, 
  af.usetype AS usetype, 
  af.serieslength AS serieslength, 
  af.system AS system, 
  af.denomination AS denomination, 
  af.formtype AS formtype, 
  u.itemid AS itemid, 
  u.unit AS unit, 
  u.qty AS qty, 
  u.saleprice AS saleprice, 
  u.`interval` AS `interval`, 
  u.cashreceiptprintout AS cashreceiptprintout, 
  u.cashreceiptdetailprintout AS cashreceiptdetailprintout  
from afunit u 
  inner join af on af.objid = u.itemid
;


DROP VIEW IF EXISTS vw_income_ledger
;
CREATE VIEW vw_income_ledger AS
SELECT 
  YEAR(jev.jevdate) AS year, MONTH(jev.jevdate) AS month, 
  jev.fundid, l.itemacctid, cr AS amount, l.jevid, l.objid  
FROM income_ledger l 
  INNER JOIN jev ON jev.objid = l.jevid
UNION ALL 
SELECT 
  YEAR(jev.jevdate) AS year, MONTH(jev.jevdate) AS month, 
  jev.fundid, l.refitemacctid as itemacctid, 
  (l.cr - l.dr) AS amount, l.jevid, l.objid  
FROM payable_ledger l  
  INNER JOIN jev ON jev.objid = l.jevid
;

drop view if exists vw_account_item_mapping 
;
create view vw_account_item_mapping as 
select 
  a.*, l.amount, l.fundid, l.year, l.month, 
  aim.itemid, ia.code as itemcode, ia.title as itemtitle 
from account_item_mapping aim 
  inner join account a on a.objid = aim.acctid 
  inner join itemaccount ia on ia.objid = aim.itemid 
  inner join vw_income_ledger l on l.itemacctid = aim.itemid 
;


drop view if exists vw_account_income_summary
; 
create view vw_account_income_summary as 
select a.*, 
  inc.amount, inc.acctid, inc.fundid, inc.collectorid, 
  inc.refdate, inc.remittancedate, inc.liquidationdate, 
  ia.type as accttype 
from account_item_mapping aim 
  inner join account a on a.objid = aim.acctid 
  inner join itemaccount ia on ia.objid = aim.itemid 
  inner join income_summary inc on inc.acctid = ia.objid 
;



drop view if exists vw_cashbook_cashreceipt
; 
CREATE VIEW vw_cashbook_cashreceipt AS select  
  c.objid AS objid, 
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,'cashreceipt' AS reftype,
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  ci.amount AS dr,0.0 AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid 
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid
  inner join cashreceiptitem ci on ci.receiptid = c.objid
;


drop view if exists vw_cashbook_cashreceipt_share
; 
CREATE VIEW vw_cashbook_cashreceipt_share AS 
select  
  c.objid AS objid, 
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,'cashreceipt' AS reftype,
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount AS dr,0.0 AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.refitem_objid AS refitemid 
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
;


drop view if exists vw_cashbook_cashreceiptvoid
; 
CREATE VIEW vw_cashbook_cashreceiptvoid AS 
select  
  v.objid AS objid, 
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  -ci.amount AS dr,
  (
  case 
    when r.liquidatingofficer_objid is null then 0.0 
    when v.txndate >= r.dtposted and cast(v.txndate as date) >= cast(r.controldate as date) then -ci.amount  
    else 0.0 
  end
  ) AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_remittance
;
CREATE VIEW vw_cashbook_remittance AS 
select  
  rem.objid AS objid, 
  rem.dtposted AS txndate, 
  rem.controldate AS refdate, 
  rem.objid AS refid, 
  rem.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  remf.fund_objid AS fundid, 
  rem.collector_objid AS collectorid, 
  0.0 AS dr, 
  remf.amount AS cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  rem.dtposted AS sortdate 
from remittance rem 
  inner join remittance_fund remf on remf.remittanceid = rem.objid 
;

drop view if exists vw_cashreceipt_itemaccount_collectiongroup
; 
CREATE VIEW vw_cashreceipt_itemaccount_collectiongroup AS 
select  
  ia.objid AS objid, 
  ia.state AS state, 
  ia.code AS code, 
  ia.title AS title, 
  ia.description AS description, 
  ia.type AS type, 
  ia.fund_objid AS fund_objid, 
  ia.fund_code AS fund_code, 
  ia.fund_title AS fund_title,
  (case when ca.defaultvalue = 0 then ia.defaultvalue else ca.defaultvalue end) AS defaultvalue,
  (case when ca.defaultvalue = 0 then ia.valuetype else ca.valuetype end) AS valuetype, 
  ca.sortorder AS sortorder, 
  ia.org_objid AS orgid, 
  ca.collectiongroupid AS collectiongroupid, 
  ia.generic AS generic 
from collectiongroup_account ca 
  inner join itemaccount ia on ia.objid = ca.account_objid 
;


drop view if exists vw_account_mapping
;
create view vw_account_mapping as 
select a.*, m.itemid, m.acctid   
from account_item_mapping m 
  inner join account a on a.objid = m.acctid 
; 



drop view if exists vw_income_summary
; 
create view vw_income_summary as 
select 
  inc.*, fund.groupid as fundgroupid, 
  ia.objid as itemid, ia.code as itemcode, ia.title as itemtitle, ia.type as itemtype  
from income_summary inc 
  inner join fund on fund.objid = inc.fundid 
  inner join itemaccount ia on ia.objid = inc.acctid 
;


drop table if exists sys_user_role
;
drop view if exists sys_user_role
; 
CREATE VIEW sys_user_role AS 
select  
  u.objid AS objid, 
  u.lastname AS lastname, 
  u.firstname AS firstname, 
  u.middlename AS middlename, 
  u.username AS username,
  concat(u.lastname,', ',u.firstname,(case when u.middlename is null then '' else concat(' ',u.middlename) end)) AS name, 
  ug.role AS role, 
  ug.domain AS domain, 
  ugm.org_objid AS orgid, 
  u.txncode AS txncode, 
  u.jobtitle AS jobtitle, 
  ugm.objid AS usergroupmemberid, 
  ugm.usergroup_objid AS usergroup_objid, 
  ugm.org_objid as respcenter_objid, 
  ugm.org_name as respcenter_name 
from sys_usergroup_member ugm 
  inner join sys_usergroup ug on ug.objid = ugm.usergroup_objid 
  inner join sys_user u on u.objid = ugm.user_objid 
;


drop view if exists vw_account_incometarget
;
create view vw_account_incometarget as 
select t.*, a.maingroupid, 
    a.objid as item_objid, a.code as item_code, a.title as item_title, 
    a.`level` as item_level, a.leftindex as item_leftindex, 
    g.objid as group_objid, g.code as group_code, g.title as group_title, 
    g.`level` as group_level, g.leftindex as group_leftindex 
from account_incometarget t 
    inner join account a on a.objid = t.itemid 
    inner join account g on g.objid = a.groupid 
;


DROP VIEW IF EXISTS vw_business_application_lob_retire
;
CREATE VIEW vw_business_application_lob_retire AS 
select 
a.business_objid AS businessid, 
a.objid AS applicationid, 
a.appno AS appno, 
a.appyear AS appyear, 
a.dtfiled AS dtfiled, 
a.txndate AS txndate, 
a.tradename AS tradename, 
b.bin AS bin, 
alob.assessmenttype AS assessmenttype, 
alob.lobid AS lobid, 
alob.name AS lobname, 
a.objid AS refid, 
a.appno AS refno  
from business_application a 
    inner join business_application_lob alob on alob.applicationid = a.objid 
    inner join business b on b.objid = a.business_objid 
where alob.assessmenttype = 'RETIRE' 
    and a.state = 'COMPLETED' 
    and a.parentapplicationid is null 
union all 
select 
pa.business_objid AS businessid, 
pa.objid AS applicationid, 
pa.appno AS appno, 
pa.appyear AS appyear, 
pa.dtfiled AS dtfiled, 
pa.txndate AS txndate, 
pa.tradename AS tradename, 
b.bin AS bin, 
alob.assessmenttype AS assessmenttype, 
alob.lobid AS lobid, 
alob.name AS lobname, 
a.objid AS refid, 
a.appno AS refno  
from business_application a 
    inner join business_application pa on pa.objid = a.parentapplicationid 
    inner join business_application_lob alob on alob.applicationid = a.objid 
    inner join business b on b.objid = pa.business_objid 
where alob.assessmenttype = 'RETIRE' 
    and a.state = 'COMPLETED'
;


drop view if exists vw_entity_mapping 
;
create view vw_entity_mapping as 
select 
  r.*,
  e.entityno,
  e.name, 
  e.address_text as address_text,
  a.province as address_province,
  a.municipality as address_municipality
from entity_mapping r 
inner join entity e on r.objid = e.objid 
left join entity_address a on e.address_objid = a.objid
left join sys_org b on a.barangay_objid = b.objid 
left join sys_org m on b.parent_objid = m.objid 
;


DROP VIEW IF EXISTS vw_fund 
;
CREATE VIEW vw_fund AS 
select 
f.objid AS objid, 
f.parentid AS parentid, 
f.state AS state, 
f.code AS code, 
f.title AS title, 
f.type AS type, 
f.special AS special, 
f.system AS system, 
f.groupid AS groupid, 
f.depositoryfundid AS depositoryfundid, 
g.objid AS group_objid, 
g.title AS group_title, 
g.indexno AS group_indexno, 
d.objid AS depositoryfund_objid, 
d.state AS depositoryfund_state, 
d.code AS depositoryfund_code, 
d.title AS depositoryfund_title  
from fund f 
    left join fundgroup g on g.objid = f.groupid 
    left join fund d on d.objid = f.depositoryfundid
;



-- ## 2020-04-21

drop view if exists vw_cashbook_cashreceipt
; 
CREATE VIEW vw_cashbook_cashreceipt AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  ci.amount AS dr, null AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid
  inner join cashreceiptitem ci on ci.receiptid = c.objid
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_cashreceipt_share
; 
CREATE VIEW vw_cashbook_cashreceipt_share AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount AS dr, 0.0 AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.refitem_objid AS refitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_cashreceipt_share_payable
; 
CREATE VIEW vw_cashbook_cashreceipt_share_payable AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount AS dr, 0.0 AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.payableitem_objid AS payableitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid  
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_remittance
;
CREATE VIEW vw_cashbook_remittance AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ci.item_fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null AS dr, ci.amount as cr,   
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series, 
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name, 
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share
;
CREATE VIEW vw_cashbook_remittance_share AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  0.0 AS dr, cs.amount as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share_payable
;
CREATE VIEW vw_cashbook_remittance_share_payable AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  0.0 AS dr, cs.amount as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_cashbook_cashreceiptvoid
; 
CREATE VIEW vw_cashbook_cashreceiptvoid AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  -ci.amount as dr, 
  -ci.amount as cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount as dr, 
  (
    case 
      when r.liquidatingofficer_objid is null then 0.0 
      when v.txndate > r.dtposted then cs.amount 
      else 0.0  
    end
  ) AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share_payable
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share_payable AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount as dr, 
  (
    case 
      when r.liquidatingofficer_objid is null then 0.0 
      when v.txndate > r.dtposted then cs.amount 
      else 0.0  
    end
  ) AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;



-- ## 2020-05-15

drop view if exists vw_remittance_cashreceiptitem
;
create view vw_remittance_cashreceiptitem AS 
select 
  c.remittanceid AS remittanceid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.collectiontype_name AS collectiontype_name, 
  c.org_objid AS org_objid, 
  c.org_name AS org_name, 
  c.formtype AS formtype, 
  c.formno AS formno, 
  (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex, 
  cri.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.controlid as controlid, 
  c.series as series, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.collector_objid AS collectorid, 
  c.collector_name AS collectorname, 
  c.collector_title AS collectortitle, 
  cri.item_fund_objid AS fundid, 
  cri.item_objid AS acctid, 
  cri.item_code AS acctcode, 
  cri.item_title AS acctname, 
  cri.remarks AS remarks, 
  (case when v.objid is null then cri.amount else 0.0 end) AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else cri.amount end) AS voidamount  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem cri on cri.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_collectionvoucher_cashreceiptitem
;
create view vw_collectionvoucher_cashreceiptitem AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.remittanceid AS remittanceid, 
  v.remittance_controldate AS remittance_controldate, 
  v.remittance_controlno AS remittance_controlno, 
  v.collectionvoucherid AS collectionvoucherid, 
  v.collectiontype_objid AS collectiontype_objid, 
  v.collectiontype_name AS collectiontype_name, 
  v.org_objid AS org_objid, 
  v.org_name AS org_name, 
  v.formtype AS formtype, 
  v.formno AS formno, 
  v.formtypeindex AS formtypeindex, 
  v.receiptid AS receiptid, 
  v.receiptdate AS receiptdate, 
  v.receiptno AS receiptno, 
  v.controlid as controlid,
  v.series as series,
  v.paidby AS paidby, 
  v.paidbyaddress AS paidbyaddress, 
  v.collectorid AS collectorid, 
  v.collectorname AS collectorname, 
  v.collectortitle AS collectortitle, 
  v.fundid AS fundid, 
  v.acctid AS acctid, 
  v.acctcode AS acctcode, 
  v.acctname AS acctname, 
  v.amount AS amount, 
  v.voided AS voided, 
  v.voidamount AS voidamount, 
  v.remarks as remarks 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptitem v on v.collectionvoucherid = cv.objid 
;


drop table if exists vw_af_inventory_summary
;
drop view if exists vw_af_inventory_summary
;
CREATE VIEW vw_af_inventory_summary AS 
select 
  af.objid, af.title, u.unit, af.formtype, 
  (case when af.formtype='serial' then 0 else 1 end) as formtypeindex, 
  (select count(0) from af_control where afid = af.objid and state = 'OPEN') AS countopen, 
  (select count(0) from af_control where afid = af.objid and state = 'ISSUED') AS countissued, 
  (select count(0) from af_control where afid = af.objid and state = 'ISSUED' and currentseries > endseries) AS countclosed, 
  (select count(0) from af_control where afid = af.objid and state = 'SOLD') AS countsold, 
  (select count(0) from af_control where afid = af.objid and state = 'PROCESSING') AS countprocessing, 
  (select count(0) from af_control where afid = af.objid and state = 'HOLD') AS counthold
from af, afunit u 
where af.objid = u.itemid
order by (case when af.formtype='serial' then 0 else 1 end), af.objid 
;



-- ## 2021-01-05

drop view if exists vw_remittance_cashreceiptitem
;
create view vw_remittance_cashreceiptitem AS 
select 
  c.remittanceid AS remittanceid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.collectiontype_name AS collectiontype_name, 
  c.org_objid AS org_objid, 
  c.org_name AS org_name, 
  c.formtype AS formtype, 
  c.formno AS formno, 
  cri.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.controlid as controlid, 
  c.series as series, 
  c.stub as stubno, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.collector_objid AS collectorid, 
  c.collector_name AS collectorname, 
  c.collector_title AS collectortitle, 
  cri.item_fund_objid AS fundid, 
  cri.item_objid AS acctid, 
  cri.item_code AS acctcode, 
  cri.item_title AS acctname, 
  cri.remarks AS remarks, 
  (case when v.objid is null then cri.amount else 0.0 end) AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else cri.amount end) AS voidamount,   
  (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem cri on cri.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_collectionvoucher_cashreceiptitem
;
create view vw_collectionvoucher_cashreceiptitem AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.*  
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptitem v on v.collectionvoucherid = cv.objid 
;



drop view if exists vw_remittance_cashreceiptshare
;
create view vw_remittance_cashreceiptshare AS 
select 
  c.remittanceid AS remittanceid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.controlid as controlid, 
  cs.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.org_objid AS org_objid, 
  c.org_name AS org_name, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.collectiontype_name AS collectiontype_name, 
  c.collector_objid AS collectorid, 
  c.collector_name AS collectorname, 
  c.collector_title AS collectortitle, 
  cs.refitem_objid AS refacctid, 
  ia.fund_objid AS fundid, 
  ia.objid AS acctid, 
  ia.code AS acctcode, 
  ia.title AS acctname, 
  (case when v.objid is null then cs.amount else 0.0 end) AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else cs.amount end) AS voidamount, 
  (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
; 


drop view if exists vw_collectionvoucher_cashreceiptshare
;
create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
; 



drop view if exists vw_remittance_cashreceiptpayment_noncash
; 
create view vw_remittance_cashreceiptpayment_noncash AS 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  nc.reftype AS reftype, 
  nc.particulars AS particulars, 
  nc.fund_objid as fundid, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  cp.bankid AS bankid, 
  cp.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'CHECK') 
  inner join checkpayment cp on cp.objid = nc.refid 
  left join cashreceipt_void v on v.receiptid = c.objid 
union all 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  'EFT' AS reftype, 
  nc.particulars AS particulars, 
  nc.fund_objid as fundid, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  ba.bank_objid AS bankid, 
  ba.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'EFT') 
  inner join eftpayment eft on eft.objid = nc.refid 
  inner join bankaccount ba on ba.objid = eft.bankacctid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;



-- ## 2021-01-16

DROP TABLE IF EXISTS vw_online_business_application 
;
DROP VIEW IF EXISTS vw_online_business_application 
;
CREATE VIEW vw_online_business_application AS 
select 
  oa.objid AS objid, 
  oa.state AS state, 
  oa.dtcreated AS dtcreated, 
  oa.createdby_objid AS createdby_objid, 
  oa.createdby_name AS createdby_name, 
  oa.controlno AS controlno, 
  oa.apptype AS apptype, 
  oa.appyear AS appyear, 
  oa.appdate AS appdate, 
  oa.prevapplicationid AS prevapplicationid, 
  oa.business_objid AS business_objid, 
  b.bin AS bin, 
  b.tradename AS tradename, 
  b.businessname AS businessname, 
  b.address_text AS address_text, 
  b.address_objid AS address_objid, 
  b.owner_name AS owner_name, 
  b.owner_address_text AS owner_address_text, 
  b.owner_address_objid AS owner_address_objid, 
  b.yearstarted AS yearstarted, 
  b.orgtype AS orgtype, 
  b.permittype AS permittype, 
  b.officetype AS officetype, 
  oa.step AS step 
from online_business_application oa 
  inner join business_application a on a.objid = oa.prevapplicationid 
  inner join business b on b.objid = a.business_objid
;



-- ## 2021-09-15

drop view if exists vw_remittance_cashreceiptshare
;
create view vw_remittance_cashreceiptshare AS 
select 
  c.remittanceid AS remittanceid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.controlid as controlid, 
  c.series as series,
  cs.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.org_objid AS org_objid, 
  c.org_name AS org_name, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.collectiontype_name AS collectiontype_name, 
  c.collector_objid AS collectorid, 
  c.collector_name AS collectorname, 
  c.collector_title AS collectortitle, 
  cs.refitem_objid AS refacctid, 
  ia.fund_objid AS fundid, 
  ia.objid AS acctid, 
  ia.code AS acctcode, 
  ia.title AS acctname, 
  (case when v.objid is null then cs.amount else 0.0 end) AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else cs.amount end) AS voidamount, 
  (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
; 


drop view if exists vw_collectionvoucher_cashreceiptshare
;
create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
; 



-- ## 2022-04-15

drop view if exists vw_cashbook_cashreceipt
; 
CREATE VIEW vw_cashbook_cashreceipt AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  ci.amount as dr, null as cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid
  inner join cashreceiptitem ci on ci.receiptid = c.objid
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceipt_share
; 
CREATE VIEW vw_cashbook_cashreceipt_share AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  -cs.amount AS dr, null AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.refitem_objid AS refitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceipt_share_payable
; 
CREATE VIEW vw_cashbook_cashreceipt_share_payable AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount AS dr, null AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.payableitem_objid AS payableitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid  
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_cashreceiptvoid
; 
CREATE VIEW vw_cashbook_cashreceiptvoid AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -ci.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then -ci.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -ci.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then -ci.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then cs.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then cs.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then cs.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share_payable
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share_payable AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -cs.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then -cs.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then -cs.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_remittance
;
CREATE VIEW vw_cashbook_remittance AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ci.item_fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then ci.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then ci.amount
    else null 
  end) as cr,  
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series, 
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name, 
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share
;
CREATE VIEW vw_cashbook_remittance_share AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then -cs.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then -cs.amount 
    else null 
  end) as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share_payable
;
CREATE VIEW vw_cashbook_remittance_share_payable AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then cs.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then cs.amount 
    else null 
  end) as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid
  left join cashreceipt_void v on v.receiptid = c.objid 
;





-- ## 2022-09-01

DROP VIEW IF EXISTS vw_collectiontype
;
CREATE VIEW vw_collectiontype AS 
select 
  c.objid AS objid,
  c.state AS state,
  c.name AS name,
  c.title AS title,
  c.formno AS formno,
  c.handler AS handler,
  c.allowbatch AS allowbatch,
  c.barcodekey AS barcodekey,
  c.allowonline AS allowonline,
  c.allowoffline AS allowoffline,
  c.sortorder AS sortorder,
  o.org_objid AS orgid,
  c.fund_objid AS fund_objid,
  c.fund_title AS fund_title,
  c.category AS category,
  c.queuesection AS queuesection,
  c.system AS system,
  af.formtype AS af_formtype,
  af.serieslength AS af_serieslength,
  af.denomination AS af_denomination,
  af.baseunit AS af_baseunit,
  c.allowpaymentorder AS allowpaymentorder,
  c.allowkiosk AS allowkiosk,
  c.allowcreditmemo AS allowcreditmemo,
  c.connection AS connection,
  c.servicename AS servicename 
from collectiontype_org o 
  inner join collectiontype c on c.objid = o.collectiontypeid 
  inner join af on af.objid = c.formno 
where c.state = 'ACTIVE' 
union 
select 
  c.objid AS objid,
  c.state AS state,
  c.name AS name,
  c.title AS title,
  c.formno AS formno,
  c.handler AS handler,
  c.allowbatch AS allowbatch,
  c.barcodekey AS barcodekey,
  c.allowonline AS allowonline,
  c.allowoffline AS allowoffline,
  c.sortorder AS sortorder,NULL AS orgid,
  c.fund_objid AS fund_objid,
  c.fund_title AS fund_title,
  c.category AS category,
  c.queuesection AS queuesection,
  c.system AS system,
  af.formtype AS af_formtype,
  af.serieslength AS af_serieslength,
  af.denomination AS af_denomination,
  af.baseunit AS af_baseunit,
  c.allowpaymentorder AS allowpaymentorder,
  c.allowkiosk AS allowkiosk,
  c.allowcreditmemo AS allowcreditmemo,
  c.connection AS connection,
  c.servicename AS servicename 
from collectiontype c 
  inner join af on af.objid = c.formno 
  left join collectiontype_org o on c.objid = o.collectiontypeid 
where o.objid is null 
  and c.state = 'ACTIVE'
;




-- ## 2022-09-19

drop table if exists vw_migrated_business
;
drop view if exists vw_migrated_business
;
create view vw_migrated_business as 
select 
  b.objid as objid, 
  b.state as state, 
  b.bin AS bin, 
  b.tradename AS tradename, 
  b.businessname AS businessname, 
  b.address_text AS address_text, 
  b.address_objid AS address_objid, 
  b.owner_name AS owner_name, 
  b.owner_address_text AS owner_address_text, 
  b.owner_address_objid AS owner_address_objid, 
  b.yearstarted AS yearstarted, 
  b.orgtype AS orgtype, 
  b.permittype AS permittype, 
  b.officetype AS officetype, 
  a.objid as applicationid, 
  a.state as appstate,
  a.appyear as appyear,
  a.apptype as apptype,
  a.appno as appno, 
  a.dtfiled as dtfiled,
  a.txndate as txndate, 
  a.txnmode as txnmode 
from migrated_business mb 
  inner join business b on b.objid = mb.objid 
  inner join business_application a on a.objid = mb.applicationid 
;




UPDATE sys_var SET 
  VALUE='ba4d084b31b41fbe55302c0429d93c81' 
WHERE name='sa_pwd'
;
DELETE FROM sys_var WHERE name='sa_pwd_change_on_logon'
;
INSERT IGNORE INTO sys_terminal (terminalid) VALUES ('T12345678')
;


-- alter table sys_org add txncode varchar(5) NULL 
-- ;

-- alter table remittance add remarks varchar(255) null 
-- ; 
