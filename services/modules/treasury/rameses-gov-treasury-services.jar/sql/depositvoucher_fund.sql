[cancelDepositSlips]
update depositslip set 
  state = 'CANCELLED' 
where depositvoucherfundid in ( 
  select objid from depositvoucher_fund 
  where parentid = $P{depositvoucherid} 
)


[findPendingDepositSlip]
select 
  ds.objid,  fund.objid as fund_objid, 
  fund.code as fund_code, fund.title as fund_title 
from depositvoucher_fund dvf 
  inner join fund on fund.objid = dvf.fundid 
  inner join depositslip ds on ds.depositvoucherfundid = dvf.objid 
where dvf.parentid = $P{depositvoucherid} 
  and ds.state not in ('VALIDATED', 'CANCELLED')
order by fund.code, fund.title 
