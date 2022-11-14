DROP VIEW IF EXISTS cashreceipt_fund_summary;
CREATE VIEW cashreceipt_fund_summary AS 
SELECT 
    CONCAT( IFNULL( cr.remittanceid, '-' ), f.objid ) AS objid, 
    CONCAT( IFNULL( r.controlno, '-'), f.code ) AS controlno,
    cr.remittanceid, 
    f.objid AS fund_objid,
    f.code AS fund_code,
    f.title AS fund_title,
    SUM( cri.amount ) AS amount    
FROM 
cashreceiptitem cri 
INNER JOIN cashreceipt cr ON cri.receiptid=cr.objid
LEFT JOIN cashreceipt_void cv ON cv.receiptid = cr.objid 
LEFT JOIN remittance r ON cr.remittanceid = r.objid 
INNER JOIN fund f ON cri.item_fund_objid = f.objid 
WHERE cv.objid IS NULL AND cr.state <> 'CANCELLED'
GROUP BY cr.remittanceid, f.objid, f.code, f.title, r.controlno 