[getList]
select 
	afc.objid, afc.afid, afc.txnmode, afc.owner_objid, afc.owner_name, 
	afc.startseries, afc.endseries, afc.currentseries, afc.active, 
	afc.org_objid, afc.org_name, afc.stubno, af.formtype, af.denomination  
from af_control afc 
	inner join af on afc.afid=af.objid 
where afc.owner_objid=$P{collectorid} 
	and afc.txnmode in ('ONLINE','OFFLINE','CAPTURE') 
	and afc.currentseries <= afc.endseries 
order by afc.afid, afc.dtfiled, afc.startseries, afc.stubno 
