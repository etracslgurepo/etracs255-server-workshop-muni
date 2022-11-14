
[copyActionDef]
INSERT INTO sys_rule_actiondef
(objid,actionclass,name,title,sortorder,actionname,domain)
SELECT
$P{newid},$P{newid},name,title,sortorder,actionname,domain
FROM sys_rule_actiondef 
WHERE objid = $P{oldid}

[copyActionDefParam]
INSERT INTO sys_rule_actiondef_param
(objid,parentid,name,sortorder,title,datatype,handler,lookuphandler,lookupkey,lookupvalue,vardatatype,lovname)
SELECT
CONCAT($P{newid},'.',name),$P{newid},name,sortorder,title,datatype,handler,lookuphandler,lookupkey,lookupvalue,vardatatype,lovname
FROM sys_rule_actiondef_param WHERE parentid=$P{oldid}

[copyRulesetActionDefs]
INSERT INTO sys_ruleset_actiondef
(ruleset, actiondef) 
SELECT a.ruleset, $P{newid} 
FROM sys_ruleset_actiondef a 
WHERE a.actiondef = $P{oldid}
	AND NOT EXISTS (SELECT * FROM sys_ruleset_actiondef WHERE actiondef=$P{newid} and ruleset=a.ruleset)

[refactorAction]
UPDATE sys_rule_action 
SET actiondef_objid = $P{newid}
WHERE actiondef_objid = $P{oldid}

[refactorActionParam]
UPDATE sys_rule_action_param 
SET actiondefparam_objid = (
	SELECT s2.objid 
	FROM sys_rule_actiondef_param s1, sys_rule_actiondef_param s2
	WHERE s1.objid = sys_rule_action_param.actiondefparam_objid 
	AND s1.name = s2.name 
	AND s1.parentid = $P{oldid} AND s2.parentid = $P{newid}
)
WHERE 
actiondefparam_objid IN (
	SELECT objid FROM sys_rule_actiondef_param WHERE parentid = $P{oldid} 
)

[removeRulesetActionDef]
DELETE FROM sys_ruleset_actiondef WHERE actiondef=$P{oldid}

[removeActionDefParam]
DELETE FROM sys_rule_actiondef_param WHERE parentid=$P{oldid}

[removeActionDef]
DELETE FROM sys_rule_actiondef WHERE objid=$P{oldid}
