[getSettingsForSync]
select s.objid from planttreerysetting s
inner join rysetting_lgu l on l.rysettingid = s.objid 
where l.lguid = $P{lguid}
and l.settingtype = 'planttree'
and s.ry = $P{ry}