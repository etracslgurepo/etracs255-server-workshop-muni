[findRuleset]
SELECT * FROM sys_ruleset WHERE name = $P{ruleset}

[getRulegroups]
SELECT * FROM sys_rulegroup WHERE ruleset = $P{ruleset}

[getRuleFacts]
SELECT * FROM sys_rule_fact WHERE ruleset = $P{ruleset}

[getFactRulesets]
SELECT * FROM sys_ruleset_fact WHERE rulefact = $P{objid}

[getRuleFactFields]
SELECT * FROM sys_rule_fact_field WHERE parentid = $P{objid}


[getRuleActionDefs]
SELECT * FROM sys_rule_actiondef WHERE ruleset = $P{ruleset}

[getActionDefRulesets]
SELECT * FROM sys_ruleset_actiondef WHERE actiondef = $P{objid}

[getRuleActionDefParams]
SELECT * FROM sys_rule_actiondef_param WHERE parentid = $P{objid}

