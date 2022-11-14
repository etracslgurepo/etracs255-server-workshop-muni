[getListForDownload]
select top 25 doc.objid 
from online_business_application_doc_fordownload d
	inner join online_business_application_doc doc on doc.objid = d.objid 
where d.scheduledate < $P{rundate} 
order by d.scheduledate, d.objid 
