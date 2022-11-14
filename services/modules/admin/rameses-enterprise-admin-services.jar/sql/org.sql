[getList]
SELECT * FROM sys_org 
WHERE orgclass=$P{orgclass} 
ORDER BY name 

[getOrgClasses]
SELECT * FROM sys_orgclass

[getLookup]
SELECT o.*, p.name as parent_name  
FROM sys_org o 
	LEFT JOIN sys_org p on p.objid = o.parent_objid  
WHERE o.orgclass=$P{orgclass} ${filters} 
ORDER BY p.name, o.name 

[findRoot]
SELECT * FROM sys_org WHERE root = 1

[findByName]
SELECT * FROM sys_org WHERE name=$P{name} 

[findByCode]
SELECT * FROM sys_org WHERE code=$P{code} 

[getOrgsByParent]
SELECT * FROM sys_org WHERE parent_objid = $P{objid}
