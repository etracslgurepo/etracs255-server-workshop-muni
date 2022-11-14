DROP VIEW IF EXISTS bpls_lob_info;
DROP VIEW IF EXISTS bpls_lob_info_extended;

CREATE VIEW bpls_lob_info AS
SELECT  
	ba.objid AS applicationid,
	ba.business_objid AS businessid,
	ba.tradename,
	ba.ownername,
	ba.dtfiled,
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
	ba.state AS appstate,
	ba.apptype,
	bal.name AS lobname, 
	bal.assessmenttype, 
	bal.lobid,
	bal.activeyear,
	   ( SELECT decimalvalue FROM business_application_info bai 
	     WHERE bai.applicationid=bal.applicationid AND bai.lob_objid=bal.lobid AND bai.attribute_objid='CAPITAL') AS capital, 

	   ( SELECT decimalvalue FROM business_application_info bai 
	     WHERE bai.applicationid=bal.applicationid AND bai.lob_objid=bal.lobid AND bai.attribute_objid='GROSS') AS gross,

	   ( SELECT decimalvalue FROM business_application_info bai 
	     WHERE bai.applicationid=bal.applicationid AND bai.lob_objid=bal.lobid AND bai.attribute_objid='ASSET_SIZE') AS assetsize,    


        (SELECT MAX(rba.dtfiled) FROM business_application_lob rbal 
  	     INNER JOIN business_application rba ON rbal.applicationid=rba.objid
  	     WHERE rbal.lobid=bal.lobid AND rbal.activeyear=bal.activeyear 
  		 AND rbal.assessmenttype='RETIRE' 
  		 AND rba.state IN ('RELEASE', 'COMPLETED')) AS retiredate

FROM business_application_lob bal 
INNER JOIN business_application ba ON bal.applicationid=ba.objid
WHERE  ba.state IN ('RELEASE', 'COMPLETED')
AND NOT(bal.assessmenttype='RETIRE');


CREATE VIEW bpls_lob_info_extended AS
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
FROM bpls_lob_info b;


