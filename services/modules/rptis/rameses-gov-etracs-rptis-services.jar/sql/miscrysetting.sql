[getSettingsForSync]
select s.objid from miscrysetting s
inner join rysetting_lgu l on l.rysettingid = s.objid 
where l.lguid = $P{lguid}
and l.settingtype = 'misc'
and s.ry = $P{ry}