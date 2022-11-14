[getEntities]
SELECT 
    e.objid,
    e.entityno,
    $P{mainentityid} AS parent_objid,
    e.name,
    e.address_text,
    a.municipality AS address_municipality,
    a.province AS address_province 
FROM entity e 
LEFT JOIN entity_address a  ON e.address_objid = a.objid 
WHERE e.objid <> $P{mainentityid}
    AND e.type = $P{type}
    AND e.entityname LIKE $P{searchtext}
    AND NOT EXISTS(SELECT * FROM entity_mapping WHERE objid = e.objid) 
ORDER BY e.name ASC