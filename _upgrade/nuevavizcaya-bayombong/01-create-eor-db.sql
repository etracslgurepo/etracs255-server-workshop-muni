CREATE DATABASE [eor]
GO

USE [eor]
GO

-- ----------------------------
-- Table structure for eor
-- ----------------------------
CREATE TABLE [dbo].[eor] (
[objid] varchar(50) NOT NULL ,
[receiptno] varchar(50) NULL ,
[receiptdate] date NULL ,
[txndate] datetime NULL ,
[state] varchar(10) NULL ,
[partnerid] varchar(50) NULL ,
[txntype] varchar(20) NULL ,
[traceid] varchar(50) NULL ,
[tracedate] datetime NULL ,
[refid] varchar(50) NULL ,
[paidby] varchar(255) NULL ,
[paidbyaddress] varchar(255) NULL ,
[payer_objid] varchar(50) NULL ,
[paymethod] varchar(20) NULL ,
[paymentrefid] varchar(50) NULL ,
[remittanceid] varchar(50) NULL ,
[remarks] varchar(255) NULL ,
[amount] decimal(16,4) NULL ,
[lockid] varchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for eor_for_email
-- ----------------------------
CREATE TABLE [dbo].[eor_for_email] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NULL ,
[email] varchar(255) NULL ,
[mobileno] varchar(50) NULL ,
[state] int NULL ,
[dtsent] datetime NULL ,
[errmsg] text NULL 
)


GO

-- ----------------------------
-- Table structure for eor_item
-- ----------------------------
CREATE TABLE [dbo].[eor_item] (
[objid] varchar(50) NOT NULL ,
[parentid] varchar(50) NULL ,
[item_objid] varchar(50) NULL ,
[item_code] varchar(100) NULL ,
[item_title] varchar(100) NULL ,
[amount] decimal(16,4) NULL ,
[remarks] varchar(255) NULL ,
[item_fund_objid] varchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for eor_manual_post
-- ----------------------------
CREATE TABLE [dbo].[eor_manual_post] (
[objid] varchar(50) NOT NULL ,
[state] varchar(10) NULL ,
[paymentorderno] varchar(50) NULL ,
[amount] decimal(16,4) NULL ,
[txntype] varchar(50) NULL ,
[paymentpartnerid] varchar(50) NULL ,
[traceid] varchar(50) NULL ,
[tracedate] datetime NULL ,
[reason] text NULL ,
[createdby_objid] varchar(50) NULL ,
[createdby_name] varchar(255) NULL ,
[dtcreated] datetime NULL 
)


GO

-- ----------------------------
-- Table structure for eor_number
-- ----------------------------
CREATE TABLE [dbo].[eor_number] (
[objid] varchar(255) NOT NULL ,
[currentno] int NOT NULL 
)


GO

-- ----------------------------
-- Table structure for eor_payment_error
-- ----------------------------
CREATE TABLE [dbo].[eor_payment_error] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NOT NULL ,
[paymentrefid] varchar(50) NOT NULL ,
[errmsg] text NOT NULL ,
[errdetail] varchar(MAX) NULL ,
[errcode] int NULL ,
[laststate] int NULL 
)


GO

-- ----------------------------
-- Table structure for eor_paymentorder
-- ----------------------------
CREATE TABLE [dbo].[eor_paymentorder] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NULL ,
[txntype] varchar(50) NULL ,
[txntypename] varchar(100) NULL ,
[payer_objid] varchar(50) NULL ,
[payer_name] varchar(MAX) NULL ,
[paidby] varchar(MAX) NULL ,
[paidbyaddress] varchar(150) NULL ,
[particulars] varchar(500) NULL ,
[amount] decimal(16,2) NULL ,
[expirydate] date NULL ,
[refid] varchar(50) NULL ,
[refno] varchar(50) NULL ,
[info] varchar(MAX) NULL ,
[origin] varchar(100) NULL ,
[controlno] varchar(50) NULL ,
[locationid] varchar(25) NULL ,
[items] varchar(MAX) NULL ,
[state] varchar(50) NULL ,
[email] varchar(50) NULL ,
[mobile] varchar(50) NULL ,
[mobileno] varchar(15) NULL 
)


