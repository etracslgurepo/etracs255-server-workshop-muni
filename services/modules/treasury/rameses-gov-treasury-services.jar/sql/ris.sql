[getRISInfo]
select 
    objid, reqno, reqtype, dtfiled, requester_name, itemclass 
    requester_title
from stockrequest     
where objid=$P{risid}


[getRISAFIssueItem]
select 
  ri.item_objid, ri.unit, ri.qty as qtyrequested, 
  afi.endseries, afi.startseries, afi.startstub, afi.endstub, afi.qty as qtyreceived 
from risitem ri 
  left join afissue af on ri.parentid = af.risid 
  left join afissueitem afi on afi.parentid = af.objid and ri.item_objid = afi.af
where ri.parentid=$P{risid} 

[getRISReceiptItem]
select 
  ri.item_objid, ri.unit, ri.qty as qtyrequested, 
  afi.endseries, afi.startseries, afi.startstub, afi.endstub, afi.qty as qtyreceived 
from risitem ri 
  left join afreceipt af on ri.parentid = af.risid 
  left join afreceiptitem afi on afi.parentid = af.objid and ri.item_objid = afi.af
where ri.parentid=$P{risid}