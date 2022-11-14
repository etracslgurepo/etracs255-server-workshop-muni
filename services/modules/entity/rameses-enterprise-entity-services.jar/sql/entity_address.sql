[getList]
SELECT * FROM entity_address WHERE parentid=$P{objid} 

[removeEntityAddress]
delete from entity_address where parentid=$P{parentid} 

[getListByOwner]
SELECT a.*,
CASE WHEN EXISTS (SELECT * FROM entity e WHERE e.address_objid = a.objid) THEN 1 ELSE 0 END AS 'asdefault' 
FROM entity_address a 
WHERE a.parentid=$P{objid}

[updateEntityDefaultAddress]
UPDATE entity SET address_text=$P{addresstext} where objid=$P{entityid} 

[makeDefault]
UPDATE entity SET address_objid=$P{addressid}, 
address_text=$P{addresstext} where objid=$P{entityid} 