GO

-- ----------------------------
-- Table structure for eor_paymentorder_cancelled
-- ----------------------------
CREATE TABLE [dbo].[eor_paymentorder_cancelled] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NULL ,
[txntype] varchar(50) NULL ,
[txntypename] varchar(100) NULL ,
[payer_objid] varchar(50) NULL ,
[payer_name] varchar(MAX) NULL ,
[paidby] varchar(MAX) NULL ,
[paidbyaddress] varchar(150) NULL ,
[particulars] text NULL ,
[amount] decimal(16,2) NULL ,
[expirydate] date NULL ,
[refid] varchar(50) NULL ,
[refno] varchar(50) NULL ,
[info] varchar(MAX) NULL ,
[origin] varchar(100) NULL ,
[controlno] varchar(50) NULL ,
[locationid] varchar(25) NULL ,
[items] varchar(MAX) NULL ,
[state] varchar(10) NULL ,
[email] varchar(255) NULL ,
[mobileno] varchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for eor_paymentorder_paid
-- ----------------------------
CREATE TABLE [dbo].[eor_paymentorder_paid] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NULL ,
[txntype] varchar(50) NULL ,
[txntypename] varchar(100) NULL ,
[payer_objid] varchar(50) NULL ,
[payer_name] varchar(MAX) NULL ,
[paidby] varchar(MAX) NULL ,
[paidbyaddress] varchar(150) NULL ,
[particulars] text NULL ,
[amount] decimal(16,2) NULL ,
[expirydate] date NULL ,
[refid] varchar(50) NULL ,
[refno] varchar(50) NULL ,
[info] varchar(MAX) NULL ,
[origin] varchar(100) NULL ,
[controlno] varchar(50) NULL ,
[locationid] varchar(25) NULL ,
[items] varchar(MAX) NULL ,
[state] varchar(10) NULL ,
[email] varchar(255) NULL ,
[mobileno] varchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for eor_remittance
-- ----------------------------
CREATE TABLE [dbo].[eor_remittance] (
[objid] varchar(50) NOT NULL ,
[state] varchar(50) NULL ,
[controlno] varchar(50) NULL ,
[partnerid] varchar(50) NULL ,
[controldate] date NULL ,
[dtcreated] datetime NULL ,
[createdby_objid] varchar(50) NULL ,
[createdby_name] varchar(255) NULL ,
[amount] decimal(16,4) NULL ,
[dtposted] datetime NULL ,
[postedby_objid] varchar(50) NULL ,
[postedby_name] varchar(255) NULL ,
[lockid] varchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for eor_remittance_fund
-- ----------------------------
CREATE TABLE [dbo].[eor_remittance_fund] (
[objid] varchar(100) NOT NULL ,
[remittanceid] varchar(50) NULL ,
[fund_objid] varchar(50) NULL ,
[fund_code] varchar(50) NULL ,
[fund_title] varchar(255) NULL ,
[amount] decimal(16,4) NULL ,
[bankaccount_objid] varchar(50) NULL ,
[bankaccount_title] varchar(255) NULL ,
[bankaccount_bank_name] varchar(255) NULL ,
[validation_refno] varchar(50) NULL ,
[validation_refdate] date NULL 
)


GO

-- ----------------------------
-- Table structure for eor_share
-- ----------------------------
CREATE TABLE [dbo].[eor_share] (
[objid] varchar(50) NOT NULL ,
[parentid] varchar(50) NOT NULL ,
[refitem_objid] varchar(50) NULL ,
[refitem_code] varchar(25) NULL ,
[refitem_title] varchar(255) NULL ,
[payableitem_objid] varchar(50) NULL ,
[payableitem_code] varchar(25) NULL ,
[payableitem_title] varchar(255) NULL ,
[amount] decimal(16,4) NULL ,
[share] decimal(16,2) NULL ,
[receiptitemid] varchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for epayment_plugin
-- ----------------------------
CREATE TABLE [dbo].[epayment_plugin] (
[objid] varchar(50) NOT NULL ,
[connection] varchar(50) NULL ,
[servicename] varchar(255) NULL 
)


GO

-- ----------------------------
-- Table structure for jev
-- ----------------------------
CREATE TABLE [dbo].[jev] (
[objid] varchar(150) NOT NULL ,
[jevno] varchar(50) NULL ,
[jevdate] date NULL ,
[fundid] varchar(50) NULL ,
[dtposted] datetime NULL ,
[txntype] varchar(50) NULL ,
[refid] varchar(50) NULL ,
[refno] varchar(50) NULL ,
[reftype] varchar(50) NULL ,
[amount] decimal(16,4) NULL ,
[state] varchar(32) NULL ,
[postedby_objid] varchar(50) NULL ,
[postedby_name] varchar(255) NULL ,
[verifiedby_objid] varchar(50) NULL ,
[verifiedby_name] varchar(255) NULL ,
[dtverified] datetime NULL ,
[batchid] varchar(50) NULL ,
[refdate] date NULL 
)


GO

-- ----------------------------
-- Table structure for jevitem
-- ----------------------------
CREATE TABLE [dbo].[jevitem] (
[objid] varchar(150) NOT NULL ,
[jevid] varchar(150) NULL ,
[accttype] varchar(50) NULL ,
[acctid] varchar(50) NULL ,
[acctcode] varchar(32) NULL ,
[acctname] varchar(255) NULL ,
[dr] decimal(16,4) NULL ,
[cr] decimal(16,4) NULL ,
[particulars] varchar(255) NULL ,
[itemrefid] varchar(255) NULL 
)


GO

-- ----------------------------
-- Table structure for paymentpartner
-- ----------------------------
CREATE TABLE [dbo].[paymentpartner] (
[objid] varchar(50) NOT NULL ,
[code] varchar(50) NULL ,
[name] varchar(100) NULL ,
[branch] varchar(255) NULL ,
[contact] varchar(255) NULL ,
[mobileno] varchar(32) NULL ,
[phoneno] varchar(32) NULL ,
[email] varchar(255) NULL ,
[indexno] varchar(3) NULL 
)


GO

-- ----------------------------
-- Table structure for sys_email_queue
-- ----------------------------
CREATE TABLE [dbo].[sys_email_queue] (
[objid] varchar(50) NOT NULL ,
[refid] varchar(50) NOT NULL ,
[state] int NOT NULL ,
[reportid] varchar(50) NULL ,
[dtsent] datetime NOT NULL ,
[to] varchar(255) NOT NULL ,
[subject] varchar(255) NOT NULL ,
[message] text NOT NULL ,
[errmsg] varchar(MAX) NULL ,
[connection] varchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for sys_email_template
-- ----------------------------
CREATE TABLE [dbo].[sys_email_template] (
[objid] varchar(50) NOT NULL ,
[subject] varchar(255) NOT NULL ,
[message] varchar(MAX) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for unpostedpayment
-- ----------------------------
CREATE TABLE [dbo].[unpostedpayment] (
[objid] varchar(50) NOT NULL ,
[txndate] datetime NOT NULL ,
[txntype] varchar(50) NOT NULL ,
[txntypename] varchar(150) NOT NULL ,
[paymentrefid] varchar(50) NOT NULL ,
[amount] decimal(16,2) NOT NULL ,
[orgcode] varchar(20) NOT NULL ,
[partnerid] varchar(50) NOT NULL ,
[traceid] varchar(100) NOT NULL ,
[tracedate] datetime NOT NULL ,
[refno] varchar(50) NULL ,
[origin] varchar(50) NULL ,
[paymentorder] varchar(MAX) NULL ,
[errmsg] varchar(MAX) NOT NULL ,
[errdetail] varchar(MAX) NULL 
)


GO

-- ----------------------------
-- View structure for vw_remittance_eor_item
-- ----------------------------
CREATE VIEW [dbo].[vw_remittance_eor_item] AS 
select 
  c.remittanceid AS remittanceid,
  r.controldate AS remittance_controldate,
  r.controlno AS remittance_controlno,
  cri.parentid AS receiptid,
  c.receiptdate AS receiptdate,
  c.receiptno AS receiptno,
  c.paidby AS paidby,
  c.paidbyaddress AS paidbyaddress,
  cri.item_fund_objid AS fundid,
  cri.item_objid AS acctid,
  cri.item_code AS acctcode,
  cri.item_title AS acctname,
  cri.remarks AS remarks,
  cri.amount AS amount,
  c.txntype
from eor_remittance r 
  inner join eor c on c.remittanceid = r.objid 
  inner join eor_item cri on cri.parentid = c.objid
GO

-- ----------------------------
-- View structure for vw_remittance_eor_share
-- ----------------------------
CREATE VIEW [dbo].[vw_remittance_eor_share] AS 
select 
  c.remittanceid AS remittanceid,
  r.controldate AS remittance_controldate,
  r.controlno AS remittance_controlno,
  cri.parentid AS receiptid,
  c.receiptdate AS receiptdate,
  c.receiptno AS receiptno,
  c.paidby AS paidby,
  c.paidbyaddress AS paidbyaddress,
  cri.refitem_objid AS refacctid,
  cri.refitem_code AS refacctcode,
  cri.refitem_title AS refaccttitle,
  cri.payableitem_objid AS acctid,
  cri.payableitem_code AS acctcode,
  cri.payableitem_title AS acctname,
  cri.share AS amount,
  c.txntype
from eor_remittance r 
  inner join eor c on c.remittanceid = r.objid 
  inner join eor_share cri on cri.parentid = c.objid
GO

-- ----------------------------
-- Indexes structure for table eor
-- ----------------------------
CREATE UNIQUE INDEX [uix_eor_receiptno] ON [dbo].[eor]
([receiptno] ASC) 
GO
CREATE INDEX [ix_receiptdate] ON [dbo].[eor]
([receiptdate] ASC) 
GO
CREATE INDEX [ix_txndate] ON [dbo].[eor]
([txndate] ASC) 
GO
CREATE INDEX [ix_partnerid] ON [dbo].[eor]
([partnerid] ASC) 
GO
CREATE INDEX [ix_traceid] ON [dbo].[eor]
([traceid] ASC) 
GO
CREATE INDEX [ix_refid] ON [dbo].[eor]
([refid] ASC) 
GO
CREATE INDEX [ix_paidby] ON [dbo].[eor]
([paidby] ASC) 
GO
CREATE INDEX [ix_payer_objid] ON [dbo].[eor]
([payer_objid] ASC) 
GO
CREATE INDEX [ix_paymentrefid] ON [dbo].[eor]
([paymentrefid] ASC) 
GO
CREATE INDEX [ix_remittanceid] ON [dbo].[eor]
([remittanceid] ASC) 
GO
CREATE INDEX [ix_lockid] ON [dbo].[eor]
([lockid] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor
-- ----------------------------
ALTER TABLE [dbo].[eor] ADD CONSTRAINT pk_eor PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_for_email
-- ----------------------------
CREATE INDEX [ix_txndate] ON [dbo].[eor_for_email]
([txndate] ASC) 
GO
CREATE INDEX [ix_state] ON [dbo].[eor_for_email]
([state] ASC) 
GO
CREATE INDEX [ix_dtsent] ON [dbo].[eor_for_email]
([dtsent] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor_for_email
-- ----------------------------
ALTER TABLE [dbo].[eor_for_email] ADD CONSTRAINT pk_eor_for_email PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_item
-- ----------------------------
CREATE INDEX [fk_eoritem_eor] ON [dbo].[eor_item]
([parentid] ASC) 
GO
CREATE INDEX [ix_item_objid] ON [dbo].[eor_item]
([item_objid] ASC) 
GO
CREATE INDEX [ix_item_fund_objid] ON [dbo].[eor_item]
([item_fund_objid] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor_item
-- ----------------------------
ALTER TABLE [dbo].[eor_item] ADD CONSTRAINT pk_eor_item PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_manual_post
-- ----------------------------
CREATE UNIQUE INDEX [uix_paymentorderno] ON [dbo].[eor_manual_post]
([paymentorderno] ASC) 
GO
CREATE INDEX [ix_state] ON [dbo].[eor_manual_post]
([state] ASC) 
GO
CREATE INDEX [ix_paymentorderno] ON [dbo].[eor_manual_post]
([paymentorderno] ASC) 
GO
CREATE INDEX [ix_paymentpartnerid] ON [dbo].[eor_manual_post]
([paymentpartnerid] ASC) 
GO
CREATE INDEX [ix_traceid] ON [dbo].[eor_manual_post]
([traceid] ASC) 
GO
CREATE INDEX [ix_tracedate] ON [dbo].[eor_manual_post]
([tracedate] ASC) 
GO
CREATE INDEX [ix_dtcreated] ON [dbo].[eor_manual_post]
([dtcreated] ASC) 
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[eor_manual_post]
([createdby_objid] ASC) 
GO
CREATE INDEX [ix_createdby_name] ON [dbo].[eor_manual_post]
([createdby_name] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor_manual_post
-- ----------------------------
ALTER TABLE [dbo].[eor_manual_post] ADD CONSTRAINT pk_eor_manual_post PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_number
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table eor_number
-- ----------------------------
ALTER TABLE [dbo].[eor_number] ADD CONSTRAINT pk_eor_number PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_payment_error
-- ----------------------------
CREATE UNIQUE INDEX [ix_paymentrefid] ON [dbo].[eor_payment_error]
([paymentrefid] ASC) 
GO
CREATE INDEX [ix_txndate] ON [dbo].[eor_payment_error]
([txndate] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor_payment_error
-- ----------------------------
ALTER TABLE [dbo].[eor_payment_error] ADD CONSTRAINT pk_eor_payment_error PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_paymentorder
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table eor_paymentorder
-- ----------------------------
ALTER TABLE [dbo].[eor_paymentorder] ADD CONSTRAINT pk_eor_paymentorder PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_paymentorder_cancelled
-- ----------------------------
CREATE INDEX [ix_txndate] ON [dbo].[eor_paymentorder_cancelled]
([txndate] ASC) 
GO
CREATE INDEX [ix_txntype] ON [dbo].[eor_paymentorder_cancelled]
([txntype] ASC) 
GO
CREATE INDEX [ix_payer_objid] ON [dbo].[eor_paymentorder_cancelled]
([payer_objid] ASC) 
GO
CREATE INDEX [ix_expirydate] ON [dbo].[eor_paymentorder_cancelled]
([expirydate] ASC) 
GO
CREATE INDEX [ix_refid] ON [dbo].[eor_paymentorder_cancelled]
([refid] ASC) 
GO
CREATE INDEX [ix_refno] ON [dbo].[eor_paymentorder_cancelled]
([refno] ASC) 
GO
CREATE INDEX [ix_controlno] ON [dbo].[eor_paymentorder_cancelled]
([controlno] ASC) 
GO
CREATE INDEX [ix_locationid] ON [dbo].[eor_paymentorder_cancelled]
([locationid] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor_paymentorder_cancelled
-- ----------------------------
ALTER TABLE [dbo].[eor_paymentorder_cancelled] ADD CONSTRAINT pk_eor_paymentorder_cancelled PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_paymentorder_paid
-- ----------------------------
CREATE INDEX [ix_txndate] ON [dbo].[eor_paymentorder_paid]
([txndate] ASC) 
GO
CREATE INDEX [ix_txntype] ON [dbo].[eor_paymentorder_paid]
([txntype] ASC) 
GO
CREATE INDEX [ix_payer_objid] ON [dbo].[eor_paymentorder_paid]
([payer_objid] ASC) 
GO
CREATE INDEX [ix_expirydate] ON [dbo].[eor_paymentorder_paid]
([expirydate] ASC) 
GO
CREATE INDEX [ix_refid] ON [dbo].[eor_paymentorder_paid]
([refid] ASC) 
GO
CREATE INDEX [ix_refno] ON [dbo].[eor_paymentorder_paid]
([refno] ASC) 
GO
CREATE INDEX [ix_controlno] ON [dbo].[eor_paymentorder_paid]
([controlno] ASC) 
GO
CREATE INDEX [ix_locationid] ON [dbo].[eor_paymentorder_paid]
([locationid] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor_paymentorder_paid
-- ----------------------------
ALTER TABLE [dbo].[eor_paymentorder_paid] ADD CONSTRAINT pk_eor_paymentorder_paid PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_remittance
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table eor_remittance
-- ----------------------------
ALTER TABLE [dbo].[eor_remittance] ADD CONSTRAINT pk_eor_remittance PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_remittance_fund
-- ----------------------------
CREATE INDEX [fk_eor_remittance_fund_remittance] ON [dbo].[eor_remittance_fund]
([remittanceid] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table eor_remittance_fund
-- ----------------------------
ALTER TABLE [dbo].[eor_remittance_fund] ADD CONSTRAINT pk_eor_remittance_fund PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table eor_share
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table eor_share
-- ----------------------------
ALTER TABLE [dbo].[eor_share] ADD CONSTRAINT pk_eor_share PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table epayment_plugin
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table epayment_plugin
-- ----------------------------
ALTER TABLE [dbo].[epayment_plugin] ADD CONSTRAINT pk_epayment_plugin PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table jev
-- ----------------------------
CREATE INDEX [ix_batchid] ON [dbo].[jev]
([batchid] ASC) 
GO
CREATE INDEX [ix_dtposted] ON [dbo].[jev]
([dtposted] ASC) 
GO
CREATE INDEX [ix_dtverified] ON [dbo].[jev]
([dtverified] ASC) 
GO
CREATE INDEX [ix_fundid] ON [dbo].[jev]
([fundid] ASC) 
GO
CREATE INDEX [ix_jevdate] ON [dbo].[jev]
([jevdate] ASC) 
GO
CREATE INDEX [ix_jevno] ON [dbo].[jev]
([jevno] ASC) 
GO
CREATE INDEX [ix_postedby_objid] ON [dbo].[jev]
([postedby_objid] ASC) 
GO
CREATE INDEX [ix_refdate] ON [dbo].[jev]
([refdate] ASC) 
GO
CREATE INDEX [ix_refid] ON [dbo].[jev]
([refid] ASC) 
GO
CREATE INDEX [ix_refno] ON [dbo].[jev]
([refno] ASC) 
GO
CREATE INDEX [ix_reftype] ON [dbo].[jev]
([reftype] ASC) 
GO
CREATE INDEX [ix_verifiedby_objid] ON [dbo].[jev]
([verifiedby_objid] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table jev
-- ----------------------------
ALTER TABLE [dbo].[jev] ADD CONSTRAINT pk_jev PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table jevitem
-- ----------------------------
CREATE INDEX [ix_jevid] ON [dbo].[jevitem]
([jevid] ASC) 
GO
CREATE INDEX [ix_ledgertype] ON [dbo].[jevitem]
([accttype] ASC) 
GO
CREATE INDEX [ix_acctid] ON [dbo].[jevitem]
([acctid] ASC) 
GO
CREATE INDEX [ix_acctcode] ON [dbo].[jevitem]
([acctcode] ASC) 
GO
CREATE INDEX [ix_acctname] ON [dbo].[jevitem]
([acctname] ASC) 
GO
CREATE INDEX [ix_itemrefid] ON [dbo].[jevitem]
([itemrefid] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table jevitem
-- ----------------------------
ALTER TABLE [dbo].[jevitem] ADD CONSTRAINT pk_jevitem PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table paymentpartner
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table paymentpartner
-- ----------------------------
ALTER TABLE [dbo].[paymentpartner] ADD CONSTRAINT pk_paymentpartner PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table sys_email_queue
-- ----------------------------
CREATE INDEX [ix_refid] ON [dbo].[sys_email_queue]
([refid] ASC) 
GO
CREATE INDEX [ix_state] ON [dbo].[sys_email_queue]
([state] ASC) 
GO
CREATE INDEX [ix_reportid] ON [dbo].[sys_email_queue]
([reportid] ASC) 
GO
CREATE INDEX [ix_dtsent] ON [dbo].[sys_email_queue]
([dtsent] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table sys_email_queue
-- ----------------------------
ALTER TABLE [dbo].[sys_email_queue] ADD CONSTRAINT pk_sys_email_queue PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table sys_email_template
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table sys_email_template
-- ----------------------------
ALTER TABLE [dbo].[sys_email_template] ADD CONSTRAINT pk_sys_email_template PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table unpostedpayment
-- ----------------------------
CREATE UNIQUE INDEX [ix_paymentrefid] ON [dbo].[unpostedpayment]
([paymentrefid] ASC) 
GO
CREATE INDEX [ix_txndate] ON [dbo].[unpostedpayment]
([txndate] ASC) 
GO
CREATE INDEX [ix_txntype] ON [dbo].[unpostedpayment]
([txntype] ASC) 
GO
CREATE INDEX [ix_partnerid] ON [dbo].[unpostedpayment]
([partnerid] ASC) 
GO
CREATE INDEX [ix_traceid] ON [dbo].[unpostedpayment]
([traceid] ASC) 
GO
CREATE INDEX [ix_tracedate] ON [dbo].[unpostedpayment]
([tracedate] ASC) 
GO
CREATE INDEX [ix_refno] ON [dbo].[unpostedpayment]
([refno] ASC) 
GO
CREATE INDEX [ix_origin] ON [dbo].[unpostedpayment]
([origin] ASC) 
GO

-- ----------------------------
-- Primary Key structure for table unpostedpayment
-- ----------------------------
ALTER TABLE [dbo].[unpostedpayment] ADD CONSTRAINT pk_unpostedpayment PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Foreign Key structure for table [dbo].[eor]
-- ----------------------------
ALTER TABLE [dbo].[eor] ADD CONSTRAINT fk_eor_remittanceid 
  FOREIGN KEY ([remittanceid]) REFERENCES [dbo].[eor_remittance] ([objid]) 
GO

-- ----------------------------
-- Foreign Key structure for table [dbo].[eor_item]
-- ----------------------------
ALTER TABLE [dbo].[eor_item] ADD CONSTRAINT fk_eor_item_parentid 
  FOREIGN KEY ([parentid]) REFERENCES [dbo].[eor] ([objid]) 
GO

-- ----------------------------
-- Foreign Key structure for table [dbo].[eor_remittance_fund]
-- ----------------------------
ALTER TABLE [dbo].[eor_remittance_fund] ADD CONSTRAINT fk_eor_remittance_fund_remittanceid 
  FOREIGN KEY ([remittanceid]) REFERENCES [dbo].[eor_remittance] ([objid]) 
GO

-- ----------------------------
-- Foreign Key structure for table [dbo].[jevitem]
-- ----------------------------
ALTER TABLE [dbo].[jevitem] ADD CONSTRAINT fk_jevitem_jevid 
  FOREIGN KEY ([jevid]) REFERENCES [dbo].[jev] ([objid]) 
GO



INSERT INTO [dbo].[epayment_plugin] ([objid], [connection], [servicename]) VALUES ('bpls', 'bpls', 'OnlineBusinessBillingService');
INSERT INTO [dbo].[epayment_plugin] ([objid], [connection], [servicename]) VALUES ('rptcol', 'rpt', 'OnlineLandTaxBillingService');
INSERT INTO [dbo].[epayment_plugin] ([objid], [connection], [servicename]) VALUES ('rpttaxclearance', 'landtax', 'OnlineRealtyTaxClearanceService');

INSERT INTO [dbo].[paymentpartner] ([objid], [code], [name], [branch], [contact], [mobileno], [phoneno], [email], [indexno]) VALUES ('DBP', '101', 'DEVELOPMENT BANK OF THE PHILIPPINES', NULL, NULL, NULL, NULL, NULL, '101');
INSERT INTO [dbo].[paymentpartner] ([objid], [code], [name], [branch], [contact], [mobileno], [phoneno], [email], [indexno]) VALUES ('GCASH', '104', 'GCASH', NULL, NULL, NULL, NULL, NULL, '104');
INSERT INTO [dbo].[paymentpartner] ([objid], [code], [name], [branch], [contact], [mobileno], [phoneno], [email], [indexno]) VALUES ('LBP', '102', 'LAND BANK OF THE PHILIPPINES', NULL, NULL, NULL, NULL, NULL, '102');
INSERT INTO [dbo].[paymentpartner] ([objid], [code], [name], [branch], [contact], [mobileno], [phoneno], [email], [indexno]) VALUES ('PAYMAYA', '103', 'PAYMAYA', NULL, NULL, NULL, NULL, NULL, '103');

INSERT INTO [dbo].[sys_email_template] ([objid], [subject], [message]) VALUES ('eor', 'EOR No ${receiptno}', 'Dear valued customer <br>Please see attached Electronic OR. This is an electronic transaction. Do not reply');




-- ## 2021-11-23

alter table eor_share add 
  refitem_fund_objid varchar(100) null, 
  payableitem_fund_objid varchar(100) null
go 
create index ix_refitem_fund_objid on eor_share (refitem_fund_objid)
go 
create index ix_payableitem_fund_objid on eor_share (payableitem_fund_objid)
go 



if object_id('dbo.vw_remittance_eor_share', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_eor_share; 
go 
CREATE VIEW vw_remittance_eor_share AS 
select 
  c.remittanceid AS remittanceid,
  r.controldate AS remittance_controldate,
  r.controlno AS remittance_controlno,
  cri.parentid AS receiptid,
  c.receiptdate AS receiptdate,
  c.receiptno AS receiptno,
  c.paidby AS paidby,
  c.paidbyaddress AS paidbyaddress,
  cri.refitem_objid AS refacctid,
  cri.refitem_code AS refacctcode,
  cri.refitem_title AS refaccttitle,
  cri.refitem_fund_objid AS reffundid,
  cri.payableitem_objid AS acctid,
  cri.payableitem_code AS acctcode,
  cri.payableitem_title AS acctname,
  cri.payableitem_fund_objid AS fundid,
  cri.amount AS amount,
  c.txntype  
from eor_remittance r 
  inner join eor c on c.remittanceid = r.objid 
  inner join eor_share cri on cri.parentid = c.objid
go 



-- ## 2021-11-24

CREATE TABLE [fund] (
  [objid] varchar(100) NOT NULL,
  [state] varchar(10) NULL,
  [code] varchar(50) NULL,
  [title] varchar(255) NULL,
  [type] varchar(20) NULL,
  [special] int NULL,
  [system] int NULL,
  [depositoryfundid] varchar(100) NULL,
  [group_objid] varchar(50) NULL,
  [group_title] varchar(255) NULL,
  [group_indexno] int NULL,
  constraint pk_fund PRIMARY KEY ([objid]) 
) 
go 

create index [ix_code] on [fund] ([code])
go 
create index [ix_title] on [fund] ([title])
go 
create index [ix_group_objid] on [fund] ([group_objid])
go 
create index [ix_depositoryfundid] on [fund] ([depositoryfundid])
go 
