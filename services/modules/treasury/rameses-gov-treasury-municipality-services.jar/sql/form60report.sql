[getForm60Items]
select 
	fi.*, h.title as  parentitle, h.code as parentcode 
from form60setup fi
	inner join form60setup  h on fi.parentid = h.objid
where fi.type='item'
order by h.code, fi.code 

[getLiquidatedSummary]
select 
   fa.parentid, sum(cri.amount) as total 
from liquidation l
  inner join liquidation_remittance lr on lr.liquidationid = l.objid 
  inner join remittance_cashreceipt rc on rc.remittanceid = lr.objid 
  inner join cashreceipt c on c.objid = rc.objid 
  inner join cashreceiptitem cri on cri.receiptid = c.objid
  inner join form60account fa on fa.revenueitemid = cri.item_objid 
  left join cashreceipt_void cv on cv.receiptid = c.objid 
where  l.dtposted between $P{fromdate} and $P{todate}  
    and cv.objid is null 
group by fa.parentid 