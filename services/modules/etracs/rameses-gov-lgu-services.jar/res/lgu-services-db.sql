
CREATE TABLE `government_property` (
  `objid` varchar(50) NOT NULL,
  `bldgno` varchar(50) DEFAULT NULL,
  `bldgname` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `subdivision` varchar(100) DEFAULT NULL,
  `barangay_objid` varchar(50) DEFAULT NULL,
  `barangay_name` varchar(100) DEFAULT NULL,
  `pin` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) 
ENGINE=InnoDB; 


INSERT INTO `government_property` (
  `objid`,
  `bldgno`,
  `bldgname`,
  `street`,
  `subdivision`,
  `barangay_objid`,
  `barangay_name`,
  `pin`
)
SELECT 
  `objid`,
  `bldgno`,
  `bldgname`,
  `street`,
  `subdivision`,
  `barangay_objid`,
  `barangay_name`,
  `pin`
FROM BUSINESS_LESSOR WHERE government = 1;
  
