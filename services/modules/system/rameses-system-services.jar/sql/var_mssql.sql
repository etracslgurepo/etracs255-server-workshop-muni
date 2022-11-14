[getCategories]
SELECT DISTINCT 
	category, 
	CASE WHEN ISNULL(category,'')='' THEN '(Default)' ELSE category END AS caption, 
	CASE WHEN ISNULL(category,'')='' THEN 0 ELSE 1 END AS sortorder  
FROM sys_var
ORDER BY sortorder,category 

[getList]
SELECT t.* FROM sys_var t 
WHERE t.category LIKE $P{category} AND t.name LIKE $P{searchtext} 
ORDER BY t.name 

[getDefaultList]
SELECT t.* FROM sys_var t 
WHERE t.category IS NULL AND t.name LIKE $P{searchtext} 
ORDER BY t.name 

[getLookupList]
SELECT t.* FROM sys_var t ORDER BY t.name 

[removeByCategory]
DELETE FROM sys_var WHERE category=$P{category} 
