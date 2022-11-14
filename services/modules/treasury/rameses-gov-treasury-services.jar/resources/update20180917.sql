ALTER TABLE checkpayment CHANGE collectorid collector_objid varchar(50);
ALTER TABLE checkpayment ADD COLUMN collector_name VARCHAR(255);
ALTER TABLE checkpayment ADD COLUMN subcollector_objid VARCHAR(50);
ALTER TABLE checkpayment ADD COLUMN subcollector_name VARCHAR(255);
UPDATE checkpayment cp, sys_user u
SET cp.collector_name = u.name 
WHERE cp.collector_objid = u.objid;

ALTER TABLE checkpayment_deadchecks CHANGE collectorid collector_objid varchar(50);
ALTER TABLE checkpayment_deadchecks ADD COLUMN collector_name VARCHAR(255);
ALTER TABLE checkpayment_deadchecks ADD COLUMN subcollector_objid VARCHAR(50);
ALTER TABLE checkpayment_deadchecks ADD COLUMN subcollector_name VARCHAR(255);

DROP TABLE IF EXISTS eftpayment;
CREATE TABLE eftpayment (
  objid varchar(50) NOT NULL,
  bankacctid varchar(50) DEFAULT NULL,
  refno varchar(50) DEFAULT NULL,
  refdate date DEFAULT NULL,
  amount decimal(16,4) DEFAULT NULL,
  receivedfrom varchar(255) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  fundid varchar(100) DEFAULT NULL,
  particulars varchar(255) DEFAULT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  receiptid varchar(50) DEFAULT NULL,
  receiptno varchar(50) DEFAULT NULL,
  payer_objid varchar(50) DEFAULT NULL,
  payer_name varchar(255) DEFAULT NULL,
  payer_address_objid varchar(50) DEFAULT NULL,
  payer_address_text varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid),
  KEY ix_bankacctid (bankacctid),
  KEY ix_refno (refno),
  KEY ix_fundid (fundid),
  CONSTRAINT fk_eftpayment_bankacct FOREIGN KEY (bankacctid) REFERENCES bankaccount (objid),
  CONSTRAINT fk_eftpayment_fund FOREIGN KEY (fundid) REFERENCES fund (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE itemaccount ADD COLUMN generic INT(11);
update itemaccount SET generic = 0;
ALTER TABLE itemaccount ADD column sortorder INT(11)
UPDATE itemaccount SET sortorder = 0;



