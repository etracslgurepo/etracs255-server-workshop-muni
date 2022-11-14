[getList]
select 
	b.objid, b.state, b.bin, b.businessname, b.address_text, 
	b.owner_name, b.owner_address_text, b.orgtype, b.activeyear, 
	b.currentapplicationid 
from ( 
	select objid from business where bin like $P{searchtext} 
	union 
	select objid from business where businessname like $P{searchtext} 
	union 
	select objid from business where owner_name like $P{searchtext} 
)xx 
	inner join business b on xx.objid=b.objid 
where b.currentapplicationid in ( 
	select distinct applicationid 
	from business_receivable 
	where applicationid=b.currentapplicationid 
		and (amount-amtpaid) > 0 
) 
order by b.businessname 
