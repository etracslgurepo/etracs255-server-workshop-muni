[getLobAttribute]
SELECT DISTINCT lob_name AS lobname, attribute_name AS attrname
FROM business_application_info 
WHERE businessid=$P{businessid}
ORDER BY lob_name

[getYears]
SELECT DISTINCT appyear 
FROM business_application
WHERE business_objid=$P{businessid}

[getValues]
SELECT bi.lob_name AS lobname, bi.attribute_name AS attrname, ba.appyear,  
bi.decimalvalue, bi.intvalue, bi.stringvalue, bi.boolvalue 
FROM business_application_info bi
INNER JOIN business_application ba ON ba.objid=bi.applicationid
WHERE ba.business_objid = $P{businessid}
