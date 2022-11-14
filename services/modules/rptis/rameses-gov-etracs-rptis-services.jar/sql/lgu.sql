[findBarangayById]
SELECT * FROM barangay WHERE objid = $P{objid}


[getBarangaysByParentId]
SELECT * FROM barangay WHERE parentid LIKE $P{parentid}
