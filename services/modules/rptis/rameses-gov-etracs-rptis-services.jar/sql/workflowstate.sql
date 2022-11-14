[insert]
INSERT INTO workflowstate (objid, state, txndate, userid, username)
VALUES ($P{objid}, $P{state}, $P{txndate}, $P{userid}, $P{username})

[delete]
DELETE FROM workflowstate WHERE objid = $P{objid} AND state = $P{state}

[deleteAll]
DELETE FROM workflowstate WHERE objid = $P{objid}

[get]
SELECT * FROM workflowstate WHERE objid = $P{objid} AND state = $P{state} 
