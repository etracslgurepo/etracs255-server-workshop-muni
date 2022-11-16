-- ## 2020-03-16

RENAME TABLE `account_incometarget` TO `z20200316_account_incometarget`
; 

CREATE TABLE `account_incometarget` (
  `objid` varchar(50) NOT NULL,
  `itemid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `target` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_itemid` (`itemid`),
  KEY `ix_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table account_incometarget add CONSTRAINT `fk_account_incometarget_itemid` 
   FOREIGN KEY (`itemid`) REFERENCES `account` (`objid`)
;

/*
CREATE TABLE `business_closure` ( 
   `objid` varchar(50) NOT NULL, 
   `businessid` varchar(50) NOT NULL, 
   `dtcreated` datetime NOT NULL, 
   `createdby_objid` varchar(50) NOT NULL, 
   `createdby_name` varchar(150) NOT NULL, 
   `dtceased` date NOT NULL, 
   `dtissued` datetime NOT NULL, 
   `remarks` text NULL,
   CONSTRAINT `pk_business_closure` PRIMARY KEY (`objid`),
   UNIQUE KEY `uix_businessid` (`businessid`),
   KEY `ix_createdby_objid` (`createdby_objid`),
   KEY `ix_dtceased` (`dtceased`),
   KEY `ix_dtcreated` (`dtcreated`),
   KEY `ix_dtissued` (`dtissued`),
   CONSTRAINT `fk_business_closure_businessid` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 
*/

-- create UNIQUE index `uix_code` on businessrequirementtype (`code`); 
-- create UNIQUE index `uix_title` on businessrequirementtype (`title`); 

-- create UNIQUE index `uix_name` on businessvariable (`name`);

CREATE TABLE `cashreceipt_group` ( 
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NOT NULL, 
   `controlid` varchar(50) NOT NULL, 
   `amount` decimal(16,2) NOT NULL, 
   `totalcash` decimal(16,2) NOT NULL, 
   `totalnoncash` decimal(16,2) NOT NULL, 
   `cashchange` decimal(16,2) NOT NULL,
   CONSTRAINT `pk_cashreceipt_group` PRIMARY KEY (`objid`),
   KEY `ix_controlid` (`controlid`),
   KEY `ix_txndate` (`txndate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `cashreceipt_groupitem` ( 
   `objid` varchar(50) NOT NULL, 
   `parentid` varchar(50) NOT NULL,
   CONSTRAINT `pk_cashreceipt_groupitem` PRIMARY KEY (`objid`),
   KEY `ix_parentid` (`parentid`),
   CONSTRAINT `fk_cashreceipt_groupitem_objid` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`),
   CONSTRAINT `fk_cashreceipt_groupitem_parentid` FOREIGN KEY (`parentid`) REFERENCES `cashreceipt_group` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `cashreceipt_plugin` ( 
   `objid` varchar(50) NOT NULL, 
   `connection` varchar(150) NOT NULL, 
   `servicename` varchar(255) NOT NULL,
   CONSTRAINT `pk_cashreceipt_plugin` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


-- create unique index uix_receiptid on cashreceipt_void (receiptid); 

alter table collectiontype add info text null 
; 

CREATE TABLE `entity_mapping` ( 
   `objid` varchar(50) NOT NULL, 
   `parent_objid` varchar(50) NOT NULL, 
   `org_objid` varchar(50) NULL,
   CONSTRAINT `pk_entity_mapping` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

-- create unique index uix_name on lob (name);
-- alter table lob add _ukey varchar(50) not null default '';
-- update lob set _ukey=objid where _ukey='';
-- create unique index uix_name on lob (name, _ukey);


DROP TABLE IF EXISTS `paymentorder`
;
CREATE TABLE `paymentorder` (
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NULL, 
   `payer_objid` varchar(50) NULL, 
   `payer_name` text NULL, 
   `paidby` text NULL, 
   `paidbyaddress` varchar(150) NULL, 
   `particulars` text NULL, 
   `amount` decimal(16,2) NULL, 
   `txntype` varchar(50) NULL, 
   `expirydate` date NULL, 
   `refid` varchar(50) NULL, 
   `refno` varchar(50) NULL, 
   `info` text NULL, 
   `txntypename` varchar(255) NULL, 
   `locationid` varchar(50) NULL, 
   `origin` varchar(50) NULL, 
   `issuedby_objid` varchar(50) NULL, 
   `issuedby_name` varchar(150) NULL, 
   `org_objid` varchar(50) NULL, 
   `org_name` varchar(255) NULL, 
   `items` text NULL, 
   `collectiontypeid` varchar(50) NULL, 
   `queueid` varchar(50) NULL,
   CONSTRAINT `pk_paymentorder` PRIMARY KEY (`objid`),
   KEY `ix_collectiontypeid` (`collectiontypeid`),
   KEY `ix_issuedby_name` (`issuedby_name`),
   KEY `ix_issuedby_objid` (`issuedby_objid`),
   KEY `ix_locationid` (`locationid`),
   KEY `ix_org_name` (`org_name`),
   KEY `ix_org_objid` (`org_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

-- CREATE UNIQUE INDEX `uix_ruleset_name` ON sys_rule (`ruleset`,`name`);
-- alter table sys_rule add _ukey varchar(50) not null default '';
-- update sys_rule set _ukey=objid where _ukey='';
-- CREATE UNIQUE INDEX `uix_ruleset_name` ON sys_rule (`ruleset`,`name`,`_ukey`);



drop table if exists sys_user_role;
drop table if exists vw_af_control_detail;
drop table if exists vw_af_inventory_summary;
drop table if exists vw_afunit;
drop table if exists vw_cashreceipt_itemaccount;
drop table if exists vw_cashreceipt_itemaccount_collectiontype;
drop table if exists vw_cashreceiptpayment_noncash;
drop table if exists vw_cashreceiptpayment_noncash_liquidated;
drop table if exists vw_collectiongroup;
drop table if exists vw_collectiontype;
drop table if exists vw_collectiontype_account;
drop table if exists vw_remittance_cashreceipt;
drop table if exists vw_remittance_cashreceipt_af;
drop table if exists vw_remittance_cashreceipt_afsummary;
drop table if exists vw_remittance_cashreceiptitem;
drop table if exists vw_remittance_cashreceiptpayment_noncash;
drop table if exists vw_remittance_cashreceiptshare;
drop table if exists vw_collectionvoucher_cashreceiptitem;
drop table if exists vw_collectionvoucher_cashreceiptshare;
drop table if exists vw_deposit_fund_transfer;
drop table if exists vw_entityindividual;
drop table if exists vw_entity_relation;
drop table if exists vw_entityindividual_lookup;
drop table if exists vw_entityrelation_lookup;
drop table if exists vw_income_ledger;
drop table if exists vw_afunit;
drop table if exists vw_income_ledger;
drop table if exists vw_account_item_mapping;
drop table if exists vw_account_income_summary;
drop table if exists vw_cashbook_cashreceipt;
drop table if exists vw_cashbook_cashreceipt_share;
drop table if exists vw_cashbook_cashreceiptvoid;
drop table if exists vw_cashbook_remittance;
drop table if exists vw_cashreceipt_itemaccount_collectiongroup;
drop table if exists vw_account_mapping;
drop table if exists vw_income_summary;
drop table if exists sys_user_role;
drop table if exists vw_account_incometarget;
drop table if exists vw_business_application_lob_retire;
drop table if exists vw_entity_mapping;
drop table if exists vw_fund;

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




-- ## 2020-04-29

update 
   af_control_detail aa, ( 
      select objid, issuedstartseries, issuedendseries, qtyissued 
      from af_control_detail d 
      where d.reftype = 'ISSUE' and d.txntype = 'COLLECTION' 
         and d.qtyreceived = 0 
   )bb 
set 
   aa.receivedstartseries = bb.issuedstartseries, aa.receivedendseries = bb.issuedendseries, aa.qtyreceived = bb.qtyissued, 
   aa.issuedstartseries = null, aa.issuedendseries = null, aa.qtyissued = 0 
where aa.objid = bb.objid 
; 

update af_control_detail set receivedstartseries = null where receivedstartseries = 0 ; 
update af_control_detail set receivedendseries = null where receivedendseries  = 0 ; 
update af_control_detail set beginstartseries = null where beginstartseries = 0 ; 
update af_control_detail set beginendseries = null where beginendseries = 0 ; 
update af_control_detail set issuedstartseries = null where issuedstartseries = 0 ; 
update af_control_detail set issuedendseries = null where issuedendseries = 0 ; 
update af_control_detail set endingstartseries = null where endingstartseries = 0 ; 
update af_control_detail set endingendseries = null where endingendseries = 0 ; 


update 
   af_control_detail aa, ( 
      select d.objid 
      from af_control_detail d 
         inner join af_control a on a.objid = d.controlid 
      where d.reftype = 'ISSUE' and d.txntype = 'COLLECTION' 
         and d.remarks = 'SALE' 
   )bb 
set aa.remarks = 'COLLECTION' 
where aa.objid = bb.objid 
;

update 
   af_control_detail aa, ( 
      select rd.objid, rd.receivedstartseries, rd.receivedendseries, rd.qtyreceived 
      from ( 
         select tt.*, (
               select objid from af_control_detail 
               where controlid = tt.controlid and reftype in ('ISSUE','MANUAL_ISSUE') 
               order by refdate, txndate, indexno limit 1 
            ) as pdetailid, (
               select objid from af_control_detail 
               where controlid = tt.controlid and refdate = tt.refdate 
                  and reftype = tt.reftype and txntype = tt.txntype and qtyreceived > 0 
               order by refdate, txndate, indexno limit 1 
            ) as cdetailid 
         from ( 
            select d.controlid, d.reftype, d.txntype, min(d.refdate) as refdate  
            from af_control_detail d 
            where d.reftype = 'remittance' and d.txntype = 'remittance' 
            group by d.controlid, d.reftype, d.txntype 
         )tt 
      )tt 
         inner join af_control_detail rd on rd.objid = tt.cdetailid 
         inner join af_control_detail pd on pd.objid = tt.pdetailid 
      where pd.refdate <> rd.refdate 
   )bb 
set 
   aa.beginstartseries = bb.receivedstartseries, aa.beginendseries = bb.receivedendseries, aa.qtybegin = bb.qtyreceived, 
   aa.receivedstartseries = null, aa.receivedendseries = null, aa.qtyreceived = 0 
where aa.objid = bb.objid 
;




-- ## 2020-05-01

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('liquidation_report_show_accountable_forms', '0', 'Show Accoutable Forms in RCD Liquidation Report ', NULL, 'TC')
;




-- ## 2020-05-04

update 
   af_control_detail aa, (
      select t2.*, (select min(receiptdate) from cashreceipt where controlid = t2.controlid) as receiptdate 
      from ( 
         select t1.* 
         from ( 
            select d.controlid, d.refdate, d.reftype, d.refid, d.objid as cdetailid, 
               (select objid from af_control_detail where controlid = d.controlid order by refdate, txndate, indexno limit 1) as firstdetailid 
            from aftxn aft 
               inner join aftxnitem afi on afi.parentid = aft.objid 
               inner join af_control_detail d on d.aftxnitemid = afi.objid 
            where aft.txntype = 'FORWARD' 
         )t1, af_control_detail d 
         where d.objid = t1.firstdetailid 
            and d.objid <> t1.cdetailid 
      )t2 
   )bb 
set aa.refdate = bb.receiptdate 
where aa.objid = bb.cdetailid 
   and bb.receiptdate is not null 
; 




-- ## 2020-05-05

alter table creditmemo change payername _payername varchar(255) null
;
-- alter table creditmemo add payer_name varchar(255) null
-- ;
-- update creditmemo set payer_name = _payername where payer_name is null 
-- ; 
-- alter table creditmemo modify payer_name varchar(255) not null
-- ;
create index ix_payer_name on creditmemo (payer_name)
;

-- alter table creditmemo add payer_address_objid varchar(50) null
-- ;
create index ix_payer_address_objid on creditmemo (payer_address_objid)
; 

-- alter table creditmemo change payeraddress _payeraddress varchar(255) null 
-- ;
-- alter table creditmemo add payer_address_text varchar(255) null 
-- ;
-- update creditmemo set payer_address_text = _payeraddress where payer_address_text is null 
-- ;




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




-- ## 2020-06-06

alter table aftxn add lockid varchar(50) null 
; 

-- alter table af_control add constraint fk_af_control_afid 
--    foreign key (afid) references af (objid) 
-- ; 

alter table af_control add constraint fk_af_control_allocid 
   foreign key (allocid) references af_allocation (objid) 
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

alter table af_control add salecost decimal(16,2) not null default '0.0'
;


insert into sys_usergroup (
   objid, title, domain, role, userclass
) values (
   'TREASURY.AFO_ADMIN', 'TREASURY AFO ADMIN', 'TREASURY', 'AFO_ADMIN', 'usergroup' 
); 

insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'TREASURY-AFO-ADMIN-aftxn-changetxntype', 'TREASURY.AFO_ADMIN', 'aftxn', 'changeTxnType', 'Change Txn Type'
); 




-- ## 2020-06-09

insert into sys_usergroup (
   objid, title, domain, role, userclass
) values (
   'TREASURY.COLLECTOR_ADMIN', 'TREASURY COLLECTOR ADMIN', 'TREASURY', 'COLLECTOR_ADMIN', 'usergroup' 
); 

insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'TREASURY-COLLECTOR-ADMIN-aftxn-changetxntype', 'TREASURY.COLLECTOR_ADMIN', 'remittance', 'rebuildFund', 'Rebuild Remittance Fund'
); 




