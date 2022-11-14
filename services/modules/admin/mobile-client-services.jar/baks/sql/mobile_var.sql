[getDeviceSettings]
SELECT v.name, v.value FROM sys_var v WHERE v.name LIKE 'device%' 
