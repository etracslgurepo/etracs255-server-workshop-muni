CREATE TABLE `holiday` (
  
`objid` varchar(50) NOT NULL,
  
`year` int(4) DEFAULT NULL,
  
`month` int(2) DEFAULT NULL,
  
`day` int(2) DEFAULT NULL,
  
`week` int(1) DEFAULT NULL,
  
`dow` int(1) DEFAULT NULL,
  
`name` varchar(255) DEFAULT NULL,
  
PRIMARY KEY (`objid`)
);