-- ## 2020-06-10

update af_control_detail set reftype = 'ISSUE' where txntype='SALE' and reftype <> 'ISSUE' 
; 

update 
   af_control_detail aa, ( 
      select 
         (select count(*) from cashreceipt where controlid = d.controlid) as receiptcount, 
         d.objid, d.controlid, d.endingstartseries, d.endingendseries, d.qtyending 
      from af_control_detail d 
      where d.txntype='SALE' 
         and d.qtyending > 0
   )bb 
set 
   aa.issuedstartseries = bb.endingstartseries, aa.issuedendseries = bb.endingendseries, aa.qtyissued = bb.qtyending, 
   aa.endingstartseries = null, aa.endingendseries = null, aa.qtyending = 0 
where aa.objid = bb.objid 
   and bb.receiptcount = 0 
;

update 
   af_control_detail aa, ( 
      select 
         (select count(*) from cashreceipt where controlid = d.controlid) as receiptcount, 
         d.objid, d.controlid, d.endingstartseries, d.endingendseries, d.qtyending 
      from af_control_detail d 
      where d.txntype='SALE' 
         and d.qtyending > 0
   )bb 
set 
   aa.reftype = 'ISSUE', aa.txntype = 'COLLECTION', aa.remarks = 'COLLECTION' 
