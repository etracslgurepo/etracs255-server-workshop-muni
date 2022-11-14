[getSettingsForSync]
select s.objid from machrysetting s
inner join rysetting_lgu l on l.rysettingid = s.objid 
where l.lguid = $P{lguid}
and l.settingtype = 'mach'
and s.ry = $P{ry}