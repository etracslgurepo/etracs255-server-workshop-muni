[getOpenList]
select a.* from ( 
  select 
    ac.objid, ac.afid, ac.txnmode, ac.assignee_objid, ac.assignee_name,
    case when af.formtype = 'serial' then ac.startseries else null end as startseries,
    case when af.formtype = 'serial' then ac.currentseries else null end as currentseries,
    case when af.formtype = 'serial' then ac.endseries else null end as endseries,
    ac.active, ac.org_objid, ac.org_name, ac.fund_objid, ac.fund_title, ac.stubno, ac.owner_objid,
    ac.owner_name, ac.prefix, ac.suffix, (ac.currentseries-ac.startseries) as qtyissued, 
    ((ac.endseries-ac.currentseries) + 1) as qtybalance, 
    case when af.formtype = 'serial' then ac.startseries else ac.stubno end as sortseries, 
    case when af.formtype = 'serial' then 0 else 1 end as sortgroupindex 
  from ( 
    select objid from af_control 
    where owner_objid=$P{userid} 
      and currentseries <= endseries  
    union 
    select objid from af_control 
    where assignee_objid=$P{userid} 
      and currentseries <= endseries 
  )xx 
    inner join af_control ac on xx.objid=ac.objid 
    inner join af on ac.afid=af.objid 
  where 1=1 ${filter} 
)a 
order by sortgroupindex, afid, sortseries 


[getAssigneeOpenList]
SELECT a.* FROM ( 
  SELECT 
    ac.objid, ac.afid, ac.txnmode, ac.assignee_objid, ac.assignee_name,
    case when af.formtype = 'serial' then ac.startseries else null end as startseries,
    case when af.formtype = 'serial' then ac.currentseries else null end as currentseries,
    case when af.formtype = 'serial' then ac.endseries else null end as endseries,
    ac.active, ac.org_objid, ac.org_name, ac.fund_objid, ac.fund_title, ac.stubno, ac.owner_objid,
    ac.owner_name, ac.prefix, ac.suffix, (ac.currentseries-ac.startseries)  AS qtyissued,
    ((ac.endseries-ac.currentseries) + 1)  AS qtybalance, af.serieslength, af.denomination, af.formtype,
    owner.jobtitle AS owner_title, assignee.jobtitle AS assignee_title
  FROM af_control ac 
  	inner join af on af.objid  = ac.afid 
  	LEFT JOIN sys_user owner ON owner_objid=owner.objid
  	LEFT JOIN sys_user assignee ON assignee_objid=assignee.objid
  WHERE ac.currentseries <= endseries 
    AND ac.assignee_objid=$P{userid}
    AND ac.afid = $P{formno}
    AND ac.txnmode = $P{txnmode}
    ${filter}  
)a 
order by startseries  


[getAssigneeIssuanceList]
SELECT 
  ac.objid, ac.afid, ac.txnmode, ac.assignee_objid, ac.assignee_name,
  case when af.formtype = 'serial' then ac.startseries else null end as startseries,
  case when af.formtype = 'serial' then ac.currentseries else null end as currentseries,
  case when af.formtype = 'serial' then ac.endseries else null end as endseries,
  ac.active, ac.org_objid, ac.org_name, ac.fund_objid, ac.fund_title, ac.stubno, ac.owner_objid,
  ac.owner_name, ac.prefix, ac.suffix, (ac.currentseries-ac.startseries)  AS qtyissued,
  ((ac.endseries-ac.currentseries) + 1)  AS qtybalance, af.serieslength, af.denomination, af.formtype,
  owner.jobtitle AS owner_title, assignee.jobtitle AS assignee_title ,
  case when ac.currentseries = ac.startseries then 0 else 1 end as opened  
FROM af_control ac 
  inner join af on af.objid  = ac.afid 
  LEFT JOIN sys_user owner ON owner_objid=owner.objid
  LEFT JOIN sys_user assignee ON assignee_objid=assignee.objid
WHERE ac.currentseries <= endseries 
AND ac.owner_objid=$P{userid}
AND ac.afid = $P{formno}
AND ac.owner_objid <> ac.assignee_objid 
order by startseries  


[findActiveControlForCashReceipt]
SELECT ac.*, af.serieslength, af.denomination, 
assignee.jobtitle AS assignee_title, 
owner.jobtitle AS owner_title 
FROM af_control ac 
INNER JOIN af ON af.objid=ac.afid 
INNER JOIN sys_user assignee ON assignee.objid=ac.assignee_objid
INNER JOIN sys_user owner ON owner.objid=ac.owner_objid
WHERE ac.afid = $P{afid}
AND ac.currentseries <= ac.endseries 
AND ac.active = 1
AND ac.txnmode = $P{txnmode}
AND ac.assignee_objid=$P{userid}
${filter}


[findActiveControlForDeactivation]
SELECT objid
FROM af_control
WHERE assignee_objid=$P{userid}
AND afid = $P{afid}
AND txnmode = $P{txnmode}
AND active=1
${filter} 


[reactivateControl]
UPDATE af_control   
SET active=1, txnmode=$P{txnmode} 
WHERE objid=$P{objid}
	${filter} 


[assignSubcollector]
UPDATE af_control 
SET assignee_objid=$P{assigneeid},
   assignee_name=$P{assigneename}
WHERE objid=$P{objid}   

[unassignSubcollector]
update af_control set 
	assignee_name = owner_name, assignee_objid = owner_objid, active = 0 
where objid=$P{objid} 

[changeMode]
UPDATE af_control 
SET txnmode = $P{txnmode}
WHERE objid=$P{objid}

[updateNextSeries]
UPDATE af_control 
SET currentseries = currentseries + $P{qtyissued}
WHERE objid = $P{objid} 

[closeAFControl]
UPDATE af_control SET 
	currentseries = $P{currentseries},
	active = 0, 
	txnmode =$P{txnmode} 
WHERE objid = $P{objid}

[assignFund]
update af_control set 
	fund_objid=$P{fundid},
	fund_title=$P{fundtitle} 
where objid=$P{objid} 

[unassignFund]
update af_control set fund_objid=NULL, fund_title=NULL 
where objid=$P{objid} 

[findControlForBatch]
SELECT 
ac.objid,
ac.controlid, 
ac.currentseries AS startseries,
ac.endseries AS endseries,
ac.stubno AS stub, 
ac.prefix,
ac.suffix, 
a.serieslength
FROM af_control ac
INNER JOIN af a ON ac.afid=a.objid
WHERE ac.objid = $P{objid}

[updateLastTxnDate]
UPDATE af_control SET lasttxndate=$P{lasttxndate} WHERE objid=$P{objid}  

[findAFSummary]
select 
  afc.objid, afc.afid, afc.startseries, afc.endseries, 
  af.denomination, af.formtype, af.serieslength, 
  0.0 as amount 
from af_control afc 
  inner join af on afc.afid=af.objid 
where afc.objid=$P{controlid} 

[syncCurrentIndexNo]
update af_control set 
  currentindexno = ifnull((select max(indexno) from af_control_detail where controlid=af_control.objid),0)
where 
  objid = $P{objid} 


[syncCurrentIndexNoByReceipt]
update af_control set 
  currentindexno = ifnull((select max(indexno) from af_control_detail where controlid=af_control.objid),0) 
where 
  receiptid = $P{receiptid} 


[syncCurrentIndexNoByIDs]
update af_control set 
    currentindexno = ifnull((select max(indexno) from af_control_detail where controlid=af_control.objid),0)
where 
  objid in (${ids}) 
