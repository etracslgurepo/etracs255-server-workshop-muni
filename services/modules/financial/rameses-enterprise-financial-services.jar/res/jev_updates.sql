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
/*Table structure for table `bankaccount_ledger` */

DROP TABLE IF EXISTS `bankaccount_ledger`;

CREATE TABLE `bankaccount_ledger` (
  `objid` varchar(50) NOT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  `bankacctid` varchar(50) DEFAULT NULL,
  `itemacctid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_bankaccount_ledger_jev` (`jevid`),
  CONSTRAINT `fk_bankaccount_ledger_jev` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cash_treasury_ledger` */

DROP TABLE IF EXISTS `cash_treasury_ledger`;

CREATE TABLE `cash_treasury_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  `itemacctid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_cash_treasury_jev` (`jevid`),
  CONSTRAINT `fk_cash_treasury_jev` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
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
  `jevid` varchar(50) DEFAULT NULL,
  `jevno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_liquidationid` (`parentid`),
  KEY `ix_fund_objid` (`fund_objid`),
  KEY `ix_objid_controlno` (`objid`,`controlno`),
  CONSTRAINT `fk_collectionvoucher_fund_fund` FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`),
  CONSTRAINT `fk_collectionvoucher_fund_parent` FOREIGN KEY (`parentid`) REFERENCES `collectionvoucher` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `depositslip` */

DROP TABLE IF EXISTS `depositslip`;

CREATE TABLE `depositslip` (
  `objid` varchar(50) NOT NULL,
  `depositvoucherid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
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
  `jevid` varchar(50) DEFAULT NULL,
  `jevno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_depositvoucher_fund_depositvoucher` (`parentid`),
  KEY `fk_depositvoucher_fund_fund` (`fundid`),
  CONSTRAINT `fk_depositvoucher_fund_depositvoucher` FOREIGN KEY (`parentid`) REFERENCES `depositvoucher` (`objid`),
  CONSTRAINT `fk_depositvoucher_fund_fund` FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `income_ledger` */

DROP TABLE IF EXISTS `income_ledger`;

CREATE TABLE `income_ledger` (
  `objid` varchar(50) NOT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_acctid` (`itemacctid`),
  KEY `fk_income_ledger_jev` (`jevid`),
  CONSTRAINT `fk_income_ledger_jev` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `jev` */

DROP TABLE IF EXISTS `jev`;

CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `jevno` varchar(50) DEFAULT NULL,
  `jevdate` date DEFAULT NULL,
  `fundid` varchar(50) NOT NULL,
  `dtposted` datetime NOT NULL,
  `txntype` varchar(50) NOT NULL,
  `refid` varchar(150) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `verifiedby_objid` varchar(50) DEFAULT NULL,
  `verifiedby_name` varchar(50) DEFAULT NULL,
  `dtverified` datetime DEFAULT NULL,
  `batchid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_refid_fundid` (`fundid`,`refid`),
  KEY `ix_jevno` (`jevno`),
  KEY `ix_jevdate` (`jevdate`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_refno` (`refno`),
  KEY `ix_reftype` (`reftype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `payable_ledger` */

DROP TABLE IF EXISTS `payable_ledger`;

CREATE TABLE `payable_ledger` (
  `objid` varchar(50) NOT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  `refitemacctid` varchar(50) DEFAULT NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_acctid` (`itemacctid`),
  KEY `fk_payable_ledger_jev` (`jevid`),
  CONSTRAINT `fk_payable_ledger_jev` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
