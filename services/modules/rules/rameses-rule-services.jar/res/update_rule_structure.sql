UPDATE sys_rule 
SET state='UPGRADE' WHERE state='DEPLOYED'
AND ruleset = <ruleset>;

DELETE FROM sys_rule_deployed
WHERE objid IN (SELECT objid FROM sys_rule WHERE state='UPGRADE' 
AND ruleset = <ruleset>);



