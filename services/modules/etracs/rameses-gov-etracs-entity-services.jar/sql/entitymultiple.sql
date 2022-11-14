[getList]
SELECT e.*, e.name AS fullname 
FROM entitymultiple emu 
	INNER JOIN entity e ON emu.objid=e.objid 
WHERE e.entityname LIKE $P{searchtext} 
ORDER BY e.entityname 

[getMembers]
SELECT * FROM entitymember WHERE entityid=$P{objid} ORDER BY itemno 

[removeMembers]
DELETE FROM entitymember WHERE entityid=$P{objid} 

[insertMultiple]
insert into entitymultiple(
	objid, fullname 
)
values ($P{objid}, $P{fullname})


[updateMultiple]
update entitymultiple set 
	fullname = $P{fullname}
where objid = $P{objid}

[findById]
select * from entitymultiple where objid = $P{objid}

