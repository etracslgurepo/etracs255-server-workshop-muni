ALTER TABLE afunit ADD COLUMN cashreceiptprintout VARCHAR(50);
ALTER TABLE afunit ADD COLUMN cashreceiptdetailprintout VARCHAR(50);

DROP VIEW IF EXISTS vw_afunit;	
CREATE  VIEW `vw_afunit` AS 
SELECT
   `u`.`objid` AS `objid`,
   `af`.`title` AS `title`,
   `af`.`usetype` AS `usetype`,
   `af`.`serieslength` AS `serieslength`,
   `af`.`system` AS `system`,
   `af`.`denomination` AS `denomination`,
   `af`.`formtype` AS `formtype`,
   `u`.`itemid` AS `itemid`,
   `u`.`unit` AS `unit`,
   `u`.`qty` AS `qty`,
   `u`.`saleprice` AS `saleprice`,
    u.interval,
    u.cashreceiptprintout,
    u.cashreceiptdetailprintout
FROM afunit u 
INNER JOIN af on af.objid = u.itemid;

