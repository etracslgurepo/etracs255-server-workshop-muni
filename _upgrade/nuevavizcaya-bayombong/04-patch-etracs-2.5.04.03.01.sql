-- ## 2021-09-15

if object_id('dbo.vw_collectionvoucher_cashreceiptshare', 'V') IS NOT NULL
  drop view vw_collectionvoucher_cashreceiptshare
go 

if object_id('dbo.vw_remittance_cashreceiptshare', 'V') IS NOT NULL
  drop view vw_remittance_cashreceiptshare
go 

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
go 

create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
go 




-- ## 2021-09-24

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_NAME', NULL, 'Cashbook Report Certified By Name', 'text', 'REPORT');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_TITLE', NULL, 'Cashbook Report Certified By Title', 'text', 'REPORT');




-- ## 2021-09-27

if object_id('dbo.report_bpdelinquency_item', 'U') IS NOT NULL 
  drop table dbo.report_bpdelinquency_item; 
go 
if object_id('dbo.report_bpdelinquency', 'U') IS NOT NULL 
  drop table dbo.report_bpdelinquency; 
go 


CREATE TABLE report_bpdelinquency (
  objid varchar(50) NOT NULL,
  state varchar(25) NULL,
  dtfiled datetime NULL,
  userid varchar(50) NULL,
  username varchar(160) NULL,
  totalcount int NULL,
  processedcount int NULL,
  billdate date NULL,
  duedate date NULL,
  lockid varchar(50) NULL,
  constraint pk_report_bpdelinquency PRIMARY KEY (objid)
) 
go 
CREATE INDEX ix_state ON report_bpdelinquency (state)
go
CREATE INDEX ix_dtfiled ON report_bpdelinquency (dtfiled)
go
CREATE INDEX ix_userid ON report_bpdelinquency (userid)
go
CREATE INDEX ix_billdate ON report_bpdelinquency (billdate)
go
CREATE INDEX ix_duedate ON report_bpdelinquency (duedate)
go


CREATE TABLE report_bpdelinquency_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  applicationid varchar(50) NOT NULL,
  tax decimal(16,2) NOT NULL DEFAULT 0.0,
  regfee decimal(16,2) NOT NULL DEFAULT 0.0,
  othercharge decimal(16,2) NOT NULL DEFAULT 0.0,
  surcharge decimal(16,2) NOT NULL DEFAULT 0.0,
  interest decimal(16,2) NOT NULL DEFAULT 0.0,
  total decimal(16,2) NOT NULL DEFAULT 0.0,
  duedate date NULL,
  year int NOT NULL,
  qtr int NOT NULL,
  constraint pk_report_bpdelinquency_item PRIMARY KEY (objid)
) 
go
CREATE INDEX ix_parentid ON report_bpdelinquency_item (parentid);
go
CREATE INDEX ix_applicationid ON report_bpdelinquency_item (applicationid);
go
CREATE INDEX ix_year ON report_bpdelinquency_item (year);
go
CREATE INDEX ix_qtr ON report_bpdelinquency_item (qtr);
go
ALTER TABLE report_bpdelinquency_item ADD CONSTRAINT fk_report_bpdelinquency_item_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
go

CREATE TABLE report_bpdelinquency_app (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  applicationid varchar(50) NOT NULL,
  appdate date not null,
  appyear int not null,
  lockid varchar(50) NULL,
  constraint pk_report_bpdelinquency_app PRIMARY KEY (objid)
) 
go 
create unique index uix_parentid_applicationid on report_bpdelinquency_app (parentid, applicationid)
go 
CREATE INDEX ix_parentid ON report_bpdelinquency_app (parentid);
go
CREATE INDEX ix_applicationid ON report_bpdelinquency_app (applicationid);
go
CREATE INDEX ix_appdate ON report_bpdelinquency_app (appdate);
go
CREATE INDEX ix_appyear ON report_bpdelinquency_app (appyear);
go
CREATE INDEX ix_lockid ON report_bpdelinquency_app (lockid);
go
ALTER TABLE report_bpdelinquency_app ADD CONSTRAINT fk_report_bpdelinquency_app_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
go 




-- ## 2021-10-01

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('cashbook_report_allow_multiple_fund_selection', '0', 'Cashbook Report: Allow Multiple Fund Selection', 'checkbox', 'TC');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('liquidate_remittance_as_of_date', '1', 'Liquidate Remittances as of Date', 'checkbox', 'TC');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('cashreceipt_reprint_requires_approval', 'false', 'CashReceipt Reprinting Requires Approval', 'checkbox', 'TC');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('cashreceipt_void_requires_approval', 'true', 'CashReceipt Void Requires Approval', 'checkbox', 'TC');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('deposit_collection_by_bank_account', '0', 'Deposit collection by bank account instead of by fund', 'checkbox', 'TC');




