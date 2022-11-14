[getSignatories]
SELECT * FROM txnsignatory WHERE refid = $P{refid} ORDER BY seqno 

[getLookup]
SELECT 
	objid, name, title
FROM signatory 
WHERE doctype = $P{doctype}
  AND (lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext})
ORDER BY name 


[deleteSignatories]
DELETE FROM txnsignatory WHERE refid = $P{refid}


[updateSignatory]
UPDATE txnsignatory SET 
	personnelid =  $P{personnelid},
	name =  $P{name},
	title = $P{title},
	dtsigned =  $P{dtsigned}
WHERE objid = $P{objid}	


[updateSignatories]
UPDATE ${tablename} SET signatories = $P{signatories} WHERE objid = $P{objid}
