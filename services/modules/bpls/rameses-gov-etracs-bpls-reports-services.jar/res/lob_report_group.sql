CREATE TABLE `lob_report_group` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
);

CREATE TABLE `lob_report_category` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `groupid` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `itemtype` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `lob_report_category_group` (`groupid`),
  CONSTRAINT `lob_report_category_group` 
  	FOREIGN KEY (`groupid`) REFERENCES `lob_report_group` (`objid`)
);

CREATE TABLE `lob_report_category_mapping` (
  `objid` varchar(50)  NOT NULL,
  `lobid` varchar(50) NOT NULL,
  `categoryid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_cmci_lob` (`categoryid`),
  CONSTRAINT `fk_lob_report_category_mapping` FOREIGN KEY (`categoryid`) 
  	REFERENCES `lob_report_category` (`objid`)
); 

