[getList]
SELECT * 
FROM rpttaxincentive
WHERE (txnno LIKE $P{searchtext} OR name LIKE $P{searchtext})
ORDER BY txnno DESC 


[updateTxnNo]
UPDATE rpttaxincentive SET txnno = $P{txnno} WHERE objid = $P{objid}


[getIncentiveItems]
SELECT 
	i.*,
	f.tdno
FROM rpttaxincentive_item i
	INNER JOIN rptledger rl on i.rptledgerid = rl.objid 
	INNER JOIN faas f on rl.faasid = f.objid 
WHERE i.rpttaxincentiveid = $P{objid}	


[deleteAllItems]
DELETE FROM rpttaxincentive_item WHERE rpttaxincentiveid = $P{objid}

[approve]
UPDATE rpttaxincentive SET state = 'APPROVED' WHERE objid = $P{objid}


[clearLedgerNextBillDate]
UPDATE rptledger SET nextbilldate = null WHERE objid = $P{rptledgerid}

