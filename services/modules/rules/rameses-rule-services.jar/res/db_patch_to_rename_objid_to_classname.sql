#fact changes
INSERT IGNORE INTO sys_rule_fact
(objid,name,title,factclass,sortorder,handler,defaultvarname,dynamic,lookuphandler,lookupkey,lookupvalue,lookupdatatype,dynamicfieldname,builtinconstraints,domain,factsuperclass)
SELECT 
factclass,name,title,factclass,sortorder,handler,defaultvarname,dynamic,lookuphandler,lookupkey,lookupvalue,
lookupdatatype,dynamicfieldname,builtinconstraints,domain,factsuperclass
FROM sys_rule_fact;

UPDATE sys_rule_fact_field ff, sys_rule_fact f
SET ff.parentid = f.factclass
WHERE ff.parentid = f.objid;


UPDATE sys_ruleset_fact rf, sys_rule_fact f
SET rf.rulefact = f.factclass
WHERE rf.rulefact = f.objid; 

UPDATE sys_rule_condition rc, sys_rule_fact f
SET rc.fact_objid = f.factclass
WHERE rc.fact_objid = f.objid;

DELETE FROM sys_rule_fact WHERE objid <> factclass;


#actiondef changes
INSERT IGNORE INTO sys_rule_actiondef
(objid,NAME,title,sortorder,actionname,domain,actionclass)
SELECT 
actionclass,NAME,title,sortorder,actionname,domain,actionclass
FROM sys_rule_actiondef;

UPDATE sys_rule_actiondef_param pp, sys_rule_actiondef a
SET pp.parentid = a.actionclass
WHERE pp.parentid = a.objid;

UPDATE sys_ruleset_actiondef rf, sys_rule_actiondef a
SET rf.actiondef = a.actionclass
WHERE rf.actiondef = a.objid; 

UPDATE sys_rule_action rc, sys_rule_actiondef a
SET rc.actiondef_objid = a.actionclass
WHERE rc.actiondef_objid = a.objid;

DELETE FROM sys_rule_actiondef WHERE objid <> actionclass;