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
