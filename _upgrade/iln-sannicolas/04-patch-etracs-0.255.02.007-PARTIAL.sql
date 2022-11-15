-- ## 2020-08-18

if object_id('dbo.paymentorder_type', 'U') IS NOT NULL 
  drop table dbo.paymentorder_type; 
go 
CREATE TABLE paymentorder_type (
  objid varchar(50) NOT NULL,
  title varchar(150) NULL,
  collectiontype_objid varchar(50) NULL,
  queuesection varchar(50) NULL,
  system int NULL
) 
go 
ALTER TABLE paymentorder_type ADD constraint pk_paymentorder_type PRIMARY KEY (objid)
go 
create index ix_collectiontype_objid on paymentorder_type (collectiontype_objid)
go 


drop index ix_collectiontype_objid on paymentorder_type 
go 
alter table paymentorder_type alter column collectiontype_objid nvarchar(50) null
go 
create index ix_collectiontype_objid on paymentorder_type (collectiontype_objid) 
go 
ALTER TABLE paymentorder_type ADD constraint fk_paymentorder_type_collectiontype_objid 
  foreign key (collectiontype_objid) references collectiontype (objid) 
go 


if object_id('dbo.paymentorder', 'U') IS NOT NULL 
  drop table dbo.paymentorder; 
go 
CREATE TABLE paymentorder (
  objid varchar(50) NOT NULL,
  txndate datetime NULL,
  payer_objid varchar(50) NULL,
  payer_name text,
  paidby text,
  paidbyaddress varchar(150) NULL,
  particulars text,
  amount decimal(16,2) NULL,
  expirydate date NULL,
  refid varchar(50) NULL,
  refno varchar(50) NULL,
  info text,
  locationid varchar(50) NULL,
  origin varchar(50) NULL,
  issuedby_objid varchar(50) NULL,
  issuedby_name varchar(150) NULL,
  org_objid varchar(50) NULL,
  org_name varchar(255) NULL,
  items text,
  queueid varchar(50) NULL,
  paymentordertype_objid varchar(50) NULL,
  controlno varchar(50) NULL
) 
go 
ALTER TABLE paymentorder ADD constraint pk_paymentorder PRIMARY KEY (objid)
go 
create index ix_txndate on paymentorder (txndate) 
go 
create index ix_issuedby_name on paymentorder (issuedby_name) 
go 
create index ix_issuedby_objid on paymentorder (issuedby_objid) 
go 
create index ix_locationid on paymentorder (locationid) 
go 
create index ix_org_name on paymentorder (org_name) 
go 
create index ix_org_objid on paymentorder (org_objid) 
go 
create index ix_paymentordertype_objid on paymentorder (paymentordertype_objid) 
go 
alter table paymentorder add CONSTRAINT fk_paymentorder_paymentordertype_objid 
  FOREIGN KEY (paymentordertype_objid) REFERENCES paymentorder_type (objid) 
go 


if object_id('dbo.paymentorder_paid', 'U') IS NOT NULL 
  drop table dbo.paymentorder_paid; 
go 
CREATE TABLE paymentorder_paid (
  objid varchar(50) NOT NULL,
  txndate datetime NULL,
  payer_objid varchar(50) NULL,
  payer_name text,
  paidby text,
  paidbyaddress varchar(150) NULL,
  particulars text,
  amount decimal(16,2) NULL,
  refid varchar(50) NULL,
  refno varchar(50) NULL,
  info text,
  locationid varchar(50) NULL,
  origin varchar(50) NULL,
  issuedby_objid varchar(50) NULL,
  issuedby_name varchar(150) NULL,
  org_objid varchar(50) NULL,
  org_name varchar(255) NULL,
  items text,
  paymentordertype_objid varchar(50) NULL,
  controlno varchar(50) NULL
) 
go 
ALTER TABLE paymentorder_paid ADD constraint pk_paymentorder_paid PRIMARY KEY (objid)
go 
create index ix_txndate on paymentorder_paid (txndate) 
go 
create index ix_issuedby_name on paymentorder_paid (issuedby_name) 
go 
create index ix_issuedby_objid on paymentorder_paid (issuedby_objid) 
go 
create index ix_locationid on paymentorder_paid (locationid) 
go 
create index ix_org_name on paymentorder_paid (org_name) 
go 
create index ix_org_objid on paymentorder_paid (org_objid) 
go 
create index ix_paymentordertype_objid on paymentorder_paid (paymentordertype_objid) 
go 
alter table paymentorder_paid add CONSTRAINT fk_paymentorder_paid_paymentordertype_objid 
  FOREIGN KEY (paymentordertype_objid) REFERENCES paymentorder_type (objid) 
go 
