ALTER TABLE depositvoucher DROP foreign key fk_depositvoucher_fundid;
ALTER TABLE depositvoucher DROP COLUMN fundid;
ALTER TABLE depositvoucher DROP COLUMN totalcash;
ALTER TABLE depositvoucher DROP COLUMN totalcheck;
ALTER TABLE depositvoucher DROP COLUMN totalcr;

CREATE TABLE `depositvoucher_fund` (
  `objid` varchar(150) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `amountdeposited` decimal(16,4) DEFAULT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `postedby_title` varchar(100) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_depositvoucher_fund_depositvoucher` (`parentid`),
  KEY `fk_depositvoucher_fund_fund` (`fundid`),
  CONSTRAINT `fk_depositvoucher_fund_depositvoucher` FOREIGN KEY (`parentid`) REFERENCES `depositvoucher` (`objid`),
  CONSTRAINT `fk_depositvoucher_fund_fund` FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE collectionvoucher ADD COLUMN depositvoucherid varchar(50);
ALTER TABLE collectionvoucher ADD CONSTRAINT `fk_collectionvoucher_depositvoucher` FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`);
