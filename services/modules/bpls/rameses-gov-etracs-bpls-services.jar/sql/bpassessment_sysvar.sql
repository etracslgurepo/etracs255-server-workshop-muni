[getList]
SELECT ap1.stringvalue AS name, ap2.lov AS datatype 
FROM sys_rule_action_param ap1
INNER JOIN sys_rule_action_param ap2 ON ap1.parentid=ap2.parentid 
INNER JOIN sys_rule_actiondef_param adp1 ON ap1.actiondefparam_objid=adp1.objid
INNER JOIN sys_rule_actiondef_param adp2 ON ap2.actiondefparam_objid=adp2.objid
INNER JOIN sys_rule_actiondef ad ON adp1.parentid=ad.objid 
INNER JOIN sys_ruleset_actiondef rsad ON rsad.actiondef=ad.objid
WHERE ad.name = 'bpassessment_sysvar' AND rsad.ruleset='bpassessment'
AND adp1.name='name' AND adp2.name='datatype'