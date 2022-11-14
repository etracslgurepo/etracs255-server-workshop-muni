DROP VIEW IF EXISTS cashreceipt_af_summary;
CREATE VIEW cashreceipt_af_summary AS 
SELECT 
CONCAT( cr.collector_objid, cr.remittanceid, afc.objid ) AS objid, af.formtype, cr.remittanceid,  
cr.collector_objid,afc.objid AS afcontrolid, afc.stubno,cr.formno,  
MIN(cr.series) AS fromseries, MAX(cr.series) AS toseries, afc.endseries,
COUNT(*) AS qty, SUM( CASE WHEN cv.objid IS NULL THEN cr.amount ELSE 0 END ) AS amount  
FROM cashreceipt cr
INNER JOIN af_control afc ON cr.controlid=afc.objid 
INNER JOIN af ON afc.afid = af.objid 
LEFT JOIN cashreceipt_void cv ON cr.objid = cv.receiptid
GROUP BY cr.collector_objid, afc.objid, afc.stubno,cr.formno, af.formtype, cr.remittanceid;