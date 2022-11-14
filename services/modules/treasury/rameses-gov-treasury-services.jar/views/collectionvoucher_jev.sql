DROP VIEW IF EXISTS collectionvoucher_jev
;
CREATE VIEW collectionvoucher_jev AS
(
   SELECT 
      ia.objid AS item_objid,
      ia.code  AS item_code,  
      ia.title  AS item_title,
      cl.fundid,
      cl.dr,
      cl.cr,
      cl.refid,
      1 AS priority 
   FROM cash_treasury_ledger cl
   LEFT JOIN itemaccount ia ON cl.fundid = ia.fund_objid AND TYPE='CASH_IN_TREASURY'
)
     
UNION

(SELECT 
   ia.objid item_objid,
   ia.code item_code,
   ia.title item_title,
   ia.fund_objid AS fundid,
   bl.dr,
   bl.cr,
   bl.refid,
   2 AS priority 
FROM  bankaccount_ledger bl
INNER JOIN bankaccount ba ON bl.bankacctid=ba.objid  
INNER JOIN itemaccount ia ON ba.acctid=ia.objid)

UNION 

( SELECT 
   ia.objid AS item_objid,
	ia.code  AS item_code,	
   ia.title  AS item_title,
   ins.fund_objid AS fundid,
   0 AS dr,
   ins.amount AS cr,
   ins.refid, 
   3 AS priority
FROM  income_summary ins
INNER JOIN itemaccount ia ON ins.item_objid=ia.objid )

UNION 

(
  SELECT 
   ia.objid AS item_objid,
	ia.code  AS item_code,	
   ia.title  AS item_title,
   pbl.fund_objid AS fundid,
   0 AS dr,
   pbl.amount AS cr,
   pbl.refid,
   4 AS priority 
FROM  payable_summary pbl
INNER JOIN itemaccount ia ON pbl.item_objid=ia.objid
)

