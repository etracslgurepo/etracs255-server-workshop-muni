#create collection group org table
CREATE TABLE `collectiongroup_org` (
  `objid` varchar(100) NOT NULL,
  `collectiongroupid` varchar(50) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(150) DEFAULT NULL,
  `org_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_collectiongroup_org` (`collectiongroupid`,`org_objid`),
  KEY `ix_collectiongroupid` (`collectiongroupid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_org_name` (`org_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


#insert existing collection orgs into this table
INSERT INTO collectiongroup_org 
 (objid, collectiongroupid, org_objid, org_name, org_type)
 SELECT 
 CONCAT( cg.objid, ':', o.objid ) AS objid,
 cg.objid AS collectiongroupid,
 o.objid AS org_objid,
 o.name AS org_name,
 o.orgclass AS org_type
 FROM collectiongroup cg
 INNER JOIN sys_org o ON cg.org_objid = o.objid

ALTER TABLE collectiongroup DROP COLUMN org_objid;
ALTER TABLE collectiongroup DROP COLUMN org_name;

#create collectiongroup account
CREATE TABLE `collectiongroup_account` (
  `objid` varchar(100) NOT NULL,
  `collectiongroupid` varchar(50) NOT NULL,
  `account_objid` varchar(50) NOT NULL,
  `account_title` varchar(100) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `defaultvalue` decimal(16,2) DEFAULT NULL,
  `valuetype` varchar(20) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_collectiongroup_account` (`collectiongroupid`,`account_objid`),
  KEY `fk_collectiongroup_account_itemaccount` (`account_objid`),
  KEY `ix_collectiongroupid` (`collectiongroupid`),
  KEY `ix_account_objid` (`account_objid`),
  CONSTRAINT `FK_collectiongroup_account` FOREIGN KEY (`account_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `fk_collectiongroup_account_collectiongroup` FOREIGN KEY (`collectiongroupid`) REFERENCES `collectiongroup` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#transfer collectiongroup_revenueitem to collectiongroup_account
INSERT INTO collectiongroup_account
(objid,collectiongroupid,account_objid,account_title,tag,defaultvalue,valuetype,sortorder)
SELECT 
CONCAT(cg.collectiongroupid,':', cg.revenueitemid ) AS objid,
collectiongroupid,
ia.objid AS account_objid,
ia.title AS account_title,
NULL AS tag,
cg.defaultvalue,
cg.valuetype,
cg.orderno AS sortorder
FROM collectiongroup_revenueitem cg
INNER JOIN itemaccount ia ON ia.objid=cg.revenueitemid

DROP TABLE collectiongroup_revenueitem;

ALTER TABLE collectiontype ADD COLUMN allowcreditmemo INT(11);
UPDATE collectiontype SET allowcreditmemo = 0;



