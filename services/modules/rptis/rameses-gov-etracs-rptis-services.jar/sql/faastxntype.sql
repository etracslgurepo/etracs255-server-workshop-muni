[insertAttributeType]
insert into faas_txntype_attribute_type
	(attribute)
values($P{attribute})


[insertAttribute]	
insert into faas_txntype_attribute (
	txntype_objid, attribute, idx
)
values 
($P{objid}, $P{attribute}, $P{idx})



[getAttributes]
select *, txntype_objid as objid from faas_txntype_attribute where txntype_objid = $P{objid} order by idx 


[deleteAttributes]
delete from faas_txntype_attribute where txntype_objid = $P{objid}


[findAttributeType]
select * from faas_txntype_attribute_type where attribute = $P{attribute}