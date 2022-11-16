-- MySQL dump 10.13  Distrib 5.5.59, for Win64 (AMD64)
--
-- Host: localhost    Database: etracs_notification
-- ------------------------------------------------------
-- Server version	5.5.59

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `etracs_notification`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `etracs_notification` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `etracs_notification`;

--
-- Table structure for table `async_notification`
--

DROP TABLE IF EXISTS `async_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `async_notification` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `messagetype` varchar(50) DEFAULT NULL,
  `data` longtext,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `async_notification`
--

LOCK TABLES `async_notification` WRITE;
/*!40000 ALTER TABLE `async_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `async_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `async_notification_delivered`
--

DROP TABLE IF EXISTS `async_notification_delivered`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `async_notification_delivered` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `async_notification_delivered`
--

LOCK TABLES `async_notification_delivered` WRITE;
/*!40000 ALTER TABLE `async_notification_delivered` DISABLE KEYS */;
/*!40000 ALTER TABLE `async_notification_delivered` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `async_notification_failed`
--

DROP TABLE IF EXISTS `async_notification_failed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `async_notification_failed` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `errormessage` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `async_notification_failed`
--

LOCK TABLES `async_notification_failed` WRITE;
/*!40000 ALTER TABLE `async_notification_failed` DISABLE KEYS */;
/*!40000 ALTER TABLE `async_notification_failed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `async_notification_pending`
--

DROP TABLE IF EXISTS `async_notification_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `async_notification_pending` (
  `objid` varchar(50) NOT NULL,
  `dtretry` datetime DEFAULT NULL,
  `retrycount` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `async_notification_pending`
--

LOCK TABLES `async_notification_pending` WRITE;
/*!40000 ALTER TABLE `async_notification_pending` DISABLE KEYS */;
/*!40000 ALTER TABLE `async_notification_pending` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `async_notification_processing`
--

DROP TABLE IF EXISTS `async_notification_processing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `async_notification_processing` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `async_notification_processing`
--

LOCK TABLES `async_notification_processing` WRITE;
/*!40000 ALTER TABLE `async_notification_processing` DISABLE KEYS */;
/*!40000 ALTER TABLE `async_notification_processing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_notification`
--

DROP TABLE IF EXISTS `cloud_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_groupid` (`groupid`),
  KEY `ix_senderid` (`senderid`),
  KEY `ix_objid` (`objid`),
  KEY `ix_origin` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_notification`
--

LOCK TABLES `cloud_notification` WRITE;
/*!40000 ALTER TABLE `cloud_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_notification_attachment`
--

DROP TABLE IF EXISTS `cloud_notification_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  KEY `ix_parentid` (`parentid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_name` (`name`),
  KEY `ix_fileid` (`fileid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_notification_attachment`
--

LOCK TABLES `cloud_notification_attachment` WRITE;
/*!40000 ALTER TABLE `cloud_notification_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_notification_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_notification_delivered`
--

DROP TABLE IF EXISTS `cloud_notification_delivered`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_notification_delivered` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `tracetime` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_traceid` (`traceid`),
  KEY `ix_tracetime` (`tracetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_notification_delivered`
--

LOCK TABLES `cloud_notification_delivered` WRITE;
/*!40000 ALTER TABLE `cloud_notification_delivered` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_notification_delivered` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_notification_failed`
--

DROP TABLE IF EXISTS `cloud_notification_failed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_notification_failed` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(25) DEFAULT NULL,
  `errormessage` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_notification_failed`
--

LOCK TABLES `cloud_notification_failed` WRITE;
/*!40000 ALTER TABLE `cloud_notification_failed` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_notification_failed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_notification_pending`
--

DROP TABLE IF EXISTS `cloud_notification_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_notification_pending` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `dtretry` datetime DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL COMMENT 'HEADER,ATTACHMENT',
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtexpiry` (`dtexpiry`),
  KEY `ix_dtretry` (`dtretry`),
  KEY `ix_dtfiled` (`dtfiled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_notification_pending`
--

LOCK TABLES `cloud_notification_pending` WRITE;
/*!40000 ALTER TABLE `cloud_notification_pending` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_notification_pending` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_notification_received`
--

DROP TABLE IF EXISTS `cloud_notification_received`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_notification_received` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `tracetime` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_traceid` (`traceid`),
  KEY `ix_tracetime` (`tracetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_notification_received`
--

LOCK TABLES `cloud_notification_received` WRITE;
/*!40000 ALTER TABLE `cloud_notification_received` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_notification_received` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_async`
--

DROP TABLE IF EXISTS `notification_async`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_async` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_async`
--

LOCK TABLES `notification_async` WRITE;
/*!40000 ALTER TABLE `notification_async` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_async` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_async_pending`
--

DROP TABLE IF EXISTS `notification_async_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_async_pending` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_async_pending`
--

LOCK TABLES `notification_async_pending` WRITE;
/*!40000 ALTER TABLE `notification_async_pending` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_async_pending` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_data`
--

DROP TABLE IF EXISTS `notification_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_data` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `content` mediumtext NOT NULL,
  `contentlength` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_data`
--

LOCK TABLES `notification_data` WRITE;
/*!40000 ALTER TABLE `notification_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_fordownload`
--

DROP TABLE IF EXISTS `notification_fordownload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_fordownload` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_fordownload`
--

LOCK TABLES `notification_fordownload` WRITE;
/*!40000 ALTER TABLE `notification_fordownload` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_fordownload` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_forprocess`
--

DROP TABLE IF EXISTS `notification_forprocess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_forprocess` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_forprocess`
--

LOCK TABLES `notification_forprocess` WRITE;
/*!40000 ALTER TABLE `notification_forprocess` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_forprocess` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_pending`
--

DROP TABLE IF EXISTS `notification_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_pending` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_pending`
--

LOCK TABLES `notification_pending` WRITE;
/*!40000 ALTER TABLE `notification_pending` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_pending` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_setting`
--

DROP TABLE IF EXISTS `notification_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_setting` (
  `objid` varchar(50) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_setting`
--

LOCK TABLES `notification_setting` WRITE;
/*!40000 ALTER TABLE `notification_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_inbox`
--

DROP TABLE IF EXISTS `sms_inbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_inbox` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `channel` varchar(25) DEFAULT NULL,
  `keyword` varchar(50) DEFAULT NULL,
  `phoneno` varchar(15) DEFAULT NULL,
  `message` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_phoneno` (`phoneno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_inbox`
--

LOCK TABLES `sms_inbox` WRITE;
/*!40000 ALTER TABLE `sms_inbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_inbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_inbox_pending`
--

DROP TABLE IF EXISTS `sms_inbox_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_inbox_pending` (
  `objid` varchar(50) NOT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `dtretry` datetime DEFAULT NULL,
  `retrycount` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_dtexpiry` (`dtexpiry`),
  KEY `ix_dtretry` (`dtretry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_inbox_pending`
--

LOCK TABLES `sms_inbox_pending` WRITE;
/*!40000 ALTER TABLE `sms_inbox_pending` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_inbox_pending` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_outbox`
--

DROP TABLE IF EXISTS `sms_outbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_phoneno` (`phoneno`),
  KEY `ix_dtsend` (`dtsend`),
  KEY `ix_refid` (`refid`),
  KEY `ix_traceid` (`traceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_outbox`
--

LOCK TABLES `sms_outbox` WRITE;
/*!40000 ALTER TABLE `sms_outbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_outbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_outbox_pending`
--

DROP TABLE IF EXISTS `sms_outbox_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_outbox_pending` (
  `objid` varchar(50) NOT NULL,
  `dtexpiry` datetime DEFAULT NULL,
  `dtretry` datetime DEFAULT NULL,
  `retrycount` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_dtexpiry` (`dtexpiry`),
  KEY `ix_dtretry` (`dtretry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_outbox_pending`
--

LOCK TABLES `sms_outbox_pending` WRITE;
/*!40000 ALTER TABLE `sms_outbox_pending` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_outbox_pending` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notification`
--

DROP TABLE IF EXISTS `sys_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_senderid` (`senderid`),
  KEY `ix_objid` (`objid`),
  KEY `ix_recipientid` (`recipientid`),
  KEY `ix_recipienttype` (`recipienttype`),
  KEY `ix_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notification`
--

LOCK TABLES `sys_notification` WRITE;
/*!40000 ALTER TABLE `sys_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-07 16:45:14
