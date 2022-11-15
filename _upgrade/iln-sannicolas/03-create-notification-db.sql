/*
Navicat SQL Server Data Transfer

Source Server         : mssql-2008
Source Server Version : 105000
Source Host           : 127.0.0.1,14338:1433
Source Database       : etracs_notification
Source Schema         : dbo

Target Server Type    : SQL Server
Target Server Version : 105000
File Encoding         : 65001

Date: 2022-11-15 13:06:04
*/


CREATE DATABASE [etracs_notification]
GO

USE [etracs_notification]
GO


-- ----------------------------
-- Table structure for async_notification
-- ----------------------------
CREATE TABLE [async_notification] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[messagetype] nvarchar(50) NULL ,
[data] nvarchar(MAX) NULL 
)


GO

-- ----------------------------
-- Table structure for async_notification_delivered
-- ----------------------------
CREATE TABLE [async_notification_delivered] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[refid] nvarchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for async_notification_failed
-- ----------------------------
CREATE TABLE [async_notification_failed] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[refid] nvarchar(50) NULL ,
[errormessage] nvarchar(MAX) NULL 
)


GO

-- ----------------------------
-- Table structure for async_notification_pending
-- ----------------------------
CREATE TABLE [async_notification_pending] (
[objid] nvarchar(50) NOT NULL ,
[dtretry] datetime NULL ,
[retrycount] smallint NULL 
)


GO

-- ----------------------------
-- Table structure for async_notification_processing
-- ----------------------------
CREATE TABLE [async_notification_processing] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL 
)


GO

-- ----------------------------
-- Table structure for cloud_notification
-- ----------------------------
CREATE TABLE [cloud_notification] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[sender] nvarchar(160) NULL ,
[senderid] nvarchar(50) NULL ,
[groupid] nvarchar(32) NULL ,
[message] nvarchar(255) NULL ,
[messagetype] nvarchar(50) NULL ,
[filetype] nvarchar(50) NULL ,
[channel] nvarchar(50) NULL ,
[channelgroup] nvarchar(50) NULL ,
[origin] nvarchar(50) NULL ,
[data] nvarchar(MAX) NULL ,
[attachmentcount] smallint NULL 
)


GO

-- ----------------------------
-- Table structure for cloud_notification_attachment
-- ----------------------------
CREATE TABLE [cloud_notification_attachment] (
[objid] nvarchar(50) NOT NULL ,
[parentid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[indexno] smallint NULL ,
[name] nvarchar(50) NULL ,
[type] nvarchar(50) NULL ,
[description] nvarchar(255) NULL ,
[fileid] nvarchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for cloud_notification_delivered
-- ----------------------------
CREATE TABLE [cloud_notification_delivered] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[traceid] nvarchar(50) NULL ,
[tracetime] datetime NULL 
)


GO

-- ----------------------------
-- Table structure for cloud_notification_failed
-- ----------------------------
CREATE TABLE [cloud_notification_failed] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[refid] nvarchar(50) NULL ,
[reftype] nvarchar(25) NULL ,
[errormessage] nvarchar(MAX) NULL 
)


GO

-- ----------------------------
-- Table structure for cloud_notification_pending
-- ----------------------------
CREATE TABLE [cloud_notification_pending] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[dtexpiry] datetime NULL ,
[dtretry] datetime NULL ,
[type] nvarchar(25) NULL ,
[state] nvarchar(50) NULL 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'cloud_notification_pending', 
'COLUMN', N'type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'HEADER,ATTACHMENT'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'cloud_notification_pending'
, @level2type = 'COLUMN', @level2name = N'type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'HEADER,ATTACHMENT'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'cloud_notification_pending'
, @level2type = 'COLUMN', @level2name = N'type'
GO

-- ----------------------------
-- Table structure for cloud_notification_received
-- ----------------------------
CREATE TABLE [cloud_notification_received] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NULL ,
[traceid] nvarchar(50) NULL ,
[tracetime] datetime NULL 
)


GO

-- ----------------------------
-- Table structure for notification
-- ----------------------------
CREATE TABLE [notification] (
[objid] nvarchar(50) NOT NULL ,
[dtfiled] datetime NOT NULL ,
[sender] nvarchar(160) NOT NULL ,
[senderid] nvarchar(50) NOT NULL ,
[groupid] nvarchar(32) NULL ,
[message] nvarchar(255) NULL ,
[messagetype] nvarchar(50) NULL ,
[filetype] nvarchar(50) NULL ,
[channel] nvarchar(50) NOT NULL ,
[channelgroup] nvarchar(50) NOT NULL ,
[origin] nvarchar(50) NOT NULL ,
[origintype] nvarchar(25) NULL ,
[chunksize] int NOT NULL ,
[chunkcount] int NOT NULL ,
[txnid] nvarchar(50) NULL ,
[txnno] nvarchar(50) NULL 
)