where aa.objid = bb.objid 
   and bb.receiptcount > 0 
;


alter table sys_usergroup_permission modify objid varchar(100) not null 
;

insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'TREASURY-COLLECTOR-ADMIN-remittance-modifyCashBreakdown', 'TREASURY.COLLECTOR_ADMIN', 'remittance', 'modifyCashBreakdown', 'Modify Remittance Cash Breakdown'
); 




-- ## 2020-06-11

update 
   af_control_detail aa, ( 
      select objid, issuedstartseries, issuedendseries, qtyissued 
      from af_control_detail 
      where txntype='sale' 
         and qtyissued > 0 
   ) bb  
set 
   aa.receivedstartseries = bb.issuedstartseries, aa.receivedendseries = bb.issuedendseries, aa.qtyreceived = bb.qtyissued, 
   aa.beginstartseries = null, aa.beginendseries = null, aa.qtybegin = 0 
where aa.objid = bb.objid 
; 


update 
   af_control aa, ( 
      select a.objid 
      from af_control a 
      where a.objid not in (
         select distinct controlid from af_control_detail where controlid = a.objid
      ) 
   )bb 
set aa.currentdetailid = null, aa.currentindexno = 0 
where aa.objid = bb.objid 
; 


update 
   af_control aa, ( 
      select d.controlid 
      from af_control_detail d, af_control a 
      where d.txntype = 'SALE' 
         and d.controlid = a.objid 
         and a.currentseries <= a.endseries 
   )bb 
