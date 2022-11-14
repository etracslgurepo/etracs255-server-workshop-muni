DROP TABLE paymentorder;
DROP TABLE paymentorder_paid;
DROP TABLE paymentorder_type;

CREATE TABLE `barcode_launcher` (
  `objid` varchar(50) NOT NULL,
  `connection` varchar(50) DEFAULT NULL,
  `paymentorder` int(1) DEFAULT NULL,
  `collectiontypeid` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
);

CREATE TABLE `paymentorder_type` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `collectiontype_objid` varchar(50) DEFAULT NULL,
  `collectiontype_name` varchar(50) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_paymentorder_type_collectiontypeid` (`collectiontype_objid`)
); 

CREATE TABLE `paymentorder` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `typeid` varchar(50) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) DEFAULT NULL,
  `particulars` varchar(500) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `params` text,
  `origin` varchar(100) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `locationid` varchar(25) DEFAULT NULL,
  `items` mediumtext,
  `state` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobileno` varchar(50) DEFAULT NULL,
  `issuedby_objid` varchar(50) DEFAULT NULL,
  `issuedby_name` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_paymentorder_typeid` (`typeid`),
  CONSTRAINT `fk_paymentorder_typeid` FOREIGN KEY (`typeid`) REFERENCES `paymentorder_type` (`objid`)
);


CREATE TABLE `paymentorder_paid` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `typeid` varchar(50) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) DEFAULT NULL,
  `particulars` varchar(500) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `info` text,
  `origin` varchar(100) DEFAULT NULL,
  `locationid` varchar(25) DEFAULT NULL,
  `items` mediumtext,
  `state` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobileno` varchar(50) DEFAULT NULL,
  `issuedby_objid` varchar(50) DEFAULT NULL,
  `issuedby_name` varchar(150) DEFAULT NULL,
  `receiptno` varchar(50) DEFAULT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `receiptdate` varchar(50) DEFAULT NULL,  
  PRIMARY KEY (`objid`),
  KEY `fk_paymentorder_paid_typeid` (`typeid`),
  CONSTRAINT `fk_paymentorder_paid_typeid` FOREIGN KEY (`typeid`) REFERENCES `paymentorder_type` (`objid`)
);


#update vw_collectiontype
ALTER TABLE `collectiontype` 
ADD COLUMN `connection` varchar(150) NULL,
ADD COLUMN `servicename` varchar(255) NULL;

DROP VIEW IF EXISTS vw_collectiontype;
CREATE VIEW  vw_collectiontype AS 
SELECT
   c.objid AS objid,
   c.state AS state,
   c.name AS name,
   c.title AS title,
   c.formno AS formno,
   c.handler AS handler,
   c.allowbatch AS allowbatch,
   c.barcodekey AS barcodekey,
   c.allowonline AS allowonline,
   c.allowoffline AS allowoffline,
   c.sortorder AS sortorder,
   o.org_objid AS orgid,
   c.fund_objid AS fund_objid,
   c.fund_title AS fund_title,
   c.category AS category,
   c.queuesection AS queuesection,
   c.system AS system,
   af.formtype AS af_formtype,
   af.serieslength AS af_serieslength,
   af.denomination AS af_denomination,
   af.baseunit AS af_baseunit,
   c.allowpaymentorder AS allowpaymentorder,
   c.allowkiosk AS allowkiosk,
   c.allowcreditmemo,
   c.connection,
   c.servicename
FROM collectiontype_org o
INNER JOIN  collectiontype c on c.objid = o.collectiontypeid
INNER JOIN af ON af.objid = c.formno
WHERE c.state = 'ACTIVE'

UNION 

SELECT 
   c.objid AS objid,
   c.state AS state,
   c.name AS name,
   c.title AS title,
   c.formno AS formno,
   c.handler AS handler,
   c.allowbatch AS allowbatch,
   c.barcodekey AS barcodekey,
   c.allowonline AS allowonline,
   c.allowoffline AS allowoffline,
   c.sortorder AS sortorder,
   NULL AS orgid,
   c.fund_objid AS fund_objid,
   c.fund_title AS fund_title,
   c.category AS category,
   c.queuesection AS queuesection,
   c.system AS system,
   af.formtype AS af_formtype,
   af.serieslength AS af_serieslength,
   af.denomination AS af_denomination,
   af.baseunit AS af_baseunit,
   c.allowpaymentorder AS allowpaymentorder,
   c.allowkiosk AS allowkiosk,
   c.allowcreditmemo,
   c.connection,
   c.servicename 
FROM collectiontype c 
INNER JOIN af ON af.objid = c.formno
LEFT JOIN collectiontype_org o ON c.objid = o.collectiontypeid
WHERE o.objid IS NULL AND c.state = 'ACTIVE';

UPDATE collectiontype ct, cashreceipt_plugin cp 
SET ct.connection = cp.connection, ct.servicename = cp.servicename 
WHERE ct.handler = cp.objid; 

DELETE FROM cashreceipt_plugin;

INSERT INTO barcode_launcher 
(objid,title,connection,collectiontypeid, paymentorder)
select barcodekey AS objid,title,connection,objid AS collectiontypeid, 0 AS paymentorder 
from collectiontype WHERE NOT(barcodekey IS NULL);

INSERT INTO barcode_launcher 
(objid,title,paymentorder)
VALUES ('PMO', 'PAYMENT ORDER ETRACS', 1 );

UPDATE collectiontype SET barcodekey = NULL;




