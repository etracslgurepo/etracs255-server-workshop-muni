[getList]
SELECT * FROM businessrequirementtype

[getLookup]
SELECT * FROM businessrequirementtype WHERE code LIKE $P{searchtext}
