ALTER TABLE cashreceiptitem ADD COLUMN remittancefundid VARCHAR(100);
ALTER TABLE cashreceiptitem ADD COLUMN remittanceid VARCHAR(100);
ALTER TABLE cashreceipt_share ADD COLUMN remittancefundid VARCHAR(100);
ALTER TABLE cashreceipt_share ADD COLUMN remittanceid VARCHAR(100);
ALTER TABLE cashreceiptpayment_noncash ADD COLUMN remittancefundid VARCHAR(100);
ALTER TABLE cashreceiptpayment_noncash ADD COLUMN remittanceid VARCHAR(100);

UPDATE cashreceiptitem cri, cashreceipt cr, remittance_fund rf
SET cri.remittancefundid = rf.objid, cri.remittanceid = rf.remittanceid
WHERE cri.receiptid = cr.objid
AND cr.remittanceid = rf.remittanceid 
AND  cri.item_fund_objid = rf.fund_objid;

UPDATE cashreceipt_share crs, cashreceipt cr, itemaccount itm, remittance_fund rf
SET crs.remittancefundid = rf.objid, crs.remittanceid = rf.remittanceid
WHERE crs.receiptid = cr.objid
AND cr.remittanceid = rf.remittanceid 
AND crs.payableitem_objid = itm.objid 
AND  itm.fund_objid = rf.fund_objid;

UPDATE cashreceiptpayment_noncash crpn, cashreceipt cr, remittance_fund rf
SET crpn.remittancefundid = rf.objid, crpn.remittanceid = rf.remittanceid
WHERE crpn.receiptid = cr.objid
AND cr.remittanceid = rf.remittanceid 
AND  crpn.fund_objid = rf.fund_objid;


ALTER TABLE `cashreceiptitem` ADD CONSTRAINT `fk_cashreceiptitem_remittancefund` FOREIGN KEY (`remittanceid`,`remittancefundid`) REFERENCES `remittance_fund` (`remittanceid`, `objid`);
ALTER TABLE `cashreceipt_share` ADD CONSTRAINT `fk_cashreceipt_share_remittancefund` FOREIGN KEY (`remittanceid`,`remittancefundid`) REFERENCES `remittance_fund` (`remittanceid`, `objid`);
ALTER TABLE `cashreceiptpayment_noncash` ADD CONSTRAINT `fk_cashreceiptpayment_noncash_remittancefund` FOREIGN KEY (`remittanceid`,`remittancefundid`) REFERENCES `remittance_fund` (`remittanceid`,`objid`);
