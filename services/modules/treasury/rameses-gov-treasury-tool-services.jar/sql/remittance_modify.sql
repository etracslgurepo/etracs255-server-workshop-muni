[getBuildRemittanceFunds]
select 
	remittanceid, controlno as remittanceno, fund_objid, fund_title, fund_code, 
	sum(amount) as amount, sum(totalcheck) as totalcheck, sum(totalcr) as totalcr, 
	sum(amount)-sum(totalcheck)-sum(totalcr) as totalcash 
from ( 
	select 
		cr.remittanceid, r.controlno, f.objid as fund_objid, f.title as fund_title, f.code as fund_code, 
		sum( cri.amount ) as amount, 0.0 as totalcheck, 0.0 as totalcr 
	from remittance r 
		inner join cashreceipt cr on cr.remittanceid = r.objid 
		inner join cashreceiptitem cri on cri.receiptid = cr.objid 
		inner join fund f ON f.objid = cri.item_fund_objid 
		left join cashreceipt_void v ON v.receiptid = cr.objid 
	where r.objid = $P{remittanceid}  
		and cr.state <> 'CANCELLED'
		and v.objid IS NULL 
	group by 
		cr.remittanceid, r.controlno, f.objid, f.title, f.code 
	union all 
	select 
		cr.remittanceid, r.controlno, f.objid as fund_objid, f.title as fund_title, f.code as fund_code, 0.0 as amount, 
		sum(case when nc.reftype='CHECK' then nc.amount else 0.0 end) as totalcheck, 
		sum(case when nc.reftype='EFT' then nc.amount else 0.0 end) as totalcr 
	from remittance r 
		inner join cashreceipt cr on cr.remittanceid = r.objid 
		inner join cashreceiptpayment_noncash nc on nc.receiptid = cr.objid 
		left join fund f ON f.objid = nc.fund_objid 
		left join cashreceipt_void v ON v.receiptid = cr.objid 
	where r.objid = $P{remittanceid}  
		and cr.state <> 'CANCELLED'
		and v.objid IS NULL 
	group by 
		cr.remittanceid, r.controlno, f.objid, f.title, f.code 
)t1
group by remittanceid, controlno, fund_objid, fund_title, fund_code 

