set @dbname := 'etracs255_loay';



/*==================================
** V2.5.04.030
==================================*/
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER-SUMMARY', 'landassessment', 'After Summary Computation', '105');
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER-SUMMARY', 'bldgassessment', 'After Summary Computation', '105');
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER-SUMMARY', 'machassessment', 'After Summary Computation', '105');
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER-SUMMARY', 'miscassessment', 'After Summary Computation', '105');
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER-SUMMARY', 'planttreeassessment', 'After Summary Computation', '105');
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('MUASSESSLEVEL', 'machassessment', 'Actual Use Assess Level Computation', '50');
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('MUASSESSEDVALUE', 'machassessment', 'Actual Use Assessed Value Computation', '55');

UPDATE sys_rulegroup SET name='INITIAL', ruleset='machassessment', title='Initial Computation', sortorder='0' WHERE (name='INITIAL') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='BASEMARKETVALUE', ruleset='machassessment', title='Machine Base Market Value Computation', sortorder='5' WHERE (name='BASEMARKETVALUE') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='AFTER-BASEMARKETVALUE', ruleset='machassessment', title='After Machine Base Market Value Computation', sortorder='10' WHERE (name='AFTER-BASEMARKETVALUE') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='DEPRECIATION', ruleset='machassessment', title='Machine Depreciation Computation', sortorder='11' WHERE (name='DEPRECIATION') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='AFTER-DEPRECIATION', ruleset='machassessment', title='After Machine Depreciation Computation', sortorder='12' WHERE (name='AFTER-DEPRECIATION') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='MARKETVALUE', ruleset='machassessment', title='Machine Market Value Computation', sortorder='25' WHERE (name='MARKETVALUE') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='AFTER-MARKETVALUE', ruleset='machassessment', title='After Machine Market Value Computation', sortorder='30' WHERE (name='AFTER-MARKETVALUE') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='ASSESSLEVEL', ruleset='machassessment', title='Machine Assess Level Computation', sortorder='35' WHERE (name='ASSESSLEVEL') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='AFTER-ASSESSLEVEL', ruleset='machassessment', title='After Machine Assess Level Computation', sortorder='36' WHERE (name='AFTER-ASSESSLEVEL') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='ASSESSEDVALUE', ruleset='machassessment', title='Machine Assessed Value Computation', sortorder='40' WHERE (name='ASSESSEDVALUE') AND (ruleset='machassessment');
UPDATE sys_rulegroup SET name='AFTER-ASSESSEDVALUE', ruleset='machassessment', title='After Machine Assessed Value Computation', sortorder='45' WHERE (name='AFTER-ASSESSEDVALUE') AND (ruleset='machassessment');


alter table rpt_redflag add info text;

alter table bldguse add addlinfo varchar(255);


alter table faas_signatory 
	add provrecommender_objid	varchar(50),
	add provrecommender_name	varchar(100),
	add provrecommender_title	varchar(50),
	add provrecommender_dtsigned	datetime,
	add provrecommender_taskid	varchar(50);

	
alter table subdividedland modify column itemno	varchar(10)	null;
alter table subdividedland modify column newtdno	varchar(50)	null;
alter table subdividedland modify column newutdno	varchar(50)	null;
alter table subdividedland modify column newtitletype	varchar(50)	null;
alter table subdividedland modify column newtitleno	varchar(50)	null;
alter table subdividedland modify column newtitledate	varchar(50)	null;
alter table subdividedland modify column areasqm	decimal(16,6)	null;
alter table subdividedland modify column areaha	decimal(16,6)	null;
alter table subdividedland modify column memoranda	varchar(500)	null;
alter table subdividedland modify column administrator_objid	varchar(50)	null;
alter table subdividedland modify column administrator_name	varchar(200)	null;
alter table subdividedland modify column administrator_address	varchar(200)	null;
alter table subdividedland modify column taxpayer_objid	varchar(50)	null;
alter table subdividedland modify column taxpayer_name	varchar(200)	null;
alter table subdividedland modify column taxpayer_address	varchar(200)	null;
alter table subdividedland modify column owner_name	varchar(200)	null;
alter table subdividedland modify column owner_address	varchar(200)	null;
alter table subdividedland modify column newrpuid	varchar(50)	null;
alter table subdividedland modify column newfaasid	varchar(50)	null;



alter table consolidation modify column txndate	datetime null;
alter table consolidation modify column txntype_objid	varchar(50) null;
alter table consolidation modify column autonumber	int(11) null;
alter table consolidation modify column effectivityyear	int(11) null;
alter table consolidation modify column effectivityqtr	int(11) null;
alter table consolidation modify column newtdno	varchar(50) null;
alter table consolidation modify column newutdno	varchar(50) null;
alter table consolidation modify column newtitletype	varchar(50) null;
alter table consolidation modify column newtitleno	varchar(50) null;
alter table consolidation modify column newtitledate	varchar(50) null;
alter table consolidation modify column memoranda	text null;
alter table consolidation modify column lguid	varchar(50) null;
alter table consolidation modify column lgutype	varchar(50) null;
alter table consolidation modify column newrpid	varchar(50) null;
alter table consolidation modify column newrpuid	varchar(50) null;
alter table consolidation modify column newfaasid	varchar(50) null;
alter table consolidation modify column taxpayer_objid	varchar(50) null;
alter table consolidation modify column taxpayer_name	text null;
alter table consolidation modify column taxpayer_address	varchar(200) null;
alter table consolidation modify column owner_name	text null;
alter table consolidation modify column owner_address	varchar(200) null;
alter table consolidation modify column administrator_objid	varchar(50) null;
alter table consolidation modify column administrator_name	varchar(500) null;
alter table consolidation modify column administrator_address	varchar(200) null;
alter table consolidation modify column administratorid	varchar(50) null;
alter table consolidation modify column administratorname	varchar(500) null;
alter table consolidation modify column administratoraddress	varchar(200) null;
alter table consolidation modify column signatories	varchar(500) null;
alter table consolidation modify column originlguid	varchar(50) null;



/* v2.5.04.030b */

alter table rptledger
  modify column firstqtrpaidontime int null,
  modify column qtrlypaymentavailed int null,
  modify column qtrlypaymentpaidontime int null,
  modify column lastitemyear int null,
  modify column lastreceiptid varchar(50) null,
  modify column advancebill int null,
  modify column lastbilledyear int null,
  modify column lastbilledqtr int null,
  modify column partialbasic decimal(16,2) null,
  modify column partialbasicint decimal(16,2) null,
  modify column partialbasicdisc decimal(16,2) null,
  modify column partialsef decimal(16,2) null,
  modify column partialsefint decimal(16,2) null,
  modify column partialsefdisc decimal(16,2) null,
  modify column partialledyear int null,
  modify column partialledqtr int null,
  add updateflag varchar(50),
  add forcerecalcbill int;


update rptledger set nextbilldate = null, forcerecalcbill = 1, updateflag = objid where forcerecalcbill is null;


alter table rptledgeritem
  add basic decimal(16,2) null,
  add basicpaid decimal(16,2) null,
  add basicint  decimal(16,2) null,
  add basicintpaid  decimal(16,2) null,
  add basicdisc decimal(16,2) null,
  add basicdisctaken  decimal(16,2) null,
  add basicidle decimal(16,2) null,
  add basicidlepaid decimal(16,2) null,
  add basicidledisc decimal(16,2) null,
  add basicidledisctaken  decimal(16,2) null,
  add basicidleint  decimal(16,2) null,
  add basicidleintpaid  decimal(16,2) null,
  add sef decimal(16,2) null,
  add sefpaid decimal(16,2) null,
  add sefint  decimal(16,2) null,
  add sefintpaid  decimal(16,2) null,
  add sefdisc decimal(16,2) null,
  add sefdisctaken  decimal(16,2) null,
  add firecode  decimal(16,2) null,
  add firecodepaid  decimal(16,2) null,
  add revperiod varchar(50) null,
  add qtrly int(11) null,
  add fullypaid int(11) null;


update rptledgeritem set 
  fullypaid = paid,
  basic = 0.0,
  basicpaid = 0.0,
  basicint = 0.0,
  basicintpaid = 0.0,
  basicdisc = 0.0,
  basicdisctaken = 0.0,
  basicidle = 0.0,
  basicidlepaid = 0.0,
  basicidledisc = 0.0,
  basicidledisctaken = 0.0,
  basicidleint = 0.0,
  basicidleintpaid = 0.0,
  sef = 0.0,
  sefpaid = 0.0,
  sefint = 0.0,
  sefintpaid = 0.0,
  sefdisc = 0.0,
  sefdisctaken = 0.0,
  firecode = 0.0,
  firecodepaid = 0.0
where basic is null;



alter table rptledgeritem
  drop column paidqtr,
  drop column paid;



  
create table rptledgeritem_qtrly (
  objid varchar(50) not null,
  parentid varchar(50) not null,
  rptledgerid varchar(50) not null,
  basicav decimal(16,2) not null,
  sefav decimal(16,2) not null,
  av decimal(16,2) not null,
  year int(11) not null,
  qtr int(11) not null,
  basic decimal(16,2) not null,
  basicpaid decimal(16,2) not null,
  basicint decimal(16,2) not null,
  basicintpaid decimal(16,2) not null,
  basicdisc decimal(16,2) not null,
  basicdisctaken decimal(16,2) not null,
  basicidle decimal(16,2) not null,
  basicidlepaid decimal(16,2) not null,
  basicidledisc decimal(16,2) not null,
  basicidledisctaken decimal(16,2) not null,
  basicidleint decimal(16,2) not null,
  basicidleintpaid decimal(16,2) not null,
  sef decimal(16,2) not null,
  sefpaid decimal(16,2) not null,
  sefint decimal(16,2) not null,
  sefintpaid decimal(16,2) not null,
  sefdisc decimal(16,2) not null,
  sefdisctaken decimal(16,2) not null,
  firecode decimal(16,2) not null,
  firecodepaid decimal(16,2) not null,
  revperiod varchar(50) default null,
  partialled int(11) not null,
  fullypaid int(11) not null,
  primary key  (objid),
  key FK_rptledgeritemqtrly_rptledgeritem (parentid),
  key FK_rptledgeritemqtrly_rptledger (rptledgerid),
  key ix_rptledgeritemqtrly_year (year),
  constraint FK_rptledgeritemqtrly_rptledger foreign key (rptledgerid) references rptledger (objid),
  constraint FK_rptledgeritemqtrly_rptledgeritem foreign key (parentid) references rptledgeritem (objid)
) engine=innodb  DEFAULT CHARSET=utf8;



alter table cashreceiptitem_rpt_online 
  add rptledgeritemqtrlyid varchar(50);

alter table cashreceiptitem_rpt_online 
  add constraint FK_cashreceiptitem_rpt_online_rptledgeritemqtrly foreign key(rptledgeritemqtrlyid)
  references rptledgeritem_qtrly(objid);



set foreign_key_checks = 0;

DROP TABLE rptbill_ledger_account;
DROP TABLE rptbill_ledger_item;
DROP TABLE rptbill_ledger;

CREATE TABLE rptbill_ledger (
  rptledgerid varchar(50) NOT NULL default '',
  billid varchar(50) NOT NULL default '',
  updateflag varchar(50),
  PRIMARY KEY  (rptledgerid,billid),
  KEY rptbillid (billid),
  KEY rptledgerid (rptledgerid),
  CONSTRAINT FK_rptbillledger_rptledger FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid),
  CONSTRAINT FK_rptbillledger_rptbill FOREIGN KEY (billid) REFERENCES rptbill(objid)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


