[getBarangays]
select * from barangay order by indexno 


[updateHeader]
update report_bpdelinquency set 
	totalcount = (select count(*) from report_bpdelinquency_app where parentid=$P{reportid}), 
	processedcount = (select count(*) from report_bpdelinquency_app where parentid=$P{reportid} and lockid is not null) 
where objid=$P{reportid} 


[getReport]
select 
  dtgenerated, businessid, tradename, businessname, businessaddress, ownername, 
  sum(tax) as taxdue, sum(regfee) as regfeedue, sum(othercharge) as otherdue, 
  sum(surcharge) as surcharge, sum(interest) as interest, sum(total) as total, 
  barangayid, barangayname 
from ( 
  select
    rpt.dtfiled as dtgenerated, 
    b.objid as businessid, a.tradename, b.businessname, 
    b.address_text as businessaddress, a.ownername, 
    rpti.tax, rpti.regfee, rpti.othercharge, 
    rpti.surcharge, rpti.interest, rpti.total, 
    baddr.barangay_objid as barangayid, baddr.barangay_name as barangayname 
  from report_bpdelinquency rpt  
    inner join report_bpdelinquency_item rpti on rpti.parentid = rpt.objid 
    inner join business_application a on a.objid = rpti.applicationid 
    inner join business b on b.objid = a.business_objid 
    left join business_address baddr on baddr.objid = b.address_objid 
  where rpt.objid = $P{reportid}  
    and rpti.duedate is not null 
  	and ${filter1} 

  union all 

  select
    rpt.dtfiled as dtgenerated, 
    b.objid as businessid, a.tradename, b.businessname, 
    b.address_text as businessaddress, a.ownername, 
    rpti.tax, rpti.regfee, rpti.othercharge, 
    rpti.surcharge, rpti.interest, rpti.total, 
    baddr.barangay_objid as barangayid, baddr.barangay_name as barangayname 
  from report_bpdelinquency rpt  
    inner join report_bpdelinquency_item rpti on rpti.parentid = rpt.objid 
    inner join business_application a on a.objid = rpti.applicationid 
    inner join business b on b.objid = a.business_objid 
    left join business_address baddr on baddr.objid = b.address_objid 
  where rpt.objid = $P{reportid} 
  	and rpti.duedate is null 
    and ${filter2} 
)t0 
group by 
  dtgenerated, businessid, tradename, businessname, 
  businessaddress, ownername, barangayid, barangayname 
order by barangayname, tradename 
