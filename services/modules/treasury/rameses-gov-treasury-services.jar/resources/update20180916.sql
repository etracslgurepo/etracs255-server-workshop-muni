
CREATE TABLE `checkpayment_deadchecks` (
  `objid` varchar(50) NOT NULL,
  `bankid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `collectorid` varchar(50) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `amtused` decimal(16,4) DEFAULT NULL,
  `receivedfrom` varchar(255) DEFAULT NULL,
  `adviceid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `depositvoucherid` varchar(50) DEFAULT NULL,
  `fundid` varchar(100) DEFAULT NULL,
  `depositslipid` varchar(100) DEFAULT NULL,
  `split` int(11) NOT NULL,
  `amtdeposited` decimal(16,4) DEFAULT NULL,
  `external` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


