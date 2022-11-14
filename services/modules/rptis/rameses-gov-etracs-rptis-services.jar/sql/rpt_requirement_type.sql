[getList]
SELECT * 
FROM rpt_requirement_type
WHERE (objid LIKE $P{seachtext} OR name LIKE $P{searchtext})
ORDER BY sortorder, name 

[approve]
UPDATE rpt_requirement_type SET state = 'APPROVED' WHERE objid = $P{objid}


[getFaasTxnAttributeTypes]
select * from faas_txntype_attribute_type wh