CREATE TABLE rptbill_ledger_account (
  objid varchar(50) NOT NULL,
  billid varchar(50) NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  revperiod varchar(25) NOT NULL,
  revtype varchar(25) NOT NULL,
  item_objid varchar(50) NOT NULL,
  amount decimal(16,4) NOT NULL,
  sharetype varchar(25) NOT NULL,
  discount decimal(16,4) default NULL,
  PRIMARY KEY  (objid),
  KEY ix_rptbill_ledger_account_rptledger (rptledgerid),
  KEY ix_rptbillledgeraccount_revenueitem (item_objid),
  KEY FK_rptbillledgeraccount_rptbill (billid),
  CONSTRAINT FK_rptbillledgeraccount_rptbill FOREIGN KEY (billid) REFERENCES rptbill (objid),
  CONSTRAINT rptbill_ledger_account_ibfk_1 FOREIGN KEY (item_objid) REFERENCES itemaccount (objid),
  CONSTRAINT rptbill_ledger_account_ibfk_2 FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE rptbill_ledger_item (
  objid varchar(75) NOT NULL,
  billid varchar(50) NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  rptledgeritemid varchar(50) NULL,
  rptledgeritemqtrlyid varchar(50) NULL,
  rptledgerfaasid varchar(50) NOT NULL,
  av decimal(16,2) default NULL,
  basicav decimal(16,2) default NULL,
  sefav decimal(16,2) default NULL,
  year int(11) NOT NULL,
  qtr int(11) NOT NULL,
  basic decimal(16,2) NOT NULL,
  basicint decimal(16,2) NOT NULL,
  basicdisc decimal(16,2) NOT NULL,
  sef decimal(16,2) NOT NULL,
  sefint decimal(16,2) NOT NULL,
  sefdisc decimal(16,2) NOT NULL,
  firecode decimal(10,2) default NULL,
  revperiod varchar(25) default NULL,
  basicnet decimal(16,2) default NULL,
  sefnet decimal(16,2) default NULL,
  total decimal(16,2) default NULL,
  partialled int(11) NOT NULL,
  basicidle decimal(16,2) default NULL,
  basicidledisc decimal(16,2) default NULL,
  basicidleint decimal(16,2) default NULL,
  taxdifference int(11) default NULL,
  PRIMARY KEY  (objid),
  KEY FK_rptbillledgeritem_rptledger (rptledgerid),
  KEY FK_rptbillledgeritem_rptledgerfaas (rptledgerfaasid),
  KEY FK_rptbillledgeritem_rptledgeritem (rptledgeritemid),
  KEY FK_rptbillledgeritem_rptledgeritemqtrly (rptledgeritemqtrlyid),
  KEY FK_rptbillledgeritem_rptbill (billid),
  CONSTRAINT FK_rptbillledgeritem_rptbill FOREIGN KEY (billid) REFERENCES rptbill (objid),
  CONSTRAINT FK_rptbillledgeritem_rptledger FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid),
  CONSTRAINT FK_rptbillledgeritem_rptledgerfaas FOREIGN KEY (rptledgerfaasid) REFERENCES rptledgerfaas (objid),
  CONSTRAINT FK_rptbillledgeritem_rptledgeritem FOREIGN KEY (rptledgeritemid) REFERENCES rptledgeritem(objid),
  CONSTRAINT FK_rptbillledgeritem_rptledgeritemqtrly FOREIGN KEY (rptledgeritemqtrlyid) REFERENCES rptledgeritem_qtrly (objid)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


set foreign_key_checks = 1;



/*

delete from sys_rule_deployed where objid in (
  select objid from sys_rule where name = 'SPLIT_ADVANCE_PARTIALLED'
);

update sys_rule set state = 'DRAFT' where name = 'SPLIT_ADVANCE_PARTIALLED';


*/



INSERT INTO sys_usergroup_permission (objid, usergroup_objid, object, permission, title) VALUES ('LANDTAX.ADMIN-add_new_ledger_faas', 'LANDTAX.ADMIN', 'rptledger', 'add_new_ledger_faas', 'Add New Ledger FAAS');
INSERT INTO sys_usergroup_permission (objid, usergroup_objid, object, permission, title) VALUES ('LANDTAX.ADMIN-change_faas_reference', 'LANDTAX.ADMIN', 'rptledger', 'change_faas_reference', 'Change FAAS Reference');
INSERT INTO sys_usergroup_permission (objid, usergroup_objid, object, permission, title) VALUES ('LANDTAX.ADMIN-fix_ledger_faas', 'LANDTAX.ADMIN', 'rptledger', 'fix_ledger_faas', 'Fix Ledger FAAS');

/* v2504031 */

/* CONSOLIDATOIN / SUBDIVISION SUPPORT */

drop table if exists subdivision_consolidatedland;

drop table if exists subdivision_motherland;


CREATE TABLE subdivision_motherland (
  objid varchar(50) NOT NULL,
  subdivisionid varchar(50) NOT NULL,
  landfaasid varchar(50) NOT NULL,
  rpuid varchar(50) NOT NULL,
  rpid varchar(50) NOT NULL,
  PRIMARY KEY  (objid),
  KEY FK_consolidatedland_faas (landfaasid),
  KEY FK_consolidatedland_subdivision (subdivisionid),
  CONSTRAINT subdivision_motherland_ibfk_2 FOREIGN KEY (landfaasid) REFERENCES faas (objid),
  CONSTRAINT subdivison_motherland_ibfk_1 FOREIGN KEY (subdivisionid) REFERENCES subdivision (objid)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


alter table subdivision modify column motherfaasid varchar(50) null;


alter table faas modify column prevav text null,
  modify column prevmv text null,
  modify column prevareaha text null,
  modify column prevareasqm text null;



insert  into subdivision_motherland(
  objid,
  subdivisionid,
  landfaasid,
  rpuid,
  rpid
)
select 
  s.objid,
  s.objid as subdivisionid,
  s.motherfaasid as landfaasid,
  f.rpuid,
  f.realpropertyid as rpid
from subdivision s 
  inner join faas f on s.motherfaasid = f.objid;

  
ALTER TABLE subdivision DROP foreign key subdivision_ibfk_1;

/* v2.5.04.032 */
INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `checkbalance`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`) VALUES ('CA', 'Change Administrator', '0', '0', '0', 'DP', '0', '1', '0', '0', '1', NULL);


CREATE TABLE `cancelledfaas_task` (
  `objid` varchar(50) character set utf8 NOT NULL default '',
  `refid` varchar(50) character set utf8 default NULL,
  `parentprocessid` varchar(50) character set utf8 default NULL,
  `state` varchar(50) character set utf8 default NULL,
  `startdate` datetime default NULL,
  `enddate` datetime default NULL,
  `assignee_objid` varchar(50) character set utf8 default NULL,
  `assignee_name` varchar(100) character set utf8 default NULL,
  `assignee_title` varchar(80) default NULL,
  `actor_objid` varchar(50) character set utf8 default NULL,
  `actor_name` varchar(100) character set utf8 default NULL,
  `actor_title` varchar(80) default NULL,
  `message` varchar(255) default NULL,
  `signature` text,
  PRIMARY KEY  (`objid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table `cancelledfaas_task` 
  add CONSTRAINT `FK_cancelledfaas_task_cancelledfaas` 
	FOREIGN KEY (`refid`) REFERENCES `cancelledfaas` (`objid`);


create table `cancelledfaas_signatory` (
  `objid` varchar(50) not null,
  `taxmapper_objid` varchar(50) default null,
  `taxmapper_name` varchar(100) default null,
  `taxmapper_title` varchar(50) default null,
  `taxmapper_dtsigned` datetime default null,
  `taxmapper_taskid` varchar(50) default null,
  `taxmapperchief_objid` varchar(50) default null,
  `taxmapperchief_name` varchar(100) default null,
  `taxmapperchief_title` varchar(50) default null,
  `taxmapperchief_dtsigned` datetime default null,
  `taxmapperchief_taskid` varchar(50) default null,
  `appraiser_objid` varchar(50) default null,
  `appraiser_name` varchar(150) default null,
  `appraiser_title` varchar(50) default null,
  `appraiser_dtsigned` datetime default null,
  `appraiser_taskid` varchar(50) default null,
  `appraiserchief_objid` varchar(50) default null,
  `appraiserchief_name` varchar(100) default null,
  `appraiserchief_title` varchar(50) default null,
  `appraiserchief_dtsigned` datetime default null,
  `appraiserchief_taskid` varchar(50) default null,
  `recommender_objid` varchar(50) default null,
  `recommender_name` varchar(100) default null,
  `recommender_title` varchar(50) default null,
  `recommender_dtsigned` datetime default null,
  `recommender_taskid` varchar(50) default null,
  `provtaxmapper_objid` varchar(50) default null,
  `provtaxmapper_name` varchar(100) default null,
  `provtaxmapper_title` varchar(50) default null,
  `provtaxmapper_dtsigned` datetime default null,
  `provtaxmapper_taskid` varchar(50) default null,
  `provtaxmapperchief_objid` varchar(50) default null,
  `provtaxmapperchief_name` varchar(100) default null,
  `provtaxmapperchief_title` varchar(50) default null,
  `provtaxmapperchief_dtsigned` datetime default null,
  `provtaxmapperchief_taskid` varchar(50) default null,
  `provappraiser_objid` varchar(50) default null,
  `provappraiser_name` varchar(100) default null,
  `provappraiser_title` varchar(50) default null,
  `provappraiser_dtsigned` datetime default null,
  `provappraiser_taskid` varchar(50) default null,
  `provappraiserchief_objid` varchar(50) default null,
  `provappraiserchief_name` varchar(100) default null,
  `provappraiserchief_title` varchar(50) default null,
  `provappraiserchief_dtsigned` datetime default null,
  `provappraiserchief_taskid` varchar(50) default null,
  `approver_objid` varchar(50) default null,
  `approver_name` varchar(100) default null,
  `approver_title` varchar(50) default null,
  `approver_dtsigned` datetime default null,
  `approver_taskid` varchar(50) default null,
  `provapprover_objid` varchar(50) default null,
  `provapprover_name` varchar(100) default null,
  `provapprover_title` varchar(50) default null,
  `provapprover_dtsigned` datetime default null,
  `provapprover_taskid` varchar(50) default null,
  `provrecommender_objid` varchar(50) default null,
  `provrecommender_name` varchar(100) default null,
  `provrecommender_title` varchar(50) default null,
  `provrecommender_dtsigned` datetime default null,
  `provrecommender_taskid` varchar(50) default null,
  primary key  (`objid`)
) engine=innodb default charset=utf8;


alter table cancelledfaas_signatory 
  add constraint `FK_cancelledfaas_signatory_cancelled_faas` 
  foreign key (`objid`) references `cancelledfaas` (`objid`);


alter table cancelledfaas modify column reason_objid varchar(50) null;
alter table cancelledfaas modify column remarks text null;

alter table cancelledfaas add `online` int null;
update cancelledfaas set `online` = 0 where `online` is null;

alter table cancelledfaas add lguid varchar(50);
alter table cancelledfaas add lasttaxyear int;
 

delete from sys_wf_transition where processname = 'cancelledfaas';
delete from sys_wf_node where processname = 'cancelledfaas';

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('start', 'cancelledfaas', 'Start', 'start', '1', NULL, 'RPT', NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-receiver', 'cancelledfaas', 'Assign Receiver', 'state', '2', '0', 'RPT', 'RECEIVER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('receiver', 'cancelledfaas', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-examiner', 'cancelledfaas', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('examiner', 'cancelledfaas', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-taxmapper', 'cancelledfaas', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('taxmapper', 'cancelledfaas', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-provtaxmapperchief', 'cancelledfaas', 'For Taxmapping Approval', 'state', '25', '0', 'RPT', 'TAXMAPPER_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-taxmapping-approval', 'cancelledfaas', 'For Taxmapper Chief Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('provtaxmapperchief', 'cancelledfaas', 'Taxmapping Chief Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('taxmapper_chief', 'cancelledfaas', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-appraiser', 'cancelledfaas', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('appraiser', 'cancelledfaas', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-appraisal-chief', 'cancelledfaas', 'For Appraisal Chief Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('appraiser_chief', 'cancelledfaas', 'Appraisal Chief Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('provappraiserchief', 'cancelledfaas', 'Appraisal Chief Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-recommender', 'cancelledfaas', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-provrecommender', 'cancelledfaas', 'For Recommending Approval', 'state', '71', NULL, 'RPT', 'RECOMMENDER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('recommender', 'cancelledfaas', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('provrecommender', 'cancelledfaas', 'Recommending Approval', 'state', '76', NULL, 'RPT', 'RECOMMENDER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-approver', 'cancelledfaas', 'For Assessor Approval', 'state', '80', NULL, 'RPT', 'APPROVER,ASSESSOR');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('approver', 'cancelledfaas', 'Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-provtaxmapper', 'cancelledfaas', 'For Taxmapping', 'state', '200', '0', 'RPT', 'TAXMAPPER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-provappraiserchief', 'cancelledfaas', 'For Appraisal Chief Approval', 'state', '201', '0', 'RPT', 'APPRAISAL_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('provtaxmapper', 'cancelledfaas', 'Taxmapping', 'state', '205', '0', 'RPT', 'TAXMAPPER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-provappraiser', 'cancelledfaas', 'For Appraisal', 'state', '210', '0', 'RPT', 'APPRAISER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('provappraiser', 'cancelledfaas', 'Appraisal', 'state', '215', '0', 'RPT', 'APPRAISER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-provapprover', 'cancelledfaas', 'For Provincial Assessor Approval', 'state', '220', '0', 'RPT', 'APPROVER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('provapprover', 'cancelledfaas', 'Provincial Assessor Approval', 'state', '230', NULL, 'RPT', 'APPROVER,ASSESSOR');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('end', 'cancelledfaas', 'End', 'end', '1000', NULL, 'RPT', NULL);

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('start', 'cancelledfaas', NULL, 'receiver', '1', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'cancelledfaas', 'delete', 'end', '5', NULL, '[caption:\'Delete\', confirm:\'Delete record?\', closeonend:true]', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'cancelledfaas', 'submit', 'assign-taxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit for taxmapping?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-taxmapper', 'cancelledfaas', NULL, 'taxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'cancelledfaas', 'return_receiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'cancelledfaas', 'submit', 'assign-recommender', '27', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-recommender', 'cancelledfaas', NULL, 'recommender', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'return_appraiser', 'appraiser', '72', NULL, '[caption:\'Return to Appraiser\',confirm:\'Return to appraiser?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'return_taxmapper', 'taxmapper', '73', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'submit_approver', 'assign-approver', '74', NULL, '[caption:\'Submit for Assessor Approval\', confirm:\'Submit to assessor approval?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'submit_to_province', 'approver', '75', NULL, '[caption:\'Submit to Province\', confirm:\'Submit to Province?\', messagehandler:\'rptmessage:create\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('approver', 'cancelledfaas', 'approve', 'end', '110', NULL, '[caption:\'Manually Approve\',confirm:\'Manually approve cancellation?\', visible:false]', NULL);




alter table subdivision add mothertdnos varchar(1000);
alter table subdivision add motherpins varchar(1000);


create index ix_subdivision_mothertdnos on subdivision(mothertdnos);
create index ix_subdivision_motherpins on subdivision(motherpins);

update subdivision s, subdivision_motherland sm, faas f  set 
	s.mothertdnos = f.tdno,
	s.motherpins = f.fullpin
where s.objid = sm.subdivisionid
  and sm.landfaasid = f.objid 
  and  1 = (select count(*) from subdivision_motherland 
			      where subdivisionid = s.objid );




alter table rptledger add administrator_name varchar(150);			      	
			      	
update rptledger rl, faas f set 
	rl.administrator_name = f.administrator_name
where rl.faasid = f.objid;

/* v2.5.04.032 */
INSERT IGNORE INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `checkbalance`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`) VALUES ('CA', 'Change Administrator', '0', '0', '0', 'DP', '0', '1', '0', '0', '1', NULL);



update subdivision s, subdivision_motherland sm, faas f  set 
	s.mothertdnos = f.tdno,
	s.motherpins = f.fullpin
where s.objid = sm.subdivisionid
  and sm.landfaasid = f.objid 
  and  1 = (select count(*) from subdivision_motherland 
			      where subdivisionid = s.objid );


    	
			      	
update rptledger rl, faas f set 
	rl.administrator_name = f.administrator_name
where rl.faasid = f.objid;



/* v2.5.04.032-03001 */
alter table cancelledfaas modify column `remarks` text null;

/* v2.5.04.032-03004 */
create table faas_list(
	objid varchar(50) primary key, 
	state varchar(30) not null, 
	rpuid varchar(50) not null, 
	realpropertyid varchar(50) not null, 
	datacapture int not null,
	ry int not null, 
	txntype_objid varchar(50) not null, 
	tdno varchar(25), 
	utdno varchar(25) not null, 
	prevtdno text, 
	displaypin varchar(35) not null, 
	pin varchar(35) not null, 
	taxpayer_objid varchar(50) , 
	owner_name text , 
	owner_address varchar(150) , 
	administrator_name varchar(150), 
	administrator_address varchar(150), 
	rputype varchar(10) not null, 
	barangayid varchar(50) not null, 
	barangay varchar(75) not null, 
	classification_objid varchar(50) , 
	classcode varchar(20), 
	cadastrallotno text, 
	blockno varchar(100), 
	surveyno varchar(255), 
	titleno varchar(50), 
	totalareaha decimal(16,6) not null , 
	totalareasqm decimal(16,6) not null, 
	totalmv decimal(16,2) not null, 
	totalav decimal(16,2) not null, 
	effectivityyear int not null, 
	effectivityqtr int not null, 
	cancelreason varchar(15), 
	cancelledbytdnos text, 
	lguid varchar(50) not null, 
	originlguid varchar(50) not null, 
	yearissued int,
	taskid varchar(50),
	taskstate varchar(50),
	assignee_objid varchar(50),
	trackingno varchar(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index ix_faaslist_state on faas_list(state);
create index ix_faaslist_rpuid on faas_list(rpuid);
create index ix_faaslist_realpropertyid on faas_list(realpropertyid);
create index ix_faaslist_ry on faas_list(ry);
create index ix_faaslist_tdno on faas_list(tdno);
create index ix_faaslist_utdno on faas_list(utdno);
create index ix_faaslist_prevtdno on faas_list(prevtdno(500));
create index ix_faaslist_pin on faas_list(pin);
create index ix_faaslist_taxpayer_objid on faas_list(taxpayer_objid);
create index ix_faaslist_owner_name on faas_list(owner_name(100));
create index ix_faaslist_administrator_name on faas_list(administrator_name(100));
create index ix_faaslist_rputype on faas_list(rputype);
create index ix_faaslist_barangayid on faas_list(barangayid);
create index ix_faaslist_barangay on faas_list(barangay);
create index ix_faaslist_classification_objid on faas_list(classification_objid);
create index ix_faaslist_classcode on faas_list(classcode);
create index ix_faaslist_cadastrallotno on faas_list(cadastrallotno(255));
create index ix_faaslist_blockno on faas_list(blockno);
create index ix_faaslist_surveyno on faas_list(surveyno);
create index ix_faaslist_titleno on faas_list(titleno);
create index ix_faaslist_lguid on faas_list(lguid);
create index ix_faaslist_originlguid on faas_list(originlguid);
create index ix_faaslist_taskstate on faas_list(taskstate);
create index ix_faaslist_trackingno on faas_list(trackingno);
create index ix_faaslist_assigneeid on faas_list(assignee_objid);



alter table realproperty 
	drop index ix_realproperty_brgysection,
	drop index ix_realproperty_brgystate;


insert into faas_list(
	objid,
	state,
	datacapture,
	rpuid,
	realpropertyid,
	ry,
	txntype_objid,
	tdno,
	utdno,
	prevtdno,
	displaypin,
	pin,
	taxpayer_objid,
	owner_name,
	owner_address,
	administrator_name,
	administrator_address,
	rputype,
	barangayid,
	barangay,
	classification_objid,
	classcode,
	cadastrallotno,
	blockno,
	surveyno,
	titleno,
	totalareaha,
	totalareasqm,
	totalmv,
	totalav,
	effectivityyear,
	effectivityqtr,
	cancelreason,
	cancelledbytdnos,
	lguid,
	originlguid,
	yearissued,
	taskid,
	taskstate,
	assignee_objid,
	trackingno
)
select 
	f.objid,
	f.state,
	f.datacapture, 
	f.rpuid,
	f.realpropertyid,
	r.ry,
	f.txntype_objid,
	f.tdno,
	f.utdno,
	f.prevtdno,
	f.fullpin as displaypin,
	case when r.rputype = 'land' then rp.pin else concat(rp.pin, '-', r.suffix) end as pin,
	f.taxpayer_objid,
	f.owner_name,
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	r.rputype,
	rp.barangayid,
	(select name from barangay where objid = rp.barangayid) as barangay,
	r.classification_objid,
	pc.code as classcode,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	f.titleno,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	f.effectivityyear,
	f.effectivityqtr,
	f.cancelreason,
	f.cancelledbytdnos,
	f.lguid,
	f.originlguid,
	f.year as yearissued,
	(select objid from faas_task where refid = f.objid and enddate is null limit 1) as taskid,
	(select state from faas_task where refid = f.objid and enddate is null limit 1) as taskstate,
	(select assignee_objid from faas_task where refid = f.objid and enddate is null limit 1) as assignee_objid,
	(select trackingno from rpttracking where objid = f.objid) as trackingno
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid 
where not exists(select * from faas_list where objid = f.objid);



		
    /* v2.5.04.032-03005 */

alter table rpt_changeinfo add refid varchar(50);

update rpt_changeinfo set refid = faasid where refid is null;
	


/* LEDGER RESTRICTION SUPPORT */
create table rptledger_restriction
(
	objid varchar(50) not null,
	parentid varchar(50) not null, 
	restrictionid varchar(50) not null,
	remarks varchar(150),
	primary key (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table rptledger_restriction 
	add constraint FK_rptledger_restriction_rptledger 
	foreign key(parentid) references rptledger(objid);

create unique index ux_rptledger_restriction on rptledger_restriction(parentid, restrictionid);


	
  /* v2.5.04.032-03006 */
alter table cancelledfaas add txnno varchar(25) null;
create index ix_cancelledfaas_txnno on cancelledfaas(txnno);


delete from sys_wf_transition where processname = 'cancelledfaas';
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('start', 'cancelledfaas', NULL, 'receiver', '1', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'cancelledfaas', 'delete', 'end', '5', NULL, '[caption:\'Delete\', confirm:\'Delete record?\', closeonend:true]', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'cancelledfaas', 'submit', 'assign-taxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit for taxmapping?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-taxmapper', 'cancelledfaas', NULL, 'taxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'cancelledfaas', 'return_receiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'cancelledfaas', 'submit', 'assign-recommender', '27', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-recommender', 'cancelledfaas', NULL, 'recommender', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'return_appraiser', 'appraiser', '72', NULL, '[caption:\'Return to Appraiser\',confirm:\'Return to appraiser?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'return_taxmapper', 'taxmapper', '73', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'submit_approver', 'assign-approver', '74', NULL, '[caption:\'Submit for Assessor Approval\', confirm:\'Submit to assessor approval?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'submit_to_province', 'approver', '75', NULL, '[caption:\'Submit to Province\', confirm:\'Submit to Province?\', messagehandler:\'rptmessage:create\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-approver', 'cancelledfaas', NULL, 'approver', '80', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('approver', 'cancelledfaas', 'approve', 'end', '110', NULL, '[caption:\'Manually Approve\',confirm:\'Manually approve cancellation?\', visible:false]', NULL);


update faas_list fl, faas f, rpu r, propertyclassification pc, realproperty rp, barangay b set 
	fl.state = f.state,
	fl.tdno = f.tdno,
	fl.utdno = f.utdno, 
	fl.prevtdno = f.prevtdno, 
	fl.displaypin = f.fullpin, 
	fl.pin = case when r.suffix = 0 then rp.pin else concat(rp.pin, '-', r.suffix) end, 
	fl.taxpayer_objid = f.taxpayer_objid,
	fl.owner_name = f.owner_name,
	fl.owner_address = f.taxpayer_objid,
	fl.administrator_name = f.administrator_name,
	fl.administrator_address = f.administrator_address,
	fl.barangayid = b.objid, 
	fl.barangay = b.name, 
	fl.classification_objid = r.classification_objid,
	fl.classcode = pc.code, 
	fl.cadastrallotno = rp.cadastrallotno, 
	fl.blockno = rp.blockno,
	fl.surveyno = rp.surveyno,
	fl.titleno = f.titleno,
	fl.totalareaha = r.totalareaha,
	fl.totalareasqm = r.totalareasqm,
	fl.totalmv = r.totalmv,
	fl.totalav = r.totalav,
	fl.effectivityyear = f.effectivityyear,
	fl.effectivityqtr = f.effectivityqtr,
	fl.cancelreason = f.cancelreason,
	fl.cancelledbytdnos = f.cancelledbytdnos,
	fl.taskid = (select objid from faas_task where refid = f.objid and enddate is null limit 1) ,
	fl.taskstate = (select state from faas_task where refid = f.objid and enddate is null limit 1) ,
	fl.assignee_objid = (select assignee_objid from faas_task where refid = f.objid and enddate is null limit 1) ,
	fl.trackingno = (select trackingno from rpttracking where objid = f.objid) 
where fl.objid = f.objid 
and f.rpuid = r.objid 
and f.realpropertyid = rp.objid 
and rp.barangayid = b.objid 
and r.classification_objid = pc.objid;




/* PUBLIC LAND */

alter table landrpu add publicland int; 
update landrpu set publicland = 0 where publicland = null;

alter table faas_list add publicland int;
update faas_list set publicland =0 where publicland = null;

create index ix_faaslist_publicland on faas_list(publicland);

	
  /* v2.5.04.032-03007 */
alter table subdivisionaffectedrpu modify column prevfaasid varchar(50) null;
alter table subdivisionaffectedrpu modify column prevtdno varchar(50) null;
alter table subdivisionaffectedrpu modify column prevpin varchar(50) null;


/*===========================================*/
/* SUBDIVISION - CANCEL IMPROVEMENTS SUPPORT */
/*===========================================*/
create table subdivision_cancelledimprovement(
	objid varchar(50) not null,
	parentid varchar(50) not null,
	faasid varchar(50),
	remarks varchar(1000),
	primary key (objid)
) engine=innodb default charset=utf8;

alter table subdivision_cancelledimprovement 
	add constraint FK_subdivision_cancelledimprovement_subdivision
	foreign key (parentid) references subdivision(objid);

alter table subdivision_cancelledimprovement 
	add constraint FK_subdivision_cancelledimprovement_faas
	foreign key (faasid) references faas(objid);


/*===========================================*/
/* MACHRPU - ADD BLDG REFERENCE */
/*===========================================*/
alter table machrpu add bldgmaster_objid varchar(50);


/*===========================================*/
/* STRUCTURE UPDATE */
/*===========================================*/
alter table structure add showinfaas int not null;
update structure set showinfaas = 1 where showinfaas is null;



/*===========================================*/
/* STEWARDSHIP SUPPORT */
/*===========================================*/
alter table realproperty add stewardshipno varchar(3) ;
alter table faas add parentfaasid varchar(50) ;

INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `checkbalance`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`) 
VALUES ('ST', 'Stewardship', '1', '1', '1', 'DP', '1', '0', '0', '1', '1', '');

INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `checkbalance`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`) 
VALUES ('STP', 'Stewardship', '0', '1', '1', 'DP', '0', '0', '0', '0', '1', '');


create table faas_stewardship
(
	objid varchar(50),
	rpumasterid varchar(50) not null, 
	stewardrpumasterid varchar(50) not null,
	ry int not null, 
	stewardshipno int not null,
	primary key(objid)
) engine=INNODB charset=utf8;

create unique index ux_faas_stewardship on faas_stewardship(rpumasterid, stewardrpumasterid, ry, stewardshipno);
create index ix_faas_stewardship_rpumasterid on faas_stewardship(rpumasterid);
create index ix_faas_stewardship_stewardrpumasterid on faas_stewardship(stewardrpumasterid);


	
/*=========================================================
* RESTRICTED PROPERTY
*=========================================================*/
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) 
VALUES ('LANDTAX.REPORT.restricted-property.generate', 'LANDTAX.REPORT', 'restricted-property', 'generate', 'Generate List of Restricted Properties');


/* v2.5.04.032-03008 */
/*========================================
*
* REPLACE etracs254_lguname with the 
* correct PRODUCTION Database Name
*=======================================*/

set @dbname := 'etracs255_loay';

/*=======================================*/


drop procedure if exists alter_sys_rule_actiondef;

delimiter $$
create procedure alter_sys_rule_actiondef(in _dbname varchar(100))
begin
    declare _count int;
    set _count = (  select count(*) 
                    from information_schema.columns
                    where  table_schema = _dbname and 
                           table_name = 'sys_rule_actiondef' and 
                           column_name = 'actionclass');

    if _count = 0 then
        alter table sys_rule_actiondef
            add column actionclass varchar(100);
    end if;
end $$
delimiter ;

call alter_sys_rule_actiondef(@dbname);

drop procedure if exists alter_sys_rule_actiondef;


create table faas_restriction_type
(
	objid varchar(50),
	name varchar(100) not null,
	idx int not null,
	isother int not null,
	primary key(objid)
)engine=innodb default charset=utf8;


INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('BOUNDARY_CONFLICT', 'Boundary Conflict', '4', '1');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('BSP_GSP', 'BSP / GSP', '9', '1');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('CARP', 'Under CARP', '1', '0');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('RED_AREAS', 'Red Areas', '3', '1');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('RP_NIA', 'RP / NIA', '5', '1');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('TELECOM', 'Telecom', '6', '1');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('UNDER_LITIGATION', 'Under Litigation', '2', '0');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('UNDETERMINED', 'Undermined', '7', '1');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('UNLOCATED_OWNER', 'Unlocated Owner', '8', '1');
INSERT INTO `faas_restriction_type` (`objid`, `name`, `idx`, `isother`) VALUES ('RESTRICTED', 'Restricted', '9', '1');



INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('RPT.REPORT', 'REPORT', 'RPT', 'usergroup', NULL, 'REPORT');

INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) 
VALUES ('RPT.REPORT-faas-titled-report-viewreport', 'RPT.REPORT', 'faas-titled-report', 'viewreport', 'View Report');



alter table subdivision_cancelledimprovement add lasttaxyear int;
alter table subdivision_cancelledimprovement add lguid varchar(50);
alter table subdivision_cancelledimprovement add reason_objid varchar(50);


/* RPLEDGER: add blockno info */
alter table rptledger add blockno varchar(50);

create index ix_rptledger_blockno on rptledger(blockno);

update rptledger rl, faas f, realproperty rp set 
    rl.blockno = rp.blockno
where rl.faasid = f.objid and f.realpropertyid = rp.objid;


/* PC and DT txn types */
INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `checkbalance`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`) VALUES ('PC', 'Physical Obsolence', '0', '1', '0', 'PC', '0', '0', '0', '0', '1', NULL);
INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `checkbalance`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`) VALUES ('DT', 'Destruction of Property', '0', '1', '0', 'DT', '0', '0', '0', '0', '1', NULL);



alter table faas_txntype add reconcileledger int ;
update faas_txntype set reconcileledger = 1 where reconcileledger is null;

INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `checkbalance`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`, `reconcileledger`) VALUES ('UK', 'Unknown to Known', '1', '1', '1', 'DP', '1', '0', '0', '0', '1', NULL, '0');
update faas_txntype set reconcileledger = 0 where objid = 'UK';    
    


/* CANCELLED FAAS */

alter table cancelledfaas add originlguid varchar(50);

update cancelledfaas set originlguid = lguid where originlguid is null;


delete from sys_wf_transition where processname = 'cancelledfaas';
    
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('start', 'cancelledfaas', '', 'receiver', '1', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'cancelledfaas', 'delete', 'end', '5', NULL, '[caption:\'Delete\', confirm:\'Delete record?\', closeonend:true]', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'cancelledfaas', 'submit', 'assign-taxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit for taxmapping?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-taxmapper', 'cancelledfaas', '', 'taxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'cancelledfaas', 'return_receiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'cancelledfaas', 'submit', 'assign-recommender', '27', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-recommender', 'cancelledfaas', '', 'recommender', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'return_receiver', 'receiver', '71', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\', messagehandler:\'default\']', '');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'return_appraiser', 'appraiser', '72', NULL, '[caption:\'Return to Appraiser\',confirm:\'Return to appraiser?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'return_taxmapper', 'taxmapper', '73', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'submit_approver', 'assign-approver', '74', NULL, '[caption:\'Submit for Assessor Approval\', confirm:\'Submit to assessor approval?\', messagehandler:\'default\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'cancelledfaas', 'submit_to_province', 'approver', '75', NULL, '[caption:\'Submit to Province\', confirm:\'Submit to Province?\', messagehandler:\'rptmessage:create\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-approver', 'cancelledfaas', '', 'approver', '80', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('approver', 'cancelledfaas', 'approve', 'end', '110', NULL, '[caption:\'Manually Approve\',confirm:\'Manually approve cancellation?\']', NULL);

update sys_wf_transition set action = '' where action is null;


ALTER TABLE `sys_wf_transition`
MODIFY COLUMN `action`  varchar(50) not null,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`parentid`, `processname`, `to`, `action`);


/* insert rptledger restrictions */
insert into rptledger_restriction(objid, parentid, restrictionid, remarks)
select distinct f.objid, rlf.rptledgerid, f.restrictionid, null 
from faas f 
    inner join rptledgerfaas rlf on f.objid = rlf.faasid 
where f.restrictionid is not null 
and not exists(select * from rptledger_restriction where parentid = rlf.rptledgerid and restrictionid = f.restrictionid);


/* v2.5.04.032-03009 */

/*============================================
**
** RPT TRANSMITTAL UPDATES 
**
============================================*/
drop table if exists rpttransmittal_item_data;
drop table if exists rpttransmittal_item;
drop table if exists rpttransmittal_log;
drop table if exists rpttransmittal;

CREATE TABLE `rpttransmittal` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `type` varchar(15) NOT NULL,
  `filetype` varchar(50) not null,
  `txnno` varchar(15) NOT NULL,
  `txndate` datetime NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `lgu_name` varchar(50) NOT NULL,
  `lgu_type` varchar(50) NOT NULL,
  `tolgu_objid` varchar(50) NOT NULL,
  `tolgu_name` varchar(50) NOT NULL,
  `tolgu_type` varchar(50) NOT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(100) NOT NULL,
  `createdby_title` varchar(50) NOT NULL,
  `remarks` varchar(500) default NULL,
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `ux_txnno` (`txnno`),
  KEY `ix_state` (`state`),
  KEY `ix_createdby_name` (`createdby_name`),
  KEY `ix_lguname` (`lgu_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `rpttransmittal_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `filetype` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(150) NOT NULL,
  `message` varchar(350),
  `remarks` varchar(350),
  `status` varchar(50), 
  `disapprovedby_name` varchar(150),
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `ux_parentid_refid` (`parentid`,`refid`),
  KEY `ix_refid` (`refid`),
  KEY `FK_rpttransmittal_item_rpttransmittal` (`parentid`)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table rpttransmittal_item 
add CONSTRAINT `FK_rpttransmittal_item_rpttransmittal` 
FOREIGN KEY (`parentid`) REFERENCES `rpttransmittal` (`objid`);


alter table rpt_changeinfo add redflagid varchar(50);





/*=================================================================
*
* MACHINE TAXABILITY
* 
=================================================================*/

alter table machdetail add taxable int;
update machdetail set taxable = 1 where taxable is null;

/* v2.5.04.032-03010 */

/*===========================================
* CERTIFICATION UPDATE
*===========================================*/

alter table rptcertification 
  add `year` int,
  add qtr int ;

  



/*===========================================
* SPECIFIC CLASS
*===========================================*/

CREATE TABLE `landspecificclass` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY  (`objid`),
  KEY `ux_landspecificclass_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


insert into landspecificclass(
  objid, state, code, name 
)
select 
  objid, 'APPROVED', code, name 
from lcuvspecificclass;


alter table lcuvspecificclass add landspecificclass_objid varchar(50);

create index ix_landspecificclass_objid on lcuvspecificclass(landspecificclass_objid );

alter table lcuvspecificclass 
  add constraint fk_lcuvspecificclass_landspecificclass 
  foreign key(landspecificclass_objid ) references landspecificclass(objid);

update lcuvspecificclass set 
  landspecificclass_objid  = objid
where landspecificclass_objid is null;



alter table landdetail add landspecificclass_objid varchar(50);

update landdetail set landspecificclass_objid = specificclass_objid where landspecificclass_objid is null;




alter table lcuvspecificclass 
  drop column code, 
  drop column name; 




/*====================================================
* SUPPORT BLDG ADDITIONAL ITEM SELECTIVE DEPRECIATION 
=====================================================*/

alter table bldgflooradditional add depreciate int;

update bldgflooradditional set depreciate = 1 where depreciate = 0;


alter table bldguse add adjfordepreciation decimal(16,2);

update bldguse set adjfordepreciation = adjustment where adjfordepreciation is null;  




/*====================================================
* SUPPORT BLDG USE TAXABILITY
=====================================================*/
alter table bldguse add taxable int; 

update bldguse set taxable = 1 where taxable is null;  

alter table rpu_assessment add taxable int;

update rpu_assessment set taxable = 1 where taxable is null;  


/* v2.5.04.032-03011 */
alter table cashreceiptitem_rpt_online drop foreign key FK_cashreceiptitem_rpt_online_rptledgeritem;
alter table cashreceiptitem_rpt_online drop foreign key FK_cashreceiptitem_rpt_online_rptledgeritemqtrly;


/* subdivision */

alter table subdivisionaffectedrpu add isnew int;
update subdivisionaffectedrpu set isnew = 0 where isnew is null;


delete from rptbill_ledger_item where billid in (
	select objid from rptbill where expirydate < '2016-09-01'
);

delete from rptbill_ledger_account where billid in (
	select objid from rptbill where expirydate < '2016-09-01'
);


delete from rptbill_ledger where billid in (
	select objid from rptbill where expirydate < '2016-09-01'
);

delete from rptbill where expirydate < '2016-09-01';



/* v2.5.04.032-03012 */
INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.MANAGEMENT', 'MANAGEMENT', 'RPT', NULL, NULL, 'MANAGEMENT');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('PER-41ea09c:157ef7851c2:-7df4', 'RPT.MANAGEMENT', 'report', 'txn-monitoring', 'Transaction Monitoring');

create index ix_realproperty_claimno on realproperty(claimno);

create index ix_dtinspected on examiner_finding(dtinspected);


create index ix_assignee_objid on faas_task(assignee_objid);
create index ix_assignee_objid on subdivision_task(assignee_objid);
create index ix_assignee_objid on consolidation_task(assignee_objid);
create index ix_assignee_objid on cancelledfaas_task(assignee_objid);

alter table faas_txntype add allowannotated int;
update faas_txntype set allowannotated = 0 where allowannotated is null;			

INSERT INTO sys_var (name, value, description, datatype, category) VALUES ('faas_transaction_process_as_capture', '0', 'Allow processing of online transaction as data capture', 'checkbox', 'ASSESSOR');


-- 254032-03013

create table memoranda_template
(
	objid varchar(50) primary key,
	code varchar(25) not null,
	template varchar(500) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table rpu_assessment modify column classification_objid varchar(50)  null;
alter table rpu_assessment modify column actualuse_objid varchar(50)  null;

-- 254032-03014

INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-bldgkind-create', 'RPT.MASTER', 'bldgkind', 'create', 'Create Kind of Building');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-bldgkind-delete', 'RPT.MASTER', 'bldgkind', 'delete', 'Delete Kind of Building');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-bldgkind-edit', 'RPT.MASTER', 'bldgkind', 'edit', 'Edit Kind of Building');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-bldgkind-read', 'RPT.MASTER', 'bldgkind', 'read', 'Open Kind of Building');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-landspecificclass-delete', 'RPT.MASTER', 'landspecificclass', 'delete', 'Delete Land Specific Class');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-landspecificclass-create', 'RPT.MASTER', 'landspecificclass', 'create', 'Create Land Specific Class');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-landspecificclass-read', 'RPT.MASTER', 'landspecificclass', 'read', 'Open Land Specific Class');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-landspecificclass-edit', 'RPT.MASTER', 'landspecificclass', 'edit', 'Edit Land Specific Class');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-machine-create', 'RPT.MASTER', 'machine', 'create', 'Create Machine');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-machine-read', 'RPT.MASTER', 'machine', 'read', 'Open Machine');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-machine-edit', 'RPT.MASTER', 'machine', 'edit', 'Edit Machine');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-machine-delete', 'RPT.MASTER', 'machine', 'delete', 'Delete Machine');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-approve', 'RPT.MASTER', 'master', 'approve', 'Approve Memoranda Template');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-sync', 'RPT.MASTER', 'master', 'sync', 'Synchronize Master Files');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-import', 'RPT.MASTER', 'master', 'import', 'Import Master Files');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-disapprove', 'RPT.MASTER', 'master', 'disapprove', 'Disapprove Memoranda Template');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-viewlist', 'RPT.MASTER', 'master', 'viewlist', 'View Master Files');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-export', 'RPT.MASTER', 'master', 'export', 'Export Master Files');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-material-delete', 'RPT.MASTER', 'material', 'delete', 'Delete Material');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-material-edit', 'RPT.MASTER', 'material', 'edit', 'Edit Material');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-material-read', 'RPT.MASTER', 'material', 'read', 'Open Material');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-material-create', 'RPT.MASTER', 'material', 'create', 'Create Material');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-plant-read', 'RPT.MASTER', 'planttree', 'read', 'Open Plant/Tree');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-plant-edit', 'RPT.MASTER', 'planttree', 'edit', 'Edit Plant/Tree');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-plant-create', 'RPT.MASTER', 'planttree', 'create', 'Create Plant/Tree');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-plant-delete', 'RPT.MASTER', 'planttree', 'delete', 'Delete Plant/Tree');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-memoranda-read', 'RPT.MASTER', 'rptis_memoranda_template', 'read', 'Open Memoranda Template');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-memoranda-delete', 'RPT.MASTER', 'rptis_memoranda_template', 'delete', 'Delete Memoranda Template');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-memoranda-create', 'RPT.MASTER', 'rptis_memoranda_template', 'create', 'Create Memoranda Template');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-memoranda-edit', 'RPT.MASTER', 'rptis_memoranda_template', 'edit', 'Edit Memoranda Template');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-miscitem-read', 'RPT.MASTER', 'miscitem', 'read', 'Open Miscellaneous Item');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-miscitem-edit', 'RPT.MASTER', 'miscitem', 'edit', 'Edit Miscellaneous Item');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-miscitem-create', 'RPT.MASTER', 'miscitem', 'create', 'Create Miscellaneous Item');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-miscitem-delete', 'RPT.MASTER', 'miscitem', 'delete', 'Delete Miscellaneous Item');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-exemptiontype-create', 'RPT.MASTER', 'exemptiontype', 'create', 'Create Exemption Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-exemptiontype-delete', 'RPT.MASTER', 'exemptiontype', 'delete', 'Delete Exemption Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-exemptiontype-edit', 'RPT.MASTER', 'exemptiontype', 'edit', 'Edit Exemption Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-exemptiontype-read', 'RPT.MASTER', 'exemptiontype', 'read', 'Open Exemption Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-rptparameter-create', 'RPT.MASTER', 'rptparameter', 'create', 'Create Parameter');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-rptparameter-delete', 'RPT.MASTER', 'rptparameter', 'delete', 'Delete Parameter');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-rptparameter-edit', 'RPT.MASTER', 'rptparameter', 'edit', 'Edit Parameter');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-rptparameter-read', 'RPT.MASTER', 'rptparameter', 'read', 'Open Parameter');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-classification-create', 'RPT.MASTER', 'propertyclassification', 'create', 'Create Property Classification');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-classification-delete', 'RPT.MASTER', 'propertyclassification', 'delete', 'Delete Property Classification');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-classification-edit', 'RPT.MASTER', 'propertyclassification', 'edit', 'Edit Property Classification');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-classification-read', 'RPT.MASTER', 'propertyclassification', 'read', 'Open Property Classification');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-structure-create', 'RPT.MASTER', 'structure', 'create', 'Create Structure');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-structure-delete', 'RPT.MASTER', 'structure', 'delete', 'Delete Structure');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-structure-edit', 'RPT.MASTER', 'structure', 'edit', 'Edit Structure');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-structure-read', 'RPT.MASTER', 'structure', 'read', 'Open Structure');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-requirementtype-create', 'RPT.MASTER', 'requirementtype', 'create', 'Create Requirement Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-requirementtype-delete', 'RPT.MASTER', 'requirementtype', 'delete', 'Delete Requirement Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-requirementtype-edit', 'RPT.MASTER', 'requirementtype', 'edit', 'Edit Requirement Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-requirementtype-read', 'RPT.MASTER', 'requirementtype', 'read', 'Open Requirement Type');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-faastxntype-edit', 'RPT.MASTER', 'faastxntype', 'edit', 'Edit Transaction Types');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.MASTER-faastxntype-read', 'RPT.MASTER', 'faastxntype', 'read', 'Open Transaction Types');



-- RYSETTING UPDATES
alter table landrysetting add remarks varchar(200);

alter table bldgrysetting add remarks varchar(200);
alter table bldgrysetting modify column predominant int null;
alter table bldgrysetting modify column depreciatecoreanditemseparately int null;
alter table bldgrysetting modify column computedepreciationbasedonschedule int null;
alter table bldgrysetting modify column straightdepreciation int null;
alter table bldgrysetting modify column calcbldgagebasedondtoccupied int null;

alter table machrysetting add remarks varchar(200);
alter table machrysetting modify column residualrate decimal(10,2) null;


alter table planttreerysetting add remarks varchar(200);
alter table planttreerysetting modify column applyagriadjustment int null;
alter table planttreeassesslevel add fixrate int ;
update planttreeassesslevel set fixrate = 1 where fixrate is null;
	
alter table miscrysetting add remarks varchar(200);



drop table if exists faas_previous;

create table faas_previous
(
	objid varchar(50) not null, 
	faasid varchar(50) not null,
	prevfaasid varchar(50) null,
	prevrpuid varchar(50) null,
	prevtdno varchar(800) null,
	prevpin varchar(800) null,
	prevowner text null,
	prevadministrator text null,
	prevav varchar(500) null,
	prevmv varchar(500) null,
	prevareasqm varchar(500)null,
	prevareaha varchar(500) null,
	preveffectivity varchar(10) null,
	primary key(objid),
	index FK_faas_previous_faas(faasid),
	index ix_faas_previous_tdno(prevtdno),
	index ix_faas_previous_pin(prevpin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table faas_previous 
	add constraint FK_faas_previous_faas 
	foreign key(faasid) references faas(objid);


insert into faas_previous(
	objid,
	faasid,
	prevfaasid,
	prevrpuid,
	prevtdno,
	prevpin,
	prevowner,
	prevadministrator,
	prevav,
	prevmv,
	prevareasqm,
	prevareaha,
	preveffectivity
)
select 
	objid,
	objid as faasid,
	null as prevfaasid,
	null as prevrpuid, 
	prevtdno,
	prevpin,
	prevowner,
	prevadministrator,
	prevav,
	prevmv,
	prevareasqm,
	prevareaha,
	preveffectivity
from faas f 
where datacapture =  1;


insert into faas_previous(
	objid,
	faasid,
	prevfaasid,
	prevrpuid,
	prevtdno,
	prevpin,
	prevowner,
	prevadministrator,
	prevav,
	prevmv,
	prevareasqm,
	prevareaha,
	preveffectivity
)
select 
	concat(f.objid, '-', pf.tdno) as objid,
	f.objid as faasid,
	pf.objid as prevfaasid,
	pf.rpuid as prevrpuid, 
	pf.tdno as prevtdno,
	pf.fullpin as prevpin,
	pf.owner_name as prevowner,
	pf.administrator_name as prevadministrator,
	pr.totalav as prevav,
	pr.totalmv as prevmv,
	pr.totalareasqm as  prevareasqm,
	pr.totalareaha as prevareaha,
	pf.effectivityyear as preveffectivity
from faas f 
	inner join previousfaas p on f.objid = p.faasid 
	inner join faas pf on p.prevfaasid = pf.objid
	inner join rpu pr on pf.rpuid = pr.objid ;



insert into faas_previous(
	objid,
	faasid,
	prevfaasid,
	prevrpuid,
	prevtdno,
	prevpin,
	prevowner,
	prevadministrator,
	prevav,
	prevmv,
	prevareasqm,
	prevareaha,
	preveffectivity
)
select 
	objid,
	objid as faasid,
	null as prevfaasid,
	null as prevrpuid, 
	prevtdno,
	prevpin,
	prevowner,
	prevadministrator,
	prevav,
	prevmv,
	prevareasqm,
	prevareaha,
	preveffectivity
from faas f 
where datacapture =  0
and not exists(select * from previousfaas where faasid = f.objid) 
and not exists(select * from faas_previous where faasid = f.objid) 
;






CREATE TABLE `batchgr_items_forrevision` (
  `objid` varchar(50) NOT NULL,
  `rpuid` varchar(50) NOT NULL,
  `realpropertyid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(25) NOT NULL,
  `fullpin` varchar(30) NOT NULL,
	`pin` varchar(30) not null,
	`suffix` int not null,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `batchgr_error` (
  `objid` varchar(50) NOT NULL,
  `newry` int(11) NOT NULL,
  `msg` longtext,
  PRIMARY KEY (`objid`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE `payment_partner` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `info` text DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cashreceiptpayment_eor` (
  `objid` varchar(50) NOT NULL,
  `dtposted` datetime NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `partner_objid` varchar(50) DEFAULT NULL,
  `txnrefid` varchar(50) DEFAULT NULL,
  `txnreftype` varchar(50) DEFAULT NULL,
  `refno` varchar(100) DEFAULT NULL,
  `refdate` datetime DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_receiptid` (`receiptid`),
  KEY `ix_account_objid` (`partner_objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_refdate` (`refdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table cashreceiptpayment_eor 
	add CONSTRAINT `fk_payment_partner_eor` 
	FOREIGN KEY (`partner_objid`) REFERENCES `payment_partner` (`objid`);

INSERT INTO `payment_partner` (`objid`, `name`, `code`, `info`) 
VALUES ('DBP', 'DEVELOPMENT BANK OF THE PHILIPPINES', '101', '[terminalid:56, transactionkey:\"5f16150a98195379b69b525626cf41c41d79b33d\"]');

INSERT INTO `payment_partner` (`objid`, `name`, `code`, `info`) 
VALUES ('LBP', 'LAND BANK OF THE PHILIPPINES', '102', '[merchantcode:\"2016120039\"]');

 INSERT INTO af ( objid, title, usetype, serieslength,  system,  denomination,  formtype)
 VALUES ('EOR', 'EOR', 'collection', 12,  1, 0.00,  'serial' );



INSERT INTO `sys_user` (`objid`, `state`, `dtcreated`, `createdby`, `username`, `pwd`, `firstname`, `lastname`, `middlename`, `name`, `jobtitle`, `pwdlogincount`, `pwdexpirydate`, `usedpwds`, `lockid`, `txncode`) VALUES ('EOR', NULL, NULL, NULL, 'EOR', NULL, 'EOR', 'EOR', NULL, 'EOR', 'EOR', '0', NULL, NULL, '', '');



drop table if exists eor_paymentorder;
drop table if exists paymentorder;

CREATE TABLE `paymentorder` (
  `txnid` varchar(50) NOT NULL DEFAULT '',
  `txndate` datetime DEFAULT NULL,
  `controlno` varchar(50) NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) DEFAULT NULL,
  `particulars` varchar(500) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `txntypeid` varchar(50) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`txnid`),
  KEY `ix_controlno` (`controlno`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `eor_paymentorder` (
  `objid` varchar(50) NOT NULL,
  `traceno` varchar(50) DEFAULT NULL,
  `tracedate` datetime DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `paymentorder_txnid` varchar(50) NOT NULL DEFAULT '',
  `paymentorder_controlno` varchar(50) NOT NULL DEFAULT '',
  `paymentorder_txndate` datetime DEFAULT NULL,
  `paymentorder_payer_objid` varchar(50) DEFAULT NULL,
  `paymentorder_payer_name` text,
  `paymentorder_paidby` text,
  `paymentorder_paidbyaddress` varchar(150) DEFAULT NULL,
  `paymentorder_particulars` varchar(500) DEFAULT NULL,
  `paymentorder_amount` decimal(16,2) DEFAULT NULL,
  `paymentorder_txntypeid` varchar(50) DEFAULT NULL,
  `paymentorder_expirydate` date DEFAULT NULL,
  `paymentorder_refid` varchar(50) DEFAULT NULL,
  `paymentorder_refno` varchar(50) DEFAULT NULL,
  `paymentorder_info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_traceno` (`traceno`),
  KEY `ix_paymentorder_txnid` (`paymentorder_txnid`),
  KEY `ix_paymentorder_controlno` (`paymentorder_controlno`),
  KEY `ix_paymentorder_refid` (`paymentorder_refid`),
  KEY `ix_paymentorder_refno` (`paymentorder_refno`),
  KEY `ix_paymentorder_txntypeid` (`paymentorder_txntypeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 254032-03014a

CREATE TABLE `rptledgeritem_qtrly_partial` (
  `objid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `basicpaid` decimal(16,2) NOT NULL,
  `basicintpaid` decimal(16,2) NOT NULL,
  `basicdisctaken` decimal(16,2) NOT NULL,
  `basicidlepaid` decimal(16,2) NOT NULL,
  `basicidleintpaid` decimal(16,2) NOT NULL,
  `basicidledisctaken` decimal(16,2) NOT NULL,
  `sefpaid` decimal(16,2) NOT NULL,
  `sefintpaid` decimal(16,2) NOT NULL,
  `sefdisctaken` decimal(16,2) NOT NULL,
  `firecodepaid` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rptledgeritemqtrlypartial_rptledger` (`rptledgerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table rptledgeritem_qtrly_partial 
add  CONSTRAINT `FK_rptledgeritemqtrlypartial_rptledger` 
FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`);


alter table faas 
  drop column taxpayer_name,
  drop column taxpayer_address;


CREATE TABLE `faas_restriction` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `ledger_objid` varchar(50) NULL,
  `state` varchar(25) NOT NULL,
  `restrictiontype_objid` varchar(50) NOT NULL,
  `txndate` date NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `receipt_objid` varchar(50) DEFAULT NULL,
  `receipt_receiptno` varchar(15) DEFAULT NULL,
  `receipt_receiptdate` datetime DEFAULT NULL,
  `receipt_amount` decimal(16,2) DEFAULT NULL,
  `receipt_lastyearpaid` int(11) DEFAULT NULL,
  `receipt_lastqtrpaid` int(11) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(150) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table faas_restriction 
add  CONSTRAINT `FK_faas_restriction_faas` 
FOREIGN KEY (`parent_objid`) REFERENCES `faas` (`objid`);



create index ix_parent_objid on faas_restriction(parent_objid);
create index ix_ledger_objid on faas_restriction(ledger_objid);
create index ix_state on faas_restriction(state);
create index ix_receiptno on faas_restriction(receipt_receiptno);
create index ix_txndate on faas_restriction(txndate);
create index ix_restrictiontype_objid on faas_restriction(restrictiontype_objid);

replace into faas_restriction(
  objid,
  parent_objid,
  ledger_objid,
  state,
  restrictiontype_objid,
  txndate,
  remarks,
  receipt_objid,
  receipt_receiptno,
  receipt_receiptdate,
  createdby_objid,
  createdby_name,
  dtcreated
)
select
  concat(rl.objid, rlr.restrictionid) as objid,
  rl.faasid as parent_objid,
  rl.objid as ledger_objid,
  'ACTIVE' as state,
  rlr.restrictionid as restrictiontype_objid,
  f.dtapproved as txndate,
  null as remarks,
  null as receipt_objid,
  null as receipt_receiptno,
  null as receipt_receiptdate,
  null as createdby_objid,
  null as createdby_name,
  null as dtcreated
from faas f 
  inner join rptledger rl on f.objid = rl.faasid 
  inner join rptledger_restriction rlr on rl.objid = rlr.parentid;



replace into faas_restriction(
  objid,
  parent_objid,
  ledger_objid,
  state,
  restrictiontype_objid,
  txndate,
  remarks,
  receipt_objid,
  receipt_receiptno,
  receipt_receiptdate,
  createdby_objid,
  createdby_name,
  dtcreated
)
select
  concat(f.objid, f.restrictionid) as objid,
  f.objid as parent_objid,
  (select distinct objid from rptledger where faasid = f.objid) as ledger_objid,
  'ACTIVE' as state,
  f.restrictionid as restrictiontype_objid,
  f.dtapproved as txndate,
  null as remarks,
  null as receipt_objid,
  null as receipt_receiptno,
  null as receipt_receiptdate,
  null as createdby_objid,
  null as createdby_name,
  null as dtcreated
from faas f 
where restrictionid is not null 
and not exists(select * from rptledger rl 
  inner join rptledger_restriction rlr on rl.objid = rlr.parentid
  where rl.faasid = f.objid 
   and f.restrictionid = rlr.restrictionid);


INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('LANDTAX.RECORD', 'RECORD', 'LANDTAX', NULL, NULL, 'RECORD');
INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('LANDTAX.RECORD_APPROVER', 'RECORD APPROVER', 'LANDTAX', NULL, NULL, 'RECORD_APPROVER');


/* 254032-03015 */


drop table batchgrerror;
alter table batchgr_error add barangayid varchar(50);
alter table batchgr_error add barangay varchar(100);
alter table batchgr_error add tdno varchar(30);


create view vw_batchgr_error 
as 
select 
	err.*,
	f.fullpin as fullpin, 
	rp.pin as pin,
	o.name as lguname
from batchgr_error err 
inner join faas f on err.objid = f.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rp.barangayid = b.objid 
inner join sys_org o on f.lguid = o.objid;


CREATE TABLE `rptledger_forprocess` (
  `objid` varchar(255) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




alter table rptledgeritem
	modify column basicintpaid decimal(16,2) null,
	modify column basicdisctaken decimal(16,2) null,
	modify column basicidledisctaken decimal(16,2) null,
	modify column basicidleintpaid decimal(16,2) null,
	modify column sefintpaid decimal(16,2) null,
	modify column sefdisctaken decimal(16,2) null;

alter table rptledgeritem_qtrly
	modify column basicintpaid decimal(16,2) null,
	modify column basicdisctaken decimal(16,2) null,
	modify column basicidledisctaken decimal(16,2) null,
	modify column basicidleintpaid decimal(16,2) null,
	modify column sefintpaid decimal(16,2) null,
	modify column sefdisctaken decimal(16,2) null;





drop table rptledgeritem_qtrly_partial;


create index ix_dtapproved on faas(dtapproved);


alter table faas_restriction add rpumaster_objid varchar(50); 


update faas_restriction fr, faas f, rpu r set 
	fr.rpumaster_objid = r.rpumasterid
where fr.parent_objid = f.objid 
and f.rpuid = r.objid 
and fr.rpumaster_objid is null;


alter table cancelledfaas add cancelledbytdnos varchar(500);
alter table cancelledfaas add cancelledbypins varchar(500);


alter table subdivision_cancelledimprovement add cancelledbytdnos varchar(500);
alter table subdivision_cancelledimprovement add cancelledbypins varchar(500);

/* 254032-03016 */
INSERT INTO `rptparameter` (`objid`, `state`, `name`, `caption`, `description`, `paramtype`, `minvalue`, `maxvalue`) VALUES ('DISTANCE_TO_AWR', 'APPROVED', 'DISTANCE_TO_AWR', 'DISTANCE TO AWR', '', 'decimal', '0', '0');
INSERT INTO `rptparameter` (`objid`, `state`, `name`, `caption`, `description`, `paramtype`, `minvalue`, `maxvalue`) VALUES ('DISTANCE_TO_LTC', 'APPROVED', 'DISTANCE_TO_LTC', 'DISTANCE TO LTC', '', 'decimal', '0', '0');


INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) VALUES ('faas_land_auto_agricultural_adjustment', '0', 'Land RPU Auto Adjustment', 'checkbox', 'ASSESSOR');

alter table landrpu 
	add distanceawr decimal(16,2),
	add distanceltc decimal(16,2);

/* 254032-03017 */

drop table rptbill_ledger_account;
drop table rptbill_ledger_item;

/* 254032-03018 */

alter table faasbacktax modify column tdno varchar(25) null;
drop table cashreceiptpayment_eor;



/* 254032-03018 */

alter table faasbacktax modify column tdno varchar(25) null;


alter table landdetail modify column subclass_objid varchar(50) null;
alter table landdetail modify column specificclass_objid varchar(50) null;
alter table landdetail modify column actualuse_objid varchar(50) null;
alter table landdetail modify column landspecificclass_objid varchar(50) null;



/* RYSETTING ORDINANCE INFO */
alter table landrysetting 
  add ordinanceno varchar(25),
  add ordinancedate date;


alter table bldgrysetting 
  add ordinanceno varchar(25),
  add ordinancedate date;


alter table machrysetting 
  add ordinanceno varchar(25),
  add ordinancedate date;


alter table miscrysetting 
  add ordinanceno varchar(25),
  add ordinancedate date;


alter table planttreerysetting 
  add ordinanceno varchar(25),
  add ordinancedate date;


delete from sys_var where name in ('gr_ordinance_date','gr_ordinance_no');

  



drop TABLE if exists `bldgrpu_land`;

CREATE TABLE `bldgrpu_land` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rpu_objid` varchar(50) NOT NULL DEFAULT '',
  `landfaas_objid` varchar(50) DEFAULT NULL,
  `landrpumaster_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_bldgrpu_land_bldgrpuid` (`rpu_objid`),
  KEY `ix_bldgrpu_land_landfaasid` (`landfaas_objid`),
  KEY `ix_bldgrpu_land_landrpumasterid` (`landrpumaster_objid`),
  CONSTRAINT `FK_bldgrpu_land_bldgrpu` FOREIGN KEY (`rpu_objid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `FK_bldgrpu_land_rpumaster` FOREIGN KEY (`landrpumaster_objid`) REFERENCES `rpumaster` (`objid`),
  CONSTRAINT `FK_bldgrpu_land_landfaas` FOREIGN KEY (`landfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

  

create table batchgr_log (
  objid varchar(50) not null,
  primary key (objid)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table bldgrpu_structuraltype modify column bldgkindbucc_objid nvarchar(50) null;



alter table bldgadditionalitem add idx int;
update bldgadditionalitem set idx = 0 where idx is null;

  



/*================================================= 
*
*  PROVINCE-MUNI LEDGER SYNCHRONIZATION SUPPORT 
*
====================================================*/
CREATE TABLE `rptledger_remote` (
  `objid` varchar(50) NOT NULL,
  `remote_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtcreated` datetime NOT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `FK_rptledgerremote_rptledger` FOREIGN KEY (`objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



/*======================================
* AUTOMATIC MACH AV RECALC SUPPORT
=======================================*/
INSERT INTO `rptparameter` (`objid`, `state`, `name`, `caption`, `description`, `paramtype`, `minvalue`, `maxvalue`) 
VALUES ('TOTAL_VALUE', 'APPROVED', 'TOTAL_VALUE', 'TOTAL VALUE', '', 'decimal', '0', '0');




/* BATCH GR ADDITIONAL SUPPORT */
alter table batchgr_items_forrevision add section varchar(3);
alter table batchgr_items_forrevision add classification_objid varchar(50);


/* 254032-03018 */

alter table faasbacktax modify column tdno varchar(25) null;



/*===============================================================
* REALTY TAX ACCOUNT MAPPING  UPDATE 
*==============================================================*/

CREATE TABLE `landtax_lgu_account_mapping` (
  `objid` varchar(50) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `revtype` varchar(50) NOT NULL,
  `revperiod` varchar(50) NOT NULL,
  `item_objid` varchar(50) NOT NULL,
  KEY `FK_landtaxlguaccountmapping_sysorg` (`lgu_objid`),
  KEY `FK_landtaxlguaccountmapping_itemaccount` (`item_objid`),
  KEY `ix_revtype` (`revtype`),
  KEY `ix_objid` (`objid`),
  CONSTRAINT `fk_landtaxlguaccountmapping_itemaccount` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `fk_landtaxlguaccountmapping_sysorg` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

delete from sys_rulegroup where ruleset = 'rptbilling' and name in ('BEFORE-MISC-COMP','MISC-COMP');





/*======================================================
* RPTLEDGER PAYMENT
*=====================================================*/ 
drop table if exists cashreceiptitem_rpt_noledger;
drop table if exists cashreceiptitem_rpt;
drop table if exists rptledger_payment_share; 
drop table if exists rptledger_payment_item; 
drop table if exists rptledger_payment;


CREATE TABLE `rptledger_payment` (
  `objid` varchar(100) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL,
  `receiptid` varchar(50) NULL,
  `receiptno` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `paidby_name` longtext NOT NULL,
  `paidby_address` varchar(150) NOT NULL,
  `postedby` varchar(100) NOT NULL,
  `postedbytitle` varchar(50) NOT NULL,
  `dtposted` datetime NOT NULL,
  `fromyear` int(11) NOT NULL,
  `fromqtr` int(11) NOT NULL,
  `toyear` int(11) NOT NULL,
  `toqtr` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `collectingagency` varchar(50) DEFAULT NULL,
  `voided` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `fk_rptledger_payment_rptledger` on rptledger_payment(`rptledgerid`) using btree;
create index `fk_rptledger_payment_cashreceipt` on rptledger_payment(`receiptid`) using btree;
create index `ix_receiptno` on rptledger_payment(`receiptno`) using btree;

alter table rptledger_payment 
add constraint `fk_rptledger_payment_cashreceipt` foreign key (`receiptid`) references `cashreceipt` (`objid`);

alter table rptledger_payment 
add constraint `fk_rptledger_payment_rptledger` foreign key (`rptledgerid`) references `rptledger` (`objid`);


CREATE TABLE `rptledger_payment_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(100) NOT NULL,
  `rptledgerfaasid` varchar(50) DEFAULT NULL,
  `rptledgeritemid` varchar(50) DEFAULT NULL,
  `rptledgeritemqtrlyid` varchar(50) DEFAULT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicdisc` decimal(16,2) NOT NULL,
  `basicidle` decimal(16,2) NOT NULL,
  `basicidledisc` decimal(16,2) DEFAULT NULL,
  `basicidleint` decimal(16,2) DEFAULT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `sefdisc` decimal(16,2) NOT NULL,
  `firecode` decimal(10,2) DEFAULT NULL,
  `sh` decimal(16,2) NOT NULL,
  `shint` decimal(16,2) NOT NULL,
  `shdisc` decimal(16,2) NOT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `revperiod` varchar(25) DEFAULT NULL,
  `partialled` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `FK_rptledger_payment_item_parentid` on rptledger_payment_item(`parentid`) using btree;
create index `FK_rptledger_payment_item_rptledgerfaasid` on rptledger_payment_item(`rptledgerfaasid`) using btree;
create index `ix_rptledgeritemid` on rptledger_payment_item(`rptledgeritemid`) using btree;
create index `ix_rptledgeritemqtrlyid` on rptledger_payment_item(`rptledgeritemqtrlyid`) using btree;


alter table rptledger_payment_item 
  add constraint `fk_rptledger_payment_item_parentid` 
  foreign key (`parentid`) references `rptledger_payment` (`objid`);
alter table rptledger_payment_item 
  add constraint `fk_rptledger_payment_item_rptledgerfaasid` 
  foreign key (`rptledgerfaasid`) references `rptledgerfaas` (`objid`);


create table rptledger_payment_share (
  objid varchar(50) not null,
  parentid varchar(100) null,
  revperiod varchar(25) not null,
  revtype varchar(25) not null,
  item_objid varchar(50) not null,
  amount decimal(16,4) not null,
  sharetype varchar(25) not null,
  discount decimal(16,4) null,
  primary key (objid)
) engine=innodb charset=utf8;

alter table rptledger_payment_share
  add constraint FK_rptledger_payment_share_parentid foreign key (parentid) 
  references rptledger_payment(objid);

alter table rptledger_payment_share
  add constraint FK_rptledger_payment_share_itemaccount foreign key (item_objid) 
  references itemaccount(objid);

create index FK_parentid on rptledger_payment_share(parentid) using btree;
create index FK_item_objid on rptledger_payment_share(item_objid) using btree;



insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  x.objid,
  x.rptledgerid,
  x.type,
  x.receiptid,
  x.receiptno,
  x.receiptdate,
  x.paidby_name,
  x.paidby_address,
  x.postedby,
  x.postedbytitle,
  x.dtposted,
  x.fromyear,
  (select min(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.fromyear) as fromqtr,
  x.toyear,
  (select max(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.toyear) as toqtr,
  x.amount,
  x.collectingagency,
  0 as voided
from (
  select
    concat(cro.rptledgerid, '-', cr.objid) as objid,
    cro.rptledgerid,
    cr.txntype as type,
    cr.objid as receiptid,
    c.receiptno as receiptno,
    c.receiptdate as receiptdate,
    c.paidby as paidby_name,
    c.paidbyaddress as paidby_address,
    c.collector_name as postedby,
    c.collector_title as postedbytitle,
    c.txndate as dtposted,
    min(cro.year) as fromyear,
    max(cro.year) as toyear,
    sum(
      cro.basic + cro.basicint - cro.basicdisc + cro.sef + cro.sefint - cro.sefdisc + cro.firecode +
      cro.basicidle + cro.basicidleint - cro.basicidledisc
    ) as amount,
    null as collectingagency
  from cashreceipt_rpt cr 
  inner join cashreceipt c on cr.objid = c.objid 
  inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid
  left join cashreceipt_void cv on c.objid = cv.receiptid 
  where cv.objid is null 
  group by 
    cr.objid,
    cro.rptledgerid,
    cr.txntype,
    c.receiptno,
    c.receiptdate,
    c.paidby,
    c.paidbyaddress,
    c.collector_name,
    c.collector_title,
    c.txndate 
)x;


insert into rptledger_payment_item(
  objid,
  parentid,
  rptledgerfaasid,
  rptledgeritemid,
  rptledgeritemqtrlyid,
  year,
  qtr,
  basic,
  basicint,
  basicdisc,
  basicidle,
  basicidledisc,
  basicidleint,
  sef,
  sefint,
  sefdisc,
  firecode,
  sh,
  shint,
  shdisc,
  total,
  revperiod,
  partialled
)
select
  cro.objid,
  concat(cro.rptledgerid, '-', cro.rptreceiptid) as parentid,
  cro.rptledgerfaasid,
  cro.rptledgeritemid,
  cro.rptledgeritemqtrlyid,
  cro.year,
  cro.qtr,
  cro.basic,
  cro.basicint,
  cro.basicdisc,
  cro.basicidle,
  cro.basicidledisc,
  cro.basicidleint,
  cro.sef,
  cro.sefint,
  cro.sefdisc,
  cro.firecode,
  0 as sh,
  0 as shint,
  0 as shdisc,
  cro.total,
  cro.revperiod,
  cro.partialled
from cashreceipt_rpt cr 
inner join cashreceipt c on cr.objid = c.objid 
inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid 
left join cashreceipt_void cv on c.objid = cv.receiptid 
where cv.objid is null ;



insert into rptledger_payment_share(
  objid,
  parentid,
  revperiod,
  revtype,
  item_objid,
  amount,
  sharetype,
  discount
)
select 
  x.objid,
  x.parentid,
  x.revperiod,
  x.revtype,
  x.item_objid,
  x.amount,
  x.sharetype,
  x.discount
from (
  select
    cra.objid,
    concat(cra.rptledgerid, '-', cra.rptreceiptid) as parentid,
    cra.revperiod,
    cra.revtype,
    cra.item_objid,
    cra.amount,
    cra.sharetype,
    cra.discount
  from cashreceipt_rpt cr 
  inner join cashreceipt c on cr.objid = c.objid 
  inner join cashreceiptitem_rpt_account cra on c.objid = cra.rptreceiptid 
  left join cashreceipt_void cv on c.objid = cv.receiptid 
  where cv.objid is null 
    and cra.rptledgerid is not null 
    and exists(select * from rptledger where objid = cra.rptledgerid)
    and not exists(select * from rptledger_payment_share where objid = cra.objid)
) x 
where exists(select * from rptledger_payment where objid= x.parentid);


insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  objid,
  rptledgerid,
  type,
  null as receiptid,
  refno as receiptno,
  refdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  (basic + basicint - basicdisc + sef + sefint - sefdisc + basicidle + firecode) as amount,
  collectingagency,
  0 as voided 
from rptledger_credit;



alter table rptledgeritem 
  add sh decimal(16,2),
  add shdisc decimal(16,2),
  add shpaid decimal(16,2),
  add shint decimal(16,2);

update rptledgeritem set 
    sh = 0, shdisc=0, shpaid = 0, shint = 0
where sh is null ;


alter table rptledgeritem_qtrly 
  add sh decimal(16,2),
  add shdisc decimal(16,2),
  add shpaid decimal(16,2),
  add shint decimal(16,2);

update rptledgeritem_qtrly set 
    sh = 0, shdisc = 0, shpaid = 0, shint = 0
where sh is null ;



alter table rptledger_compromise_item add sh decimal(16,2);
alter table rptledger_compromise_item add shpaid decimal(16,2);
alter table rptledger_compromise_item add shint decimal(16,2);
alter table rptledger_compromise_item add shintpaid decimal(16,2);

update rptledger_compromise_item set 
    sh = 0, shpaid = 0, shint = 0, shintpaid = 0
where sh is null ;


alter table rptledger_compromise_item_credit add sh decimal(16,2);
alter table rptledger_compromise_item_credit add shint decimal(16,2);

update rptledger_compromise_item_credit set 
    sh = 0, shint = 0
where sh is null ;

/* 254032-03019 */

/*==================================================
*
*  CDU RATING SUPPORT 
*
=====================================================*/

alter table bldgrpu add cdurating varchar(15);

alter table bldgtype add usecdu int;
update bldgtype set usecdu = 0 where usecdu is null;

alter table bldgtype_depreciation 
  add excellent decimal(16,2),
  add verygood decimal(16,2),
  add good decimal(16,2),
  add average decimal(16,2),
  add fair decimal(16,2),
  add poor decimal(16,2),
  add verypoor decimal(16,2),
  add unsound decimal(16,2);



alter table batchgr_error drop column barangayid;
alter table batchgr_error drop column barangay;
alter table batchgr_error drop column tdno;

drop table if exists vw_batchgr_error;
drop view if exists vw_batchgr_error;

create view vw_batchgr_error 
as 
select 
    err.*,
    f.tdno,
    f.prevtdno, 
    f.fullpin as fullpin, 
    rp.pin as pin,
    b.name as barangay,
    o.name as lguname
from batchgr_error err 
inner join faas f on err.objid = f.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rp.barangayid = b.objid 
inner join sys_org o on f.lguid = o.objid;




/*=============================================================
*
* SKETCH 
*
==============================================================*/
CREATE TABLE `faas_sketch` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `drawing` text NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



create index FK_faas_sketch_faas  on faas_sketch(objid);

alter table faas_sketch 
  add constraint FK_faas_sketch_faas foreign key(objid) 
  references faas(objid);


  
/*=============================================================
*
* CUSTOM RPU SUFFIX SUPPORT
*
==============================================================*/  

CREATE TABLE `rpu_type_suffix` (
  `objid` varchar(50) NOT NULL,
  `rputype` varchar(20) NOT NULL,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 



insert into rpu_type_suffix (
  objid, rputype, `from`, `to`
)
values('LAND', 'land', 0, 0),
('BLDG-1001-1999', 'bldg', 1001, 1999),
('MACH-2001-2999', 'mach', 2001, 2999),
('PLANTTREE-3001-6999', 'planttree', 3001, 6999),
('MISC-7001-7999', 'misc', 7001, 7999)
;



/*=============================================================
*
* MEMORANDA TEMPLATE UPDATE 
*
==============================================================*/  
alter table memoranda_template add fields text;

update memoranda_template set fields = '[]' where fields is null;
  


/* 254032-03019.01 */

/*==================================================
*
*  BATCH GR UPDATES
*
=====================================================*/
drop table batchgr_error;
drop table batchgr_items_forrevision;
drop table batchgr_log;
drop view vw_batchgr_error;

CREATE TABLE `batchgr` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `ry` int(255) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `rputype` varchar(15) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `count` int(255) NOT NULL,
  `completed` int(255) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_barangay_objid` on batchgr(`barangay_objid`);
create index `ix_state` on batchgr(`state`);
create index `fk_lgu_objid` on batchgr(`lgu_objid`);

alter table batchgr add constraint `fk_barangay_objid` 
  foreign key (`barangay_objid`) references `barangay` (`objid`);
  
alter table batchgr add constraint `fk_lgu_objid` 
  foreign key (`lgu_objid`) references `sys_org` (`objid`);



CREATE TABLE `batchgr_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `fullpin` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `suffix` int(255) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



create index `fk_batchgr_item_batchgr` on batchgr_item (`parent_objid`);
create index `fk_batchgr_item_newfaasid` on batchgr_item (`newfaasid`);
create index `fk_batchgr_item_tdno` on batchgr_item (`tdno`);
create index `fk_batchgr_item_pin` on batchgr_item (`pin`);


alter table batchgr_item add constraint `fk_batchgr_item_objid` 
	foreign key (`objid`) references `faas` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_batchgr` 
	foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_newfaasid` 
	foreign key (`newfaasid`) references `faas` (`objid`);


CREATE TABLE `batchgr_forprocess` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `fk_batchgr_forprocess_parentid` on batchgr_forprocess(`parent_objid`);

alter table batchgr_forprocess add constraint `fk_batchgr_forprocess_parentid` 
	foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_forprocess add constraint `fk_batchgr_forprocess_objid` 
	foreign key (`objid`) references `batchgr_item` (`objid`);

	/* 254032-03019.02 */

/*==============================================
* EXAMINATION UPDATES
==============================================*/

alter table examiner_finding 
	add inspectedby_objid varchar(50),
	add inspectedby_name varchar(100),
	add inspectedby_title varchar(50),
	add doctype varchar(50)
;

create index ix_examiner_finding_inspectedby_objid on examiner_finding(inspectedby_objid)
;


update examiner_finding e, faas f set 
	e.inspectedby_objid = (select assignee_objid from faas_task where refid = f.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'faas'
where e.parent_objid = f.objid
;

update examiner_finding e, subdivision s set 
	e.inspectedby_objid = (select assignee_objid from subdivision_task where refid = s.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'subdivision'
where e.parent_objid = s.objid
;

update examiner_finding e, consolidation c set 
	e.inspectedby_objid = (select assignee_objid from consolidation_task where refid = c.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'consolidation'
where e.parent_objid = c.objid
;

update examiner_finding e, cancelledfaas c set 
	e.inspectedby_objid = (select assignee_objid from cancelledfaas_task where refid = c.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'cancelledfaas'
where e.parent_objid = c.objid
;



/*======================================================
*
*  ASSESSMENT NOTICE 
*
======================================================*/
alter table assessmentnotice modify column dtdelivered date null
;
alter table assessmentnotice add deliverytype_objid varchar(50)
;
update assessmentnotice set state = 'DELIVERED' where state = 'RECEIVED'
;


drop view if exists vw_assessment_notice
;

create view vw_assessment_notice
as 
select 
	a.objid,
	a.state,
	a.txnno,
	a.txndate,
	a.taxpayerid,
	a.taxpayername,
	a.taxpayeraddress,
	a.dtdelivered,
	a.receivedby,
	a.remarks,
	a.assessmentyear,
	a.administrator_name,
	a.administrator_address,
	fl.tdno,
	fl.displaypin as fullpin,
	fl.cadastrallotno,
	fl.titleno
from assessmentnotice a 
inner join assessmentnoticeitem i on a.objid = i.assessmentnoticeid
inner join faas_list fl on i.faasid = fl.objid
;


drop view if exists vw_assessment_notice_item 
;

create view vw_assessment_notice_item 
as 
select 
	ni.objid,
	ni.assessmentnoticeid, 
	f.objid AS faasid,
	f.effectivityyear,
	f.effectivityqtr,
	f.tdno,
	f.taxpayer_objid,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address,
	f.owner_name,
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	f.rpuid, 
	f.lguid,
	f.txntype_objid, 
	ft.displaycode as txntype_code,
	rpu.rputype,
	rpu.ry,
	rpu.fullpin ,
	rpu.taxable,
	rpu.totalareaha,
	rpu.totalareasqm,
	rpu.totalbmv,
	rpu.totalmv,
	rpu.totalav,
	rp.section,
	rp.parcel,
	rp.surveyno,
	rp.cadastrallotno,
	rp.blockno,
	rp.claimno,
	rp.street,
	o.name as lguname, 
	b.name AS barangay,
	pc.code AS classcode,
	pc.name as classification 
FROM assessmentnoticeitem ni 
	INNER JOIN faas f ON ni.faasid = f.objid 
	LEFT JOIN txnsignatory ts on ts.refid = f.objid and ts.type='APPROVER'
	INNER JOIN rpu rpu ON f.rpuid = rpu.objid
	INNER JOIN propertyclassification pc ON rpu.classification_objid = pc.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN sys_org o ON f.lguid = o.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
	INNER JOIN faas_txntype ft on f.txntype_objid = ft.objid 
;



/*======================================================
*
*  TAX CLEARANCE UPDATE
*
======================================================*/

alter table rpttaxclearance add reporttype varchar(15)
;

update rpttaxclearance set reporttype = 'fullypaid' where reporttype is null
;





/*REVENUE PARENT ACCOUNTS  */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE', 'ACTIVE', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT', 'ACTIVE', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT', 'ACTIVE', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS', 'ACTIVE', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS', 'ACTIVE', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR', 'ACTIVE', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR', 'ACTIVE', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_ADVANCE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_CURRENT', 'ACTIVE', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_CURRENT', 'ACTIVE', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;



alter table itemaccount_tag add objid varchar(50)
;

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
;





/* BARANGAY SHARE PAYABLE */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;



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
;




/*===============================================================
*
* SET PARENT OF BARANGAY ACCOUNTS
*
===============================================================*/

-- advance account 
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_ADVANCE_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicadvacct_objid = i.objid 
and m.barangayid = o.objid
;


-- current account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_CURRENT_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basiccurracct_objid = i.objid 
and m.barangayid = o.objid
;

-- current int account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_CURRENT_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basiccurrintacct_objid = i.objid 
and m.barangayid = o.objid
;



-- previous account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicprevacct_objid = i.objid 
and m.barangayid = o.objid
;



-- prevint account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicprevintacct_objid = i.objid 
and m.barangayid = o.objid
;


-- prior account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_PRIOR_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicprioracct_objid = i.objid 
and m.barangayid = o.objid
;

-- priorint account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_PRIOR_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicpriorintacct_objid = i.objid 
and m.barangayid = o.objid
;



/*============================================================
*
* 254032-03020
*
=============================================================*/
update cashreceiptitem_rpt_account set discount= 0 where discount is null;

alter table rptledger add lguid varchar(50);

update rptledger rl, barangay b, sys_org m set 
  rl.lguid = m.objid 
where rl.barangayid = b.objid 
and b.parentid = m.objid 
and m.orgclass = 'municipality';


update rptledger rl, barangay b, sys_org d, sys_org c set 
  rl.lguid = c.objid
where rl.barangayid = b.objid 
and b.parentid = d.objid 
and d.parent_objid = c.objid 
and d.orgclass = 'district';



create table `rptpayment` (
  `objid` varchar(100) not null,
  `type` varchar(50) default null,
  `refid` varchar(50) not null,
  `reftype` varchar(50) not null,
  `receiptid` varchar(50) default null,
  `receiptno` varchar(50) not null,
  `receiptdate` date not null,
  `paidby_name` longtext not null,
  `paidby_address` varchar(150) not null,
  `postedby` varchar(100) not null,
  `postedbytitle` varchar(50) not null,
  `dtposted` datetime not null,
  `fromyear` int(11) not null,
  `fromqtr` int(11) not null,
  `toyear` int(11) not null,
  `toqtr` int(11) not null,
  `amount` decimal(12,2) not null,
  `collectingagency` varchar(50) default null,
  `voided` int(11) not null,
  primary key(objid)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_cashreceipt` on rptpayment(`receiptid`);
create index `ix_refid` on rptpayment(`refid`);
create index `ix_receiptno` on rptpayment(`receiptno`);

alter table rptpayment 
  add constraint `fk_rptpayment_cashreceipt` 
  foreign key (`receiptid`) references `cashreceipt` (`objid`);



create table `rptpayment_item` (
  `objid` varchar(50) not null,
  `parentid` varchar(100) not null,
  `rptledgerfaasid` varchar(50) default null,
  `year` int(11) not null,
  `qtr` int(11) default null,
  `revtype` varchar(50) not null,
  `revperiod` varchar(25) default null,
  `amount` decimal(16,2) not null,
  `interest` decimal(16,2) not null,
  `discount` decimal(16,2) not null,
  `partialled` int(11) not null,
  `priority` int(11) not null,
  primary key (`objid`)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_item_parentid` on rptpayment_item (`parentid`);
create index `fk_rptpayment_item_rptledgerfaasid` on rptpayment_item (`rptledgerfaasid`);

alter table rptpayment_item
  add constraint `rptpayment_item_rptledgerfaas` foreign key (`rptledgerfaasid`) 
  references `rptledgerfaas` (`objid`);

alter table rptpayment_item
  add constraint `rptpayment_item_rptpayment` foreign key (`parentid`) 
  references `rptpayment` (`objid`);




create table `rptpayment_share` (
  `objid` varchar(50) not null,
  `parentid` varchar(100) default null,
  `revperiod` varchar(25) not null,
  `revtype` varchar(25) not null,
  `sharetype` varchar(25) not null,
  `item_objid` varchar(50) not null,
  `amount` decimal(16,4) not null,
  `discount` decimal(16,4) default null,
  primary key (`objid`)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_share_parentid` on rptpayment_share(`parentid`);
create index `fk_rptpayment_share_item_objid` on  rptpayment_share(`item_objid`);

alter table rptpayment_share add constraint `rptpayment_share_itemaccount` 
  foreign key (`item_objid`) references `itemaccount` (`objid`);

alter table rptpayment_share add constraint `rptpayment_share_rptpayment` 
  foreign key (`parentid`) references `rptpayment` (`objid`);



insert into rptpayment(
  objid,
  type,
  refid,
  reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
)
select
  objid,
  type, 
  rptledgerid as refid,
  'rptledger' as reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
from rptledger_payment;


insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basic') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basic' as revtype,
  revperiod,
  basic as amount,
  basicint as interest,
  basicdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item;





insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sef') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sef' as revtype,
  revperiod,
  sef as amount,
  sefint as interest,
  sefdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item;


insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sh') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sh' as revtype,
  revperiod,
  sh as amount,
  shint as interest,
  shdisc as discount,
  partialled,
  100 as priority
from rptledger_payment_item
where sh > 0;




insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-firecode') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'firecode' as revtype,
  revperiod,
  firecode as amount,
  0 as interest,
  0 as discount,
  partialled,
  50 as priority
from rptledger_payment_item
where firecode > 0
;



insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basicidle') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basicidle' as revtype,
  revperiod,
  basicidle as amount,
  basicidleint as interest,
  basicidledisc as discount,
  partialled,
  200 as priority
from rptledger_payment_item
where basicidle > 0
;



update cashreceipt_rpt set txntype = 'online' where txntype = 'rptonline'
;
update cashreceipt_rpt set txntype = 'manual' where txntype = 'rptmanual'
;
update cashreceipt_rpt set txntype = 'compromise' where txntype = 'rptcompromise'
;

update rptpayment set type = 'online' where type = 'rptonline'
;
update rptpayment set type = 'manual' where type = 'rptmanual'
;
update rptpayment set type = 'compromise' where type = 'rptcompromise'
;






  
create table landtax_report_rptdelinquency (
  objid varchar(50) not null,
  rptledgerid varchar(50) not null,
  barangayid varchar(50) not null,
  year int not null,
  qtr int null,
  revtype varchar(50) not null,
  amount decimal(16,2) not null,
  interest decimal(16,2) not null,
  discount decimal(16,2) not null,
  dtgenerated datetime not null, 
  generatedby_name varchar(255) not null,
  generatedby_title varchar(100) not null,
  primary key (objid)
)engine=innodb default charset=utf8
;




create view vw_rptpayment_item_detail as
select
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled 
from rptpayment_item rpi
;




create view vw_rptpayment_item as
select 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled
from vw_rptpayment_item_detail x
group by 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod
;


create view vw_landtax_report_rptdelinquency_detail 
as
select
  objid,
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from landtax_report_rptdelinquency
;



create view vw_landtax_report_rptdelinquency
as
select
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  sum(basic) as basic,
  sum(basicint) as basicint,
  sum(basicdisc) as basicdisc,
  sum(basicdp) as basicdp,
  sum(basicnet) as basicnet,
  sum(basicidle) as basicidle,
  sum(basicidleint) as basicidleint,
  sum(basicidledisc) as basicidledisc,
  sum(basicidledp) as basicidledp,
  sum(basicidlenet) as basicidlenet,
  sum(sef) as sef,
  sum(sefint) as sefint,
  sum(sefdisc) as sefdisc,
  sum(sefdp) as sefdp,
  sum(sefnet) as sefnet,
  sum(firecode) as firecode,
  sum(firecodeint) as firecodeint,
  sum(firecodedisc) as firecodedisc,
  sum(firecodedp) as firecodedp,
  sum(firecodenet) as firecodenet,
  sum(sh) as sh,
  sum(shint) as shint,
  sum(shdisc) as shdisc,
  sum(shdp) as shdp,
  sum(shnet) as shnet,
  sum(total) as total
from vw_landtax_report_rptdelinquency_detail
group by 
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title
;






create table `rptledger_item` (
  `objid` varchar(50) not null,
  `parentid` varchar(50) not null,
  `rptledgerfaasid` varchar(50) default null,
  `remarks` varchar(100) default null,
  `basicav` decimal(16,2) not null,
  `sefav` decimal(16,2) not null,
  `av` decimal(16,2) not null,
  `revtype` varchar(50) not null,
  `year` int(11) not null,
  `amount` decimal(16,2) not null,
  `amtpaid` decimal(16,2) not null,
  `priority` int(11) not null,
  `taxdifference` int(11) not null,
  `system` int(11) not null,
  primary key (`objid`)
) engine=innodb default charset=utf8
;

create index `fk_rptledger_item_rptledger` on rptledger_item (`parentid`)
; 

alter table rptledger_item 
  add constraint `fk_rptledger_item_rptledger` foreign key (`parentid`) 
  references `rptledger` (`objid`)
;



insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basic') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'basic' as revtype,
  rli.year,
  rli.basic as amount,
  rli.basicpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basic > 0 
and rli.basicpaid < rli.basic
;




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sef') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'sef' as revtype,
  rli.year,
  rli.sef as amount,
  rli.sefpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sef > 0 
and rli.sefpaid < rli.sef
;




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-firecode') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'firecode' as revtype,
  rli.year,
  rli.firecode as amount,
  rli.firecodepaid as amtpaid,
  1 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.firecode > 0 
and rli.firecodepaid < rli.firecode
;



insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basicidle') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'basicidle' as revtype,
  rli.year,
  rli.basicidle as amount,
  rli.basicidlepaid as amtpaid,
  5 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basicidle > 0 
and rli.basicidlepaid < rli.basicidle
;


insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sh') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'sh' as revtype,
  rli.year,
  rli.sh as amount,
  rli.shpaid as amtpaid,
  10 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sh > 0 
and rli.shpaid < rli.sh
;









/*====================================================================================
*
* RPTLEDGER AND RPTBILLING RULE SUPPORT 
*
======================================================================================*/


set @ruleset = 'rptledger' 
;

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)
;
delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
);
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
);
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)
;
delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule where ruleset=@ruleset 
;
delete from sys_ruleset_fact where ruleset=@ruleset
;
delete from sys_ruleset_actiondef where ruleset=@ruleset
;
delete from sys_rulegroup where ruleset=@ruleset 
;
delete from sys_ruleset where name=@ruleset 
;



set @ruleset = 'rptbilling' 
;

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)
;
delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
);
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
);
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)
;
delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule where ruleset=@ruleset 
;
delete from sys_ruleset_fact where ruleset=@ruleset
;
delete from sys_ruleset_actiondef where ruleset=@ruleset
;
delete from sys_rulegroup where ruleset=@ruleset 
;
delete from sys_ruleset where name=@ruleset 
;






INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptbilling', 'RPT Billing Rules', 'rptbilling', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptledger', 'Ledger Billing Rules', 'rptledger', 'LANDTAX', 'RULE_AUTHOR', NULL);


INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LEDGER_ITEM', 'rptledger', 'Ledger Item Posting', '1');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('TAX', 'rptledger', 'Tax Computation', '2');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_TAX', 'rptledger', 'Post Tax Computation', '3');


INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptbilling', 'Init', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DISCOUNT', 'rptbilling', 'Discount Computation', '9');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_DISCOUNT', 'rptbilling', 'After Discount Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PENALTY', 'rptbilling', 'Penalty Computation', '7');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_PENALTY', 'rptbilling', 'After Penalty Computation', '8');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE_SUMMARY', 'rptbilling', 'Before Summary ', '19');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'rptbilling', 'Summary', '20');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_SUMMARY', 'rptbilling', 'After Summary', '21');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BRGY_SHARE', 'rptbilling', 'Barangay Share Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PROV_SHARE', 'rptbilling', 'Province Share Computation', '27');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LGU_SHARE', 'rptbilling', 'LGU Share Computation', '26');






drop view if exists vw_landtax_lgu_account_mapping
; 

create view vw_landtax_lgu_account_mapping
as 
select 
  ia.org_objid as org_objid,
  ia.org_name as org_name, 
  o.orgclass as org_class, 
  p.objid as parent_objid,
  p.code as parent_code,
  p.title as parent_title,
  ia.objid as item_objid,
  ia.code as item_code,
  ia.title as item_title,
  ia.fund_objid as item_fund_objid, 
  ia.fund_code as item_fund_code,
  ia.fund_title as item_fund_title,
  ia.type as item_type,
  pt.tag as item_tag
from itemaccount ia
inner join itemaccount p on ia.parentid = p.objid 
inner join itemaccount_tag pt on p.objid = pt.acctid
inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'APPROVED'
; 









/*=============================================================
*
* COMPROMISE UPDATE 
*
==============================================================*/


CREATE TABLE `rptcompromise` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` date NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `lastyearpaid` int(11) NOT NULL,
  `lastqtrpaid` int(11) NOT NULL,
  `startyear` int(11) NOT NULL,
  `startqtr` int(11) NOT NULL,
  `endyear` int(11) NOT NULL,
  `endqtr` int(11) NOT NULL,
  `enddate` date NOT NULL,
  `cypaymentrequired` int(11) DEFAULT NULL,
  `cypaymentorno` varchar(10) DEFAULT NULL,
  `cypaymentordate` date DEFAULT NULL,
  `cypaymentoramount` decimal(10,2) DEFAULT NULL,
  `downpaymentrequired` int(11) NOT NULL,
  `downpaymentrate` decimal(10,0) NOT NULL,
  `downpayment` decimal(10,2) NOT NULL,
  `downpaymentorno` varchar(50) DEFAULT NULL,
  `downpaymentordate` date DEFAULT NULL,
  `term` int(11) NOT NULL,
  `numofinstallment` int(11) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtforinstallment` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `firstpartyname` varchar(100) NOT NULL,
  `firstpartytitle` varchar(50) NOT NULL,
  `firstpartyaddress` varchar(100) NOT NULL,
  `firstpartyctcno` varchar(15) NOT NULL,
  `firstpartyctcissued` varchar(100) NOT NULL,
  `firstpartyctcdate` date NOT NULL,
  `firstpartynationality` varchar(50) NOT NULL,
  `firstpartystatus` varchar(50) NOT NULL,
  `firstpartygender` varchar(10) NOT NULL,
  `secondpartyrepresentative` varchar(100) NOT NULL,
  `secondpartyname` varchar(100) NOT NULL,
  `secondpartyaddress` varchar(100) NOT NULL,
  `secondpartyctcno` varchar(15) NOT NULL,
  `secondpartyctcissued` varchar(100) NOT NULL,
  `secondpartyctcdate` date NOT NULL,
  `secondpartynationality` varchar(50) NOT NULL,
  `secondpartystatus` varchar(50) NOT NULL,
  `secondpartygender` varchar(10) NOT NULL,
  `dtsigned` date DEFAULT NULL,
  `notarizeddate` date DEFAULT NULL,
  `notarizedby` varchar(100) DEFAULT NULL,
  `notarizedbytitle` varchar(50) DEFAULT NULL,
  `signatories` varchar(1000) NOT NULL,
  `manualdiff` decimal(16,2) NOT NULL DEFAULT '0.00',
  `cypaymentreceiptid` varchar(50) DEFAULT NULL,
  `downpaymentreceiptid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_faasid` on rptcompromise(`faasid`);
create index `ix_rptcompromise_ledgerid` on rptcompromise(`rptledgerid`);
alter table rptcompromise add CONSTRAINT `fk_rptcompromise_faas` 
  FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`);
alter table rptcompromise add CONSTRAINT `fk_rptcompromise_rptledger` 
  FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`);



CREATE TABLE `rptcompromise_installment` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `installmentno` int(11) NOT NULL,
  `duedate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `fullypaid` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_rptcompromise_installment_rptcompromiseid` on rptcompromise_installment(`parentid`);

alter table rptcompromise_installment 
  add CONSTRAINT `fk_rptcompromise_installment_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);



  CREATE TABLE `rptcompromise_credit` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `installmentid` varchar(50) DEFAULT NULL,
  `collector_name` varchar(100) NOT NULL,
  `collector_title` varchar(50) NOT NULL,
  `orno` varchar(10) NOT NULL,
  `ordate` date NOT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `mode` varchar(50) NOT NULL,
  `paidby` varchar(150) NOT NULL,
  `paidbyaddress` varchar(100) NOT NULL,
  `partial` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_credit_parentid` on rptcompromise_credit(`parentid`);
create index `ix_rptcompromise_credit_receiptid` on rptcompromise_credit(`receiptid`);
create index `ix_rptcompromise_credit_installmentid` on rptcompromise_credit(`installmentid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_rptcompromise_installment` 
  FOREIGN KEY (`installmentid`) REFERENCES `rptcompromise_installment` (`objid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_cashreceipt` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);



CREATE TABLE `rptcompromise_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerfaasid` varchar(50) NOT NULL,
  `revtype` varchar(50) NOT NULL,
  `revperiod` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `interestpaid` decimal(16,2) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `taxdifference` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_item_rptcompromise` on rptcompromise_item (`parentid`);
create index `ix_rptcompromise_item_rptledgerfaas` on rptcompromise_item (`rptledgerfaasid`);

alter table rptcompromise_item 
  add CONSTRAINT `fk_rptcompromise_item_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);

alter table rptcompromise_item 
  add CONSTRAINT `fk_rptcompromise_item_rptledgerfaas` 
  FOREIGN KEY (`rptledgerfaasid`) REFERENCES `rptledgerfaas` (`objid`);


/*=============================================================
*
* MIGRATE COMPROMISE RECORDS 
*
==============================================================*/
insert into rptcompromise(
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
)
select 
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
from rptledger_compromise
;


insert into rptcompromise_installment(
    objid,
    parentid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
)
select 
    objid,
    rptcompromiseid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
from rptledger_compromise_installment    
;


insert into rptcompromise_credit(
    objid,
    parentid,
    receiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    amount, 
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
)
select 
    objid,
    rptcompromiseid as parentid,
    rptreceiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    oramount,
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
from rptledger_compromise_credit    
;



insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basic') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'basic' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basic) as amount,
    sum(rci.basicpaid) as amtpaid,
    sum(rci.basicint) as interest,
    sum(rci.basicintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basic > 0 
group by rc.rptledgerid, year, rptcompromiseid
;



insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-sef') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'sef' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.sef) as amount,
    sum(rci.sefpaid) as amtpaid,
    sum(rci.sefint) as interest,
    sum(rci.sefintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.sef > 0
group by rc.rptledgerid, year, rptcompromiseid
;


insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basicidle') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'basicidle' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basicidle) as amount,
    sum(rci.basicidlepaid) as amtpaid,
    sum(rci.basicidleint) as interest,
    sum(rci.basicidleintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
;




insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-firecode') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'firecode' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.firecode) as amount,
    sum(rci.firecodepaid) as amtpaid,
    sum(0) as interest,
    sum(0) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
;





/*====================================================================
*
* LANDTAX RPT DELINQUENCY UPDATE 
*
====================================================================*/

drop table if exists report_rptdelinquency_error
;
drop table if exists report_rptdelinquency_forprocess
;
drop table if exists report_rptdelinquency_item
;
drop table if exists report_rptdelinquency_barangay
;
drop table if exists report_rptdelinquency
;



CREATE TABLE `report_rptdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtgenerated` datetime NOT NULL,
  `dtcomputed` datetime NOT NULL,
  `generatedby_name` varchar(255) NOT NULL,
  `generatedby_title` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) DEFAULT NULL,
  `revtype` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `discount` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;



create index fk_rptdelinquency_item_rptdelinquency_parentid on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptledger foreign key(rptledgerid)
  references rptledger(objid)
;

create index fk_rptdelinquency_item_rptledger_rptledgerid on report_rptdelinquency_item(rptledgerid)  
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_barangay foreign key(barangayid)
  references barangay(objid)
;

create index fk_rptdelinquency_item_barangay_barangayid on report_rptdelinquency_item(barangayid)  
;




CREATE TABLE `report_rptdelinquency_barangay` (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  `barangayid` varchar(50) NOT NULL,
  count int not null,
  processed int not null, 
  errors int not null, 
  ignored int not null, 
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index fk_rptdelinquency_barangay_rptdelinquency on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_barangay foreign key(barangayid)
  references barangay(objid)
;



create index fk_rptdelinquency_barangay_barangayid on report_rptdelinquency_barangay(barangayid)  
;


CREATE TABLE `report_rptdelinquency_forprocess` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index ix_barangayid on report_rptdelinquency_forprocess(barangayid);
  


CREATE TABLE `report_rptdelinquency_error` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `error` text NULL,
  `ignored` int,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;  




drop view vw_landtax_report_rptdelinquency_detail
;

create view vw_landtax_report_rptdelinquency_detail 
as
select
  parentid, 
  rptledgerid,
  barangayid,
  year,
  qtr,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from report_rptdelinquency_item 
;



/*====================================================================
*
* LANDTAX RPT DELINQUENCY UPDATE 
*
====================================================================*/

drop table if exists report_rptdelinquency_error
;
drop table if exists report_rptdelinquency_forprocess
;
drop table if exists report_rptdelinquency_item
;
drop table if exists report_rptdelinquency_barangay
;
drop table if exists report_rptdelinquency
;



CREATE TABLE `report_rptdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtgenerated` datetime NOT NULL,
  `dtcomputed` datetime NOT NULL,
  `generatedby_name` varchar(255) NOT NULL,
  `generatedby_title` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) DEFAULT NULL,
  `revtype` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `discount` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;


create index fk_rptdelinquency_item_rptdelinquency_parentid on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptledger foreign key(rptledgerid)
  references rptledger(objid)
;

create index fk_rptdelinquency_item_rptledger_rptledgerid on report_rptdelinquency_item(rptledgerid)  
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_barangay foreign key(barangayid)
  references barangay(objid)
;

create index fk_rptdelinquency_item_barangay_barangayid on report_rptdelinquency_item(barangayid)  
;




CREATE TABLE `report_rptdelinquency_barangay` (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  `barangayid` varchar(50) NOT NULL,
  count int not null,
  processed int not null, 
  errors int not null, 
  ignored int not null, 
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index fk_rptdelinquency_barangay_rptdelinquency on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_barangay foreign key(barangayid)
  references barangay(objid)
;


create index fk_rptdelinquency_barangay_barangayid on report_rptdelinquency_barangay(barangayid)  
;


CREATE TABLE `report_rptdelinquency_forprocess` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index ix_barangayid on report_rptdelinquency_forprocess(barangayid);
  


CREATE TABLE `report_rptdelinquency_error` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `error` text NULL,
  `ignored` int,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;  




drop view vw_landtax_report_rptdelinquency_detail
;

create view vw_landtax_report_rptdelinquency_detail 
as
select
  parentid, 
  rptledgerid,
  barangayid,
  year,
  qtr,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from report_rptdelinquency_item 
;




drop  view vw_landtax_report_rptdelinquency
;

create view vw_landtax_report_rptdelinquency
as
select
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title,
  sum(v.basic) as basic,
  sum(v.basicint) as basicint,
  sum(v.basicdisc) as basicdisc,
  sum(v.basicdp) as basicdp,
  sum(v.basicnet) as basicnet,
  sum(v.basicidle) as basicidle,
  sum(v.basicidleint) as basicidleint,
  sum(v.basicidledisc) as basicidledisc,
  sum(v.basicidledp) as basicidledp,
  sum(v.basicidlenet) as basicidlenet,
  sum(v.sef) as sef,
  sum(v.sefint) as sefint,
  sum(v.sefdisc) as sefdisc,
  sum(v.sefdp) as sefdp,
  sum(v.sefnet) as sefnet,
  sum(v.firecode) as firecode,
  sum(v.firecodeint) as firecodeint,
  sum(v.firecodedisc) as firecodedisc,
  sum(v.firecodedp) as firecodedp,
  sum(v.firecodenet) as firecodenet,
  sum(v.sh) as sh,
  sum(v.shint) as shint,
  sum(v.shdisc) as shdisc,
  sum(v.shdp) as shdp,
  sum(v.shnet) as shnet,
  sum(v.total) as total
from report_rptdelinquency rr 
inner join vw_landtax_report_rptdelinquency_detail v on rr.objid = v.parentid 
group by 
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title
;



drop  view vw_landtax_report_rptdelinquency
;

create view vw_landtax_report_rptdelinquency
as
select
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title,
  sum(v.basic) as basic,
  sum(v.basicint) as basicint,
  sum(v.basicdisc) as basicdisc,
  sum(v.basicdp) as basicdp,
  sum(v.basicnet) as basicnet,
  sum(v.basicidle) as basicidle,
  sum(v.basicidleint) as basicidleint,
  sum(v.basicidledisc) as basicidledisc,
  sum(v.basicidledp) as basicidledp,
  sum(v.basicidlenet) as basicidlenet,
  sum(v.sef) as sef,
  sum(v.sefint) as sefint,
  sum(v.sefdisc) as sefdisc,
  sum(v.sefdp) as sefdp,
  sum(v.sefnet) as sefnet,
  sum(v.firecode) as firecode,
  sum(v.firecodeint) as firecodeint,
  sum(v.firecodedisc) as firecodedisc,
  sum(v.firecodedp) as firecodedp,
  sum(v.firecodenet) as firecodenet,
  sum(v.sh) as sh,
  sum(v.shint) as shint,
  sum(v.shdisc) as shdisc,
  sum(v.shdp) as shdp,
  sum(v.shnet) as shnet,
  sum(v.total) as total
from report_rptdelinquency rr 
inner join vw_landtax_report_rptdelinquency_detail v on rr.objid = v.parentid 
group by 
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title
;


/* 03021 */

/*============================================
*
* TAX DIFFERENCE
*
*============================================*/

CREATE TABLE `rptledger_avdifference` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `rptledgerfaas_objid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `av` decimal(16,2) NOT NULL,
  `paid` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index `fk_rptledger` on rptledger_avdifference (`parent_objid`)
;

create index `fk_rptledgerfaas` on rptledger_avdifference (`rptledgerfaas_objid`)
;
 
alter table rptledger_avdifference 
	add CONSTRAINT `fk_rptledgerfaas` FOREIGN KEY (`rptledgerfaas_objid`) 
	REFERENCES `rptledgerfaas` (`objid`)
;

alter table rptledger_avdifference 
	add CONSTRAINT `fk_rptledger` FOREIGN KEY (`parent_objid`) 
	REFERENCES `rptledger` (`objid`)
;



create view vw_rptledger_avdifference
as 
select 
  rlf.objid,
  'APPROVED' as state,
  d.parent_objid as rptledgerid,
  rl.faasid,
  rl.tdno,
  rlf.txntype_objid,
  rlf.classification_objid,
  rlf.actualuse_objid,
  rlf.taxable,
  rlf.backtax,
  d.year as fromyear,
  1 as fromqtr,
  d.year as toyear,
  4 as toqtr,
  d.av as assessedvalue,
  1 as systemcreated,
  rlf.reclassed,
  rlf.idleland,
  1 as taxdifference
from rptledger_avdifference d 
inner join rptledgerfaas rlf on d.rptledgerfaas_objid = rlf.objid 
inner join rptledger rl on d.parent_objid = rl.objid 
; 

/* 03022 */

/*============================================
*
* SYNC PROVINCE AND REMOTE LEGERS
*
*============================================*/
drop table if exists `rptledger_remote`;

CREATE TABLE `remote_mapping` (
  `objid` varchar(50) NOT NULL,
  `doctype` varchar(50) NOT NULL,
  `remote_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtcreated` datetime NOT NULL,
  `orgcode` varchar(10) DEFAULT NULL,
  `remote_orgcode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index ix_doctype on remote_mapping(doctype);
create index ix_orgcode on remote_mapping(orgcode);
create index ix_remote_orgcode on remote_mapping(remote_orgcode);
create index ix_remote_objid on remote_mapping(remote_objid);




drop table if exists sync_data_forprocess;
drop table if exists sync_data_pending;
drop table if exists sync_data;


create table `sync_data` (
  `objid` varchar(50) not null,
  `parentid` varchar(50) not null,
  `refid` varchar(50) not null,
  `reftype` varchar(50) not null,
  `action` varchar(50) not null,
  `orgid` varchar(50) null,
  `remote_orgid` varchar(50) null,
  `remote_orgcode` varchar(20) null,
  `remote_orgclass` varchar(20) null,
  `dtfiled` datetime not null,
  `idx` int not null,
  `sender_objid` varchar(50) null,
  `sender_name` varchar(150) null,
  primary key (`objid`)
) engine=innodb default charset=utf8
;


create index ix_sync_data_refid on sync_data(refid)
;

create index ix_sync_data_reftype on sync_data(reftype)
;

create index ix_sync_data_orgid on sync_data(orgid)
;

create index ix_sync_data_dtfiled on sync_data(dtfiled)
;



CREATE TABLE `sync_data_forprocess` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table sync_data_forprocess add constraint `fk_sync_data_forprocess_sync_data` 
  foreign key (`objid`) references `sync_data` (`objid`)
;

CREATE TABLE `sync_data_pending` (
  `objid` varchar(50) NOT NULL,
  `error` text,
  `expirydate` datetime,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table sync_data_pending add constraint `fk_sync_data_pending_sync_data` 
  foreign key (`objid`) references `sync_data` (`objid`)
;

create index ix_expirydate on sync_data_pending(expirydate)
;








/*==================================================
*
*  BATCH GR UPDATES
*
=====================================================*/
drop view if exists vw_batchgr_error;
drop table if exists batchgr_log;
drop table if exists batchgr_error;
drop table if exists batchgr_items_forrevision;
drop table if exists batchgrerror;
drop table if exists batchgr_forprocess;
drop table if exists batchgr_item;
drop table if exists batchgr;

CREATE TABLE `batchgr` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `ry` int(255) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `rputype` varchar(15) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `memoranda` varchar(100) DEFAULT NULL,
  `appraiser_name` varchar(150) DEFAULT NULL,
  `appraiser_dtsigned` date DEFAULT NULL,
  `taxmapper_name` varchar(150) DEFAULT NULL,
  `taxmapper_dtsigned` date DEFAULT NULL,
  `recommender_name` varchar(150) DEFAULT NULL,
  `recommender_dtsigned` date DEFAULT NULL,
  `approver_name` varchar(150) DEFAULT NULL,
  `approver_dtsigned` date DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_barangay_objid` on batchgr(`barangay_objid`);
create index `ix_state` on batchgr(`state`);
create index `fk_lgu_objid` on batchgr(`lgu_objid`);

alter table batchgr add constraint `fk_barangay_objid` 
  foreign key (`barangay_objid`) references `barangay` (`objid`);
  
alter table batchgr add constraint `fk_lgu_objid` 
  foreign key (`lgu_objid`) references `sys_org` (`objid`);



CREATE TABLE `batchgr_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `fullpin` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `suffix` int(255) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `fk_batchgr_item_batchgr` on batchgr_item (`parent_objid`);
create index `fk_batchgr_item_newfaasid` on batchgr_item (`newfaasid`);
create index `fk_batchgr_item_tdno` on batchgr_item (`tdno`);
create index `fk_batchgr_item_pin` on batchgr_item (`pin`);


alter table batchgr_item add constraint `fk_batchgr_item_objid` 
  foreign key (`objid`) references `faas` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_batchgr` 
  foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_newfaasid` 
  foreign key (`newfaasid`) references `faas` (`objid`);




alter table faas modify column prevtdno varchar(1000);

create index ix_prevtdno on faas(prevtdno);






create view vw_txn_log 
as 
select 
  distinct
  u.objid as userid, 
  u.name as username, 
  txndate, 
  ref,
  action, 
  1 as cnt 
from txnlog t
inner join sys_user u on t.userid = u.objid 

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'faas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from faas_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'subdivision' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'consolidation' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%consolidation%'

union 


select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'cancelledfaas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%cancelledfaas%'
;



/*===================================================
* DELINQUENCY UPDATE 
====================================================*/


alter table report_rptdelinquency_barangay add idx int
;

update report_rptdelinquency_barangay set idx = 0 where idx is null
;


create view vw_faas_lookup
as 
SELECT 
f.*,
e.name as taxpayer_name, 
e.address_text as taxpayer_address,
pc.code AS classification_code, 
pc.code AS classcode, 
pc.name AS classification_name, 
pc.name AS classname, 
r.ry, r.rputype, r.totalmv, r.totalav,
r.totalareasqm, r.totalareaha, r.suffix, r.rpumasterid, 
rp.barangayid, rp.cadastrallotno, rp.blockno, rp.surveyno, rp.pintype, 
rp.section, rp.parcel, rp.stewardshipno, rp.pin, 
b.name AS barangay_name 
FROM faas f 
INNER JOIN faas_list fl on f.objid = fl.objid 
INNER JOIN rpu r ON f.rpuid = r.objid 
INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
INNER JOIN barangay b ON rp.barangayid = b.objid 
INNER JOIN entity e on f.taxpayer_objid = e.objid
;

drop  view if exists vw_rptpayment_item_detail
;

create view vw_rptpayment_item_detail
as 
select
  rpi.objid,
  rpi.parentid,
  rp.refid as rptledgerid, 
  rpi.rptledgerfaasid,
  rpi.year,
  rpi.qtr,
  rpi.revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled,
  rp.voided 
from rptpayment_item rpi
inner join rptpayment rp on rpi.parentid = rp.objid
;

drop view if exists vw_rptpayment_item 
;

create view vw_rptpayment_item 
as 
select 
    x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled,
    x.voided 
from vw_rptpayment_item_detail x
group by 
  x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    x.voided
;



alter table faas drop key ix_canceldate
;


alter table faas modify column canceldate date 
;

create index ix_faas_canceldate on faas(canceldate)
;




alter table machdetail modify column depreciation decimal(16,6)
;

delete from sys_wf_transition where processname ='resection';
delete from sys_wf_node where processname ='resection';

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('start', 'resection', 'Start', 'start', '1', NULL, 'RPT', NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('receiver', 'resection', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-examiner', 'resection', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('examiner', 'resection', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-taxmapper', 'resection', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('taxmapper', 'resection', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-taxmapping-approval', 'resection', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('taxmapper_chief', 'resection', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-appraiser', 'resection', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('appraiser', 'resection', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-appraisal-chief', 'resection', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('appraiser_chief', 'resection', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-recommender', 'resection', 'For Recommending Aprpoval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSISTANT_ASSESSOR');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('recommender', 'resection', 'Assessor Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSISTANT_ASSESSOR');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-approver', 'resection', 'Assign Approver', 'state', '76', NULL, 'RPT', 'APPROVER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('approver', 'resection', 'Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('cityapprover', 'resection', 'City Approver', 'state', '100', NULL, 'RPT', 'APPROVER');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-record', 'resection', 'For Record Section', 'state', '101', NULL, 'RPT', 'RECORD');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('record', 'resection', 'Record', 'state', '105', NULL, 'RPT', 'RECORD');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('assign-release', 'resection', 'For Release', 'state', '110', NULL, 'RPT', 'RELEASING');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('release', 'resection', 'Release', 'state', '115', NULL, 'RPT', 'RELEASING');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`) VALUES ('end', 'resection', 'End', 'end', '1000', NULL, 'RPT', NULL);

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('start', 'resection', '', 'receiver', '1', NULL, NULL, 'RECEIVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'resection', 'submit_examiner', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\']', 'RECEIVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'resection', 'submit_taxmapper', 'assign-taxmapper', '5', NULL, '[caption:\'Submit For Taxmapping\', confirm:\'Submit?\']', 'RECEIVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('receiver', 'resection', 'delete', 'end', '6', NULL, '[caption:\'Delete\', confirm:\'Delete?\', closeonend:true]', 'RECEIVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-examiner', 'resection', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', 'EXAMINER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('examiner', 'resection', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', 'EXAMINER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('examiner', 'resection', 'submit', 'assign-taxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit?\']', 'EXAMINER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-taxmapper', 'resection', '', 'taxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', 'TAXMAPPER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'resection', 'returnexaminer', 'examiner', '25', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', 'TAXMAPPER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('taxmapper', 'resection', 'submit', 'assign-appraiser', '26', NULL, '[caption:\'Submit for Appraisal\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', 'TAXMAPPER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-appraiser', 'resection', '', 'appraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', 'APPRAISER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('appraiser', 'resection', 'returntaxmapper', 'taxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', 'APPRAISER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('appraiser', 'resection', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', 'APPRAISER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('appraiser', 'resection', 'submit', 'assign-recommender', '47', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'default\']', 'APPRAISER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-recommender', 'resection', '', 'recommender', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', 'RECOMMENDER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'resection', 'returnexaminer', 'examiner', '75', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', 'RECOMMENDER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'resection', 'returntaxmapper', 'taxmapper', '76', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', 'RECOMMENDER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'resection', 'returnappraiser', 'appraiser', '77', NULL, '[caption:\'Return to Appraiser\', confirm:\'Return to appraiser?\', messagehandler:\'default\']', 'RECOMMENDER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('recommender', 'resection', 'submit', 'assign-approver', '78', NULL, '[caption:\'Submit to Assessor\', confirm:\'Submit to Assessor Approval\', messagehandler:\'default\']', 'RECOMMENDER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-approver', 'resection', '', 'approver', '80', NULL, '[caption:\'Assign to Me\', confirm:\'Assign task to you?\']', 'APPROVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('approver', 'resection', 'approve', 'cityapprover', '81', NULL, '[caption:\'Approve\', confirm:\'Assign task to you?\', messagehandler:\'default\']', 'APPROVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('approver', 'resection', 'return_recommender', 'recommender', '82', NULL, '[caption:\'Return to Recommender\',confirm:\'Return to Recommender?\', messagehandler:\'default\']', 'APPROVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('approver', 'resection', 'return_taxmapper', 'taxmapper', '83', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to Taxmapper?\', messagehandler:\'default\']', 'APPROVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('approver', 'resection', 'return_appraiser', 'appraiser', '84', NULL, '[caption:\'Return to Appraiser\',confirm:\'Return to Appraiser?\', messagehandler:\'default\']', 'APPROVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('cityapprover', 'resection', 'backapprover', 'approver', '85', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', 'APPROVER');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('cityapprover', 'resection', 'completed', 'assign-record', '95', NULL, '[caption:\'Approved\', visible:false]', '');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-record', 'resection', '', 'record', '105', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', '');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('record', 'resection', 'submit', 'assign-release', '110', NULL, '[caption:\'Submit for Releasing\',confirm:\'Submit for releasing?\',messagehandler:\'default\']', '');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('assign-release', 'resection', '', 'release', '115', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', '');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`) VALUES ('release', 'resection', 'submit', 'end', '120', NULL, '[caption:\'Receive Documents\',confirm:\'Receive documents?\',messagehandler:\'default\', closeonend:false]', '');

/* 255-03001 */

-- create tables: resection and resection_item

drop table if exists resectionaffectedrpu;
drop table if exists resectionitem;
drop table if exists resection_item;
drop table if exists resection;

CREATE TABLE `resection` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `pintype` varchar(3) NOT NULL,
  `section` varchar(3) NOT NULL,
  `originlgu_objid` varchar(50) NOT NULL,
  `memoranda` varchar(255) DEFAULT NULL,
  `taskid` varchar(50) DEFAULT NULL,
  `taskstate` varchar(50) DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_resection_txnno` (`txnno`),
  KEY `FK_resection_lgu_org` (`lgu_objid`),
  KEY `FK_resection_barangay_org` (`barangay_objid`),
  KEY `FK_resection_originlgu_org` (`originlgu_objid`),
  KEY `ix_resection_state` (`state`),
  CONSTRAINT `FK_resection_barangay_org` FOREIGN KEY (`barangay_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `FK_resection_lgu_org` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `FK_resection_originlgu_org` FOREIGN KEY (`originlgu_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `resection_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  `faas_rputype` varchar(15) NOT NULL,
  `faas_pin` varchar(25) NOT NULL,
  `faas_suffix` int(255) NOT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `newfaas_rpuid` varchar(50) DEFAULT NULL,
  `newfaas_rpid` varchar(50) DEFAULT NULL,
  `newfaas_section` varchar(3) DEFAULT NULL,
  `newfaas_parcel` varchar(3) DEFAULT NULL,
  `newfaas_suffix` int(255) DEFAULT NULL,
  `newfaas_tdno` varchar(25) DEFAULT NULL,
  `newfaas_fullpin` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_resection_item_tdno` (`newfaas_tdno`) USING BTREE,
  KEY `FK_resection_item_item` (`parent_objid`),
  KEY `FK_resection_item_faas` (`faas_objid`),
  KEY `FK_resection_item_newfaas` (`newfaas_objid`),
  KEY `ix_resection_item_fullpin` (`newfaas_fullpin`),
  CONSTRAINT `FK_resection_item_faas` FOREIGN KEY (`faas_objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `FK_resection_item_item` FOREIGN KEY (`parent_objid`) REFERENCES `resection` (`objid`),
  CONSTRAINT `FK_resection_item_newfaas` FOREIGN KEY (`newfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `resection_task` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `parentprocessid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `assignee_title` varchar(80) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `actor_title` varchar(80) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `signature` longtext,
  PRIMARY KEY (`objid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

/* 255-03001 */
alter table rptcertification add properties text;

	
alter table faas_signatory 
    add reviewer_objid varchar(50),
    add reviewer_name varchar(100),
    add reviewer_title varchar(75),
    add reviewer_dtsigned datetime,
    add reviewer_taskid varchar(50),
    add assessor_name varchar(100),
    add assessor_title varchar(100);

alter table cancelledfaas_signatory 
    add reviewer_objid varchar(50),
    add reviewer_name varchar(100),
    add reviewer_title varchar(75),
    add reviewer_dtsigned datetime,
    add reviewer_taskid varchar(50),
    add assessor_name varchar(100),
    add assessor_title varchar(100);



    
drop table if exists rptacknowledgement_item
;
drop table if exists rptacknowledgement
;


CREATE TABLE `rptacknowledgement` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `pin` varchar(25) DEFAULT NULL,
  `createdby_objid` varchar(25) DEFAULT NULL,
  `createdby_name` varchar(25) DEFAULT NULL,
  `createdby_title` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_txnno` (`txnno`),
  KEY `ix_rptacknowledgement_pin` (`pin`),
  KEY `ix_rptacknowledgement_taxpayerid` (`taxpayer_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `rptacknowledgement_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `trackingno` varchar(25) NULL,
  `faas_objid` varchar(50) DEFAULT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rptacknowledgement_item 
  add constraint fk_rptacknowledgement_item_rptacknowledgement
  foreign key (parent_objid) references rptacknowledgement(objid)
;

create index ix_rptacknowledgement_parentid on rptacknowledgement_item(parent_objid)
;

create unique index ux_rptacknowledgement_itemno on rptacknowledgement_item(trackingno)
;

create index ix_rptacknowledgement_item_faasid  on rptacknowledgement_item(faas_objid)
;

create index ix_rptacknowledgement_item_newfaasid on rptacknowledgement_item(newfaas_objid)
;

drop view if exists vw_faas_lookup 
;


CREATE view vw_faas_lookup AS 
select 
  fl.objid AS objid,
  fl.state AS state,
  fl.rpuid AS rpuid,
  fl.utdno AS utdno,
  fl.tdno AS tdno,
  fl.txntype_objid AS txntype_objid,
  fl.effectivityyear AS effectivityyear,
  fl.effectivityqtr AS effectivityqtr,
  fl.taxpayer_objid AS taxpayer_objid,
  fl.owner_name AS owner_name,
  fl.owner_address AS owner_address,
  fl.prevtdno AS prevtdno,
  fl.cancelreason AS cancelreason,
  fl.cancelledbytdnos AS cancelledbytdnos,
  fl.lguid AS lguid,
  fl.realpropertyid AS realpropertyid,
  fl.displaypin AS fullpin,
  fl.originlguid AS originlguid,
  e.name AS taxpayer_name,
  e.address_text AS taxpayer_address,
  pc.code AS classification_code,
  pc.code AS classcode,
  pc.name AS classification_name,
  pc.name AS classname,
  fl.ry AS ry,
  fl.rputype AS rputype,
  fl.totalmv AS totalmv,
  fl.totalav AS totalav,
  fl.totalareasqm AS totalareasqm,
  fl.totalareaha AS totalareaha,
  fl.barangayid AS barangayid,
  fl.cadastrallotno AS cadastrallotno,
  fl.blockno AS blockno,
  fl.surveyno AS surveyno,
  fl.pin AS pin,
  fl.barangay AS barangay_name,
  fl.trackingno
from faas_list fl
left join propertyclassification pc on fl.classification_objid = pc.objid
left join entity e on fl.taxpayer_objid = e.objid
;


alter table faas modify column prevtdno varchar(800);
alter table faas_list  
  modify column prevtdno varchar(800),
  modify column owner_name varchar(5000),
  modify column cadastrallotno varchar(900);


create index ix_faaslist_txntype_objid on faas_list(txntype_objid);



alter table rptledger modify column prevtdno varchar(800);
create index ix_rptledger_prevtdno on rptledger(prevtdno);
create index ix_rptledgerfaas_tdno on rptledgerfaas(tdno);

  
alter table rptledger modify column owner_name varchar(1500) not null;
create index ix_rptledger_owner_name on rptledger(owner_name);

/* SUBLEDGER : add beneficiary info */

alter table rptledger add beneficiary_objid varchar(50);
create index ix_beneficiary_objid on rptledger(beneficiary_objid);


/* COMPROMISE UPDATE */
alter table rptcompromise_item add qtr int;

/* 255-03012 */

/*=====================================
* LEDGER TAG
=====================================*/
CREATE TABLE `rptledger_tag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `tag` varchar(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rptledgertag_rptledger` (`parent_objid`),
  UNIQUE KEY `ux_rptledger_tag` (`parent_objid`,`tag`),
  CONSTRAINT `FK_rptledgertag_rptledger` FOREIGN KEY (`parent_objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

/* 255-03013 */
alter table resection_item add newfaas_claimno varchar(25);
alter table resection_item add faas_claimno varchar(25);

/* 255-03015 */

CREATE TABLE `rptcertification_online` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `reftype` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` date DEFAULT NULL,
  `oramount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orno` (`orno`),
  CONSTRAINT `fk_rptcertification_online_rptcertification` FOREIGN KEY (`objid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `assessmentnotice_online` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `reftype` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` date DEFAULT NULL,
  `oramount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orno` (`orno`),
  CONSTRAINT `fk_assessmentnotice_online_assessmentnotice` FOREIGN KEY (`objid`) REFERENCES `assessmentnotice` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



/*===============================================================
**
** FAAS ANNOTATION
**
===============================================================*/
CREATE TABLE `faasannotation_faas` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faasannotation foreign key(parent_objid)
references faasannotation (objid)
;

alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faas foreign key(faas_objid)
references faas (objid)
;

create index ix_parent_objid on faasannotation_faas(parent_objid)
;

create index ix_faas_objid on faasannotation_faas(faas_objid)
;


create unique index ux_parent_faas on faasannotation_faas(parent_objid, faas_objid)
;

alter table faasannotation modify column faasid varchar(50) null
;



-- insert annotated faas
insert into faasannotation_faas(
  objid, 
  parent_objid,
  faas_objid 
)
select 
  objid, 
  objid as parent_objid,
  faasid as faas_objid 
from faasannotation
;



/*============================================
*
*  LEDGER FAAS FACTS
*
=============================================*/
INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('rptledger_rule_include_ledger_faases', '0', 'Include Ledger FAASes as rule facts', 'checkbox', 'LANDTAX')
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('rptledger_post_ledgerfaas_by_actualuse', '0', 'Post by Ledger FAAS by actual use', 'checkbox', 'LANDTAX')
;

/* 255-03016 */

/*================================================================
*
* RPTLEDGER REDFLAG
*
================================================================*/

CREATE TABLE `rptledger_redflag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `caseno` varchar(25) NULL,
  `dtfiled` datetime NULL,
  `type` varchar(25) NOT NULL,
  `finding` text,
  `remarks` text,
  `blockaction` varchar(25) DEFAULT NULL,
  `filedby_objid` varchar(50) DEFAULT NULL,
  `filedby_name` varchar(255) DEFAULT NULL,
  `filedby_title` varchar(50) DEFAULT NULL,
  `resolvedby_objid` varchar(50) DEFAULT NULL,
  `resolvedby_name` varchar(255) DEFAULT NULL,
  `resolvedby_title` varchar(50) DEFAULT NULL,
  `dtresolved` datetime NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parent_objid on rptledger_redflag(parent_objid)
;
create index ix_state on rptledger_redflag(state)
;
create unique index ux_caseno on rptledger_redflag(caseno)
;
create index ix_type on rptledger_redflag(type)
;
create index ix_filedby_objid on rptledger_redflag(filedby_objid)
;
create index ix_resolvedby_objid on rptledger_redflag(resolvedby_objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_rptledger foreign key (parent_objid)
references rptledger(objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_filedby foreign key (filedby_objid)
references sys_user(objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_resolvedby foreign key (resolvedby_objid)
references sys_user(objid)
;





/*==================================================
* RETURNED TASK 
==================================================*/
alter table faas_task add returnedby varchar(100)
;
alter table subdivision_task add returnedby varchar(100)
;
alter table consolidation_task add returnedby varchar(100)
;
alter table cancelledfaas_task add returnedby varchar(100)
;
alter table resection_task add returnedby varchar(100)
;



/* 255-03017 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/

alter table rptpayment_share 
	add iscommon int,
	add `year` int
;

update rptpayment_share set iscommon = 0 where iscommon is null 
;


CREATE TABLE `cashreceipt_rpt_share_forposting` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `error` int(255) NOT NULL,
  `msg` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


create UNIQUE index `ux_receiptid_rptledgerid` on cashreceipt_rpt_share_forposting (`receiptid`,`rptledgerid`)
;
create index `fk_cashreceipt_rpt_share_forposing_rptledger` on cashreceipt_rpt_share_forposting (`rptledgerid`)
;
create index `fk_cashreceipt_rpt_share_forposing_cashreceipt` on cashreceipt_rpt_share_forposting (`receiptid`)
;

alter table cashreceipt_rpt_share_forposting add CONSTRAINT `fk_cashreceipt_rpt_share_forposing_rptledger` 
FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
;
alter table cashreceipt_rpt_share_forposting add CONSTRAINT `fk_cashreceipt_rpt_share_forposing_cashreceipt` 
FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`)
;




/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date;

delete from sys_wf_transition where processname = 'batchgr'
;
delete from sys_wf_node where processname = 'batchgr'
;

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-receiver', 'batchgr', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forapproval', 'batchgr', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-approver', 'batchgr', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'batchgr', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'batchgr', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-receiver', 'batchgr', '', 'receiver', '2', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'batchgr', 'submit', 'assign-provtaxmapper', '5', NULL, '[caption:\'Submit For Taxmapping\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapper', 'batchgr', '', 'provtaxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'batchgr', 'returnexaminer', 'examiner', '25', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'batchgr', 'submit', 'assign-provappraiser', '26', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:sign\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provappraiser', 'batchgr', '', 'provappraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'batchgr', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'batchgr', 'submit', 'assign-approver', '47', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:sign\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-approver', 'batchgr', '', 'approver', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'batchgr', 'approve', 'provapprover', '90', NULL, '[caption:\'Approve\', confirm:\'Approve record?\', messagehandler:\'rptmessage:sign\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', NULL, NULL, NULL);

/* 255-03018 */

/*==================================================
**
** ONLINE BATCH GR 
**
===================================================*/
drop table if exists zz_tmp_batchgr_item 
;
drop table if exists zz_tmp_batchgr
;

create table zz_tmp_batchgr 
select * from batchgr
;

create table zz_tmp_batchgr_item 
select * from batchgr_item
;

drop table if exists batchgr_task
;

alter table batchgr 
  add txntype_objid varchar(50),
  add txnno varchar(25),
  add txndate datetime,
  add effectivityyear int,
  add effectivityqtr int,
  add originlgu_objid varchar(50)
;


create index ix_ry on batchgr(ry)
;
create index ix_txnno on batchgr(txnno)
;
create index ix_classificationid on batchgr(classification_objid)
;
create index ix_section on batchgr(section)
;

alter table batchgr 
add constraint fk_batchgr_lguid foreign key(lgu_objid) 
references sys_org(objid)
;

alter table batchgr 
add constraint fk_batchgr_barangayid foreign key(barangay_objid) 
references sys_org(objid)
;

alter table batchgr 
add constraint fk_batchgr_classificationid foreign key(classification_objid) 
references propertyclassification(objid)
;


alter table batchgr_item add subsuffix int
;

alter table batchgr_item 
add constraint fk_batchgr_item_faas foreign key(objid) 
references faas(objid)
;

create table `batchgr_task` (
  `objid` varchar(50) not null,
  `refid` varchar(50) default null,
  `parentprocessid` varchar(50) default null,
  `state` varchar(50) default null,
  `startdate` datetime default null,
  `enddate` datetime default null,
  `assignee_objid` varchar(50) default null,
  `assignee_name` varchar(100) default null,
  `assignee_title` varchar(80) default null,
  `actor_objid` varchar(50) default null,
  `actor_name` varchar(100) default null,
  `actor_title` varchar(80) default null,
  `message` varchar(255) default null,
  `signature` longtext,
  `returnedby` varchar(100) default null,
  primary key (`objid`),
  key `ix_assignee_objid` (`assignee_objid`),
  key `ix_refid` (`refid`)
) engine=innodb default charset=utf8;

alter table batchgr_task 
add constraint fk_batchgr_task_batchgr foreign key(refid) 
references batchgr(objid)
;




drop view if exists vw_batchgr
;

create view vw_batchgr 
as 
select 
  bg.*,
  l.name as lgu_name,
  b.name as barangay_name,
  pc.name as classification_name,
  t.objid AS taskid,
  t.state AS taskstate,
  t.assignee_objid 
from batchgr bg
inner join sys_org l on bg.lgu_objid = l.objid 
left join sys_org b on bg.barangay_objid = b.objid
left join propertyclassification pc on bg.classification_objid = pc.objid 
left join batchgr_task t on bg.objid = t.refid  and t.enddate is null 
;


/* insert task */
insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-appraiser') as objid,
  b.objid as refid,
  null as parentprocessid,
  'appraiser' as state,
  b.appraiser_dtsigned as startdate,
  b.appraiser_dtsigned as enddate,
  null as assignee_objid,
  b.appraiser_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.appraiser_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.appraiser_name is not null
;


insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-taxmapper') as objid,
  b.objid as refid,
  null as parentprocessid,
  'taxmapper' as state,
  b.taxmapper_dtsigned as startdate,
  b.taxmapper_dtsigned as enddate,
  null as assignee_objid,
  b.taxmapper_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.taxmapper_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.taxmapper_name is not null
;


insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-recommender') as objid,
  b.objid as refid,
  null as parentprocessid,
  'recommender' as state,
  b.recommender_dtsigned as startdate,
  b.recommender_dtsigned as enddate,
  null as assignee_objid,
  b.recommender_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.recommender_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.recommender_name is not null
;



insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-approver') as objid,
  b.objid as refid,
  null as parentprocessid,
  'approver' as state,
  b.approver_dtsigned as startdate,
  b.approver_dtsigned as enddate,
  null as assignee_objid,
  b.approver_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.approver_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.approver_name is not null
;


alter table batchgr 
  drop column appraiser_name,
  drop column appraiser_dtsigned,
  drop column taxmapper_name,
  drop column taxmapper_dtsigned,
  drop column recommender_name,
  drop column recommender_dtsigned,
  drop column approver_name,
  drop column approver_dtsigned
;  




/*===========================================
*
*  ENTITY MAPPING (PROVINCE)
*
============================================*/

DROP TABLE IF EXISTS `entity_mapping`
;

CREATE TABLE `entity_mapping` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop view if exists vw_entity_mapping
;

create view vw_entity_mapping
as 
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




/*===========================================
*
*  CERTIFICATION UPDATES
*
============================================*/
drop view if exists vw_rptcertification_item
;

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
;



/*===========================================
*
*  SUBDIVISION ASSISTANCE
*
============================================*/
drop table if exists subdivision_assist_item
; 

drop table if exists subdivision_assist
; 

CREATE TABLE `subdivision_assist` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `taskstate` varchar(50) NOT NULL,
  `assignee_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table subdivision_assist 
add constraint fk_subdivision_assist_subdivision foreign key(parent_objid)
references subdivision(objid)
;

alter table subdivision_assist 
add constraint fk_subdivision_assist_user foreign key(assignee_objid)
references sys_user(objid)
;

create index ix_parent_objid on subdivision_assist(parent_objid)
;

create index ix_assignee_objid on subdivision_assist(assignee_objid)
;

create unique index ux_parent_assignee on subdivision_assist(parent_objid, taskstate, assignee_objid)
;


CREATE TABLE `subdivision_assist_item` (
`objid` varchar(50) NOT NULL,
  `subdivision_objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `pintype` varchar(10) NOT NULL,
  `section` varchar(5) NOT NULL,
  `startparcel` int(255) NOT NULL,
  `endparcel` int(255) NOT NULL,
  `parcelcount` int(11) DEFAULT NULL,
  `parcelcreated` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision foreign key(subdivision_objid)
references subdivision(objid)
;

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision_assist foreign key(parent_objid)
references subdivision_assist(objid)
;

create index ix_subdivision_objid on subdivision_assist_item(subdivision_objid)
;

create index ix_parent_objid on subdivision_assist_item(parent_objid)
;



/*==================================================
**
** REALTY TAX CREDIT
**
===================================================*/

drop table if exists rpttaxcredit
;



CREATE TABLE `rpttaxcredit` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `type` varchar(25) NOT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `reftype` varchar(25) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(25) NOT NULL,
  `refdate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtapplied` decimal(16,2) NOT NULL,
  `rptledger_objid` varchar(50) NOT NULL,
  `srcledger_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `approvedby_objid` varchar(50) DEFAULT NULL,
  `approvedby_name` varchar(150) DEFAULT NULL,
  `approvedby_title` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


create index ix_state on rpttaxcredit(state)
;

create index ix_type on rpttaxcredit(type)
;

create unique index ux_txnno on rpttaxcredit(txnno)
;

create index ix_reftype on rpttaxcredit(reftype)
;

create index ix_refid on rpttaxcredit(refid)
;

create index ix_refno on rpttaxcredit(refno)
;

create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
;

create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_rptledger foreign key (rptledger_objid)
references rptledger (objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_srcledger foreign key (srcledger_objid)
references rptledger (objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_sys_user foreign key (approvedby_objid)
references sys_user(objid)
;





/*==================================================
**
** MACHINE SMV
**
===================================================*/

CREATE TABLE `machine_smv` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `machine_objid` varchar(50) NOT NULL,
  `expr` varchar(255) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parent_objid on machine_smv(parent_objid)
;
create index ix_machine_objid on machine_smv(machine_objid)
;
create index ix_previd on machine_smv(previd)
;
create unique index ux_parent_machine on machine_smv(parent_objid, machine_objid)
;



alter table machine_smv
add constraint fk_machinesmv_machrysetting foreign key (parent_objid)
references machrysetting (objid)
;

alter table machine_smv
add constraint fk_machinesmv_machine foreign key (machine_objid)
references machine(objid)
;


alter table machine_smv
add constraint fk_machinesmv_machinesmv foreign key (previd)
references machine_smv(objid)
;


create view vw_machine_smv 
as 
select 
  ms.*, 
  m.code,
  m.name
from machine_smv ms 
inner join machine m on ms.machine_objid = m.objid 
;

alter table machdetail 
  add smvid varchar(50),
  add params text
;

update machdetail set params = '[]' where params is null
;

create index ix_smvid on machdetail(smvid)
;


alter table machdetail 
add constraint fk_machdetail_machine_smv foreign key(smvid)
references machine_smv(objid)
;




/*==================================================
**
** AFFECTED FAS TXNTYPE (DP)
**
===================================================*/

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('faas_affected_rpu_txntype_dp', '0', 'Set affected improvements FAAS txntype to DP e.g. SD and CS', 'checkbox', 'ASSESSOR')
;




delete from sys_wf_transition where processname = 'batchgr';
delete from sys_wf_node where processname = 'batchgr';

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forapproval', 'batchgr', 'For Province Approval', 'state', '85', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'batchgr', 'Province Approval', 'state', '90', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('cityapprover', 'batchgr', 'Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'batchgr', '', 'receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'batchgr', 'submit', 'assign-taxmapper', '5', NULL, '[caption:\'Submit For Taxmapping\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'batchgr', 'delete', 'end', '6', NULL, '[caption:\'Delete\', confirm:\'Delete?\', closeonend:true]', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'submit', 'assign-taxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-taxmapper', 'batchgr', '', 'taxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'batchgr', 'returnreceiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'batchgr', 'returnexaminer', 'examiner', '26', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'batchgr', 'submit', 'assign-appraiser', '26', NULL, '[caption:\'Submit for Appraisal\', confirm:\'Submit?\', messagehandler:\'rptmessage:sign\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-appraiser', 'batchgr', '', 'appraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'batchgr', 'returntaxmapper', 'taxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'batchgr', 'submit', 'assign-recommender', '47', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:sign\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'returnexaminer', 'examiner', '75', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'returntaxmapper', 'taxmapper', '76', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'returnappraiser', 'appraiser', '77', NULL, '[caption:\'Return to Appraiser\', confirm:\'Return to appraiser?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'submit', 'forprovsubmission', '78', NULL, '[caption:\'Submit to Province\', confirm:\'Submit to Province?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('forprovsubmission', 'batchgr', 'returnapprover', 'recommender', '80', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('forprovsubmission', 'batchgr', 'completed', 'approver', '81', NULL, '[caption:\'Completed\', visible:false]', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'batchgr', '', 'provapprover', '90', NULL, '[caption:\'Manually Approve Consolidation\', confirm:\'Approve?\', messagehandler:\'rptmessage:approval\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', NULL, NULL, NULL);





drop table if exists sync_data_forprocess
;
drop table if exists sync_data_pending
;
drop table if exists sync_data
;

CREATE TABLE `syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(100) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(100) NOT NULL,
  `orgid` varchar(25) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_createdbyid` (`createdby_objid`),
  KEY `ix_reftype` (`reftype`) USING BTREE,
  KEY `ix_refno` (`refno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(20) DEFAULT NULL,
  `remote_orgclass` varchar(20) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(150) DEFAULT NULL,
  `fileid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_fileid` (`fileid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(255) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `error` text,
  `idx` int(255) NOT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `fk_syncdataitem_syncdata` FOREIGN KEY (`parentid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



CREATE TABLE `syncdata_forprocess` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `fk_syncdata_forprocess_syncdata_item` FOREIGN KEY (`objid`) REFERENCES `syncdata_item` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_pending` (
  `objid` varchar(50) NOT NULL,
  `error` text,
  `expirydate` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_expirydate` (`expirydate`),
  CONSTRAINT `fk_syncdata_pending_syncdata` FOREIGN KEY (`objid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
;


update faas_previous pf, faas f, rpu r set 
  pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
where pf.prevfaasid = f.objid
and f.rpuid = r.objid 
and pf.prevtaxability is null 
;


/* 255-03020 */

alter table syncdata_item add async int default 0
;
alter table syncdata_item add dependedaction varchar(100)
;

create index ix_state on syncdata(state)
;
create index ix_state on syncdata_item(state)
;

create table syncdata_offline_org (
	orgid varchar(50) not null,
	expirydate datetime not null,
	primary key(orgid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*=======================================
*
*  QRRPA: Mixed-Use Support
*
=======================================*/

drop view if exists vw_rpu_assessment
;

create view vw_rpu_assessment as 
select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join landassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join bldgassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join machassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join planttreeassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join miscassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid
;



drop table if exists syncdata_offline_org
;

DROP TABLE if exists `syncdata_org` 
; 


CREATE TABLE `syncdata_org` (
  `orgid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `errorcount` int default 0,
  PRIMARY KEY (`orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_state on syncdata_org(state)
;

insert into syncdata_org (
  orgid, 
  state, 
  errorcount
)
select 
  objid,
  'ACTIVE',
  0
from sys_org
where orgclass = 'province'
;


drop table if exists syncdata_forprocess
;

CREATE TABLE `syncdata_forprocess` (
  `objid` varchar(50) NOT NULL,
  `processed` int(11) DEFAULT '0',
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_forprocess_syncdata_item` FOREIGN KEY (`objid`) REFERENCES `syncdata_item` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table rptledger_item 
	add fromqtr int,
	add toqtr int;

DROP TABLE if exists `batch_rpttaxcredit_ledger_posted`
;

DROP TABLE if exists `batch_rpttaxcredit_ledger`
;

DROP TABLE if exists `batch_rpttaxcredit`
;

CREATE TABLE `batch_rpttaxcredit` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txndate` date NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `paymentfrom` date DEFAULT NULL,
  `paymentto` varchar(255) DEFAULT NULL,
  `creditedyear` int(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `validity` date NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_txnno` (`txnno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `batch_rpttaxcredit_ledger` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `error` varchar(255) NULL,
	barangayid varchar(50) not null, 
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_state` (`state`),
KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_parent foreign key(parentid) references batch_rpttaxcredit(objid)
;

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_rptledger foreign key(objid) references rptledger(objid)
;




CREATE TABLE `batch_rpttaxcredit_ledger_posted` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_parent foreign key(parentid) references batch_rpttaxcredit(objid)
;

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_rptledger foreign key(objid) references rptledger(objid)
;

create view vw_batch_rpttaxcredit_error
as 
select br.*, rl.tdno
from batch_rpttaxcredit_ledger br 
inner join rptledger rl on br.objid = rl.objid 
where br.state = 'ERROR'
;

alter table rpttaxcredit add info text
;


alter table rpttaxcredit add discapplied decimal(16,2) not null
;

update rpttaxcredit set discapplied = 0 where discapplied is null 
;

CREATE TABLE `rpt_syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `FK_parentid_rpt_syncdata` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_error` (
  `objid` varchar(50) NOT NULL,
  `filekey` varchar(1000) NOT NULL,
  `error` text,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `parent` text,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_filekey` (`filekey`(255)),
  KEY `ix_remote_orgid` (`remote_orgid`),
  KEY `ix_remote_orgcode` (`remote_orgcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('assesser_new_sync_lgus', NULL, 'List of LGUs using new sync facility', NULL, 'ASSESSOR')
;



ALTER TABLE rpt_syncdata_forsync ADD remote_orgid VARCHAR(15)
;


INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) VALUES ('fileserver_upload_task_active', '0', 'Activate / Deactivate upload task', 'boolean', 'SYSTEM')
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('fileserver_download_task_active', '1', 'Activate / Deactivate download task', 'boolean', 'SYSTEM')
;


CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(255) NOT NULL,
  `idx` int(255) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `parent_orgid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(255) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_refid` (`refid`),
  KEY `ix_parent_orgid` (`parent_orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rpt_syncdata_forsync add info text
;
alter table rpt_syncdata add info text
;


drop view if exists vw_landtax_lgu_account_mapping
;

CREATE VIEW vw_landtax_lgu_account_mapping 
AS 
select 
    ia.org_objid AS org_objid,
    ia.org_name AS org_name,
    o.orgclass AS org_class,
    p.objid AS parent_objid,
    p.code AS parent_code,
    p.title AS parent_title,
    ia.objid AS item_objid,
    ia.code AS item_code,
    ia.title AS item_title,
    ia.fund_objid AS item_fund_objid,
    ia.fund_code AS item_fund_code,
    ia.fund_title AS item_fund_title,
    ia.type AS item_type,
    pt.tag AS item_tag 
from itemaccount ia 
    inner join itemaccount p on ia.parentid = p.objid 
    inner join itemaccount_tag pt on p.objid = pt.acctid 
    inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'ACTIVE' 
  and ia.state = 'ACTIVE'
;

drop view if exists vw_batchgr
;

create view vw_batchgr 
as 
select 
    bg.objid AS objid,
    bg.state AS state,
    bg.ry AS ry,
    bg.lgu_objid AS lgu_objid,
    bg.barangay_objid AS barangay_objid,
    bg.rputype AS rputype,
    bg.classification_objid AS classification_objid,
    bg.section AS section,
    bg.memoranda AS memoranda,
    bg.txntype_objid AS txntype_objid,
    bg.txnno AS txnno,
    bg.txndate AS txndate,
    bg.effectivityyear AS effectivityyear,
    bg.effectivityqtr AS effectivityqtr,
    bg.originlgu_objid AS originlgu_objid,
    l.name AS lgu_name,
    b.name AS barangay_name,
    b.pin AS barangay_pin,
    pc.name AS classification_name,
    t.objid AS taskid,
    t.state AS taskstate,
    t.assignee_objid AS assignee_objid 
from batchgr bg join sys_org l on bg.lgu_objid = l.objid 
    left join barangay b on bg.barangay_objid = b.objid 
    left join propertyclassification pc on bg.classification_objid = pc.objid 
    left join batchgr_task t on bg.objid = t.refid and t.enddate is null 
;

CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(100) NOT NULL,
  `rptpaymentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`),
  KEY `fk_rptshare_repost_rptledgerid` (`rptledgerid`),
  KEY `fk_rptshare_repost_cashreceiptid` (`receiptid`),
  CONSTRAINT `fk_rptshare_repost_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `fk_rptshare_repost_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



/*===================================================== 
	IMPORTANT: BEFORE EXECUTING !!!!

	CHANGE "eor" database name to match the LGUs 
	eor production database name

=======================================================*/
drop view if exists vw_landtax_eor
;


create view vw_landtax_eor 
as 
select * from eor.eor
;


drop view if exists vw_landtax_eor_remittance
;

create view vw_landtax_eor_remittance 
as 
select * from eor.eor_remittance
;



CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop view if exists vw_landtax_abstract_of_collection_detail
;


create view vw_landtax_abstract_of_collection_detail
as 
select
	liq.objid as liquidationid,
	liq.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.dtposted as remittancedate,
	cr.objid as receiptid, 
	cr.receiptdate as ordate, 
	cr.receiptno as orno, 
	cr.collector_objid as collectorid,
	rl.objid as rptledgerid,
	rl.fullpin,
	rl.titleno, 
	rl.cadastrallotno, 
	rl.rputype, 
	rl.totalmv, 
	b.name as barangay, 
	rp.fromqtr,
  rp.toqtr,
  rpi.year,
	rpi.qtr,
	rpi.revtype,
	case when cv.objid is null then rl.owner_name else '*** voided ***' end as taxpayername, 
	case when cv.objid is null then rl.tdno else '' end as tdno, 
	case when m.name is null then c.name else m.name end as municityname, 
	case when cv.objid is null  then rl.classcode else '' end as classification, 
	case when cv.objid is null then rl.totalav else 0.0 end as assessvalue,
	case when cv.objid is null then rl.totalav else 0.0 end as assessedvalue,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basiccurrentyear,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'basic' then rpi.discount else 0.0 end as basicdiscount,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as sefcurrentyear,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as sefpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'sef' then rpi.discount else 0.0 end as sefdiscount,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as sefpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as sefpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basicidlecurrent,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicidleprevious,
	case when cv.objid is null  and rpi.revtype = 'basicidle' then rpi.amount else 0.0 end as basicidlediscount,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicidlecurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicidlepreviouspenalty,

	
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as shcurrent,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as shprevious,
	case when cv.objid is null  and rpi.revtype = 'sh' then rpi.discount else 0.0 end as shdiscount,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as shcurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as shpreviouspenalty,

	case when cv.objid is null and rpi.revtype = 'firecode' then rpi.amount else 0.0 end as firecode,
	
	case 
			when cv.objid is null 
			then rpi.amount - rpi.discount + rpi.interest 
			else 0.0 
	end as total,
	case when cv.objid is null then rpi.partialled else 0 end as partialled
from collectionvoucher liq
	inner join remittance rem on rem.collectionvoucherid = liq.objid 
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	left join cashreceipt_void cv on cr.objid = cv.receiptid 
	inner join rptpayment rp on rp.receiptid= cr.objid 
	inner join rptpayment_item rpi on rpi.parentid = rp.objid
	inner join rptledger rl on rl.objid = rp.refid
	inner join barangay b on b.objid  = rl.barangayid
	left join district d on b.parentid = d.objid 
	left join city c on d.parentid = c.objid 
	left join municipality m on b.parentid = m.objid 
;



drop view if exists vw_landtax_abstract_of_collection_detail_eor
;

create view vw_landtax_abstract_of_collection_detail_eor
as 
select
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.objid as receiptid, 
	eor.receiptdate as ordate, 
	eor.receiptno as orno, 
	rem.createdby_objid as collectorid,
	rl.objid as rptledgerid,
	rl.fullpin,
	rl.titleno, 
	rl.cadastrallotno, 
	rl.rputype, 
	rl.totalmv, 
	b.name as barangay, 
	rp.fromqtr,
  rp.toqtr,
  rpi.year,
	rpi.qtr,
	rpi.revtype,
	case when cv.objid is null then rl.owner_name else '*** voided ***' end as taxpayername, 
	case when cv.objid is null then rl.tdno else '' end as tdno, 
	case when m.name is null then c.name else m.name end as municityname, 
	case when cv.objid is null  then rl.classcode else '' end as classification, 
	case when cv.objid is null then rl.totalav else 0.0 end as assessvalue,
	case when cv.objid is null then rl.totalav else 0.0 end as assessedvalue,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basiccurrentyear,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'basic' then rpi.discount else 0.0 end as basicdiscount,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as sefcurrentyear,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as sefpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'sef' then rpi.discount else 0.0 end as sefdiscount,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as sefpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as sefpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basicidlecurrent,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicidleprevious,
	case when cv.objid is null  and rpi.revtype = 'basicidle' then rpi.amount else 0.0 end as basicidlediscount,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicidlecurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicidlepreviouspenalty,

	
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as shcurrent,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as shprevious,
	case when cv.objid is null  and rpi.revtype = 'sh' then rpi.discount else 0.0 end as shdiscount,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as shcurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as shpreviouspenalty,

	case when cv.objid is null and rpi.revtype = 'firecode' then rpi.amount else 0.0 end as firecode,
	
	case 
			when cv.objid is null 
			then rpi.amount - rpi.discount + rpi.interest 
			else 0.0 
	end as total,
	case when cv.objid is null then rpi.partialled else 0 end as partialled
from vw_landtax_eor_remittance rem
	inner join vw_landtax_eor eor on rem.objid = eor.remittanceid 
	left join cashreceipt_void cv on eor.objid = cv.receiptid 
	inner join rptpayment rp on eor.objid = rp.receiptid 
	inner join rptpayment_item rpi on rpi.parentid = rp.objid
	inner join rptledger rl on rl.objid = rp.refid
	inner join barangay b on b.objid  = rl.barangayid
	left join district d on b.parentid = d.objid 
	left join city c on d.parentid = c.objid 
	left join municipality m on b.parentid = m.objid 
;


drop view if exists vw_landtax_collection_detail
;

create view vw_landtax_collection_detail
as 
select 
	cv.objid as liquidationid,
	cv.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	cr.receiptdate,
	o.objid as lguid,
	o.name as lgu,
	b.objid as barangayid,
	b.indexno as brgyindex,
	b.name as barangay,
	ri.revperiod,
	ri.revtype,
	ri.year,
	ri.qtr,
	ri.amount,
	ri.interest,
	ri.discount,
  pc.name as classname, 
	pc.orderno, 
	pc.special,  
  case when ri.revperiod='current' and ri.revtype = 'basic' then ri.amount else 0.0 end  as basiccurrent,
  case when ri.revtype = 'basic' then ri.discount else 0.0 end  as basicdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.amount else 0.0 end  as basicprev,
  case when ri.revperiod='current' and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basiccurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basicprevint,
  case when ri.revtype = 'basic' then ri.amount - ri.discount+ ri.interest else 0 end as basicnet, 

  case when ri.revperiod='current' and ri.revtype = 'sef' then ri.amount else 0.0 end  as sefcurrent,
  case when ri.revtype = 'sef' then ri.discount else 0.0 end  as sefdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.amount else 0.0 end  as sefprev,
  case when ri.revperiod='current' and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefcurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefprevint,
  case when ri.revtype = 'sef' then ri.amount - ri.discount+ ri.interest else 0 end as sefnet, 

  case when ri.revperiod='current' and ri.revtype = 'basicidle' then ri.amount else 0.0 end  as idlecurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basicidle'  then ri.amount else 0.0 end  as idleprev,
  case when ri.revtype = 'basicidle' then ri.discount else 0.0 end  as idledisc,
  case when ri.revtype = 'basicidle' then ri.interest else 0 end   as idleint, 
  case when ri.revtype = 'basicidle'then ri.amount - ri.discount + ri.interest else 0 end as idlenet, 

  case when ri.revperiod='current' and ri.revtype = 'sh' then ri.amount else 0.0 end  as shcurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sh' then ri.amount else 0.0 end  as shprev,
  case when ri.revtype = 'sh' then ri.discount else 0.0 end  as shdisc,
  case when ri.revtype = 'sh' then ri.interest else 0 end  as shint, 
  case when ri.revtype = 'sh' then ri.amount - ri.discount + ri.interest else 0 end as shnet, 

  case when ri.revtype = 'firecode' then ri.amount - ri.discount + ri.interest else 0 end  as firecode,

  0.0 as levynet 
from remittance rem 
  inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
  inner join cashreceipt cr on cr.remittanceid = rem.objid 
  left join cashreceipt_void crv on cr.objid = crv.receiptid
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  left join rptledger rl ON rp.refid = rl.objid  
	left join barangay b on rl.barangayid = b.objid 
	left join sys_org o on rl.lguid = o.objid  
  left join propertyclassification pc ON rl.classification_objid = pc.objid 
where crv.objid is null 
;


drop view if exists vw_landtax_collection_disposition_detail
;

create view vw_landtax_collection_disposition_detail
as 
select   
	cv.objid as liquidationid,
	cv.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	cr.receiptdate,
	ri.revperiod,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    0.0 as brgysefshare 
  from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
		left join cashreceipt_void crv on cr.objid = crv.receiptid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  where crv.objid is null 
;


drop view if exists vw_landtax_collection_detail_eor
;

create view vw_landtax_collection_detail_eor
as 
select 
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.receiptdate,
	o.objid as lguid,
	o.name as lgu,
	b.objid as barangayid,
	b.indexno as brgyindex,
	b.name as barangay,
	ri.revperiod,
	ri.revtype,
	ri.year,
	ri.qtr,
	ri.amount,
	ri.interest,
	ri.discount,
  pc.name as classname, 
	pc.orderno, 
	pc.special,  
  case when ri.revperiod='current' and ri.revtype = 'basic' then ri.amount else 0.0 end  as basiccurrent,
  case when ri.revtype = 'basic' then ri.discount else 0.0 end  as basicdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.amount else 0.0 end  as basicprev,
  case when ri.revperiod='current' and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basiccurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basicprevint,
  case when ri.revtype = 'basic' then ri.amount - ri.discount+ ri.interest else 0 end as basicnet, 

  case when ri.revperiod='current' and ri.revtype = 'sef' then ri.amount else 0.0 end  as sefcurrent,
  case when ri.revtype = 'sef' then ri.discount else 0.0 end  as sefdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.amount else 0.0 end  as sefprev,
  case when ri.revperiod='current' and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefcurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefprevint,
  case when ri.revtype = 'sef' then ri.amount - ri.discount+ ri.interest else 0 end as sefnet, 

  case when ri.revperiod='current' and ri.revtype = 'basicidle' then ri.amount else 0.0 end  as idlecurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basicidle'  then ri.amount else 0.0 end  as idleprev,
  case when ri.revtype = 'basicidle' then ri.discount else 0.0 end  as idledisc,
  case when ri.revtype = 'basicidle' then ri.interest else 0 end   as idleint, 
  case when ri.revtype = 'basicidle'then ri.amount - ri.discount + ri.interest else 0 end as idlenet, 

  case when ri.revperiod='current' and ri.revtype = 'sh' then ri.amount else 0.0 end  as shcurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sh' then ri.amount else 0.0 end  as shprev,
  case when ri.revtype = 'sh' then ri.discount else 0.0 end  as shdisc,
  case when ri.revtype = 'sh' then ri.interest else 0 end  as shint, 
  case when ri.revtype = 'sh' then ri.amount - ri.discount + ri.interest else 0 end as shnet, 

  case when ri.revtype = 'firecode' then ri.amount - ri.discount + ri.interest else 0 end  as firecode,

  0.0 as levynet 
from vw_landtax_eor_remittance rem 
  inner join vw_landtax_eor eor on rem.objid = eor.remittanceid
  inner join rptpayment rp on eor.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  left join rptledger rl ON rp.refid = rl.objid  
	left join barangay b on rl.barangayid = b.objid
	left join sys_org o on rl.lguid = o.objid   
  left join propertyclassification pc ON rl.classification_objid = pc.objid 
;


drop view if exists vw_landtax_collection_disposition_detail_eor
;

create view vw_landtax_collection_disposition_detail_eor
as 
select   
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.receiptdate,
	ri.revperiod,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    0.0 as brgysefshare 
  from vw_landtax_eor_remittance rem 
    inner join vw_landtax_eor eor on rem.objid = eor.remittanceid
		inner join rptpayment rp on eor.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  
;


create view vw_newly_assessed_property as 
select
	f.objid,
	f.owner_name,
	f.tdno,
	b.name as barangay,
	case 
		when f.rputype = 'land' then 'LAND' 
		when f.rputype = 'bldg' then 'BUILDING' 
		when f.rputype = 'mach' then 'MACHINERY' 
		when f.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	f.totalav,
	f.effectivityyear
from faas_list f 
	inner join barangay b on f.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED') 
and f.txntype_objid = 'ND'
;

create view vw_real_property_payment as 
select 
	cv.controldate as cv_controldate,
	rem.controldate as rem_controldate,
	rl.owner_name,
	rl.tdno,
	pc.name as classification, 
	case 
		when rl.rputype = 'land' then 'LAND' 
		when rl.rputype = 'bldg' then 'BUILDING' 
		when rl.rputype = 'mach' then 'MACHINERY' 
		when rl.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	b.name as barangay,
	rpi.year, 
	rpi.qtr,
	rpi.amount + rpi.interest - rpi.discount as amount,
	case when v.objid is null then 0 else 1 end as voided
from collectionvoucher cv 
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_item rpi on rp.objid = rpi.parentid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join barangay b on rl.barangayid = b.objid 
	inner join propertyclassification pc on rl.classification_objid = pc.objid 
	left join cashreceipt_void v on cr.objid = v.receiptid
;

drop view if exists vw_rptledger_cancelled_faas 
;

create view vw_rptledger_cancelled_faas 
as 
select 
	rl.objid,
	rl.state,
	rl.faasid,
	rl.lastyearpaid,
	rl.lastqtrpaid,
	rl.barangayid,
	rl.taxpayer_objid,
	rl.fullpin,
	rl.tdno,
	rl.cadastrallotno,
	rl.rputype,
	rl.txntype_objid,
	rl.classification_objid,
	rl.classcode,
	rl.totalav,
	rl.totalmv,
	rl.totalareaha,
	rl.taxable,
	rl.owner_name,
	rl.prevtdno,
	rl.titleno,
	rl.administrator_name,
	rl.blockno,
	rl.lguid,
	rl.beneficiary_objid,
	pc.name as classification,
	b.name as barangay,
	o.name as lgu
from rptledger rl 
	inner join faas f on rl.faasid = f.objid 
	left join barangay b on rl.barangayid = b.objid 
	left join sys_org o on rl.lguid = o.objid 
	left join propertyclassification pc on rl.classification_objid = pc.objid 
	inner join entity e on rl.taxpayer_objid = e.objid 
where rl.state = 'APPROVED' 
and f.state = 'CANCELLED' 
;


drop view if exists vw_certification_landdetail 
;

create view vw_certification_landdetail 
as 
select 
	f.objid as faasid,
	ld.areaha,
	ld.areasqm,
	ld.assessedvalue,
	ld.marketvalue,
	ld.basemarketvalue,
	ld.unitvalue,
	lspc.name as specificclass_name
from faas f 
	inner join landdetail ld on f.rpuid = ld.landrpuid
	inner join landspecificclass lspc on ld.landspecificclass_objid = lspc.objid 
;


drop view if exists vw_certification_land_improvement
;

create view vw_certification_land_improvement
as 
select 
	f.objid as faasid,
	pt.name as improvement,
	ptd.areacovered,
	ptd.productive,
	ptd.nonproductive,
	ptd.basemarketvalue,
	ptd.marketvalue,
	ptd.unitvalue,
	ptd.assessedvalue
from faas f 
	inner join planttreedetail ptd on f.rpuid = ptd.landrpuid
	inner join planttree pt on ptd.planttree_objid = pt.objid
;



drop view if exists vw_landtax_collection_share_detail
;

create view vw_landtax_collection_share_detail
as 
select 
  cv.objid as liquidationid,
  cv.controlno as liquidationno,
    cv.controldate as liquidationdate,
    rem.objid as remittanceid,
    rem.controlno as remittanceno,
    rem.controldate as remittancedate,
    cr.objid as receiptid,
    cr.receiptno,
    cr.receiptdate,
    cr.txndate,
    o.name as lgu,
    b.objid as barangayid,
    b.name as barangay, 
    cra.revtype,
    cra.revperiod,
    cra.sharetype,
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' then cra.amount else 0 end) as brgycurr,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' then cra.amount else 0 end) as brgyprev,
    (case when cra.revtype = 'basicint' then cra.amount else 0 end) as brgypenalty,
    
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgyprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as citycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as cityprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('city') then cra.amount else 0 end) as citypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunicurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmuniprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunipenaltyshare,
    cra.amount,
    cra.discount
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join rptledger rl on rp.refid = rl.objid
    left join sys_org o on rl.lguid = o.objid 
    left join barangay b on rl.barangayid = b.objid 
    left join cashreceipt_void crv on cr.objid = crv.receiptid 
;



drop view if exists vw_landtax_collection_share_detail_eor
;

create view vw_landtax_collection_share_detail_eor
as 
select 
rem.objid as liquidationid,
  rem.controlno as liquidationno,
    rem.controldate as liquidationdate,
    rem.objid as remittanceid,
    rem.controlno as remittanceno,
    rem.controldate as remittancedate,
    eor.objid as receiptid,
    eor.receiptno,
    eor.receiptdate,
    eor.txndate,
    o.name as lgu,
    b.objid as barangayid,
    b.name as barangay, 
    cra.revtype,
    cra.revperiod,
    cra.sharetype,
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' then cra.amount else 0 end) as brgycurr,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' then cra.amount else 0 end) as brgyprev,
    (case when cra.revtype = 'basicint' then cra.amount else 0 end) as brgypenalty,
    
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgyprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as citycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as cityprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('city') then cra.amount else 0 end) as citypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunicurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmuniprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunipenaltyshare,
    cra.amount,
    cra.discount
from  vw_landtax_eor_remittance rem 
  inner join vw_landtax_eor eor on rem.objid = eor.remittanceid 
  inner join rptpayment rp on eor.objid = rp.receiptid 
  inner join rptpayment_share cra on rp.objid = cra.parentid
  left join rptledger rl on rp.refid = rl.objid
  left join sys_org o on rl.lguid = o.objid 
  left join barangay b on rl.barangayid = b.objid 
  left join cashreceipt_void crv on eor.objid = crv.receiptid 
;

INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER')
;
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_ISSUER', 'CERTIFICATION_ISSUER', 'RPT', 'usergroup', NULL, 'CERTIFICATION_ISSUER')
;
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER')
;
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_RELEASER', 'RPT CERTIFICATION_RELEASER', 'RPT', NULL, NULL, 'CERTIFICATION_RELEASER')
;


delete from sys_wf_transition where processname ='rptcertification'
;
delete from sys_wf_node where processname ='rptcertification'
;

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:\"#00ff00\",size:[32,32],pos:[102,127],type:\"start\"]', NULL)
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'rptcertification', 'Received', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:\"#c0c0c0\",size:[114,40],pos:[206,127],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('verifier', 'rptcertification', 'For Verification', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:\"#c0c0c0\",size:[129,44],pos:[412,127],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'rptcertification', 'For Approval', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-releaser', 'rptcertification', 'Releasing', 'state', '6', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('releaser', 'rptcertification', 'For Release', 'state', '7', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('released', 'rptcertification', 'Released', 'end', '8', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#ff0000\",size:[32,32],pos:[797,148],type:\"end\"]', '1')
;


INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'rptcertification', 'assign', 'receiver', '1', NULL, '[:]', NULL, 'Assign', '[size:[72,0],pos:[134,142],type:\"arrow\",points:[134,142,206,142]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'cancelissuance', 'end', '5', NULL, '[caption:\'Cancel Issuance\', confirm:\'Cancel issuance?\',closeonend:true]', NULL, 'Cancel Issuance', '[size:[559,116],pos:[258,32],type:\"arrow\",points:[262,127,258,32,817,40,813,148]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'submit', 'verifier', '6', NULL, '[caption:\'Submit to Verifier\', confirm:\'Submit to verifier?\', messagehandler:\'rptmessage:info\',targetrole:\'RPT.CERTIFICATION_VERIFIER\']', NULL, 'Submit to Verifier', '[size:[92,0],pos:[320,146],type:\"arrow\",points:[320,146,412,146]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'return_receiver', 'receiver', '10', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[160,63],pos:[292,64],type:\"arrow\",points:[452,127,385,64,292,127]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'submit', 'approver', '11', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit for approval?\', messagehandler:\'rptmessage:sign\',targetrole:\'RPT.CERTIFICATION_APPROVER\']', NULL, 'Submit to Approver', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'return_receiver', 'receiver', '15', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[333,113],pos:[285,167],type:\"arrow\",points:[618,183,414,280,285,167]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'submit', 'assign-releaser', '16', NULL, '[caption:\'Approve\', confirm:\'Approve?\', messagehandler:\'rptmessage:sign\']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:\"arrow\",points:[722,162,797,162]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-releaser', 'rptcertification', 'assign', 'releaser', '20', NULL, '[caption:\'Assign to Me\', confirm:\'Assign task to you?\']', NULL, 'Assign To Me', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('releaser', 'rptcertification', 'submit', 'released', '100', '', '[caption:\'Release Certification\', confirm:\'Release certifications?\', closeonend:false, messagehandler:\'rptmessage:info\']', '', 'Release Certification', '[:]')
;



drop view if exists vw_building
; 

create view vw_building as 
select 
	f.objid,
	f.state,
	f.rpuid,
	f.realpropertyid,
	f.tdno, 
	f.fullpin, 
	f.taxpayer_objid, 
	f.owner_name, 
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	f.lguid as lgu_objid,
	o.name as lgu_name,
	b.objid as barangay_objid,
	b.name as barangay_name,
	r.classification_objid,
	pc.name as classification_name,
	rp.pin,
	rp.section,
	rp.ry, 
	rp.cadastrallotno, 
	rp.blockno, 
	rp.surveyno,
	bt.objid as bldgtype_objid,
	bt.name as bldgtype_name,
	bk.objid as bldgkind_objid,
	bk.name as bldgkind_name,
	bu.basemarketvalue,
	bu.adjustment,
	bu.depreciationvalue,
	bu.marketvalue,
	bu.assessedvalue,
	al.objid as actualuse_objid,
	al.name as actualuse_name,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join sys_org o on f.lguid = o.objid 
	inner join bldgrpu_structuraltype bst on r.objid = bst.bldgrpuid 
	inner join bldgtype bt on bst.bldgtype_objid = bt.objid 
	inner join bldgkindbucc bucc on bst.bldgkindbucc_objid = bucc.objid 
	inner join bldgkind bk on bucc.bldgkind_objid = bk.objid 
	inner join bldguse bu on bst.objid = bu.structuraltype_objid
	inner join bldgassesslevel al on bu.actualuse_objid = al.objid 
;


drop view if exists vw_machinery
; 

create view vw_machinery as 
select 
	f.objid,
	f.state,
	f.rpuid,
	f.realpropertyid,
	f.tdno, 
	f.fullpin, 
	f.taxpayer_objid, 
	f.owner_name, 
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	f.lguid as lgu_objid,
	o.name as lgu_name,
	b.objid as barangay_objid,
	b.name as barangay_name,
	r.classification_objid,
	pc.name as classification_name,
	rp.pin,
	rp.section,
	rp.ry, 
	rp.cadastrallotno, 
	rp.blockno, 
	rp.surveyno,
	m.objid as machine_objid,
	m.name as machine_name,
	mu.basemarketvalue,
	mu.marketvalue,
	mu.assessedvalue,
	al.objid as actualuse_objid,
	al.name as actualuse_name,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join sys_org o on f.lguid = o.objid 
	inner join machuse mu on r.objid = mu.machrpuid
	inner join machdetail md on mu.objid = md.machuseid
	inner join machine m on md.machine_objid = m.objid 
	inner join machassesslevel al on mu.actualuse_objid = al.objid 
;


alter table rptcertification add taskid varchar(50)
;



CREATE TABLE `rptcertification_task` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `refid` varchar(50) DEFAULT NULL,
  `parentprocessid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `assignee_title` varchar(80) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `actor_title` varchar(80) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `signature` text,
  `returnedby` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_assignee_objid` (`assignee_objid`) USING BTREE,
  CONSTRAINT `rptcertification_task_ibfk_1` FOREIGN KEY (`refid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


DROP VIEW IF EXISTS `vw_online_rptcertification`
;
CREATE VIEW `vw_online_rptcertification` AS select `c`.`objid` AS `objid`,`c`.`txnno` AS `txnno`,`c`.`txndate` AS `txndate`,`c`.`opener` AS `opener`,`c`.`taxpayer_objid` AS `taxpayer_objid`,`c`.`taxpayer_name` AS `taxpayer_name`,`c`.`taxpayer_address` AS `taxpayer_address`,`c`.`requestedby` AS `requestedby`,`c`.`requestedbyaddress` AS `requestedbyaddress`,`c`.`certifiedby` AS `certifiedby`,`c`.`certifiedbytitle` AS `certifiedbytitle`,`c`.`official` AS `official`,`c`.`purpose` AS `purpose`,`c`.`orno` AS `orno`,`c`.`ordate` AS `ordate`,`c`.`oramount` AS `oramount`,`c`.`taskid` AS `taskid`,`t`.`state` AS `task_state`,`t`.`startdate` AS `task_startdate`,`t`.`enddate` AS `task_enddate`,`t`.`assignee_objid` AS `task_assignee_objid`,`t`.`assignee_name` AS `task_assignee_name`,`t`.`actor_objid` AS `task_actor_objid`,`t`.`actor_name` AS `task_actor_name` from (`rptcertification` `c` join `rptcertification_task` `t` on((`c`.`taskid` = `t`.`objid`)))
;


update sys_sequence set objid = CONCAT('TDNO-', objid ) where objid REGEXP('^[0-9][0-9]') = 1
;

CREATE TABLE `faas_requested_series` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `series` varchar(255) NOT NULL,
  `requestedby_name` varchar(255) NOT NULL,
  `requestedby_date` date NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_date` datetime NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_faas_requested_series_sys_sequence` (`parentid`),
  CONSTRAINT `fk_faas_requested_series_sys_sequence` FOREIGN KEY (`parentid`) REFERENCES `sys_sequence` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop view if exists vw_report_orc
;


create view vw_report_orc as 
select 
	f.objid,
	f.state,
	e.objid as taxpayerid,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address,
  	o.name as lgu_name,
	o.code as lgu_indexno,
	f.dtapproved,
	r.rputype,
	pc.code as classcode,
	pc.name as classification,
	f.fullpin as pin,
	f.titleno,
	rp.cadastrallotno,
	f.tdno,
	'' as arpno,
	f.prevowner,
	b.name as location,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav,
	case when f.state = 'CURRENT' then '' else 'CANCELLED' end as remarks
from faas f
inner join rpu r on f.rpuid = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join propertyclassification pc on r.classification_objid = pc.objid 
inner join entity e on f.taxpayer_objid = e.objid 
inner join sys_org o on rp.lguid = o.objid 
inner join barangay b on rp.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED')
;



create index ix_year on rptpayment_item (year)
;
create index ix_revperiod on rptpayment_item (revperiod)
;
create index ix_revtype on rptpayment_item (revtype)
;


create index ix_year on rptpayment_share (year)
;
create index ix_revperiod on rptpayment_share (revperiod)
;
create index ix_revtype on rptpayment_share (revtype)
;


DROP TABLE IF EXISTS `cashreceipt_rpt_share_forposting_repost` 
;

CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(50) NOT NULL,
  `rptpaymentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`),
  KEY `fk_rptshare_repost_rptledgerid` (`rptledgerid`),
  KEY `fk_rptshare_repost_cashreceiptid` (`receiptid`),
  CONSTRAINT `fk_rptshare_repost_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `fk_rptshare_repost_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

update sys_sequence set objid = CONCAT('TDNO-', objid ) where objid REGEXP('^[0-9][0-9]') = 1
;

DROP TABLE IF EXISTS `faas_requested_series` 
;

CREATE TABLE `faas_requested_series` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `series` varchar(255) NOT NULL,
  `requestedby_name` varchar(255) NOT NULL,
  `requestedby_date` date NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_date` datetime NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_faas_requested_series_sys_sequence` (`parentid`),
  CONSTRAINT `fk_faas_requested_series_sys_sequence` FOREIGN KEY (`parentid`) REFERENCES `sys_sequence` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop table if exists rpt_syncdata_item_completed;
drop table if exists rpt_syncdata_completed;
drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_fordownload;
drop table if exists rpt_syncdata_error;
drop table if exists rpt_syncdata_item;
drop table if exists rpt_syncdata;

CREATE TABLE `rpt_syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `error` text,
  `filekey` varchar(1200) DEFAULT NULL,
  `etag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  CONSTRAINT `rpt_syncdata_item_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(15) DEFAULT NULL,
  `state` varchar(25) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_error` (
  `objid` varchar(50) NOT NULL,
  `filekey` varchar(1000) NOT NULL,
  `error` text,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `parent` text,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_filekey` (`filekey`(255)) USING BTREE,
  KEY `ix_remote_orgid` (`remote_orgid`) USING BTREE,
  KEY `ix_remote_orgcode` (`remote_orgcode`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item_completed` (
  `objid` varchar(255) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `idx` int(255) DEFAULT NULL,
  `info` text,
  `error` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_remote_orgid` (`parentid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop TABLE if exists `cashreceipt_rpt_share_forposting_repost`
;

CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(100) NOT NULL,
  `rptpaymentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `error` int(11) DEFAULT NULL,
  `msg` text,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_rptledgerid` (`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_cashreceiptid` (`receiptid`) USING BTREE,
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_1` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_2` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop TABLE if exists `rpt_syncdata_completed` 
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `idx` int,
  `action` varchar(50) ,
  `refid` varchar(50) ,
  `reftype` varchar(50) ,
  `refno` varchar(50) ,
  `parent_orgid` varchar(50) ,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `dtcreated` datetime,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_parent_orgid` (`parent_orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table cashreceipt_rpt_share_forposting_repost add receipttype varchar(10)
;

alter table cashreceipt_rpt_share_forposting_repost drop foreign key cashreceipt_rpt_share_forposting_repost_ibfk_1
;

/* MACHUSE: TAXABLE SUPPORT  */

alter table machuse add taxable int
;
update machuse set taxable = 1 where taxable is null
;
create unique index ux_actualuseid_taxable on machuse(machrpuid, actualuse_objid, taxable)
;


/* SYNCDATA: pre-download file */

drop table if exists rpt_syncdata_item_completed;
drop table if exists rpt_syncdata_completed;
drop table if exists rpt_syncdata_item;
drop table if exists rpt_syncdata;
drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_fordownload;

CREATE TABLE `rpt_syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(15) DEFAULT NULL,
  `state` varchar(25) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE,
  KEY `ix_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `error` text,
  `filekey` varchar(1200) DEFAULT NULL,
  `etag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  CONSTRAINT `rpt_syncdata_item_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `info` text,
  `dtfiled` datetime DEFAULT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(25) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item_completed` (
  `objid` varchar(255) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `idx` int(255) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_remote_orgid` (`parentid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* RPT CERTIFICATION WORKFLOW */
delete from sys_wf_transition where processname = 'rptcertification';
delete from sys_wf_node where processname = 'rptcertification';

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:\"#00ff00\",size:[32,32],pos:[102,127],type:\"start\"]', NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'rptcertification', 'Received', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:\"#c0c0c0\",size:[114,40],pos:[206,127],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('verifier', 'rptcertification', 'For Verification', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:\"#c0c0c0\",size:[129,44],pos:[412,127],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'rptcertification', 'For Approval', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-releaser', 'rptcertification', 'Releasing', 'state', '6', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('releaser', 'rptcertification', 'For Release', 'state', '7', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('released', 'rptcertification', 'Released', 'end', '8', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#ff0000\",size:[32,32],pos:[797,148],type:\"end\"]', '1');

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'rptcertification', 'assign', 'receiver', '1', NULL, '[:]', NULL, 'Assign', '[size:[72,0],pos:[134,142],type:\"arrow\",points:[134,142,206,142]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'cancelissuance', 'end', '5', NULL, '[caption:\'Cancel Issuance\', confirm:\'Cancel issuance?\',closeonend:true]', NULL, 'Cancel Issuance', '[size:[559,116],pos:[258,32],type:\"arrow\",points:[262,127,258,32,817,40,813,148]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'submit', 'verifier', '6', NULL, '[caption:\'Submit to Verifier\', confirm:\'Submit to verifier?\', messagehandler:\'rptmessage:info\',targetrole:\'RPT.CERTIFICATION_VERIFIER\']', NULL, 'Submit to Verifier', '[size:[92,0],pos:[320,146],type:\"arrow\",points:[320,146,412,146]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'return_receiver', 'receiver', '10', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[160,63],pos:[292,64],type:\"arrow\",points:[452,127,385,64,292,127]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'submit', 'approver', '11', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit for approval?\', messagehandler:\'rptmessage:sign\',targetrole:\'RPT.CERTIFICATION_APPROVER\']', NULL, 'Submit to Approver', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'return_receiver', 'receiver', '15', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[333,113],pos:[285,167],type:\"arrow\",points:[618,183,414,280,285,167]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'submit', 'assign-releaser', '16', NULL, '[caption:\'Approve\', confirm:\'Approve?\', messagehandler:\'rptmessage:sign\']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:\"arrow\",points:[722,162,797,162]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-releaser', 'rptcertification', 'assign', 'releaser', '20', NULL, '[caption:\'Assign to Me\', confirm:\'Assign task to you?\']', NULL, 'Assign To Me', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('releaser', 'rptcertification', 'submit', 'released', '100', '', '[caption:\'Release Certification\', confirm:\'Release certifications?\', closeonend:false, messagehandler:\'rptmessage:info\']', '', 'Release Certification', '[:]');

INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER');
INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_ISSUER', 'CERTIFICATION_ISSUER', 'RPT', 'usergroup', NULL, 'CERTIFICATION_ISSUER');
INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_RELEASER', 'RPT CERTIFICATION_RELEASER', 'RPT', NULL, NULL, 'CERTIFICATION_RELEASER');
INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER');


/* STOREY ADJUSTMENT SUPPORT */
alter table bldgtype add storeyadjtype varchar(10)
;
update bldgtype set storeyadjtype = 'bytype' where storeyadjtype is null
;


alter table bldgflooradditional add issystem int
;
update bldgflooradditional set issystem = 0 where issystem is null 
;

INSERT INTO `rptparameter` (`objid`, `state`, `name`, `caption`, `description`, `paramtype`, `minvalue`, `maxvalue`) 
VALUES ('MULTI_STOREY_RATE', 'APPROVED', 'MULTI_STOREY_RATE', 'MULTI-STOREY RATE', NULL, 'decimal', '0.00', '0.00')
;


INSERT INTO `bldgadditionalitem` (`objid`, `bldgrysettingid`, `code`, `name`, `unit`, `expr`, `previd`, `type`, `addareatobldgtotalarea`, `idx`) 
select
  concat('BMSA-', r.objid) as objid, 
  r.objid as bldgrysettingid, 
  'BMSA' as code, 
  'MULTI-STOREY ADJUSTMENT' as name, 
  'RATE' as unit, 
  'SYS_AREA * SYS_BASE_VALUE * MULTI_STOREY_RATE  / 100.0' as expr, 
  NULL as previd, 
  'adjustment' as type, 
  '0' as addareatobldgtotalarea, 
  '100' as idx
from bldgrysetting r
;


DROP TABLE IF EXISTS `bldgtype_storeyadjustment_bldgkind`
;
DROP TABLE IF EXISTS `bldgtype_storeyadjustment`
;


CREATE TABLE `bldgtype_storeyadjustment` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `floorno` int(10) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgtype_storeyadjustment` (`bldgtypeid`,`floorno`,`rate`) USING BTREE,
  KEY `bldgtypeid` (`bldgtypeid`) USING BTREE,
  KEY `FK_bldgtype_storeyadjustment` (`previd`) USING BTREE,
  KEY `FK_bldgtype_storeyadjustment_bldgrysetting` (`bldgrysettingid`) USING BTREE,
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_1` FOREIGN KEY (`previd`) REFERENCES `bldgtype_storeyadjustment` (`objid`),
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_2` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_3` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `bldgtype_storeyadjustment_bldgkind` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `floorno` int(11) NOT NULL,
  `bldgkindid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgtype_kind_floorno` (`bldgtypeid`,`bldgkindid`,`floorno`),
  KEY `fk_storeyadjustment_bldgkind_bldgrysetting` (`bldgrysettingid`),
  KEY `fk_storeyadjustment_bldgkind_parent` (`parentid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgrysetting` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgtype` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_parent` FOREIGN KEY (`parentid`) REFERENCES `bldgtype_storeyadjustment` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop view if exists vw_assessment_notice_item;
drop view if exists vw_assessment_notice;
drop view if exists vw_batch_rpttaxcredit_error;
drop view if exists vw_batchgr;
drop view if exists vw_building;
drop view if exists vw_certification_land_improvement;
drop view if exists vw_certification_landdetail;
drop view if exists vw_faas_lookup;
drop view if exists vw_landtax_abstract_of_collection_detail;
drop view if exists vw_landtax_abstract_of_collection_detail_eor;
drop view if exists vw_landtax_collection_detail;
drop view if exists vw_landtax_collection_detail_eor;
drop view if exists vw_landtax_collection_disposition_detail;
drop view if exists vw_landtax_collection_disposition_detail_eor;
drop view if exists vw_landtax_collection_share_detail;
drop view if exists vw_landtax_collection_share_detail_eor;
drop view if exists vw_landtax_eor;
drop view if exists vw_landtax_eor_remittance;
drop view if exists vw_landtax_lgu_account_mapping;
drop view if exists vw_landtax_report_rptdelinquency_detail;
drop view if exists vw_landtax_report_rptdelinquency;
drop view if exists vw_machine_smv;
drop view if exists vw_machinery;
drop view if exists vw_newly_assessed_property;
drop view if exists vw_online_rptcertification;
drop view if exists vw_real_property_payment;
drop view if exists vw_report_orc;
drop view if exists vw_rptcertification_item;
drop view if exists vw_rptledger_avdifference;
drop view if exists vw_rptledger_cancelled_faas;
drop view if exists vw_rptpayment_item_detail;
drop view if exists vw_rpu_assessment;

drop table if exists vw_assessment_notice_item;
drop table if exists vw_assessment_notice;
drop table if exists vw_batch_rpttaxcredit_error;
drop table if exists vw_batchgr;
drop table if exists vw_building;
drop table if exists vw_certification_land_improvement;
drop table if exists vw_certification_landdetail;
drop table if exists vw_faas_lookup;
drop table if exists vw_landtax_abstract_of_collection_detail;
drop table if exists vw_landtax_abstract_of_collection_detail_eor;
drop table if exists vw_landtax_collection_detail;
drop table if exists vw_landtax_collection_detail_eor;
drop table if exists vw_landtax_collection_disposition_detail;
drop table if exists vw_landtax_collection_disposition_detail_eor;
drop table if exists vw_landtax_collection_share_detail;
drop table if exists vw_landtax_collection_share_detail_eor;
drop table if exists vw_landtax_eor;
drop table if exists vw_landtax_eor_remittance;
drop table if exists vw_landtax_lgu_account_mapping;
drop table if exists vw_landtax_report_rptdelinquency_detail;
drop table if exists vw_landtax_report_rptdelinquency;
drop table if exists vw_machine_smv;
drop table if exists vw_machinery;
drop table if exists vw_newly_assessed_property;
drop table if exists vw_online_rptcertification;
drop table if exists vw_real_property_payment;
drop table if exists vw_report_orc;
drop table if exists vw_rptcertification_item;
drop table if exists vw_rptledger_avdifference;
drop table if exists vw_rptledger_cancelled_faas;
drop table if exists vw_rptpayment_item_detail;
drop table if exists vw_rpu_assessment;


CREATE VIEW `vw_landtax_eor` AS select `eor`.`eor`.`objid` AS `objid`,`eor`.`eor`.`receiptno` AS `receiptno`,`eor`.`eor`.`receiptdate` AS `receiptdate`,`eor`.`eor`.`txndate` AS `txndate`,`eor`.`eor`.`state` AS `state`,`eor`.`eor`.`partnerid` AS `partnerid`,`eor`.`eor`.`txntype` AS `txntype`,`eor`.`eor`.`traceid` AS `traceid`,`eor`.`eor`.`tracedate` AS `tracedate`,`eor`.`eor`.`refid` AS `refid`,`eor`.`eor`.`paidby` AS `paidby`,`eor`.`eor`.`paidbyaddress` AS `paidbyaddress`,`eor`.`eor`.`payer_objid` AS `payer_objid`,`eor`.`eor`.`paymethod` AS `paymethod`,`eor`.`eor`.`paymentrefid` AS `paymentrefid`,`eor`.`eor`.`remittanceid` AS `remittanceid`,`eor`.`eor`.`remarks` AS `remarks`,`eor`.`eor`.`amount` AS `amount`,`eor`.`eor`.`lockid` AS `lockid` from `eor`.`eor`
;
CREATE VIEW `vw_landtax_eor_remittance` AS select `eor`.`eor_remittance`.`objid` AS `objid`,`eor`.`eor_remittance`.`state` AS `state`,`eor`.`eor_remittance`.`controlno` AS `controlno`,`eor`.`eor_remittance`.`partnerid` AS `partnerid`,`eor`.`eor_remittance`.`controldate` AS `controldate`,`eor`.`eor_remittance`.`dtcreated` AS `dtcreated`,`eor`.`eor_remittance`.`createdby_objid` AS `createdby_objid`,`eor`.`eor_remittance`.`createdby_name` AS `createdby_name`,`eor`.`eor_remittance`.`amount` AS `amount`,`eor`.`eor_remittance`.`dtposted` AS `dtposted`,`eor`.`eor_remittance`.`postedby_objid` AS `postedby_objid`,`eor`.`eor_remittance`.`postedby_name` AS `postedby_name`,`eor`.`eor_remittance`.`lockid` AS `lockid` from `eor`.`eor_remittance`
;

CREATE VIEW `vw_assessment_notice` AS select `a`.`objid` AS `objid`,`a`.`state` AS `state`,`a`.`txnno` AS `txnno`,`a`.`txndate` AS `txndate`,`a`.`taxpayerid` AS `taxpayerid`,`a`.`taxpayername` AS `taxpayername`,`a`.`taxpayeraddress` AS `taxpayeraddress`,`a`.`dtdelivered` AS `dtdelivered`,`a`.`receivedby` AS `receivedby`,`a`.`remarks` AS `remarks`,`a`.`assessmentyear` AS `assessmentyear`,`a`.`administrator_name` AS `administrator_name`,`a`.`administrator_address` AS `administrator_address`,`fl`.`tdno` AS `tdno`,`fl`.`displaypin` AS `fullpin`,`fl`.`cadastrallotno` AS `cadastrallotno`,`fl`.`titleno` AS `titleno` from ((`assessmentnotice` `a` join `assessmentnoticeitem` `i` on((`a`.`objid` = `i`.`assessmentnoticeid`))) join `faas_list` `fl` on((`i`.`faasid` = `fl`.`objid`)))
;
CREATE VIEW `vw_assessment_notice_item` AS select `ni`.`objid` AS `objid`,`ni`.`assessmentnoticeid` AS `assessmentnoticeid`,`f`.`objid` AS `faasid`,`f`.`effectivityyear` AS `effectivityyear`,`f`.`effectivityqtr` AS `effectivityqtr`,`f`.`tdno` AS `tdno`,`f`.`taxpayer_objid` AS `taxpayer_objid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`rpuid` AS `rpuid`,`f`.`lguid` AS `lguid`,`f`.`txntype_objid` AS `txntype_objid`,`ft`.`displaycode` AS `txntype_code`,`rpu`.`rputype` AS `rputype`,`rpu`.`ry` AS `ry`,`rpu`.`fullpin` AS `fullpin`,`rpu`.`taxable` AS `taxable`,`rpu`.`totalareaha` AS `totalareaha`,`rpu`.`totalareasqm` AS `totalareasqm`,`rpu`.`totalbmv` AS `totalbmv`,`rpu`.`totalmv` AS `totalmv`,`rpu`.`totalav` AS `totalav`,`rp`.`section` AS `section`,`rp`.`parcel` AS `parcel`,`rp`.`surveyno` AS `surveyno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`blockno` AS `blockno`,`rp`.`claimno` AS `claimno`,`rp`.`street` AS `street`,`o`.`name` AS `lguname`,`b`.`name` AS `barangay`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification` from (((((((((`assessmentnoticeitem` `ni` join `faas` `f` on((`ni`.`faasid` = `f`.`objid`))) left join `txnsignatory` `ts` on(((`ts`.`refid` = `f`.`objid`) and (`ts`.`type` = 'APPROVER')))) join `rpu` on((`f`.`rpuid` = `rpu`.`objid`))) join `propertyclassification` `pc` on((`rpu`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `o` on((`f`.`lguid` = `o`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`))) join `faas_txntype` `ft` on((`f`.`txntype_objid` = `ft`.`objid`)))
;
CREATE VIEW `vw_batch_rpttaxcredit_error` AS select `br`.`objid` AS `objid`,`br`.`parentid` AS `parentid`,`br`.`state` AS `state`,`br`.`error` AS `error`,`br`.`barangayid` AS `barangayid`,`rl`.`tdno` AS `tdno` from (`batch_rpttaxcredit_ledger` `br` join `rptledger` `rl` on((`br`.`objid` = `rl`.`objid`))) where (`br`.`state` = 'ERROR')
;
CREATE VIEW `vw_batchgr` AS select `bg`.`objid` AS `objid`,`bg`.`state` AS `state`,`bg`.`ry` AS `ry`,`bg`.`lgu_objid` AS `lgu_objid`,`bg`.`barangay_objid` AS `barangay_objid`,`bg`.`rputype` AS `rputype`,`bg`.`classification_objid` AS `classification_objid`,`bg`.`section` AS `section`,`bg`.`memoranda` AS `memoranda`,`bg`.`txntype_objid` AS `txntype_objid`,`bg`.`txnno` AS `txnno`,`bg`.`txndate` AS `txndate`,`bg`.`effectivityyear` AS `effectivityyear`,`bg`.`effectivityqtr` AS `effectivityqtr`,`bg`.`originlgu_objid` AS `originlgu_objid`,`l`.`name` AS `lgu_name`,`b`.`name` AS `barangay_name`,`b`.`pin` AS `barangay_pin`,`pc`.`name` AS `classification_name`,`t`.`objid` AS `taskid`,`t`.`state` AS `taskstate`,`t`.`assignee_objid` AS `assignee_objid` from ((((`batchgr` `bg` join `sys_org` `l` on((`bg`.`lgu_objid` = `l`.`objid`))) left join `barangay` `b` on((`bg`.`barangay_objid` = `b`.`objid`))) left join `propertyclassification` `pc` on((`bg`.`classification_objid` = `pc`.`objid`))) left join `batchgr_task` `t` on(((`bg`.`objid` = `t`.`refid`) and isnull(`t`.`enddate`))))
;
CREATE VIEW `vw_building` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`f`.`rpuid` AS `rpuid`,`f`.`realpropertyid` AS `realpropertyid`,`f`.`tdno` AS `tdno`,`f`.`fullpin` AS `fullpin`,`f`.`taxpayer_objid` AS `taxpayer_objid`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`lguid` AS `lgu_objid`,`o`.`name` AS `lgu_name`,`b`.`objid` AS `barangay_objid`,`b`.`name` AS `barangay_name`,`r`.`classification_objid` AS `classification_objid`,`pc`.`name` AS `classification_name`,`rp`.`pin` AS `pin`,`rp`.`section` AS `section`,`rp`.`ry` AS `ry`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`blockno` AS `blockno`,`rp`.`surveyno` AS `surveyno`,`bt`.`objid` AS `bldgtype_objid`,`bt`.`name` AS `bldgtype_name`,`bk`.`objid` AS `bldgkind_objid`,`bk`.`name` AS `bldgkind_name`,`bu`.`basemarketvalue` AS `basemarketvalue`,`bu`.`adjustment` AS `adjustment`,`bu`.`depreciationvalue` AS `depreciationvalue`,`bu`.`marketvalue` AS `marketvalue`,`bu`.`assessedvalue` AS `assessedvalue`,`al`.`objid` AS `actualuse_objid`,`al`.`name` AS `actualuse_name`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalmv` AS `totalmv`,`r`.`totalav` AS `totalav` from (((((((((((`faas` `f` join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `o` on((`f`.`lguid` = `o`.`objid`))) join `bldgrpu_structuraltype` `bst` on((`r`.`objid` = `bst`.`bldgrpuid`))) join `bldgtype` `bt` on((`bst`.`bldgtype_objid` = `bt`.`objid`))) join `bldgkindbucc` `bucc` on((`bst`.`bldgkindbucc_objid` = `bucc`.`objid`))) join `bldgkind` `bk` on((`bucc`.`bldgkind_objid` = `bk`.`objid`))) join `bldguse` `bu` on((`bst`.`objid` = `bu`.`structuraltype_objid`))) join `bldgassesslevel` `al` on((`bu`.`actualuse_objid` = `al`.`objid`)))
;
CREATE VIEW `vw_certification_land_improvement` AS select `f`.`objid` AS `faasid`,`pt`.`name` AS `improvement`,`ptd`.`areacovered` AS `areacovered`,`ptd`.`productive` AS `productive`,`ptd`.`nonproductive` AS `nonproductive`,`ptd`.`basemarketvalue` AS `basemarketvalue`,`ptd`.`marketvalue` AS `marketvalue`,`ptd`.`unitvalue` AS `unitvalue`,`ptd`.`assessedvalue` AS `assessedvalue` from ((`faas` `f` join `planttreedetail` `ptd` on((`f`.`rpuid` = `ptd`.`landrpuid`))) join `planttree` `pt` on((`ptd`.`planttree_objid` = `pt`.`objid`)))
;
CREATE VIEW `vw_certification_landdetail` AS select `f`.`objid` AS `faasid`,`ld`.`areaha` AS `areaha`,`ld`.`areasqm` AS `areasqm`,`ld`.`assessedvalue` AS `assessedvalue`,`ld`.`marketvalue` AS `marketvalue`,`ld`.`basemarketvalue` AS `basemarketvalue`,`ld`.`unitvalue` AS `unitvalue`,`lspc`.`name` AS `specificclass_name` from ((`faas` `f` join `landdetail` `ld` on((`f`.`rpuid` = `ld`.`landrpuid`))) join `landspecificclass` `lspc` on((`ld`.`landspecificclass_objid` = `lspc`.`objid`)))
;
CREATE VIEW `vw_faas_lookup` AS select `fl`.`objid` AS `objid`,`fl`.`state` AS `state`,`fl`.`rpuid` AS `rpuid`,`fl`.`utdno` AS `utdno`,`fl`.`tdno` AS `tdno`,`fl`.`txntype_objid` AS `txntype_objid`,`fl`.`effectivityyear` AS `effectivityyear`,`fl`.`effectivityqtr` AS `effectivityqtr`,`fl`.`taxpayer_objid` AS `taxpayer_objid`,`fl`.`owner_name` AS `owner_name`,`fl`.`owner_address` AS `owner_address`,`fl`.`prevtdno` AS `prevtdno`,`fl`.`cancelreason` AS `cancelreason`,`fl`.`cancelledbytdnos` AS `cancelledbytdnos`,`fl`.`lguid` AS `lguid`,`fl`.`realpropertyid` AS `realpropertyid`,`fl`.`displaypin` AS `fullpin`,`fl`.`originlguid` AS `originlguid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`pc`.`code` AS `classification_code`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification_name`,`pc`.`name` AS `classname`,`fl`.`ry` AS `ry`,`fl`.`rputype` AS `rputype`,`fl`.`totalmv` AS `totalmv`,`fl`.`totalav` AS `totalav`,`fl`.`totalareasqm` AS `totalareasqm`,`fl`.`totalareaha` AS `totalareaha`,`fl`.`barangayid` AS `barangayid`,`fl`.`cadastrallotno` AS `cadastrallotno`,`fl`.`blockno` AS `blockno`,`fl`.`surveyno` AS `surveyno`,`fl`.`pin` AS `pin`,`fl`.`barangay` AS `barangay_name`,`fl`.`trackingno` AS `trackingno` from ((`faas_list` `fl` left join `propertyclassification` `pc` on((`fl`.`classification_objid` = `pc`.`objid`))) left join `entity` `e` on((`fl`.`taxpayer_objid` = `e`.`objid`)))
;
CREATE VIEW `vw_landtax_abstract_of_collection_detail` AS select `liq`.`objid` AS `liquidationid`,`liq`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`dtposted` AS `remittancedate`,`cr`.`objid` AS `receiptid`,`cr`.`receiptdate` AS `ordate`,`cr`.`receiptno` AS `orno`,`cr`.`collector_objid` AS `collectorid`,`rl`.`objid` AS `rptledgerid`,`rl`.`fullpin` AS `fullpin`,`rl`.`titleno` AS `titleno`,`rl`.`cadastrallotno` AS `cadastrallotno`,`rl`.`rputype` AS `rputype`,`rl`.`totalmv` AS `totalmv`,`b`.`name` AS `barangay`,`rp`.`fromqtr` AS `fromqtr`,`rp`.`toqtr` AS `toqtr`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revtype` AS `revtype`,(case when isnull(`cv`.`objid`) then `rl`.`owner_name` else '*** voided ***' end) AS `taxpayername`,(case when isnull(`cv`.`objid`) then `rl`.`tdno` else '' end) AS `tdno`,(case when isnull(`m`.`name`) then `c`.`name` else `m`.`name` end) AS `municityname`,(case when isnull(`cv`.`objid`) then `rl`.`classcode` else '' end) AS `classification`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessvalue`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessedvalue`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basiccurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic')) then `rpi`.`discount` else 0.0 end) AS `basicdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `sefcurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `sefpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef')) then `rpi`.`discount` else 0.0 end) AS `sefdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basicidlecurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicidleprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle')) then `rpi`.`amount` else 0.0 end) AS `basicidlediscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicidlecurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicidlepreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `shcurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `shprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh')) then `rpi`.`discount` else 0.0 end) AS `shdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `shcurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `shpreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'firecode')) then `rpi`.`amount` else 0.0 end) AS `firecode`,(case when isnull(`cv`.`objid`) then ((`rpi`.`amount` - `rpi`.`discount`) + `rpi`.`interest`) else 0.0 end) AS `total`,(case when isnull(`cv`.`objid`) then `rpi`.`partialled` else 0 end) AS `partialled` from ((((((((((`collectionvoucher` `liq` join `remittance` `rem` on((`rem`.`collectionvoucherid` = `liq`.`objid`))) join `cashreceipt` `cr` on((`rem`.`objid` = `cr`.`remittanceid`))) left join `cashreceipt_void` `cv` on((`cr`.`objid` = `cv`.`receiptid`))) join `rptpayment` `rp` on((`rp`.`receiptid` = `cr`.`objid`))) join `rptpayment_item` `rpi` on((`rpi`.`parentid` = `rp`.`objid`))) join `rptledger` `rl` on((`rl`.`objid` = `rp`.`refid`))) join `barangay` `b` on((`b`.`objid` = `rl`.`barangayid`))) left join `district` `d` on((`b`.`parentid` = `d`.`objid`))) left join `city` `c` on((`d`.`parentid` = `c`.`objid`))) left join `municipality` `m` on((`b`.`parentid` = `m`.`objid`)))
;
CREATE VIEW `vw_landtax_abstract_of_collection_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`objid` AS `receiptid`,`eor`.`receiptdate` AS `ordate`,`eor`.`receiptno` AS `orno`,`rem`.`createdby_objid` AS `collectorid`,`rl`.`objid` AS `rptledgerid`,`rl`.`fullpin` AS `fullpin`,`rl`.`titleno` AS `titleno`,`rl`.`cadastrallotno` AS `cadastrallotno`,`rl`.`rputype` AS `rputype`,`rl`.`totalmv` AS `totalmv`,`b`.`name` AS `barangay`,`rp`.`fromqtr` AS `fromqtr`,`rp`.`toqtr` AS `toqtr`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revtype` AS `revtype`,(case when isnull(`cv`.`objid`) then `rl`.`owner_name` else '*** voided ***' end) AS `taxpayername`,(case when isnull(`cv`.`objid`) then `rl`.`tdno` else '' end) AS `tdno`,(case when isnull(`m`.`name`) then `c`.`name` else `m`.`name` end) AS `municityname`,(case when isnull(`cv`.`objid`) then `rl`.`classcode` else '' end) AS `classification`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessvalue`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessedvalue`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basiccurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic')) then `rpi`.`discount` else 0.0 end) AS `basicdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `sefcurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `sefpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef')) then `rpi`.`discount` else 0.0 end) AS `sefdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basicidlecurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicidleprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle')) then `rpi`.`amount` else 0.0 end) AS `basicidlediscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicidlecurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicidlepreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `shcurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `shprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh')) then `rpi`.`discount` else 0.0 end) AS `shdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `shcurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `shpreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'firecode')) then `rpi`.`amount` else 0.0 end) AS `firecode`,(case when isnull(`cv`.`objid`) then ((`rpi`.`amount` - `rpi`.`discount`) + `rpi`.`interest`) else 0.0 end) AS `total`,(case when isnull(`cv`.`objid`) then `rpi`.`partialled` else 0 end) AS `partialled` from (((((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) left join `cashreceipt_void` `cv` on((`eor`.`objid` = `cv`.`receiptid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `rpi` on((`rpi`.`parentid` = `rp`.`objid`))) join `rptledger` `rl` on((`rl`.`objid` = `rp`.`refid`))) join `barangay` `b` on((`b`.`objid` = `rl`.`barangayid`))) left join `district` `d` on((`b`.`parentid` = `d`.`objid`))) left join `city` `c` on((`d`.`parentid` = `c`.`objid`))) left join `municipality` `m` on((`b`.`parentid` = `m`.`objid`)))
;
CREATE VIEW `vw_landtax_collection_detail` AS 
select 
  `cv`.`objid` AS `liquidationid`,
  `cv`.`controldate` AS `liquidationdate`,
  `rem`.`objid` AS `remittanceid`,
  `rem`.`controldate` AS `remittancedate`,
  `cr`.`receiptdate` AS `receiptdate`,
  `o`.`objid` AS `lguid`,
  `o`.`name` AS `lgu`,
  `b`.`objid` AS `barangayid`,
  `b`.`indexno` AS `brgyindex`,
  `b`.`name` AS `barangay`,
  `ri`.`revperiod` AS `revperiod`,
  `ri`.`revtype` AS `revtype`,
  `ri`.`year` AS `year`,
  `ri`.`qtr` AS `qtr`,
  `ri`.`amount` AS `amount`,
  `ri`.`interest` AS `interest`,
  `ri`.`discount` AS `discount`,
  `pc`.`name` AS `classname`,
  `pc`.`orderno` AS `orderno`,
  `pc`.`special` AS `special`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basiccurrent`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0.0 end) AS `basicdisc`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basicprev`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basiccurrentint`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basicprevint`,
  (case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `basicnet`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefcurrent`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0.0 end) AS `sefdisc`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefprev`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefcurrentint`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefprevint`,
  (case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `sefnet`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idlecurrent`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idleprev`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0.0 end) AS `idledisc`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `idleint`,
  (case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `idlenet`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shcurrent`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shprev`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0.0 end) AS `shdisc`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,
  (case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `shnet`,
  (case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `firecode`,
  0.0 AS `levynet`,
  case when crv.objid is null then 0 else 1 end as voided
from (((((((((`remittance` `rem` 
join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) 
join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) left 
join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`))) 
join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) 
join `rptpayment_item` `ri` on((`rp`.`objid` = `ri`.`parentid`))) left 
join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left 
join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left 
join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left 
join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`))) 
;
CREATE VIEW `vw_landtax_collection_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`receiptdate` AS `receiptdate`,`o`.`objid` AS `lguid`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`indexno` AS `brgyindex`,`b`.`name` AS `barangay`,`ri`.`revperiod` AS `revperiod`,`ri`.`revtype` AS `revtype`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`ri`.`amount` AS `amount`,`ri`.`interest` AS `interest`,`ri`.`discount` AS `discount`,`pc`.`name` AS `classname`,`pc`.`orderno` AS `orderno`,`pc`.`special` AS `special`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basiccurrent`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0.0 end) AS `basicdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basicprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basiccurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basicprevint`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `basicnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefcurrent`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0.0 end) AS `sefdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefcurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefprevint`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `sefnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idlecurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idleprev`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0.0 end) AS `idledisc`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `idleint`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `idlenet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shcurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shprev`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0.0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `shnet`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `firecode`,0.0 AS `levynet` from (((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `ri` on((`rp`.`objid` = `ri`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`)))
;
CREATE VIEW `vw_landtax_collection_disposition_detail` 
AS 
select 
  `cv`.`objid` AS `liquidationid`,
  `cv`.`controldate` AS `liquidationdate`,
  `rem`.`objid` AS `remittanceid`,
  `rem`.`controldate` AS `remittancedate`,
  `cr`.`receiptdate` AS `receiptdate`,
  `ri`.`revperiod` AS `revperiod`,
  (case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitybasicshare`,
  (case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munibasicshare`,
  (case when ((`ri`.`revtype` in ('basic','basicint')) and (`ri`.`sharetype` = 'barangay')) then `ri`.`amount` else 0.0 end) AS `brgybasicshare`,
  (case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitysefshare`,
  (case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munisefshare`,
  0.0 AS `brgysefshare`,
  case when crv.objid is null then 0 else 1 end as voided
from (((((`remittance` `rem` 
join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) 
join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) left 
join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`))) 
join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) 
join `rptpayment_share` `ri` on((`rp`.`objid` = `ri`.`parentid`))) 
;
CREATE VIEW `vw_landtax_collection_disposition_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`receiptdate` AS `receiptdate`,`ri`.`revperiod` AS `revperiod`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitybasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munibasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint')) and (`ri`.`sharetype` = 'barangay')) then `ri`.`amount` else 0.0 end) AS `brgybasicshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitysefshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munisefshare`,0.0 AS `brgysefshare` from (((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `ri` on((`rp`.`objid` = `ri`.`parentid`)))
;
CREATE VIEW `vw_landtax_collection_share_detail` AS select `cv`.`objid` AS `liquidationid`,`cv`.`controlno` AS `liquidationno`,`cv`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controlno` AS `remittanceno`,`rem`.`controldate` AS `remittancedate`,`cr`.`objid` AS `receiptid`,`cr`.`receiptno` AS `receiptno`,`cr`.`receiptdate` AS `receiptdate`,`cr`.`txndate` AS `txndate`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`name` AS `barangay`,`cra`.`revtype` AS `revtype`,`cra`.`revperiod` AS `revperiod`,`cra`.`sharetype` AS `sharetype`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgycurr`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgyprev`,(case when (`cra`.`revtype` = 'basicint') then `cra`.`amount` else 0 end) AS `brgypenalty`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgyprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `cityprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunicurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmuniprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunipenaltyshare`,`cra`.`amount` AS `amount`,`cra`.`discount` AS `discount`,(case when isnull(`crv`.`objid`) then 0 else 1 end) AS `voided` from ((((((((`remittance` `rem` join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `cra` on((`rp`.`objid` = `cra`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`)))
;
CREATE VIEW `vw_landtax_collection_share_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controlno` AS `liquidationno`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controlno` AS `remittanceno`,`rem`.`controldate` AS `remittancedate`,`eor`.`objid` AS `receiptid`,`eor`.`receiptno` AS `receiptno`,`eor`.`receiptdate` AS `receiptdate`,`eor`.`txndate` AS `txndate`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`name` AS `barangay`,`cra`.`revtype` AS `revtype`,`cra`.`revperiod` AS `revperiod`,`cra`.`sharetype` AS `sharetype`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgycurr`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgyprev`,(case when (`cra`.`revtype` = 'basicint') then `cra`.`amount` else 0 end) AS `brgypenalty`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgyprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `cityprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunicurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmuniprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunipenaltyshare`,`cra`.`amount` AS `amount`,`cra`.`discount` AS `discount` from (((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `cra` on((`rp`.`objid` = `cra`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `cashreceipt_void` `crv` on((`eor`.`objid` = `crv`.`receiptid`)))
;
CREATE VIEW `vw_landtax_lgu_account_mapping` AS select `ia`.`org_objid` AS `org_objid`,`ia`.`org_name` AS `org_name`,`o`.`orgclass` AS `org_class`,`p`.`objid` AS `parent_objid`,`p`.`code` AS `parent_code`,`p`.`title` AS `parent_title`,`ia`.`objid` AS `item_objid`,`ia`.`code` AS `item_code`,`ia`.`title` AS `item_title`,`ia`.`fund_objid` AS `item_fund_objid`,`ia`.`fund_code` AS `item_fund_code`,`ia`.`fund_title` AS `item_fund_title`,`ia`.`type` AS `item_type`,`pt`.`tag` AS `item_tag` from (((`itemaccount` `ia` join `itemaccount` `p` on((`ia`.`parentid` = `p`.`objid`))) join `itemaccount_tag` `pt` on((`p`.`objid` = `pt`.`acctid`))) join `sys_org` `o` on((`ia`.`org_objid` = `o`.`objid`))) where (`p`.`state` = 'ACTIVE')
;
CREATE VIEW `vw_landtax_report_rptdelinquency` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;
CREATE VIEW `vw_landtax_report_rptdelinquency_detail` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;
CREATE VIEW `vw_machine_smv` AS select `ms`.`objid` AS `objid`,`ms`.`parent_objid` AS `parent_objid`,`ms`.`machine_objid` AS `machine_objid`,`ms`.`expr` AS `expr`,`ms`.`previd` AS `previd`,`m`.`code` AS `code`,`m`.`name` AS `name` from (`machine_smv` `ms` join `machine` `m` on((`ms`.`machine_objid` = `m`.`objid`)))
;
CREATE VIEW `vw_machinery` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`f`.`rpuid` AS `rpuid`,`f`.`realpropertyid` AS `realpropertyid`,`f`.`tdno` AS `tdno`,`f`.`fullpin` AS `fullpin`,`f`.`taxpayer_objid` AS `taxpayer_objid`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`lguid` AS `lgu_objid`,`o`.`name` AS `lgu_name`,`b`.`objid` AS `barangay_objid`,`b`.`name` AS `barangay_name`,`r`.`classification_objid` AS `classification_objid`,`pc`.`name` AS `classification_name`,`rp`.`pin` AS `pin`,`rp`.`section` AS `section`,`rp`.`ry` AS `ry`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`blockno` AS `blockno`,`rp`.`surveyno` AS `surveyno`,`m`.`objid` AS `machine_objid`,`m`.`name` AS `machine_name`,`mu`.`basemarketvalue` AS `basemarketvalue`,`mu`.`marketvalue` AS `marketvalue`,`mu`.`assessedvalue` AS `assessedvalue`,`al`.`objid` AS `actualuse_objid`,`al`.`name` AS `actualuse_name`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalmv` AS `totalmv`,`r`.`totalav` AS `totalav` from (((((((((`faas` `f` join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `o` on((`f`.`lguid` = `o`.`objid`))) join `machuse` `mu` on((`r`.`objid` = `mu`.`machrpuid`))) join `machdetail` `md` on((`mu`.`objid` = `md`.`machuseid`))) join `machine` `m` on((`md`.`machine_objid` = `m`.`objid`))) join `machassesslevel` `al` on((`mu`.`actualuse_objid` = `al`.`objid`)))
;
CREATE VIEW `vw_newly_assessed_property` AS select `f`.`objid` AS `objid`,`f`.`owner_name` AS `owner_name`,`f`.`tdno` AS `tdno`,`b`.`name` AS `barangay`,(case when (`f`.`rputype` = 'land') then 'LAND' when (`f`.`rputype` = 'bldg') then 'BUILDING' when (`f`.`rputype` = 'mach') then 'MACHINERY' when (`f`.`rputype` = 'planttree') then 'PLANT/TREE' else 'MISCELLANEOUS' end) AS `rputype`,`f`.`totalav` AS `totalav`,`f`.`effectivityyear` AS `effectivityyear` from (`faas_list` `f` join `barangay` `b` on((`f`.`barangayid` = `b`.`objid`))) where ((`f`.`state` in ('CURRENT','CANCELLED')) and (`f`.`txntype_objid` = 'ND'))
;
CREATE VIEW `vw_online_rptcertification` AS select `c`.`objid` AS `objid`,`c`.`txnno` AS `txnno`,`c`.`txndate` AS `txndate`,`c`.`opener` AS `opener`,`c`.`taxpayer_objid` AS `taxpayer_objid`,`c`.`taxpayer_name` AS `taxpayer_name`,`c`.`taxpayer_address` AS `taxpayer_address`,`c`.`requestedby` AS `requestedby`,`c`.`requestedbyaddress` AS `requestedbyaddress`,`c`.`certifiedby` AS `certifiedby`,`c`.`certifiedbytitle` AS `certifiedbytitle`,`c`.`official` AS `official`,`c`.`purpose` AS `purpose`,`c`.`orno` AS `orno`,`c`.`ordate` AS `ordate`,`c`.`oramount` AS `oramount`,`c`.`taskid` AS `taskid`,`t`.`state` AS `task_state`,`t`.`startdate` AS `task_startdate`,`t`.`enddate` AS `task_enddate`,`t`.`assignee_objid` AS `task_assignee_objid`,`t`.`assignee_name` AS `task_assignee_name`,`t`.`actor_objid` AS `task_actor_objid`,`t`.`actor_name` AS `task_actor_name` from (`rptcertification` `c` join `rptcertification_task` `t` on((`c`.`taskid` = `t`.`objid`)))
;
CREATE VIEW `vw_real_property_payment` AS select `cv`.`controldate` AS `cv_controldate`,`rem`.`controldate` AS `rem_controldate`,`rl`.`owner_name` AS `owner_name`,`rl`.`tdno` AS `tdno`,`pc`.`name` AS `classification`,(case when (`rl`.`rputype` = 'land') then 'LAND' when (`rl`.`rputype` = 'bldg') then 'BUILDING' when (`rl`.`rputype` = 'mach') then 'MACHINERY' when (`rl`.`rputype` = 'planttree') then 'PLANT/TREE' else 'MISCELLANEOUS' end) AS `rputype`,`b`.`name` AS `barangay`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) AS `amount`,(case when isnull(`v`.`objid`) then 0 else 1 end) AS `voided` from ((((((((`collectionvoucher` `cv` join `remittance` `rem` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) join `cashreceipt` `cr` on((`rem`.`objid` = `cr`.`remittanceid`))) join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `rpi` on((`rp`.`objid` = `rpi`.`parentid`))) join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`))) left join `cashreceipt_void` `v` on((`cr`.`objid` = `v`.`receiptid`)))
;
CREATE VIEW `vw_report_orc` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`e`.`objid` AS `taxpayerid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`o`.`name` AS `lgu_name`,`o`.`code` AS `lgu_indexno`,`f`.`dtapproved` AS `dtapproved`,`r`.`rputype` AS `rputype`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification`,`f`.`fullpin` AS `pin`,`f`.`titleno` AS `titleno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`f`.`tdno` AS `tdno`,'' AS `arpno`,`f`.`prevowner` AS `prevowner`,`b`.`name` AS `location`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalmv` AS `totalmv`,`r`.`totalav` AS `totalav`,(case when (`f`.`state` = 'CURRENT') then '' else 'CANCELLED' end) AS `remarks` from ((((((`faas` `f` join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`))) join `sys_org` `o` on((`rp`.`lguid` = `o`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) where (`f`.`state` in ('CURRENT','CANCELLED'))
;
CREATE VIEW `vw_rptcertification_item` AS select `rci`.`rptcertificationid` AS `rptcertificationid`,`f`.`objid` AS `faasid`,`f`.`fullpin` AS `fullpin`,`f`.`tdno` AS `tdno`,`e`.`objid` AS `taxpayerid`,`e`.`name` AS `taxpayer_name`,`f`.`owner_name` AS `owner_name`,`f`.`administrator_name` AS `administrator_name`,`f`.`titleno` AS `titleno`,`f`.`rpuid` AS `rpuid`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classname`,`so`.`name` AS `lguname`,`b`.`name` AS `barangay`,`r`.`rputype` AS `rputype`,`r`.`suffix` AS `suffix`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalav` AS `totalav`,`r`.`totalmv` AS `totalmv`,`rp`.`street` AS `street`,`rp`.`blockno` AS `blockno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`surveyno` AS `surveyno`,`r`.`taxable` AS `taxable`,`f`.`effectivityyear` AS `effectivityyear`,`f`.`effectivityqtr` AS `effectivityqtr` from (((((((`rptcertificationitem` `rci` join `faas` `f` on((`rci`.`refid` = `f`.`objid`))) join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `so` on((`f`.`lguid` = `so`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`)))
;
CREATE VIEW `vw_rptledger_avdifference` AS select `rlf`.`objid` AS `objid`,'APPROVED' AS `state`,`d`.`parent_objid` AS `rptledgerid`,`rl`.`faasid` AS `faasid`,`rl`.`tdno` AS `tdno`,`rlf`.`txntype_objid` AS `txntype_objid`,`rlf`.`classification_objid` AS `classification_objid`,`rlf`.`actualuse_objid` AS `actualuse_objid`,`rlf`.`taxable` AS `taxable`,`rlf`.`backtax` AS `backtax`,`d`.`year` AS `fromyear`,1 AS `fromqtr`,`d`.`year` AS `toyear`,4 AS `toqtr`,`d`.`av` AS `assessedvalue`,1 AS `systemcreated`,`rlf`.`reclassed` AS `reclassed`,`rlf`.`idleland` AS `idleland`,1 AS `taxdifference` from ((`rptledger_avdifference` `d` join `rptledgerfaas` `rlf` on((`d`.`rptledgerfaas_objid` = `rlf`.`objid`))) join `rptledger` `rl` on((`d`.`parent_objid` = `rl`.`objid`)))
;
CREATE VIEW `vw_rptledger_cancelled_faas` AS select `rl`.`objid` AS `objid`,`rl`.`state` AS `state`,`rl`.`faasid` AS `faasid`,`rl`.`lastyearpaid` AS `lastyearpaid`,`rl`.`lastqtrpaid` AS `lastqtrpaid`,`rl`.`barangayid` AS `barangayid`,`rl`.`taxpayer_objid` AS `taxpayer_objid`,`rl`.`fullpin` AS `fullpin`,`rl`.`tdno` AS `tdno`,`rl`.`cadastrallotno` AS `cadastrallotno`,`rl`.`rputype` AS `rputype`,`rl`.`txntype_objid` AS `txntype_objid`,`rl`.`classification_objid` AS `classification_objid`,`rl`.`classcode` AS `classcode`,`rl`.`totalav` AS `totalav`,`rl`.`totalmv` AS `totalmv`,`rl`.`totalareaha` AS `totalareaha`,`rl`.`taxable` AS `taxable`,`rl`.`owner_name` AS `owner_name`,`rl`.`prevtdno` AS `prevtdno`,`rl`.`titleno` AS `titleno`,`rl`.`administrator_name` AS `administrator_name`,`rl`.`blockno` AS `blockno`,`rl`.`lguid` AS `lguid`,`rl`.`beneficiary_objid` AS `beneficiary_objid`,`pc`.`name` AS `classification`,`b`.`name` AS `barangay`,`o`.`name` AS `lgu` from (((((`rptledger` `rl` join `faas` `f` on((`rl`.`faasid` = `f`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`))) join `entity` `e` on((`rl`.`taxpayer_objid` = `e`.`objid`))) where ((`rl`.`state` = 'APPROVED') and (`f`.`state` = 'CANCELLED'))
;
CREATE VIEW `vw_rptpayment_item_detail` AS select `rpi`.`objid` AS `objid`,`rpi`.`parentid` AS `parentid`,`rpi`.`rptledgerfaasid` AS `rptledgerfaasid`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revperiod` AS `revperiod`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`amount` else 0 end) AS `basic`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`interest` else 0 end) AS `basicint`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`discount` else 0 end) AS `basicdisc`,(case when (`rpi`.`revtype` = 'basic') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicdp`,(case when (`rpi`.`revtype` = 'basic') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicnet`,(case when (`rpi`.`revtype` = 'basicidle') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicidle`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`interest` else 0 end) AS `basicidleint`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`discount` else 0 end) AS `basicidledisc`,(case when (`rpi`.`revtype` = 'basicidle') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicidledp`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`amount` else 0 end) AS `sef`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`interest` else 0 end) AS `sefint`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`discount` else 0 end) AS `sefdisc`,(case when (`rpi`.`revtype` = 'sef') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `sefdp`,(case when (`rpi`.`revtype` = 'sef') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sefnet`,(case when (`rpi`.`revtype` = 'firecode') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `firecode`,(case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sh`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`interest` else 0 end) AS `shint`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`discount` else 0 end) AS `shdisc`,(case when (`rpi`.`revtype` = 'sh') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `shdp`,(case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `shnet`,((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) AS `amount`,`rpi`.`partialled` AS `partialled` from `rptpayment_item` `rpi`
;
CREATE VIEW `vw_rpu_assessment` AS select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `landassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `bldgassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `machassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `planttreeassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `miscassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`)))
;
DROP VIEW IF EXISTS `vw_txn_log`
;
CREATE VIEW `vw_txn_log` AS select distinct `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`txndate` AS `txndate`,`t`.`ref` AS `ref`,`t`.`action` AS `action`,1 AS `cnt` from (`txnlog` `t` join `sys_user` `u` on((`t`.`userid` = `u`.`objid`))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'faas' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`faas_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%assign%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'subdivision' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%assign%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'consolidation' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%consolidation%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'cancelledfaas' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%cancelledfaas%')))
;




/* CHANGE RPUT TYPE  */
INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`, `checkbalance`, `reconcileledger`, `allowannotated`) VALUES ('CK', 'Change Kind', '0', '1', '1', 'DP', '1', '1', '1', '1', '', '0', '0', '0')
;


/* EXAMINATION FINDING */
alter table examiner_finding add txnno varchar(25)
;

create table zzztmp_examiner_finding 
select * from examiner_finding
;

alter table zzztmp_examiner_finding  add oid int auto_increment primary key
;

create index ix_objid on zzztmp_examiner_finding (objid)
;

update examiner_finding f, zzztmp_examiner_finding z set 
	f.txnno = concat('S', lpad(z.oid, 6, '0'))
where f.objid = z.objid 
;

drop table zzztmp_examiner_finding
;

create unique index ix_txnno on examiner_finding ( txnno) 
;



/* OCULAR INSPECTION */
drop view if exists vw_ocular_inspection 
;

create view vw_ocular_inspection 
as 
select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join faas f on ef.parent_objid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  


union all 



select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join subdivision_motherland sm on ef.parent_objid = sm.subdivisionid  
  join faas f on sm.landfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join consolidation c on ef.parent_objid = c.objid  
  join faas f on c.newfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  '' AS owner_name,
  '' AS owner_address,
  '' AS titleno,
  '' AS fullpin,
  '' AS blockno,
  '' AS cadastrallotno,
  0 AS totalareaha,
  0 AS totalareasqm,
  0 AS totalmv,
  0 AS totalav,
  o.objid AS lguid,
  o.name AS lgu_name,
  b.objid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  '' AS purok,
  '' AS street 
from  examiner_finding ef 
  join batchgr bgr on ef.parent_objid = bgr.objid  
  join sys_org b on bgr.barangay_objid = b.objid  
  join sys_org o on bgr.lgu_objid = o.objid 

union all 

select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join cancelledfaas cf on ef.parent_objid = cf.objid  
join faas f on cf.faasid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  
;
/* SUBDIVISION VIEWS */
drop view if exists vw_report_subdividedland
;

create view vw_report_subdividedland
as 
select 
	sl.objid,
	s.objid as subdivisionid,
	s.txnno, 
	b.name as barangay,
	o.name as lguname,
	pc.code as classcode,
	f.tdno,
	f.owner_name,
	f.administrator_name,
	f.titleno,
	f.lguid,
	f.titledate,
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.rputype,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	f.txntype_objid,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name
from subdividedland sl 
	inner join subdivision s on sl.subdivisionid = s.objid 
	inner join faas f on sl.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
;

drop view if exists vw_report_motherland_summary
;

create view vw_report_motherland_summary
as 
select 
	m.subdivisionid,
	f.tdno,
	f.owner_name,
	b.name as barangay,
	o.name as lguname,
	f.titleno,
	f.titledate,
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.administrator_name,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from subdivision_motherland m
	inner join faas f on m.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
;



/* CONSOLIDATION VIEWS */
drop view if exists vw_report_consolidation
;

create view vw_report_consolidation
as 
select 
	c.objid,
	c.txnno,
	b.name as barangay,
	o.name as lguname,
	f.tdno,
	f.owner_name,
	f.administrator_name,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.txntype_objid,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from consolidation c
	inner join faas f on c.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 	
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
;

drop view if exists vw_report_consolidated_land
;

create view vw_report_consolidated_land
as 
select 
	cl.consolidationid,
	f.tdno,
	f.owner_name,
	b.name as barangay,
	o.name as lguname,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.administrator_name,
	f.txntype_objid,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from consolidatedland cl 
	inner join faas f on cl.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
;



/* SYNC2: DOWNLOADED */
drop table if exists rpt_syncdata_downloaded
; 

CREATE TABLE `rpt_syncdata_downloaded` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

insert into rpt_syncdata_downloaded(
	objid, 
	etag,
	error
)
select 
	objid,
	etag,
	error
from rpt_syncdata_fordownload
where state = 'DOWNLOADED'
;

insert into rpt_syncdata_downloaded(
	objid, 
	etag,
	error
)
select 
	filekey,
	'-',
	1
from rpt_syncdata_error
;

delete from rpt_syncdata_fordownload 
where state = 'DOWNLOADED'
;



/* REPORT VIEW: OCULAR INSPECTION */
DROP VIEW IF EXISTS `vw_ocular_inspection` 
;

CREATE VIEW `vw_ocular_inspection` 
AS 
select 
  `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
join `faas` `f` on `ef`.`parent_objid` = `f`.`objid`  
join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
left join `subdivision_motherland` `sm` on `ef`.`parent_objid` = `sm`.`subdivisionid`  
left join `faas` `f` on `sm`.`landfaasid` = `f`.`objid`  
left join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
left join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
left join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
left join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
join `consolidation` `c` on `ef`.`parent_objid` = `c`.`objid`  
left join `faas` `f` on `c`.`newfaasid` = `f`.`objid`  
left join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
left join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
left join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
left join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,'
  ' AS `owner_name`,'
  ' AS `owner_address`,'
  ' AS `titleno`,'
  ' AS `fullpin`,'
  ' AS `blockno`,'
  ' AS `cadastrallotno`
  ,0 AS `totalareaha`
  ,0 AS `totalareasqm`
  ,0 AS `totalmv`
  ,0 AS `totalav`,
  `o`.`objid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `b`.`objid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,'
  ' AS `purok`,'
  ' AS `street` 
from  `examiner_finding` `ef` 
join `batchgr` `bgr` on `ef`.`parent_objid` = `bgr`.`objid`  
join `sys_org` `b` on `bgr`.`barangay_objid` = `b`.`objid`  
join `sys_org` `o` on `bgr`.`lgu_objid` = `o`.`objid` 
;


drop view if exists vw_report_landrpu
;

create view vw_report_landrpu as 
select	
	f.objid,
	f.state,
	o.name as lgu, 
	b.name as barangay,
	f.tdno,
	f.fullpin as pin,
	f.titleno,
	f.dtapproved,
	f.canceldate,
	f.cancelledbytdnos,
	f.prevtdno,
	f.effectivityyear,
	f.effectivityqtr,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address, 
	f.owner_name,
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	pc.name as classification,
	lspc.name as specificclass,
	sub.code as subclasscode, 
	sub.name as subclass,
	rp.blockno,
	rp.cadastrallotno,
	rp.ry,
	rp.section,
	rp.parcel,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	case 
		when r.useswornamount = 1 then r.swornamount 
		else r.totalbmv 
	end as totalbmv,
	r.totalmv,
	r.totalav
from faas f 
inner join rpu r on f.rpuid  = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rp.barangayid = b.objid 
inner join sys_org o on f.lguid = o.objid 
inner join propertyclassification pc on r.classification_objid = pc.objid 
inner join landdetail ld on r.objid = ld.landrpuid 
inner join lcuvspecificclass spc on ld.specificclass_objid = spc.objid 
inner join landspecificclass lspc on spc.landspecificclass_objid = lspc.objid 
inner join lcuvsubclass sub on ld.subclass_objid = sub.objid 
inner join entity e on f.taxpayer_objid = e.objid 
;

/* ABSTRACT RPT COLLECTION: change remittance to controldate */

DROP VIEW IF EXISTS `vw_landtax_abstract_of_collection_detail`
;

CREATE VIEW `vw_landtax_abstract_of_collection_detail` AS 
select 
`liq`.`objid` AS `liquidationid`,
`liq`.`controldate` AS `liquidationdate`,
`rem`.`objid` AS `remittanceid`,
`rem`.`controldate` AS `remittancedate`,
`cr`.`objid` AS `receiptid`,
`cr`.`receiptdate` AS `ordate`,
`cr`.`receiptno` AS `orno`,
`cr`.`collector_objid` AS `collectorid`,
`rl`.`objid` AS `rptledgerid`,
`rl`.`fullpin` AS `fullpin`,
`rl`.`titleno` AS `titleno`,
`rl`.`cadastrallotno` AS `cadastrallotno`,
`rl`.`rputype` AS `rputype`,
`rl`.`totalmv` AS `totalmv`,
`b`.`name` AS `barangay`,
`rp`.`fromqtr` AS `fromqtr`,
`rp`.`toqtr` AS `toqtr`,
`rpi`.`year` AS `year`,
`rpi`.`qtr` AS `qtr`,
`rpi`.`revtype` AS `revtype`,
(case when isnull(`cv`.`objid`) then `rl`.`owner_name` else '*** voided ***' end) AS `taxpayername`,
(case when isnull(`cv`.`objid`) then `rl`.`tdno` else '' end) AS `tdno`,
(case when isnull(`m`.`name`) then `c`.`name` else `m`.`name` end) AS `municityname`,
(case when isnull(`cv`.`objid`) then `rl`.`classcode` else '' end) AS `classification`,
(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessvalue`,
(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessedvalue`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basiccurrentyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicpreviousyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic')) then `rpi`.`discount` else 0.0 end) AS `basicdiscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltycurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltyprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `sefcurrentyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `sefpreviousyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef')) then `rpi`.`discount` else 0.0 end) AS `sefdiscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltycurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltyprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basicidlecurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicidleprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle')) then `rpi`.`amount` else 0.0 end) AS `basicidlediscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicidlecurrentpenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicidlepreviouspenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `shcurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `shprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh')) then `rpi`.`discount` else 0.0 end) AS `shdiscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `shcurrentpenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `shpreviouspenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'firecode')) then `rpi`.`amount` else 0.0 end) AS `firecode`,
(case when isnull(`cv`.`objid`) then ((`rpi`.`amount` - `rpi`.`discount`) + `rpi`.`interest`) else 0.0 end) AS `total`,
(case when isnull(`cv`.`objid`) then `rpi`.`partialled` else 0 end) AS `partialled` 
from  `collectionvoucher` `liq` 
join `remittance` `rem` on `rem`.`collectionvoucherid` = `liq`.`objid`  
join `cashreceipt` `cr` on `rem`.`objid` = `cr`.`remittanceid`  left 
join `cashreceipt_void` `cv` on `cr`.`objid` = `cv`.`receiptid`  
join `rptpayment` `rp` on `rp`.`receiptid` = `cr`.`objid`  
join `rptpayment_item` `rpi` on `rpi`.`parentid` = `rp`.`objid`  
join `rptledger` `rl` on `rl`.`objid` = `rp`.`refid`  
join `barangay` `b` on `b`.`objid` = `rl`.`barangayid`  left 
join `district` `d` on `b`.`parentid` = `d`.`objid`  left 
join `city` `c` on `d`.`parentid` = `c`.`objid`  left 
join `municipality` `m` on `b`.`parentid` = `m`.`objid` 
;


/* ADD TAXABLE */
DROP  VIEW IF EXISTS  `vw_report_subdividedland`
;

CREATE  VIEW `vw_report_subdividedland` AS 
select 
  `sl`.`objid` AS `objid`,
  `s`.`objid` AS `subdivisionid`,
  `s`.`txnno` AS `txnno`,
  `b`.`name` AS `barangay`,
  `o`.`name` AS `lguname`,
  `pc`.`code` AS `classcode`,
  `f`.`tdno` AS `tdno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`administrator_name` AS `administrator_name`,
  `f`.`titleno` AS `titleno`,
  `f`.`lguid` AS `lguid`,
  `f`.`titledate` AS `titledate`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`surveyno` AS `surveyno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`rputype` AS `rputype`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `r`.`taxable` as `taxable`,
  `f`.`txntype_objid` AS `txntype_objid`,
  `ft`.`displaycode` AS `txntype_code`,
  `e`.`name` AS `taxpayer_name` 
  from  `subdividedland` `sl` 
  join `subdivision` `s` on `sl`.`subdivisionid` = `s`.`objid` 
  join `faas` `f` on `sl`.`newfaasid` = `f`.`objid` 
  join `rpu` `r` on `f`.`rpuid` = `r`.`objid` 
  join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid` 
  join `barangay` `b` on `rp`.`barangayid` = `b`.`objid` 
  join `sys_org` `o` on `f`.`lguid` = `o`.`objid` 
  join `faas_txntype` `ft` on `f`.`txntype_objid` = `ft`.`objid` 
  join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid` 
  join `propertyclassification` `pc` on `r`.`classification_objid` = `pc`.`objid`
;

DROP  VIEW IF EXISTS  `vw_report_consolidated_land`
;

CREATE VIEW `vw_report_consolidated_land` AS 
select 
  `cl`.`consolidationid` AS `consolidationid`,
  `f`.`tdno` AS `tdno`,
  `f`.`owner_name` AS `owner_name`,
  `b`.`name` AS `barangay`,
  `o`.`name` AS `lguname`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`surveyno` AS `surveyno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`rputype` AS `rputype`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `r`.`taxable` as `taxable`,
  `f`.`administrator_name` AS `administrator_name`,
  `f`.`txntype_objid` AS `txntype_objid`,
  `pc`.`code` AS `classcode`,
  `ft`.`displaycode` AS `txntype_code`,
  `e`.`name` AS `taxpayer_name` 
from  `consolidatedland` `cl` 
join `faas` `f` on `cl`.`landfaasid` = `f`.`objid` 
join `rpu` `r` on `f`.`rpuid` = `r`.`objid` 
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid` 
join `barangay` `b` on `rp`.`barangayid` = `b`.`objid` 
join `sys_org` `o` on `f`.`lguid` = `o`.`objid` 
join `propertyclassification` `pc` on `r`.`classification_objid` = `pc`.`objid` 
join `faas_txntype` `ft` on `f`.`txntype_objid` = `ft`.`objid` 
join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid`
;


/* ENCODER_APPROVER */
INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('RPT.ENCODER_APPROVER', 'RPT ENCODER_APPROVER', 'RPT', NULL, NULL, 'ENCODER_APPROVER')
;

/* TOPN IMPROVEMENT */
create index ix_year on report_rptdelinquency_item(year)
;


DROP VIEW IF EXISTS `vw_landtax_report_rptdelinquency_detail` 
;

/* ADD PARENTID */
CREATE VIEW `vw_landtax_report_rptdelinquency_detail` AS 
select 
  r.objid as parentid,
  `ri`.`objid` AS `objid`,
  `ri`.`rptledgerid` AS `rptledgerid`,
  `ri`.`barangayid` AS `barangayid`,
  `ri`.`year` AS `year`,
  `ri`.`qtr` AS `qtr`,
  `r`.`dtgenerated` AS `dtgenerated`,
  `r`.`dtcomputed` AS `dtcomputed`,
  `r`.`generatedby_name` AS `generatedby_name`,
  `r`.`generatedby_title` AS `generatedby_title`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,
  (case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,
  (case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,
  (case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,
  (case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,
  (case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,
  (case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,
  (case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,
  (case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,
  (case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,
  (case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,
  (case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,
  (case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,
  (case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,
  ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` 
from (`report_rptdelinquency_item` `ri` 
  join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;




DROP TABLE IF EXISTS report_rptdelinquency_total_bytaxpayer
;

CREATE TABLE report_rptdelinquency_total_bytaxpayer (
  taxpayer_objid varchar(50) DEFAULT NULL,
  parentid varchar(50) NOT NULL,
  amount decimal(16,2) DEFAULT NULL,
	ledgercount int
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parentid on report_rptdelinquency_total_bytaxpayer(parentid)
;
create index ix_taxpayer_objid on report_rptdelinquency_total_bytaxpayer(taxpayer_objid)
;
create index ix_amount on report_rptdelinquency_total_bytaxpayer(amount)
;

insert into report_rptdelinquency_total_bytaxpayer (
	taxpayer_objid,
	parentid,
	amount,
	ledgercount
)
SELECT 
	rl.taxpayer_objid,
	rr.parentid,
	SUM(rr.basic - rr.basicdisc + rr.basicint  + rr.sef - rr.sefdisc + rr.sefint ) AS amount,
	count( distinct rr.rptledgerid) as ledgercount
FROM vw_landtax_report_rptdelinquency_detail rr 
	inner join rptledger rl on rr.rptledgerid = rl.objid 
WHERE rl.taxable = 1
AND NOT EXISTS(select * from faas_restriction where ledger_objid = rr.rptledgerid and state='ACTIVE')
GROUP BY rl.taxpayer_objid, rr.parentid
;




/* TOPN PAYER IMPROVEMENT */

DROP TABLE IF EXISTS `report_rptcollection_annual_bypayer`
;

CREATE TABLE `report_rptcollection_annual_bypayer` (
  `rputype` varchar(50) not null,
  `year` int(11) NOT NULL,
  `payer_name` varchar(2000) NOT NULL,
  `amount` decimal(50,2) DEFAULT NULL,
  dtgenerated datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_rputype on report_rptcollection_annual_bypayer(rputype)
;
create index ix_year on report_rptcollection_annual_bypayer(year)
;
create index ix_payer on report_rptcollection_annual_bypayer(payer_name(150))
;


delete from report_rptcollection_annual_bypayer
;

insert into report_rptcollection_annual_bypayer(
  rputype,
	year, 
	payer_name,
	amount,
  dtgenerated
)
select 
  rl.rputype,
		year(c.receiptdate), 
		c.paidby as payer_name, 
		sum(
			basic + basicint - basicdisc + 
			sef + sefint - sefdisc + firecode +
			basicidle + basicidleint - basicidledisc +
			sh + shint - shdisc
		) as amount,
    now()
from collectionvoucher cv
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt c on rem.objid = c.remittanceid 
	left join cashreceipt_void crv on c.objid = crv.receiptid
	inner join rptpayment rp on c.objid = rp.receiptid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
-- where cv.controldate < concat(YEAR(now()), '-01-01')
group by rl.rputype, c.receiptdate,  c.paidby 
;



/* PORTION OF */
alter table realproperty add portionof varchar(255)
;

/* MISCRPU */
alter table miscrpuitem add appraisalstartdate date
;
alter table miscrpuitem add taxable int
;
update miscrpuitem set taxable = 1 where taxable is null 
;
/* ADMIN PERMISSIONS */
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-189d', 'RPT.ADMIN', 'faas', 'view_issued_clearances', 'View issued clearances');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-334b', 'RPT.ADMIN', 'faas', 'update_ledger_mapping', 'Update FAAS and Ledger mapping');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-4a01', 'RPT.ADMIN', 'faas', 'resend_to_province', 'Resend to province');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-5fbf', 'RPT.ADMIN', 'faas', 'modify_superseded_info', 'Modify superseded information');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-611c', 'RPT.ADMIN', 'faas', 'view_payments', 'Modify payments');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-6243', 'RPT.ADMIN', 'faas', 'modify_information', 'Modify information');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-638a', 'RPT.ADMIN', 'faas', 'modify_owner', 'Modify owner');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-6473', 'RPT.ADMIN', 'faas', 'modify_property_info', 'Modify property information');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-653e', 'RPT.ADMIN', 'faas', 'modify_signatories', 'Modify signatories');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-65eb', 'RPT.ADMIN', 'faas', 'modify_sketch', 'Modify sketch');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-6682', 'RPT.ADMIN', 'faas', 'modify_appraisal', 'Modify appraisal');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-7a00', 'RPT.ADMIN', 'faas', 'view_payments', 'View payments');

/* ASSESSMENT NOTICE NATB */
alter table assessmentnotice add info varchar(1000)
;
alter table assessmentnoticeitem add info varchar(1000)
;

DROP VIEW IF EXISTS `vw_assessment_notice_item`;

CREATE VIEW `vw_assessment_notice_item` AS 
  select 
    `ni`.`objid` AS `objid`,
    `ni`.`assessmentnoticeid` AS `assessmentnoticeid`,
    `ni`.`info`,
    `f`.`objid` AS `faasid`,
    `f`.`effectivityyear` AS `effectivityyear`,
    `f`.`effectivityqtr` AS `effectivityqtr`,
    `f`.`tdno` AS `tdno`,
    `f`.`taxpayer_objid` AS `taxpayer_objid`,
    `e`.`name` AS `taxpayer_name`,
    `e`.`address_text` AS `taxpayer_address`,
    `f`.`owner_name` AS `owner_name`,
    `f`.`owner_address` AS `owner_address`,
    `f`.`administrator_name` AS `administrator_name`,
    `f`.`administrator_address` AS `administrator_address`,
    `f`.`rpuid` AS `rpuid`,
    `f`.`lguid` AS `lguid`,
    `f`.`txntype_objid` AS `txntype_objid`,
    `ft`.`displaycode` AS `txntype_code`,
    `rpu`.`rputype` AS `rputype`,
    `rpu`.`ry` AS `ry`,
    `rpu`.`fullpin` AS `fullpin`,
    `rpu`.`taxable` AS `taxable`,
    `rpu`.`totalareaha` AS `totalareaha`,
    `rpu`.`totalareasqm` AS `totalareasqm`,
    `rpu`.`totalbmv` AS `totalbmv`,
    `rpu`.`totalmv` AS `totalmv`,
    `rpu`.`totalav` AS `totalav`,
    `rp`.`section` AS `section`,
    `rp`.`parcel` AS `parcel`,
    `rp`.`surveyno` AS `surveyno`,
    `rp`.`cadastrallotno` AS `cadastrallotno`,
    `rp`.`blockno` AS `blockno`,
    `rp`.`claimno` AS `claimno`,
    `rp`.`street` AS `street`,
    `o`.`name` AS `lguname`,
    `b`.`name` AS `barangay`,
    `pc`.`code` AS `classcode`,
    `pc`.`name` AS `classification` 
from  `assessmentnoticeitem` `ni` join `faas` `f` on `ni`.`faasid` = `f`.`objid`  
left join `txnsignatory` `ts` on `ts`.`refid` = `f`.`objid`  and  `ts`.`type` = 'APPROVER'  
join `rpu` on `f`.`rpuid` = `rpu`.`objid`  
join `propertyclassification` `pc` on `rpu`.`classification_objid` = `pc`.`objid`  
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
join `barangay` `b` on `rp`.`barangayid` = `b`.`objid`  
join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  
join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid`  
join `faas_txntype` `ft` on `f`.`txntype_objid` = `ft`.`objid` 
;

/* ORC */
DROP VIEW IF EXISTS `vw_report_orc`
;

CREATE VIEW `vw_report_orc` AS 
select 
  `f`.`objid` AS `objid`,
  `f`.txntype_objid,
  `f`.`state` AS `state`,
  `e`.`objid` AS `taxpayerid`,
  `e`.`name` AS `taxpayer_name`,
  `e`.`address_text` AS `taxpayer_address`,
  `o`.`name` AS `lgu_name`,
  `o`.`code` AS `lgu_indexno`,
  `f`.`dtapproved` AS `dtapproved`,
  `r`.`rputype` AS `rputype`,
  `pc`.`code` AS `classcode`,
  `pc`.`name` AS `classification`,
  `f`.`fullpin` AS `pin`,
  `f`.`titleno` AS `titleno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `f`.`tdno` AS `tdno`,
  `f`.`prevtdno`,
  '' AS `arpno`,
  `f`.`prevowner` AS `prevowner`,
  `b`.`name` AS `location`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  (case when (`f`.`state` = 'CURRENT') then '' else 'CANCELLED' end) AS `remarks` 
from  `faas` `f` 
join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
join `propertyclassification` `pc` on `r`.`classification_objid` = `pc`.`objid`  
join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid`  
join `sys_org` `o` on `rp`.`lguid` = `o`.`objid`  
join `barangay` `b` on `rp`.`barangayid` = `b`.`objid`  
where  `f`.`state` in  ('CURRENT','CANCELLED')
;



DROP  VIEW IF EXISTS `vw_idle_land`
;
CREATE  VIEW `vw_idle_land` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`f`.`rpuid` AS `rpuid`,`f`.`realpropertyid` AS `realpropertyid`,`f`.`lguid` AS `lguid`,`f`.`barangayid` AS `barangayid`,`o`.`name` AS `lgu`,`f`.`barangay` AS `barangay`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`tdno` AS `tdno`,`f`.`titleno` AS `titleno`,`f`.`pin` AS `pin`,`pc`.`name` AS `classification`,`f`.`cadastrallotno` AS `cadastrallotno`,`f`.`blockno` AS `blockno`,`f`.`ry` AS `ry`,`f`.`totalareaha` AS `totalareaha`,`f`.`totalareasqm` AS `totalareasqm`,`f`.`totalmv` AS `totalmv`,`f`.`totalav` AS `totalav` from (((`faas_list` `f` join `landrpu` `lr` on(`f`.`rpuid`)) join `propertyclassification` `pc` on(`f`.`classification_objid`)) join `sys_org` `o` on(`f`.`lguid`)) where ((`f`.`state` in ('current','cancelled')) and (`lr`.`idleland` = 1))
;
drop table if exists rptacknowledgement_item;
drop table if exists rptacknowledgement;

CREATE TABLE `rptacknowledgement` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `pin` varchar(25) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(150) DEFAULT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtchecked` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_txnno` (`txnno`),
  KEY `ix_rptacknowledgement_pin` (`pin`),
  KEY `ix_rptacknowledgement_taxpayerid` (`taxpayer_objid`),
  KEY `ix_rptacknowledgement_createdby_objid` (`createdby_objid`),
  KEY `ix_rptacknowledgement_createdby_name` (`createdby_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rptacknowledgement_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `trackingno` varchar(25) DEFAULT NULL,
  `ref_objid` varchar(50) DEFAULT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_itemno` (`trackingno`),
  KEY `ix_rptacknowledgement_parentid` (`parent_objid`),
  KEY `ix_rptacknowledgement_item_faasid` (`ref_objid`),
  KEY `ix_rptacknowledgement_item_newfaasid` (`newfaas_objid`),
  CONSTRAINT `fk_rptacknowledgement_item_rptacknowledgement` FOREIGN KEY (`parent_objid`) REFERENCES `rptacknowledgement` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS `rpttracking` 
;

CREATE TABLE `rpttracking` (
  `objid` varchar(50) NOT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `trackingno` varchar(25) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `landcount` int(11) DEFAULT '0',
  `bldgcount` int(11) DEFAULT '0',
  `machcount` int(11) DEFAULT '0',
  `planttreecount` int(11) DEFAULT '0',
  `misccount` int(11) DEFAULT '0',
  `pin` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rpttracking_trackingno` (`trackingno`),
  KEY `ix_rpttracking_receivedby` (`receivedby`),
  KEY `ix_rpttracking_remarks` (`remarks`),
  KEY `ix_rpttracking_pin` (`pin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

/* RPU HISTORY */
CREATE TABLE `rpu_history` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `rpumaster_objid` varchar(50) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `prevtdno` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `ry` int(11) NOT NULL,
  `txntype_objid` varchar(5) NOT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `titleno` varchar(50) DEFAULT NULL,
  `titledate` date DEFAULT NULL,
  `portionof` varchar(255) DEFAULT NULL,
  `owner_name` varchar(1500) NOT NULL,
  `owner_address` varchar(255) DEFAULT NULL,
  `administrator_name` varchar(255) DEFAULT NULL,
  `administrator_address` varchar(255) DEFAULT NULL,
  `beneficiary_name` varchar(255) DEFAULT NULL,
  `beneficiary_address` varchar(255) DEFAULT NULL,
  `classification_objid` varchar(50) NOT NULL,
  `totalareaha` decimal(16,6) NOT NULL,
  `totalareasqm` decimal(16,2) NOT NULL,
  `totalmv` decimal(16,2) NOT NULL,
  `totalav` decimal(16,2) NOT NULL,
  `memoranda` varchar(1500) NOT NULL,
  `surveyno` varchar(255) DEFAULT NULL,
  `cadastrallotno` varchar(255) DEFAULT NULL,
  `blockno` varchar(25) DEFAULT NULL,
  `purok` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `dtapproved` date NOT NULL,
  `cancelreason` varchar(50) NOT NULL,
  `canceldate` date NOT NULL,
  `cancelledbytdnos` varchar(255) NOT NULL,
  `prevhistory_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rpumasterid` (`rpumaster_objid`),
  KEY `ix_tdno` (`tdno`),
  KEY `ix_prevtdno` (`prevtdno`),
  KEY `ix_pin` (`pin`),
  KEY `ix_titleno` (`titleno`),
  KEY `ix_owner_name` (`owner_name`(255)),
  KEY `ix_administrator_name` (`administrator_name`),
  KEY `ix_classification_objid` (`classification_objid`),
  KEY `ix_cadastrallotno` (`cadastrallotno`),
  KEY `ix_cancelledbytdnos` (`cancelledbytdnos`),
  KEY `ix_prevhistory_objid` (`prevhistory_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table rpu_history add constraint fk_rpuhistory_rpumaster 
foreign key (rpumaster_objid) references rpumaster (objid)
;

INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) 
VALUES ('RPT.RECORD.faas.create_history', 'RPT.RECORD', 'faas', 'create_history', 'Create FAAS History')
;


/* TXN INITIATED BY ASSESSOR */
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.RECEIVER_ADMIN', 'RPT RECEIVER_ADMIN', 'RPT', NULL, NULL, 'RECEIVER_ADMIN');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createCorrection', 'RPT.RECEIVER_ADMIN', 'faas', 'createCorrection', 'FAAS correction initiated by assessor');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createReassessment', 'RPT.RECEIVER_ADMIN', 'faas', 'createReassessment', 'FAAS reassessment initiated by assessor');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createPropertyDestruction', 'RPT.RECEIVER_ADMIN', 'faas', 'createPropertyDestruction', 'FAAS destruction initiated by assessor');





/* REPRINT TD AS ORIGINAL */
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.RECORD_ADMIN', 'RPT RECORD_ADMIN', 'RPT', NULL, NULL, 'RECORD_ADMIN');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECORD_ADMIN:faas:reprint_original_taxdec', 'RPT.RECORD_ADMIN', 'faas', 'reprint_original_taxdec', 'Reprint tax dec as original');

/* EXAMINATION FINDING */
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.ADMIN:examination_finding:delete', 'RPT.ADMIN', 'examination_finding', 'delete', 'Delete examination finding');

INSERT IGNORE INTO sys_var (name, value, description, datatype, category) 
VALUES ('faas_effectivity_editable', '0', 'Allow or disallows editing of FAAS effectivity', 'boolean', 'ASSESSOR')
;

alter table sys_usergroup_permission modify column permission varchar(100)
; 


INSERT IGNORE INTO sys_usergroup_permission (objid, usergroup_objid, object, permission, title) 
VALUES ('RPT.CERTIFICATION_RELEASER:rptcertification:reprint', 'RPT.CERTIFICATION_RELEASER', 'rptcertification', 'reprint', 'Reprint released certification')
;

INSERT IGNORE INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('LANDTAX.RECORD_ADMIN', 'LANDTAX RECORD_ADMIN', 'LANDTAX', NULL, NULL, 'RECORD_ADMIN')
;
INSERT IGNORE INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('RPT.RECORD_ADMIN', 'RPT RECORD_ADMIN', 'RPT', NULL, NULL, 'RECORD_ADMIN')
;

INSERT IGNORE INTO sys_usergroup_permission (objid, usergroup_objid, object, permission, title) 
VALUES ('LANDTAX.RECORD_ADMIN:faas:print_td_official_copy', 'LANDTAX.RECORD_ADMIN', 'faas', 'print_taxdec_official_copy', 'Print official copy of tax declaration')
; 


DROP TABLE IF EXISTS `rptexpiry`
;

CREATE TABLE `rptexpiry` (
	`iyear` int(11) NOT NULL,
  `iqtr` int(11) NOT NULL,
  `imonth` int(11) NOT NULL,
  `expirytype` varchar(50) NOT NULL,
  `expirydate` date DEFAULT NULL,
	`validuntil` date DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`iqtr`,`imonth`,`iyear`,`expirytype`),
  KEY `ix_rptexpiry_yrqtr` (`iyear`,`iqtr`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* TXN INITIATED BY ASSESSOR */
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createChangePin', 'RPT.RECEIVER_ADMIN', 'faas', 'createChangePin', 'FAAS Change PIN initiated by assessor');


alter table bldgrpu add occpermitno varchar(50);
alter table rpt_redflag add parentid varchar(50);
alter table rpt_redflag add state varchar(25);
alter table rpt_redflag add filedby_date date;
alter table rpt_redflag add resolvedby_date date;
alter table rpt_redflag add lguid varchar(50);
alter table rpt_redflag add dtclosed date;
alter table rpt_redflag add remarks varchar(1000);
alter table rpu add isonline int default 0;





/*========================================
** LGU ACCOUNT MAPPING 
========================================*/


set foreign_key_checks = 0
;


INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_ADVANCE', 'ACTIVE', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_CURRENT', 'ACTIVE', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASICINT_CURRENT', 'ACTIVE', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_PREVIOUS', 'ACTIVE', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASICINT_PREVIOUS', 'ACTIVE', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_PRIOR', 'ACTIVE', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASICINT_PRIOR', 'ACTIVE', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_ADVANCE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_CURRENT', 'ACTIVE', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEFINT_CURRENT', 'ACTIVE', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEFINT_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEFINT_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;


INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE PROVINCE SHARE', 'RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PROVINCE SHARE', 'RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PROVINCE SHARE', 'RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE PROVINCE SHARE', 'RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PROVINCE SHARE', 'RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PROVINCE SHARE', 'RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PROVINCE SHARE', 'RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_ADVANCE_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;



/* REVENUE TAG */
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE' as objid, 'RPT_BASIC_ADVANCE' as acctid, 'rpt_basic_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_CURRENT' as objid, 'RPT_BASIC_CURRENT' as acctid, 'rpt_basic_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_CURRENT' as objid, 'RPT_BASICINT_CURRENT' as acctid, 'rpt_basicint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PREVIOUS' as objid, 'RPT_BASIC_PREVIOUS' as acctid, 'rpt_basic_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PREVIOUS' as objid, 'RPT_BASICINT_PREVIOUS' as acctid, 'rpt_basicint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PRIOR' as objid, 'RPT_BASIC_PRIOR' as acctid, 'rpt_basic_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PRIOR' as objid, 'RPT_BASICINT_PRIOR' as acctid, 'rpt_basicint_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_ADVANCE' as objid, 'RPT_SEF_ADVANCE' as acctid, 'rpt_sef_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_CURRENT' as objid, 'RPT_SEF_CURRENT' as acctid, 'rpt_sef_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_CURRENT' as objid, 'RPT_SEFINT_CURRENT' as acctid, 'rpt_sefint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PREVIOUS' as objid, 'RPT_SEF_PREVIOUS' as acctid, 'rpt_sef_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PREVIOUS' as objid, 'RPT_SEFINT_PREVIOUS' as acctid, 'rpt_sefint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PRIOR' as objid, 'RPT_SEF_PRIOR' as acctid, 'rpt_sef_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PRIOR' as objid, 'RPT_SEFINT_PRIOR' as acctid, 'rpt_sefint_prior' as tag
;


/* PROVINCE PAYABLE TAG */
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_basic_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASIC_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basic_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basicint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basic_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basicint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASIC_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basic_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basicint_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_SEF_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_sef_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEF_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sef_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sefint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sef_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sefint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEF_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sef_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sefint_prior' as tag
;

/* BARANGAY PAYABLE TAG */
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_BRGY_SHARE' as objid, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as acctid, 'rpt_basic_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_CURRENT_BRGY_SHARE' as objid, 'RPT_BASIC_CURRENT_BRGY_SHARE' as acctid, 'rpt_basic_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_CURRENT_BRGY_SHARE' as objid, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as acctid, 'rpt_basicint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basic_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basicint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PRIOR_BRGY_SHARE' as objid, 'RPT_BASIC_PRIOR_BRGY_SHARE' as acctid, 'rpt_basic_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PRIOR_BRGY_SHARE' as objid, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as acctid, 'rpt_basicint_prior' as tag
;



/* MUNICIPALITY ACCOUNT MAPPING */
replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_ADVANCE' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicadvacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicprioracct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicpriorintacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicprevacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicprevintacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basiccurracct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basiccurrintacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_ADVANCE' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefadvacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefprioracct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefpriorintacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefprevacct_objid  = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefprevintacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefcurracct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefcurrintacct_objid= ia.objid
and m.lguid = l.objid
;





/* PROVINCE SHARE ACCOUNT MAPPING */
replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicadvacct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicprioracct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicpriorintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicprevacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicprevintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basiccurracct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basiccurrintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_ADVANCE_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefadvacct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefprioracct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefpriorintacct_objid = ia.objid
and l.objid = '047'
;



replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefprevacct_objid  = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefprevintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefcurracct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefcurrintacct_objid= ia.objid
and l.objid = '047'
;



/* BARANGAY ACCOUNT MAPPING */
replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicadvacct_objid = ia.objid
and m.barangayid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PRIOR_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicprioracct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicpriorintacct_objid = ia.objid
and m.barangayid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicprevacct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicprevintacct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_CURRENT_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basiccurracct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basiccurrintacct_objid = ia.objid
and m.barangayid = l.objid
;



set foreign_key_checks = 1
;