-- ## 2021-11-06

INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
VALUES ('TREASURY.MANAGER', 'TREASURY MANAGER', 'TREASURY', 'usergroup', NULL, 'MANAGER');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('treasury_remote_orgs', '', NULL, 'text', 'TC');


update raf set 
  raf.controlid = d.controlid, 
  raf.receivedstartseries = d.receivedstartseries, 
  raf.receivedendseries = d.receivedendseries, 
  raf.qtyreceived = d.qtyreceived, 
  raf.beginstartseries = d.beginstartseries, 
  raf.beginendseries = d.beginendseries, 
  raf.qtybegin = d.qtybegin, 
  raf.issuedstartseries = d.issuedstartseries, 
  raf.issuedendseries = d.issuedendseries, 
  raf.qtyissued = d.qtyissued, 
  raf.endingstartseries = d.endingstartseries, 
  raf.endingendseries = d.endingendseries, 
  raf.qtyending = d.qtyending, 
  raf.qtycancelled = d.qtycancelled, 
  raf.remarks = d.remarks 
from remittance_af raf, af_control_detail d 
where raf.objid = d.objid 
  and raf.controlid is null 
; 

delete from af_control_detail where reftype='remittance' and txntype = 'forward' 
; 


insert into sys_usergroup_member (
  objid, usergroup_objid, user_objid, user_username, user_firstname, user_lastname 
) 
select * 
from ( 
  select 
  ('UGM-'+ convert(varchar(50), HashBytes('MD5', (u.objid + ug.objid)), 2)) as objid, 
    ug.objid as usergroup_objid, u.objid as user_objid, 
    u.username as user_username, u.firstname as user_firstname, u.lastname as user_lastname
  from 
    sys_user u, sys_usergroup ug, 
    (select distinct user_objid from sys_usergroup_member where usergroup_objid = 'ADMIN.SYSADMIN') xx 
  where u.objid = xx.user_objid 
    and ug.domain='TREASURY' 
    and ug.objid in ('TREASURY.AFO_ADMIN','TREASURY.COLLECTOR_ADMIN','TREASURY.LIQ_OFFICER_ADMIN','TREASURY.MANAGER')
)t0 
where (
  select count(*) from sys_usergroup_member 
  where usergroup_objid = t0.usergroup_objid 
    and user_objid = t0.user_objid 
) = 0 
;




-- ## 2021-11-25

create table online_business_application_doc (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  doc_type varchar(50) not null, 
  doc_title varchar(255) not null, 
  attachment_objid varchar(50) not null,
  attachment_name varchar(255) not null, 
  attachment_path varchar(255) not null,
  fs_filetype varchar(10) not null, 
  fs_filelocid varchar(50) null, 
  fs_fileid varchar(50) null, 
  lockid varchar(50) null, 
  constraint pk_online_business_application_doc PRIMARY KEY (objid) 
) 
go
create index ix_parentid on online_business_application_doc (parentid)
go
create index ix_attachment_objid on online_business_application_doc (attachment_objid)
go
create index ix_fs_filelocid on online_business_application_doc (fs_filelocid)
go
create index ix_fs_fileid on online_business_application_doc (fs_fileid)
go
create index ix_lockid on online_business_application_doc (lockid)
go
alter table online_business_application_doc 
  add CONSTRAINT fk_online_business_application_doc_parentid 
  FOREIGN KEY (parentid) REFERENCES online_business_application (objid)
go


CREATE TABLE online_business_application_doc_fordownload (
  objid varchar(50) NOT NULL,
  scheduledate datetime NOT NULL,
  msg text NULL,
  filesize int NOT NULL DEFAULT '0',
  bytesprocessed int NOT NULL DEFAULT '0',
  lockid varchar(50) NULL,
  constraint pk_online_business_application_doc_fordownload PRIMARY KEY (objid) 
) 
go
create index ix_scheduledate on online_business_application_doc_fordownload (scheduledate)
go
create index ix_lockid on online_business_application_doc_fordownload (lockid)
go
alter table online_business_application_doc_fordownload 
  add CONSTRAINT fk_online_business_application_doc_fordownload_objid 
  FOREIGN KEY (objid) REFERENCES online_business_application_doc (objid)
go 


CREATE TABLE sys_fileloc (
  objid varchar(50) NOT NULL,
  url varchar(255) NOT NULL,
  rootdir varchar(255) NULL,
  defaultloc int NOT NULL,
  loctype varchar(20) NULL,
  user_name varchar(50) NULL,
  user_pwd varchar(50) NULL,
  info text,
  constraint pk_sys_fileloc PRIMARY KEY (objid)
) 
go
create index ix_loctype on sys_fileloc (loctype)
go

