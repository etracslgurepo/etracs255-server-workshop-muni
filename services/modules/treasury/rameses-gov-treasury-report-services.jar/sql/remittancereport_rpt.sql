[getBrgyShares]
select 
  min(b.name) as barangayname, sum( cri.basic + cri.basicint - cri.basicdisc ) as netbasic, 
  sum(cri.lgushare + cri.lguintshare) as lgushare, sum( cri.brgyshare + brgyintshare) as brgyshare 
from ( 
  select rc.*, 
    (select count(*) from cashreceipt_void where receiptid=rc.objid) as voided 
  from remittance_cashreceipt rc 
  where remittanceid = $P{remittanceid} 
)xx   
  inner join cashreceipt c on xx.objid = c.objid 
  inner join cashreceiptitem_rpt cri on c.objid = cri.rptreceiptid 
  inner join barangay b on cri.barangayid = b.objid 
where xx.voided=0 
group by cri.barangayid 
order by barangayname 
