[copyFact]
INSERT INTO sys_rule_fact
(objid,name,title,factclass,sortorder,handler,defaultvarname,dynamic,lookuphandler,lookupkey,lookupvalue,lookupdatatype,dynamicfieldname,builtinconstraints,domain,factsuperclass)
SELECT
$P{newid},$P{newid},title,$P{newid},sortorder,handler,defaultvarname,dynamic,lookuphandler,lookupkey,lookupvalue,lookupdatatype,dynamicfieldname,builtinconstraints,domain,factsuperclass
FROM sys_rule_fact 
WHERE objid = $P{oldid}

[copyFactField]
INSERT INTO sys_rule_fact_field
(objid,parentid,name,title,datatype,sortorder,handler,lookuphandler,lookupkey,lookupvalue,lookupdatatype,multivalued,required,vardatatype,lovname)
SELECT
($P{newid} +'.'+ name),$P{newid},name,title,datatype,sortorder,handler,lookuphandler,lookupkey,lookupvalue,lookupdatatype,multivalued,required,vardatatype,lovname
FROM sys_rule_fact_field WHERE parentid=$P{oldid}

[copyRulesetFact]
INSERT INTO sys_ruleset_fact (ruleset, rulefact) 
SELECT f.ruleset, $P{newid} 
FROM sys_ruleset_fact f 
WHERE f.rulefact = $P{oldid}  
 AND NOT EXISTS (SELECT * FROM sys_ruleset_fact WHERE rulefact=$P{newid} and ruleset=f.ruleset)


[refactorCondition]
UPDATE sys_rule_condition 
SET fact_name = $P{newid}, fact_objid = $P{newid}
WHERE fact_objid = $P{oldid}


[refactorConstraint]
UPDATE sys_rule_condition_constraint  
SET field_objid  = (
	SELECT s2.objid 
	FROM sys_rule_fact_field s1, sys_rule_fact_field s2
	WHERE s1.objid = sys_rule_condition_constraint.field_objid 
	AND s1.name = s2.name 
	AND s1.parentid = $P{oldid} AND s2.parentid = $P{newid}
)
WHERE 
field_objid IN (
	SELECT objid FROM sys_rule_fact_field WHERE parentid = $P{oldid} 
)


[removeRulesetFact]
DELETE FROM sys_ruleset_fact WHERE rulefact=$P{oldid}

[removeFactField]
DELETE FROM sys_rule_fact_field WHERE parentid=$P{oldid}

[removeFact]
DELETE FROM sys_rule_fact WHERE objid=$P{oldid}
