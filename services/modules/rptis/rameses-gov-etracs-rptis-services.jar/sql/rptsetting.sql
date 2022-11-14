[getSettingsByCategory]
SELECT * FROM sys_var WHERE category = $P{category} ORDER BY name 

[updateSetting]
UPDATE sys_var SET value = $P{value} WHERE name = $P{name}