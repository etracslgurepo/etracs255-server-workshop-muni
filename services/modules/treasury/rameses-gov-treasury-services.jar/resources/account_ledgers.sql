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
  `bankacctid` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `cash_treasury_ledger` */

DROP TABLE IF EXISTS `cash_treasury_ledger`;

CREATE TABLE `cash_treasury_ledger` (
  `objid` varchar(150) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  `liquidatingofficer_objid` varchar(50) DEFAULT NULL,
  `liquidatingofficer_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `income_summary` */

DROP TABLE IF EXISTS `income_summary`;

CREATE TABLE `income_summary` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `item_objid` varchar(50) NOT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `fund_objid` varchar(50) NOT NULL,
  `org_objid` varchar(50) NOT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_acctid` (`item_objid`),
  KEY `ix_fundid` (`fund_objid`),
  KEY `ix_orgid` (`org_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `payable_summary` */

DROP TABLE IF EXISTS `payable_summary`;

CREATE TABLE `payable_summary` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `item_objid` varchar(50) NOT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `fund_objid` varchar(50) NOT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_acctid` (`item_objid`),
  KEY `ix_fundid` (`fund_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
