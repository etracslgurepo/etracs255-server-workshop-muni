CREATE TABLE `business_billitem_txntype` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `feetype` varchar(50) DEFAULT NULL,
  `domain` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`)
);

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
);