[insertPin]
INSERT INTO pin 
	(objid, state, barangayid)
VALUES	
	($P{objid}, $P{state}, $P{barangayid})


[deletePin]
DELETE FROM pin WHERE objid = $P{objid}


[updateState]
UPDATE pin SET state = $P{state} WHERE objid = $P{pinid}

[updateBarangayid]
UPDATE pin SET barangayid = $P{barangayid} WHERE objid = $P{pinid}