CREATE TABLE sys_file (
  objid varchar(50) NOT NULL,
  title varchar(50) NULL,
  filetype varchar(50) NULL,
  dtcreated datetime NULL,
  createdby_objid varchar(50) NULL,
  createdby_name varchar(255) NULL,
  keywords varchar(255) NULL,
  description text,
  constraint pk_sys_file PRIMARY KEY (objid)
) 
go
create index ix_dtcreated on sys_file (dtcreated)
go
create index ix_createdby_objid on sys_file (createdby_objid)
go
create index ix_keywords on sys_file (keywords)
go
create index ix_title on sys_file (title)
go

CREATE TABLE sys_fileitem (
  objid varchar(50) NOT NULL,
  state varchar(50) NULL,
  parentid varchar(50) NULL,
  dtcreated datetime NULL,
  createdby_objid varchar(50) NULL,
  createdby_name varchar(255) NULL,
  caption varchar(155) NULL,
  remarks varchar(255) NULL,
  filelocid varchar(50) NULL,
  filesize int NULL,
  thumbnail text,
  constraint pk_sys_fileitem PRIMARY KEY (objid)
) 
go
create index ix_parentid on sys_fileitem (parentid)
go
create index ix_filelocid on sys_fileitem (filelocid)
go
alter table sys_fileitem 
  add CONSTRAINT fk_sys_fileitem_parentid 
  FOREIGN KEY (parentid) REFERENCES sys_file (objid)
go


alter table online_business_application_doc add fs_state varchar(20) NOT NULL
go


INSERT INTO sys_fileloc (objid, url, rootdir, defaultloc, loctype, user_name, user_pwd, info) 
VALUES ('bpls-fileserver', '127.0.0.1', NULL, '0', 'ftp', 'ftpuser', 'P@ssw0rd#', NULL);

INSERT INTO sys_fileloc (objid, url, rootdir, defaultloc, loctype, user_name, user_pwd, info) 
VALUES ('bpls-fileserver-pub', '127.0.0.1', NULL, '0', 'ftp', 'ftpuser', 'P@ssw0rd#', NULL);




-- ## 2021-11-26

CREATE TABLE [sys_email_template] (
  [objid] varchar(50) NOT NULL,
  [subject] varchar(255) NOT NULL,
  [message] text NOT NULL,
  PRIMARY KEY (objid)
) 
go

INSERT INTO sys_email_template (objid, subject, message) 
VALUES ('business_permit', 'Business Permit ${permitno}', 'Dear valued customer, <br><br>Please see attached Business Permit document. This is an electronic transaction. Please do not reply.');




-- ## 2022-01-17

update aa set 
  aa.yearstarted = bb.newyearstarted 
from 
  business aa, 
  (
    select 
      b.objid, b.yearstarted as oldyearstarted, 
      min(a.yearstarted) as newyearstarted
    from business b, business_application a 
    where a.business_objid = b.objid 
    group by b.objid, b.yearstarted 
    having b.yearstarted <> min(a.yearstarted)
  )bb 
where 
  aa.objid = bb.objid 
; 

update a set 
  a.yearstarted = b.yearstarted 
from 
  business_application a, 
  business b 
where 
  a.business_objid = b.objid and 
  a.yearstarted <> b.yearstarted 
; 




-- ## 2022-03-07

delete from sys_wf_transition where processname = 'business_application' and parentid = 'approval' and action = 'submit' 
;

insert into sys_wf_transition (
  parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui
) 
values (
  'approval', 'business_application', 'submit', 'payment', '0', NULL, 
  '[caption:"Approve For Payment",  icon:"approve",  confirm: ''You are about to submit this for payment. Proceed?'',   depends: ''currentSection'',   visibleWhen: ''#{(has_loaded_assessment == true && entity.totals.total > 0)}'']', NULL, NULL, NULL
)
;

insert into sys_wf_transition (
  parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui
) 
values (
  'approval', 'business_application', 'submit', 'release', '0', NULL, 
  '[caption:"Approve For Release",  icon:"approve",  confirm: ''You are about to submit this for release. Proceed?'',   depends: ''currentSection'',   visibleWhen: ''#{(has_loaded_assessment == true && entity.totals.total == 0)}'']', NULL, NULL, NULL
)
;




-- ## 2022-04-07

insert into sys_rule_fact_field (
  objid, parentid, name, title, sortorder, [handler], datatype, vardatatype 
) 
select 
  (f.objid + '.year') as objid, f.objid as parentid, 'year' as name, 'Year' as title, 
  4 as sortorder, 'integer' as handler, 'integer' as datatype, 'integer' as vardatatype 
from sys_rule_fact f 
  left join sys_rule_fact_field ff on (ff.parentid = f.objid and ff.name = 'year') 
where f.factclass = 'bpls.facts.BillItem'
  and ff.objid is null 
; 




-- ## 2022-04-11

INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUBarangay', 'treasury.facts.LGUBarangay', 'LGU Barangay', 'treasury.facts.LGUBarangay', '100', NULL, 'BRGY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUMunicipality', 'treasury.facts.LGUMunicipality', 'LGU Municipality', 'treasury.facts.LGUMunicipality', '100', NULL, 'MUNI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUProvince', 'treasury.facts.LGUProvince', 'LGU Province', 'treasury.facts.LGUProvince', '100', NULL, 'PROV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');

INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgid', 'treasury.facts.LGUBarangay', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgclass', 'treasury.facts.LGUBarangay', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.root', 'treasury.facts.LGUBarangay', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgid', 'treasury.facts.LGUMunicipality', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgclass', 'treasury.facts.LGUMunicipality', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.root', 'treasury.facts.LGUMunicipality', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgid', 'treasury.facts.LGUProvince', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgclass', 'treasury.facts.LGUProvince', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.root', 'treasury.facts.LGUProvince', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUBarangay');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUMunicipality');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUProvince');


INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.CollectionType', 'treasury.facts.CollectionType', 'Collection Type', 'treasury.facts.CollectionType', '0', NULL, 'CT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', NULL);

INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.CollectionType.objid', 'treasury.facts.CollectionType', 'objid', 'ID', 'string', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.CollectionType.name', 'treasury.facts.CollectionType', 'name', 'Name', 'string', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.CollectionType.handler', 'treasury.facts.CollectionType', 'handler', 'Handler', 'string', '2', 'lookup', 'collectiontype_handler:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.CollectionType');




-- ## 2022-04-15

if object_id('dbo.vw_cashbook_cashreceipt', 'V') IS NOT NULL
  drop view vw_cashbook_cashreceipt
go 
CREATE VIEW vw_cashbook_cashreceipt AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,
  'cashreceipt' AS reftype, 
  (ct.name +' ('+ c.paidby +')') AS particulars, 
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
go

if object_id('dbo.vw_cashbook_cashreceipt_share', 'V') IS NOT NULL
  drop view vw_cashbook_cashreceipt_share
go 
CREATE VIEW vw_cashbook_cashreceipt_share AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  (ct.name +' ('+ c.paidby +')') AS particulars, 
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
go

if object_id('dbo.vw_cashbook_cashreceipt_share_payable', 'V') IS NOT NULL
  drop view vw_cashbook_cashreceipt_share_payable
go 
CREATE VIEW vw_cashbook_cashreceipt_share_payable AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  (ct.name +' ('+ c.paidby +')') AS particulars, 
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
go

if object_id('dbo.vw_cashbook_cashreceiptvoid', 'V') IS NOT NULL
  drop view vw_cashbook_cashreceiptvoid
go 
CREATE VIEW vw_cashbook_cashreceiptvoid AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  ('VOID '+ v.reason) AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -ci.amount
    when v.txndate <= ISNULL(r.dtposted, v.txndate) then -ci.amount
    when v.txndate > ISNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -ci.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > ISNULL(r.dtposted, v.txndate) then -ci.amount
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
go

if object_id('dbo.vw_cashbook_cashreceiptvoid_share', 'V') IS NOT NULL
  drop view vw_cashbook_cashreceiptvoid_share
go 
CREATE VIEW vw_cashbook_cashreceiptvoid_share AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  ('VOID '+ v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then cs.amount
    when v.txndate <= ISNULL(r.dtposted, v.txndate) then cs.amount
    when v.txndate > ISNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > ISNULL(r.dtposted, v.txndate) then cs.amount
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
go

if object_id('dbo.vw_cashbook_cashreceiptvoid_share_payable', 'V') IS NOT NULL
  drop view vw_cashbook_cashreceiptvoid_share_payable
go 
CREATE VIEW vw_cashbook_cashreceiptvoid_share_payable AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype, 
  ('VOID '+ v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -cs.amount
    when v.txndate <= ISNULL(r.dtposted, v.txndate) then -cs.amount
    when v.txndate > ISNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > ISNULL(r.dtposted, v.txndate) then -cs.amount
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
go


if object_id('dbo.vw_cashbook_remittance', 'V') IS NOT NULL
  drop view vw_cashbook_remittance
go 
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
    when r.dtposted < ISNULL(v.txndate, r.dtposted) then ci.amount
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
go

if object_id('dbo.vw_cashbook_remittance_share', 'V') IS NOT NULL
  drop view vw_cashbook_remittance_share
go 
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
    when r.dtposted < ISNULL(v.txndate, r.dtposted) then -cs.amount 
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
go

if object_id('dbo.vw_cashbook_remittance_share_payable', 'V') IS NOT NULL
  drop view vw_cashbook_remittance_share_payable
go 
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
    when r.dtposted < ISNULL(v.txndate, r.dtposted) then cs.amount 
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
go
