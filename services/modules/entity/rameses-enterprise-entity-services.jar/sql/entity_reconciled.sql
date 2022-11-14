[backup]
INSERT INTO entity_reconciled 
(objid, info, masterid)
VALUES
($P{objid}, $P{info}, $P{masterid})

[backupTxn]
INSERT INTO entity_reconciled_txn
(objid,reftype,refid,tag)
VALUES
($P{objid},$P{reftype},$P{refid},$P{tag})
