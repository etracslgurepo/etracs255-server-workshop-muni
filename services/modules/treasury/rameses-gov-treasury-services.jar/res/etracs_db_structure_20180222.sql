/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.1.73-community : Database - etracs_panabo2
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `account` */

DROP TABLE IF EXISTS `account`;

CREATE TABLE `account` (
  `objid` varchar(50) NOT NULL,
  `maingroupid` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `groupid` varchar(50) DEFAULT NULL,
  `accttype` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_account_code` (`maingroupid`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `account_group` */

DROP TABLE IF EXISTS `account_group`;

CREATE TABLE `account_group` (
  `objid` varchar(50) NOT NULL,
  `maingroupid` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `groupid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_acctgroup_code` (`maingroupid`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `account_item_mapping` */

DROP TABLE IF EXISTS `account_item_mapping`;

CREATE TABLE `account_item_mapping` (
  `objid` varchar(50) NOT NULL,
  `maingroupid` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `itemid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `account_maingroup` */

DROP TABLE IF EXISTS `account_maingroup`;

CREATE TABLE `account_maingroup` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `reporttype` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `account_payable` */

DROP TABLE IF EXISTS `account_payable`;

CREATE TABLE `account_payable` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `entity_objid` varchar(50) DEFAULT NULL,
  `entity_name` varchar(255) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_entity_objid` (`entity_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `account_payable_itemaccount` */

DROP TABLE IF EXISTS `account_payable_itemaccount`;

CREATE TABLE `account_payable_itemaccount` (
  `objid` varchar(50) NOT NULL,
  `apid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_apid` (`apid`),
  CONSTRAINT `fk_account_payable_itemaccount_apid` FOREIGN KEY (`apid`) REFERENCES `account_payable` (`objid`),
  CONSTRAINT `fk_account_payable_itemaccount_objid` FOREIGN KEY (`objid`) REFERENCES `itemaccount` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `account_receivable` */

DROP TABLE IF EXISTS `account_receivable`;

CREATE TABLE `account_receivable` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `totaldr` decimal(16,4) NOT NULL,
  `totalcr` decimal(16,4) NOT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `account_receivable_itemaccount` */

DROP TABLE IF EXISTS `account_receivable_itemaccount`;

CREATE TABLE `account_receivable_itemaccount` (
  `objid` varchar(50) NOT NULL,
  `arid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_arid` (`arid`),
  CONSTRAINT `fk_account_receivable_itemaccount_apid` FOREIGN KEY (`arid`) REFERENCES `account_receivable` (`objid`),
  CONSTRAINT `fk_account_receivable_itemaccount_objid` FOREIGN KEY (`objid`) REFERENCES `itemaccount` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `af` */

DROP TABLE IF EXISTS `af`;

CREATE TABLE `af` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `usetype` varchar(50) DEFAULT NULL,
  `serieslength` int(11) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `denomination` decimal(10,2) DEFAULT NULL,
  `formtype` varchar(50) DEFAULT NULL,
  `baseunit` varchar(10) DEFAULT NULL,
  `defaultunit` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `af_allocation` */

DROP TABLE IF EXISTS `af_allocation`;

CREATE TABLE `af_allocation` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `respcenter_objid` varchar(50) DEFAULT NULL,
  `respcenter_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `af_control` */

DROP TABLE IF EXISTS `af_control`;

CREATE TABLE `af_control` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `afid` varchar(50) DEFAULT NULL,
  `txnmode` varchar(10) DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(50) DEFAULT NULL,
  `startseries` int(11) DEFAULT NULL,
  `currentseries` int(11) DEFAULT NULL,
  `endseries` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_title` varchar(200) DEFAULT NULL,
  `stubno` int(11) DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `owner_objid` varchar(50) DEFAULT NULL,
  `owner_name` varchar(255) DEFAULT NULL,
  `prefix` varchar(10) NOT NULL,
  `suffix` varchar(10) NOT NULL,
  `dtfiled` date DEFAULT NULL,
  `currentindexno` int(11) DEFAULT NULL,
  `batchref` varchar(50) DEFAULT NULL,
  `batchno` int(50) DEFAULT NULL,
  `lockid` varchar(50) DEFAULT NULL,
  `respcenter_objid` varchar(50) DEFAULT NULL,
  `respcenter_name` varchar(100) DEFAULT NULL,
  `cost` decimal(16,2) DEFAULT NULL,
  `currentdetailid` varchar(50) DEFAULT NULL,
  `allocid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_code` (`afid`,`startseries`,`prefix`,`suffix`),
  KEY `ix_afid` (`afid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  KEY `ix_owner_objid` (`owner_objid`),
  KEY `ix_fund_objid` (`fund_objid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_org_name` (`org_name`),
  KEY `fk_af_contrl_currentdetail` (`currentdetailid`),
  CONSTRAINT `fk_af_contrl_currentdetail` FOREIGN KEY (`currentdetailid`) REFERENCES `af_control_detail` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `af_control_detail` */

DROP TABLE IF EXISTS `af_control_detail`;

CREATE TABLE `af_control_detail` (
  `objid` varchar(150) NOT NULL,
  `state` int(2) DEFAULT NULL,
  `controlid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refitemid` varchar(50) DEFAULT NULL,
  `refno` varchar(32) NOT NULL,
  `reftype` varchar(32) NOT NULL,
  `refdate` datetime NOT NULL,
  `txndate` datetime NOT NULL,
  `txntype` varchar(32) NOT NULL,
  `receivedstartseries` int(11) DEFAULT NULL,
  `receivedendseries` int(11) DEFAULT NULL,
  `beginstartseries` int(11) DEFAULT NULL,
  `beginendseries` int(11) DEFAULT NULL,
  `issuedstartseries` int(11) DEFAULT NULL,
  `issuedendseries` int(11) DEFAULT NULL,
  `endingstartseries` int(11) DEFAULT NULL,
  `endingendseries` int(11) DEFAULT NULL,
  `qtyreceived` int(11) NOT NULL,
  `qtybegin` int(11) NOT NULL,
  `qtyissued` int(11) NOT NULL,
  `qtyending` int(11) NOT NULL,
  `qtycancelled` int(11) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `issuedto_objid` varchar(50) DEFAULT NULL,
  `issuedto_name` varchar(255) DEFAULT NULL,
  `respcenter_objid` varchar(50) DEFAULT NULL,
  `respcenter_name` varchar(255) DEFAULT NULL,
  `prevdetailid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_controlid` (`controlid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_issuedto_objid` (`issuedto_objid`),
  KEY `ix_issuedto_name` (`issuedto_name`),
  KEY `ix_respcenter_objid` (`respcenter_objid`),
  KEY `ix_respcenter_name` (`respcenter_name`),
  KEY `fk_refitemid` (`refitemid`),
  CONSTRAINT `fk_af_control_detail_controlid` FOREIGN KEY (`controlid`) REFERENCES `af_control` (`objid`),
  CONSTRAINT `fk_af_ref` FOREIGN KEY (`refid`) REFERENCES `aftxn` (`objid`),
  CONSTRAINT `fk_refitemid` FOREIGN KEY (`refitemid`) REFERENCES `aftxnitem` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `afrequest` */

DROP TABLE IF EXISTS `afrequest`;

CREATE TABLE `afrequest` (
  `objid` varchar(50) NOT NULL,
  `reqno` varchar(20) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `reqtype` varchar(10) DEFAULT NULL,
  `itemclass` varchar(50) DEFAULT NULL,
  `requester_objid` varchar(50) DEFAULT NULL,
  `requester_name` varchar(50) DEFAULT NULL,
  `requester_title` varchar(50) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `vendor` varchar(100) DEFAULT NULL,
  `respcenter_objid` varchar(50) DEFAULT NULL,
  `respcenter_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_reqno` (`reqno`),
  KEY `ix_state` (`state`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_requester_objid` (`requester_objid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_requester_name` (`requester_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `afrequestitem` */

DROP TABLE IF EXISTS `afrequestitem`;

CREATE TABLE `afrequestitem` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `item_objid` varchar(50) DEFAULT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `qtyreceived` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_item_objid` (`item_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `aftxn` */

DROP TABLE IF EXISTS `aftxn`;

CREATE TABLE `aftxn` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `request_objid` varchar(50) DEFAULT NULL,
  `request_reqno` varchar(50) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `user_objid` varchar(50) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `issueto_objid` varchar(50) DEFAULT NULL,
  `issueto_name` varchar(100) DEFAULT NULL,
  `issueto_title` varchar(50) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `respcenter_objid` varchar(50) DEFAULT NULL,
  `respcenter_name` varchar(100) DEFAULT NULL,
  `txndate` datetime NOT NULL,
  `cost` decimal(16,2) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_issueno` (`controlno`),
  KEY `ix_request_objid` (`request_objid`),
  KEY `ix_request_reqno` (`request_reqno`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_user_objid` (`user_objid`),
  KEY `ix_issueto_objid` (`issueto_objid`),
  KEY `ix_org_objid` (`org_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `aftxn_type` */

DROP TABLE IF EXISTS `aftxn_type`;

CREATE TABLE `aftxn_type` (
  `txntype` varchar(50) NOT NULL,
  `formtype` varchar(50) DEFAULT NULL,
  `poststate` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`txntype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `aftxnitem` */

DROP TABLE IF EXISTS `aftxnitem`;

CREATE TABLE `aftxnitem` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `item_objid` varchar(50) DEFAULT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `qtyserved` int(11) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `cost` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_item_objid` (`item_objid`),
  CONSTRAINT `fk_afir` FOREIGN KEY (`parentid`) REFERENCES `aftxn` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `afunit` */

DROP TABLE IF EXISTS `afunit`;

CREATE TABLE `afunit` (
  `objid` varchar(50) NOT NULL,
  `itemid` varchar(50) DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `saleprice` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `assessmentnotice` */

DROP TABLE IF EXISTS `assessmentnotice`;

CREATE TABLE `assessmentnotice` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `taxpayerid` varchar(50) NOT NULL,
  `taxpayername` text NOT NULL,
  `taxpayeraddress` varchar(150) NOT NULL,
  `createdbyid` varchar(50) DEFAULT NULL,
  `createdbyname` varchar(100) NOT NULL,
  `createdbytitle` varchar(50) NOT NULL,
  `approvedbyid` varchar(50) DEFAULT NULL,
  `approvedbyname` varchar(100) DEFAULT NULL,
  `approvedbytitle` varchar(50) DEFAULT NULL,
  `dtdelivered` datetime DEFAULT NULL,
  `receivedby` varchar(150) DEFAULT NULL,
  `remarks` text,
  `assessmentyear` int(11) DEFAULT NULL,
  `administrator_name` varchar(150) DEFAULT NULL,
  `administrator_address` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_assessmentnotice_receivedby` (`receivedby`),
  KEY `ix_assessmentnotice_state` (`state`),
  KEY `ix_assessmentnotice_taxpayerid` (`taxpayerid`),
  KEY `ix_assessmentnotice_txnno` (`txnno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `assessmentnoticeitem` */

DROP TABLE IF EXISTS `assessmentnoticeitem`;

CREATE TABLE `assessmentnoticeitem` (
  `objid` varchar(50) NOT NULL,
  `assessmentnoticeid` varchar(50) NOT NULL,
  `faasid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_assessmentnoticeitem_assessmentnotice` (`assessmentnoticeid`),
  KEY `FK_assessmentnoticeitem_faas` (`faasid`),
  CONSTRAINT `assessmentnoticeitem_ibfk_1` FOREIGN KEY (`assessmentnoticeid`) REFERENCES `assessmentnotice` (`objid`),
  CONSTRAINT `assessmentnoticeitem_ibfk_2` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bank` */

DROP TABLE IF EXISTS `bank`;

CREATE TABLE `bank` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `branchname` varchar(50) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `manager` varchar(50) DEFAULT NULL,
  `deposittype` varchar(50) DEFAULT NULL,
  `depository` int(11) DEFAULT NULL,
  `cashreport` varchar(50) DEFAULT NULL,
  `cashbreakdownreport` varchar(50) DEFAULT NULL,
  `checkreport` varchar(50) DEFAULT NULL,
  `checkbreakdownreport` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bankaccount` */

DROP TABLE IF EXISTS `bankaccount`;

CREATE TABLE `bankaccount` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `accttype` varchar(50) NOT NULL,
  `bank_objid` varchar(50) NOT NULL,
  `bank_code` varchar(50) NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `fund_objid` varchar(50) NOT NULL,
  `fund_code` varchar(50) NOT NULL,
  `fund_title` varchar(50) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_code` (`code`),
  KEY `ix_bank_objid` (`bank_objid`),
  KEY `ix_fund_objid` (`fund_objid`),
  CONSTRAINT `fk_bankaccount_bank_objid` FOREIGN KEY (`bank_objid`) REFERENCES `bank` (`objid`),
  CONSTRAINT `fk_bankaccount_fund_objid` FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bankaccount_summary` */

DROP TABLE IF EXISTS `bankaccount_summary`;

CREATE TABLE `bankaccount_summary` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `barangay` */

DROP TABLE IF EXISTS `barangay`;

CREATE TABLE `barangay` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `indexno` varchar(15) DEFAULT NULL,
  `pin` varchar(15) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `captain_name` varchar(100) DEFAULT NULL,
  `captain_title` varchar(50) DEFAULT NULL,
  `captain_office` varchar(50) DEFAULT NULL,
  `treasurer_name` varchar(100) DEFAULT NULL,
  `treasurer_title` varchar(50) DEFAULT NULL,
  `treasurer_office` varchar(50) DEFAULT NULL,
  `oldindexno` varchar(15) DEFAULT NULL,
  `oldpin` varchar(15) DEFAULT NULL,
  `fullname` varchar(250) DEFAULT NULL,
  `address` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_indexno` (`indexno`),
  KEY `ix_pin` (`pin`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `fk_barangay_objid` FOREIGN KEY (`objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `batchcapture_collection` */

DROP TABLE IF EXISTS `batchcapture_collection`;

CREATE TABLE `batchcapture_collection` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `txndate` datetime NOT NULL,
  `defaultreceiptdate` datetime NOT NULL,
  `txnmode` varchar(10) NOT NULL,
  `stub` int(11) NOT NULL,
  `formno` varchar(50) NOT NULL,
  `formtype` varchar(10) NOT NULL,
  `controlid` varchar(50) NOT NULL,
  `serieslength` int(11) NOT NULL,
  `prefix` varchar(10) DEFAULT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `startseries` int(11) NOT NULL,
  `endseries` int(11) NOT NULL,
  `totalamount` decimal(16,2) NOT NULL,
  `totalcash` decimal(16,2) NOT NULL,
  `totalnoncash` decimal(16,2) NOT NULL,
  `collectiontype_objid` varchar(50) DEFAULT NULL,
  `collectiontype_name` varchar(100) DEFAULT NULL,
  `collector_objid` varchar(50) DEFAULT NULL,
  `collector_name` varchar(100) DEFAULT NULL,
  `collector_title` varchar(50) DEFAULT NULL,
  `capturedby_objid` varchar(50) DEFAULT NULL,
  `capturedby_name` varchar(100) DEFAULT NULL,
  `capturedby_title` varchar(50) DEFAULT NULL,
  `org_objid` varchar(50) NOT NULL,
  `org_name` varchar(50) NOT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(100) DEFAULT NULL,
  `postedby_date` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_defaultreceiptdate` (`defaultreceiptdate`),
  KEY `ix_formno` (`formno`),
  KEY `ix_controlid` (`controlid`),
  KEY `ix_collectiontype_objid` (`collectiontype_objid`),
  KEY `ix_collector_objid` (`collector_objid`),
  KEY `ix_collector_name` (`collector_name`),
  KEY `ix_capturedby_objid` (`capturedby_objid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  CONSTRAINT `fk_batchcapture_collection_collector_objid` FOREIGN KEY (`collector_objid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `batchcapture_collection_entry` */

DROP TABLE IF EXISTS `batchcapture_collection_entry`;

CREATE TABLE `batchcapture_collection_entry` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `receiptno` varchar(50) NOT NULL,
  `receiptdate` datetime NOT NULL,
  `paidby` varchar(100) NOT NULL,
  `paidbyaddress` varchar(255) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `totalcash` decimal(16,2) NOT NULL,
  `totalnoncash` decimal(16,2) NOT NULL,
  `series` int(11) NOT NULL,
  `collectiontype_objid` varchar(50) DEFAULT NULL,
  `collectiontype_name` varchar(100) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `particulars` longtext,
  `voided` int(11) DEFAULT NULL,
  `paymentitems` longtext,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_receiptno` (`receiptno`),
  KEY `ix_receiptdate` (`receiptdate`),
  KEY `ix_collectiontype_objid` (`collectiontype_objid`),
  CONSTRAINT `fk_batchcapture_collection_entry_collectiontype_objid` FOREIGN KEY (`collectiontype_objid`) REFERENCES `collectiontype` (`objid`),
  CONSTRAINT `fk_batchcapture_collection_entry_parentid` FOREIGN KEY (`parentid`) REFERENCES `batchcapture_collection` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `batchcapture_collection_entry_item` */

DROP TABLE IF EXISTS `batchcapture_collection_entry_item`;

CREATE TABLE `batchcapture_collection_entry_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `item_objid` varchar(50) DEFAULT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `item_title` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_code` varchar(50) DEFAULT NULL,
  `fund_title` varchar(50) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_item_objid` (`item_objid`),
  KEY `ix_fund_objid` (`fund_objid`),
  CONSTRAINT `fk_batchcapture_collection_entry_item_fund` FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`),
  CONSTRAINT `fk_batchcapture_collection_entry_item_itemaccount` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `fk_batchcapture_collection_entry_item_parentid` FOREIGN KEY (`parentid`) REFERENCES `batchcapture_collection_entry` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `batchgr_error` */

DROP TABLE IF EXISTS `batchgr_error`;

CREATE TABLE `batchgr_error` (
  `objid` varchar(50) NOT NULL,
  `newry` int(11) NOT NULL,
  `msg` longtext,
  `barangayid` varchar(50) DEFAULT NULL,
  `barangay` varchar(100) DEFAULT NULL,
  `tdno` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `batchgr_items_forrevision` */

DROP TABLE IF EXISTS `batchgr_items_forrevision`;

CREATE TABLE `batchgr_items_forrevision` (
  `objid` varchar(50) NOT NULL,
  `rpuid` varchar(50) NOT NULL,
  `realpropertyid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(25) NOT NULL,
  `fullpin` varchar(30) NOT NULL,
  `pin` varchar(30) NOT NULL,
  `suffix` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `billitem_txntype` */

DROP TABLE IF EXISTS `billitem_txntype`;

CREATE TABLE `billitem_txntype` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgadditionalitem` */

DROP TABLE IF EXISTS `bldgadditionalitem`;

CREATE TABLE `bldgadditionalitem` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `unit` varchar(25) NOT NULL,
  `expr` varchar(100) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `addareatobldgtotalarea` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `UQ_settingid_code` (`bldgrysettingid`,`code`),
  UNIQUE KEY `UQ_settingid_name` (`bldgrysettingid`,`name`),
  KEY `bldgrysettingid` (`bldgrysettingid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `bldgadditionalitem_ibfk_1` FOREIGN KEY (`previd`) REFERENCES `bldgadditionalitem` (`objid`),
  CONSTRAINT `bldgadditionalitem_ibfk_2` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgassesslevel` */

DROP TABLE IF EXISTS `bldgassesslevel`;

CREATE TABLE `bldgassesslevel` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `fixrate` int(11) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgassesslevel_code` (`bldgrysettingid`,`code`),
  UNIQUE KEY `ux_bldgassesslevel_name` (`bldgrysettingid`,`name`),
  KEY `FK_bldgassesslevel_bldgrysettingid` (`bldgrysettingid`),
  KEY `FK_bldgassesslevel_propertyclassification` (`classification_objid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `bldgassesslevel_ibfk_1` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `bldgassesslevel_ibfk_2` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgassesslevelrange` */

DROP TABLE IF EXISTS `bldgassesslevelrange`;

CREATE TABLE `bldgassesslevelrange` (
  `objid` varchar(50) NOT NULL,
  `bldgassesslevelid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `mvfrom` decimal(16,2) NOT NULL,
  `mvto` decimal(16,2) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgassesslevelrange_mvfrom` (`bldgassesslevelid`,`mvfrom`),
  KEY `bldgassesslevelid` (`bldgassesslevelid`),
  KEY `FK_bldgassesslevelrange_bldgrysetting` (`bldgrysettingid`),
  CONSTRAINT `bldgassesslevelrange_ibfk_1` FOREIGN KEY (`bldgassesslevelid`) REFERENCES `bldgassesslevel` (`objid`),
  CONSTRAINT `bldgassesslevelrange_ibfk_2` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgfloor` */

DROP TABLE IF EXISTS `bldgfloor`;

CREATE TABLE `bldgfloor` (
  `objid` varchar(50) NOT NULL,
  `bldguseid` varchar(50) NOT NULL,
  `bldgrpuid` varchar(50) NOT NULL,
  `floorno` varchar(5) NOT NULL,
  `area` decimal(16,2) NOT NULL,
  `storeyrate` decimal(16,2) NOT NULL,
  `basevalue` decimal(16,2) NOT NULL,
  `unitvalue` decimal(16,2) NOT NULL,
  `basemarketvalue` decimal(16,2) NOT NULL,
  `adjustment` decimal(16,2) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_bldgfloor_bldgrpu` (`bldgrpuid`),
  KEY `FK_bldgfloor_bldguse` (`bldguseid`),
  CONSTRAINT `bldgfloor_ibfk_1` FOREIGN KEY (`bldgrpuid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `bldgfloor_ibfk_2` FOREIGN KEY (`bldguseid`) REFERENCES `bldguse` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgflooradditional` */

DROP TABLE IF EXISTS `bldgflooradditional`;

CREATE TABLE `bldgflooradditional` (
  `objid` varchar(50) NOT NULL,
  `bldgfloorid` varchar(50) NOT NULL,
  `bldgrpuid` varchar(50) NOT NULL,
  `additionalitem_objid` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `expr` text NOT NULL,
  `depreciate` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_bldgflooradditional_additionalitem` (`additionalitem_objid`),
  KEY `FK_bldgflooradditional_bldgfloor` (`bldgfloorid`),
  KEY `FK_bldgflooradditional_bldgrpu` (`bldgrpuid`),
  CONSTRAINT `bldgflooradditional_ibfk_1` FOREIGN KEY (`additionalitem_objid`) REFERENCES `bldgadditionalitem` (`objid`),
  CONSTRAINT `bldgflooradditional_ibfk_2` FOREIGN KEY (`bldgfloorid`) REFERENCES `bldgfloor` (`objid`),
  CONSTRAINT `bldgflooradditional_ibfk_3` FOREIGN KEY (`bldgrpuid`) REFERENCES `bldgrpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgflooradditionalparam` */

DROP TABLE IF EXISTS `bldgflooradditionalparam`;

CREATE TABLE `bldgflooradditionalparam` (
  `objid` varchar(50) NOT NULL,
  `bldgflooradditionalid` varchar(50) NOT NULL,
  `bldgrpuid` varchar(50) NOT NULL,
  `param_objid` varchar(50) NOT NULL,
  `intvalue` int(11) DEFAULT NULL,
  `decimalvalue` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_bldgflooradditionalparam_bldgflooradditional` (`bldgflooradditionalid`),
  KEY `FK_bldgflooradditionalparam_bldgrpu` (`bldgrpuid`),
  KEY `FK_bldgflooradditionalparam_param` (`param_objid`),
  CONSTRAINT `bldgflooradditionalparam_ibfk_1` FOREIGN KEY (`bldgflooradditionalid`) REFERENCES `bldgflooradditional` (`objid`),
  CONSTRAINT `bldgflooradditionalparam_ibfk_2` FOREIGN KEY (`bldgrpuid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `bldgflooradditionalparam_ibfk_3` FOREIGN KEY (`param_objid`) REFERENCES `rptparameter` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgkind` */

DROP TABLE IF EXISTS `bldgkind`;

CREATE TABLE `bldgkind` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgkind_code` (`code`),
  UNIQUE KEY `ux_bldgkind_name` (`name`),
  KEY `ix_bldgkind_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgkindbucc` */

DROP TABLE IF EXISTS `bldgkindbucc`;

CREATE TABLE `bldgkindbucc` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `bldgkind_objid` varchar(50) NOT NULL,
  `basevaluetype` varchar(25) NOT NULL,
  `basevalue` decimal(10,2) NOT NULL,
  `minbasevalue` decimal(10,2) NOT NULL,
  `maxbasevalue` decimal(10,2) NOT NULL,
  `gapvalue` int(11) NOT NULL,
  `minarea` decimal(10,2) NOT NULL,
  `maxarea` decimal(10,2) NOT NULL,
  `bldgclass` varchar(50) DEFAULT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `bldgrysettingid` (`bldgrysettingid`),
  KEY `FK_bldgkindbucc_bldgkind` (`bldgkind_objid`),
  KEY `FK_bldgkindbucc_bldgtype` (`bldgtypeid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `bldgkindbucc_ibfk_1` FOREIGN KEY (`bldgkind_objid`) REFERENCES `bldgkind` (`objid`),
  CONSTRAINT `bldgkindbucc_ibfk_2` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `bldgkindbucc_ibfk_3` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgrpu` */

DROP TABLE IF EXISTS `bldgrpu`;

CREATE TABLE `bldgrpu` (
  `objid` varchar(50) NOT NULL,
  `landrpuid` varchar(50) DEFAULT NULL,
  `houseno` varchar(25) DEFAULT NULL,
  `psic` varchar(255) DEFAULT NULL,
  `permitno` varchar(255) DEFAULT NULL,
  `permitdate` datetime DEFAULT NULL,
  `permitissuedby` varchar(255) DEFAULT NULL,
  `bldgtype_objid` varchar(50) DEFAULT NULL,
  `bldgkindbucc_objid` varchar(50) DEFAULT NULL,
  `basevalue` decimal(16,2) NOT NULL,
  `dtcompleted` datetime DEFAULT NULL,
  `dtoccupied` datetime DEFAULT NULL,
  `floorcount` int(11) NOT NULL,
  `depreciation` decimal(16,2) NOT NULL,
  `depreciationvalue` decimal(16,2) NOT NULL,
  `totaladjustment` decimal(16,2) NOT NULL,
  `additionalinfo` text,
  `bldgage` int(11) NOT NULL,
  `percentcompleted` int(11) NOT NULL,
  `bldgassesslevel_objid` varchar(50) DEFAULT NULL,
  `assesslevel` decimal(16,2) NOT NULL,
  `condominium` int(11) NOT NULL,
  `bldgclass` varchar(15) DEFAULT NULL,
  `predominant` int(11) DEFAULT NULL,
  `effectiveage` int(11) NOT NULL,
  `condocerttitle` varchar(50) DEFAULT NULL,
  `dtcertcompletion` date DEFAULT NULL,
  `dtcertoccupancy` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_bldgrpu_bldgassesslevel` (`bldgassesslevel_objid`),
  KEY `FK_bldgrpu_bldgkindbucc` (`bldgkindbucc_objid`),
  KEY `FK_bldgrpu_bldgtype` (`bldgtype_objid`),
  KEY `FK_bldgrpu_landrpu` (`landrpuid`),
  CONSTRAINT `bldgrpu_ibfk_1` FOREIGN KEY (`bldgassesslevel_objid`) REFERENCES `bldgassesslevel` (`objid`),
  CONSTRAINT `bldgrpu_ibfk_2` FOREIGN KEY (`bldgkindbucc_objid`) REFERENCES `bldgkindbucc` (`objid`),
  CONSTRAINT `bldgrpu_ibfk_3` FOREIGN KEY (`bldgtype_objid`) REFERENCES `bldgtype` (`objid`),
  CONSTRAINT `bldgrpu_ibfk_4` FOREIGN KEY (`landrpuid`) REFERENCES `landrpu` (`objid`),
  CONSTRAINT `bldgrpu_ibfk_5` FOREIGN KEY (`objid`) REFERENCES `rpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgrpu_land` */

DROP TABLE IF EXISTS `bldgrpu_land`;

CREATE TABLE `bldgrpu_land` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `bldgrpuid` varchar(50) NOT NULL DEFAULT '',
  `landfaas_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgrpu_land_bldgrpu_landfaas` (`bldgrpuid`,`landfaas_objid`),
  KEY `ix_bldgrpu_land_bldgrpuid` (`bldgrpuid`),
  KEY `ix_bldgrpu_land_landfaasid` (`landfaas_objid`),
  CONSTRAINT `FK_bldgrpu_land_bldgrpu` FOREIGN KEY (`bldgrpuid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `FK_bldgrpu_land_landfaas` FOREIGN KEY (`landfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgrpu_structuraltype` */

DROP TABLE IF EXISTS `bldgrpu_structuraltype`;

CREATE TABLE `bldgrpu_structuraltype` (
  `objid` varchar(50) NOT NULL,
  `bldgrpuid` varchar(50) NOT NULL,
  `bldgtype_objid` varchar(50) NOT NULL,
  `bldgkindbucc_objid` varchar(50) NOT NULL,
  `floorcount` int(11) NOT NULL,
  `basefloorarea` decimal(16,2) NOT NULL,
  `totalfloorarea` decimal(16,2) NOT NULL,
  `basevalue` decimal(16,2) NOT NULL,
  `unitvalue` decimal(16,2) NOT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_bldgrpu_structuraltype_bldgtype` (`bldgtype_objid`),
  KEY `FK_bldgrpu_structuraltype_bldgkindbucc` (`bldgkindbucc_objid`),
  KEY `FK_bldgrpu_structuraltype_bldgrpu` (`bldgrpuid`),
  KEY `FK_bldgrpu_structuraltype` (`classification_objid`),
  CONSTRAINT `FK_bldgrpu_structuraltype` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`),
  CONSTRAINT `FK_bldgrpu_structuraltype_bldgkindbucc` FOREIGN KEY (`bldgkindbucc_objid`) REFERENCES `bldgkindbucc` (`objid`),
  CONSTRAINT `FK_bldgrpu_structuraltype_bldgrpu` FOREIGN KEY (`bldgrpuid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `FK_bldgrpu_structuraltype_bldgtype` FOREIGN KEY (`bldgtype_objid`) REFERENCES `bldgtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgrysetting` */

DROP TABLE IF EXISTS `bldgrysetting`;

CREATE TABLE `bldgrysetting` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `ry` int(11) NOT NULL,
  `predominant` int(11) DEFAULT NULL,
  `depreciatecoreanditemseparately` int(11) DEFAULT NULL,
  `computedepreciationbasedonschedule` int(11) DEFAULT NULL,
  `straightdepreciation` int(11) DEFAULT NULL,
  `calcbldgagebasedondtoccupied` int(11) DEFAULT NULL,
  `appliedto` longtext,
  `previd` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_bldgrysetting_previd` (`previd`),
  KEY `ix_bldgrysetting_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgstructure` */

DROP TABLE IF EXISTS `bldgstructure`;

CREATE TABLE `bldgstructure` (
  `objid` varchar(50) NOT NULL,
  `bldgrpuid` varchar(50) NOT NULL,
  `structure_objid` varchar(50) NOT NULL,
  `material_objid` varchar(50) DEFAULT NULL,
  `floor` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgstructure` (`bldgrpuid`,`floor`,`structure_objid`,`material_objid`),
  KEY `FK_bldgstructure_bldgrpu` (`bldgrpuid`),
  KEY `FK_bldgstructure_material` (`material_objid`),
  KEY `FK_bldgstructure_structure` (`structure_objid`),
  CONSTRAINT `bldgstructure_ibfk_1` FOREIGN KEY (`bldgrpuid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `bldgstructure_ibfk_2` FOREIGN KEY (`material_objid`) REFERENCES `material` (`objid`),
  CONSTRAINT `bldgstructure_ibfk_3` FOREIGN KEY (`structure_objid`) REFERENCES `structure` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgtype` */

DROP TABLE IF EXISTS `bldgtype`;

CREATE TABLE `bldgtype` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `basevaluetype` varchar(10) NOT NULL,
  `residualrate` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `bldgrysettingid` (`bldgrysettingid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `bldgtype_ibfk_1` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `bldgtype_ibfk_2` FOREIGN KEY (`previd`) REFERENCES `bldgtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgtype_depreciation` */

DROP TABLE IF EXISTS `bldgtype_depreciation`;

CREATE TABLE `bldgtype_depreciation` (
  `objid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `agefrom` int(11) NOT NULL,
  `ageto` int(11) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_bldgtype_depreciation_bldgrysetting` (`bldgrysettingid`),
  KEY `ix_bldgtypeid` (`bldgtypeid`),
  CONSTRAINT `bldgtype_depreciation_ibfk_1` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `bldgtype_depreciation_ibfk_2` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldgtype_storeyadjustment` */

DROP TABLE IF EXISTS `bldgtype_storeyadjustment`;

CREATE TABLE `bldgtype_storeyadjustment` (
  `objid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `floorno` varchar(10) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `bldgtypeid` (`bldgtypeid`),
  KEY `FK_bldgtype_storeyadjustment` (`previd`),
  KEY `FK_bldgtype_storeyadjustment_bldgrysetting` (`bldgrysettingid`),
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_1` FOREIGN KEY (`previd`) REFERENCES `bldgtype_storeyadjustment` (`objid`),
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_2` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_3` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bldguse` */

DROP TABLE IF EXISTS `bldguse`;

CREATE TABLE `bldguse` (
  `objid` varchar(50) NOT NULL,
  `bldgrpuid` varchar(50) NOT NULL,
  `structuraltype_objid` varchar(50) DEFAULT NULL,
  `actualuse_objid` varchar(50) NOT NULL,
  `basevalue` decimal(16,2) NOT NULL,
  `area` decimal(16,2) NOT NULL,
  `basemarketvalue` decimal(16,2) NOT NULL,
  `depreciationvalue` decimal(16,2) NOT NULL,
  `adjustment` decimal(16,2) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  `assesslevel` decimal(16,2) DEFAULT NULL,
  `assessedvalue` decimal(16,2) DEFAULT NULL,
  `addlinfo` varchar(255) DEFAULT NULL,
  `adjfordepreciation` decimal(16,2) DEFAULT NULL,
  `taxable` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_bldguse_bldgassesslevel` (`actualuse_objid`),
  KEY `FK_bldguse_bldgrpu` (`bldgrpuid`),
  KEY `FK_bldguse_structuraltype` (`structuraltype_objid`),
  CONSTRAINT `bldguse_ibfk_1` FOREIGN KEY (`actualuse_objid`) REFERENCES `bldgassesslevel` (`objid`),
  CONSTRAINT `bldguse_ibfk_2` FOREIGN KEY (`bldgrpuid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `FK_bldguse_structuraltype` FOREIGN KEY (`structuraltype_objid`) REFERENCES `bldgrpu_structuraltype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bpexpirydate` */

DROP TABLE IF EXISTS `bpexpirydate`;

CREATE TABLE `bpexpirydate` (
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `expirydate` date DEFAULT NULL,
  `reason` text,
  PRIMARY KEY (`year`,`qtr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `brgy_taxaccount_mapping` */

DROP TABLE IF EXISTS `brgy_taxaccount_mapping`;

CREATE TABLE `brgy_taxaccount_mapping` (
  `barangayid` varchar(50) NOT NULL,
  `basicadvacct_objid` varchar(50) DEFAULT NULL,
  `basicprevacct_objid` varchar(50) DEFAULT NULL,
  `basicprevintacct_objid` varchar(50) DEFAULT NULL,
  `basicprioracct_objid` varchar(50) DEFAULT NULL,
  `basicpriorintacct_objid` varchar(50) DEFAULT NULL,
  `basiccurracct_objid` varchar(50) DEFAULT NULL,
  `basiccurrintacct_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `brgyshare` */

DROP TABLE IF EXISTS `brgyshare`;

CREATE TABLE `brgyshare` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(15) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `totalshare` decimal(16,2) NOT NULL,
  `createdbyid` varchar(50) DEFAULT NULL,
  `createdby` varchar(150) NOT NULL,
  `createdbytitle` varchar(50) NOT NULL,
  `postedbyid` varchar(50) DEFAULT NULL,
  `postedby` varchar(150) DEFAULT NULL,
  `postedbytitle` varchar(50) DEFAULT NULL,
  `sharetype` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_brgyshare_state` (`state`),
  KEY `ix_brgyshare_yq` (`year`),
  KEY `ix_brgyshare_yqm` (`year`,`month`),
  KEY `ix_brgyshare_yr` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `brgyshare_account_mapping` */

DROP TABLE IF EXISTS `brgyshare_account_mapping`;

CREATE TABLE `brgyshare_account_mapping` (
  `barangayid` varchar(50) NOT NULL,
  `acct_objid` varchar(50) NOT NULL,
  `penaltyacct_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `brgyshareitem` */

DROP TABLE IF EXISTS `brgyshareitem`;

CREATE TABLE `brgyshareitem` (
  `objid` varchar(50) NOT NULL,
  `brgyshareid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicdisc` decimal(16,2) NOT NULL,
  `basicshare` decimal(16,2) NOT NULL,
  `basicintshare` decimal(16,2) NOT NULL,
  `commonshare` decimal(16,2) DEFAULT NULL,
  `basiccurrent` decimal(16,2) DEFAULT NULL,
  `basicprevious` decimal(16,2) DEFAULT NULL,
  `basiccollection` decimal(16,2) DEFAULT NULL,
  `basicintcollection` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `brgyshareid` (`brgyshareid`),
  CONSTRAINT `brgyshareitem_ibfk_1` FOREIGN KEY (`brgyshareid`) REFERENCES `brgyshare` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business` */

DROP TABLE IF EXISTS `business`;

CREATE TABLE `business` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `owner_name` varchar(255) NOT NULL,
  `owner_objid` varchar(50) NOT NULL,
  `owner_address_text` varchar(255) DEFAULT NULL,
  `owner_address_objid` varchar(50) DEFAULT NULL,
  `businessname` varchar(255) DEFAULT NULL,
  `tradename` varchar(255) NOT NULL,
  `address_text` varchar(255) DEFAULT NULL,
  `address_objid` varchar(50) DEFAULT NULL,
  `orgtype` varchar(50) DEFAULT NULL,
  `yearstarted` int(11) DEFAULT NULL,
  `activeyear` int(11) DEFAULT NULL,
  `pin` varchar(50) DEFAULT NULL,
  `taxcredit` decimal(18,2) DEFAULT NULL,
  `currentapplicationid` varchar(50) DEFAULT NULL,
  `currentpermitid` varchar(50) DEFAULT NULL,
  `bin` varchar(50) DEFAULT NULL,
  `activeqtr` int(11) DEFAULT NULL,
  `appcount` int(11) DEFAULT NULL,
  `mobileno` varchar(50) DEFAULT NULL,
  `phoneno` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `apptype` varchar(50) DEFAULT NULL,
  `oldbin` varchar(50) DEFAULT NULL,
  `permit_objid` varchar(50) DEFAULT NULL,
  `permittype` varchar(50) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `officetype` varchar(25) DEFAULT NULL,
  `purpose` varchar(50) DEFAULT NULL,
  `nextrenewaldate` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_businessname` (`businessname`),
  UNIQUE KEY `uix_bin` (`bin`),
  KEY `ix_state` (`state`),
  KEY `ix_owner_objid` (`owner_objid`),
  KEY `ix_owner_name` (`owner_name`),
  KEY `ix_owner_address_objid` (`owner_address_objid`),
  KEY `ix_tradename` (`tradename`),
  KEY `ix_address_objid` (`address_objid`),
  KEY `ix_bin` (`bin`),
  KEY `ix_currentapplicationid` (`currentapplicationid`),
  KEY `ix_currentpermitid` (`currentpermitid`),
  KEY `ix_yearstarted` (`yearstarted`),
  KEY `ix_activeyear` (`activeyear`),
  CONSTRAINT `FK_business_business_address` FOREIGN KEY (`address_objid`) REFERENCES `business_address` (`objid`),
  CONSTRAINT `FK_business_business_application` FOREIGN KEY (`currentapplicationid`) REFERENCES `business_application` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_active_info` */

DROP TABLE IF EXISTS `business_active_info`;

CREATE TABLE `business_active_info` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `businessid` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `attribute_objid` varchar(50) NOT NULL,
  `attribute_name` varchar(50) NOT NULL,
  `lob_objid` varchar(50) DEFAULT NULL,
  `lob_name` varchar(100) DEFAULT NULL,
  `decimalvalue` decimal(16,2) DEFAULT NULL,
  `intvalue` int(11) DEFAULT NULL,
  `stringvalue` varchar(255) DEFAULT NULL,
  `boolvalue` int(11) DEFAULT NULL,
  `phase` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_attribute_objid` (`attribute_objid`),
  KEY `ix_attribute_name` (`attribute_name`),
  KEY `ix_lob_objid` (`lob_objid`),
  KEY `ix_lob_name` (`lob_name`),
  CONSTRAINT `FK_business_active_info_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`),
  CONSTRAINT `FK_business_active_info_lob` FOREIGN KEY (`lob_objid`) REFERENCES `lob` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_active_lob` */

DROP TABLE IF EXISTS `business_active_lob`;

CREATE TABLE `business_active_lob` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) NOT NULL,
  `lobid` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_lobid` (`lobid`),
  CONSTRAINT `FK_business_active_lob_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`),
  CONSTRAINT `FK_business_active_lob_lob` FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_active_lob_history` */

DROP TABLE IF EXISTS `business_active_lob_history`;

CREATE TABLE `business_active_lob_history` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `activeyear` int(11) DEFAULT NULL,
  `lobid` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_businessid_activeyear_lobid` (`businessid`,`activeyear`,`lobid`) USING BTREE,
  KEY `ix_businessid` (`businessid`) USING BTREE,
  KEY `ix_activeyear` (`activeyear`) USING BTREE,
  KEY `ix_lobid` (`lobid`) USING BTREE,
  CONSTRAINT `fk_business_active_lob_history_businessid` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`),
  CONSTRAINT `fk_business_active_lob_history_lobid` FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_active_lob_history_forprocess` */

DROP TABLE IF EXISTS `business_active_lob_history_forprocess`;

CREATE TABLE `business_active_lob_history_forprocess` (
  `businessid` varchar(50) NOT NULL,
  PRIMARY KEY (`businessid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_address` */

DROP TABLE IF EXISTS `business_address`;

CREATE TABLE `business_address` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `businessid` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `addresstype` varchar(50) DEFAULT NULL,
  `barangay_objid` varchar(50) DEFAULT NULL,
  `barangay_name` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `province` varchar(50) DEFAULT NULL,
  `municipality` varchar(50) DEFAULT NULL,
  `bldgno` varchar(50) DEFAULT NULL,
  `bldgname` varchar(50) DEFAULT NULL,
  `unitno` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `subdivision` varchar(100) DEFAULT NULL,
  `pin` varchar(50) DEFAULT NULL,
  `monthlyrent` decimal(18,2) DEFAULT NULL,
  `lessor_objid` varchar(50) DEFAULT NULL,
  `lessor_name` varchar(255) DEFAULT NULL,
  `lessor_address_text` varchar(255) DEFAULT NULL,
  `rentedaddressid` varchar(50) DEFAULT NULL,
  `ownedaddressid` varchar(50) DEFAULT NULL,
  `lessor_address_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_barangay_objid` (`barangay_objid`),
  KEY `ix_lessor_objid` (`lessor_objid`),
  KEY `ix_rentedaddressid` (`rentedaddressid`),
  KEY `ix_ownedaddressid` (`ownedaddressid`),
  KEY `ix_lessor_address_objid` (`lessor_address_objid`),
  CONSTRAINT `FK_business_address_ownerid` FOREIGN KEY (`ownedaddressid`) REFERENCES `business_lessor` (`objid`),
  CONSTRAINT `FK_business_address_rentedaddressid` FOREIGN KEY (`rentedaddressid`) REFERENCES `business_lessor` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_application` */

DROP TABLE IF EXISTS `business_application`;

CREATE TABLE `business_application` (
  `objid` varchar(50) NOT NULL,
  `business_objid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `appno` varchar(50) DEFAULT NULL,
  `apptype` varchar(25) DEFAULT NULL,
  `dtfiled` date DEFAULT NULL,
  `ownername` varchar(255) DEFAULT NULL,
  `owneraddress` varchar(255) DEFAULT NULL,
  `tradename` varchar(255) DEFAULT NULL,
  `businessaddress` varchar(255) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `yearstarted` int(11) DEFAULT NULL,
  `appyear` int(11) DEFAULT NULL,
  `appqtr` int(11) DEFAULT NULL,
  `txnmode` varchar(25) DEFAULT NULL,
  `assessor_objid` varchar(50) DEFAULT NULL,
  `assessor_name` varchar(255) DEFAULT NULL,
  `assessor_title` varchar(50) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `approver_objid` varchar(50) DEFAULT NULL,
  `approver_name` varchar(255) DEFAULT NULL,
  `approver_title` varchar(50) DEFAULT NULL,
  `dtreleased` datetime DEFAULT NULL,
  `totals_tax` decimal(18,2) DEFAULT NULL,
  `totals_regfee` decimal(18,2) DEFAULT NULL,
  `totals_othercharge` decimal(18,2) DEFAULT NULL,
  `totals_total` decimal(18,2) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `permit_objid` varchar(50) DEFAULT NULL,
  `parentapplicationid` varchar(50) DEFAULT NULL,
  `nextbilldate` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_appno` (`appno`),
  KEY `ix_business_objid` (`business_objid`),
  KEY `ix_state` (`state`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_ownername` (`ownername`),
  KEY `ix_owneraddress` (`owneraddress`),
  KEY `ix_tradename` (`tradename`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_appyear` (`appyear`),
  KEY `ix_businessaddress` (`businessaddress`),
  KEY `ix_assessor_objid` (`assessor_objid`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_approver_objid` (`approver_objid`),
  KEY `ix_dtreleased` (`dtreleased`),
  KEY `ix_permit_objid` (`permit_objid`),
  KEY `ix_parentapplicationid` (`parentapplicationid`),
  KEY `ix_nextbilldate` (`nextbilldate`),
  CONSTRAINT `FK_business_application_business` FOREIGN KEY (`business_objid`) REFERENCES `business` (`objid`),
  CONSTRAINT `FK_business_application_parent` FOREIGN KEY (`parentapplicationid`) REFERENCES `business_application` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_application_info` */

DROP TABLE IF EXISTS `business_application_info`;

CREATE TABLE `business_application_info` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `businessid` varchar(50) NOT NULL,
  `applicationid` varchar(50) DEFAULT NULL,
  `activeyear` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `attribute_objid` varchar(50) NOT NULL,
  `attribute_name` varchar(50) NOT NULL,
  `lob_objid` varchar(50) DEFAULT NULL,
  `lob_name` varchar(100) DEFAULT NULL,
  `decimalvalue` decimal(16,2) DEFAULT NULL,
  `intvalue` int(11) DEFAULT NULL,
  `stringvalue` varchar(255) DEFAULT NULL,
  `boolvalue` int(11) DEFAULT NULL,
  `phase` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_applicationid` (`applicationid`),
  KEY `ix_activeyear` (`activeyear`),
  KEY `ix_attribute_objid` (`attribute_objid`),
  KEY `ix_lob_objid` (`lob_objid`),
  CONSTRAINT `FK_business_info_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`),
  CONSTRAINT `FK_business_info_business_application` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `FK_business_info_business_lob` FOREIGN KEY (`lob_objid`) REFERENCES `lob` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_application_lob` */

DROP TABLE IF EXISTS `business_application_lob`;

CREATE TABLE `business_application_lob` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) NOT NULL,
  `applicationid` varchar(50) DEFAULT NULL,
  `activeyear` int(11) NOT NULL,
  `lobid` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `assessmenttype` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_applicationid` (`applicationid`),
  KEY `ix_activeyear` (`activeyear`),
  KEY `ix_lobid` (`lobid`),
  KEY `ix_name` (`name`),
  CONSTRAINT `fk_business_application_lob_application` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `fk_business_application_lob_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`),
  CONSTRAINT `fk_business_application_lob_lob` FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_application_task` */

DROP TABLE IF EXISTS `business_application_task`;

CREATE TABLE `business_application_task` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `refid` varchar(50) DEFAULT NULL,
  `parentprocessid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_parentprocessid` (`parentprocessid`),
  KEY `ix_startdate` (`startdate`),
  KEY `ix_enddate` (`enddate`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  KEY `ix_actor_objid` (`actor_objid`),
  CONSTRAINT `fk_business_application_task_application` FOREIGN KEY (`refid`) REFERENCES `business_application` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_application_workitem` */

DROP TABLE IF EXISTS `business_application_workitem`;

CREATE TABLE `business_application_workitem` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `refid` varchar(50) DEFAULT NULL,
  `taskid` varchar(50) DEFAULT NULL,
  `workitemid` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_taskid` (`taskid`),
  KEY `ix_workitemid` (`workitemid`),
  KEY `ix_startdate` (`startdate`),
  KEY `ix_enddate` (`enddate`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  KEY `ix_actor_objid` (`actor_objid`),
  CONSTRAINT `fk_business_application_workitem_task` FOREIGN KEY (`taskid`) REFERENCES `business_application_task` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_billing` */

DROP TABLE IF EXISTS `business_billing`;

CREATE TABLE `business_billing` (
  `objid` varchar(50) NOT NULL,
  `applicationid` varchar(50) DEFAULT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `billdate` datetime DEFAULT NULL,
  `apptype` varchar(50) DEFAULT NULL,
  `appyear` int(11) DEFAULT NULL,
  `expirydate` datetime DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `surcharge` decimal(18,2) DEFAULT NULL,
  `interest` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_applicationid` (`applicationid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_billdate` (`billdate`),
  KEY `ix_appyear` (`appyear`),
  KEY `ix_expirydate` (`expirydate`),
  CONSTRAINT `FK_business_billing_applicationid` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `FK_business_billing_businessid` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_billing_item` */

DROP TABLE IF EXISTS `business_billing_item`;

CREATE TABLE `business_billing_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `receivableid` varchar(50) DEFAULT NULL,
  `account_objid` varchar(50) DEFAULT NULL,
  `account_title` varchar(255) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `duedate` datetime DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `surcharge` decimal(18,2) DEFAULT NULL,
  `interest` decimal(18,2) DEFAULT NULL,
  `discount` decimal(18,2) DEFAULT NULL,
  `lob_objid` varchar(50) DEFAULT NULL,
  `lob_assessmenttype` varchar(50) DEFAULT NULL,
  `taxfeetype` varchar(50) DEFAULT NULL,
  `paypriority` int(11) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_receivableid` (`receivableid`),
  KEY `ix_account_objid` (`account_objid`),
  KEY `ix_duedate` (`duedate`),
  KEY `ix_lob_objid` (`lob_objid`),
  CONSTRAINT `fk_business_billing_item_parent` FOREIGN KEY (`parentid`) REFERENCES `business_billing` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_billitem_txntype` */

DROP TABLE IF EXISTS `business_billitem_txntype`;

CREATE TABLE `business_billitem_txntype` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `feetype` varchar(50) DEFAULT NULL,
  `domain` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_change_log` */

DROP TABLE IF EXISTS `business_change_log`;

CREATE TABLE `business_change_log` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) NOT NULL,
  `applicationid` varchar(50) NOT NULL,
  `entryno` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(100) NOT NULL,
  `changetype` varchar(50) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `particulars` text,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_applicationid` (`applicationid`),
  KEY `ix_entryno` (`entryno`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_filedby_objid` (`filedby_objid`),
  CONSTRAINT `FK_business_change_log_applicationid` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `FK_business_change_log_businessid` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_compromise` */

DROP TABLE IF EXISTS `business_compromise`;

CREATE TABLE `business_compromise` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `approver_objid` varchar(50) DEFAULT NULL,
  `approver_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_dtexpiry` (`dtexpiry`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_approver_objid` (`approver_objid`),
  CONSTRAINT `fk_business_compromise_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_lessor` */

DROP TABLE IF EXISTS `business_lessor`;

CREATE TABLE `business_lessor` (
  `objid` varchar(50) NOT NULL,
  `government` int(11) DEFAULT NULL,
  `lessor_orgtype` varchar(50) DEFAULT NULL,
  `lessor_objid` varchar(50) DEFAULT NULL,
  `lessor_name` varchar(100) DEFAULT NULL,
  `lessor_address_text` varchar(255) DEFAULT NULL,
  `lessor_address_objid` varchar(50) DEFAULT NULL,
  `bldgno` varchar(50) DEFAULT NULL,
  `bldgname` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `subdivision` varchar(100) DEFAULT NULL,
  `barangay_objid` varchar(50) DEFAULT NULL,
  `barangay_name` varchar(100) DEFAULT NULL,
  `pin` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_lessor_objid` (`lessor_objid`),
  KEY `ix_lessor_address_objid` (`lessor_address_objid`),
  KEY `ix_bldgno` (`bldgno`),
  KEY `ix_bldgname` (`bldgname`),
  KEY `ix_barangay_objid` (`barangay_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_payment` */

DROP TABLE IF EXISTS `business_payment`;

CREATE TABLE `business_payment` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `appyear` int(11) DEFAULT NULL,
  `applicationid` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `voided` int(11) DEFAULT NULL,
  `paymentmode` varchar(50) DEFAULT NULL,
  `taxcredit` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_appyear` (`appyear`),
  KEY `ix_applicationid` (`applicationid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_refdate` (`refdate`),
  CONSTRAINT `fk_business_payment_application` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `fk_business_payment_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_payment_item` */

DROP TABLE IF EXISTS `business_payment_item`;

CREATE TABLE `business_payment_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `receivableid` varchar(50) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `discount` decimal(16,2) DEFAULT NULL,
  `account_objid` varchar(50) DEFAULT NULL,
  `account_code` varchar(50) DEFAULT NULL,
  `account_title` varchar(100) DEFAULT NULL,
  `lob_objid` varchar(50) DEFAULT NULL,
  `lob_name` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `surcharge` decimal(16,2) DEFAULT NULL,
  `interest` decimal(16,2) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `partial` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_receivableid` (`receivableid`),
  KEY `ix_account_objid` (`account_objid`),
  KEY `ix_lob_objid` (`lob_objid`),
  CONSTRAINT `fk_business_payment_item_parent` FOREIGN KEY (`parentid`) REFERENCES `business_payment` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_permit` */

DROP TABLE IF EXISTS `business_permit`;

CREATE TABLE `business_permit` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `applicationid` varchar(50) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `permitno` varchar(20) DEFAULT NULL,
  `activeyear` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `permittype` varchar(20) DEFAULT NULL,
  `dtissued` date DEFAULT NULL,
  `issuedby_objid` varchar(50) DEFAULT NULL,
  `issuedby_name` varchar(255) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `plateno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_businessid_activeyear_version` (`businessid`,`activeyear`,`version`),
  UNIQUE KEY `uix_permitno` (`permitno`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_applicationid` (`applicationid`),
  KEY `ix_activeyear` (`activeyear`),
  KEY `ix_dtissued` (`dtissued`),
  KEY `ix_issuedby_objid` (`issuedby_objid`),
  KEY `ix_expirydate` (`expirydate`),
  KEY `ix_plateno` (`plateno`),
  CONSTRAINT `fk_business_permit_application` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `fk_business_permit_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_permit_lob` */

DROP TABLE IF EXISTS `business_permit_lob`;

CREATE TABLE `business_permit_lob` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `lobid` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_lobid` (`lobid`),
  KEY `ix_name` (`name`),
  CONSTRAINT `fk_business_permit_lob_lobid` FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`),
  CONSTRAINT `fk_business_permit_lob_parentid` FOREIGN KEY (`parentid`) REFERENCES `business_permit` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_permit_type` */

DROP TABLE IF EXISTS `business_permit_type`;

CREATE TABLE `business_permit_type` (
  `objid` varchar(10) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `options` varchar(255) DEFAULT NULL,
  `indexno` int(11) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_receivable` */

DROP TABLE IF EXISTS `business_receivable`;

CREATE TABLE `business_receivable` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `applicationid` varchar(50) DEFAULT NULL,
  `iyear` int(11) DEFAULT NULL,
  `account_objid` varchar(50) DEFAULT NULL,
  `account_title` varchar(100) DEFAULT NULL,
  `lob_objid` varchar(50) DEFAULT NULL,
  `lob_name` varchar(100) DEFAULT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `discount` decimal(16,2) NOT NULL,
  `taxcredit` decimal(16,2) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `taxfeetype` varchar(50) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `surcharge` decimal(16,2) DEFAULT NULL,
  `interest` decimal(16,2) DEFAULT NULL,
  `assessmenttype` varchar(50) DEFAULT NULL,
  `lastqtrpaid` int(11) DEFAULT NULL,
  `partial` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_applicationid` (`applicationid`),
  KEY `ix_account_objid` (`account_objid`),
  KEY `ix_lob_objid` (`lob_objid`),
  CONSTRAINT `fk_business_receivable_application` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `fk_business_receivable_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_receivable_detail` */

DROP TABLE IF EXISTS `business_receivable_detail`;

CREATE TABLE `business_receivable_detail` (
  `objid` varchar(50) NOT NULL,
  `receivableid` varchar(50) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `duedate` datetime DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `surcharge` decimal(18,2) DEFAULT NULL,
  `interest` decimal(18,2) DEFAULT NULL,
  `discount` decimal(18,2) DEFAULT NULL,
  `paypriority` int(11) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_receivableid` (`receivableid`),
  KEY `ix_duedate` (`duedate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_recurringfee` */

DROP TABLE IF EXISTS `business_recurringfee`;

CREATE TABLE `business_recurringfee` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `businessid` varchar(50) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `account_objid` varchar(50) DEFAULT NULL,
  `account_title` varchar(100) DEFAULT NULL,
  `amount` decimal(16,2) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `user_objid` varchar(50) DEFAULT NULL,
  `user_name` varchar(150) DEFAULT NULL,
  `txntypeid` varchar(50) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(100) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `modifiedby_objid` varchar(50) DEFAULT NULL,
  `modifiedby_name` varchar(100) DEFAULT NULL,
  `dtmodified` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_business_acctid` (`businessid`,`account_objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_account_objid` (`account_objid`),
  CONSTRAINT `fk_business_recurringfee_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_redflag` */

DROP TABLE IF EXISTS `business_redflag`;

CREATE TABLE `business_redflag` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `filedby_objid` varchar(50) DEFAULT NULL,
  `filedby_name` varchar(255) DEFAULT NULL,
  `resolved` int(11) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `blockaction` varchar(50) DEFAULT NULL,
  `effectivedate` date DEFAULT NULL,
  `resolvedby_objid` varchar(50) DEFAULT NULL,
  `resolvedby_name` varchar(100) DEFAULT NULL,
  `caseno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_filedby_objid` (`filedby_objid`),
  KEY `ix_effectivedate` (`effectivedate`),
  KEY `ix_resolvedby_objid` (`resolvedby_objid`),
  CONSTRAINT `fk_business_redflag_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_requirement` */

DROP TABLE IF EXISTS `business_requirement`;

CREATE TABLE `business_requirement` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `applicationid` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `issuedby` varchar(100) DEFAULT NULL,
  `dtissued` date DEFAULT NULL,
  `placeissued` varchar(100) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `status` varchar(25) DEFAULT NULL,
  `step` varchar(50) DEFAULT NULL,
  `completedby_objid` varchar(50) DEFAULT NULL,
  `completedby_name` varchar(50) DEFAULT NULL,
  `dtcompleted` datetime DEFAULT NULL,
  `completed` int(11) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_businessid` (`businessid`),
  KEY `ix_applicationid` (`applicationid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_dtissued` (`dtissued`),
  KEY `ix_completedby_objid` (`completedby_objid`),
  KEY `ix_dtcompleted` (`dtcompleted`),
  CONSTRAINT `fk_business_requirement_application` FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`),
  CONSTRAINT `fk_business_requirement_business` FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_sms` */

DROP TABLE IF EXISTS `business_sms`;

CREATE TABLE `business_sms` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `phoneno` varchar(50) DEFAULT NULL,
  `logdate` datetime DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `amtpaid` decimal(10,2) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_taxcredit` */

DROP TABLE IF EXISTS `business_taxcredit`;

CREATE TABLE `business_taxcredit` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `businessid` varchar(50) DEFAULT NULL,
  `currentlineno` int(11) DEFAULT NULL,
  `totaldr` decimal(18,2) DEFAULT NULL,
  `totalcr` decimal(18,2) DEFAULT NULL,
  `balance` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_taxcredit_item` */

DROP TABLE IF EXISTS `business_taxcredit_item`;

CREATE TABLE `business_taxcredit_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `lineno` int(11) DEFAULT NULL,
  `particulars` varchar(100) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(20) DEFAULT NULL,
  `dr` decimal(18,2) DEFAULT NULL,
  `cr` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `parentid` (`parentid`),
  CONSTRAINT `FK_business_taxcredit_detail_business_taxcredit` FOREIGN KEY (`parentid`) REFERENCES `business_taxcredit` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `business_taxincentive` */

DROP TABLE IF EXISTS `business_taxincentive`;

CREATE TABLE `business_taxincentive` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `approver_objid` varchar(50) DEFAULT NULL,
  `approver_name` varchar(255) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `businessrequirementtype` */

DROP TABLE IF EXISTS `businessrequirementtype`;

CREATE TABLE `businessrequirementtype` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `agency` varchar(50) DEFAULT NULL,
  `sortindex` int(11) DEFAULT NULL,
  `verifier` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `businessvariable` */

DROP TABLE IF EXISTS `businessvariable`;

CREATE TABLE `businessvariable` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `datatype` varchar(20) NOT NULL,
  `caption` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `arrayvalues` longtext,
  `system` int(11) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cancelannotation` */

DROP TABLE IF EXISTS `cancelannotation`;

CREATE TABLE `cancelannotation` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `txnno` varchar(10) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `annotationid` varchar(50) NOT NULL,
  `fileno` varchar(20) NOT NULL,
  `remarks` text NOT NULL,
  `orno` varchar(10) DEFAULT NULL,
  `ordate` datetime DEFAULT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `signedby` varchar(150) NOT NULL,
  `signedbytitle` varchar(50) NOT NULL,
  `dtsigned` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_cancelannotation_faasannotation` (`annotationid`),
  KEY `ix_cancelannotation_fileno` (`fileno`),
  KEY `ix_cancelannotation_txnno` (`txnno`),
  CONSTRAINT `cancelannotation_ibfk_1` FOREIGN KEY (`annotationid`) REFERENCES `faasannotation` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cancelledfaas` */

DROP TABLE IF EXISTS `cancelledfaas`;

CREATE TABLE `cancelledfaas` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `txndate` datetime NOT NULL,
  `faasid` varchar(50) NOT NULL,
  `reason_objid` varchar(50) DEFAULT NULL,
  `remarks` text,
  `online` int(11) DEFAULT NULL,
  `lguid` varchar(50) DEFAULT NULL,
  `lasttaxyear` int(11) DEFAULT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  `originlguid` varchar(50) DEFAULT NULL,
  `cancelledbytdnos` varchar(500) DEFAULT NULL,
  `cancelledbypins` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_cancelledfaas_faas` (`faasid`),
  KEY `FK_cancelledfaas_reason` (`reason_objid`),
  KEY `ix_cancelledfaas_txnno` (`txnno`),
  CONSTRAINT `cancelledfaas_ibfk_1` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `cancelledfaas_ibfk_2` FOREIGN KEY (`reason_objid`) REFERENCES `canceltdreason` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cancelledfaas_signatory` */

DROP TABLE IF EXISTS `cancelledfaas_signatory`;

CREATE TABLE `cancelledfaas_signatory` (
  `objid` varchar(50) NOT NULL,
  `taxmapper_objid` varchar(50) DEFAULT NULL,
  `taxmapper_name` varchar(100) DEFAULT NULL,
  `taxmapper_title` varchar(50) DEFAULT NULL,
  `taxmapper_dtsigned` datetime DEFAULT NULL,
  `taxmapper_taskid` varchar(50) DEFAULT NULL,
  `taxmapperchief_objid` varchar(50) DEFAULT NULL,
  `taxmapperchief_name` varchar(100) DEFAULT NULL,
  `taxmapperchief_title` varchar(50) DEFAULT NULL,
  `taxmapperchief_dtsigned` datetime DEFAULT NULL,
  `taxmapperchief_taskid` varchar(50) DEFAULT NULL,
  `appraiser_objid` varchar(50) DEFAULT NULL,
  `appraiser_name` varchar(150) DEFAULT NULL,
  `appraiser_title` varchar(50) DEFAULT NULL,
  `appraiser_dtsigned` datetime DEFAULT NULL,
  `appraiser_taskid` varchar(50) DEFAULT NULL,
  `appraiserchief_objid` varchar(50) DEFAULT NULL,
  `appraiserchief_name` varchar(100) DEFAULT NULL,
  `appraiserchief_title` varchar(50) DEFAULT NULL,
  `appraiserchief_dtsigned` datetime DEFAULT NULL,
  `appraiserchief_taskid` varchar(50) DEFAULT NULL,
  `recommender_objid` varchar(50) DEFAULT NULL,
  `recommender_name` varchar(100) DEFAULT NULL,
  `recommender_title` varchar(50) DEFAULT NULL,
  `recommender_dtsigned` datetime DEFAULT NULL,
  `recommender_taskid` varchar(50) DEFAULT NULL,
  `provtaxmapper_objid` varchar(50) DEFAULT NULL,
  `provtaxmapper_name` varchar(100) DEFAULT NULL,
  `provtaxmapper_title` varchar(50) DEFAULT NULL,
  `provtaxmapper_dtsigned` datetime DEFAULT NULL,
  `provtaxmapper_taskid` varchar(50) DEFAULT NULL,
  `provtaxmapperchief_objid` varchar(50) DEFAULT NULL,
  `provtaxmapperchief_name` varchar(100) DEFAULT NULL,
  `provtaxmapperchief_title` varchar(50) DEFAULT NULL,
  `provtaxmapperchief_dtsigned` datetime DEFAULT NULL,
  `provtaxmapperchief_taskid` varchar(50) DEFAULT NULL,
  `provappraiser_objid` varchar(50) DEFAULT NULL,
  `provappraiser_name` varchar(100) DEFAULT NULL,
  `provappraiser_title` varchar(50) DEFAULT NULL,
  `provappraiser_dtsigned` datetime DEFAULT NULL,
  `provappraiser_taskid` varchar(50) DEFAULT NULL,
  `provappraiserchief_objid` varchar(50) DEFAULT NULL,
  `provappraiserchief_name` varchar(100) DEFAULT NULL,
  `provappraiserchief_title` varchar(50) DEFAULT NULL,
  `provappraiserchief_dtsigned` datetime DEFAULT NULL,
  `provappraiserchief_taskid` varchar(50) DEFAULT NULL,
  `approver_objid` varchar(50) DEFAULT NULL,
  `approver_name` varchar(100) DEFAULT NULL,
  `approver_title` varchar(50) DEFAULT NULL,
  `approver_dtsigned` datetime DEFAULT NULL,
  `approver_taskid` varchar(50) DEFAULT NULL,
  `provapprover_objid` varchar(50) DEFAULT NULL,
  `provapprover_name` varchar(100) DEFAULT NULL,
  `provapprover_title` varchar(50) DEFAULT NULL,
  `provapprover_dtsigned` datetime DEFAULT NULL,
  `provapprover_taskid` varchar(50) DEFAULT NULL,
  `provrecommender_objid` varchar(50) DEFAULT NULL,
  `provrecommender_name` varchar(100) DEFAULT NULL,
  `provrecommender_title` varchar(50) DEFAULT NULL,
  `provrecommender_dtsigned` datetime DEFAULT NULL,
  `provrecommender_taskid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `FK_cancelledfaas_signatory_cancelled_faas` FOREIGN KEY (`objid`) REFERENCES `cancelledfaas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cancelledfaas_task` */

DROP TABLE IF EXISTS `cancelledfaas_task`;

CREATE TABLE `cancelledfaas_task` (
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
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  CONSTRAINT `FK_cancelledfaas_task_cancelledfaas` FOREIGN KEY (`refid`) REFERENCES `cancelledfaas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `canceltdreason` */

DROP TABLE IF EXISTS `canceltdreason`;

CREATE TABLE `canceltdreason` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_canceltdreason_code` (`code`),
  UNIQUE KEY `ux_canceltdreason_name` (`name`),
  KEY `ix_canceltdreason_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cash_summary` */

DROP TABLE IF EXISTS `cash_summary`;

CREATE TABLE `cash_summary` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashbook` */

DROP TABLE IF EXISTS `cashbook`;

CREATE TABLE `cashbook` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `subacct_objid` varchar(50) DEFAULT NULL,
  `subacct_name` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_code` varchar(50) DEFAULT NULL,
  `fund_title` varchar(100) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_code` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `beginbalance` decimal(16,2) DEFAULT NULL,
  `forwardbalance` decimal(16,2) DEFAULT NULL,
  `totaldr` decimal(16,2) DEFAULT NULL,
  `totalcr` decimal(16,2) DEFAULT NULL,
  `endbalance` decimal(16,2) DEFAULT NULL,
  `currentlineno` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_type_subacct_fund_org` (`type`,`subacct_objid`,`fund_objid`,`org_objid`),
  KEY `ix_subacct_objid` (`subacct_objid`),
  KEY `ix_fund_objid` (`fund_objid`),
  KEY `ix_org_objid` (`org_objid`),
  CONSTRAINT `fk_cashbook_fund` FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`),
  CONSTRAINT `fk_cashbook_org` FOREIGN KEY (`org_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `fk_cashbook_subacct` FOREIGN KEY (`subacct_objid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashbook_entry` */

DROP TABLE IF EXISTS `cashbook_entry`;

CREATE TABLE `cashbook_entry` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `refdate` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `particulars` text,
  `dr` decimal(16,2) DEFAULT NULL,
  `cr` decimal(16,2) DEFAULT NULL,
  `runbalance` decimal(16,2) DEFAULT NULL,
  `lineno` int(11) DEFAULT NULL,
  `postingrefid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `fk_cashbook_entry_parentid` FOREIGN KEY (`parentid`) REFERENCES `cashbook` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashbook_treasury` */

DROP TABLE IF EXISTS `cashbook_treasury`;

CREATE TABLE `cashbook_treasury` (
  `objid` varchar(100) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_code` (`code`),
  KEY `ix_title` (`title`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_fundid` (`fundid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt` */

DROP TABLE IF EXISTS `cashreceipt`;

CREATE TABLE `cashreceipt` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `txndate` datetime NOT NULL,
  `receiptno` varchar(50) NOT NULL,
  `receiptdate` datetime NOT NULL,
  `txnmode` varchar(10) NOT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(100) NOT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `collector_objid` varchar(50) NOT NULL,
  `collector_name` varchar(100) NOT NULL,
  `collector_title` varchar(50) NOT NULL,
  `totalcash` decimal(16,4) DEFAULT NULL,
  `totalnoncash` decimal(16,4) DEFAULT NULL,
  `cashchange` decimal(16,2) NOT NULL,
  `totalcredit` decimal(16,2) NOT NULL,
  `org_objid` varchar(50) NOT NULL,
  `org_name` varchar(50) NOT NULL,
  `formno` varchar(50) NOT NULL,
  `series` int(11) NOT NULL,
  `controlid` varchar(50) NOT NULL,
  `collectiontype_objid` varchar(50) DEFAULT NULL,
  `collectiontype_name` varchar(100) DEFAULT NULL,
  `user_objid` varchar(50) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `subcollector_objid` varchar(50) DEFAULT NULL,
  `subcollector_name` varchar(100) DEFAULT NULL,
  `subcollector_title` varchar(50) DEFAULT NULL,
  `formtype` varchar(25) DEFAULT NULL,
  `stub` varchar(25) DEFAULT NULL,
  `remittanceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_receiptno` (`receiptno`),
  KEY `ix_state` (`state`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_receiptdate` (`receiptdate`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_collectorid` (`collector_objid`),
  KEY `ix_collectorname` (`collector_name`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_formno` (`formno`),
  KEY `ix_controlid` (`controlid`),
  KEY `ix_collectiontype_objid` (`collectiontype_objid`),
  KEY `ix_user_objid` (`user_objid`),
  KEY `ix_subcollector_objid` (`subcollector_objid`),
  KEY `ix_remittanceid` (`remittanceid`),
  CONSTRAINT `fk_cashreceipt_collectiontype` FOREIGN KEY (`collectiontype_objid`) REFERENCES `collectiontype` (`objid`),
  CONSTRAINT `fk_cashreceipt_collector` FOREIGN KEY (`collector_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `fk_cashreceipt_remittanceid` FOREIGN KEY (`remittanceid`) REFERENCES `remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_burial` */

DROP TABLE IF EXISTS `cashreceipt_burial`;

CREATE TABLE `cashreceipt_burial` (
  `objid` varchar(50) NOT NULL,
  `tocitymuni` varchar(100) DEFAULT NULL,
  `toprovince` varchar(100) DEFAULT NULL,
  `permissiontype` varchar(15) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `nationality` varchar(15) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `dtdeath` varchar(15) DEFAULT NULL,
  `deathcause` varchar(50) DEFAULT NULL,
  `cemetery` varchar(50) DEFAULT NULL,
  `infectious` varchar(50) DEFAULT NULL,
  `embalmed` varchar(50) DEFAULT NULL,
  `disposition` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_cancelseries` */

DROP TABLE IF EXISTS `cashreceipt_cancelseries`;

CREATE TABLE `cashreceipt_cancelseries` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(100) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `controlid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_receiptid` (`receiptid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  KEY `ix_controlid` (`controlid`),
  CONSTRAINT `fk_cashreceipt_cancelseries_receiptid` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_cashticket` */

DROP TABLE IF EXISTS `cashreceipt_cashticket`;

CREATE TABLE `cashreceipt_cashticket` (
  `objid` varchar(50) NOT NULL,
  `qtyissued` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_cashreceipt_cashticket_objid` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_ctc_corporate` */

DROP TABLE IF EXISTS `cashreceipt_ctc_corporate`;

CREATE TABLE `cashreceipt_ctc_corporate` (
  `objid` varchar(50) NOT NULL,
  `payer_tin` varchar(50) DEFAULT NULL,
  `payer_orgtype` varchar(50) DEFAULT NULL,
  `payer_nature` varchar(50) DEFAULT NULL,
  `payer_dtregistered` datetime DEFAULT NULL,
  `payer_placeregistered` varchar(100) DEFAULT NULL,
  `additional_remarks` varchar(100) DEFAULT NULL,
  `realpropertyav` decimal(16,2) NOT NULL,
  `businessgross` decimal(16,2) NOT NULL,
  `basictax` decimal(16,2) NOT NULL,
  `propertyavtax` decimal(16,2) NOT NULL,
  `businessgrosstax` decimal(16,2) NOT NULL,
  `totaltax` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `amountdue` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_cashreceipt_ctc_corporate_cashreceipt` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_ctc_individual` */

DROP TABLE IF EXISTS `cashreceipt_ctc_individual`;

CREATE TABLE `cashreceipt_ctc_individual` (
  `objid` varchar(50) NOT NULL,
  `payer_profession` varchar(50) DEFAULT NULL,
  `payer_citizenship` varchar(50) DEFAULT NULL,
  `payer_civilstatus` varchar(25) DEFAULT NULL,
  `payer_height` varchar(25) DEFAULT NULL,
  `payer_weight` varchar(25) DEFAULT NULL,
  `additional_remarks` varchar(100) DEFAULT NULL,
  `businessgross` decimal(16,2) NOT NULL,
  `annualsalary` decimal(16,2) NOT NULL,
  `propertyincome` decimal(16,2) NOT NULL,
  `basictax` decimal(16,2) NOT NULL,
  `salarytax` decimal(16,2) NOT NULL,
  `businessgrosstax` decimal(16,2) NOT NULL,
  `propertyincometax` decimal(16,2) NOT NULL,
  `additionaltax` decimal(16,2) NOT NULL,
  `totaltax` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `amountdue` decimal(16,2) NOT NULL,
  `interestdue` decimal(16,2) NOT NULL,
  `barangay_objid` varchar(50) DEFAULT NULL,
  `barangay_name` varchar(50) DEFAULT NULL,
  `brgytaxshare` decimal(16,2) NOT NULL,
  `brgyinterestshare` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_cashreceipt_ctc_individual_cashreceipt` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_largecattleownership` */

DROP TABLE IF EXISTS `cashreceipt_largecattleownership`;

CREATE TABLE `cashreceipt_largecattleownership` (
  `objid` varchar(50) NOT NULL,
  `ownerof` varchar(200) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `municipalitybrand` varchar(20) DEFAULT NULL,
  `ownerbrand` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_cashreceipt_largecattleownership_cashreceipt` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_largecattletransfer` */

DROP TABLE IF EXISTS `cashreceipt_largecattletransfer`;

CREATE TABLE `cashreceipt_largecattletransfer` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `purchasedby` varchar(200) DEFAULT NULL,
  `price` decimal(16,2) DEFAULT NULL,
  `citymuni` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `municipalitybrand` varchar(20) DEFAULT NULL,
  `ownerbrand` varchar(20) DEFAULT NULL,
  `certificateno` varchar(30) DEFAULT NULL,
  `issuedate` date DEFAULT NULL,
  `issuedcitymuni` varchar(100) DEFAULT NULL,
  `issuedprovince` varchar(100) DEFAULT NULL,
  `attestedby` varchar(100) DEFAULT NULL,
  `treasurer` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_cashreceipt_largecattletransfer_cashreceipt` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_marriage` */

DROP TABLE IF EXISTS `cashreceipt_marriage`;

CREATE TABLE `cashreceipt_marriage` (
  `objid` varchar(50) NOT NULL,
  `groomname` varchar(100) DEFAULT NULL,
  `groomaddress` varchar(100) DEFAULT NULL,
  `groomageyear` int(11) DEFAULT NULL,
  `groomagemonth` int(11) DEFAULT NULL,
  `bridename` varchar(100) DEFAULT NULL,
  `brideaddress` varchar(100) DEFAULT NULL,
  `brideageyear` int(11) DEFAULT NULL,
  `brideagemonth` int(11) DEFAULT NULL,
  `registerno` varchar(30) DEFAULT NULL,
  `attachments` varchar(200) DEFAULT NULL,
  `lcrofficer` varchar(100) DEFAULT NULL,
  `lcrofficertitle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_cashreceipt_marriage_cashreceipt` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_rpt` */

DROP TABLE IF EXISTS `cashreceipt_rpt`;

CREATE TABLE `cashreceipt_rpt` (
  `objid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `day` int(11) NOT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `cashreceipt_rpt_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_share` */

DROP TABLE IF EXISTS `cashreceipt_share`;

CREATE TABLE `cashreceipt_share` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `refacctid` varchar(50) DEFAULT NULL,
  `payableacctid` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `share` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_slaughter` */

DROP TABLE IF EXISTS `cashreceipt_slaughter`;

CREATE TABLE `cashreceipt_slaughter` (
  `objid` varchar(50) NOT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `acctno` varchar(50) DEFAULT NULL,
  `acctitle` varchar(100) DEFAULT NULL,
  `permitamount` decimal(18,2) DEFAULT NULL,
  `slaughterof` varchar(25) DEFAULT NULL,
  `weight` decimal(18,2) DEFAULT NULL,
  `ordinanceno` varchar(50) DEFAULT NULL,
  `ordinancedate` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_acctno` (`acctno`),
  CONSTRAINT `fk_cashreceipt_slaughter_cashreceipt` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceipt_void` */

DROP TABLE IF EXISTS `cashreceipt_void`;

CREATE TABLE `cashreceipt_void` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `postedby_objid` varchar(50) NOT NULL,
  `postedby_name` varchar(100) NOT NULL,
  `reason` varchar(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_receiptid` (`receiptid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  CONSTRAINT `fk_cashreceipt_void_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceiptitem` */

DROP TABLE IF EXISTS `cashreceiptitem`;

CREATE TABLE `cashreceiptitem` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `item_objid` varchar(50) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `item_title` varchar(100) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `item_fund_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_receiptid` (`receiptid`),
  KEY `ix_item_objid` (`item_objid`),
  CONSTRAINT `fk_cashreceiptitem_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `fk_cashreceiptitem_itemaccount` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceiptitem_rpt_account` */

DROP TABLE IF EXISTS `cashreceiptitem_rpt_account`;

CREATE TABLE `cashreceiptitem_rpt_account` (
  `objid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) DEFAULT NULL,
  `revperiod` varchar(25) NOT NULL,
  `revtype` varchar(25) NOT NULL,
  `item_objid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `rptreceiptid` varchar(50) DEFAULT NULL,
  `sharetype` varchar(25) NOT NULL,
  `discount` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_cashreceiptitemrptaccount_cashreceiptrpt` (`rptreceiptid`),
  KEY `ix_cashreceiptitem_rpt_account_rptledger` (`rptledgerid`),
  KEY `ix_rptbillledgeraccount_revenueitem` (`item_objid`),
  CONSTRAINT `cashreceiptitem_rpt_account_ibfk_1` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `cashreceiptitem_rpt_account_ibfk_2` FOREIGN KEY (`rptreceiptid`) REFERENCES `cashreceipt_rpt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceiptitem_rpt_online` */

DROP TABLE IF EXISTS `cashreceiptitem_rpt_online`;

CREATE TABLE `cashreceiptitem_rpt_online` (
  `objid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) DEFAULT NULL,
  `rptledgerfaasid` varchar(50) DEFAULT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `fromqtr` int(11) NOT NULL,
  `toqtr` int(11) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicdisc` decimal(16,2) NOT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `sefdisc` decimal(16,2) NOT NULL,
  `firecode` decimal(10,2) DEFAULT NULL,
  `revperiod` varchar(25) DEFAULT NULL,
  `basicnet` decimal(16,2) DEFAULT NULL,
  `sefnet` decimal(16,2) DEFAULT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `rptreceiptid` varchar(50) DEFAULT NULL,
  `partialled` int(11) NOT NULL,
  `basicidle` decimal(16,2) DEFAULT '0.00',
  `rptledgeritemid` varchar(50) DEFAULT NULL,
  `basicidledisc` decimal(16,2) DEFAULT NULL,
  `basicidleint` decimal(16,2) DEFAULT NULL,
  `rptledgeritemqtrlyid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `rptreceiptid` (`rptreceiptid`),
  KEY `ix_cashreceiptitem_rpt_online_rptledger` (`rptledgerid`),
  KEY `ix_cashreceiptitem_rpt_online_rptledgerfaas` (`rptledgerfaasid`),
  KEY `ix_rptledgerbillitem_rptledgerfaasid` (`rptledgerfaasid`),
  KEY `ix_rptledgerbillitem_rptledgerid` (`rptledgerid`),
  KEY `FK_cashreceiptitem_rpt_online_rptledgeritem` (`rptledgeritemid`),
  KEY `FK_cashreceiptitem_rpt_online_rptledgeritemqtrly` (`rptledgeritemqtrlyid`),
  CONSTRAINT `cashreceiptitem_rpt_online_ibfk_1` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`),
  CONSTRAINT `cashreceiptitem_rpt_online_ibfk_2` FOREIGN KEY (`rptledgerfaasid`) REFERENCES `rptledgerfaas` (`objid`),
  CONSTRAINT `cashreceiptitem_rpt_online_ibfk_3` FOREIGN KEY (`rptreceiptid`) REFERENCES `cashreceipt_rpt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceiptpayment_creditmemo` */

DROP TABLE IF EXISTS `cashreceiptpayment_creditmemo`;

CREATE TABLE `cashreceiptpayment_creditmemo` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `account_objid` varchar(50) DEFAULT NULL,
  `account_code` varchar(100) DEFAULT NULL,
  `account_fund_name` varchar(50) DEFAULT NULL,
  `account_fund_objid` varchar(50) DEFAULT NULL,
  `account_bank` varchar(50) DEFAULT NULL,
  `refno` varchar(25) DEFAULT NULL,
  `refdate` datetime DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_receiptid` (`receiptid`),
  KEY `ix_account_objid` (`account_objid`),
  KEY `ix_account_fund_objid` (`account_fund_objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_refdate` (`refdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cashreceiptpayment_noncash` */

DROP TABLE IF EXISTS `cashreceiptpayment_noncash`;

CREATE TABLE `cashreceiptpayment_noncash` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(25) DEFAULT NULL,
  `refdate` datetime DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  `bankid` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_refid_fundid` (`refid`,`fund_objid`),
  KEY `ix_receiptid` (`receiptid`),
  KEY `ix_bankid` (`bankid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_refdate` (`refdate`),
  CONSTRAINT `fk_cashreceiptpayment_noncash_bank` FOREIGN KEY (`bankid`) REFERENCES `bank` (`objid`),
  CONSTRAINT `fk_cashreceiptpayment_noncash_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `certification` */

DROP TABLE IF EXISTS `certification`;

CREATE TABLE `certification` (
  `objid` varchar(50) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime NOT NULL,
  `type` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `address` text NOT NULL,
  `requestedby` longtext NOT NULL,
  `requestedbyaddress` varchar(100) NOT NULL,
  `purpose` text,
  `certifiedby` varchar(150) NOT NULL,
  `certifiedbytitle` varchar(50) NOT NULL,
  `byauthority` varchar(150) DEFAULT NULL,
  `byauthoritytitle` varchar(50) DEFAULT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` datetime DEFAULT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `stampamount` decimal(16,2) NOT NULL,
  `createdbyid` varchar(50) DEFAULT NULL,
  `createdby` varchar(150) NOT NULL,
  `createdbytitle` varchar(50) NOT NULL,
  `office` varchar(50) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `citizenship` */

DROP TABLE IF EXISTS `citizenship`;

CREATE TABLE `citizenship` (
  `objid` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `city` */

DROP TABLE IF EXISTS `city`;

CREATE TABLE `city` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `indexno` varchar(15) DEFAULT NULL,
  `pin` varchar(15) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `mayor_name` varchar(100) DEFAULT NULL,
  `mayor_title` varchar(50) DEFAULT NULL,
  `mayor_office` varchar(50) DEFAULT NULL,
  `assessor_name` varchar(100) DEFAULT NULL,
  `assessor_title` varchar(50) DEFAULT NULL,
  `assessor_office` varchar(50) DEFAULT NULL,
  `treasurer_name` varchar(100) DEFAULT NULL,
  `treasurer_title` varchar(50) DEFAULT NULL,
  `treasurer_office` varchar(50) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `fullname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_indexno` (`indexno`),
  KEY `ix_pin` (`pin`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `fk_city_org` FOREIGN KEY (`objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `collectiongroup` */

DROP TABLE IF EXISTS `collectiongroup`;

CREATE TABLE `collectiongroup` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(30) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `afno` varchar(50) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(150) DEFAULT NULL,
  `sharing` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_afno` (`afno`),
  KEY `ix_org_objid` (`org_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `collectiongroup_revenueitem` */

DROP TABLE IF EXISTS `collectiongroup_revenueitem`;

CREATE TABLE `collectiongroup_revenueitem` (
  `collectiongroupid` varchar(50) NOT NULL,
  `revenueitemid` varchar(50) NOT NULL,
  `orderno` int(11) DEFAULT NULL,
  `valuetype` varchar(50) DEFAULT NULL,
  `defaultvalue` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`collectiongroupid`,`revenueitemid`),
  KEY `ix_revenueitemid` (`revenueitemid`),
  CONSTRAINT `fk_collectiongroup_revenueitem_collectiongroup` FOREIGN KEY (`collectiongroupid`) REFERENCES `collectiongroup` (`objid`),
  CONSTRAINT `fk_collectiongroup_revenueitem_itemaccount` FOREIGN KEY (`revenueitemid`) REFERENCES `itemaccount` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `collectiontype` */

DROP TABLE IF EXISTS `collectiontype`;

CREATE TABLE `collectiontype` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `formno` varchar(10) DEFAULT NULL,
  `handler` varchar(25) DEFAULT NULL,
  `allowbatch` int(11) DEFAULT NULL,
  `barcodekey` varchar(100) DEFAULT NULL,
  `allowonline` int(11) DEFAULT '0',
  `allowoffline` int(11) DEFAULT NULL,
  `sortorder` int(11) DEFAULT '0',
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_title` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `queuesection` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`),
  KEY `ix_formno` (`formno`),
  KEY `ix_handler` (`handler`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_fund_objid` (`fund_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `collectiontype_account` */

DROP TABLE IF EXISTS `collectiontype_account`;

CREATE TABLE `collectiontype_account` (
  `objid` varchar(100) NOT NULL,
  `collectiontypeid` varchar(50) DEFAULT NULL,
  `account_objid` varchar(50) DEFAULT NULL,
  `account_title` varchar(100) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `defaultvalue` decimal(16,2) DEFAULT NULL,
  `valuetype` varchar(20) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_account_objid` (`account_objid`,`collectiontypeid`),
  KEY `fk_collectiontype_account_collectiontype` (`collectiontypeid`),
  CONSTRAINT `fk_collectiontype_account_collectiontype` FOREIGN KEY (`collectiontypeid`) REFERENCES `collectiontype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `collectiontype_org` */

DROP TABLE IF EXISTS `collectiontype_org`;

CREATE TABLE `collectiontype_org` (
  `objid` varchar(50) NOT NULL,
  `collectiontypeid` varchar(50) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(150) DEFAULT NULL,
  `org_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_collectiontype_org` (`collectiontypeid`,`org_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `collectionvoucher` */

DROP TABLE IF EXISTS `collectionvoucher`;

CREATE TABLE `collectionvoucher` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `controlno` varchar(50) NOT NULL,
  `controldate` date NOT NULL,
  `dtposted` datetime NOT NULL,
  `liquidatingofficer_objid` varchar(50) DEFAULT NULL,
  `liquidatingofficer_name` varchar(100) DEFAULT NULL,
  `liquidatingofficer_title` varchar(50) DEFAULT NULL,
  `liquidatingofficer_signature` longtext,
  `amount` decimal(18,2) DEFAULT NULL,
  `totalcash` decimal(18,2) DEFAULT NULL,
  `totalcheck` decimal(16,4) DEFAULT NULL,
  `cashbreakdown` text,
  `totalcr` decimal(16,4) DEFAULT NULL,
  `depositvoucherid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_txnno` (`controlno`),
  KEY `ix_state` (`state`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_liquidatingofficer_objid` (`liquidatingofficer_objid`),
  KEY `ix_liquidatingofficer_name` (`liquidatingofficer_name`),
  KEY `fk_collectionvoucher_depositvoucher` (`depositvoucherid`),
  CONSTRAINT `fk_collectionvoucher_depositvoucher` FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`),
  CONSTRAINT `fk_liquidation_officer` FOREIGN KEY (`liquidatingofficer_objid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `collectionvoucher_fund` */

DROP TABLE IF EXISTS `collectionvoucher_fund`;

CREATE TABLE `collectionvoucher_fund` (
  `objid` varchar(255) NOT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_title` varchar(100) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `totalcash` decimal(16,4) DEFAULT NULL,
  `totalcheck` decimal(16,4) DEFAULT NULL,
  `totalcr` decimal(16,4) DEFAULT NULL,
  `cashbreakdown` text,
  PRIMARY KEY (`objid`),
  KEY `ix_liquidationid` (`parentid`),
  KEY `ix_fund_objid` (`fund_objid`),
  KEY `ix_objid_controlno` (`objid`,`controlno`),
  CONSTRAINT `fk_collectionvoucher_fund_fund` FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`),
  CONSTRAINT `fk_collectionvoucher_fund_parent` FOREIGN KEY (`parentid`) REFERENCES `collectionvoucher` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `consolidatedland` */

DROP TABLE IF EXISTS `consolidatedland`;

CREATE TABLE `consolidatedland` (
  `objid` varchar(50) NOT NULL,
  `consolidationid` varchar(50) NOT NULL,
  `landfaasid` varchar(50) NOT NULL,
  `rpuid` varchar(50) NOT NULL,
  `rpid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_consolidatedland_consolidation` (`consolidationid`),
  KEY `FK_consolidatedland_faas` (`landfaasid`),
  CONSTRAINT `consolidatedland_ibfk_1` FOREIGN KEY (`consolidationid`) REFERENCES `consolidation` (`objid`),
  CONSTRAINT `consolidatedland_ibfk_2` FOREIGN KEY (`landfaasid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `consolidation` */

DROP TABLE IF EXISTS `consolidation`;

CREATE TABLE `consolidation` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `ry` int(11) NOT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `autonumber` int(11) DEFAULT NULL,
  `effectivityyear` int(11) DEFAULT NULL,
  `effectivityqtr` int(11) DEFAULT NULL,
  `newtdno` varchar(50) DEFAULT NULL,
  `newutdno` varchar(50) DEFAULT NULL,
  `newtitletype` varchar(50) DEFAULT NULL,
  `newtitleno` varchar(50) DEFAULT NULL,
  `newtitledate` varchar(50) DEFAULT NULL,
  `memoranda` text,
  `lguid` varchar(50) DEFAULT NULL,
  `lgutype` varchar(50) DEFAULT NULL,
  `newrpid` varchar(50) DEFAULT NULL,
  `newrpuid` varchar(50) DEFAULT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `taxpayer_name` text,
  `taxpayer_address` varchar(200) DEFAULT NULL,
  `owner_name` text,
  `owner_address` varchar(200) DEFAULT NULL,
  `administrator_objid` varchar(50) DEFAULT NULL,
  `administrator_name` varchar(500) DEFAULT NULL,
  `administrator_address` varchar(200) DEFAULT NULL,
  `administratorid` varchar(50) DEFAULT NULL,
  `administratorname` varchar(500) DEFAULT NULL,
  `administratoraddress` varchar(200) DEFAULT NULL,
  `signatories` varchar(500) DEFAULT NULL,
  `originlguid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_consolidation_newfaas` (`newfaasid`),
  KEY `FK_consolidation_newrp` (`newrpid`),
  KEY `FK_consolidation_newrpu` (`newrpuid`),
  KEY `ix_consolidation_newtdno` (`newtdno`),
  KEY `txntype_objid` (`txntype_objid`),
  CONSTRAINT `consolidation_ibfk_1` FOREIGN KEY (`newfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `consolidation_ibfk_2` FOREIGN KEY (`newrpid`) REFERENCES `realproperty` (`objid`),
  CONSTRAINT `consolidation_ibfk_3` FOREIGN KEY (`newrpuid`) REFERENCES `rpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `consolidation_task` */

DROP TABLE IF EXISTS `consolidation_task`;

CREATE TABLE `consolidation_task` (
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
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_assignee_objid` (`assignee_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `consolidationaffectedrpu` */

DROP TABLE IF EXISTS `consolidationaffectedrpu`;

CREATE TABLE `consolidationaffectedrpu` (
  `objid` varchar(50) NOT NULL,
  `consolidationid` varchar(50) NOT NULL,
  `landfaasid` varchar(50) NOT NULL,
  `prevfaasid` varchar(50) NOT NULL,
  `newrpid` varchar(50) NOT NULL,
  `newrpuid` varchar(50) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `newtdno` varchar(50) DEFAULT NULL,
  `newutdno` varchar(50) DEFAULT NULL,
  `newsuffix` int(11) DEFAULT NULL,
  `memoranda` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_consolidationaffectedrpu_consolidation` (`consolidationid`),
  KEY `FK_consolidationaffectedrpu_newfaas` (`newfaasid`),
  KEY `FK_consolidationaffectedrpu_newrpu` (`newrpuid`),
  KEY `FK_consolidationaffectedrpu_prevfaas` (`prevfaasid`),
  KEY `ix_consolidationaffectedrpu_landfaasid` (`landfaasid`),
  KEY `ix_consolidationaffectedrpu_newtdno` (`newtdno`),
  KEY `newrpid` (`newrpid`),
  CONSTRAINT `consolidationaffectedrpu_ibfk_1` FOREIGN KEY (`consolidationid`) REFERENCES `consolidation` (`objid`),
  CONSTRAINT `consolidationaffectedrpu_ibfk_2` FOREIGN KEY (`newfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `consolidationaffectedrpu_ibfk_3` FOREIGN KEY (`newrpuid`) REFERENCES `rpu` (`objid`),
  CONSTRAINT `consolidationaffectedrpu_ibfk_4` FOREIGN KEY (`prevfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `consolidationaffectedrpu_ibfk_5` FOREIGN KEY (`newrpid`) REFERENCES `realproperty` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `creditmemo` */

DROP TABLE IF EXISTS `creditmemo`;

CREATE TABLE `creditmemo` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refdate` date NOT NULL,
  `refno` varchar(25) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `particulars` varchar(250) DEFAULT NULL,
  `bankaccount_objid` varchar(50) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` varchar(150) DEFAULT NULL,
  `payer_address_text` varchar(255) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `receiptno` varchar(50) DEFAULT NULL,
  `receiptdate` date DEFAULT NULL,
  `dtissued` date DEFAULT NULL,
  `issuedby_objid` varchar(50) DEFAULT NULL,
  `issuedby_name` varchar(150) DEFAULT NULL,
  `issuereceipt` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_bankaccount_objid` (`bankaccount_objid`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_controlno` (`controlno`),
  KEY `ix_receiptid` (`receiptid`),
  KEY `ix_receiptno` (`receiptno`),
  KEY `ix_dtissued` (`dtissued`),
  KEY `ix_issuedby_objid` (`issuedby_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `creditmemoitem` */

DROP TABLE IF EXISTS `creditmemoitem`;

CREATE TABLE `creditmemoitem` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `item_objid` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_item_objid` (`item_objid`),
  CONSTRAINT `fk_creditmemoitem_itemaccount` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `fk_creditmemoitem_parent` FOREIGN KEY (`parentid`) REFERENCES `creditmemo` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `creditmemotype` */

DROP TABLE IF EXISTS `creditmemotype`;

CREATE TABLE `creditmemotype` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `issuereceipt` int(11) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_code` varchar(50) DEFAULT NULL,
  `fund_title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_fund_objid` (`fund_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `creditmemotype_account` */

DROP TABLE IF EXISTS `creditmemotype_account`;

CREATE TABLE `creditmemotype_account` (
  `typeid` varchar(50) NOT NULL,
  `account_objid` varchar(50) NOT NULL,
  `account_title` varchar(100) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`typeid`,`account_objid`),
  KEY `ix_account_objid` (`account_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ctc_individual_view` */

DROP TABLE IF EXISTS `ctc_individual_view`;

CREATE TABLE `ctc_individual_view` (
  `objid` varchar(50) NOT NULL,
  `payer_profession` varchar(50) DEFAULT NULL,
  `payer_citizenship` varchar(50) DEFAULT NULL,
  `payer_civilstatus` varchar(25) DEFAULT NULL,
  `payer_height` varchar(25) DEFAULT NULL,
  `payer_weight` varchar(25) DEFAULT NULL,
  `additional_remarks` varchar(100) DEFAULT NULL,
  `businessgross` decimal(16,2) NOT NULL,
  `annualsalary` decimal(16,2) NOT NULL,
  `propertyincome` decimal(16,2) NOT NULL,
  `basictax` decimal(16,2) NOT NULL,
  `salarytax` decimal(16,2) NOT NULL,
  `businessgrosstax` decimal(16,2) NOT NULL,
  `propertyincometax` decimal(16,2) NOT NULL,
  `additionaltax` decimal(16,2) NOT NULL,
  `totaltax` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `amountdue` decimal(16,2) NOT NULL,
  `interestdue` decimal(16,2) NOT NULL,
  `barangay_objid` varchar(50) DEFAULT NULL,
  `barangay_name` varchar(50) DEFAULT NULL,
  `brgytaxshare` decimal(16,2) NOT NULL,
  `brgyinterestshare` decimal(16,2) NOT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` text,
  `payer_lastname` varchar(100) DEFAULT NULL,
  `payer_firstname` varchar(100) DEFAULT NULL,
  `payer_middlename` varchar(100) DEFAULT NULL,
  `receiptno` varchar(50) NOT NULL,
  `receiptdate` datetime NOT NULL,
  `receiptyear` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `deposit_fund_transfer` */

DROP TABLE IF EXISTS `deposit_fund_transfer`;

CREATE TABLE `deposit_fund_transfer` (
  `objid` varchar(150) NOT NULL,
  `depositid` varchar(50) DEFAULT NULL,
  `fromfundid` varchar(50) NOT NULL,
  `tofundid` varchar(50) NOT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `amtused` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_deposit_fund_trasnfer_deposit` (`depositid`),
  CONSTRAINT `fk_deposit_fund_trasnfer_deposit` FOREIGN KEY (`depositid`) REFERENCES `depositvoucher` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `depositslip` */

DROP TABLE IF EXISTS `depositslip`;

CREATE TABLE `depositslip` (
  `objid` varchar(50) NOT NULL,
  `depositvoucherid` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `depositdate` date DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `bankacctid` varchar(50) DEFAULT NULL,
  `totalcash` decimal(16,4) DEFAULT NULL,
  `totalcheck` decimal(16,4) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `validation_refno` varchar(50) DEFAULT NULL,
  `validation_refdate` date DEFAULT NULL,
  `cashbreakdown` text,
  PRIMARY KEY (`objid`),
  KEY `fk_depositslip_depositvoucherid` (`depositvoucherid`),
  CONSTRAINT `fk_depositslip_depositvoucherid` FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `depositvoucher` */

DROP TABLE IF EXISTS `depositvoucher`;

CREATE TABLE `depositvoucher` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `controldate` date DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `depositvoucher_fund` */

DROP TABLE IF EXISTS `depositvoucher_fund`;

CREATE TABLE `depositvoucher_fund` (
  `objid` varchar(150) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `totalcash` decimal(16,4) DEFAULT NULL,
  `totalcheck` decimal(16,4) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `cashtodeposit` decimal(16,4) DEFAULT NULL,
  `checktodeposit` decimal(16,4) DEFAULT NULL,
  `cashier_objid` varchar(50) DEFAULT NULL,
  `cashier_name` varchar(255) DEFAULT NULL,
  `cashier_title` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_depositvoucher_fund_depositvoucher` (`parentid`),
  KEY `fk_depositvoucher_fund_fund` (`fundid`),
  CONSTRAINT `fk_depositvoucher_fund_depositvoucher` FOREIGN KEY (`parentid`) REFERENCES `depositvoucher` (`objid`),
  CONSTRAINT `fk_depositvoucher_fund_fund` FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `discounttype` */

DROP TABLE IF EXISTS `discounttype`;

CREATE TABLE `discounttype` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `rate` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `district` */

DROP TABLE IF EXISTS `district`;

CREATE TABLE `district` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `indexno` varchar(15) DEFAULT NULL,
  `pin` varchar(15) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `oldindexno` varchar(15) DEFAULT NULL,
  `oldpin` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_indexno` (`indexno`),
  KEY `ix_pin` (`pin`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_previd` (`previd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `draft_remittance` */

DROP TABLE IF EXISTS `draft_remittance`;

CREATE TABLE `draft_remittance` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `remittancedate` date NOT NULL,
  `collector_objid` varchar(50) NOT NULL,
  `collector_name` varchar(255) NOT NULL,
  `collector_title` varchar(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_remittancedate` (`remittancedate`),
  KEY `ix_collector_objid` (`collector_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `draft_remittance_cashreceipt` */

DROP TABLE IF EXISTS `draft_remittance_cashreceipt`;

CREATE TABLE `draft_remittance_cashreceipt` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `controlid` varchar(50) NOT NULL,
  `batchid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_controlid` (`controlid`),
  KEY `ix_batchid` (`batchid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entity` */

DROP TABLE IF EXISTS `entity`;

CREATE TABLE `entity` (
  `objid` varchar(50) NOT NULL,
  `entityno` varchar(50) NOT NULL,
  `name` longtext NOT NULL,
  `address_text` varchar(255) NOT NULL DEFAULT '',
  `mailingaddress` varchar(255) DEFAULT NULL,
  `type` varchar(25) NOT NULL,
  `sys_lastupdate` varchar(25) DEFAULT NULL,
  `sys_lastupdateby` varchar(50) DEFAULT NULL,
  `remarks` text,
  `entityname` varchar(300) DEFAULT NULL,
  `address_objid` varchar(50) DEFAULT NULL,
  `mobileno` varchar(25) DEFAULT NULL,
  `phoneno` varchar(25) DEFAULT NULL,
  `email` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_entityno` (`entityno`),
  KEY `ix_entityname` (`entityname`(255)),
  KEY `ix_address_objid` (`address_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entity_address` */

DROP TABLE IF EXISTS `entity_address`;

CREATE TABLE `entity_address` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `parentid` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `addresstype` varchar(50) DEFAULT NULL,
  `barangay_objid` varchar(50) DEFAULT NULL,
  `barangay_name` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `province` varchar(50) DEFAULT NULL,
  `municipality` varchar(50) DEFAULT NULL,
  `bldgno` varchar(50) DEFAULT NULL,
  `bldgname` varchar(50) DEFAULT NULL,
  `unitno` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `subdivision` varchar(100) DEFAULT NULL,
  `pin` varchar(50) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_barangay_objid` (`barangay_objid`),
  CONSTRAINT `fk_entity_address_parent` FOREIGN KEY (`parentid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entity_ctc` */

DROP TABLE IF EXISTS `entity_ctc`;

CREATE TABLE `entity_ctc` (
  `objid` varchar(50) NOT NULL,
  `entityid` varchar(50) DEFAULT NULL,
  `ctcno` varchar(50) DEFAULT NULL,
  `dateissued` date DEFAULT NULL,
  `placeissued` varchar(50) DEFAULT NULL,
  `activeyear` int(11) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entity_relation` */

DROP TABLE IF EXISTS `entity_relation`;

CREATE TABLE `entity_relation` (
  `objid` varchar(50) NOT NULL,
  `entity_objid` varchar(50) DEFAULT NULL,
  `relateto_objid` varchar(50) DEFAULT NULL,
  `relation` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_sender_receiver` (`entity_objid`,`relateto_objid`),
  KEY `ix_sender_objid` (`entity_objid`),
  KEY `ix_receiver_objid` (`relateto_objid`),
  CONSTRAINT `fk_entityrelation_entity_objid` FOREIGN KEY (`entity_objid`) REFERENCES `entity` (`objid`),
  CONSTRAINT `fk_entityrelation_relateto_objid` FOREIGN KEY (`relateto_objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entitycontact` */

DROP TABLE IF EXISTS `entitycontact`;

CREATE TABLE `entitycontact` (
  `objid` varchar(50) NOT NULL,
  `entityid` varchar(50) NOT NULL,
  `contacttype` varchar(25) NOT NULL,
  `contact` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_entityid` (`entityid`),
  CONSTRAINT `fk_entitycontact_entity` FOREIGN KEY (`entityid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entityid` */

DROP TABLE IF EXISTS `entityid`;

CREATE TABLE `entityid` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `entityid` varchar(50) NOT NULL,
  `idtype` varchar(50) NOT NULL,
  `idno` varchar(25) NOT NULL,
  `dtissued` date DEFAULT NULL,
  `dtexpiry` date DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_entityid` (`entityid`),
  KEY `ix_idtype` (`idtype`),
  KEY `ix_idno` (`idno`),
  KEY `ix_dtexpiry` (`dtexpiry`),
  KEY `ix_entityid_state` (`state`),
  CONSTRAINT `fk_entityid_entity` FOREIGN KEY (`entityid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entityindividual` */

DROP TABLE IF EXISTS `entityindividual`;

CREATE TABLE `entityindividual` (
  `objid` varchar(50) NOT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `middlename` varchar(100) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `birthplace` varchar(160) DEFAULT NULL,
  `citizenship` varchar(50) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `civilstatus` varchar(15) DEFAULT NULL,
  `profession` varchar(50) DEFAULT NULL,
  `tin` varchar(25) DEFAULT NULL,
  `sss` varchar(25) DEFAULT NULL,
  `height` varchar(10) DEFAULT NULL,
  `weight` varchar(10) DEFAULT NULL,
  `acr` varchar(50) DEFAULT NULL,
  `religion` varchar(50) DEFAULT NULL,
  `photo` mediumblob,
  `thumbnail` blob,
  PRIMARY KEY (`objid`),
  KEY `ix_lfname` (`lastname`,`firstname`),
  KEY `ix_fname` (`firstname`),
  KEY `ix_tin` (`tin`),
  KEY `ix_ss` (`sss`),
  CONSTRAINT `fk_entityindividual_entity` FOREIGN KEY (`objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entityjuridical` */

DROP TABLE IF EXISTS `entityjuridical`;

CREATE TABLE `entityjuridical` (
  `objid` varchar(50) NOT NULL,
  `tin` varchar(25) DEFAULT NULL,
  `dtregistered` datetime DEFAULT NULL,
  `orgtype` varchar(25) DEFAULT NULL,
  `nature` varchar(255) DEFAULT NULL,
  `placeregistered` varchar(100) DEFAULT NULL,
  `administrator_name` varchar(100) DEFAULT NULL,
  `administrator_address` varchar(100) DEFAULT NULL,
  `administrator_position` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_tin` (`tin`),
  CONSTRAINT `fk_entityjuridical_entity` FOREIGN KEY (`objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entitymember` */

DROP TABLE IF EXISTS `entitymember`;

CREATE TABLE `entitymember` (
  `objid` varchar(50) NOT NULL,
  `entityid` varchar(50) NOT NULL,
  `itemno` int(11) NOT NULL,
  `prefix` varchar(100) DEFAULT NULL,
  `member_objid` varchar(50) NOT NULL,
  `member_name` text NOT NULL,
  `member_address_text` varchar(255) NOT NULL DEFAULT '',
  `suffix` varchar(100) DEFAULT NULL,
  `remarks` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_entityid` (`entityid`),
  KEY `ix_member_objid` (`member_objid`),
  KEY `ix_member_name` (`member_name`(255)),
  CONSTRAINT `fk_entitymember_entity` FOREIGN KEY (`entityid`) REFERENCES `entity` (`objid`),
  CONSTRAINT `fk_entitymember_member` FOREIGN KEY (`member_objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `entitymultiple` */

DROP TABLE IF EXISTS `entitymultiple`;

CREATE TABLE `entitymultiple` (
  `objid` varchar(50) NOT NULL,
  `fullname` longtext,
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_entitymultiple_entity` FOREIGN KEY (`objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `epayment` */

DROP TABLE IF EXISTS `epayment`;

CREATE TABLE `epayment` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `partnerid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `traceno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_partnerid` (`partnerid`),
  KEY `ix_receiptid` (`receiptid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `examiner_finding` */

DROP TABLE IF EXISTS `examiner_finding`;

CREATE TABLE `examiner_finding` (
  `objid` varchar(50) NOT NULL,
  `findings` text,
  `parent_objid` varchar(50) DEFAULT NULL,
  `dtinspected` date DEFAULT NULL,
  `inspectors` varchar(500) DEFAULT NULL,
  `notedby` varchar(100) DEFAULT NULL,
  `notedbytitle` varchar(50) DEFAULT NULL,
  `photos` varchar(255) DEFAULT NULL,
  `recommendations` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtinspected` (`dtinspected`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `exemptiontype` */

DROP TABLE IF EXISTS `exemptiontype`;

CREATE TABLE `exemptiontype` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `orderno` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_exemptiontype_code` (`code`),
  UNIQUE KEY `ux_exemptiontype_name` (`name`),
  KEY `ix_exemptiontype_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas` */

DROP TABLE IF EXISTS `faas`;

CREATE TABLE `faas` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `rpuid` varchar(50) DEFAULT NULL,
  `datacapture` int(11) NOT NULL,
  `autonumber` int(11) NOT NULL,
  `utdno` varchar(25) NOT NULL,
  `tdno` varchar(25) DEFAULT NULL,
  `txntype_objid` varchar(10) DEFAULT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `titletype` varchar(10) DEFAULT NULL,
  `titleno` varchar(50) DEFAULT NULL,
  `titledate` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `owner_name` longtext,
  `owner_address` varchar(150) DEFAULT NULL,
  `administrator_objid` varchar(50) DEFAULT NULL,
  `administrator_name` text,
  `administrator_address` varchar(150) DEFAULT NULL,
  `beneficiary_objid` varchar(50) DEFAULT NULL,
  `beneficiary_name` varchar(150) DEFAULT NULL,
  `beneficiary_address` varchar(150) DEFAULT NULL,
  `memoranda` text,
  `cancelnote` varchar(250) DEFAULT NULL,
  `restrictionid` varchar(50) DEFAULT NULL,
  `backtaxyrs` int(11) NOT NULL,
  `prevtdno` text,
  `prevpin` text,
  `prevowner` longtext,
  `prevav` text,
  `prevmv` text,
  `cancelreason` varchar(5) DEFAULT NULL,
  `canceldate` datetime DEFAULT NULL,
  `cancelledbytdnos` text,
  `lguid` varchar(50) NOT NULL,
  `txntimestamp` varchar(15) DEFAULT NULL,
  `cancelledtimestamp` varchar(25) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `dtapproved` date DEFAULT NULL,
  `realpropertyid` varchar(50) DEFAULT NULL,
  `lgutype` varchar(25) DEFAULT NULL,
  `signatories` text,
  `ryordinanceno` varchar(25) DEFAULT NULL,
  `ryordinancedate` date DEFAULT NULL,
  `prevareaha` text,
  `prevareasqm` text,
  `fullpin` varchar(35) DEFAULT NULL,
  `preveffectivity` varchar(10) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `day` int(11) DEFAULT NULL,
  `cancelledyear` int(11) DEFAULT NULL,
  `cancelledqtr` int(11) DEFAULT NULL,
  `cancelledmonth` int(11) DEFAULT NULL,
  `cancelledday` int(11) DEFAULT NULL,
  `prevadministrator` varchar(200) DEFAULT NULL,
  `originlguid` varchar(50) DEFAULT NULL,
  `parentfaasid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_faas_utdno` (`utdno`),
  KEY `FK_faas_rpu` (`rpuid`),
  KEY `ix_canceldate` (`canceldate`),
  KEY `ix_faas_appraisedby` (`objid`),
  KEY `ix_faas_beneficiary` (`beneficiary_name`),
  KEY `ix_faas_cancelledtimestamp` (`cancelledtimestamp`),
  KEY `ix_faas_name` (`name`),
  KEY `ix_faas_realproperty` (`realpropertyid`),
  KEY `ix_faas_restrictionid` (`restrictionid`),
  KEY `ix_faas_state` (`state`),
  KEY `ix_faas_tdno` (`tdno`),
  KEY `ix_faas_titleno` (`titleno`),
  KEY `ix_faas_txntimestamp` (`txntimestamp`),
  KEY `txntype_objid` (`txntype_objid`),
  KEY `taxpayer_objid` (`taxpayer_objid`),
  KEY `ix_faas_cancelledyear` (`year`),
  KEY `ix_faas_cancelledyear_qtr` (`year`,`qtr`),
  KEY `ix_faas_cancelledyear_qtr_month` (`year`,`qtr`,`month`),
  KEY `ix_faas_cancelledyear_qtr_month_day` (`year`,`qtr`,`month`,`day`),
  KEY `ix_faas_year` (`year`),
  KEY `ix_faas_year_qtr` (`year`,`qtr`),
  KEY `ix_faas_year_qtr_month` (`year`,`qtr`,`month`),
  KEY `ix_faas_year_qtr_month_day` (`year`,`qtr`,`month`,`day`),
  KEY `ix_dtapproved` (`dtapproved`),
  CONSTRAINT `faas_ibfk_1` FOREIGN KEY (`rpuid`) REFERENCES `rpu` (`objid`),
  CONSTRAINT `faas_ibfk_2` FOREIGN KEY (`realpropertyid`) REFERENCES `realproperty` (`objid`),
  CONSTRAINT `faas_ibfk_3` FOREIGN KEY (`txntype_objid`) REFERENCES `faas_txntype` (`objid`),
  CONSTRAINT `faas_ibfk_4` FOREIGN KEY (`taxpayer_objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_affectedrpu` */

DROP TABLE IF EXISTS `faas_affectedrpu`;

CREATE TABLE `faas_affectedrpu` (
  `objid` varchar(50) NOT NULL,
  `faasid` varchar(50) NOT NULL,
  `prevfaasid` varchar(50) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `newsuffix` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_faasaffectedrpu_faasprevfaas` (`faasid`,`prevfaasid`),
  KEY `FK_faasaffectedrpu_faas` (`faasid`),
  KEY `FK_faasaffectedrpu_prevfaas` (`prevfaasid`),
  KEY `FK_faasaffectedrpu_newfaas` (`newfaasid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_list` */

DROP TABLE IF EXISTS `faas_list`;

CREATE TABLE `faas_list` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(30) NOT NULL,
  `rpuid` varchar(50) NOT NULL,
  `realpropertyid` varchar(50) NOT NULL,
  `datacapture` int(11) NOT NULL,
  `ry` int(11) NOT NULL,
  `txntype_objid` varchar(50) NOT NULL,
  `tdno` varchar(25) DEFAULT NULL,
  `utdno` varchar(25) NOT NULL,
  `prevtdno` text,
  `displaypin` varchar(35) NOT NULL,
  `pin` varchar(35) NOT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `owner_name` text,
  `owner_address` varchar(150) DEFAULT NULL,
  `administrator_name` varchar(150) DEFAULT NULL,
  `administrator_address` varchar(150) DEFAULT NULL,
  `rputype` varchar(10) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `barangay` varchar(75) NOT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `classcode` varchar(20) DEFAULT NULL,
  `cadastrallotno` text,
  `blockno` varchar(100) DEFAULT NULL,
  `surveyno` varchar(255) DEFAULT NULL,
  `titleno` varchar(50) DEFAULT NULL,
  `totalareaha` decimal(16,6) NOT NULL,
  `totalareasqm` decimal(16,6) NOT NULL,
  `totalmv` decimal(16,2) NOT NULL,
  `totalav` decimal(16,2) NOT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `cancelreason` varchar(15) DEFAULT NULL,
  `cancelledbytdnos` text,
  `lguid` varchar(50) NOT NULL,
  `originlguid` varchar(50) NOT NULL,
  `yearissued` int(11) DEFAULT NULL,
  `taskid` varchar(50) DEFAULT NULL,
  `taskstate` varchar(50) DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `trackingno` varchar(20) DEFAULT NULL,
  `publicland` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_faaslist_state` (`state`),
  KEY `ix_faaslist_rpuid` (`rpuid`),
  KEY `ix_faaslist_realpropertyid` (`realpropertyid`),
  KEY `ix_faaslist_ry` (`ry`),
  KEY `ix_faaslist_tdno` (`tdno`),
  KEY `ix_faaslist_utdno` (`utdno`),
  KEY `ix_faaslist_prevtdno` (`prevtdno`(255)),
  KEY `ix_faaslist_pin` (`pin`),
  KEY `ix_faaslist_taxpayer_objid` (`taxpayer_objid`),
  KEY `ix_faaslist_owner_name` (`owner_name`(100)),
  KEY `ix_faaslist_administrator_name` (`administrator_name`(100)),
  KEY `ix_faaslist_rputype` (`rputype`),
  KEY `ix_faaslist_barangayid` (`barangayid`),
  KEY `ix_faaslist_barangay` (`barangay`),
  KEY `ix_faaslist_classification_objid` (`classification_objid`),
  KEY `ix_faaslist_classcode` (`classcode`),
  KEY `ix_faaslist_cadastrallotno` (`cadastrallotno`(255)),
  KEY `ix_faaslist_blockno` (`blockno`),
  KEY `ix_faaslist_surveyno` (`surveyno`),
  KEY `ix_faaslist_titleno` (`titleno`),
  KEY `ix_faaslist_lguid` (`lguid`),
  KEY `ix_faaslist_originlguid` (`originlguid`),
  KEY `ix_faaslist_taskstate` (`taskstate`),
  KEY `ix_faaslist_trackingno` (`trackingno`),
  KEY `ix_faaslist_assigneeid` (`assignee_objid`),
  KEY `ix_faaslist_publicland` (`publicland`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_previous` */

DROP TABLE IF EXISTS `faas_previous`;

CREATE TABLE `faas_previous` (
  `objid` varchar(50) NOT NULL,
  `faasid` varchar(50) NOT NULL,
  `prevfaasid` varchar(50) DEFAULT NULL,
  `prevrpuid` varchar(50) DEFAULT NULL,
  `prevtdno` varchar(800) DEFAULT NULL,
  `prevpin` varchar(800) DEFAULT NULL,
  `prevowner` text,
  `prevadministrator` text,
  `prevav` varchar(500) DEFAULT NULL,
  `prevmv` varchar(500) DEFAULT NULL,
  `prevareasqm` varchar(500) DEFAULT NULL,
  `prevareaha` varchar(500) DEFAULT NULL,
  `preveffectivity` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_faas_previous_faas` (`faasid`),
  KEY `ix_faas_previous_tdno` (`prevtdno`(255)),
  KEY `ix_faas_previous_pin` (`prevpin`(255)),
  CONSTRAINT `FK_faas_previous_faas` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_restriction` */

DROP TABLE IF EXISTS `faas_restriction`;

CREATE TABLE `faas_restriction` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `ledger_objid` varchar(50) DEFAULT NULL,
  `state` varchar(25) NOT NULL,
  `restrictiontype_objid` varchar(50) NOT NULL,
  `txndate` date DEFAULT NULL,
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
  `rpumaster_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parent_objid` (`parent_objid`),
  KEY `ix_ledger_objid` (`ledger_objid`),
  KEY `ix_state` (`state`),
  KEY `ix_receiptno` (`receipt_receiptno`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_restrictiontype_objid` (`restrictiontype_objid`),
  CONSTRAINT `FK_faas_restriction_faas` FOREIGN KEY (`parent_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_restriction_type` */

DROP TABLE IF EXISTS `faas_restriction_type`;

CREATE TABLE `faas_restriction_type` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL,
  `idx` int(11) NOT NULL,
  `isother` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_signatory` */

DROP TABLE IF EXISTS `faas_signatory`;

CREATE TABLE `faas_signatory` (
  `objid` varchar(50) NOT NULL,
  `taxmapper_objid` varchar(50) DEFAULT NULL,
  `taxmapper_name` varchar(100) DEFAULT NULL,
  `taxmapper_title` varchar(50) DEFAULT NULL,
  `taxmapper_dtsigned` datetime DEFAULT NULL,
  `taxmapper_taskid` varchar(50) DEFAULT NULL,
  `taxmapperchief_objid` varchar(50) DEFAULT NULL,
  `taxmapperchief_name` varchar(100) DEFAULT NULL,
  `taxmapperchief_title` varchar(50) DEFAULT NULL,
  `taxmapperchief_dtsigned` datetime DEFAULT NULL,
  `taxmapperchief_taskid` varchar(50) DEFAULT NULL,
  `appraiser_objid` varchar(50) DEFAULT NULL,
  `appraiser_name` varchar(100) DEFAULT NULL,
  `appraiser_title` varchar(50) DEFAULT NULL,
  `appraiser_dtsigned` datetime DEFAULT NULL,
  `appraiser_taskid` varchar(50) DEFAULT NULL,
  `appraiserchief_objid` varchar(50) DEFAULT NULL,
  `appraiserchief_name` varchar(100) DEFAULT NULL,
  `appraiserchief_title` varchar(50) DEFAULT NULL,
  `appraiserchief_dtsigned` datetime DEFAULT NULL,
  `appraiserchief_taskid` varchar(50) DEFAULT NULL,
  `recommender_objid` varchar(50) DEFAULT NULL,
  `recommender_name` varchar(100) DEFAULT NULL,
  `recommender_title` varchar(50) DEFAULT NULL,
  `recommender_dtsigned` datetime DEFAULT NULL,
  `recommender_taskid` varchar(50) DEFAULT NULL,
  `provtaxmapper_objid` varchar(50) DEFAULT NULL,
  `provtaxmapper_name` varchar(100) DEFAULT NULL,
  `provtaxmapper_title` varchar(50) DEFAULT NULL,
  `provtaxmapper_dtsigned` datetime DEFAULT NULL,
  `provtaxmapper_taskid` varchar(50) DEFAULT NULL,
  `provtaxmapperchief_objid` varchar(50) DEFAULT NULL,
  `provtaxmapperchief_name` varchar(100) DEFAULT NULL,
  `provtaxmapperchief_title` varchar(50) DEFAULT NULL,
  `provtaxmapperchief_dtsigned` datetime DEFAULT NULL,
  `provtaxmapperchief_taskid` varchar(50) DEFAULT NULL,
  `provappraiser_objid` varchar(50) DEFAULT NULL,
  `provappraiser_name` varchar(100) DEFAULT NULL,
  `provappraiser_title` varchar(50) DEFAULT NULL,
  `provappraiser_dtsigned` datetime DEFAULT NULL,
  `provappraiser_taskid` varchar(50) DEFAULT NULL,
  `provappraiserchief_objid` varchar(50) DEFAULT NULL,
  `provappraiserchief_name` varchar(100) DEFAULT NULL,
  `provappraiserchief_title` varchar(50) DEFAULT NULL,
  `provappraiserchief_dtsigned` datetime DEFAULT NULL,
  `provappraiserchief_taskid` varchar(50) DEFAULT NULL,
  `approver_objid` varchar(50) DEFAULT NULL,
  `approver_name` varchar(100) DEFAULT NULL,
  `approver_title` varchar(50) DEFAULT NULL,
  `approver_dtsigned` datetime DEFAULT NULL,
  `approver_taskid` varchar(50) DEFAULT NULL,
  `provapprover_objid` varchar(50) DEFAULT NULL,
  `provapprover_name` varchar(100) DEFAULT NULL,
  `provapprover_title` varchar(75) DEFAULT NULL,
  `provapprover_dtsigned` datetime DEFAULT NULL,
  `provapprover_taskid` varchar(50) DEFAULT NULL,
  `provrecommender_objid` varchar(50) DEFAULT NULL,
  `provrecommender_name` varchar(100) DEFAULT NULL,
  `provrecommender_title` varchar(50) DEFAULT NULL,
  `provrecommender_dtsigned` datetime DEFAULT NULL,
  `provrecommender_taskid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `FK_faas_faas_signatory` FOREIGN KEY (`objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_stewardship` */

DROP TABLE IF EXISTS `faas_stewardship`;

CREATE TABLE `faas_stewardship` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rpumasterid` varchar(50) NOT NULL,
  `stewardrpumasterid` varchar(50) NOT NULL,
  `ry` int(11) NOT NULL,
  `stewardshipno` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_faas_stewardship` (`rpumasterid`,`stewardrpumasterid`,`ry`,`stewardshipno`),
  KEY `ix_faas_stewardship_rpumasterid` (`rpumasterid`),
  KEY `ix_faas_stewardship_stewardrpumasterid` (`stewardrpumasterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_task` */

DROP TABLE IF EXISTS `faas_task`;

CREATE TABLE `faas_task` (
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
  `signature` longtext,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  CONSTRAINT `faas_task_ibfk_1` FOREIGN KEY (`refid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_txntype` */

DROP TABLE IF EXISTS `faas_txntype`;

CREATE TABLE `faas_txntype` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL DEFAULT '',
  `newledger` int(11) NOT NULL,
  `newrpu` int(11) NOT NULL,
  `newrealproperty` int(11) NOT NULL,
  `displaycode` varchar(10) DEFAULT NULL,
  `allowEditOwner` int(11) DEFAULT NULL,
  `allowEditPin` int(11) DEFAULT NULL,
  `allowEditPinInfo` int(11) DEFAULT NULL,
  `allowEditAppraisal` int(11) DEFAULT NULL,
  `opener` varchar(50) DEFAULT NULL,
  `checkbalance` int(11) DEFAULT NULL,
  `reconcileledger` int(11) DEFAULT NULL,
  `allowannotated` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_txntype_attribute` */

DROP TABLE IF EXISTS `faas_txntype_attribute`;

CREATE TABLE `faas_txntype_attribute` (
  `txntype_objid` varchar(50) NOT NULL,
  `attribute` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  PRIMARY KEY (`txntype_objid`,`attribute`),
  KEY `FK_faas_txntype_attribute_type` (`attribute`),
  CONSTRAINT `FK_faas_txntype_attribute` FOREIGN KEY (`txntype_objid`) REFERENCES `faas_txntype` (`objid`),
  CONSTRAINT `FK_faas_txntype_attribute_type` FOREIGN KEY (`attribute`) REFERENCES `faas_txntype_attribute_type` (`attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faas_txntype_attribute_type` */

DROP TABLE IF EXISTS `faas_txntype_attribute_type`;

CREATE TABLE `faas_txntype_attribute_type` (
  `attribute` varchar(50) NOT NULL,
  PRIMARY KEY (`attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faasannotation` */

DROP TABLE IF EXISTS `faasannotation`;

CREATE TABLE `faasannotation` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `annotationtype_objid` varchar(50) NOT NULL,
  `faasid` varchar(50) NOT NULL,
  `txnno` varchar(15) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `fileno` varchar(25) NOT NULL,
  `orno` varchar(10) NOT NULL,
  `ordate` datetime NOT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `memoranda` text NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_faasannotation_faas` (`faasid`),
  KEY `FK_faasannotation_faasannotationtype` (`annotationtype_objid`),
  KEY `ix_faasannotation_fileno` (`fileno`),
  KEY `ix_faasannotation_orno` (`orno`),
  KEY `ix_faasannotation_state` (`state`),
  KEY `ix_faasannotation_txnno` (`txnno`),
  CONSTRAINT `faasannotation_ibfk_1` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `faasannotation_ibfk_2` FOREIGN KEY (`annotationtype_objid`) REFERENCES `faasannotationtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faasannotationtype` */

DROP TABLE IF EXISTS `faasannotationtype`;

CREATE TABLE `faasannotationtype` (
  `objid` varchar(50) NOT NULL,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faasbacktax` */

DROP TABLE IF EXISTS `faasbacktax`;

CREATE TABLE `faasbacktax` (
  `objid` varchar(50) NOT NULL,
  `faasid` varchar(50) NOT NULL,
  `ry` int(11) NOT NULL,
  `tdno` varchar(25) DEFAULT NULL,
  `bmv` decimal(16,2) NOT NULL,
  `mv` decimal(16,2) NOT NULL,
  `av` decimal(16,2) NOT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `taxable` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_faasbacktax` (`faasid`),
  CONSTRAINT `faasbacktax_ibfk_1` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `faasupdate` */

DROP TABLE IF EXISTS `faasupdate`;

CREATE TABLE `faasupdate` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(10) NOT NULL,
  `txndate` datetime NOT NULL,
  `faasid` varchar(50) NOT NULL,
  `prevtitletype` varchar(25) DEFAULT NULL,
  `prevtitleno` varchar(25) DEFAULT NULL,
  `prevtitledate` datetime DEFAULT NULL,
  `prevtaxpayerid` varchar(50) NOT NULL,
  `prevtaxpayername` text NOT NULL,
  `prevtaxpayeraddress` varchar(150) NOT NULL,
  `prevownername` text NOT NULL,
  `prevowneraddress` varchar(150) NOT NULL,
  `prevadministratorid` varchar(50) DEFAULT NULL,
  `prevadministratorname` varchar(150) DEFAULT NULL,
  `prevadministratoraddress` varchar(100) DEFAULT NULL,
  `prevrestrictionid` varchar(50) DEFAULT NULL,
  `prevmemoranda` text NOT NULL,
  `prevsurveyno` varchar(100) DEFAULT NULL,
  `prevcadastrallotno` varchar(100) NOT NULL,
  `prevblockno` varchar(50) DEFAULT NULL,
  `prevpurok` varchar(50) DEFAULT NULL,
  `prevstreet` varchar(100) DEFAULT NULL,
  `prevnorth` varchar(150) NOT NULL,
  `preveast` varchar(150) NOT NULL,
  `prevsouth` varchar(150) NOT NULL,
  `prevwest` varchar(150) NOT NULL,
  `faas_titletype` varchar(25) DEFAULT NULL,
  `faas_titleno` varchar(25) DEFAULT NULL,
  `faas_titledate` datetime DEFAULT NULL,
  `faas_restrictionid` varchar(50) DEFAULT NULL,
  `faas_memoranda` text NOT NULL,
  `rp_surveyno` varchar(100) DEFAULT NULL,
  `rp_cadastrallotno` varchar(100) NOT NULL,
  `rp_blockno` varchar(50) DEFAULT NULL,
  `rp_street` varchar(100) DEFAULT NULL,
  `rp_north` varchar(150) NOT NULL,
  `rp_east` varchar(150) NOT NULL,
  `rp_south` varchar(150) NOT NULL,
  `rp_west` varchar(150) NOT NULL,
  `faas_taxpayer_objid` varchar(50) NOT NULL,
  `faas_taxpayer_name` text NOT NULL,
  `faas_taxpayer_address` varchar(150) NOT NULL,
  `faas_owner_address` text NOT NULL,
  `faas_owner_name` text NOT NULL,
  `faas_administrator_name` varchar(200) DEFAULT NULL,
  `faas_administrator_objid` varchar(50) DEFAULT NULL,
  `faas_administrator_address` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_faasupdate_faas` (`faasid`),
  CONSTRAINT `faasupdate_ibfk_1` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `fund` */

DROP TABLE IF EXISTS `fund`;

CREATE TABLE `fund` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `special` int(11) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_code` (`code`),
  KEY `ix_title` (`title`),
  CONSTRAINT `fk_fund_fundgroup` FOREIGN KEY (`parentid`) REFERENCES `fundgroup` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `fundgroup` */

DROP TABLE IF EXISTS `fundgroup`;

CREATE TABLE `fundgroup` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `indexno` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `fundtransfer` */

DROP TABLE IF EXISTS `fundtransfer`;

CREATE TABLE `fundtransfer` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `issuedby_objid` varchar(50) DEFAULT NULL,
  `issuedby_name` varchar(255) DEFAULT NULL,
  `dtissued` date DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `frombankaccountid` varchar(50) DEFAULT NULL,
  `tobankaccountid` varchar(50) DEFAULT NULL,
  `validationno` varchar(50) DEFAULT NULL,
  `validationdate` date DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `government_property` */

DROP TABLE IF EXISTS `government_property`;

CREATE TABLE `government_property` (
  `objid` varchar(50) NOT NULL,
  `bldgno` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `subdivision` varchar(100) DEFAULT NULL,
  `barangay_objid` varchar(50) DEFAULT NULL,
  `barangay_name` varchar(100) DEFAULT NULL,
  `pin` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_bldgname` (`name`),
  KEY `ix_barangay_objid` (`barangay_objid`),
  KEY `ix_barangay_name` (`barangay_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `holiday` */

DROP TABLE IF EXISTS `holiday`;

CREATE TABLE `holiday` (
  `objid` varchar(50) NOT NULL,
  `year` int(4) DEFAULT NULL,
  `month` int(2) DEFAULT NULL,
  `day` int(2) DEFAULT NULL,
  `week` int(1) DEFAULT NULL,
  `dow` int(1) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `income_summary` */

DROP TABLE IF EXISTS `income_summary`;

CREATE TABLE `income_summary` (
  `refid` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) NOT NULL,
  `fundid` varchar(50) NOT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `orgid` varchar(50) NOT NULL,
  `collectorid` varchar(50) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  PRIMARY KEY (`refid`,`refdate`,`fundid`,`acctid`,`orgid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_collectorid` (`collectorid`),
  KEY `ix_refyear` (`year`),
  KEY `ix_refmonth` (`month`),
  KEY `ix_refqtr` (`qtr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `itemaccount` */

DROP TABLE IF EXISTS `itemaccount`;

CREATE TABLE `itemaccount` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_code` varchar(50) DEFAULT NULL,
  `fund_title` varchar(50) DEFAULT NULL,
  `defaultvalue` decimal(16,2) DEFAULT NULL,
  `valuetype` varchar(10) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_code` (`code`),
  KEY `ix_title` (`title`),
  KEY `ix_fund_objid` (`fund_objid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `fk_itemaccount_fund` FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`),
  CONSTRAINT `fk_itemaccount_org` FOREIGN KEY (`org_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `itemaccount_tag` */

DROP TABLE IF EXISTS `itemaccount_tag`;

CREATE TABLE `itemaccount_tag` (
  `objid` varchar(100) NOT NULL,
  `acctid` varchar(50) NOT NULL,
  `tag` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `jev` */

DROP TABLE IF EXISTS `jev`;

CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `jevno` varchar(50) DEFAULT NULL,
  `jevdate` date DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `refid` varchar(150) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `verifiedby_objid` varchar(50) DEFAULT NULL,
  `verifiedby_name` varchar(50) DEFAULT NULL,
  `dtverified` datetime DEFAULT NULL,
  `batchid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_refid` (`refid`),
  KEY `ix_jevno` (`jevno`),
  KEY `ix_jevdate` (`jevdate`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_refno` (`refno`),
  KEY `ix_reftype` (`reftype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `jevitem` */

DROP TABLE IF EXISTS `jevitem`;

CREATE TABLE `jevitem` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) DEFAULT NULL,
  `accttype` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  `ledgerid` varchar(50) DEFAULT NULL,
  `ledgertype` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_jevid` (`jevid`),
  KEY `ix_ledgertype` (`accttype`),
  KEY `ix_acctid` (`acctid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landadjustment` */

DROP TABLE IF EXISTS `landadjustment`;

CREATE TABLE `landadjustment` (
  `objid` varchar(50) NOT NULL,
  `landrpuid` varchar(50) DEFAULT NULL,
  `landdetailid` varchar(50) DEFAULT NULL,
  `adjustmenttype_objid` varchar(50) NOT NULL,
  `expr` text,
  `adjustment` decimal(16,2) NOT NULL,
  `type` varchar(2) NOT NULL,
  `basemarketvalue` decimal(16,2) DEFAULT NULL,
  `marketvalue` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_landadjustment_landadjustmenttype` (`adjustmenttype_objid`),
  KEY `FK_landadjustment_landdetail` (`landdetailid`),
  KEY `FK_landadjustment_landrpu` (`landrpuid`),
  CONSTRAINT `landadjustment_ibfk_1` FOREIGN KEY (`adjustmenttype_objid`) REFERENCES `landadjustmenttype` (`objid`),
  CONSTRAINT `landadjustment_ibfk_2` FOREIGN KEY (`landdetailid`) REFERENCES `landdetail` (`objid`),
  CONSTRAINT `landadjustment_ibfk_3` FOREIGN KEY (`landrpuid`) REFERENCES `landrpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landadjustmentparameter` */

DROP TABLE IF EXISTS `landadjustmentparameter`;

CREATE TABLE `landadjustmentparameter` (
  `objid` varchar(50) NOT NULL,
  `landadjustmentid` varchar(50) NOT NULL,
  `landrpuid` varchar(50) NOT NULL,
  `parameter_objid` varchar(50) DEFAULT NULL,
  `value` decimal(16,2) NOT NULL,
  `param_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_landadjustmentparameter_landadjustment` (`landadjustmentid`),
  KEY `FK_landadjustmentparameter_landrpu` (`landrpuid`),
  KEY `FK_landadjustmentparameter_rptparameter` (`parameter_objid`),
  CONSTRAINT `landadjustmentparameter_ibfk_1` FOREIGN KEY (`landadjustmentid`) REFERENCES `landadjustment` (`objid`),
  CONSTRAINT `landadjustmentparameter_ibfk_2` FOREIGN KEY (`landrpuid`) REFERENCES `landrpu` (`objid`),
  CONSTRAINT `landadjustmentparameter_ibfk_3` FOREIGN KEY (`parameter_objid`) REFERENCES `rptparameter` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landadjustmenttype` */

DROP TABLE IF EXISTS `landadjustmenttype`;

CREATE TABLE `landadjustmenttype` (
  `objid` varchar(50) NOT NULL,
  `landrysettingid` varchar(50) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `expr` text NOT NULL,
  `appliedto` varchar(150) DEFAULT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `idx` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_landadjustment_landrysetting` (`landrysettingid`),
  KEY `ix_landadjustmenttype` (`previd`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `landadjustmenttype_ibfk_1` FOREIGN KEY (`landrysettingid`) REFERENCES `landrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landadjustmenttype_classification` */

DROP TABLE IF EXISTS `landadjustmenttype_classification`;

CREATE TABLE `landadjustmenttype_classification` (
  `landadjustmenttypeid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) NOT NULL,
  `landrysettingid` varchar(50) NOT NULL,
  PRIMARY KEY (`landadjustmenttypeid`,`classification_objid`),
  KEY `FK_landadjustmenttype_classification_classification` (`classification_objid`),
  CONSTRAINT `landadjustmenttype_classification_ibfk_1` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`),
  CONSTRAINT `landadjustmenttype_classification_ibfk_2` FOREIGN KEY (`landadjustmenttypeid`) REFERENCES `landadjustmenttype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landassesslevel` */

DROP TABLE IF EXISTS `landassesslevel`;

CREATE TABLE `landassesslevel` (
  `objid` varchar(50) NOT NULL,
  `landrysettingid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `fixrate` int(11) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_landassesslevel_code` (`landrysettingid`,`code`),
  UNIQUE KEY `ux_landassesslevel_name` (`landrysettingid`,`name`),
  KEY `landrysettingid` (`landrysettingid`),
  KEY `FK_landassesslevel_propertyclassification` (`classification_objid`),
  KEY `ix_landassesslevel_previd` (`previd`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `landassesslevel_ibfk_1` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`),
  CONSTRAINT `landassesslevel_ibfk_2` FOREIGN KEY (`landrysettingid`) REFERENCES `landrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landassesslevelrange` */

DROP TABLE IF EXISTS `landassesslevelrange`;

CREATE TABLE `landassesslevelrange` (
  `objid` varchar(50) NOT NULL,
  `landassesslevelid` varchar(50) NOT NULL,
  `landrysettingid` varchar(50) NOT NULL,
  `mvfrom` decimal(16,2) NOT NULL,
  `mvto` decimal(16,2) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_landassesslevelrange_landassesslevel` (`landassesslevelid`),
  KEY `ix_landassesslevelrange_rootid` (`landrysettingid`),
  CONSTRAINT `landassesslevelrange_ibfk_1` FOREIGN KEY (`landrysettingid`) REFERENCES `landrysetting` (`objid`),
  CONSTRAINT `landassesslevelrange_ibfk_2` FOREIGN KEY (`landassesslevelid`) REFERENCES `landassesslevel` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landdetail` */

DROP TABLE IF EXISTS `landdetail`;

CREATE TABLE `landdetail` (
  `objid` varchar(50) NOT NULL,
  `landrpuid` varchar(50) NOT NULL,
  `subclass_objid` varchar(50) NOT NULL,
  `specificclass_objid` varchar(50) NOT NULL,
  `actualuse_objid` varchar(50) NOT NULL,
  `stripping_objid` varchar(50) DEFAULT NULL,
  `striprate` decimal(16,2) NOT NULL,
  `areatype` varchar(10) NOT NULL,
  `addlinfo` varchar(250) DEFAULT NULL,
  `area` decimal(18,6) NOT NULL,
  `areasqm` decimal(18,2) NOT NULL,
  `areaha` decimal(18,6) NOT NULL,
  `basevalue` decimal(16,2) NOT NULL,
  `unitvalue` decimal(16,2) NOT NULL,
  `taxable` int(11) NOT NULL,
  `basemarketvalue` decimal(16,2) NOT NULL,
  `adjustment` decimal(16,2) NOT NULL,
  `landvalueadjustment` decimal(16,2) NOT NULL,
  `actualuseadjustment` decimal(16,2) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  `assesslevel` decimal(16,2) NOT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  `landspecificclass_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_landdetail_actualuse` (`actualuse_objid`),
  KEY `FK_landdetail_landrpu` (`landrpuid`),
  KEY `FK_landdetail_lcuvspecificclass` (`specificclass_objid`),
  KEY `FK_landdetail_lcuvsubclass` (`subclass_objid`),
  KEY `stripping_objid` (`stripping_objid`),
  CONSTRAINT `landdetail_ibfk_1` FOREIGN KEY (`actualuse_objid`) REFERENCES `landassesslevel` (`objid`),
  CONSTRAINT `landdetail_ibfk_2` FOREIGN KEY (`landrpuid`) REFERENCES `landrpu` (`objid`),
  CONSTRAINT `landdetail_ibfk_3` FOREIGN KEY (`specificclass_objid`) REFERENCES `lcuvspecificclass` (`objid`),
  CONSTRAINT `landdetail_ibfk_4` FOREIGN KEY (`subclass_objid`) REFERENCES `lcuvsubclass` (`objid`),
  CONSTRAINT `landdetail_ibfk_5` FOREIGN KEY (`stripping_objid`) REFERENCES `lcuvstripping` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landrpu` */

DROP TABLE IF EXISTS `landrpu`;

CREATE TABLE `landrpu` (
  `objid` varchar(50) NOT NULL,
  `idleland` int(11) NOT NULL,
  `totallandbmv` decimal(16,2) NOT NULL,
  `totallandmv` decimal(16,2) NOT NULL,
  `totallandav` decimal(16,2) NOT NULL,
  `totalplanttreebmv` decimal(16,2) NOT NULL,
  `totalplanttreemv` decimal(16,2) NOT NULL,
  `totalplanttreeadjustment` decimal(16,2) NOT NULL,
  `totalplanttreeav` decimal(16,2) NOT NULL,
  `landvalueadjustment` decimal(16,2) NOT NULL,
  `publicland` int(11) DEFAULT NULL,
  `distanceawr` decimal(16,2) DEFAULT NULL,
  `distanceltc` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `landrpu_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `rpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landrysetting` */

DROP TABLE IF EXISTS `landrysetting`;

CREATE TABLE `landrysetting` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `ry` int(11) NOT NULL,
  `appliedto` text,
  `previd` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_landrysetting_previd` (`previd`),
  KEY `ix_landrysetting_ry` (`ry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landspecificclass` */

DROP TABLE IF EXISTS `landspecificclass`;

CREATE TABLE `landspecificclass` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ux_landspecificclass_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `landtax_lgu_account_mapping` */

DROP TABLE IF EXISTS `landtax_lgu_account_mapping`;

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

/*Table structure for table `lcuvspecificclass` */

DROP TABLE IF EXISTS `lcuvspecificclass`;

CREATE TABLE `lcuvspecificclass` (
  `objid` varchar(50) NOT NULL,
  `landrysettingid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) NOT NULL,
  `areatype` varchar(10) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `landspecificclass_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `landrysettingid` (`landrysettingid`),
  KEY `FK_lcuvspecificclass_propertyclassification` (`classification_objid`),
  KEY `ix_lcuvspecificclass_previd` (`previd`),
  KEY `ix_previd` (`previd`),
  KEY `ix_landspecificclass_objid` (`landspecificclass_objid`),
  CONSTRAINT `fk_lcuvspecificclass_landspecificclass` FOREIGN KEY (`landspecificclass_objid`) REFERENCES `landspecificclass` (`objid`),
  CONSTRAINT `lcuvspecificclass_ibfk_1` FOREIGN KEY (`landrysettingid`) REFERENCES `landrysetting` (`objid`),
  CONSTRAINT `lcuvspecificclass_ibfk_2` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `lcuvstripping` */

DROP TABLE IF EXISTS `lcuvstripping`;

CREATE TABLE `lcuvstripping` (
  `objid` varchar(50) NOT NULL,
  `landrysettingid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) NOT NULL,
  `striplevel` int(11) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_lcuvstripping_landrysetting` (`landrysettingid`),
  KEY `FK_lcuvstripping_propertyclassification` (`classification_objid`),
  KEY `ix_lcuvstripping_previd` (`previd`),
  CONSTRAINT `lcuvstripping_ibfk_1` FOREIGN KEY (`landrysettingid`) REFERENCES `landrysetting` (`objid`),
  CONSTRAINT `lcuvstripping_ibfk_2` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `lcuvsubclass` */

DROP TABLE IF EXISTS `lcuvsubclass`;

CREATE TABLE `lcuvsubclass` (
  `objid` varchar(50) NOT NULL,
  `specificclass_objid` varchar(50) NOT NULL,
  `landrysettingid` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(25) NOT NULL,
  `unitvalue` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_lcuvsubclass_lcuvspecificclass` (`specificclass_objid`),
  KEY `ix_lcuvsubclass_previd` (`previd`),
  KEY `ix_lcuvsubclass_rootid` (`landrysettingid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `lcuvsubclass_ibfk_1` FOREIGN KEY (`landrysettingid`) REFERENCES `landrysetting` (`objid`),
  CONSTRAINT `lcuvsubclass_ibfk_2` FOREIGN KEY (`specificclass_objid`) REFERENCES `lcuvspecificclass` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `lob` */

DROP TABLE IF EXISTS `lob`;

CREATE TABLE `lob` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `classification_objid` varchar(50) NOT NULL,
  `psic` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`),
  KEY `ix_classification_objid` (`classification_objid`),
  KEY `ix_psic` (`psic`),
  CONSTRAINT `lob_classification_objid_ibfk_1` FOREIGN KEY (`classification_objid`) REFERENCES `lobclassification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `lob_lobattribute` */

DROP TABLE IF EXISTS `lob_lobattribute`;

CREATE TABLE `lob_lobattribute` (
  `lobid` varchar(50) NOT NULL,
  `lobattributeid` varchar(50) NOT NULL,
  PRIMARY KEY (`lobid`,`lobattributeid`),
  KEY `lobattributeid` (`lobattributeid`),
  CONSTRAINT `lob_lobattribute_ibfk_1` FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`),
  CONSTRAINT `lob_lobattribute_ibfk_2` FOREIGN KEY (`lobattributeid`) REFERENCES `lobattribute` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `lobattribute` */

DROP TABLE IF EXISTS `lobattribute`;

CREATE TABLE `lobattribute` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `lobclassification` */

DROP TABLE IF EXISTS `lobclassification`;

CREATE TABLE `lobclassification` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machassesslevel` */

DROP TABLE IF EXISTS `machassesslevel`;

CREATE TABLE `machassesslevel` (
  `objid` varchar(50) NOT NULL,
  `machrysettingid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `fixrate` int(11) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `machrysettingid` (`machrysettingid`),
  KEY `FK_machassesslevel_propertyclassification` (`classification_objid`),
  KEY `ix_machassesslevel_previd` (`previd`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `machassesslevel_ibfk_1` FOREIGN KEY (`machrysettingid`) REFERENCES `machrysetting` (`objid`),
  CONSTRAINT `machassesslevel_ibfk_2` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machassesslevelrange` */

DROP TABLE IF EXISTS `machassesslevelrange`;

CREATE TABLE `machassesslevelrange` (
  `objid` varchar(50) NOT NULL,
  `machassesslevelid` varchar(50) NOT NULL,
  `machrysettingid` varchar(50) NOT NULL,
  `mvfrom` decimal(16,2) NOT NULL,
  `mvto` decimal(16,2) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `machrysettingid` (`machrysettingid`),
  KEY `FK_machassesslevelrange_machassesslevel` (`machassesslevelid`),
  CONSTRAINT `machassesslevelrange_ibfk_1` FOREIGN KEY (`machassesslevelid`) REFERENCES `machassesslevel` (`objid`),
  CONSTRAINT `machassesslevelrange_ibfk_2` FOREIGN KEY (`machrysettingid`) REFERENCES `machrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machdetail` */

DROP TABLE IF EXISTS `machdetail`;

CREATE TABLE `machdetail` (
  `objid` varchar(50) NOT NULL,
  `machuseid` varchar(50) NOT NULL,
  `machrpuid` varchar(50) NOT NULL,
  `machine_objid` varchar(50) NOT NULL,
  `operationyear` int(11) DEFAULT NULL,
  `replacementcost` decimal(16,2) NOT NULL,
  `depreciation` decimal(16,2) NOT NULL,
  `depreciationvalue` decimal(16,2) NOT NULL,
  `basemarketvalue` decimal(16,2) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  `assesslevel` decimal(16,2) NOT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `capacity` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `serialno` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `yearacquired` int(11) DEFAULT NULL,
  `estimatedlife` int(11) DEFAULT NULL,
  `remaininglife` int(11) DEFAULT NULL,
  `yearinstalled` int(11) DEFAULT NULL,
  `yearsused` int(11) DEFAULT NULL,
  `originalcost` decimal(16,2) NOT NULL,
  `freightcost` decimal(16,2) NOT NULL,
  `insurancecost` decimal(16,2) NOT NULL,
  `installationcost` decimal(16,2) NOT NULL,
  `brokeragecost` decimal(16,2) NOT NULL,
  `arrastrecost` decimal(16,2) NOT NULL,
  `othercost` decimal(16,2) NOT NULL,
  `acquisitioncost` decimal(16,2) NOT NULL,
  `feracid` varchar(50) DEFAULT NULL,
  `ferac` decimal(16,2) DEFAULT NULL,
  `forexid` varchar(50) DEFAULT NULL,
  `forex` decimal(16,4) DEFAULT NULL,
  `residualrate` decimal(16,2) NOT NULL,
  `conversionfactor` decimal(16,2) NOT NULL,
  `swornamount` decimal(16,2) NOT NULL,
  `useswornamount` int(11) NOT NULL,
  `imported` int(11) NOT NULL,
  `newlyinstalled` int(11) NOT NULL,
  `autodepreciate` int(11) NOT NULL,
  `taxable` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_machdetail_machforex` (`feracid`),
  KEY `FK_machdetail_machforexid` (`forexid`),
  KEY `FK_machdetail_machine` (`machine_objid`),
  KEY `FK_machdetail_machrpu` (`machrpuid`),
  KEY `FK_machdetail_machuse` (`machuseid`),
  CONSTRAINT `machdetail_ibfk_1` FOREIGN KEY (`feracid`) REFERENCES `machforex` (`objid`),
  CONSTRAINT `machdetail_ibfk_2` FOREIGN KEY (`forexid`) REFERENCES `machforex` (`objid`),
  CONSTRAINT `machdetail_ibfk_3` FOREIGN KEY (`machine_objid`) REFERENCES `machine` (`objid`),
  CONSTRAINT `machdetail_ibfk_4` FOREIGN KEY (`machrpuid`) REFERENCES `machrpu` (`objid`),
  CONSTRAINT `machdetail_ibfk_5` FOREIGN KEY (`machuseid`) REFERENCES `machuse` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machforex` */

DROP TABLE IF EXISTS `machforex`;

CREATE TABLE `machforex` (
  `objid` varchar(50) NOT NULL,
  `machrysettingid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `forex` decimal(10,6) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `machrysettingid` (`machrysettingid`),
  KEY `ix_machforex_previd` (`previd`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `machforex_ibfk_1` FOREIGN KEY (`machrysettingid`) REFERENCES `machrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machine` */

DROP TABLE IF EXISTS `machine`;

CREATE TABLE `machine` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_machine_code` (`code`),
  UNIQUE KEY `ux_machine_name` (`name`),
  KEY `ix_machine_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machrpu` */

DROP TABLE IF EXISTS `machrpu`;

CREATE TABLE `machrpu` (
  `objid` varchar(50) NOT NULL,
  `landrpuid` varchar(50) DEFAULT NULL,
  `bldgmaster_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_machrpu_landrpu` (`landrpuid`),
  CONSTRAINT `machrpu_ibfk_1` FOREIGN KEY (`landrpuid`) REFERENCES `landrpu` (`objid`),
  CONSTRAINT `machrpu_ibfk_2` FOREIGN KEY (`objid`) REFERENCES `rpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machrysetting` */

DROP TABLE IF EXISTS `machrysetting`;

CREATE TABLE `machrysetting` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `ry` int(11) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `appliedto` longtext,
  `residualrate` decimal(10,2) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `machuse` */

DROP TABLE IF EXISTS `machuse`;

CREATE TABLE `machuse` (
  `objid` varchar(50) NOT NULL,
  `machrpuid` varchar(50) NOT NULL,
  `actualuse_objid` varchar(50) NOT NULL,
  `basemarketvalue` decimal(16,2) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  `assesslevel` decimal(16,2) NOT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_machuse_machassesslevel` (`actualuse_objid`),
  KEY `FK_machuse_machrpu` (`machrpuid`),
  CONSTRAINT `machuse_ibfk_1` FOREIGN KEY (`actualuse_objid`) REFERENCES `machassesslevel` (`objid`),
  CONSTRAINT `machuse_ibfk_2` FOREIGN KEY (`machrpuid`) REFERENCES `machrpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `material` */

DROP TABLE IF EXISTS `material`;

CREATE TABLE `material` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_material_code` (`code`),
  UNIQUE KEY `ux_material_name` (`name`),
  KEY `ix_material_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `mcsettlement` */

DROP TABLE IF EXISTS `mcsettlement`;

CREATE TABLE `mcsettlement` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `memoranda` text,
  `prevfaas_objid` varchar(50) DEFAULT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `newtdno` varchar(25) DEFAULT NULL,
  `signatories` text NOT NULL,
  `lgutype` varchar(25) NOT NULL,
  `lguid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `newfaas_objid` (`newfaas_objid`),
  KEY `prevfaas_objid` (`prevfaas_objid`),
  KEY `ix_mcsettlement_state` (`state`),
  KEY `ix_mcsettlement_txnno` (`txnno`),
  CONSTRAINT `mcsettlement_ibfk_1` FOREIGN KEY (`newfaas_objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `mcsettlement_ibfk_2` FOREIGN KEY (`prevfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `mcsettlement_affectedrpu` */

DROP TABLE IF EXISTS `mcsettlement_affectedrpu`;

CREATE TABLE `mcsettlement_affectedrpu` (
  `objid` varchar(50) NOT NULL,
  `mcsettlementid` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `prevfaas_objid` varchar(50) NOT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `newtdno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_mcaffectedrpu_mcid` (`mcsettlementid`),
  KEY `ix_mcaffectedrpu_newfaas_objid` (`newfaas_objid`),
  KEY `ix_mcaffectedrpu_prevfaas_objid` (`prevfaas_objid`),
  CONSTRAINT `mcsettlement_affectedrpu_ibfk_1` FOREIGN KEY (`mcsettlementid`) REFERENCES `mcsettlement` (`objid`),
  CONSTRAINT `mcsettlement_affectedrpu_ibfk_2` FOREIGN KEY (`newfaas_objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `mcsettlement_affectedrpu_ibfk_3` FOREIGN KEY (`prevfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `mcsettlement_otherclaim` */

DROP TABLE IF EXISTS `mcsettlement_otherclaim`;

CREATE TABLE `mcsettlement_otherclaim` (
  `objid` varchar(50) NOT NULL,
  `mcsettlementid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_mcotherclaim_faas_objid` (`faas_objid`),
  KEY `ix_mcotherclaim_mcid` (`mcsettlementid`),
  CONSTRAINT `mcsettlement_otherclaim_ibfk_1` FOREIGN KEY (`faas_objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `mcsettlement_otherclaim_ibfk_2` FOREIGN KEY (`mcsettlementid`) REFERENCES `mcsettlement` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `memoranda_template` */

DROP TABLE IF EXISTS `memoranda_template`;

CREATE TABLE `memoranda_template` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(25) NOT NULL,
  `template` varchar(500) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscassesslevel` */

DROP TABLE IF EXISTS `miscassesslevel`;

CREATE TABLE `miscassesslevel` (
  `objid` varchar(50) NOT NULL,
  `miscrysettingid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `fixrate` int(11) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `miscrysettingid` (`miscrysettingid`),
  KEY `FK_miscassesslevel_classification` (`classification_objid`),
  KEY `ix_miscassesslevel_previd` (`previd`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `miscassesslevel_ibfk_1` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`),
  CONSTRAINT `miscassesslevel_ibfk_2` FOREIGN KEY (`miscrysettingid`) REFERENCES `miscrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscassesslevelrange` */

DROP TABLE IF EXISTS `miscassesslevelrange`;

CREATE TABLE `miscassesslevelrange` (
  `objid` varchar(50) NOT NULL,
  `miscassesslevelid` varchar(50) NOT NULL,
  `miscrysettingid` varchar(50) NOT NULL,
  `mvfrom` decimal(16,2) NOT NULL,
  `mvto` decimal(16,2) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_miscassesslevelrange_miscassesslevel` (`miscassesslevelid`),
  KEY `FK_miscassesslevelrange_miscrysetting` (`miscrysettingid`),
  CONSTRAINT `miscassesslevelrange_ibfk_1` FOREIGN KEY (`miscassesslevelid`) REFERENCES `miscassesslevel` (`objid`),
  CONSTRAINT `miscassesslevelrange_ibfk_2` FOREIGN KEY (`miscrysettingid`) REFERENCES `miscrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `misccollectiontype` */

DROP TABLE IF EXISTS `misccollectiontype`;

CREATE TABLE `misccollectiontype` (
  `objid` varchar(50) NOT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscitem` */

DROP TABLE IF EXISTS `miscitem`;

CREATE TABLE `miscitem` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_miscitem_code` (`code`),
  UNIQUE KEY `ux_miscitem_name` (`name`),
  KEY `ix_miscitem_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscitemvalue` */

DROP TABLE IF EXISTS `miscitemvalue`;

CREATE TABLE `miscitemvalue` (
  `objid` varchar(50) NOT NULL,
  `miscrysettingid` varchar(50) NOT NULL,
  `miscitem_objid` varchar(50) NOT NULL,
  `expr` varchar(100) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `miscrysettingid` (`miscrysettingid`),
  KEY `FK_miscitemvalue_miscitem` (`miscitem_objid`),
  KEY `ix_miscitemvalue_previd` (`previd`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `miscitemvalue_ibfk_1` FOREIGN KEY (`miscitem_objid`) REFERENCES `miscitem` (`objid`),
  CONSTRAINT `miscitemvalue_ibfk_2` FOREIGN KEY (`miscrysettingid`) REFERENCES `miscrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscrpu` */

DROP TABLE IF EXISTS `miscrpu`;

CREATE TABLE `miscrpu` (
  `objid` varchar(50) NOT NULL,
  `actualuse_objid` varchar(50) DEFAULT NULL,
  `landrpuid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_miscrpu_miscassesslevel` (`actualuse_objid`),
  CONSTRAINT `miscrpu_ibfk_1` FOREIGN KEY (`actualuse_objid`) REFERENCES `miscassesslevel` (`objid`),
  CONSTRAINT `miscrpu_ibfk_2` FOREIGN KEY (`objid`) REFERENCES `rpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscrpuitem` */

DROP TABLE IF EXISTS `miscrpuitem`;

CREATE TABLE `miscrpuitem` (
  `objid` varchar(50) NOT NULL,
  `miscrpuid` varchar(50) NOT NULL,
  `miv_objid` varchar(50) NOT NULL,
  `miscitem_objid` varchar(50) NOT NULL,
  `expr` varchar(255) NOT NULL,
  `depreciation` decimal(16,2) NOT NULL,
  `depreciatedvalue` decimal(16,2) NOT NULL,
  `basemarketvalue` decimal(16,2) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  `assesslevel` decimal(16,2) NOT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_miscrpuitem_miscitem` (`miscitem_objid`),
  KEY `FK_miscrpuitem_miscitemvalue` (`miv_objid`),
  KEY `FK_miscrpuitem_miscrpu` (`miscrpuid`),
  CONSTRAINT `miscrpuitem_ibfk_1` FOREIGN KEY (`miscitem_objid`) REFERENCES `miscitem` (`objid`),
  CONSTRAINT `miscrpuitem_ibfk_2` FOREIGN KEY (`miv_objid`) REFERENCES `miscitemvalue` (`objid`),
  CONSTRAINT `miscrpuitem_ibfk_3` FOREIGN KEY (`miscrpuid`) REFERENCES `miscrpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscrpuitem_rptparameter` */

DROP TABLE IF EXISTS `miscrpuitem_rptparameter`;

CREATE TABLE `miscrpuitem_rptparameter` (
  `miscrpuitemid` varchar(50) NOT NULL,
  `param_objid` varchar(50) NOT NULL,
  `miscrpuid` varchar(50) NOT NULL,
  `intvalue` int(11) DEFAULT NULL,
  `decimalvalue` decimal(16,2) NOT NULL,
  PRIMARY KEY (`miscrpuitemid`,`param_objid`),
  KEY `FK_miscrpuitem_rptparameter_` (`miscrpuid`),
  KEY `FK_miscrpuitem_rptparameter_rptparamer` (`param_objid`),
  CONSTRAINT `miscrpuitem_rptparameter_ibfk_1` FOREIGN KEY (`miscrpuid`) REFERENCES `miscrpu` (`objid`),
  CONSTRAINT `miscrpuitem_rptparameter_ibfk_2` FOREIGN KEY (`miscrpuitemid`) REFERENCES `miscrpuitem` (`objid`),
  CONSTRAINT `miscrpuitem_rptparameter_ibfk_3` FOREIGN KEY (`param_objid`) REFERENCES `rptparameter` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `miscrysetting` */

DROP TABLE IF EXISTS `miscrysetting`;

CREATE TABLE `miscrysetting` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `ry` int(11) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `appliedto` longtext,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_miscrysetting_ry` (`ry`),
  KEY `ix_miscrysetting_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `municipality` */

DROP TABLE IF EXISTS `municipality`;

CREATE TABLE `municipality` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `indexno` varchar(15) DEFAULT NULL,
  `pin` varchar(15) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `mayor_name` varchar(100) DEFAULT NULL,
  `mayor_title` varchar(50) DEFAULT NULL,
  `mayor_office` varchar(50) DEFAULT NULL,
  `assessor_name` varchar(100) DEFAULT NULL,
  `assessor_title` varchar(50) DEFAULT NULL,
  `assessor_office` varchar(50) DEFAULT NULL,
  `treasurer_name` varchar(100) DEFAULT NULL,
  `treasurer_title` varchar(50) DEFAULT NULL,
  `treasurer_office` varchar(50) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `fullname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_indexno` (`indexno`),
  KEY `ix_pin` (`pin`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `fk_municipality_org` FOREIGN KEY (`objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `municipality_taxaccount_mapping` */

DROP TABLE IF EXISTS `municipality_taxaccount_mapping`;

CREATE TABLE `municipality_taxaccount_mapping` (
  `lguid` varchar(50) NOT NULL,
  `basicadvacct_objid` varchar(50) DEFAULT NULL,
  `basicprevacct_objid` varchar(50) DEFAULT NULL,
  `basicprevintacct_objid` varchar(50) DEFAULT NULL,
  `basicprioracct_objid` varchar(50) DEFAULT NULL,
  `basicpriorintacct_objid` varchar(50) DEFAULT NULL,
  `basiccurracct_objid` varchar(50) DEFAULT NULL,
  `basiccurrintacct_objid` varchar(50) DEFAULT NULL,
  `sefadvacct_objid` varchar(50) DEFAULT NULL,
  `sefprevacct_objid` varchar(50) DEFAULT NULL,
  `sefprevintacct_objid` varchar(50) DEFAULT NULL,
  `sefprioracct_objid` varchar(50) DEFAULT NULL,
  `sefpriorintacct_objid` varchar(50) DEFAULT NULL,
  `sefcurracct_objid` varchar(50) DEFAULT NULL,
  `sefcurrintacct_objid` varchar(50) DEFAULT NULL,
  `basicidlecurracct_objid` varchar(50) DEFAULT NULL,
  `basicidlecurrintacct_objid` varchar(50) DEFAULT NULL,
  `basicidleprevacct_objid` varchar(50) DEFAULT NULL,
  `basicidleprevintacct_objid` varchar(50) DEFAULT NULL,
  `basicidleadvacct_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`lguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `payable_summary` */

DROP TABLE IF EXISTS `payable_summary`;

CREATE TABLE `payable_summary` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `checkpayment` */

DROP TABLE IF EXISTS `checkpayment`;

CREATE TABLE `checkpayment` (
  `objid` varchar(50) NOT NULL,
  `bankid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `amtused` decimal(16,4) DEFAULT NULL,
  `receivedfrom` varchar(255) DEFAULT NULL,
  `adviceid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL
  `depositvoucherid` varchar(50) DEFAULT NULL,
  `fundid` varchar(100) DEFAULT NULL,
  `depositslipid` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_checkpayment_depositvoucher` (`depositvoucherid`),
  KEY `fk_checkpayment_fund` (`fundid`),
  KEY `fk_checkpayment_depositslip` (`depositslipid`),
  CONSTRAINT `fk_checkpayment_depositvoucher` FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`),
  CONSTRAINT `fk_checkpayment_fund` FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`),
  CONSTRAINT `fk_checkpayment_depositslip` FOREIGN KEY (`depositslipid`) REFERENCES `depositslip` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `paymentorder` */

DROP TABLE IF EXISTS `paymentorder`;

CREATE TABLE `paymentorder` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `txntypename` varchar(100) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) DEFAULT NULL,
  `particulars` varchar(500) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `collectiontypeid` varchar(50) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `info` text,
  `origin` varchar(100) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `locationid` varchar(25) DEFAULT NULL,
  `items` mediumtext,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `paymentorder_type` */

DROP TABLE IF EXISTS `paymentorder_type`;

CREATE TABLE `paymentorder_type` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `collectiontype_objid` varchar(50) DEFAULT NULL,
  `queuesection` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_paymentorder_type_collectiontype` (`collectiontype_objid`),
  CONSTRAINT `fk_paymentorder_type_collectiontype` FOREIGN KEY (`collectiontype_objid`) REFERENCES `collectiontype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `paymentpartner` */

DROP TABLE IF EXISTS `paymentpartner`;

CREATE TABLE `paymentpartner` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `bankaccountid` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pin` */

DROP TABLE IF EXISTS `pin`;

CREATE TABLE `pin` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_lgu_barangay` (`barangayid`),
  KEY `ix_pin_state` (`state`),
  CONSTRAINT `pin_ibfk_1` FOREIGN KEY (`barangayid`) REFERENCES `barangay` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `planttree` */

DROP TABLE IF EXISTS `planttree`;

CREATE TABLE `planttree` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_planttree_code` (`code`),
  UNIQUE KEY `ux_planttree_name` (`name`),
  KEY `ix_planttree_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `planttreeassesslevel` */

DROP TABLE IF EXISTS `planttreeassesslevel`;

CREATE TABLE `planttreeassesslevel` (
  `objid` varchar(50) NOT NULL,
  `planttreerysettingid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) NOT NULL,
  `code` varchar(25) NOT NULL,
  `name` varchar(50) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `fixrate` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `planttreerysettingid` (`planttreerysettingid`),
  CONSTRAINT `planttreeassesslevel_ibfk_1` FOREIGN KEY (`planttreerysettingid`) REFERENCES `planttreerysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `planttreedetail` */

DROP TABLE IF EXISTS `planttreedetail`;

CREATE TABLE `planttreedetail` (
  `objid` varchar(50) NOT NULL,
  `planttreerpuid` varchar(50) DEFAULT NULL,
  `landrpuid` varchar(50) DEFAULT NULL,
  `planttreeunitvalue_objid` varchar(50) NOT NULL,
  `planttree_objid` varchar(50) NOT NULL,
  `actualuse_objid` varchar(50) NOT NULL,
  `productive` decimal(16,2) NOT NULL,
  `nonproductive` decimal(16,2) NOT NULL,
  `nonproductiveage` varchar(25) DEFAULT NULL,
  `unitvalue` decimal(16,2) NOT NULL,
  `basemarketvalue` decimal(16,2) NOT NULL,
  `adjustment` decimal(16,2) NOT NULL,
  `adjustmentrate` decimal(16,2) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  `assesslevel` decimal(16,2) NOT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  `areacovered` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_planttreedetail_landrpu` (`landrpuid`),
  KEY `FK_planttreedetail_plantreeassesslevel` (`actualuse_objid`),
  KEY `FK_planttreedetail_planttree` (`planttree_objid`),
  KEY `FK_planttreedetail_planttreerpu` (`planttreerpuid`),
  KEY `FK_planttreedetail_planttreeunitvalue` (`planttreeunitvalue_objid`),
  CONSTRAINT `planttreedetail_ibfk_1` FOREIGN KEY (`landrpuid`) REFERENCES `landrpu` (`objid`),
  CONSTRAINT `planttreedetail_ibfk_2` FOREIGN KEY (`actualuse_objid`) REFERENCES `planttreeassesslevel` (`objid`),
  CONSTRAINT `planttreedetail_ibfk_3` FOREIGN KEY (`planttree_objid`) REFERENCES `planttree` (`objid`),
  CONSTRAINT `planttreedetail_ibfk_4` FOREIGN KEY (`planttreerpuid`) REFERENCES `planttreerpu` (`objid`),
  CONSTRAINT `planttreedetail_ibfk_5` FOREIGN KEY (`planttreeunitvalue_objid`) REFERENCES `planttreeunitvalue` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `planttreerpu` */

DROP TABLE IF EXISTS `planttreerpu`;

CREATE TABLE `planttreerpu` (
  `objid` varchar(50) NOT NULL,
  `landrpuid` varchar(50) NOT NULL,
  `productive` decimal(16,2) NOT NULL,
  `nonproductive` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_planttreerpu_landrpu` (`landrpuid`),
  CONSTRAINT `planttreerpu_ibfk_1` FOREIGN KEY (`landrpuid`) REFERENCES `landrpu` (`objid`),
  CONSTRAINT `planttreerpu_ibfk_2` FOREIGN KEY (`objid`) REFERENCES `rpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `planttreerysetting` */

DROP TABLE IF EXISTS `planttreerysetting`;

CREATE TABLE `planttreerysetting` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) NOT NULL,
  `ry` int(11) NOT NULL,
  `applyagriadjustment` int(11) DEFAULT NULL,
  `appliedto` longtext,
  `previd` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `previd` (`previd`),
  KEY `ix_planttreerysetting_ry` (`ry`),
  CONSTRAINT `planttreerysetting_ibfk_1` FOREIGN KEY (`previd`) REFERENCES `planttreerysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `planttreeunitvalue` */

DROP TABLE IF EXISTS `planttreeunitvalue`;

CREATE TABLE `planttreeunitvalue` (
  `objid` varchar(50) NOT NULL,
  `planttreerysettingid` varchar(50) NOT NULL,
  `planttree_objid` varchar(50) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(25) NOT NULL,
  `unitvalue` decimal(10,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `planttreerysettingid` (`planttreerysettingid`),
  KEY `FK_planttreeunitvalue_planttree` (`planttree_objid`),
  CONSTRAINT `planttreeunitvalue_ibfk_1` FOREIGN KEY (`planttree_objid`) REFERENCES `planttree` (`objid`),
  CONSTRAINT `planttreeunitvalue_ibfk_2` FOREIGN KEY (`planttreerysettingid`) REFERENCES `planttreerysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `previousfaas` */

DROP TABLE IF EXISTS `previousfaas`;

CREATE TABLE `previousfaas` (
  `faasid` varchar(50) NOT NULL,
  `prevfaasid` varchar(50) NOT NULL,
  PRIMARY KEY (`faasid`,`prevfaasid`),
  KEY `FK_previousfaas_prevfaas` (`prevfaasid`),
  CONSTRAINT `previousfaas_ibfk_1` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `previousfaas_ibfk_2` FOREIGN KEY (`prevfaasid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `profession` */

DROP TABLE IF EXISTS `profession`;

CREATE TABLE `profession` (
  `objid` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `propertyclassification` */

DROP TABLE IF EXISTS `propertyclassification`;

CREATE TABLE `propertyclassification` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `special` int(11) NOT NULL,
  `orderno` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_propertyclassification_code` (`code`),
  UNIQUE KEY `ux_propertyclassification_name` (`name`),
  KEY `ix_propertyclassification_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `propertypayer` */

DROP TABLE IF EXISTS `propertypayer`;

CREATE TABLE `propertypayer` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `taxpayer_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_propertypayer_taxpayerid` (`taxpayer_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `propertypayer_item` */

DROP TABLE IF EXISTS `propertypayer_item`;

CREATE TABLE `propertypayer_item` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `parentid` varchar(50) NOT NULL,
  `rptledger_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_propertypayeritem_rptledgerid` (`parentid`,`rptledger_objid`),
  KEY `ix_propertypayeritem_parentid` (`parentid`),
  KEY `ix_propertypayeritem_rptledgerid` (`rptledger_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `province` */

DROP TABLE IF EXISTS `province`;

CREATE TABLE `province` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `indexno` varchar(15) DEFAULT NULL,
  `pin` varchar(15) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `governor_name` varchar(100) DEFAULT NULL,
  `governor_title` varchar(50) DEFAULT NULL,
  `governor_office` varchar(50) DEFAULT NULL,
  `assessor_name` varchar(100) DEFAULT NULL,
  `assessor_title` varchar(50) DEFAULT NULL,
  `assessor_office` varchar(50) DEFAULT NULL,
  `treasurer_name` varchar(100) DEFAULT NULL,
  `treasurer_title` varchar(50) DEFAULT NULL,
  `treasurer_office` varchar(50) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `fullname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_indexno` (`indexno`),
  KEY `ix_pin` (`pin`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_previd` (`previd`),
  CONSTRAINT `fk_province_org` FOREIGN KEY (`objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `province_taxaccount_mapping` */

DROP TABLE IF EXISTS `province_taxaccount_mapping`;

CREATE TABLE `province_taxaccount_mapping` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `basicadvacct_objid` varchar(50) DEFAULT NULL,
  `basicprevacct_objid` varchar(50) DEFAULT NULL,
  `basicprevintacct_objid` varchar(50) DEFAULT NULL,
  `basicprioracct_objid` varchar(50) DEFAULT NULL,
  `basicpriorintacct_objid` varchar(50) DEFAULT NULL,
  `basiccurracct_objid` varchar(50) DEFAULT NULL,
  `basiccurrintacct_objid` varchar(50) DEFAULT NULL,
  `sefadvacct_objid` varchar(50) DEFAULT NULL,
  `sefprevacct_objid` varchar(50) DEFAULT NULL,
  `sefprevintacct_objid` varchar(50) DEFAULT NULL,
  `sefprioracct_objid` varchar(50) DEFAULT NULL,
  `sefpriorintacct_objid` varchar(50) DEFAULT NULL,
  `sefcurracct_objid` varchar(50) DEFAULT NULL,
  `sefcurrintacct_objid` varchar(50) DEFAULT NULL,
  `basicidlecurracct_objid` varchar(50) DEFAULT NULL,
  `basicidlecurrintacct_objid` varchar(50) DEFAULT NULL,
  `basicidleprevacct_objid` varchar(50) DEFAULT NULL,
  `basicidleprevintacct_objid` varchar(50) DEFAULT NULL,
  `basicidleadvacct_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `realproperty` */

DROP TABLE IF EXISTS `realproperty`;

CREATE TABLE `realproperty` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `autonumber` int(11) NOT NULL,
  `pintype` varchar(5) NOT NULL,
  `pin` varchar(30) NOT NULL,
  `ry` int(11) NOT NULL,
  `claimno` varchar(5) DEFAULT NULL,
  `section` varchar(3) DEFAULT NULL,
  `parcel` varchar(3) DEFAULT NULL,
  `cadastrallotno` text,
  `blockno` varchar(255) DEFAULT NULL,
  `surveyno` varchar(255) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `purok` varchar(100) DEFAULT NULL,
  `north` varchar(500) DEFAULT NULL,
  `south` varchar(500) DEFAULT NULL,
  `east` varchar(500) DEFAULT NULL,
  `west` varchar(500) DEFAULT NULL,
  `barangayid` varchar(50) NOT NULL,
  `lgutype` varchar(50) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `lguid` varchar(50) DEFAULT NULL,
  `stewardshipno` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`),
  KEY `ix_realproperty_blockno` (`blockno`),
  KEY `ix_realproperty_pin` (`pin`),
  KEY `ix_realproperty_ry` (`ry`),
  KEY `ix_realproperty_surveyno` (`surveyno`),
  KEY `ix_realproperty_claimno` (`claimno`),
  CONSTRAINT `realproperty_ibfk_1` FOREIGN KEY (`barangayid`) REFERENCES `barangay` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `religion` */

DROP TABLE IF EXISTS `religion`;

CREATE TABLE `religion` (
  `objid` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `remittance` */

DROP TABLE IF EXISTS `remittance`;

CREATE TABLE `remittance` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `controlno` varchar(50) NOT NULL,
  `controldate` datetime DEFAULT NULL,
  `dtposted` datetime NOT NULL,
  `collector_objid` varchar(50) NOT NULL,
  `collector_name` varchar(100) NOT NULL,
  `collector_title` varchar(50) NOT NULL,
  `liquidatingofficer_objid` varchar(50) DEFAULT NULL,
  `liquidatingofficer_name` varchar(100) DEFAULT NULL,
  `liquidatingofficer_title` varchar(50) DEFAULT NULL,
  `liquidatingofficer_signature` longtext,
  `amount` decimal(18,2) NOT NULL,
  `totalcash` decimal(18,2) NOT NULL,
  `totalcheck` decimal(16,4) DEFAULT NULL,
  `cashbreakdown` text NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `collector_signature` longtext,
  `collectionvoucherid` varchar(50) DEFAULT NULL,
  `totalcr` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_txnno` (`controlno`),
  KEY `ix_state` (`state`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_collector_objid` (`collector_objid`),
  KEY `ix_liquidatingofficer_objid` (`liquidatingofficer_objid`),
  KEY `ix_remittancedate` (`controldate`),
  KEY `fk_remittance_collectionvoucher` (`collectionvoucherid`),
  CONSTRAINT `fk_remittance_collectionvoucher` FOREIGN KEY (`collectionvoucherid`) REFERENCES `collectionvoucher` (`objid`),
  CONSTRAINT `fk_remittance_collector` FOREIGN KEY (`collector_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `fk_remittance_liqofficer` FOREIGN KEY (`liquidatingofficer_objid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `remittance_af` */

DROP TABLE IF EXISTS `remittance_af`;

CREATE TABLE `remittance_af` (
  `objid` varchar(150) NOT NULL,
  `remittanceid` varchar(50) DEFAULT NULL,
  `controlid` varchar(50) DEFAULT NULL,
  `receivedstartseries` int(11) DEFAULT NULL,
  `receivedendseries` int(11) DEFAULT NULL,
  `beginstartseries` int(11) DEFAULT NULL,
  `beginendseries` int(11) DEFAULT NULL,
  `issuedstartseries` int(11) DEFAULT NULL,
  `issuedendseries` int(11) DEFAULT NULL,
  `endingstartseries` int(11) DEFAULT NULL,
  `endingendseries` int(11) DEFAULT NULL,
  `qtyreceived` int(11) DEFAULT NULL,
  `qtybegin` int(11) DEFAULT NULL,
  `qtyissued` int(11) DEFAULT NULL,
  `qtyending` int(11) DEFAULT NULL,
  `qtycancelled` int(11) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_remittanceid` (`remittanceid`),
  KEY `ix_controlid` (`controlid`),
  CONSTRAINT `fk_remittance_af_remittanceid` FOREIGN KEY (`remittanceid`) REFERENCES `remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `remittance_fund` */

DROP TABLE IF EXISTS `remittance_fund`;

CREATE TABLE `remittance_fund` (
  `objid` varchar(100) NOT NULL,
  `remittanceid` varchar(50) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_title` varchar(100) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `totalcash` decimal(16,4) DEFAULT NULL,
  `totalcheck` decimal(16,4) DEFAULT NULL,
  `totalcr` decimal(16,4) DEFAULT NULL,
  `cashbreakdown` text,
  PRIMARY KEY (`objid`),
  KEY `ix_remittanceid` (`remittanceid`),
  KEY `ix_fund_objid` (`fund_objid`),
  KEY `objid` (`objid`),
  CONSTRAINT `fk_remittance_fund_fund` FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`),
  CONSTRAINT `fk_remittance_fund_remittanceid` FOREIGN KEY (`remittanceid`) REFERENCES `remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `remoteserverdata` */

DROP TABLE IF EXISTS `remoteserverdata`;

CREATE TABLE `remoteserverdata` (
  `objid` varchar(50) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `report_rptdelinquency` */

DROP TABLE IF EXISTS `report_rptdelinquency`;

CREATE TABLE `report_rptdelinquency` (
  `objid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicdisc` decimal(16,2) NOT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `sefdisc` decimal(16,2) NOT NULL,
  `firecode` decimal(16,2) NOT NULL,
  `dtgenerated` datetime NOT NULL,
  `generatedby_name` varchar(75) DEFAULT NULL,
  `generatedby_title` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_report_rptdelinquency_rptledgerid` (`rptledgerid`),
  KEY `ix_report_rptdelinquency_barangayid` (`barangayid`),
  KEY `ix_report_rptdelinquency_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `requirement_type` */

DROP TABLE IF EXISTS `requirement_type`;

CREATE TABLE `requirement_type` (
  `code` varchar(10) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `resection` */

DROP TABLE IF EXISTS `resection`;

CREATE TABLE `resection` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `pintype` varchar(5) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `barangaypin` varchar(15) NOT NULL,
  `section` varchar(3) NOT NULL,
  `ry` int(11) NOT NULL,
  `txntype_objid` varchar(5) NOT NULL,
  `txnno` varchar(10) NOT NULL,
  `txndate` datetime NOT NULL,
  `autonumber` int(11) NOT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `memoranda` text NOT NULL,
  `signatories` text,
  PRIMARY KEY (`objid`),
  KEY `txntype_objid` (`txntype_objid`),
  KEY `barangayid` (`barangayid`),
  CONSTRAINT `resection_ibfk_1` FOREIGN KEY (`txntype_objid`) REFERENCES `faas_txntype` (`objid`),
  CONSTRAINT `resection_ibfk_2` FOREIGN KEY (`barangayid`) REFERENCES `barangay` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `resectionaffectedrpu` */

DROP TABLE IF EXISTS `resectionaffectedrpu`;

CREATE TABLE `resectionaffectedrpu` (
  `objid` varchar(50) NOT NULL,
  `resectionid` varchar(50) NOT NULL,
  `rputype` varchar(10) NOT NULL,
  `prevfaasid` varchar(50) NOT NULL,
  `prevrpuid` varchar(50) NOT NULL,
  `prevrpid` varchar(50) NOT NULL,
  `newsection` varchar(3) DEFAULT NULL,
  `newparcel` varchar(3) DEFAULT NULL,
  `newtdno` varchar(20) DEFAULT NULL,
  `newutdno` varchar(20) NOT NULL,
  `newpin` varchar(25) DEFAULT NULL,
  `newsuffix` int(11) DEFAULT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `newrpuid` varchar(50) DEFAULT NULL,
  `newrpid` varchar(50) DEFAULT NULL,
  `memoranda` text,
  PRIMARY KEY (`objid`),
  KEY `newfaasid` (`newfaasid`),
  KEY `newrpid` (`newrpid`),
  KEY `newrpuid` (`newrpuid`),
  KEY `prevfaasid` (`prevfaasid`),
  KEY `prevrpid` (`prevrpid`),
  KEY `prevrpuid` (`prevrpuid`),
  KEY `resectionid` (`resectionid`),
  CONSTRAINT `resectionaffectedrpu_ibfk_1` FOREIGN KEY (`newfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `resectionaffectedrpu_ibfk_2` FOREIGN KEY (`newrpid`) REFERENCES `realproperty` (`objid`),
  CONSTRAINT `resectionaffectedrpu_ibfk_3` FOREIGN KEY (`newrpuid`) REFERENCES `rpu` (`objid`),
  CONSTRAINT `resectionaffectedrpu_ibfk_4` FOREIGN KEY (`prevfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `resectionaffectedrpu_ibfk_5` FOREIGN KEY (`prevrpid`) REFERENCES `realproperty` (`objid`),
  CONSTRAINT `resectionaffectedrpu_ibfk_6` FOREIGN KEY (`prevrpuid`) REFERENCES `rpu` (`objid`),
  CONSTRAINT `resectionaffectedrpu_ibfk_7` FOREIGN KEY (`resectionid`) REFERENCES `resection` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `resectionitem` */

DROP TABLE IF EXISTS `resectionitem`;

CREATE TABLE `resectionitem` (
  `objid` varchar(50) NOT NULL,
  `resectionid` varchar(50) NOT NULL,
  `newsection` varchar(3) NOT NULL,
  `landcount` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `resectionid` (`resectionid`),
  CONSTRAINT `resectionitem_ibfk_1` FOREIGN KEY (`resectionid`) REFERENCES `resection` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpt_changeinfo` */

DROP TABLE IF EXISTS `rpt_changeinfo`;

CREATE TABLE `rpt_changeinfo` (
  `objid` varchar(50) NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `rpid` varchar(50) DEFAULT NULL,
  `rpuid` varchar(50) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `reason` text NOT NULL,
  `newinfo` text NOT NULL,
  `previnfo` text NOT NULL,
  `dtposted` datetime NOT NULL,
  `postedbyid` varchar(50) DEFAULT NULL,
  `postedby` varchar(100) NOT NULL,
  `postedbytitle` varchar(100) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `redflagid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpt_redflag` */

DROP TABLE IF EXISTS `rpt_redflag`;

CREATE TABLE `rpt_redflag` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(30) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(15) NOT NULL,
  `caseno` varchar(25) NOT NULL,
  `message` text NOT NULL,
  `filedby_date` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(150) NOT NULL,
  `action` varchar(50) NOT NULL,
  `resolvedby_objid` varchar(50) DEFAULT NULL,
  `resolvedby_name` varchar(150) DEFAULT NULL,
  `resolvedby_date` datetime DEFAULT NULL,
  `lguid` varchar(15) NOT NULL,
  `dtclosed` datetime DEFAULT NULL,
  `remarks` text,
  `info` text,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptredflag_caseno` (`caseno`),
  KEY `ix_rptredflag_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpt_requirement` */

DROP TABLE IF EXISTS `rpt_requirement`;

CREATE TABLE `rpt_requirement` (
  `objid` varchar(50) NOT NULL,
  `requirementtypeid` varchar(50) NOT NULL,
  `handler` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `value_objid` varchar(50) DEFAULT NULL,
  `value_txnno` varchar(50) DEFAULT NULL,
  `value_txndate` date DEFAULT NULL,
  `value_txnamount` decimal(16,2) DEFAULT NULL,
  `value_remarks` text,
  `complied` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptrequirement_refid` (`refid`),
  KEY `ix_rptrequirement_requirementtypeid` (`requirementtypeid`),
  KEY `ix_rptrequirement_valueobjid` (`value_objid`),
  CONSTRAINT `rpt_requirement_ibfk_1` FOREIGN KEY (`requirementtypeid`) REFERENCES `rpt_requirement_type` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpt_requirement_type` */

DROP TABLE IF EXISTS `rpt_requirement_type`;

CREATE TABLE `rpt_requirement_type` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(150) DEFAULT NULL,
  `handler` varchar(100) DEFAULT NULL,
  `sortorder` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_rptrequirementtype_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpt_sales_data` */

DROP TABLE IF EXISTS `rpt_sales_data`;

CREATE TABLE `rpt_sales_data` (
  `objid` varchar(50) NOT NULL,
  `seller_name` varchar(250) NOT NULL,
  `seller_address` varchar(100) NOT NULL,
  `buyer_name` varchar(250) NOT NULL,
  `buyer_address` varchar(100) NOT NULL,
  `saledate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `remarks` text,
  PRIMARY KEY (`objid`),
  KEY `ix_buyername` (`buyer_name`),
  KEY `ix_sellername` (`seller_name`),
  CONSTRAINT `rpt_sales_data_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpt_sms` */

DROP TABLE IF EXISTS `rpt_sms`;

CREATE TABLE `rpt_sms` (
  `objid` varchar(50) NOT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `phoneno` varchar(50) NOT NULL,
  `logdate` datetime NOT NULL,
  `message` text,
  `amount` decimal(10,2) NOT NULL,
  `amtpaid` decimal(10,2) NOT NULL,
  `action` varchar(100) DEFAULT NULL,
  `status` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptsms_phoneno` (`phoneno`),
  KEY `ix_rptsms_traceid` (`traceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpt_sms_registration` */

DROP TABLE IF EXISTS `rpt_sms_registration`;

CREATE TABLE `rpt_sms_registration` (
  `phoneno` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `dtregistered` datetime NOT NULL,
  PRIMARY KEY (`phoneno`,`refid`),
  KEY `ix_rptsmsreg_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptbill` */

DROP TABLE IF EXISTS `rptbill`;

CREATE TABLE `rptbill` (
  `objid` varchar(50) NOT NULL,
  `taxpayer_objid` varchar(50) NOT NULL,
  `barcode` varchar(25) NOT NULL,
  `expirydate` date NOT NULL,
  `postedby` varchar(100) NOT NULL,
  `postedbytitle` varchar(50) DEFAULT NULL,
  `billtoyear` int(11) DEFAULT NULL,
  `billtoqtr` int(11) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `taxpayer_name` text,
  `taxpayer_address` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `taxpayer_objid` (`taxpayer_objid`),
  CONSTRAINT `rptbill_ibfk_1` FOREIGN KEY (`taxpayer_objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptbill_ledger` */

DROP TABLE IF EXISTS `rptbill_ledger`;

CREATE TABLE `rptbill_ledger` (
  `rptledgerid` varchar(50) NOT NULL DEFAULT '',
  `billid` varchar(50) NOT NULL DEFAULT '',
  `updateflag` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`rptledgerid`,`billid`),
  KEY `rptbillid` (`billid`),
  KEY `rptledgerid` (`rptledgerid`),
  CONSTRAINT `FK_rptbillledger_rptbill` FOREIGN KEY (`billid`) REFERENCES `rptbill` (`objid`),
  CONSTRAINT `FK_rptbillledger_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptcertification` */

DROP TABLE IF EXISTS `rptcertification`;

CREATE TABLE `rptcertification` (
  `objid` varchar(50) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime NOT NULL,
  `opener` varchar(50) NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `taxpayer_name` longtext NOT NULL,
  `taxpayer_address` varchar(150) DEFAULT NULL,
  `requestedby` longtext NOT NULL,
  `requestedbyaddress` varchar(100) NOT NULL,
  `purpose` text,
  `certifiedby` varchar(150) NOT NULL,
  `certifiedbytitle` varchar(50) NOT NULL,
  `byauthority` varchar(150) DEFAULT NULL,
  `byauthoritytitle` varchar(50) DEFAULT NULL,
  `official` int(11) NOT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` datetime DEFAULT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `stampamount` decimal(16,2) NOT NULL,
  `createdbyid` varchar(50) DEFAULT NULL,
  `createdby` varchar(150) NOT NULL,
  `createdbytitle` varchar(50) NOT NULL,
  `office` varchar(50) DEFAULT NULL,
  `addlinfo` text,
  `attestedby` varchar(150) DEFAULT NULL,
  `attestedbytitle` varchar(50) DEFAULT NULL,
  `asofyear` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `qtr` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rptcertification_faas` (`faasid`),
  KEY `ix_rptcertification_office` (`office`),
  KEY `ix_rptcertification_office_txnno` (`office`,`txnno`),
  KEY `ix_rptcertification_taxpayerid` (`taxpayer_objid`),
  KEY `createdbyid` (`createdbyid`),
  CONSTRAINT `rptcertification_ibfk_1` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `rptcertification_ibfk_2` FOREIGN KEY (`taxpayer_objid`) REFERENCES `entity` (`objid`),
  CONSTRAINT `rptcertification_ibfk_3` FOREIGN KEY (`createdbyid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptcertificationitem` */

DROP TABLE IF EXISTS `rptcertificationitem`;

CREATE TABLE `rptcertificationitem` (
  `rptcertificationid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  KEY `FK_rptcertificationitem_rptcertification` (`rptcertificationid`),
  KEY `ix_rptcertificationitem_refid` (`refid`),
  CONSTRAINT `rptcertificationitem_ibfk_1` FOREIGN KEY (`rptcertificationid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptexpiry` */

DROP TABLE IF EXISTS `rptexpiry`;

CREATE TABLE `rptexpiry` (
  `iyear` int(11) NOT NULL,
  `iqtr` int(11) NOT NULL,
  `expirytype` varchar(50) NOT NULL,
  `expirydate` datetime DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`iqtr`,`iyear`,`expirytype`),
  KEY `ix_rptexpiry_yrqtr` (`iyear`,`iqtr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger` */

DROP TABLE IF EXISTS `rptledger`;

CREATE TABLE `rptledger` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `nextbilldate` date DEFAULT NULL,
  `lastyearpaid` int(11) NOT NULL,
  `lastqtrpaid` int(11) NOT NULL,
  `firstqtrpaidontime` int(11) DEFAULT NULL,
  `qtrlypaymentavailed` int(11) DEFAULT NULL,
  `qtrlypaymentpaidontime` int(11) DEFAULT NULL,
  `lastitemyear` int(11) DEFAULT NULL,
  `lastreceiptid` varchar(50) DEFAULT NULL,
  `barangayid` varchar(50) NOT NULL,
  `advancebill` int(11) DEFAULT NULL,
  `lastbilledyear` int(11) DEFAULT NULL,
  `lastbilledqtr` int(11) DEFAULT NULL,
  `partialbasic` decimal(16,2) DEFAULT NULL,
  `partialbasicint` decimal(16,2) DEFAULT NULL,
  `partialbasicdisc` decimal(16,2) DEFAULT NULL,
  `partialsef` decimal(16,2) DEFAULT NULL,
  `partialsefint` decimal(16,2) DEFAULT NULL,
  `partialsefdisc` decimal(16,2) DEFAULT NULL,
  `partialledyear` int(11) DEFAULT NULL,
  `partialledqtr` int(11) DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `fullpin` varchar(30) NOT NULL DEFAULT '',
  `tdno` varchar(20) DEFAULT NULL,
  `cadastrallotno` varchar(50) DEFAULT NULL,
  `rputype` varchar(12) DEFAULT NULL,
  `txntype_objid` varchar(5) DEFAULT NULL,
  `classcode` varchar(5) DEFAULT NULL,
  `totalav` decimal(16,2) DEFAULT NULL,
  `totalmv` decimal(16,2) DEFAULT NULL,
  `totalareaha` decimal(16,6) DEFAULT NULL,
  `taxable` int(255) DEFAULT NULL,
  `owner_name` varchar(1000) DEFAULT NULL,
  `prevtdno` varchar(1000) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `titleno` varchar(30) DEFAULT NULL,
  `undercompromise` int(11) DEFAULT NULL,
  `updateflag` varchar(50) DEFAULT NULL,
  `forcerecalcbill` int(11) DEFAULT NULL,
  `administrator_name` varchar(150) DEFAULT NULL,
  `blockno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptledger_tdno` (`tdno`),
  KEY `barangayid` (`barangayid`),
  KEY `ix_rptledger_faasid` (`faasid`),
  KEY `ix_rptledger_state` (`state`),
  KEY `ix_rptledger_state_barangay` (`state`,`barangayid`),
  KEY `ix_rptledger_state_faasid` (`state`,`faasid`),
  KEY `ix_rptledger_state_lastyearpaid` (`state`,`lastyearpaid`),
  KEY `ix_rptledgerlastyearpaidqtr` (`lastyearpaid`,`lastqtrpaid`),
  KEY `ix_rptledger_taxpayerid` (`taxpayer_objid`),
  KEY `ix_rptledger_cadastrallotno` (`cadastrallotno`),
  KEY `ix_rptledger_administartorname` (`administrator_name`),
  KEY `ix_rptledger_blockno` (`blockno`),
  CONSTRAINT `FK_rptledger_taxpayer` FOREIGN KEY (`taxpayer_objid`) REFERENCES `entity` (`objid`),
  CONSTRAINT `rptledger_ibfk_1` FOREIGN KEY (`barangayid`) REFERENCES `barangay` (`objid`),
  CONSTRAINT `rptledger_ibfk_2` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_compromise` */

DROP TABLE IF EXISTS `rptledger_compromise`;

CREATE TABLE `rptledger_compromise` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `state` varchar(25) NOT NULL DEFAULT '',
  `txnno` varchar(25) NOT NULL DEFAULT '',
  `txndate` date NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `rptledgerid` varchar(50) NOT NULL DEFAULT '',
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
  `firstpartyname` varchar(100) NOT NULL DEFAULT '',
  `firstpartytitle` varchar(50) NOT NULL DEFAULT '',
  `firstpartyaddress` varchar(100) NOT NULL DEFAULT '',
  `firstpartyctcno` varchar(15) NOT NULL DEFAULT '',
  `firstpartyctcissued` varchar(100) NOT NULL DEFAULT '',
  `firstpartyctcdate` date NOT NULL,
  `firstpartynationality` varchar(50) NOT NULL DEFAULT '',
  `firstpartystatus` varchar(50) NOT NULL DEFAULT '',
  `firstpartygender` varchar(10) NOT NULL DEFAULT '',
  `secondpartyrepresentative` varchar(100) NOT NULL DEFAULT '',
  `secondpartyname` varchar(100) NOT NULL DEFAULT '',
  `secondpartyaddress` varchar(100) NOT NULL DEFAULT '',
  `secondpartyctcno` varchar(15) NOT NULL DEFAULT '',
  `secondpartyctcissued` varchar(100) NOT NULL DEFAULT '',
  `secondpartyctcdate` date NOT NULL,
  `secondpartynationality` varchar(50) NOT NULL DEFAULT '',
  `secondpartystatus` varchar(50) NOT NULL DEFAULT '',
  `secondpartygender` varchar(10) NOT NULL DEFAULT '',
  `dtsigned` date DEFAULT NULL,
  `notarizeddate` date DEFAULT NULL,
  `notarizedby` varchar(100) DEFAULT NULL,
  `notarizedbytitle` varchar(50) DEFAULT NULL,
  `signatories` varchar(1000) NOT NULL DEFAULT '',
  `manualdiff` decimal(16,2) NOT NULL DEFAULT '0.00',
  `cypaymentreceiptid` varchar(50) DEFAULT NULL,
  `downpaymentreceiptid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptcompromise_faasid` (`faasid`),
  KEY `ix_rptcompromise_ledgerid` (`rptledgerid`),
  CONSTRAINT `FK_rptleger_compromise_faas` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `FK_rptleger_compromise_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_compromise_credit` */

DROP TABLE IF EXISTS `rptledger_compromise_credit`;

CREATE TABLE `rptledger_compromise_credit` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rptcompromiseid` varchar(50) NOT NULL DEFAULT '',
  `rptreceiptid` varchar(50) DEFAULT NULL,
  `installmentid` varchar(50) DEFAULT NULL,
  `collector_name` varchar(100) NOT NULL DEFAULT '',
  `collector_title` varchar(50) NOT NULL DEFAULT '',
  `orno` varchar(10) NOT NULL DEFAULT '',
  `ordate` date NOT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `mode` varchar(50) NOT NULL DEFAULT '',
  `paidby` varchar(150) NOT NULL DEFAULT '',
  `paidbyaddress` varchar(100) NOT NULL DEFAULT '',
  `partial` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptcompromise_credit_rptcompromiseid` (`rptcompromiseid`),
  KEY `ix_rptcompromise_credit_receiptid` (`rptreceiptid`),
  KEY `ix_rptcompromise_credit_installmentid` (`installmentid`),
  CONSTRAINT `FK_rptleger_compromise_credit_installment` FOREIGN KEY (`installmentid`) REFERENCES `rptledger_compromise_installment` (`objid`),
  CONSTRAINT `FK_rptleger_compromise_credit_receipt` FOREIGN KEY (`rptreceiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `FK_rptleger_compromise_credit_rptcompromise` FOREIGN KEY (`rptcompromiseid`) REFERENCES `rptledger_compromise` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_compromise_installment` */

DROP TABLE IF EXISTS `rptledger_compromise_installment`;

CREATE TABLE `rptledger_compromise_installment` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rptcompromiseid` varchar(50) NOT NULL DEFAULT '',
  `installmentno` int(11) NOT NULL,
  `duedate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `fullypaid` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptcompromise_installment_rptcompromiseid` (`rptcompromiseid`),
  CONSTRAINT `FK_rptleger_compromise_installment_rptcompromise` FOREIGN KEY (`rptcompromiseid`) REFERENCES `rptledger_compromise` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_compromise_item` */

DROP TABLE IF EXISTS `rptledger_compromise_item`;

CREATE TABLE `rptledger_compromise_item` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rptcompromiseid` varchar(50) NOT NULL DEFAULT '',
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  `tdno` varchar(25) NOT NULL DEFAULT '',
  `classcode` varchar(10) NOT NULL DEFAULT '',
  `actualusecode` varchar(10) NOT NULL DEFAULT '',
  `basic` decimal(16,2) NOT NULL,
  `basicpaid` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicintpaid` decimal(16,2) NOT NULL,
  `basicidle` decimal(16,2) NOT NULL,
  `basicidlepaid` decimal(16,2) NOT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefpaid` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `sefintpaid` decimal(16,2) NOT NULL,
  `firecode` decimal(16,2) NOT NULL,
  `firecodepaid` decimal(16,2) NOT NULL,
  `total` decimal(16,2) NOT NULL,
  `fullypaid` int(11) NOT NULL,
  `basicidleint` decimal(16,4) NOT NULL,
  `basicidleintpaid` decimal(16,4) NOT NULL,
  `sh` decimal(16,2) DEFAULT NULL,
  `shpaid` decimal(16,2) DEFAULT NULL,
  `shint` decimal(16,2) DEFAULT NULL,
  `shintpaid` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptcompromise_item_rptcompromise` (`rptcompromiseid`),
  KEY `ix_rptcompromise_item_faas` (`faasid`),
  CONSTRAINT `FK_rptleger_compromise_item_faas` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `FK_rptleger_compromise_item_rptcompromise` FOREIGN KEY (`rptcompromiseid`) REFERENCES `rptledger_compromise` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_compromise_item_credit` */

DROP TABLE IF EXISTS `rptledger_compromise_item_credit`;

CREATE TABLE `rptledger_compromise_item_credit` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rptcompromiseitemid` varchar(50) NOT NULL DEFAULT '',
  `rptreceiptid` varchar(50) DEFAULT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicidle` decimal(16,2) NOT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `firecode` decimal(16,2) NOT NULL,
  `basicidleint` decimal(16,4) NOT NULL,
  `sh` decimal(16,2) DEFAULT NULL,
  `shint` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptledger_compromise_item_credit_rptcompromiseitemid` (`rptcompromiseitemid`),
  KEY `ix_rptledger_compromise_item_credit_rptreceiptid` (`rptreceiptid`),
  CONSTRAINT `FK_rptledger_compromise_item_credit_rptcompromise_item` FOREIGN KEY (`rptcompromiseitemid`) REFERENCES `rptledger_compromise_item` (`objid`),
  CONSTRAINT `FK_rptledger_compromise_item_credit_rptreceipt` FOREIGN KEY (`rptreceiptid`) REFERENCES `cashreceipt_rpt` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_credit` */

DROP TABLE IF EXISTS `rptledger_credit`;

CREATE TABLE `rptledger_credit` (
  `objid` varchar(100) NOT NULL DEFAULT '',
  `rptledgerid` varchar(50) NOT NULL DEFAULT '',
  `type` varchar(20) NOT NULL DEFAULT '',
  `refno` varchar(50) NOT NULL DEFAULT '',
  `refdate` date NOT NULL,
  `payorid` varchar(50) DEFAULT NULL,
  `paidby_name` longtext NOT NULL,
  `paidby_address` varchar(150) NOT NULL DEFAULT '',
  `collector` varchar(80) NOT NULL DEFAULT '',
  `postedby` varchar(100) NOT NULL DEFAULT '',
  `postedbytitle` varchar(50) NOT NULL DEFAULT '',
  `dtposted` datetime NOT NULL,
  `fromyear` int(11) NOT NULL,
  `fromqtr` int(11) NOT NULL,
  `toyear` int(11) NOT NULL,
  `toqtr` int(11) NOT NULL,
  `basic` decimal(12,2) NOT NULL,
  `basicint` decimal(12,2) NOT NULL,
  `basicdisc` decimal(12,2) NOT NULL,
  `basicidle` decimal(12,2) NOT NULL,
  `sef` decimal(12,2) NOT NULL,
  `sefint` decimal(12,2) NOT NULL,
  `sefdisc` decimal(12,2) NOT NULL,
  `firecode` decimal(12,2) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `collectingagency` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptreceipt_payorid` (`payorid`),
  KEY `ix_rptreceipt_receiptno` (`refno`),
  KEY `FK_rptledgercredit_rptledger` (`rptledgerid`),
  CONSTRAINT `rptledger_credit_ibfk_1` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_forprocess` */

DROP TABLE IF EXISTS `rptledger_forprocess`;

CREATE TABLE `rptledger_forprocess` (
  `objid` varchar(255) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_payment` */

DROP TABLE IF EXISTS `rptledger_payment`;

CREATE TABLE `rptledger_payment` (
  `objid` varchar(100) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
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
  PRIMARY KEY (`objid`),
  KEY `fk_rptledger_payment_rptledger` (`rptledgerid`) USING BTREE,
  KEY `fk_rptledger_payment_cashreceipt` (`receiptid`) USING BTREE,
  KEY `ix_receiptno` (`receiptno`) USING BTREE,
  CONSTRAINT `fk_rptledger_payment_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `fk_rptledger_payment_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_payment_item` */

DROP TABLE IF EXISTS `rptledger_payment_item`;

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
  PRIMARY KEY (`objid`),
  KEY `FK_rptledger_payment_item_parentid` (`parentid`) USING BTREE,
  KEY `FK_rptledger_payment_item_rptledgerfaasid` (`rptledgerfaasid`) USING BTREE,
  KEY `ix_rptledgeritemid` (`rptledgeritemid`) USING BTREE,
  KEY `ix_rptledgeritemqtrlyid` (`rptledgeritemqtrlyid`) USING BTREE,
  CONSTRAINT `fk_rptledger_payment_item_parentid` FOREIGN KEY (`parentid`) REFERENCES `rptledger_payment` (`objid`),
  CONSTRAINT `fk_rptledger_payment_item_rptledgerfaasid` FOREIGN KEY (`rptledgerfaasid`) REFERENCES `rptledgerfaas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_payment_share` */

DROP TABLE IF EXISTS `rptledger_payment_share`;

CREATE TABLE `rptledger_payment_share` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(100) DEFAULT NULL,
  `revperiod` varchar(25) NOT NULL,
  `revtype` varchar(25) NOT NULL,
  `item_objid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `sharetype` varchar(25) NOT NULL,
  `discount` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_parentid` (`parentid`) USING BTREE,
  KEY `FK_item_objid` (`item_objid`) USING BTREE,
  CONSTRAINT `FK_rptledger_payment_share_itemaccount` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `FK_rptledger_payment_share_parentid` FOREIGN KEY (`parentid`) REFERENCES `rptledger_payment` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_restriction` */

DROP TABLE IF EXISTS `rptledger_restriction`;

CREATE TABLE `rptledger_restriction` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `restrictionid` varchar(50) NOT NULL,
  `remarks` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptledger_restriction` (`parentid`,`restrictionid`),
  CONSTRAINT `FK_rptledger_restriction_rptledger` FOREIGN KEY (`parentid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledger_subledger` */

DROP TABLE IF EXISTS `rptledger_subledger`;

CREATE TABLE `rptledger_subledger` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `parent_objid` varchar(50) NOT NULL DEFAULT '',
  `subacctno` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_parentid_subacctno` (`parent_objid`,`subacctno`),
  CONSTRAINT `FK_rptledger_subledger_rptldger` FOREIGN KEY (`parent_objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledgerfaas` */

DROP TABLE IF EXISTS `rptledgerfaas`;

CREATE TABLE `rptledgerfaas` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `tdno` varchar(60) NOT NULL,
  `txntype_objid` varchar(10) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `actualuse_objid` varchar(50) DEFAULT NULL,
  `taxable` int(11) NOT NULL,
  `backtax` int(11) NOT NULL,
  `fromyear` int(11) NOT NULL,
  `fromqtr` int(11) NOT NULL,
  `toyear` int(11) NOT NULL,
  `toqtr` int(11) NOT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  `systemcreated` int(11) NOT NULL,
  `reclassed` int(11) DEFAULT NULL,
  `idleland` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `faasid` (`faasid`),
  KEY `ix_rptledgerfaas_rptledgerid_faasid` (`rptledgerid`,`faasid`),
  KEY `ix_rptledgerhistory_ledgerid_toyear` (`rptledgerid`,`toyear`),
  KEY `fk_rptledgerhistory_rptledger` (`rptledgerid`),
  CONSTRAINT `rptledgerfaas_ibfk_1` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `rptledgerfaas_ibfk_2` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `rptledgerfaas_ibfk_3` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledgeritem` */

DROP TABLE IF EXISTS `rptledgeritem`;

CREATE TABLE `rptledgeritem` (
  `objid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL DEFAULT '',
  `rptledgerfaasid` varchar(50) NOT NULL DEFAULT '',
  `year` int(11) NOT NULL,
  `av` decimal(16,2) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `taxdifference` int(11) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `actualuse_objid` varchar(50) DEFAULT NULL,
  `basicav` decimal(16,2) DEFAULT NULL,
  `sefav` decimal(16,2) DEFAULT NULL,
  `basic` decimal(16,2) DEFAULT NULL,
  `basicpaid` decimal(16,2) DEFAULT NULL,
  `basicint` decimal(16,2) DEFAULT NULL,
  `basicintpaid` decimal(16,2) DEFAULT NULL,
  `basicdisc` decimal(16,2) DEFAULT NULL,
  `basicdisctaken` decimal(16,2) DEFAULT NULL,
  `basicidle` decimal(16,2) DEFAULT NULL,
  `basicidlepaid` decimal(16,2) DEFAULT NULL,
  `basicidledisc` decimal(16,2) DEFAULT NULL,
  `basicidledisctaken` decimal(16,2) DEFAULT NULL,
  `basicidleint` decimal(16,2) DEFAULT NULL,
  `basicidleintpaid` decimal(16,2) DEFAULT NULL,
  `sef` decimal(16,2) DEFAULT NULL,
  `sefpaid` decimal(16,2) DEFAULT NULL,
  `sefint` decimal(16,2) DEFAULT NULL,
  `sefintpaid` decimal(16,2) DEFAULT NULL,
  `sefdisc` decimal(16,2) DEFAULT NULL,
  `sefdisctaken` decimal(16,2) DEFAULT NULL,
  `firecode` decimal(16,2) DEFAULT NULL,
  `firecodepaid` decimal(16,2) DEFAULT NULL,
  `revperiod` varchar(50) DEFAULT NULL,
  `qtrly` int(11) DEFAULT NULL,
  `fullypaid` int(11) DEFAULT NULL,
  `sh` decimal(16,2) DEFAULT NULL,
  `shdisc` decimal(16,2) DEFAULT NULL,
  `shpaid` decimal(16,2) DEFAULT NULL,
  `shint` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rptledgeritem_rptledger` (`rptledgerid`),
  KEY `FK_rptledgeritem_rptledgerfaas` (`rptledgerfaasid`),
  CONSTRAINT `rptledgeritem_ibfk_1` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`),
  CONSTRAINT `rptledgeritem_ibfk_2` FOREIGN KEY (`rptledgerfaasid`) REFERENCES `rptledgerfaas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptledgeritem_qtrly` */

DROP TABLE IF EXISTS `rptledgeritem_qtrly`;

CREATE TABLE `rptledgeritem_qtrly` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `basicav` decimal(16,2) NOT NULL,
  `sefav` decimal(16,2) NOT NULL,
  `av` decimal(16,2) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicpaid` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicintpaid` decimal(16,2) DEFAULT NULL,
  `basicdisc` decimal(16,2) NOT NULL,
  `basicdisctaken` decimal(16,2) DEFAULT NULL,
  `basicidle` decimal(16,2) NOT NULL,
  `basicidlepaid` decimal(16,2) NOT NULL,
  `basicidledisc` decimal(16,2) NOT NULL,
  `basicidledisctaken` decimal(16,2) DEFAULT NULL,
  `basicidleint` decimal(16,2) NOT NULL,
  `basicidleintpaid` decimal(16,2) DEFAULT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefpaid` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `sefintpaid` decimal(16,2) DEFAULT NULL,
  `sefdisc` decimal(16,2) NOT NULL,
  `sefdisctaken` decimal(16,2) DEFAULT NULL,
  `firecode` decimal(16,2) NOT NULL,
  `firecodepaid` decimal(16,2) NOT NULL,
  `revperiod` varchar(50) DEFAULT NULL,
  `partialled` int(11) NOT NULL,
  `fullypaid` int(11) NOT NULL,
  `sh` decimal(16,2) DEFAULT NULL,
  `shdisc` decimal(16,2) DEFAULT NULL,
  `shpaid` decimal(16,2) DEFAULT NULL,
  `shint` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rptledgeritemqtrly_rptledgeritem` (`parentid`),
  KEY `FK_rptledgeritemqtrly_rptledger` (`rptledgerid`),
  KEY `ix_rptledgeritemqtrly_year` (`year`),
  CONSTRAINT `FK_rptledgeritemqtrly_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`),
  CONSTRAINT `FK_rptledgeritemqtrly_rptledgeritem` FOREIGN KEY (`parentid`) REFERENCES `rptledgeritem` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptparameter` */

DROP TABLE IF EXISTS `rptparameter`;

CREATE TABLE `rptparameter` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `caption` varchar(100) NOT NULL,
  `description` text,
  `paramtype` varchar(20) NOT NULL,
  `minvalue` decimal(10,2) NOT NULL,
  `maxvalue` decimal(10,2) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptparameter_name` (`name`),
  KEY `ix_rptparameter_caption` (`caption`),
  KEY `ix_rptparameter_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptreceipt_capture` */

DROP TABLE IF EXISTS `rptreceipt_capture`;

CREATE TABLE `rptreceipt_capture` (
  `objid` varchar(100) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `receiptno` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `payorid` varchar(50) DEFAULT NULL,
  `paidby_name` longtext NOT NULL,
  `paidby_address` varchar(150) NOT NULL,
  `collector` varchar(80) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `postedby` varchar(100) NOT NULL,
  `postedbytitle` varchar(50) NOT NULL,
  `dtposted` datetime NOT NULL,
  `paidby` varchar(255) NOT NULL,
  `fromyear` int(11) NOT NULL,
  `fromqtr` int(11) NOT NULL,
  `toyear` int(11) NOT NULL,
  `toqtr` int(11) NOT NULL,
  `period` varchar(50) NOT NULL,
  `basic` decimal(12,2) NOT NULL,
  `basicint` decimal(12,2) NOT NULL,
  `basicdisc` decimal(12,2) NOT NULL,
  `sef` decimal(12,2) NOT NULL,
  `sefint` decimal(12,2) NOT NULL,
  `sefdisc` decimal(12,2) NOT NULL,
  `firecode` decimal(12,2) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rptreceipt_capture_paidby` (`paidby`),
  KEY `ix_rptreceipt_payorid` (`payorid`),
  KEY `ix_rptreceipt_receiptno` (`receiptno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpttask` */

DROP TABLE IF EXISTS `rpttask`;

CREATE TABLE `rpttask` (
  `taskid` varchar(50) NOT NULL,
  `objid` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `filetype` varchar(50) NOT NULL,
  `msg` varchar(100) DEFAULT NULL,
  `startdate` datetime NOT NULL,
  `enddate` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(150) NOT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `assignedto_objid` varchar(50) DEFAULT NULL,
  `assignedto_name` varchar(150) DEFAULT NULL,
  `assignedto_title` varchar(50) DEFAULT NULL,
  `workflowid` varchar(50) DEFAULT NULL,
  `signatory` varchar(50) DEFAULT NULL,
  `docname` varchar(50) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`taskid`),
  KEY `ix_rpttask_assignedto_enddate` (`assignedto_objid`,`enddate`),
  KEY `ix_rpttask_assignedto_name` (`assignedto_name`),
  KEY `ix_rpttask_assignedto_objid` (`assignedto_objid`),
  KEY `ix_rpttask_createdby_name` (`createdby_name`),
  KEY `ix_rpttask_createdby_objid` (`createdby_objid`),
  KEY `ix_rpttask_enddate` (`enddate`),
  KEY `ix_rpttask_objid` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpttaxclearance` */

DROP TABLE IF EXISTS `rpttaxclearance`;

CREATE TABLE `rpttaxclearance` (
  `objid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `rpttaxclearance_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpttaxincentive` */

DROP TABLE IF EXISTS `rpttaxincentive`;

CREATE TABLE `rpttaxincentive` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  `txndate` date DEFAULT NULL,
  `taxpayer_objid` varchar(50) NOT NULL,
  `taxpayer_name` longtext NOT NULL,
  `taxpayer_address` varchar(150) NOT NULL,
  `name` varchar(100) NOT NULL,
  `remarks` varchar(250) NOT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(100) NOT NULL,
  `createdby_title` varchar(50) NOT NULL,
  `createdby_date` datetime NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rpttaxincentive_name` (`name`),
  KEY `ix_rpttaxincentive_state` (`state`),
  KEY `ix_rpttaxincentive_taxpayerid` (`taxpayer_objid`),
  KEY `ix_rpttaxincentive_txnno` (`txnno`),
  KEY `createdby_objid` (`createdby_objid`),
  CONSTRAINT `rpttaxincentive_ibfk_1` FOREIGN KEY (`taxpayer_objid`) REFERENCES `entity` (`objid`),
  CONSTRAINT `rpttaxincentive_ibfk_2` FOREIGN KEY (`createdby_objid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpttaxincentive_item` */

DROP TABLE IF EXISTS `rpttaxincentive_item`;

CREATE TABLE `rpttaxincentive_item` (
  `objid` varchar(50) NOT NULL,
  `rpttaxincentiveid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `fromyear` int(11) NOT NULL,
  `toyear` int(11) NOT NULL,
  `basicrate` int(11) NOT NULL,
  `sefrate` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rpttaxincentiveitem_rptledgerid` (`rptledgerid`),
  KEY `ix_rpttaxincentiveitem_rpttaxincentiveid` (`rpttaxincentiveid`),
  CONSTRAINT `rpttaxincentive_item_ibfk_1` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`),
  CONSTRAINT `rpttaxincentive_item_ibfk_2` FOREIGN KEY (`rpttaxincentiveid`) REFERENCES `rpttaxincentive` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpttracking` */

DROP TABLE IF EXISTS `rpttracking`;

CREATE TABLE `rpttracking` (
  `objid` varchar(50) NOT NULL,
  `filetype` varchar(50) NOT NULL,
  `trackingno` varchar(25) NOT NULL,
  `msg` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpttransmittal` */

DROP TABLE IF EXISTS `rpttransmittal`;

CREATE TABLE `rpttransmittal` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `type` varchar(15) NOT NULL,
  `filetype` varchar(50) NOT NULL,
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
  `remarks` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_txnno` (`txnno`),
  KEY `ix_state` (`state`),
  KEY `ix_createdby_name` (`createdby_name`),
  KEY `ix_lguname` (`lgu_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpttransmittal_item` */

DROP TABLE IF EXISTS `rpttransmittal_item`;

CREATE TABLE `rpttransmittal_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `filetype` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(150) NOT NULL,
  `message` varchar(350) DEFAULT NULL,
  `remarks` varchar(350) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `disapprovedby_name` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_parentid_refid` (`parentid`,`refid`),
  KEY `ix_refid` (`refid`),
  KEY `FK_rpttransmittal_item_rpttransmittal` (`parentid`),
  CONSTRAINT `FK_rpttransmittal_item_rpttransmittal` FOREIGN KEY (`parentid`) REFERENCES `rpttransmittal` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rptvariable` */

DROP TABLE IF EXISTS `rptvariable`;

CREATE TABLE `rptvariable` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpu` */

DROP TABLE IF EXISTS `rpu`;

CREATE TABLE `rpu` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `realpropertyid` varchar(50) DEFAULT NULL,
  `rputype` varchar(10) NOT NULL,
  `ry` int(11) NOT NULL,
  `fullpin` varchar(30) DEFAULT NULL,
  `suffix` int(11) NOT NULL,
  `subsuffix` int(11) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `exemptiontype_objid` varchar(50) DEFAULT NULL,
  `taxable` int(11) NOT NULL,
  `totalareaha` decimal(18,6) NOT NULL,
  `totalareasqm` decimal(18,6) NOT NULL,
  `totalbmv` decimal(16,2) NOT NULL,
  `totalmv` decimal(16,2) NOT NULL,
  `totalav` decimal(16,2) NOT NULL,
  `hasswornamount` int(11) NOT NULL,
  `swornamount` decimal(16,2) NOT NULL,
  `useswornamount` int(11) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  `rpumasterid` varchar(50) DEFAULT NULL,
  `reclassed` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `exemptiontype_objid` (`exemptiontype_objid`),
  KEY `rpumasterid` (`rpumasterid`),
  KEY `FK_rpu_realpropertyid` (`realpropertyid`),
  KEY `ix_classification_objid` (`classification_objid`),
  KEY `ix_previd` (`previd`),
  KEY `ix_rpu_fullpin` (`fullpin`),
  KEY `ix_rpu_ry_fullpin` (`fullpin`,`ry`),
  KEY `ix_rpu_ry_state` (`state`),
  KEY `ix_rpu_state` (`state`),
  KEY `ix_rpy_ry` (`ry`),
  CONSTRAINT `rpu_ibfk_1` FOREIGN KEY (`exemptiontype_objid`) REFERENCES `exemptiontype` (`objid`),
  CONSTRAINT `rpu_ibfk_2` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`),
  CONSTRAINT `rpu_ibfk_4` FOREIGN KEY (`rpumasterid`) REFERENCES `rpumaster` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpu_assessment` */

DROP TABLE IF EXISTS `rpu_assessment`;

CREATE TABLE `rpu_assessment` (
  `objid` varchar(50) NOT NULL,
  `rpuid` varchar(50) NOT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `actualuse_objid` varchar(50) DEFAULT NULL,
  `areasqm` decimal(16,2) NOT NULL,
  `areaha` decimal(16,6) NOT NULL,
  `marketvalue` decimal(16,2) NOT NULL,
  `assesslevel` decimal(16,2) NOT NULL,
  `assessedvalue` decimal(16,2) NOT NULL,
  `rputype` varchar(25) DEFAULT NULL,
  `taxable` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rpuassessmetn_rpu` (`rpuid`),
  CONSTRAINT `FK_rpuassessmetn_rpu` FOREIGN KEY (`rpuid`) REFERENCES `rpu` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rpumaster` */

DROP TABLE IF EXISTS `rpumaster`;

CREATE TABLE `rpumaster` (
  `objid` varchar(50) NOT NULL,
  `currentfaasid` varchar(50) DEFAULT NULL,
  `currentrpuid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rysetting_lgu` */

DROP TABLE IF EXISTS `rysetting_lgu`;

CREATE TABLE `rysetting_lgu` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rysettingid` varchar(50) NOT NULL DEFAULT '',
  `lguid` varchar(50) NOT NULL DEFAULT '',
  `settingtype` varchar(15) NOT NULL DEFAULT '',
  `barangayid` varchar(50) DEFAULT NULL,
  `lguname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rysettinglgu` (`rysettingid`,`lguid`,`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rysettinginfo` */

DROP TABLE IF EXISTS `rysettinginfo`;

CREATE TABLE `rysettinginfo` (
  `ry` int(11) NOT NULL,
  `ordinanceno` varchar(50) DEFAULT NULL,
  `ordinancedate` datetime DEFAULT NULL,
  `sangguniangname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `signatory` */

DROP TABLE IF EXISTS `signatory`;

CREATE TABLE `signatory` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `doctype` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `title` varchar(50) NOT NULL,
  `department` varchar(50) DEFAULT NULL,
  `personnelid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_doctype` (`doctype`),
  KEY `ix_personnelid` (`personnelid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sre_revenue_mapping` */

DROP TABLE IF EXISTS `sre_revenue_mapping`;

CREATE TABLE `sre_revenue_mapping` (
  `objid` varchar(50) NOT NULL,
  `version` varchar(10) DEFAULT NULL,
  `revenueitemid` varchar(50) NOT NULL,
  `acctid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_revenueitemid` (`revenueitemid`),
  KEY `ix_acctid` (`acctid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sreaccount` */

DROP TABLE IF EXISTS `sreaccount`;

CREATE TABLE `sreaccount` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `chartid` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `acctgroup` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_code` (`code`),
  KEY `ix_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sreaccount_incometarget` */

DROP TABLE IF EXISTS `sreaccount_incometarget`;

CREATE TABLE `sreaccount_incometarget` (
  `objid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `target` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`objid`,`year`),
  CONSTRAINT `sreaccount_incometarget_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `sreaccount` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `structure` */

DROP TABLE IF EXISTS `structure`;

CREATE TABLE `structure` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `indexno` int(11) NOT NULL,
  `showinfaas` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_structure_code` (`code`),
  UNIQUE KEY `ux_structure_name` (`name`),
  KEY `ix_structure_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `structurematerial` */

DROP TABLE IF EXISTS `structurematerial`;

CREATE TABLE `structurematerial` (
  `structure_objid` varchar(50) NOT NULL,
  `material_objid` varchar(50) NOT NULL,
  `display` int(11) DEFAULT NULL,
  `idx` int(11) DEFAULT NULL,
  PRIMARY KEY (`structure_objid`,`material_objid`),
  KEY `FK_structurematerial_material` (`material_objid`),
  CONSTRAINT `structurematerial_ibfk_1` FOREIGN KEY (`material_objid`) REFERENCES `material` (`objid`),
  CONSTRAINT `structurematerial_ibfk_2` FOREIGN KEY (`structure_objid`) REFERENCES `structure` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subcollector_remittance` */

DROP TABLE IF EXISTS `subcollector_remittance`;

CREATE TABLE `subcollector_remittance` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `txnno` varchar(20) NOT NULL,
  `dtposted` datetime NOT NULL,
  `collector_objid` varchar(50) NOT NULL,
  `collector_name` varchar(100) NOT NULL,
  `collector_title` varchar(30) NOT NULL,
  `subcollector_objid` varchar(50) NOT NULL,
  `subcollector_name` varchar(100) NOT NULL,
  `subcollector_title` varchar(50) DEFAULT NULL,
  `amount` decimal(18,2) NOT NULL,
  `totalcash` decimal(12,2) DEFAULT NULL,
  `totalnoncash` decimal(12,2) DEFAULT NULL,
  `cashbreakdown` text,
  `collectionsummaries` longtext,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_txnno` (`txnno`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_collector_objid` (`collector_objid`),
  KEY `ix_subcollector_objid` (`subcollector_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subcollector_remittance_cashreceipt` */

DROP TABLE IF EXISTS `subcollector_remittance_cashreceipt`;

CREATE TABLE `subcollector_remittance_cashreceipt` (
  `objid` varchar(50) NOT NULL,
  `remittanceid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_remittanceid` (`remittanceid`),
  CONSTRAINT `fk_subcollector_remittance_cashreceipt_objid` FOREIGN KEY (`objid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `fk_subcollector_remittance_cashreceipt_remittanceid` FOREIGN KEY (`remittanceid`) REFERENCES `subcollector_remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subdividedland` */

DROP TABLE IF EXISTS `subdividedland`;

CREATE TABLE `subdividedland` (
  `objid` varchar(50) NOT NULL,
  `subdivisionid` varchar(50) NOT NULL,
  `itemno` varchar(10) DEFAULT NULL,
  `newtdno` varchar(50) DEFAULT NULL,
  `newutdno` varchar(50) DEFAULT NULL,
  `newpin` varchar(25) NOT NULL,
  `newtitletype` varchar(50) DEFAULT NULL,
  `newtitleno` varchar(50) DEFAULT NULL,
  `newtitledate` varchar(50) DEFAULT NULL,
  `areasqm` decimal(16,6) DEFAULT NULL,
  `areaha` decimal(16,6) DEFAULT NULL,
  `memoranda` varchar(500) DEFAULT NULL,
  `administrator_objid` varchar(50) DEFAULT NULL,
  `administrator_name` varchar(200) DEFAULT NULL,
  `administrator_address` varchar(200) DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `taxpayer_name` varchar(200) DEFAULT NULL,
  `taxpayer_address` varchar(200) DEFAULT NULL,
  `owner_name` varchar(200) DEFAULT NULL,
  `owner_address` varchar(200) DEFAULT NULL,
  `newrpid` varchar(50) NOT NULL,
  `newrpuid` varchar(50) DEFAULT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_subdividedland_newpin` (`newpin`),
  UNIQUE KEY `ux_newpin` (`newpin`),
  KEY `FK_subdividedland_faas` (`newfaasid`),
  KEY `FK_subdividedland_newrp` (`newrpid`),
  KEY `FK_subdividedland_newrpu` (`newrpuid`),
  KEY `FK_subdividedland_subdivision` (`subdivisionid`),
  KEY `ix_subdividedland_administrator_name` (`administrator_name`),
  KEY `ix_subdividedland_newtdno` (`newtdno`),
  CONSTRAINT `subdividedland_ibfk_1` FOREIGN KEY (`newfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `subdividedland_ibfk_2` FOREIGN KEY (`newrpid`) REFERENCES `realproperty` (`objid`),
  CONSTRAINT `subdividedland_ibfk_3` FOREIGN KEY (`newrpuid`) REFERENCES `rpu` (`objid`),
  CONSTRAINT `subdividedland_ibfk_4` FOREIGN KEY (`subdivisionid`) REFERENCES `subdivision` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subdivision` */

DROP TABLE IF EXISTS `subdivision`;

CREATE TABLE `subdivision` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `ry` int(11) NOT NULL,
  `txntype_objid` varchar(5) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime NOT NULL,
  `autonumber` int(11) NOT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `memoranda` text NOT NULL,
  `motherfaasid` varchar(50) DEFAULT NULL,
  `lguid` varchar(50) DEFAULT NULL,
  `signatories` text,
  `source` varchar(50) DEFAULT NULL,
  `filetype` varchar(25) DEFAULT NULL,
  `originlguid` varchar(50) DEFAULT NULL,
  `mothertdnos` varchar(1000) DEFAULT NULL,
  `motherpins` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_subdivision_faas` (`motherfaasid`),
  KEY `txntype_objid` (`txntype_objid`),
  KEY `ix_subdivision_mothertdnos` (`mothertdnos`(255)),
  KEY `ix_subdivision_motherpins` (`motherpins`(255)),
  CONSTRAINT `subdivision_ibfk_2` FOREIGN KEY (`txntype_objid`) REFERENCES `faas_txntype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subdivision_cancelledimprovement` */

DROP TABLE IF EXISTS `subdivision_cancelledimprovement`;

CREATE TABLE `subdivision_cancelledimprovement` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `remarks` varchar(1000) DEFAULT NULL,
  `lasttaxyear` int(11) DEFAULT NULL,
  `lguid` varchar(50) DEFAULT NULL,
  `reason_objid` varchar(50) DEFAULT NULL,
  `cancelledbytdnos` varchar(500) DEFAULT NULL,
  `cancelledbypins` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_subdivision_cancelledimprovement_subdivision` (`parentid`),
  KEY `FK_subdivision_cancelledimprovement_faas` (`faasid`),
  CONSTRAINT `FK_subdivision_cancelledimprovement_faas` FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `FK_subdivision_cancelledimprovement_subdivision` FOREIGN KEY (`parentid`) REFERENCES `subdivision` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subdivision_motherland` */

DROP TABLE IF EXISTS `subdivision_motherland`;

CREATE TABLE `subdivision_motherland` (
  `objid` varchar(50) NOT NULL,
  `subdivisionid` varchar(50) NOT NULL,
  `landfaasid` varchar(50) NOT NULL,
  `rpuid` varchar(50) NOT NULL,
  `rpid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_consolidatedland_faas` (`landfaasid`),
  KEY `FK_consolidatedland_subdivision` (`subdivisionid`),
  CONSTRAINT `subdivision_motherland_ibfk_2` FOREIGN KEY (`landfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `subdivison_motherland_ibfk_1` FOREIGN KEY (`subdivisionid`) REFERENCES `subdivision` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subdivision_task` */

DROP TABLE IF EXISTS `subdivision_task`;

CREATE TABLE `subdivision_task` (
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
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  CONSTRAINT `subdivision_task_ibfk_1` FOREIGN KEY (`refid`) REFERENCES `subdivision` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `subdivisionaffectedrpu` */

DROP TABLE IF EXISTS `subdivisionaffectedrpu`;

CREATE TABLE `subdivisionaffectedrpu` (
  `objid` varchar(50) NOT NULL,
  `subdivisionid` varchar(50) NOT NULL,
  `itemno` varchar(50) DEFAULT NULL,
  `subdividedlandid` varchar(50) DEFAULT NULL,
  `prevfaasid` varchar(50) DEFAULT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `newtdno` varchar(50) DEFAULT NULL,
  `newutdno` varchar(50) DEFAULT NULL,
  `newsuffix` int(11) DEFAULT NULL,
  `newpin` varchar(25) DEFAULT NULL,
  `newrpuid` varchar(50) DEFAULT NULL,
  `newrpid` varchar(50) DEFAULT NULL,
  `memoranda` varchar(500) DEFAULT NULL,
  `prevpin` varchar(50) DEFAULT NULL,
  `prevtdno` varchar(50) DEFAULT NULL,
  `isnew` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_subdivisionaffectedpru_newfaas` (`newfaasid`),
  KEY `FK_subdivisionaffectedpru_newrpu` (`newrpuid`),
  KEY `FK_subdivisionaffectedpru_prevfaas` (`prevfaasid`),
  KEY `FK_subdivisionaffectedpru_subdividedland` (`subdividedlandid`),
  KEY `FK_subdivisionaffectedpru_subdivision` (`subdivisionid`),
  KEY `ix_subdivisionaffectedrpu_newtdno` (`newtdno`),
  KEY `newrpid` (`newrpid`),
  CONSTRAINT `subdivisionaffectedrpu_ibfk_1` FOREIGN KEY (`newfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `subdivisionaffectedrpu_ibfk_2` FOREIGN KEY (`newrpuid`) REFERENCES `rpu` (`objid`),
  CONSTRAINT `subdivisionaffectedrpu_ibfk_3` FOREIGN KEY (`prevfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `subdivisionaffectedrpu_ibfk_4` FOREIGN KEY (`subdividedlandid`) REFERENCES `subdividedland` (`objid`),
  CONSTRAINT `subdivisionaffectedrpu_ibfk_5` FOREIGN KEY (`subdivisionid`) REFERENCES `subdivision` (`objid`),
  CONSTRAINT `subdivisionaffectedrpu_ibfk_6` FOREIGN KEY (`newrpid`) REFERENCES `realproperty` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_dataset` */

DROP TABLE IF EXISTS `sys_dataset`;

CREATE TABLE `sys_dataset` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `input` longtext,
  `output` longtext,
  `statement` varchar(50) DEFAULT NULL,
  `datasource` varchar(50) DEFAULT NULL,
  `servicename` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_holiday` */

DROP TABLE IF EXISTS `sys_holiday`;

CREATE TABLE `sys_holiday` (
  `objid` varchar(50) NOT NULL,
  `year` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_org` */

DROP TABLE IF EXISTS `sys_org`;

CREATE TABLE `sys_org` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `orgclass` varchar(50) DEFAULT NULL,
  `parent_objid` varchar(50) DEFAULT NULL,
  `parent_orgclass` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `root` int(11) NOT NULL,
  `txncode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`),
  KEY `ix_parent_objid` (`parent_objid`),
  KEY `ix_parent_orgclass` (`parent_orgclass`),
  KEY `ix_code` (`code`),
  KEY `fk_sys_org_orgclass` (`orgclass`),
  CONSTRAINT `fk_sys_org_orgclass` FOREIGN KEY (`orgclass`) REFERENCES `sys_orgclass` (`name`) ON UPDATE CASCADE,
  CONSTRAINT `fk_sys_org_parent_objid` FOREIGN KEY (`parent_objid`) REFERENCES `sys_org` (`objid`) ON UPDATE CASCADE,
  CONSTRAINT `fk_sys_org_parent_orgclass` FOREIGN KEY (`parent_orgclass`) REFERENCES `sys_orgclass` (`name`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_orgclass` */

DROP TABLE IF EXISTS `sys_orgclass`;

CREATE TABLE `sys_orgclass` (
  `name` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `parentclass` varchar(255) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_quarter` */

DROP TABLE IF EXISTS `sys_quarter`;

CREATE TABLE `sys_quarter` (
  `qtrid` int(11) NOT NULL,
  PRIMARY KEY (`qtrid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_report` */

DROP TABLE IF EXISTS `sys_report`;

CREATE TABLE `sys_report` (
  `objid` varchar(50) NOT NULL,
  `reportfolderid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `filetype` varchar(25) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `createdby` varchar(50) DEFAULT NULL,
  `datasetid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_sys_report_dataset` (`datasetid`),
  KEY `FK_sys_report_entry_folder` (`reportfolderid`),
  CONSTRAINT `sys_report_ibfk_1` FOREIGN KEY (`datasetid`) REFERENCES `sys_dataset` (`objid`),
  CONSTRAINT `sys_report_ibfk_2` FOREIGN KEY (`reportfolderid`) REFERENCES `sys_report_folder` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_report_admin` */

DROP TABLE IF EXISTS `sys_report_admin`;

CREATE TABLE `sys_report_admin` (
  `objid` varchar(50) NOT NULL,
  `userid` varchar(50) DEFAULT NULL,
  `reportfolderid` varchar(50) DEFAULT NULL,
  `exclude` longtext,
  PRIMARY KEY (`objid`),
  KEY `FK_sys_report_admin_folder` (`reportfolderid`),
  KEY `FK_sys_report_admin_user` (`userid`),
  CONSTRAINT `sys_report_admin_ibfk_1` FOREIGN KEY (`reportfolderid`) REFERENCES `sys_report_folder` (`objid`),
  CONSTRAINT `sys_report_admin_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_report_folder` */

DROP TABLE IF EXISTS `sys_report_folder`;

CREATE TABLE `sys_report_folder` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_report_member` */

DROP TABLE IF EXISTS `sys_report_member`;

CREATE TABLE `sys_report_member` (
  `objid` varchar(50) NOT NULL,
  `reportfolderid` varchar(50) DEFAULT NULL,
  `userid` varchar(50) DEFAULT NULL,
  `usergroupid` varchar(50) DEFAULT NULL,
  `exclude` longtext,
  PRIMARY KEY (`objid`),
  KEY `FK_sys_report_member_folder` (`reportfolderid`),
  KEY `FK_sys_report_member_user` (`userid`),
  KEY `FK_sys_report_member_usergroup` (`usergroupid`),
  CONSTRAINT `sys_report_member_ibfk_1` FOREIGN KEY (`reportfolderid`) REFERENCES `sys_report_folder` (`objid`),
  CONSTRAINT `sys_report_member_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `sys_report_member_ibfk_3` FOREIGN KEY (`usergroupid`) REFERENCES `sys_usergroup` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_requirement_type` */

DROP TABLE IF EXISTS `sys_requirement_type`;

CREATE TABLE `sys_requirement_type` (
  `code` varchar(50) NOT NULL,
  `title` varchar(155) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule` */

DROP TABLE IF EXISTS `sys_rule`;

CREATE TABLE `sys_rule` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `ruleset` varchar(50) NOT NULL,
  `rulegroup` varchar(50) DEFAULT NULL,
  `title` varchar(250) DEFAULT NULL,
  `description` longtext,
  `salience` int(11) DEFAULT NULL,
  `effectivefrom` date DEFAULT NULL,
  `effectiveto` date DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `user_objid` varchar(50) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `noloop` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `rulegroup` (`rulegroup`,`ruleset`),
  KEY `ruleset` (`ruleset`),
  CONSTRAINT `sys_rule_ibfk_1` FOREIGN KEY (`rulegroup`, `ruleset`) REFERENCES `sys_rulegroup` (`name`, `ruleset`),
  CONSTRAINT `sys_rule_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_action` */

DROP TABLE IF EXISTS `sys_rule_action`;

CREATE TABLE `sys_rule_action` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `actiondef_objid` varchar(50) DEFAULT NULL,
  `actiondef_name` varchar(50) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_actiondef_objid` (`actiondef_objid`),
  CONSTRAINT `sys_rule_action_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_action_param` */

DROP TABLE IF EXISTS `sys_rule_action_param`;

CREATE TABLE `sys_rule_action_param` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `actiondefparam_objid` varchar(50) DEFAULT NULL,
  `stringvalue` varchar(255) DEFAULT NULL,
  `booleanvalue` int(11) DEFAULT NULL,
  `var_objid` varchar(50) DEFAULT NULL,
  `var_name` varchar(50) DEFAULT NULL,
  `expr` longtext,
  `exprtype` varchar(25) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `obj_key` varchar(50) DEFAULT NULL,
  `obj_value` varchar(255) DEFAULT NULL,
  `listvalue` longtext,
  `lov` varchar(50) DEFAULT NULL,
  `rangeoption` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_var_objid` (`var_objid`),
  CONSTRAINT `sys_rule_action_param_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_action` (`objid`),
  CONSTRAINT `sys_rule_action_param_ibfk_2` FOREIGN KEY (`var_objid`) REFERENCES `sys_rule_condition_var` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_actiondef` */

DROP TABLE IF EXISTS `sys_rule_actiondef`;

CREATE TABLE `sys_rule_actiondef` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(250) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `actionname` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `actionclass` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_actiondef_param` */

DROP TABLE IF EXISTS `sys_rule_actiondef_param`;

CREATE TABLE `sys_rule_actiondef_param` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `lookuphandler` varchar(50) DEFAULT NULL,
  `lookupkey` varchar(50) DEFAULT NULL,
  `lookupvalue` varchar(50) DEFAULT NULL,
  `vardatatype` varchar(50) DEFAULT NULL,
  `lovname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `parentid` (`parentid`),
  CONSTRAINT `sys_rule_actiondef_param_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_actiondef` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_condition` */

DROP TABLE IF EXISTS `sys_rule_condition`;

CREATE TABLE `sys_rule_condition` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `fact_name` varchar(50) DEFAULT NULL,
  `fact_objid` varchar(50) DEFAULT NULL,
  `varname` varchar(50) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `ruletext` longtext,
  `displaytext` longtext,
  `dynamic_datatype` varchar(50) DEFAULT NULL,
  `dynamic_key` varchar(50) DEFAULT NULL,
  `dynamic_value` varchar(50) DEFAULT NULL,
  `notexist` int(11) DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_fact_objid` (`fact_objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `sys_rule_condition_ibfk_1` FOREIGN KEY (`fact_objid`) REFERENCES `sys_rule_fact` (`objid`),
  CONSTRAINT `sys_rule_condition_ibfk_2` FOREIGN KEY (`parentid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_condition_constraint` */

DROP TABLE IF EXISTS `sys_rule_condition_constraint`;

CREATE TABLE `sys_rule_condition_constraint` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `field_objid` varchar(50) DEFAULT NULL,
  `fieldname` varchar(50) DEFAULT NULL,
  `varname` varchar(50) DEFAULT NULL,
  `operator_caption` varchar(50) DEFAULT NULL,
  `operator_symbol` varchar(50) DEFAULT NULL,
  `usevar` int(11) DEFAULT NULL,
  `var_objid` varchar(50) DEFAULT NULL,
  `var_name` varchar(50) DEFAULT NULL,
  `decimalvalue` decimal(16,2) DEFAULT NULL,
  `intvalue` int(11) DEFAULT NULL,
  `stringvalue` varchar(255) DEFAULT NULL,
  `listvalue` longtext,
  `datevalue` date DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_var_objid` (`var_objid`),
  CONSTRAINT `sys_rule_condition_constraint_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_condition` (`objid`),
  CONSTRAINT `sys_rule_condition_constraint_ibfk_2` FOREIGN KEY (`var_objid`) REFERENCES `sys_rule_condition_var` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_condition_var` */

DROP TABLE IF EXISTS `sys_rule_condition_var`;

CREATE TABLE `sys_rule_condition_var` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `ruleid` varchar(50) DEFAULT NULL,
  `varname` varchar(50) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `sys_rule_condition_var_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_condition` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_deployed` */

DROP TABLE IF EXISTS `sys_rule_deployed`;

CREATE TABLE `sys_rule_deployed` (
  `objid` varchar(50) NOT NULL,
  `ruletext` longtext,
  PRIMARY KEY (`objid`),
  CONSTRAINT `sys_rule_deployed_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_fact` */

DROP TABLE IF EXISTS `sys_rule_fact`;

CREATE TABLE `sys_rule_fact` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `factclass` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `defaultvarname` varchar(25) DEFAULT NULL,
  `dynamic` int(11) DEFAULT NULL,
  `lookuphandler` varchar(50) DEFAULT NULL,
  `lookupkey` varchar(50) DEFAULT NULL,
  `lookupvalue` varchar(50) DEFAULT NULL,
  `lookupdatatype` varchar(50) DEFAULT NULL,
  `dynamicfieldname` varchar(50) DEFAULT NULL,
  `builtinconstraints` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `factsuperclass` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rule_fact_field` */

DROP TABLE IF EXISTS `sys_rule_fact_field`;

CREATE TABLE `sys_rule_fact_field` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `lookuphandler` varchar(50) DEFAULT NULL,
  `lookupkey` varchar(50) DEFAULT NULL,
  `lookupvalue` varchar(50) DEFAULT NULL,
  `lookupdatatype` varchar(50) DEFAULT NULL,
  `multivalued` int(11) DEFAULT NULL,
  `required` int(11) DEFAULT NULL,
  `vardatatype` varchar(50) DEFAULT NULL,
  `lovname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `sys_rule_fact_field_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_fact` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_rulegroup` */

DROP TABLE IF EXISTS `sys_rulegroup`;

CREATE TABLE `sys_rulegroup` (
  `name` varchar(50) NOT NULL,
  `ruleset` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`,`ruleset`),
  KEY `ruleset` (`ruleset`),
  CONSTRAINT `sys_rulegroup_ibfk_1` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_ruleset` */

DROP TABLE IF EXISTS `sys_ruleset`;

CREATE TABLE `sys_ruleset` (
  `name` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `packagename` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `permission` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_ruleset_actiondef` */

DROP TABLE IF EXISTS `sys_ruleset_actiondef`;

CREATE TABLE `sys_ruleset_actiondef` (
  `ruleset` varchar(50) NOT NULL,
  `actiondef` varchar(50) NOT NULL,
  PRIMARY KEY (`ruleset`,`actiondef`),
  KEY `actiondef` (`actiondef`),
  CONSTRAINT `sys_ruleset_actiondef_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_ruleset_fact` */

DROP TABLE IF EXISTS `sys_ruleset_fact`;

CREATE TABLE `sys_ruleset_fact` (
  `ruleset` varchar(50) NOT NULL,
  `rulefact` varchar(50) NOT NULL,
  PRIMARY KEY (`ruleset`,`rulefact`),
  KEY `rulefact` (`rulefact`),
  CONSTRAINT `sys_ruleset_fact_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_script` */

DROP TABLE IF EXISTS `sys_script`;

CREATE TABLE `sys_script` (
  `name` varchar(50) NOT NULL,
  `title` longblob,
  `content` longtext,
  `category` varchar(20) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `createdby` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_securitygroup` */

DROP TABLE IF EXISTS `sys_securitygroup`;

CREATE TABLE `sys_securitygroup` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `usergroup_objid` varchar(50) DEFAULT NULL,
  `exclude` longtext,
  PRIMARY KEY (`objid`),
  KEY `FK_sys_securitygroup_usergroup` (`usergroup_objid`),
  CONSTRAINT `sys_securitygroup_ibfk_1` FOREIGN KEY (`usergroup_objid`) REFERENCES `sys_usergroup` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_sequence` */

DROP TABLE IF EXISTS `sys_sequence`;

CREATE TABLE `sys_sequence` (
  `objid` varchar(100) NOT NULL,
  `nextSeries` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_session` */

DROP TABLE IF EXISTS `sys_session`;

CREATE TABLE `sys_session` (
  `sessionid` varchar(50) NOT NULL,
  `userid` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `clienttype` varchar(12) DEFAULT NULL,
  `accesstime` datetime DEFAULT NULL,
  `accessexpiry` datetime DEFAULT NULL,
  `timein` datetime DEFAULT NULL,
  PRIMARY KEY (`sessionid`),
  KEY `ix_timein` (`timein`),
  KEY `ix_userid` (`userid`),
  KEY `ix_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_session_log` */

DROP TABLE IF EXISTS `sys_session_log`;

CREATE TABLE `sys_session_log` (
  `sessionid` varchar(50) NOT NULL,
  `userid` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `clienttype` varchar(12) DEFAULT NULL,
  `accesstime` datetime DEFAULT NULL,
  `accessexpiry` datetime DEFAULT NULL,
  `timein` datetime DEFAULT NULL,
  `timeout` datetime DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sessionid`),
  KEY `ix_timein` (`timein`),
  KEY `ix_timeout` (`timeout`),
  KEY `ix_userid` (`userid`),
  KEY `ix_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_terminal` */

DROP TABLE IF EXISTS `sys_terminal`;

CREATE TABLE `sys_terminal` (
  `terminalid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `parentcode` varchar(50) DEFAULT NULL,
  `parenttype` varchar(50) DEFAULT NULL,
  `macaddress` varchar(50) DEFAULT NULL,
  `dtregistered` datetime DEFAULT NULL,
  `registeredby` varchar(50) DEFAULT NULL,
  `info` longtext,
  `state` int(11) DEFAULT NULL,
  PRIMARY KEY (`terminalid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_user` */

DROP TABLE IF EXISTS `sys_user`;

CREATE TABLE `sys_user` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(15) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `createdby` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `pwd` varchar(50) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `jobtitle` varchar(50) DEFAULT NULL,
  `pwdlogincount` int(11) DEFAULT NULL,
  `pwdexpirydate` datetime DEFAULT NULL,
  `usedpwds` longtext,
  `lockid` varchar(32) DEFAULT NULL,
  `txncode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_username` (`username`),
  KEY `ix_lastname_firstname` (`lastname`,`firstname`),
  KEY `ix_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_usergroup` */

DROP TABLE IF EXISTS `sys_usergroup`;

CREATE TABLE `sys_usergroup` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `domain` varchar(25) DEFAULT NULL,
  `userclass` varchar(25) DEFAULT NULL,
  `orgclass` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_usergroup_admin` */

DROP TABLE IF EXISTS `sys_usergroup_admin`;

CREATE TABLE `sys_usergroup_admin` (
  `objid` varchar(50) NOT NULL,
  `usergroupid` varchar(50) DEFAULT NULL,
  `user_objid` varchar(50) DEFAULT NULL,
  `user_username` varchar(50) DEFAULT NULL,
  `user_firstname` varchar(50) NOT NULL,
  `user_lastname` varchar(50) DEFAULT NULL,
  `exclude` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `usergroupid` (`usergroupid`),
  KEY `FK_sys_usergroup_admin` (`user_objid`),
  CONSTRAINT `sys_usergroup_admin_ibfk_1` FOREIGN KEY (`user_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `sys_usergroup_admin_ibfk_2` FOREIGN KEY (`usergroupid`) REFERENCES `sys_usergroup` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_usergroup_member` */

DROP TABLE IF EXISTS `sys_usergroup_member`;

CREATE TABLE `sys_usergroup_member` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `usergroup_objid` varchar(50) DEFAULT NULL,
  `user_objid` varchar(50) NOT NULL,
  `user_username` varchar(50) DEFAULT NULL,
  `user_firstname` varchar(50) NOT NULL,
  `user_lastname` varchar(50) NOT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `org_orgclass` varchar(50) DEFAULT NULL,
  `securitygroup_objid` varchar(50) DEFAULT NULL,
  `exclude` varchar(255) DEFAULT NULL,
  `displayname` varchar(50) DEFAULT NULL,
  `jobtitle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `usergroup_objid` (`usergroup_objid`),
  KEY `FK_sys_usergroup_member` (`user_objid`),
  KEY `FK_sys_usergroup_member_org` (`org_objid`),
  KEY `FK_sys_usergroup_member_securitygorup` (`securitygroup_objid`),
  KEY `ix_user_firstname` (`user_firstname`),
  KEY `ix_user_lastname_firstname` (`user_lastname`,`user_firstname`),
  KEY `ix_username` (`user_username`),
  CONSTRAINT `sys_usergroup_member_ibfk_1` FOREIGN KEY (`user_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `sys_usergroup_member_ibfk_2` FOREIGN KEY (`org_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `sys_usergroup_member_ibfk_3` FOREIGN KEY (`securitygroup_objid`) REFERENCES `sys_securitygroup` (`objid`),
  CONSTRAINT `sys_usergroup_member_ibfk_4` FOREIGN KEY (`usergroup_objid`) REFERENCES `sys_usergroup` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_usergroup_permission` */

DROP TABLE IF EXISTS `sys_usergroup_permission`;

CREATE TABLE `sys_usergroup_permission` (
  `objid` varchar(50) NOT NULL,
  `usergroup_objid` varchar(50) DEFAULT NULL,
  `object` varchar(25) DEFAULT NULL,
  `permission` varchar(25) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_sys_usergroup_permission_usergroup` (`usergroup_objid`),
  CONSTRAINT `sys_usergroup_permission_ibfk_1` FOREIGN KEY (`usergroup_objid`) REFERENCES `sys_usergroup` (`objid`),
  CONSTRAINT `sys_usergroup_permission_ibfk_2` FOREIGN KEY (`usergroup_objid`) REFERENCES `sys_usergroup` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_var` */

DROP TABLE IF EXISTS `sys_var`;

CREATE TABLE `sys_var` (
  `name` varchar(50) NOT NULL,
  `value` longtext,
  `description` varchar(255) DEFAULT NULL,
  `datatype` varchar(15) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_wf` */

DROP TABLE IF EXISTS `sys_wf`;

CREATE TABLE `sys_wf` (
  `name` varchar(50) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_wf_assignee` */

DROP TABLE IF EXISTS `sys_wf_assignee`;

CREATE TABLE `sys_wf_assignee` (
  `objid` varchar(50) NOT NULL,
  `processname` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `user_objid` varchar(50) DEFAULT NULL,
  `expr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_wf_node` */

DROP TABLE IF EXISTS `sys_wf_node`;

CREATE TABLE `sys_wf_node` (
  `name` varchar(50) NOT NULL,
  `processname` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(100) DEFAULT NULL,
  `nodetype` varchar(10) DEFAULT NULL,
  `idx` int(11) DEFAULT NULL,
  `salience` int(11) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`,`processname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_wf_subtask` */

DROP TABLE IF EXISTS `sys_wf_subtask`;

CREATE TABLE `sys_wf_subtask` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `taskid` varchar(50) DEFAULT NULL,
  `requester_objid` varchar(50) DEFAULT NULL,
  `requester_name` varchar(100) DEFAULT NULL,
  `requestdate` datetime DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_sys_wf_subtask_sys_wf_task` (`taskid`),
  CONSTRAINT `FK_sys_wf_subtask_sys_wf_task` FOREIGN KEY (`taskid`) REFERENCES `sys_wf_task` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_wf_task` */

DROP TABLE IF EXISTS `sys_wf_task`;

CREATE TABLE `sys_wf_task` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `refid` varchar(50) DEFAULT NULL,
  `parentprocessid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_wf_transition` */

DROP TABLE IF EXISTS `sys_wf_transition`;

CREATE TABLE `sys_wf_transition` (
  `parentid` varchar(50) NOT NULL DEFAULT '',
  `processname` varchar(50) NOT NULL DEFAULT '',
  `action` varchar(50) NOT NULL DEFAULT '',
  `to` varchar(50) NOT NULL,
  `idx` int(11) DEFAULT NULL,
  `eval` mediumtext,
  `properties` varchar(255) DEFAULT NULL,
  `permission` varchar(255) DEFAULT NULL,
  `caption` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`parentid`,`processname`,`to`,`action`),
  CONSTRAINT `FK_sys_wf_transition_wf_node` FOREIGN KEY (`parentid`, `processname`) REFERENCES `sys_wf_node` (`name`, `processname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_wf_workitemtype` */

DROP TABLE IF EXISTS `sys_wf_workitemtype`;

CREATE TABLE `sys_wf_workitemtype` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL DEFAULT '',
  `processname` varchar(50) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `expr` varchar(255) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`,`state`,`processname`),
  KEY `FK_sys_wf_subtasktype_node` (`state`,`processname`),
  CONSTRAINT `FK_sys_wf_subtasktype_node` FOREIGN KEY (`state`, `processname`) REFERENCES `sys_wf_node` (`name`, `processname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `txnlog` */

DROP TABLE IF EXISTS `txnlog`;

CREATE TABLE `txnlog` (
  `objid` varchar(50) NOT NULL,
  `ref` varchar(100) NOT NULL,
  `refid` text NOT NULL,
  `txndate` datetime NOT NULL,
  `action` varchar(50) NOT NULL,
  `userid` varchar(50) NOT NULL,
  `remarks` text,
  `diff` longtext,
  `username` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txnlog_action` (`action`),
  KEY `ix_txnlog_ref` (`ref`),
  KEY `ix_txnlog_userid` (`userid`),
  KEY `ix_txnlog_useridaction` (`userid`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `txnref` */

DROP TABLE IF EXISTS `txnref`;

CREATE TABLE `txnref` (
  `oid` int(11) NOT NULL AUTO_INCREMENT,
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY (`oid`),
  KEY `ix_txnref_refid` (`refid`),
  KEY `ix_txnref_objid` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `txnsignatory` */

DROP TABLE IF EXISTS `txnsignatory`;

CREATE TABLE `txnsignatory` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `personnelid` varchar(50) DEFAULT NULL,
  `type` varchar(25) NOT NULL,
  `caption` varchar(25) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `dtsigned` datetime DEFAULT NULL,
  `seqno` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_signatory_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `variableinfo` */

DROP TABLE IF EXISTS `variableinfo`;

CREATE TABLE `variableinfo` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `datatype` varchar(20) NOT NULL,
  `caption` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `arrayvalues` longtext,
  `system` int(11) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `workflowstate` */

DROP TABLE IF EXISTS `workflowstate`;

CREATE TABLE `workflowstate` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `userid` varchar(50) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`,`state`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_userid` (`userid`),
  KEY `ix_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