set aa.currentseries = aa.endseries+1 
where aa.objid = bb.controlid 
; 


update af_control set 
   currentindexno = (select indexno from af_control_detail where objid = af_control.currentdetailid)
where currentdetailid is not null 
; 


insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'TREASURY-COLLECTOR-ADMIN-remittance-voidReceipt', 'TREASURY.COLLECTOR_ADMIN', 'remittance', 'voidReceipt', 'Void Receipt'
); 




-- ## 2020-06-12

insert into sys_usergroup (
   objid, title, domain, role, userclass
) values (
   'TREASURY.LIQ_OFFICER_ADMIN', 'TREASURY LIQ. OFFICER ADMIN', 
   'TREASURY', 'LIQ_OFFICER_ADMIN', 'usergroup' 
); 

insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'UGP-d2bb69a6769517e0c8e672fec41f5fd7', 'TREASURY.LIQ_OFFICER_ADMIN', 
   'collectionvoucher', 'changeLiqOfficer', 'Change Liquidating Officer'
); 

insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'UGP-3219ec222220f68d1f69d4d1d76021e0', 'TREASURY.LIQ_OFFICER_ADMIN', 
   'collectionvoucher', 'modifyCashBreakdown', 'Modify Cash Breakdown'
); 

insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'UGP-4e508bdd04888894926f677bbc0be374', 'TREASURY.LIQ_OFFICER_ADMIN', 
   'collectionvoucher', 'rebuildFund', 'Rebuild Fund Summary'
); 

