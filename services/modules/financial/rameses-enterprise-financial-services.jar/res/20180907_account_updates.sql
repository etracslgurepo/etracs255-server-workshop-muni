INSERT INTO account 
(objid, maingroupid, code, title, groupid, type)
SELECT 
objid, maingroupid, code, title, groupid, 'group'
FROM account_group;

UPDATE account SET type='root' WHERE groupid IS NULL;

DROP TABLE account_group;
ALTER TABLE account add CONSTRAINT `fk_account_maingroup` FOREIGN KEY (`maingroupid`) REFERENCES `account_maingroup` (`objid`);