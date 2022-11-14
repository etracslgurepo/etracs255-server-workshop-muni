[getList]
SELECT objid, parent_objid, findings, recommendations, txnno, dtinspected, notedby, notedbytitle
FROM examiner_finding 
WHERE parent_objid = $P{parentid}
ORDER BY dtinspected


