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
				select objid from account_maingroup a 
				where reporttype = 'NGAS' 
				order by version desc limit 1 
			)tmp1 
				inner join account_maingroup amg on amg.objid = tmp1.objid 
				inner join account_item_mapping aim on aim.maingroupid = amg.objid 
				inner join account a on a.objid = aim.acctid 
		)b on b.itemid = ji.acctid  
	where ji.jevid = $P{jevid} 
)tmp1
group by jevid, acctid, acctcode, acctname, groupindex 
order by groupindex 
