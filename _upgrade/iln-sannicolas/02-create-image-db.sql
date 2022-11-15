/*
Navicat SQL Server Data Transfer

Source Server         : mssql-2008
Source Server Version : 105000
Source Host           : 127.0.0.1,14338:1433
Source Database       : etracs_image
Source Schema         : dbo

Target Server Type    : SQL Server
Target Server Version : 105000
File Encoding         : 65001

Date: 2022-11-15 13:04:23
*/


CREATE DATABASE [etracs_image]
GO

USE [etracs_image]
GO


-- ----------------------------
-- Table structure for image_chunk
-- ----------------------------
CREATE TABLE [image_chunk] (
[objid] nvarchar(50) NOT NULL ,
[parentid] nvarchar(50) NOT NULL ,
[fileno] int NOT NULL ,
[byte] varbinary(MAX) NOT NULL 
)


GO

-- ----------------------------
-- Table structure for image_header
-- ----------------------------
CREATE TABLE [image_header] (
[objid] nvarchar(50) NOT NULL ,
[refid] nvarchar(50) NOT NULL ,
[title] nvarchar(255) NOT NULL ,
[filesize] int NULL ,
[extension] nvarchar(255) NULL ,
[parentid] nvarchar(50) NULL 
)


GO

-- ----------------------------
-- Indexes structure for table image_chunk
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table image_chunk
-- ----------------------------
ALTER TABLE [image_chunk] ADD PRIMARY KEY ([objid])
GO

-- ----------------------------
-- Indexes structure for table image_header
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table image_header
-- ----------------------------
ALTER TABLE [image_header] ADD PRIMARY KEY ([objid])
GO
