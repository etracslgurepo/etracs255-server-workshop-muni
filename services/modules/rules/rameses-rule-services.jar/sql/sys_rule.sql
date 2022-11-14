[undeployForUpgrade]
DELETE FROM sys_rule_deployed 
WHERE objid 
IN ( SELECT objid FROM sys_rule WHERE ruleset = $P{ruleset} AND state='UPGRADE' )
