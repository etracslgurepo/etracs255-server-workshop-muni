RENAME TABLE `jev` TO `jevfund`;
ALTER TABLE jevfund DROP INDEX `ix_batchid`;
ALTER TABLE jevfund DROP INDEX `ix_jevno`; 
ALTER TABLE jevfund DROP INDEX `ix_jevdate`;
ALTER TABLE jevfund DROP INDEX `ix_dtposted`;
ALTER TABLE jevfund DROP INDEX `ix_refid`;
ALTER TABLE jevfund DROP INDEX `ix_refno`;
ALTER TABLE jevfund DROP INDEX `ix_reftype`;
ALTER TABLE jevfund DROP INDEX `ix_postedby_objid`;
ALTER TABLE jevfund DROP INDEX `ix_verifiedby_objid` ;
ALTER TABLE jevfund DROP INDEX `ix_dtverified`;

CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `jevno` varchar(50) DEFAULT NULL,
  `jevdate` date DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `state` varchar(32) NOT NULL,
  `postedby_objid` varchar(50) NOT NULL,
  `postedby_name` varchar(255) NOT NULL,
  `verifiedby_objid` varchar(50) DEFAULT NULL,
  `verifiedby_name` varchar(255) DEFAULT NULL,
  `dtverified` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_jevno` (`jevno`),
  KEY `ix_jevdate` (`jevdate`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  KEY `ix_verifiedby_objid` (`verifiedby_objid`),
  KEY `ix_dtverified` (`dtverified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO jev (objid, dtposted, postedby_objid, postedby_name, refid, refno, reftype, refdate, amount, state, verifiedby_objid, verifiedby_name, dtverified,txntype) 
SELECT refid, MIN(dtposted), MAX(postedby_objid), MAX(postedby_name), 
refid, MAX(refno), MAX(reftype), MAX(refdate), SUM(amount) AS amount, MAX(state), MAX(verifiedby_objid), MAX(verifiedby_name), MAX(dtverified), MAX(txntype) 
FROM jevfund GROUP BY refid;

ALTER TABLE jevfund ADD COLUMN jevid VARCHAR(50);
ALTER TABLE `jevfund` ADD CONSTRAINT `fk_jevfund_jev` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`);
UPDATE jevfund SET jevid = refid;
ALTER TABLE jevfund DROP COLUMN jevno;
ALTER TABLE jevfund DROP COLUMN jevdate;
ALTER TABLE jevfund DROP COLUMN dtposted;
ALTER TABLE jevfund DROP COLUMN txntype;
ALTER TABLE jevfund DROP COLUMN refid;
ALTER TABLE jevfund DROP COLUMN refno;
ALTER TABLE jevfund DROP COLUMN reftype;
ALTER TABLE jevfund DROP COLUMN refdate;
ALTER TABLE jevfund DROP COLUMN state;
ALTER TABLE jevfund DROP COLUMN postedby_objid;
ALTER TABLE jevfund DROP COLUMN postedby_name;
ALTER TABLE jevfund DROP COLUMN verifiedby_objid;
ALTER TABLE jevfund DROP COLUMN verifiedby_name;
ALTER TABLE jevfund DROP COLUMN dtverified;
ALTER TABLE jevfund DROP COLUMN batchid;

ALTER TABLE `jevitem` CHANGE `jevid` `jevfundid` VARCHAR(150)  ;
ALTER TABLE `jevitem` ADD CONSTRAINT `fk_jevfunditem_jevfund` FOREIGN KEY (`jevfundid`) REFERENCES `jevfund` (`objid`);
