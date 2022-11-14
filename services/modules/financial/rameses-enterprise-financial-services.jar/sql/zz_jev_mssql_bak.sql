[getRootNodes]
SELECT a.* FROM account a  WHERE a.parentid IS NULL and a.type='group' ORDER BY a.code

[getChildNodes]
SELECT a.* FROM account a WHERE a.parentid=$P{objid} and a.type='group' ORDER BY a.code

[getList]
SELECT * FROM account WHERE parentid=$P{objid} ORDER BY code 

[getSearch]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM account WHERE code LIKE $P{searchtext}
  UNION 
  SELECT * FROM account WHERE title LIKE $P{searchtext}
) a
ORDER BY a.code 

[findInfo]
SELECT a.*, p.code AS parent_code, p.title AS parent_title 
FROM account a
LEFT JOIN account p ON a.parentid = p.objid
WHERE a.objid=$P{objid}

[getLookup]
SELECT a.* FROM 
(SELECT objid,code,title FROM account t WHERE t.code LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid}
UNION
SELECT objid,code,title FROM account t WHERE t.title LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid} ) 
AS a ORDER BY a.title

[approve]
UPDATE account SET state='APPROVED' WHERE objid=$P{objid} 

[changeParent]
UPDATE account SET parentid=$P{parentid} WHERE objid=$P{objid} 

[getSubaccounts]
SELECT a.* FROM account a WHERE a.parentid=$P{objid} AND a.type='subaccount' ORDER BY a.code

[getItemsInNGASAccount]
select 
	jevid, acctid, acctcode, 
	(case when acctid is null then '<Unmapped>' else acctname end) as acctname, 
	groupindex, sum(dr) as dr, sum(cr) as cr 
from ( 
	select 
		ji.jevid, b.objid acctid, b.code as acctcode, b.title as acctname, 
		ji.dr, ji.cr, ji.objid as itemid, ji.acctcode as itemcode, ji.acctname as itemname, 
		(case when b.objid is null then 0 else 1 end) as groupindex 
	from jevitem ji  
		left join ( 
			select a.*, aim.itemid  
			from ( 
				select top 1 objid from account_maingroup a 
				where reporttype = 'NGAS' 
				order by version desc 
			)tmp1 
				inner join account_maingroup amg on amg.objid = tmp1.objid 
				inner join account_item_mapping aim on aim.maingroupid = amg.objid 
				inner join account a on a.objid = aim.acctid 
		)b on b.itemid = ji.objid 
	where ji.jevid = $P{jevid} 
)tmp1
group by jevid, acctid, acctcode, acctname, groupindex 
order by groupindex 
