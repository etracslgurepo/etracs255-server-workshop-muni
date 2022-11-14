[getList]
SELECT r.* FROM ( 
	SELECT objid,name FROM sys_rule 
	WHERE ruleset=$P{ruleset} and name like $P{name} 
	union 
	SELECT objid,name FROM sys_rule 
	WHERE ruleset=$P{ruleset} and title like $P{title} 
)xx INNER JOIN sys_rule r on xx.objid=r.objid 
${filter} 

[getRulesets]
SELECT * FROM sys_ruleset

[getRulegroups]
SELECT * 
FROM sys_rulegroup 
WHERE ruleset=$P{ruleset}
ORDER BY sortorder

[getFacts]
SELECT f.* 
FROM sys_rule_fact f
INNER JOIN sys_ruleset_fact rf ON rf.rulefact=f.objid
WHERE rf.ruleset=$P{ruleset}
ORDER BY f.sortorder

[getActionDefs]
SELECT ad.* 
FROM sys_rule_actiondef ad
INNER JOIN sys_ruleset_actiondef ra ON ra.actiondef=ad.objid 
WHERE ra.ruleset=$P{ruleset}
ORDER BY sortorder

[getFactRulesets]
SELECT * FROM sys_ruleset_fact WHERE rulefact=$P{objid} 

[getFactFields]
SELECT *
FROM sys_rule_fact_field 
WHERE parentid=$P{objid}
ORDER BY sortorder

[findRule]
SELECT r.* 
FROM sys_rule r 
WHERE r.objid = $P{objid}

[getRuleConditions]
SELECT rc.*,  
	f.title AS fact_title, 
	f.factclass AS fact_factclass,
	f.dynamicfieldname AS fact_dynamicfieldname,
	f.builtinconstraints AS fact_builtinconstraints
FROM sys_rule_condition rc
INNER JOIN sys_rule_fact f ON f.objid=rc.fact_objid
WHERE rc.parentid=$P{objid} 
ORDER BY rc.pos

[getRuleConditionVars]
SELECT * FROM sys_rule_condition_var WHERE parentid=$P{objid} ORDER BY pos

[getRuleConditionConstraints]
SELECT c.*, 
f.name AS field_name, 
f.title AS field_title, 
f.datatype AS field_datatype, 
f.handler AS field_handler, 
f.lookupkey AS field_lookupkey, 
f.lookupvalue AS field_lookupvalue,
f.lookuphandler AS field_lookuphandler, 
f.lookupdatatype AS field_lookupdatatype, 
f.lovname AS field_lovname, 
f.vardatatype AS field_vardatatype, 
f.required AS field_required, 
f.multivalued AS field_multivalued
FROM sys_rule_condition_constraint c
INNER JOIN sys_rule_fact_field f ON f.objid=c.field_objid
WHERE c.parentid=$P{objid} ORDER BY c.pos

[getRuleActions]
SELECT a.*, ad.title AS actiondef_title, ad.actionname AS actiondef_actionname 
FROM sys_rule_action a
INNER JOIN sys_rule_actiondef ad ON ad.objid=a.actiondef_objid
WHERE a.parentid=$P{objid} ORDER BY a.pos

[getRuleActionParams]
SELECT p.*, 
ad.name AS actiondefparam_name,
ad.title AS actiondefparam_title,
ad.datatype AS actiondefparam_datatype,
ad.handler AS actiondefparam_handler,
ad.datatype AS actiondefparam_datatype,
ad.lookupkey AS actiondefparam_lookupkey,
ad.lookupvalue AS actiondefparam_lookupvalue,
ad.lookuphandler AS actiondefparam_lookuphandler,
ad.vardatatype AS actiondefparam_vardatatype,
ad.lovname AS actiondefparam_lovname
FROM sys_rule_action_param p
INNER JOIN sys_rule_actiondef_param ad ON ad.objid=p.actiondefparam_objid
WHERE p.parentid=$P{objid} 
ORDER BY ad.sortorder

[findAllVarsByType]
SELECT objid, name, datatype, pos 
FROM
(
SELECT var.objid, var.varname AS name, var.datatype, cond.pos 
FROM sys_rule_condition_var var
INNER JOIN sys_rule_condition cond ON var.parentid=cond.objid
WHERE cond.parentid=$P{ruleid}
UNION 
SELECT var.objid, var.varname AS NAME, fact.factsuperclass AS datatype, cond.pos
FROM sys_rule_condition_var var
INNER JOIN sys_rule_condition cond ON var.parentid=cond.objid
LEFT JOIN sys_rule_fact fact ON var.datatype=fact.factclass  
WHERE cond.parentid=$P{ruleid} AND NOT(fact.factsuperclass IS NULL)
) var
WHERE NOT(var.objid IS NULL)
${filter}
ORDER BY var.pos

[getActionDefRulesets]
SELECT * FROM sys_ruleset_actiondef WHERE actiondef=$P{objid} 

[getActionDefParams]
SELECT *
FROM sys_rule_actiondef_param
WHERE parentid=$P{objid}
ORDER BY sortorder

[getRulesForDeployment]
SELECT d.ruletext 
FROM sys_rule_deployed d
INNER JOIN sys_rule r ON d.objid = r.objid 
WHERE r.ruleset = $P{ruleset}


[removeAllConditionConstraint]
DELETE 
FROM sys_rule_condition_constraint
WHERE parentid=$P{objid}

[removeAllConditionVar]
DELETE 
FROM sys_rule_condition_var
WHERE parentid=$P{objid}

[removeAllActionParams]
DELETE
FROM sys_rule_action_param
WHERE parentid=$P{objid}

[getRuleVars]
SELECT * 
FROM sys_rule_condition_var 
WHERE ruleid = $P{objid}
ORDER BY pos

[removeAllRuleConstraints]
DELETE FROM sys_rule_condition_constraint WHERE parentid IN ( 
	SELECT objid FROM sys_rule_condition WHERE parentid=$P{objid} 
) 

[removeAllRuleConditionVars]
DELETE FROM sys_rule_condition_var WHERE parentid IN (
	SELECT objid FROM sys_rule_condition WHERE parentid=$P{objid} 
) 

[removeAllRuleConditions]
DELETE FROM sys_rule_condition WHERE parentid =$P{objid} 

[removeAllRuleActionParams]
DELETE FROM sys_rule_action_param WHERE parentid IN  ( 
	SELECT objid FROM sys_rule_action WHERE parentid=$P{objid} 
) 

[removeAllRuleActions]
DELETE FROM sys_rule_action WHERE parentid=$P{objid} 

[removeActionDefRulesets]
DELETE FROM sys_ruleset_actiondef WHERE actiondef=$P{objid}

[removeActionDefParams]
DELETE FROM sys_rule_actiondef_param WHERE parentid=$P{objid}

[removeActionDef]
DELETE FROM sys_rule_actiondef WHERE objid=$P{objid}

[removeFactRulesets]
DELETE FROM sys_ruleset_fact WHERE rulefact=$P{objid}

[removeFactFields]
DELETE FROM sys_rule_fact_field WHERE parentid=$P{objid}

[removeFact]
DELETE FROM sys_rule_fact WHERE objid=$P{objid}


[getRuleActionsForLoading]
SELECT a.* FROM sys_rule_actiondef a
WHERE a.objid IN ( 
	SELECT actiondef FROM sys_ruleset_actiondef WHERE ruleset=$P{ruleset} 
)
