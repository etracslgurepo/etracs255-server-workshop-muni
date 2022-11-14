[getList]
SELECT * FROM sys_orgclass

[getLookup]
SELECT o.* 
FROM (
	SELECT o.name, CASE WHEN o.name=$P{excludename} THEN 0 ELSE 1 END AS allowed 
	FROM sys_orgclass o WHERE o.name LIKE $P{searchtext} 
	
	UNION
	
	SELECT o.name, CASE WHEN o.name=$P{excludename} THEN 0 ELSE 1 END AS allowed 
	FROM sys_orgclass o WHERE o.title LIKE $P{searchtext}
)bt 
	INNER JOIN sys_orgclass o ON bt.name=o.name 
WHERE bt.allowed=1 
