
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for async_notification
-- ----------------------------
-- DROP TABLE IF EXISTS `async_notification`;
CREATE TABLE `async_notification` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `messagetype` varchar(50) DEFAULT NULL,
  `data` longtext,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for async_notification_delivered
-- ----------------------------
-- DROP TABLE IF EXISTS `async_notification_delivered`;
CREATE TABLE `async_notification_delivered` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for async_notification_failed
-- ----------------------------
-- DROP TABLE IF EXISTS `async_notification_failed`;
CREATE TABLE `async_notification_failed` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `errormessage` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for async_notification_pending
-- ----------------------------
-- DROP TABLE IF EXISTS `async_notification_pending`;
CREATE TABLE `async_notification_pending` (
  `objid` varchar(50) NOT NULL,
  `dtretry` datetime DEFAULT NULL,
  `retrycount` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for async_notification_processing
-- ----------------------------
-- DROP TABLE IF EXISTS `async_notification_processing`;
CREATE TABLE `async_notification_processing` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cloud_notification
-- ----------------------------
-- DROP TABLE IF EXISTS `cloud_notification`;
CREATE TABLE `cloud_notification` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `sender` varchar(160) DEFAULT NULL,
  `senderid` varchar(50) DEFAULT NULL,
  `groupid` varchar(32) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `messagetype` varchar(50) DEFAULT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `channelgroup` varchar(50) DEFAULT NULL,
  `origin` varchar(50) DEFAULT NULL,
  `data` longtext,
  `attachmentcount` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_groupid` (`groupid`) USING BTREE,
  KEY `ix_senderid` (`senderid`) USING BTREE,
  KEY `ix_objid` (`objid`) USING BTREE,
  KEY `ix_origin` (`origin`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cloud_notification_attachment
-- ----------------------------
-- DROP TABLE IF EXISTS `cloud_notification_attachment`;
CREATE TABLE `cloud_notification_attachment` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `indexno` smallint(6) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `fileid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`) USING BTREE,
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_name` (`name`) USING BTREE,
  KEY `ix_fileid` (`fileid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cloud_notification_delivered
-- ----------------------------
-- DROP TABLE IF EXISTS `cloud_notification_delivered`;
CREATE TABLE `cloud_notification_delivered` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `tracetime` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_traceid` (`traceid`) USING BTREE,
  KEY `ix_tracetime` (`tracetime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cloud_notification_failed
-- ----------------------------
-- DROP TABLE IF EXISTS `cloud_notification_failed`;
CREATE TABLE `cloud_notification_failed` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(25) DEFAULT NULL,
  `errormessage` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cloud_notification_pending
-- ----------------------------
-- DROP TABLE IF EXISTS `cloud_notification_pending`;
CREATE TABLE `cloud_notification_pending` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `dtretry` datetime DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL COMMENT 'HEADER,ATTACHMENT',
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtexpiry` (`dtexpiry`) USING BTREE,
  KEY `ix_dtretry` (`dtretry`) USING BTREE,
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cloud_notification_received
-- ----------------------------
-- DROP TABLE IF EXISTS `cloud_notification_received`;
CREATE TABLE `cloud_notification_received` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `tracetime` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_traceid` (`traceid`) USING BTREE,
  KEY `ix_tracetime` (`tracetime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification
-- ----------------------------
-- DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `sender` varchar(160) NOT NULL,
  `senderid` varchar(50) NOT NULL,
  `groupid` varchar(32) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `messagetype` varchar(50) DEFAULT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `channel` varchar(50) NOT NULL,
  `channelgroup` varchar(50) NOT NULL,
  `origin` varchar(50) NOT NULL,
  `origintype` varchar(25) DEFAULT NULL,
  `chunksize` int(11) NOT NULL,
  `chunkcount` int(11) NOT NULL,
  `txnid` varchar(50) DEFAULT NULL,
  `txnno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_senderid` (`senderid`),
  KEY `ix_groupid` (`groupid`),
  KEY `ix_txnid` (`txnid`),
  KEY `ix_txnno` (`txnno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification_async
-- ----------------------------
-- DROP TABLE IF EXISTS `notification_async`;
CREATE TABLE `notification_async` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification_async_pending
-- ----------------------------
-- DROP TABLE IF EXISTS `notification_async_pending`;
CREATE TABLE `notification_async_pending` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification_data
-- ----------------------------
-- DROP TABLE IF EXISTS `notification_data`;
CREATE TABLE `notification_data` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `content` mediumtext NOT NULL,
  `contentlength` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification_fordownload
-- ----------------------------
-- DROP TABLE IF EXISTS `notification_fordownload`;
CREATE TABLE `notification_fordownload` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification_forprocess
-- ----------------------------
-- DROP TABLE IF EXISTS `notification_forprocess`;
CREATE TABLE `notification_forprocess` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification_pending
-- ----------------------------
-- DROP TABLE IF EXISTS `notification_pending`;
CREATE TABLE `notification_pending` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for notification_setting
-- ----------------------------
-- DROP TABLE IF EXISTS `notification_setting`;
CREATE TABLE `notification_setting` (
  `objid` varchar(50) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_inbox
-- ----------------------------
-- DROP TABLE IF EXISTS `sms_inbox`;
CREATE TABLE `sms_inbox` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `channel` varchar(25) DEFAULT NULL,
  `keyword` varchar(50) DEFAULT NULL,
  `phoneno` varchar(15) DEFAULT NULL,
  `message` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_phoneno` (`phoneno`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_inbox_pending
-- ----------------------------
-- DROP TABLE IF EXISTS `sms_inbox_pending`;
CREATE TABLE `sms_inbox_pending` (
  `objid` varchar(50) NOT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `dtretry` datetime DEFAULT NULL,
  `retrycount` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_dtexpiry` (`dtexpiry`) USING BTREE,
  KEY `ix_dtretry` (`dtretry`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_outbox
-- ----------------------------
-- DROP TABLE IF EXISTS `sms_outbox`;
CREATE TABLE `sms_outbox` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `phoneno` varchar(15) DEFAULT NULL,
  `message` text,
  `creditcount` smallint(6) DEFAULT '0',
  `remarks` varchar(160) DEFAULT NULL,
  `dtsend` datetime DEFAULT NULL,
  `traceid` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_phoneno` (`phoneno`) USING BTREE,
  KEY `ix_dtsend` (`dtsend`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_traceid` (`traceid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_outbox_pending
-- ----------------------------
-- DROP TABLE IF EXISTS `sms_outbox_pending`;
CREATE TABLE `sms_outbox_pending` (
  `objid` varchar(50) NOT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `dtretry` datetime DEFAULT NULL,
  `retrycount` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_dtexpiry` (`dtexpiry`) USING BTREE,
  KEY `ix_dtretry` (`dtretry`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sys_notification
-- ----------------------------
-- DROP TABLE IF EXISTS `sys_notification`;
CREATE TABLE `sys_notification` (
  `notificationid` varchar(50) NOT NULL,
  `objid` varchar(50) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `sender` varchar(160) DEFAULT NULL,
  `senderid` varchar(50) DEFAULT NULL,
  `recipientid` varchar(50) DEFAULT NULL,
  `recipienttype` varchar(50) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `data` longtext,
  `tag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`notificationid`),
  KEY `ix_dtfiled` (`dtfiled`) USING BTREE,
  KEY `ix_senderid` (`senderid`) USING BTREE,
  KEY `ix_objid` (`objid`) USING BTREE,
  KEY `ix_recipientid` (`recipientid`) USING BTREE,
  KEY `ix_recipienttype` (`recipienttype`) USING BTREE,
  KEY `ix_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