GO

-- ----------------------------
-- Table structure for notification_async
-- ----------------------------
CREATE TABLE [notification_async] (
[objid] nvarchar(50) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for notification_async_pending
-- ----------------------------
CREATE TABLE [notification_async_pending] (
[objid] nvarchar(50) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for notification_data
-- ----------------------------
CREATE TABLE [notification_data] (
[objid] nvarchar(50) NOT NULL ,
[parentid] nvarchar(50) NOT NULL ,
[indexno] int NOT NULL ,
[content] nvarchar(MAX) NOT NULL ,
[contentlength] int NOT NULL 
)


GO

-- ----------------------------
-- Table structure for notification_fordownload
-- ----------------------------
CREATE TABLE [notification_fordownload] (
[objid] nvarchar(50) NOT NULL ,
[indexno] int NOT NULL 
)


GO

-- ----------------------------
-- Table structure for notification_forprocess
-- ----------------------------
CREATE TABLE [notification_forprocess] (
[objid] nvarchar(50) NOT NULL ,
[indexno] int NULL 
)


GO

-- ----------------------------
-- Table structure for notification_pending
-- ----------------------------
CREATE TABLE [notification_pending] (
[objid] nvarchar(50) NOT NULL ,
[indexno] int NOT NULL 
)


GO

-- ----------------------------
-- Table structure for notification_setting
-- ----------------------------
CREATE TABLE [notification_setting] (
[objid] nvarchar(50) NOT NULL ,
[value] nvarchar(255) NULL 
)


GO

-- ----------------------------
-- Table structure for sms_inbox
-- ----------------------------
CREATE TABLE [sms_inbox] (
[objid] nvarchar(50) NOT NULL ,
[state] nvarchar(25) NULL ,
[dtfiled] datetime NULL ,
[channel] nvarchar(25) NULL ,
[keyword] nvarchar(50) NULL ,
[phoneno] nvarchar(15) NULL ,
[message] nvarchar(160) NULL 
)


GO

-- ----------------------------
-- Table structure for sms_inbox_pending
-- ----------------------------
CREATE TABLE [sms_inbox_pending] (
[objid] nvarchar(50) NOT NULL ,
[dtexpiry] datetime NULL ,
[dtretry] datetime NULL ,
[retrycount] smallint NULL 
)


GO

-- ----------------------------
-- Table structure for sms_outbox
-- ----------------------------
CREATE TABLE [sms_outbox] (
[objid] nvarchar(50) NOT NULL ,
[state] nvarchar(25) NULL ,
[dtfiled] datetime NULL ,
[refid] nvarchar(50) NULL ,
[phoneno] nvarchar(15) NULL ,
[message] nvarchar(MAX) NULL ,
[creditcount] smallint NULL ,
[remarks] nvarchar(160) NULL ,
[dtsend] datetime NULL ,
[traceid] nvarchar(100) NULL 
)


GO

-- ----------------------------
-- Table structure for sms_outbox_pending
-- ----------------------------
CREATE TABLE [sms_outbox_pending] (
[objid] nvarchar(50) NOT NULL ,
[dtexpiry] datetime NULL ,
[dtretry] datetime NULL ,
[retrycount] smallint NULL 
)


GO

-- ----------------------------
-- Table structure for sys_notification
-- ----------------------------
CREATE TABLE [sys_notification] (
[notificationid] nvarchar(50) NOT NULL ,
[objid] nvarchar(50) NULL ,
[dtfiled] datetime NULL ,
[sender] nvarchar(160) NULL ,
[senderid] nvarchar(50) NULL ,
[recipientid] nvarchar(50) NULL ,
[recipienttype] nvarchar(50) NULL ,
[message] nvarchar(255) NULL ,
[filetype] nvarchar(50) NULL ,
[data] nvarchar(MAX) NULL ,
[tag] nvarchar(255) NULL 
)


GO

-- ----------------------------
-- Indexes structure for table async_notification
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [async_notification]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table async_notification
-- ----------------------------
ALTER TABLE [async_notification] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table async_notification_delivered
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [async_notification_delivered]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_refid] ON [async_notification_delivered]
([refid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table async_notification_delivered
-- ----------------------------
ALTER TABLE [async_notification_delivered] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table async_notification_failed
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [async_notification_failed]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_refid] ON [async_notification_failed]
([refid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table async_notification_failed
-- ----------------------------
ALTER TABLE [async_notification_failed] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table async_notification_pending
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table async_notification_pending
-- ----------------------------
ALTER TABLE [async_notification_pending] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table async_notification_processing
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table async_notification_processing
-- ----------------------------
ALTER TABLE [async_notification_processing] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table cloud_notification
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [cloud_notification]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_groupid] ON [cloud_notification]
([groupid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_senderid] ON [cloud_notification]
([senderid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_objid] ON [cloud_notification]
([objid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_origin] ON [cloud_notification]
([origin] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table cloud_notification
-- ----------------------------
ALTER TABLE [cloud_notification] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table cloud_notification_attachment
-- ----------------------------
CREATE INDEX [ix_parentid] ON [cloud_notification_attachment]
([parentid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_dtfiled] ON [cloud_notification_attachment]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_name] ON [cloud_notification_attachment]
([name] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_fileid] ON [cloud_notification_attachment]
([fileid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table cloud_notification_attachment
-- ----------------------------
ALTER TABLE [cloud_notification_attachment] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table cloud_notification_delivered
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [cloud_notification_delivered]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_traceid] ON [cloud_notification_delivered]
([traceid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_tracetime] ON [cloud_notification_delivered]
([tracetime] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table cloud_notification_delivered
-- ----------------------------
ALTER TABLE [cloud_notification_delivered] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table cloud_notification_failed
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [cloud_notification_failed]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_refid] ON [cloud_notification_failed]
([refid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table cloud_notification_failed
-- ----------------------------
ALTER TABLE [cloud_notification_failed] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table cloud_notification_pending
-- ----------------------------
CREATE INDEX [ix_dtexpiry] ON [cloud_notification_pending]
([dtexpiry] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_dtretry] ON [cloud_notification_pending]
([dtretry] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_dtfiled] ON [cloud_notification_pending]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table cloud_notification_pending
-- ----------------------------
ALTER TABLE [cloud_notification_pending] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table cloud_notification_received
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [cloud_notification_received]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_traceid] ON [cloud_notification_received]
([traceid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_tracetime] ON [cloud_notification_received]
([tracetime] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table cloud_notification_received
-- ----------------------------
ALTER TABLE [cloud_notification_received] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [notification]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_senderid] ON [notification]
([senderid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_groupid] ON [notification]
([groupid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_txnid] ON [notification]
([txnid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_txnno] ON [notification]
([txnno] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table notification
-- ----------------------------
ALTER TABLE [notification] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification_async
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table notification_async
-- ----------------------------
ALTER TABLE [notification_async] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification_async_pending
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table notification_async_pending
-- ----------------------------
ALTER TABLE [notification_async_pending] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification_data
-- ----------------------------
CREATE INDEX [ix_parentid] ON [notification_data]
([parentid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table notification_data
-- ----------------------------
ALTER TABLE [notification_data] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification_fordownload
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table notification_fordownload
-- ----------------------------
ALTER TABLE [notification_fordownload] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification_forprocess
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table notification_forprocess
-- ----------------------------
ALTER TABLE [notification_forprocess] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification_pending
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table notification_pending
-- ----------------------------
ALTER TABLE [notification_pending] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table notification_setting
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table notification_setting
-- ----------------------------
ALTER TABLE [notification_setting] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table sms_inbox
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [sms_inbox]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_phoneno] ON [sms_inbox]
([phoneno] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table sms_inbox
-- ----------------------------
ALTER TABLE [sms_inbox] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table sms_inbox_pending
-- ----------------------------
CREATE INDEX [ix_dtexpiry] ON [sms_inbox_pending]
([dtexpiry] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_dtretry] ON [sms_inbox_pending]
([dtretry] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table sms_inbox_pending
-- ----------------------------
ALTER TABLE [sms_inbox_pending] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table sms_outbox
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [sms_outbox]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_phoneno] ON [sms_outbox]
([phoneno] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_dtsend] ON [sms_outbox]
([dtsend] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_refid] ON [sms_outbox]
([refid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_traceid] ON [sms_outbox]
([traceid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table sms_outbox
-- ----------------------------
ALTER TABLE [sms_outbox] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table sms_outbox_pending
-- ----------------------------
CREATE INDEX [ix_dtexpiry] ON [sms_outbox_pending]
([dtexpiry] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_dtretry] ON [sms_outbox_pending]
([dtretry] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table sms_outbox_pending
-- ----------------------------
ALTER TABLE [sms_outbox_pending] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table sys_notification
-- ----------------------------
CREATE INDEX [ix_dtfiled] ON [sys_notification]
([dtfiled] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_senderid] ON [sys_notification]
([senderid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_objid] ON [sys_notification]
([objid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_recipientid] ON [sys_notification]
([recipientid] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_recipienttype] ON [sys_notification]
([recipienttype] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE INDEX [ix_tag] ON [sys_notification]
([tag] ASC) 
WITH (STATISTICS_NORECOMPUTE = ON)
GO

-- ----------------------------
-- Primary Key structure for table sys_notification
-- ----------------------------
ALTER TABLE [sys_notification] ADD PRIMARY KEY ([notificationid])
GO
