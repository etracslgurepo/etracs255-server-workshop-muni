DROP VIEW IF EXISTS vw_entityindividual_lookup;
CREATE VIEW vw_entityindividual_lookup 
AS 
SELECT 
	e.objid, e.entityno, e.name, e.address_text as addresstext, 
	e.type, ei.lastname, ei.firstname, ei.middlename, ei.gender, ei.birthdate, 
	e.mobileno, e.phoneno 
FROM entity e 
INNER JOIN entityindividual ei on ei.objid=e.objid 
WHERE state = 'ACTIVE'