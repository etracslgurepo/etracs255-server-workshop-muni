/*
SQLyog Enterprise - MySQL GUI v7.15 
MySQL - 5.0.27-community-nt : Database - etracstc
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `af` */

CREATE TABLE `af` (
  `objid` varchar(50) NOT NULL,
  `description` varchar(50) NOT NULL,
  `aftype` varchar(10) NOT NULL,
  `unit` varchar(10) NOT NULL,
  `unitqty` int(11) NOT NULL,
  `denomination` decimal(10,2) NOT NULL,
  `serieslength` int(11) NOT NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afcontrol` */

CREATE TABLE `afcontrol` (
  `objid` varchar(50) NOT NULL,
  `mode` varchar(10) default NULL,
  `state` varchar(10) default NULL,
  `af` varchar(10) default NULL,
  `collector` varchar(50) default NULL,
  `assignee` varchar(50) default NULL,
  `startseries` int(11) default NULL,
  `endseries` int(11) default NULL,
  `currentseries` int(11) default NULL,
  `lastremittedseries` int(11) default NULL,
  `beginseries` int(11) default NULL,
  `prefix` varchar(10) default NULL,
  `suffix` varchar(10) default NULL,
  `stub` int(11) default NULL,
  `active` int(11) default NULL,
  `refid` varchar(50) default NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afcontrolbeginbalance` */

CREATE TABLE `afcontrolbeginbalance` (
  `objid` varchar(50) NOT NULL,
  `af` varchar(10) default NULL,
  `collector` varchar(50) default NULL,
  `startseries` int(11) default NULL,
  `endseries` int(11) default NULL,
  `qty` int(11) default NULL,
  `startstub` int(11) default NULL,
  `prefix` varchar(10) default NULL,
  `suffix` varchar(10) default NULL,
  `txndate` datetime default NULL,
  `createdby` varchar(50) default NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afcontrolcancelled` */

CREATE TABLE `afcontrolcancelled` (
  `objid` varchar(50) NOT NULL,
  `controlid` varchar(50) default NULL,
  `startseries` int(11) default NULL,
  `endseries` int(11) default NULL,
  `reason` varchar(50) default NULL,
  `collector` varchar(50) default NULL,
  `txndate` datetime default NULL,
  `qty` int(11) default NULL,
  `issuedby` varchar(50) default NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afcontroltransferhistory` */

CREATE TABLE `afcontroltransferhistory` (
  `objid` varchar(50) NOT NULL,
  `controlid` varchar(50) default NULL,
  `txndate` datetime default NULL,
  `collector` varchar(50) default NULL,
  `assignee` varchar(50) default NULL,
  `startseries` int(11) default NULL,
  `endseries` int(11) default NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afinventorycontrol` */

CREATE TABLE `afinventorycontrol` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime default NULL,
  `state` varchar(10) default NULL,
  `af` varchar(10) default NULL,
  `receiptid` varchar(50) default NULL,
  `reqid` varchar(50) default NULL,
  `startstub` int(11) default NULL,
  `endstub` int(11) default NULL,
  `currentstub` int(50) default NULL,
  `startseries` int(11) default NULL,
  `endseries` int(11) default NULL,
  `currentseries` int(11) default NULL,
  `prefix` varchar(50) default NULL,
  `suffix` varchar(50) default NULL,
  `qtyreceived` int(11) default NULL,
  `qtyissued` int(11) default NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afreceipt` */

CREATE TABLE `afreceipt` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) default NULL,
  `txndate` datetime default NULL,
  `txntype` varchar(10) default NULL,
  `reqid` varchar(50) default NULL,
  `issuer` varchar(50) default NULL,
  `issueto` varchar(50) default NULL,
  `createdby` varchar(50) default NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afreceiptitem` */

CREATE TABLE `afreceiptitem` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL default '',
  `af` varchar(10) default NULL,
  `qty` int(11) default NULL,
  `startseries` int(11) default NULL,
  `endseries` int(11) default NULL,
  `prefix` varchar(10) default NULL,
  `suffix` varchar(10) default NULL,
  `startstub` varchar(50) default NULL,
  `endstub` varchar(50) default NULL,
  `controlid` varchar(50) default NULL,
  PRIMARY KEY  (`objid`),
  KEY `FK_afreceiptitem_af` (`af`),
  CONSTRAINT `FK_afreceiptitem_af` FOREIGN KEY (`af`) REFERENCES `af` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afrequest` */

CREATE TABLE `afrequest` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) default NULL,
  `txndate` datetime default NULL,
  `txntype` varchar(10) default NULL,
  `requester` varchar(50) default NULL,
  `reqdate` datetime default NULL,
  `requnit` varchar(50) default NULL,
  `createdby` varchar(50) default NULL,
  `vendor` varchar(50) default NULL,
  `receiptid` varchar(50) default NULL,
  PRIMARY KEY  (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `afrequestitem` */

CREATE TABLE `afrequestitem` (
  `objid` varchar(50) NOT NULL,
  `reqid` varchar(50) default NULL,
  `af` varchar(10) default NULL,
  `qty` int(11) default '0',
  `qtyreceived` int(11) default '0',
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `req_af_uidx` (`reqid`,`af`),
  KEY `FK_afrequestitem_af` (`af`),
  CONSTRAINT `FK_afrequestitem` FOREIGN KEY (`reqid`) REFERENCES `afrequest` (`objid`),
  CONSTRAINT `FK_afrequestitem_af` FOREIGN KEY (`af`) REFERENCES `af` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
