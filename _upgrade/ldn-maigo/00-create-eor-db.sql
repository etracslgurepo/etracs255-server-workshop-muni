create database eor character set utf8;

use eor; 

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for eor
-- ----------------------------
CREATE TABLE `eor` (
  `objid` varchar(50) NOT NULL,
  `receiptno` varchar(50) NULL,
  `receiptdate` date NULL,
  `txndate` datetime NULL,
  `state` varchar(10) NULL,
  `partnerid` varchar(50) NULL,
  `txntype` varchar(20) NULL,
  `traceid` varchar(50) NULL,
  `tracedate` datetime NULL,
  `refid` varchar(50) NULL,
  `paidby` varchar(255) NULL,
  `paidbyaddress` varchar(255) NULL,
  `payer_objid` varchar(50) NULL,
  `paymethod` varchar(20) NULL,
  `paymentrefid` varchar(50) NULL,
  `remittanceid` varchar(50) NULL,
  `remarks` varchar(255) NULL,
  `amount` decimal(16,4) NULL,
  `lockid` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_eor_receiptno` (`receiptno`),
  KEY `ix_receiptdate` (`receiptdate`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_partnerid` (`partnerid`),
  KEY `ix_traceid` (`traceid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_paidby` (`paidby`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_paymentrefid` (`paymentrefid`),
  KEY `ix_remittanceid` (`remittanceid`),
  KEY `ix_lockid` (`lockid`),
  CONSTRAINT `fk_eor_remittanceid` FOREIGN KEY (`remittanceid`) REFERENCES `eor_remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_for_email
-- ----------------------------
CREATE TABLE `eor_for_email` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `email` varchar(255) NULL,
  `mobileno` varchar(50) NULL,
  `state` int(11) NULL,
  `dtsent` datetime NULL,
  `errmsg` varchar(255) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_item
-- ----------------------------
CREATE TABLE `eor_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `item_objid` varchar(50) NULL,
  `item_code` varchar(100) NULL,
  `item_title` varchar(100) NULL,
  `amount` decimal(16,4) NULL,
  `remarks` varchar(255) NULL,
  `item_fund_objid` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_eoritem_eor` (`parentid`),
  KEY `ix_item_objid` (`item_objid`),
  KEY `ix_item_fund_objid` (`item_fund_objid`),
  CONSTRAINT `fk_eoritem_eor` FOREIGN KEY (`parentid`) REFERENCES `eor` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_manual_post
-- ----------------------------
CREATE TABLE `eor_manual_post` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NULL,
  `paymentorderno` varchar(50) NULL,
  `amount` decimal(16,4) NULL,
  `txntype` varchar(50) NULL,
  `paymentpartnerid` varchar(50) NULL,
  `traceid` varchar(50) NULL,
  `tracedate` datetime NULL,
  `reason` tinytext,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `dtcreated` datetime NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_eor_manual_post_paymentorderno` (`paymentorderno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_number
-- ----------------------------
CREATE TABLE `eor_number` (
  `objid` varchar(255) NOT NULL,
  `currentno` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_paymentorder
-- ----------------------------
CREATE TABLE `eor_paymentorder` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `txntype` varchar(50) NULL,
  `txntypename` varchar(100) NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) NULL,
  `particulars` varchar(500) NULL,
  `amount` decimal(16,2) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` text,
  `origin` varchar(100) NULL,
  `controlno` varchar(50) NULL,
  `locationid` varchar(25) NULL,
  `items` mediumtext,
  `state` varchar(32) NULL,
  `email` varchar(255) NULL,
  `mobileno` varchar(25) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_paymentorder_cancelled
-- ----------------------------
CREATE TABLE `eor_paymentorder_cancelled` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `txntype` varchar(50) NULL,
  `txntypename` varchar(100) NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` longtext,
  `paidby` longtext,
  `paidbyaddress` varchar(150) NULL,
  `particulars` text,
  `amount` decimal(16,2) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` longtext,
  `origin` varchar(100) NULL,
  `controlno` varchar(50) NULL,
  `locationid` varchar(25) NULL,
  `items` longtext,
  `state` varchar(10) NULL,
  `email` varchar(255) NULL,
  `mobileno` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_payer_name` (`payer_name`(255)),
  KEY `ix_expirydate` (`expirydate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_controlno` (`controlno`),
  KEY `ix_locationid` (`locationid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_paymentorder_paid
-- ----------------------------
CREATE TABLE `eor_paymentorder_paid` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `txntype` varchar(50) NULL,
  `txntypename` varchar(100) NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` longtext,
  `paidby` longtext,
  `paidbyaddress` varchar(150) NULL,
  `particulars` text,
  `amount` decimal(16,2) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` longtext,
  `origin` varchar(100) NULL,
  `controlno` varchar(50) NULL,
  `locationid` varchar(25) NULL,
  `items` longtext,
  `state` varchar(10) NULL,
  `email` varchar(255) NULL,
  `mobileno` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_payer_name` (`payer_name`(255)),
  KEY `ix_expirydate` (`expirydate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_controlno` (`controlno`),
  KEY `ix_locationid` (`locationid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_payment_error
-- ----------------------------
CREATE TABLE `eor_payment_error` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `paymentrefid` varchar(50) NOT NULL,
  `errmsg` longtext NOT NULL,
  `errdetail` longtext,
  `errcode` int(1) NULL,
  `laststate` int(1) NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_paymentrefid` (`paymentrefid`),
  KEY `ix_txndate` (`txndate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_remittance
-- ----------------------------
CREATE TABLE `eor_remittance` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NULL,
  `controlno` varchar(50) NULL,
  `partnerid` varchar(50) NULL,
  `controldate` date NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `amount` decimal(16,4) NULL,
  `dtposted` datetime NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  `lockid` varchar(50) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_remittance_fund
-- ----------------------------
CREATE TABLE `eor_remittance_fund` (
  `objid` varchar(100) NOT NULL,
  `remittanceid` varchar(50) NULL,
  `fund_objid` varchar(50) NULL,
  `fund_code` varchar(50) NULL,
  `fund_title` varchar(255) NULL,
  `amount` decimal(16,4) NULL,
  `bankaccount_objid` varchar(50) NULL,
  `bankaccount_title` varchar(255) NULL,
  `bankaccount_bank_name` varchar(255) NULL,
  `validation_refno` varchar(50) NULL,
  `validation_refdate` date NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_eor_remittance_fund_remittance` (`remittanceid`),
  CONSTRAINT `fk_eor_remittance_fund_remittance` FOREIGN KEY (`remittanceid`) REFERENCES `eor_remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for eor_share
-- ----------------------------
CREATE TABLE `eor_share` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `refitem_objid` varchar(50) NULL,
  `refitem_code` varchar(25) NULL,
  `refitem_title` varchar(255) NULL,
  `payableitem_objid` varchar(50) NULL,
  `payableitem_code` varchar(25) NULL,
  `payableitem_title` varchar(255) NULL,
  `amount` decimal(16,4) NULL,
  `share` decimal(16,2) NULL,
  `receiptitemid` varchar(50) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for epayment_plugin
-- ----------------------------
CREATE TABLE `epayment_plugin` (
  `objid` varchar(50) NOT NULL,
  `connection` varchar(50) NULL,
  `servicename` varchar(255) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jev
-- ----------------------------
CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `jevno` varchar(50) NULL,
  `jevdate` date NULL,
  `fundid` varchar(50) NULL,
  `dtposted` datetime NULL,
  `txntype` varchar(50) NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `reftype` varchar(50) NULL,
  `amount` decimal(16,4) NULL,
  `state` varchar(32) NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  `verifiedby_objid` varchar(50) NULL,
  `verifiedby_name` varchar(255) NULL,
  `dtverified` datetime NULL,
  `batchid` varchar(50) NULL,
  `refdate` date NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_batchid` (`batchid`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_dtverified` (`dtverified`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_jevdate` (`jevdate`),
  KEY `ix_jevno` (`jevno`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_verifiedby_objid` (`verifiedby_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jevitem
-- ----------------------------
CREATE TABLE `jevitem` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `accttype` varchar(50) NULL,
  `acctid` varchar(50) NULL,
  `acctcode` varchar(32) NULL,
  `acctname` varchar(255) NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  `particulars` varchar(255) NULL,
  `itemrefid` varchar(255) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_jevid` (`jevid`),
  KEY `ix_ledgertype` (`accttype`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_acctcode` (`acctcode`),
  KEY `ix_acctname` (`acctname`),
  KEY `ix_itemrefid` (`itemrefid`),
  CONSTRAINT `fk_jevitem_jevid` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for paymentpartner
-- ----------------------------
CREATE TABLE `paymentpartner` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(50) NULL,
  `name` varchar(100) NULL,
  `branch` varchar(255) NULL,
  `contact` varchar(255) NULL,
  `mobileno` varchar(32) NULL,
  `phoneno` varchar(32) NULL,
  `email` varchar(255) NULL,
  `indexno` varchar(3) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sys_email_queue
-- ----------------------------
CREATE TABLE `sys_email_queue` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `state` int(11) NOT NULL,
  `reportid` varchar(50) NULL,
  `dtsent` datetime NOT NULL,
  `to` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `errmsg` longtext,
  `connection` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_state` (`state`),
  KEY `ix_reportid` (`reportid`),
  KEY `ix_dtsent` (`dtsent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sys_email_template
-- ----------------------------
CREATE TABLE `sys_email_template` (
  `objid` varchar(50) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for unpostedpayment
-- ----------------------------
CREATE TABLE `unpostedpayment` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `txntype` varchar(50) NOT NULL,
  `txntypename` varchar(150) NOT NULL,
  `paymentrefid` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `orgcode` varchar(20) NOT NULL,
  `partnerid` varchar(50) NOT NULL,
  `traceid` varchar(100) NOT NULL,
  `tracedate` datetime NOT NULL,
  `refno` varchar(50) NULL,
  `origin` varchar(50) NULL,
  `paymentorder` longtext,
  `errmsg` text NOT NULL,
  `errdetail` longtext,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_paymentrefid` (`paymentrefid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_partnerid` (`partnerid`),
  KEY `ix_traceid` (`traceid`),
  KEY `ix_tracedate` (`tracedate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_origin` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- View structure for vw_remittance_eor_item
-- ----------------------------
CREATE VIEW `vw_remittance_eor_item` AS select `c`.`remittanceid` AS `remittanceid`,`r`.`controldate` AS `remittance_controldate`,`r`.`controlno` AS `remittance_controlno`,`cri`.`parentid` AS `receiptid`,`c`.`receiptdate` AS `receiptdate`,`c`.`receiptno` AS `receiptno`,`c`.`paidby` AS `paidby`,`c`.`paidbyaddress` AS `paidbyaddress`,`cri`.`item_fund_objid` AS `fundid`,`cri`.`item_objid` AS `acctid`,`cri`.`item_code` AS `acctcode`,`cri`.`item_title` AS `acctname`,`cri`.`remarks` AS `remarks`,`cri`.`amount` AS `amount` from ((`eor_remittance` `r` join `eor` `c` on((`c`.`remittanceid` = `r`.`objid`))) join `eor_item` `cri` on((`cri`.`parentid` = `c`.`objid`))) ;

-- ----------------------------
-- View structure for vw_remittance_eor_share
-- ----------------------------
CREATE VIEW `vw_remittance_eor_share` AS select `c`.`remittanceid` AS `remittanceid`,`r`.`controldate` AS `remittance_controldate`,`r`.`controlno` AS `remittance_controlno`,`cri`.`parentid` AS `receiptid`,`c`.`receiptdate` AS `receiptdate`,`c`.`receiptno` AS `receiptno`,`c`.`paidby` AS `paidby`,`c`.`paidbyaddress` AS `paidbyaddress`,`cri`.`refitem_objid` AS `refacctid`,`cri`.`refitem_code` AS `refacctcode`,`cri`.`refitem_title` AS `refaccttitle`,`cri`.`payableitem_objid` AS `acctid`,`cri`.`payableitem_code` AS `acctcode`,`cri`.`payableitem_title` AS `acctname`,`cri`.`share` AS `amount` from ((`eor_remittance` `r` join `eor` `c` on((`c`.`remittanceid` = `r`.`objid`))) join `eor_share` `cri` on((`cri`.`parentid` = `c`.`objid`))) ;


SET FOREIGN_KEY_CHECKS=1;



-- ## 2021-11-23

alter table eor_share 
  add refitem_fund_objid varchar(100) null, 
  add payableitem_fund_objid varchar(100) null
;
create index ix_refitem_fund_objid on eor_share (refitem_fund_objid)
;
create index ix_payableitem_fund_objid on eor_share (payableitem_fund_objid)
;



drop view if exists vw_remittance_eor_share
; 
CREATE VIEW vw_remittance_eor_share AS 
select 
  c.remittanceid AS remittanceid,
  r.controldate AS remittance_controldate,
  r.controlno AS remittance_controlno,
  cri.parentid AS receiptid,
  c.receiptdate AS receiptdate,
  c.receiptno AS receiptno,
  c.paidby AS paidby,
  c.paidbyaddress AS paidbyaddress,
  cri.refitem_objid AS refacctid,
  cri.refitem_code AS refacctcode,
  cri.refitem_title AS refaccttitle,
  cri.refitem_fund_objid as reffundid, 
  cri.payableitem_objid AS acctid,
  cri.payableitem_code AS acctcode,
  cri.payableitem_title AS acctname,
  cri.payableitem_fund_objid AS fundid,
  cri.amount AS amount,
  c.txntype  
from eor_remittance r 
  inner join eor c on c.remittanceid = r.objid 
  inner join eor_share cri on cri.parentid = c.objid
;



-- ## 2021-11-24

CREATE TABLE `fund` (
  `objid` varchar(100) NOT NULL,
  `state` varchar(10) NULL,
  `code` varchar(50) NULL,
  `title` varchar(255) NULL,
  `type` varchar(20) NULL,
  `special` int NULL,
  `system` int NULL,
  `depositoryfundid` varchar(100) NULL,
  `group_objid` varchar(50) NULL,
  `group_title` varchar(255) NULL,
  `group_indexno` int NULL,
  constraint pk_fund PRIMARY KEY (`objid`),
  KEY `ix_code` (`code`),
  KEY `ix_title` (`title`),
  KEY `ix_group_objid` (`group_objid`),
  KEY `ix_depositoryfundid` (`depositoryfundid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 



INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) VALUES ('DBP', '101', 'DEVELOPMENT BANK OF THE PHILIPPINES', NULL, NULL, NULL, NULL, NULL, '101');
INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) VALUES ('LBP', '102', 'LAND BANK OF THE PHILIPPINES', NULL, NULL, NULL, NULL, NULL, '102');
INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) VALUES ('PAYMAYA', '103', 'PAYMAYA', NULL, NULL, NULL, NULL, NULL, '103');
INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) VALUES ('GCASH', '104', 'GCASH', NULL, NULL, NULL, NULL, NULL, '104');

INSERT INTO `epayment_plugin` (`objid`, `connection`, `servicename`) VALUES ('bpls', 'bpls', 'OnlineBusinessBillingService');
INSERT INTO `epayment_plugin` (`objid`, `connection`, `servicename`) VALUES ('po', 'po', 'OnlinePaymentOrderService');
INSERT INTO `epayment_plugin` (`objid`, `connection`, `servicename`) VALUES ('rptcol', 'rpt', 'OnlineLandTaxBillingService');
INSERT INTO `epayment_plugin` (`objid`, `connection`, `servicename`) VALUES ('rpttaxclearance', 'landtax', 'OnlineRealtyTaxClearanceService');

INSERT INTO `sys_email_template` (`objid`, `subject`, `message`) 
VALUES ('eor', 'EOR No ${receiptno}', 'Dear valued customer <br>Please see attached Electronic OR. This is an electronic transaction. Do not reply');
