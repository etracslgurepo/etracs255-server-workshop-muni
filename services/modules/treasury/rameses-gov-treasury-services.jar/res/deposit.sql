
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
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_controlno` (`controlno`),
  KEY `ix_controldate` (`controldate`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_createdby_name` (`createdby_name`),
  KEY `ix_dtcreated` (`dtcreated`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  KEY `ix_postedby_name` (`postedby_name`),
  KEY `ix_dtposted` (`dtposted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `depositvoucher_fund` (
  `objid` varchar(150) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `amountdeposited` decimal(16,4) DEFAULT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `totaldr` decimal(16,4) DEFAULT NULL,
  `totalcr` decimal(16,4) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `postedby_title` varchar(100) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_depositvoucher_fund_depositvoucher` (`parentid`),
  KEY `fk_depositvoucher_fund_fund` (`fundid`),
  CONSTRAINT `fk_depositvoucher_fund_depositvoucher` FOREIGN KEY (`parentid`) REFERENCES `depositvoucher` (`objid`),
  CONSTRAINT `fk_depositvoucher_fund_fund` FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `deposit_fund_transfer` (
  `objid` varchar(255) NOT NULL,
  `fromdepositvoucherfundid` varchar(50) DEFAULT NULL,
  `todepositvoucherfundid` varchar(50) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_collectionvoucherid` (`fromdepositvoucherfundid`),
  KEY `fk_deposit_fund_transfer_tovoucher` (`todepositvoucherfundid`),
  CONSTRAINT `fk_deposit_fund_transfer_fromvoucher` FOREIGN KEY (`fromdepositvoucherfundid`) REFERENCES `depositvoucher_fund` (`objid`),
  CONSTRAINT `fk_deposit_fund_transfer_tovoucher` FOREIGN KEY (`todepositvoucherfundid`) REFERENCES `depositvoucher_fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `depositslip` (
  `objid` varchar(50) NOT NULL,
  `depositvoucherfundid` varchar(50) DEFAULT NULL,
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
  `state` varchar(10) DEFAULT NULL,
  `deposittype` varchar(50) DEFAULT NULL,
  `checktype` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_depositvoucherid` (`depositvoucherfundid`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_depositdate` (`depositdate`),
  KEY `ix_dtcreated` (`dtcreated`),
  KEY `ix_bankacctid` (`bankacctid`),
  CONSTRAINT `fk_depositslip_depositvoucherfund` FOREIGN KEY (`depositvoucherfundid`) REFERENCES `depositvoucher_fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `interfund_transfer_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(50) DEFAULT NULL,
  `itemacctid` varchar(50) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_jevid` (`jevid`),
  KEY `ix_itemacctid` (`itemacctid`),
  CONSTRAINT `fk_interfund_transfer_jev` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