insert into sys_usergroup_permission (
   objid, usergroup_objid, object, permission, title 
) values ( 
   'UGP-cf543fabc2aca483c6e5d3d48c39c4cc', 'TREASURY.LIQ_OFFICER_ADMIN', 
   'incomesummary', 'rebuild', 'Rebuild Income Summary'
); 


INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('RULEMGMT.DEV', 'RULEMGMT DEV', 'RULEMGMT', NULL, NULL, 'DEV');

INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('WORKFLOW.DEV', 'WORKFLOW DEV', 'WORKFLOW', NULL, NULL, 'DEV');


UPDATE sys_usergroup_member SET usergroup_objid = 'RULEMGMT.DEV' where usergroup_objid = 'RULEMGMT.MASTER' 
;
UPDATE sys_usergroup_member SET usergroup_objid = 'WORKFLOW.DEV' where usergroup_objid = 'WORKFLOW.MASTER' 
;




-- ## 2020-08-18

drop table if exists paymentorder_paid
;
drop table if exists paymentorder
;
drop table if exists paymentorder_type
;

CREATE TABLE `paymentorder_type` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(150) NULL,
  `collectiontype_objid` varchar(50) NULL,
  `queuesection` varchar(50) NULL,
  `system` int(11) NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_paymentorder_type_collectiontype` (`collectiontype_objid`),
  CONSTRAINT `paymentorder_type_ibfk_1` FOREIGN KEY (`collectiontype_objid`) REFERENCES `collectiontype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `paymentorder` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) NULL,
  `particulars` text,
  `amount` decimal(16,2) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` text,
  `locationid` varchar(50) NULL,
  `origin` varchar(50) NULL,
  `issuedby_objid` varchar(50) NULL,
  `issuedby_name` varchar(150) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(255) NULL,
  `items` text,
  `queueid` varchar(50) NULL,
  `paymentordertype_objid` varchar(50) NULL,
  `controlno` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_issuedby_name` (`issuedby_name`),
  KEY `ix_issuedby_objid` (`issuedby_objid`),
  KEY `ix_locationid` (`locationid`),
  KEY `ix_org_name` (`org_name`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_paymentordertype_objid` (`paymentordertype_objid`),
  CONSTRAINT `fk_paymentorder_paymentordertype_objid` FOREIGN KEY (`paymentordertype_objid`) REFERENCES `paymentorder_type` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `paymentorder_paid` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) NULL,
  `particulars` text,
  `amount` decimal(16,2) NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` text,
  `locationid` varchar(50) NULL,
  `origin` varchar(50) NULL,
  `issuedby_objid` varchar(50) NULL,
  `issuedby_name` varchar(150) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(255) NULL,
  `items` text,
  `paymentordertype_objid` varchar(50) NULL,
  `controlno` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_issuedby_name` (`issuedby_name`),
  KEY `ix_issuedby_objid` (`issuedby_objid`),
  KEY `ix_locationid` (`locationid`),
  KEY `ix_org_name` (`org_name`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_paymentordertype_objid` (`paymentordertype_objid`),
  CONSTRAINT `fk_paymentorder_paid_paymentordertype_objid` FOREIGN KEY (`paymentordertype_objid`) REFERENCES `paymentorder_type` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
