[getListForReconcile] 
SELECT * FROM entity 
WHERE entityname LIKE $P{entityname} 
  AND objid <> $P{entityid} 
ORDER BY entityname 

[reconcileTaxpayerId]
update faas set
	taxpayer_objid=$P{taxpayerid},
	taxpayer_name=$P{taxpayername},
	taxpayer_address=$P{taxpayeraddress}
where taxpayer_objid = $P{reconciledid}




[deleteIndividual]
DELETE FROM entityindividual WHERE objid = $P{objid}

[deleteJuridical]
DELETE FROM entityjuridical WHERE objid = $P{objid}

[deleteMultiple]
DELETE FROM entitymultiple WHERE objid = $P{objid}

[deleteEntityMember]
DELETE FROM entitymember WHERE entityid = $P{objid}

[deleteEntityContact]
DELETE FROM entitycontact WHERE entityid = $P{objid}

[deleteEntityIDCard]
DELETE FROM entityidcard WHERE entityid = $P{objid}

[deleteEntity]
DELETE FROM entity WHERE objid = $P{objid} 





#----------------------------------
# FAAS 
#----------------------------------


[getFaasListByTaxpayer]
select 
	f.objid, f.tdno, f.owner_name as ownername, f.owner_address as owneraddress, 
	r.rputype, r.totalmv, r.totalav, pr.name as classname, r.fullpin 
from faas f
 inner join rpu r on f.rpuid = r.objid
 left join propertyclassification pr on pr.objid = r.classification_objid 
where f.taxpayer_objid=$P{taxpayerid} 




