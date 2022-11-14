
CREATE TABLE `bank` (
  `objid` varchar(50) NOT NULL default '',
  `state` varchar(10) NOT NULL COMMENT 'DRAFT, APPROVED',
  `code` varchar(50) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `branchname` varchar(50) NOT NULL default '',
  `address` varchar(100) default NULL,
  `manager` varchar(50) default NULL,
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `ux_bank_code` (`code`),
  UNIQUE KEY `ux_bank_name` (`name`),
  KEY `ix_bank_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `bankaccount` */

CREATE TABLE `fund` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `parentid` varchar(50) default NULL,
  `fund` varchar(50) NOT NULL,
  `fundname` varchar(50) NOT NULL,
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `ux_fund_fundname` (`fundname`),
  KEY `ix_fund_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `itemaccount` */
CREATE TABLE `bankaccount` (
  `objid` varchar(50) NOT NULL default '',
  `state` varchar(10) NOT NULL default '' COMMENT 'DRAFT, APPROVED',
  `name` varchar(50) NOT NULL default '',
  `acctno` varchar(50) NOT NULL default '',
  `accttype` varchar(50) NOT NULL default '' COMMENT 'CHECKING, SAVING',
  `fundid` varchar(50) NOT NULL default '',
  `bankid` varchar(50) NOT NULL default '',
  `currency` varchar(50) NOT NULL default '' COMMENT 'PHP, USD',
  `cashreport` varchar(50) default NULL,
  `cashbreakdownreport` varchar(50) default NULL,
  `checkreport` varchar(50) default NULL,
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `ux_bankaccount_acctno` (`acctno`,`bankid`),
  KEY `FK_bankaccount_fund` (`fundid`),
  KEY `FK_bankaccount_bank` (`bankid`),
  CONSTRAINT `FK_bankaccount_bank` FOREIGN KEY (`bankid`) REFERENCES `bank` (`objid`),
  CONSTRAINT `FK_bankaccount_fund` FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `fund` */



CREATE TABLE `itemaccount` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL default '' COMMENT 'DRAFT, APPROVED',
  `acctcode` varchar(25) default NULL,
  `accttitle` varchar(250) NOT NULL,
  `fundid` varchar(50) default NULL,
  `systype` varchar(25) default NULL,
  `valuetype` varchar(25) default NULL,
  `defaultvalue` decimal(12,2) NOT NULL,
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `ux_itemaccount_acctitle` (`accttitle`),
  KEY `ix_itemaccount_acctno` (`acctcode`),
  KEY `ix_itemaccount_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `itemaccountgroup` */

CREATE TABLE `itemaccountgroup` (
  `objid` varchar(50) NOT NULL default '',
  `state` varchar(10) NOT NULL COMMENT 'DRAFT, APPROVED',
  `name` varchar(100) NOT NULL,
  `remarks` varchar(100) default NULL,
  PRIMARY KEY  (`objid`),
  UNIQUE KEY `ux_itemaccountgroup_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;