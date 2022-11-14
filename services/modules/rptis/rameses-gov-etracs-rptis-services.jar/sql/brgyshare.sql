[getList]
SELECT 
	bs.*,
	CASE 
		WHEN bs.month = 1 THEN 'January'
		WHEN bs.month = 2 THEN 'February'
		WHEN bs.month = 3 THEN 'March'
		WHEN bs.month = 4 THEN 'April'	
		WHEN bs.month = 5 THEN 'May'
		WHEN bs.month = 6 THEN 'June'
		WHEN bs.month = 7 THEN 'July'
		WHEN bs.month = 8 THEN 'August'
		WHEN bs.month = 9 THEN 'September'
		WHEN bs.month = 10 THEN 'October'
		WHEN bs.month = 11 THEN 'November'
		WHEN bs.month = 12 THEN 'December'
	END AS smonth	
FROM brgyshare bs 
${filters}
ORDER BY bs.year, bs.month


[openBrgyShare]
SELECT 
	bs.*,
	CASE 
		WHEN bs.month = 1 THEN 'January'
		WHEN bs.month = 2 THEN 'February'
		WHEN bs.month = 3 THEN 'March'
		WHEN bs.month = 4 THEN 'April'	
		WHEN bs.month = 5 THEN 'May'
		WHEN bs.month = 6 THEN 'June'
		WHEN bs.month = 7 THEN 'July'
		WHEN bs.month = 8 THEN 'August'
		WHEN bs.month = 9 THEN 'September'
		WHEN bs.month = 10 THEN 'October'
		WHEN bs.month = 11 THEN 'November'
		WHEN bs.month = 12 THEN 'December'
	END AS smonth	
FROM brgyshare bs 
WHERE bs.objid = $P{objid}

[deleteItems]
DELETE FROM brgyshareitem WHERE brgyshareid = $P{brgyshareid}

[getAccountPayable]
SELECT * FROM ap WHERE subacctid = $P{subacctid}


[insertPayable]
INSERT INTO ap 
	(objid, subacctid, subacctclass, subaccttitle, sltype, totaldr, totalcr, balance)
SELECT
	$P{apid} AS objid, 
	bsi.barangayid AS subacctid, 
	'barangay' AS subacctclass, 
	b.name AS subaccttitle, 
	'ledger' AS sltype, 
	0.0 AS  totaldr, 
	0.0 AS totalcr, 
	0.0 AS balance
FROM brgyshare bs
	INNER JOIN brgyshareitem bsi ON bs.objid = bsi.brgyshareid 
	INNER JOIN barangay b ON bsi.barangayid = b.objid 
WHERE bs.objid = $P{shareid}


[insertPayableItem]
INSERT INTO ap_detail 
	(objid, parentid, txndate, txnrefid, txnrefno, txnreftype, particulars, dr, cr)
SELECT
	bsi.objid,
	$P{apid} AS parentid,
	bs.txndate,
	bs.objid AS txnrefid,
	bs.txnno AS txnrefno,
	'brgyshare' AS txnreftype,
	CONCAT('Share for the Month of ', $P{smonth}, ', ', bs.year) AS particulars,
	bsi.basicshare + bsi.basicintshare AS dr,
	0.0 AS cr
FROM brgyshare bs
	INNER JOIN brgyshareitem bsi ON bs.objid = bsi.brgyshareid 
	INNER JOIN barangay b ON bsi.barangayid = b.objid 
WHERE bs.objid = $P{shareid}


[updatePayableBalance]
UPDATE ap SET totaldr = totaldr + $P{dr} WHERE objid = $P{objid}




[getOpenBrgyShares]
SELECT
	b.name AS barangay,
	rl.barangayid,
	SUM(rci.basic) AS basic,
	SUM(rci.basicint) AS basicint,
	SUM(rci.basicdisc) AS basicdisc,
	SUM(rci.brgybasic) AS basicshare,
	SUM(rci.brgybasicint) AS basicintshare,
	SUM( rci.brgybasic + rci.brgybasicint) AS totalshare
FROM cashreceipt_rpt rc 
	INNER JOIN cashreceipt_rpt_item rci ON rc.objid = rci.rptreceiptid 
	INNER JOIN rptledger rl ON rci.rptledgerid = rl.objid 
	INNER JOIN barangay b ON rl.barangayid = b.objid 
WHERE rc.year = $P{year}
  AND rc.month = $P{month}
  AND rci.revtype <> 'advance'
GROUP BY b.name, rl.barangayid  


[getBrgyShareItems]
SELECT 
	bsi.*,
	bsi.basicshare + bsi.basicintshare AS totalshare,
	b.name AS barangay
FROM brgyshareitem bsi 
	INNER JOIN barangay b ON bsi.barangayid = b.objid 
ORDER BY b.name 	


[getShareByYearMonth]
SELECT * FROM brgyshare WHERE year = $P{year} AND month = $P{month}


[getBrgyShareItemDetail]
SELECT
	b.name AS barangay,
	SUM(CASE WHEN ri.revtype = 'current' THEN ri.basic + ri.basicint - ri.basicdisc ELSE 0.0 END) AS basiccurrent,
	SUM(CASE WHEN ri.revtype = 'previous' THEN ri.basic + ri.basicint ELSE 0.0 END) AS basicprevious,
	SUM(ri.basic + ri.basicint - ri.basicdisc) AS basictotal,
	SUM(CASE WHEN ri.revtype = 'current' THEN ri.brgybasic + ri.brgybasicint ELSE 0.0 END) AS basiccurrentshare,
	SUM(CASE WHEN ri.revtype = 'previous' THEN ri.brgybasic + ri.brgybasicint ELSE 0.0 END) AS basicpreviousshare,
	SUM(ri.brgybasic + ri.brgybasicint) AS totalshare
FROM cashreceipt_rpt r
		INNER JOIN cashreceipt_rpt_item ri ON r.objid = ri.rptreceiptid 
		INNER JOIN rptledger rl ON ri.rptledgerid = rl.objid
		INNER JOIN barangay b ON rl.barangayid = b.objid 
WHERE r.year = $P{year}		
  AND r.month = $P{month}
  AND ri.revtype <> 'advance'
GROUP BY b.name		