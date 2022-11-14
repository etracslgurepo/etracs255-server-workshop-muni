[getSettingsForSync]
select s.objid from bldgrysetting s
inner join rysetting_lgu l on l.rysettingid = s.objid 
where l.lguid = $P{lguid}
and l.settingtype = 'bldg'
and s.ry = $P{ry}