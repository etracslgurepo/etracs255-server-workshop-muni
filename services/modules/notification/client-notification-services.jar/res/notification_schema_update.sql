
SET FOREIGN_KEY_CHECKS=0;

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

CREATE TABLE `notification_async` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notification_async_pending` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notification_data` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `content` mediumtext NOT NULL,
  `contentlength` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notification_fordownload` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notification_forprocess` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notification_pending` (
  `objid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notification_setting` (
  `objid` varchar(50) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE sys_notification ADD `tag` varchar(255) DEFAULT NULL
;
CREATE INDEX ix_tag ON sys_notification (`tag`)
;
