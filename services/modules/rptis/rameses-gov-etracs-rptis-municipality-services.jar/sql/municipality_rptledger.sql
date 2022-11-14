[findFaasByTdNo]
SELECT objid FROM faas WHERE tdno = $P{tdno}

[findFaasByPrevTdNo]
SELECT objid FROM faas WHERE prevtdno = $P{prevtdno}

[findLedgerByFaasId]
SELECT objid FROM rptledger WHERE faasid = $P{faasid} AND state = 'APPROVED'