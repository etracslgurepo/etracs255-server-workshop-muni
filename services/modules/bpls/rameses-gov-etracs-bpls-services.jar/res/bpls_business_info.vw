DROP VIEW IF EXISTS bpls_business_info;
DROP VIEW IF EXISTS bpls_business_info_extended;

CREATE VIEW bpls_business_info AS

SELECT 
   ba.objid AS applicationid,
   ba.appyear,
   ba.apptype,
   b.orgtype,
   ba.ownername,
   ba.tradename,

   DATE_FORMAT( ba.dtfiled, '%c') AS `month`, 	
   DATE_FORMAT( ba.dtfiled, '%Y') AS `year`,
   CASE DATE_FORMAT( ba.dtfiled, '%c')  	
	   WHEN 1 THEN 1	
	   WHEN 2 THEN 1
	   WHEN 3 THEN 1
	   WHEN 4 THEN 2
	   WHEN 5 THEN 2	   
	   WHEN 6 THEN 2
	   WHEN 7 THEN 3
	   WHEN 8 THEN 3
	   WHEN 9 THEN 3	   
	   ELSE 4
   END AS qtr,
   	
   ( SELECT bai.intvalue FROM business_application_info bai
     WHERE bai.applicationid=ba.objid 
     AND bai.lob_objid IS NULL 
     AND bai.attribute_objid = 'NUM_EMPLOYEE') AS numemployee, 

   ( SELECT bai.intvalue 
     FROM business_application_info bai
     WHERE bai.applicationid=ba.objid 
     AND bai.lob_objid IS NULL 
     AND bai.attribute_objid = 'NUM_EMPLOYEE_MALE') AS numemployeemale, 

   ( SELECT bai.intvalue 
     FROM business_application_info bai
     WHERE bai.applicationid=ba.objid 
     AND bai.lob_objid IS NULL 
     AND bai.attribute_objid = 'NUM_EMPLOYEE_FEMALE') AS numemployeefemale, 

    (SELECT SUM( decimalvalue ) 
     FROM business_application_info bai
     WHERE bai.applicationid=ba.objid 
     AND NOT(bai.lob_objid IS NULL) 
     AND bai.attribute_objid = 'CAPITAL') AS capital,   

    (SELECT SUM( decimalvalue ) 
     FROM business_application_info bai
     WHERE bai.applicationid=ba.objid 
     AND NOT(bai.lob_objid IS NULL) 
     AND bai.attribute_objid = 'GROSS') AS gross,   

    (SELECT SUM( decimalvalue ) 
     FROM business_application_info bai
     WHERE bai.applicationid=ba.objid 
     AND NOT(bai.lob_objid IS NULL) 
     AND bai.attribute_objid = 'ASSET_SIZE') AS assetsize,   

    ( SELECT MAX(dtfiled) 
      FROM business_application rba WHERE rba.appyear=ba.appyear
      AND rba.state IN ('RELEASE', 'COMPLETED')
     ) AS dtretired,   

     (SELECT 1 FROM entityindividual e WHERE e.objid=b.owner_objid AND e.gender='M' ) AS ownermale,
     (SELECT 1 FROM entityindividual e WHERE e.objid=b.owner_objid AND e.gender='F' ) AS ownerfemale
 

FROM business_application ba
INNER JOIN business b ON ba.business_objid=b.objid
WHERE  ba.state IN ('RELEASE', 'COMPLETED')
AND NOT(ba.apptype='RETIRE');

CREATE VIEW bpls_business_info_extended AS
SELECT b.*, 
CASE 
   WHEN capital IS NULL AND gross IS NULL AND assetsize IS NULL THEN 'NA'	
   WHEN assetsize <= 3000000 THEN 'MICRO'
   WHEN assetsize <= 15000000 THEN 'SMALL'
   WHEN assetsize <= 100000000 THEN 'MEDIUM'
   WHEN capital <= 3000000 THEN 'MICRO'
   WHEN capital <= 15000000 THEN 'SMALL'
   WHEN capital <= 100000000 THEN 'MEDIUM'
   WHEN gross <= 3000000 THEN 'MICRO'
   WHEN gross <= 15000000 THEN 'SMALL'
   WHEN gross <= 100000000 THEN 'MEDIUM'
   ELSE 'LARGE'
END AS businesssize
FROM bpls_business_info b;
