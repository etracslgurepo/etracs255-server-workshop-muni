if object_id('dbo.sys_user_role', 'V') IS NOT NULL 
  drop view dbo.sys_user_role; 
go 
CREATE VIEW sys_user_role AS select u.objid AS objid,u.lastname AS lastname,u.firstname AS firstname,u.middlename AS middlename,u.username AS username,concat(u.lastname,', ',u.firstname,(case when isnull(u.middlename) then '' else (' ' + u.middlename) end)) AS name,ug.role AS role,ug.domain AS domain,ugm.org_objid AS orgid,u.txncode AS txncode,u.jobtitle AS jobtitle,ugm.objid AS usergroupmemberid,ugm.usergroup_objid AS usergroup_objid from ((sys_usergroup_member ugm join sys_usergroup ug on((ug.objid = ugm.usergroup_objid))) join sys_user u on((u.objid = ugm.user_objid))) 
go 

-- ----------------------------
-- View structure for vw_af_control_detail
-- ----------------------------
if object_id('dbo.vw_af_control_detail', 'V') IS NOT NULL 
  drop view dbo.vw_af_control_detail; 
go 
CREATE VIEW [vw_af_control_detail] AS 
select 
	afd.*, 
	afc.afid, afc.unit, af.formtype, af.denomination, af.serieslength, 
	afu.qty, afu.saleprice, afc.startseries, afc.endseries, afc.currentseries, 
	afc.stubno, afc.prefix, afc.suffix, afc.cost, afc.batchno, 
	afc.state as controlstate, afd.qtyending as qtybalance 
from af_control_detail afd 
	inner join af_control afc on afc.objid = afd.controlid 
	inner join af on af.objid = afc.afid 
	inner join afunit afu on (afu.itemid=af.objid and afu.unit=afc.unit)
GO

-- ----------------------------
-- View structure for vw_af_inventory_summary
-- ----------------------------
if object_id('dbo.vw_af_inventory_summary', 'V') IS NOT NULL 
  drop view dbo.vw_af_inventory_summary; 
go 
CREATE VIEW [vw_af_inventory_summary] AS 
SELECT 
  af.objid, 
  af.title, 
  u.unit,
  (SELECT COUNT(*) FROM af_control WHERE state = 'OPEN' AND afid = af.objid ) AS countopen,  
  (SELECT COUNT(*) FROM af_control WHERE state = 'ISSUED' AND afid = af.objid ) AS countissued,  
  (SELECT COUNT(*) FROM af_control WHERE state = 'OPEN' AND afid = af.objid ) AS countclosed,  
  (SELECT COUNT(*) FROM af_control WHERE state = 'PROCESSING' AND afid = af.objid ) AS countprocessing  
FROM af 
  INNER JOIN afunit u ON af.objid = u.itemid
GO

-- ----------------------------
-- View structure for vw_afunit
-- ----------------------------
if object_id('dbo.vw_afunit', 'V') IS NOT NULL 
  drop view dbo.vw_afunit; 
go 
CREATE VIEW [vw_afunit] AS 
SELECT
   u.objid, af.title, af.usetype, af.serieslength, af.system, 
   af.denomination, af.formtype, u.itemid, u.unit, u.qty, u.saleprice,  
   u.interval, u.cashreceiptprintout, u.cashreceiptdetailprintout  
FROM afunit u 
   INNER JOIN af on af.objid = u.itemid
GO

-- ----------------------------
-- View structure for vw_batchcapture_collection
-- ----------------------------
if object_id('dbo.vw_batchcapture_collection', 'V') IS NOT NULL 
  drop view dbo.vw_batchcapture_collection; 
go 
CREATE VIEW [vw_batchcapture_collection] AS 
select 
  bc.objid, bc.state, bc.txndate, bc.defaultreceiptdate, bc.txnmode, bc.stub, bc.formno, bc.formtype, 
  bc.controlid, bc.serieslength, bc.prefix, bc.suffix, bc.totalamount, bc.totalcash, bc.totalnoncash, 
  bc.collectiontype_objid, bc.collectiontype_name, bc.collector_objid, bc.collector_name, bc.collector_title, 
  bc.capturedby_objid, bc.capturedby_name, bc.capturedby_title, bc.org_objid, bc.org_name, 
  bc.postedby_objid, bc.postedby_name, bc.postedby_date, bc.endseries, 
  isnull(min(bce.series),min(bc.startseries)) as startseries, isnull(max(bce.series)+1, min(bc.startseries)) as currentseries 
from batchcapture_collection bc 
  left join batchcapture_collection_entry bce on bce.parentid = bc.objid 
group by  
  bc.objid, bc.state, bc.txndate, bc.defaultreceiptdate, bc.txnmode, bc.stub, bc.formno, bc.formtype, 
  bc.controlid, bc.serieslength, bc.prefix, bc.suffix, bc.totalamount, bc.totalcash, bc.totalnoncash, 
  bc.collectiontype_objid, bc.collectiontype_name, bc.collector_objid, bc.collector_name, bc.collector_title, 
  bc.capturedby_objid, bc.capturedby_name, bc.capturedby_title, bc.org_objid, bc.org_name, 
  bc.postedby_objid, bc.postedby_name, bc.postedby_date, bc.endseries
GO

-- ----------------------------
-- View structure for vw_cashreceipt_itemaccount
-- ----------------------------
if object_id('dbo.vw_cashreceipt_itemaccount', 'V') IS NOT NULL 
  drop view dbo.vw_cashreceipt_itemaccount; 
go 
CREATE VIEW [vw_cashreceipt_itemaccount] AS 
SELECT 
  objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
  defaultvalue, valuetype, sortorder, org_objid AS orgid 
FROM itemaccount 
WHERE state='ACTIVE' 
  AND type IN ('REVENUE','NONREVENUE','PAYABLE') 
  AND (generic = 0 OR generic IS NULL)
GO

-- ----------------------------
-- View structure for vw_cashreceipt_itemaccount_collectiongroup
-- ----------------------------
if object_id('dbo.vw_cashreceipt_itemaccount_collectiongroup', 'V') IS NOT NULL 
  drop view dbo.vw_cashreceipt_itemaccount_collectiongroup; 
go 
CREATE VIEW [vw_cashreceipt_itemaccount_collectiongroup] AS 
SELECT 
ia.objid,ia.state,ia.code,ia.title,ia.description,ia.type,ia.fund_objid,ia.fund_code,ia.fund_title,
CASE WHEN ca.defaultvalue =0 THEN ia.defaultvalue ELSE ca.defaultvalue END AS defaultvalue,
CASE WHEN ca.valuetype IS NULL THEN ia.valuetype ELSE ca.valuetype END AS valuetype, 
CASE WHEN ca.sortorder=0 THEN ia.sortorder ELSE ca.sortorder END AS sortorder,
org_objid AS orgid, ca.collectiongroupid
FROM itemaccount ia
INNER JOIN collectiongroup_account ca ON ca.account_objid = ia.objid
WHERE (ia.generic = 0  OR ia.generic IS NULL)

UNION 

SELECT  
ia.objid,ia.state,ia.code,ia.title,ia.description,ip.type,ia.fund_objid,ia.fund_code,ia.fund_title,ca.defaultvalue,ca.valuetype, ca.sortorder, ia.org_objid AS orgid,
ca.collectiongroupid 
FROM itemaccount ia 
INNER JOIN itemaccount ip ON ia.parentid = ip.objid
INNER JOIN collectiongroup_account ca ON ca.account_objid = ip.objid
WHERE ip.generic = 1
GO

-- ----------------------------
-- View structure for vw_cashreceipt_itemaccount_collectiontype
-- ----------------------------
if object_id('dbo.vw_cashreceipt_itemaccount_collectiontype', 'V') IS NOT NULL 
  drop view dbo.vw_cashreceipt_itemaccount_collectiontype; 
go 
CREATE VIEW [vw_cashreceipt_itemaccount_collectiontype] AS 
SELECT 
ia.objid,ia.state,ia.code,ia.title,ia.description,ia.type,ia.fund_objid,ia.fund_code,ia.fund_title,
CASE WHEN ca.defaultvalue =0 THEN ia.defaultvalue ELSE ca.defaultvalue END AS defaultvalue,
CASE WHEN ca.valuetype IS NULL THEN ia.valuetype ELSE ca.valuetype END AS valuetype, 
CASE WHEN ca.sortorder=0 THEN ia.sortorder ELSE ca.sortorder END AS sortorder,
null AS orgid, ca.collectiontypeid
FROM itemaccount ia
INNER JOIN collectiontype_account ca ON ca.account_objid=ia.objid
WHERE ia.parentid is NULL AND (ia.generic = 0 OR ia.generic IS NULL) AND ia.state='ACTIVE' AND ia.type IN ('REVENUE','NONREVENUE','PAYABLE')

UNION 

SELECT  
ia.objid,ia.state,ia.code,ia.title,ia.description,ip.type,ia.fund_objid,ia.fund_code,ia.fund_title,ia.defaultvalue,ia.valuetype, ia.sortorder, ia.org_objid AS orgid, ca.collectiontypeid 
FROM itemaccount ia 
INNER JOIN itemaccount ip ON ia.parentid = ip.objid
INNER JOIN collectiontype_account ca ON ca.account_objid=ip.objid
WHERE ip.generic = 1 AND ia.state='ACTIVE' AND ip.type IN ('REVENUE','NONREVENUE','PAYABLE')

UNION 

SELECT  
ia.objid,ia.state,ia.code,ia.title,ia.description,ia.type,ia.fund_objid,ia.fund_code,ia.fund_title,
CASE WHEN ca.defaultvalue =0 THEN ia.defaultvalue ELSE ca.defaultvalue END AS defaultvalue,
CASE WHEN ca.valuetype IS NULL THEN ia.valuetype ELSE ca.valuetype END AS valuetype, 
CASE WHEN ca.sortorder=0 THEN ia.sortorder ELSE ca.sortorder END AS sortorder,
ia.org_objid AS orgid, ca.collectiontypeid
FROM itemaccount ia 
INNER JOIN collectiontype_account ca ON ca.account_objid=ia.objid
WHERE NOT(ia.org_objid IS NULL) AND ia.state='ACTIVE' AND ia.type IN ('REVENUE','NONREVENUE','PAYABLE')
GO

-- ----------------------------
-- View structure for vw_cashreceiptpayment_noncash
-- ----------------------------
if object_id('dbo.vw_cashreceiptpayment_noncash', 'V') IS NOT NULL 
  drop view dbo.vw_cashreceiptpayment_noncash; 
go 
CREATE VIEW [vw_cashreceiptpayment_noncash] AS 
select nc.*, v.objid as void_objid, 
	(case when v.objid is null then 0 else 1 end) as voided, 
	c.receiptno as receipt_receiptno, c.receiptdate as receipt_receiptdate, c.amount as receipt_amount, 
	c.collector_objid as receipt_collector_objid, c.collector_name as receipt_collector_name, c.remittanceid, 
	rem.objid as remittance_objid, rem.controlno as remittance_controlno, rem.controldate as remittance_controldate
from cashreceiptpayment_noncash nc 
	inner join cashreceipt c on c.objid = nc.receiptid 
	left join cashreceipt_void v on v.receiptid = c.objid 
	left join remittance rem on rem.objid = c.remittanceid
GO

-- ----------------------------
-- View structure for vw_cashreceiptpayment_noncash_liquidated
-- ----------------------------
if object_id('dbo.vw_cashreceiptpayment_noncash_liquidated', 'V') IS NOT NULL 
  drop view dbo.vw_cashreceiptpayment_noncash_liquidated; 
go 
CREATE VIEW [vw_cashreceiptpayment_noncash_liquidated] AS 
select 
  nc.*, v.objid as void_objid, 
  (case when v.objid is null then 0 else 1 end) as voided, 
  c.receiptno as receipt_receiptno, c.receiptdate as receipt_receiptdate, c.amount as receipt_amount, 
  c.collector_objid as receipt_collector_objid, c.collector_name as receipt_collector_name, c.remittanceid, 
  r.objid as remittance_objid, r.controlno as remittance_controlno, r.controldate as remittance_controldate, 
  r.collectionvoucherid, cv.objid as collectionvoucher_objid, cv.controlno as collectionvoucher_controlno, 
  cv.controldate as collectionvoucher_controldate, cv.depositvoucherid 
from collectionvoucher cv 
  inner join remittance r on r.collectionvoucherid = cv.objid 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid
GO

-- ----------------------------
-- View structure for vw_collectiongroup
-- ----------------------------
if object_id('dbo.vw_collectiongroup', 'V') IS NOT NULL 
  drop view dbo.vw_collectiongroup; 
go 
CREATE VIEW [vw_collectiongroup] AS 
SELECT cg.objid,cg.name,cg.sharing,NULL AS orgid 
FROM collectiongroup cg
LEFT JOIN collectiongroup_org co ON co.collectiongroupid=cg.objid
WHERE co.objid IS NULL AND cg.state = 'ACTIVE'

UNION 

SELECT cg.objid,cg.name,cg.sharing,co.org_objid AS orgid 
FROM collectiongroup cg
INNER JOIN collectiongroup_org co ON co.collectiongroupid=cg.objid
WHERE cg.state = 'ACTIVE'
GO

-- ----------------------------
-- View structure for vw_collectiontype
-- ----------------------------
if object_id('dbo.vw_collectiontype', 'V') IS NOT NULL 
  drop view dbo.vw_collectiontype; 
go 
CREATE VIEW [vw_collectiontype] AS 
SELECT
   c.objid AS objid,
   c.state AS state,
   c.name AS name,
   c.title AS title,
   c.formno AS formno,
   c.handler AS handler,
   c.allowbatch AS allowbatch,
   c.barcodekey AS barcodekey,
   c.allowonline AS allowonline,
   c.allowoffline AS allowoffline,
   c.sortorder AS sortorder,
   o.org_objid AS orgid,
   c.fund_objid AS fund_objid,
   c.fund_title AS fund_title,
   c.category AS category,
   c.queuesection AS queuesection,
   c.system AS system,
   af.formtype AS af_formtype,
   af.serieslength AS af_serieslength,
   af.denomination AS af_denomination,
   af.baseunit AS af_baseunit,
   c.allowpaymentorder AS allowpaymentorder,
   c.allowkiosk AS allowkiosk,
   c.allowcreditmemo
FROM collectiontype_org o
INNER JOIN  collectiontype c on c.objid = o.collectiontypeid
INNER JOIN af ON af.objid = c.formno
WHERE c.state = 'ACTIVE'

UNION 

SELECT 
   c.objid AS objid,
   c.state AS state,
   c.name AS name,
   c.title AS title,
   c.formno AS formno,
   c.handler AS handler,
   c.allowbatch AS allowbatch,
   c.barcodekey AS barcodekey,
   c.allowonline AS allowonline,
   c.allowoffline AS allowoffline,
   c.sortorder AS sortorder,
   NULL AS orgid,
   c.fund_objid AS fund_objid,
   c.fund_title AS fund_title,
   c.category AS category,
   c.queuesection AS queuesection,
   c.system AS system,
   af.formtype AS af_formtype,
   af.serieslength AS af_serieslength,
   af.denomination AS af_denomination,
   af.baseunit AS af_baseunit,
   c.allowpaymentorder AS allowpaymentorder,
   c.allowkiosk AS allowkiosk,
   c.allowcreditmemo 
FROM collectiontype c 
INNER JOIN af ON af.objid = c.formno
LEFT JOIN collectiontype_org o ON c.objid = o.collectiontypeid
WHERE o.objid IS NULL AND c.state = 'ACTIVE'
GO

-- ----------------------------
-- View structure for vw_collectiontype_account
-- ----------------------------
if object_id('dbo.vw_collectiontype_account', 'V') IS NOT NULL 
  drop view dbo.vw_collectiontype_account; 
go 
CREATE VIEW [vw_collectiontype_account] AS 
select 
	ia.objid, ia.code, ia.title, 
	ia.fund_objid, fund.code as fund_code, fund.title as fund_title, 
	cta.collectiontypeid, cta.tag, cta.valuetype, cta.defaultvalue 
from collectiontype_account cta 
	inner join itemaccount ia on ia.objid = cta.account_objid 
	inner join fund on fund.objid = ia.fund_objid
GO

-- ----------------------------
-- View structure for vw_collectionvoucher_cashreceiptitem
-- ----------------------------
if object_id('dbo.vw_collectionvoucher_cashreceiptitem', 'V') IS NOT NULL 
  drop view dbo.vw_collectionvoucher_cashreceiptitem; 
go 
CREATE VIEW [vw_collectionvoucher_cashreceiptitem] AS 
select 
  cv.controldate as collectionvoucher_controldate, cv.controlno as collectionvoucher_controlno, v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptitem v on v.collectionvoucherid = cv.objid
GO

-- ----------------------------
-- View structure for vw_collectionvoucher_cashreceiptshare
-- ----------------------------
if object_id('dbo.vw_collectionvoucher_cashreceiptshare', 'V') IS NOT NULL 
  drop view dbo.vw_collectionvoucher_cashreceiptshare; 
go 
CREATE VIEW [vw_collectionvoucher_cashreceiptshare] AS 
select 
  cv.controldate as collectionvoucher_controldate, cv.controlno as collectionvoucher_controlno, v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid
GO

-- ----------------------------
-- View structure for vw_deposit_fund_transfer
-- ----------------------------
if object_id('dbo.vw_deposit_fund_transfer', 'V') IS NOT NULL 
  drop view dbo.vw_deposit_fund_transfer; 
go 
CREATE VIEW [vw_deposit_fund_transfer] AS 
SELECT 
   dft.objid,
   dft.amount,
   dft.todepositvoucherfundid,
   tof.objid AS todepositvoucherfund_fund_objid,
   tof.code AS todepositvoucherfund_fund_code,
   tof.title AS todepositvoucherfund_fund_title,
   dft.fromdepositvoucherfundid,
   fromf.objid AS fromdepositvoucherfund_fund_objid,
   fromf.code AS fromdepositvoucherfund_fund_code,
   fromf.title AS fromdepositvoucherfund_fund_title
FROM deposit_fund_transfer dft
INNER JOIN depositvoucher_fund todv ON dft.todepositvoucherfundid = todv.objid
INNER JOIN fund tof ON todv.fundid = tof.objid
INNER JOIN depositvoucher_fund fromdv ON dft.fromdepositvoucherfundid = fromdv.objid
INNER JOIN fund fromf ON fromdv.fundid = fromf.objid
GO

-- ----------------------------
-- View structure for vw_remittance_cashreceipt
-- ----------------------------
if object_id('dbo.vw_remittance_cashreceipt', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_cashreceipt; 
go 
CREATE VIEW [vw_remittance_cashreceipt] AS 
select 
  r.objid as remittance_objid, r.controldate as remittance_controldate, r.controlno as remittance_controlno, 
  c.remittanceid, r.collectionvoucherid, c.controlid, af.formtype, 
  case when af.formtype = 'serial' then 0 else 1 end as formtypeindexno, 
  c.formno, c.stub as stubno, c.series, c.receiptno, c.receiptdate, 
  c.amount, c.totalnoncash, (c.amount - c.totalnoncash) as totalcash, 
  case when v.objid is null then 0 else 1 end as voided, 
  case when v.objid is null then 0 else c.amount end as voidamount, 
  c.paidby, c.paidbyaddress, c.payer_objid, c.payer_name, 
  c.collector_objid, c.collector_name, c.collector_title, 
  c.objid as receiptid, c.collectiontype_objid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join af on af.objid = c.formno 
  left join cashreceipt_void v on v.receiptid = c.objid
GO

-- ----------------------------
-- View structure for vw_remittance_cashreceipt_af
-- ----------------------------
if object_id('dbo.vw_remittance_cashreceipt_af', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_cashreceipt_af; 
go 
CREATE VIEW [vw_remittance_cashreceipt_af] AS 
select 
  cr.remittanceid, cr.collector_objid, cr.controlid, 
  min(cr.receiptno) as fromreceiptno, max(cr.receiptno) as toreceiptno, 
  min(cr.series) as fromseries, max(cr.series) as toseries, 
  count(cr.objid) as qty, sum(cr.amount) as amount, 
  0 as qtyvoided, 0.0 as voidamt, 
  0 as qtycancelled, 0.0 as cancelledamt, 
  af.formtype, af.serieslength, af.denomination, 
  cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  
from cashreceipt cr
  inner join remittance rem on rem.objid = cr.remittanceid 
  inner join af_control afc ON cr.controlid=afc.objid 
  inner join af ON afc.afid = af.objid 
group by 
  cr.remittanceid, cr.collector_objid, cr.controlid, 
  af.formtype, af.serieslength, af.denomination, 
  cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  

union all 

select 
  cr.remittanceid, cr.collector_objid, cr.controlid, 
  null as fromreceiptno, null as toreceiptno, 
  null as fromseries, null as toseries, 
  0 as qty, 0.0 as amount, 
  count(cr.objid) as qtyvoided, sum(cr.amount) as voidamt, 
  0 as qtycancelled, 0.0 as cancelledamt, 
  af.formtype, af.serieslength, af.denomination, 
  cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  
from cashreceipt cr 
  inner join cashreceipt_void cv on cv.receiptid = cr.objid 
  inner join remittance rem on rem.objid = cr.remittanceid 
  inner join af_control afc ON cr.controlid=afc.objid 
  inner join af ON afc.afid = af.objid 
group by 
  cr.remittanceid, cr.collector_objid, cr.controlid, 
  af.formtype, af.serieslength, af.denomination, 
  cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  

union all 

select 
  cr.remittanceid, cr.collector_objid, cr.controlid, 
  null as fromreceiptno, null as toreceiptno, 
  null as fromseries, null as toseries, 
  0 as qty, 0.0 as amount, 0 as qtyvoided, 0.0 as voidamt, 
  count(cr.objid) as qtycancelled, sum(cr.amount) as cancelledamt, 
  af.formtype, af.serieslength, af.denomination, 
  cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix  
from cashreceipt cr 
  inner join remittance rem on rem.objid = cr.remittanceid 
  inner join af_control afc ON cr.controlid=afc.objid 
  inner join af ON afc.afid = af.objid 
where cr.state = 'CANCELLED' 
group by 
  cr.remittanceid, cr.collector_objid, cr.controlid, 
  af.formtype, af.serieslength, af.denomination, 
  cr.formno, afc.stubno, afc.startseries, afc.endseries, afc.prefix, afc.suffix
GO

-- ----------------------------
-- View structure for vw_remittance_cashreceipt_afsummary
-- ----------------------------
if object_id('dbo.vw_remittance_cashreceipt_afsummary', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_cashreceipt_afsummary; 
go 
CREATE VIEW [vw_remittance_cashreceipt_afsummary] AS 
select 
  concat( remittanceid, collector_objid, controlid ) as objid, 
  remittanceid, collector_objid, controlid, 
  min(fromreceiptno) as fromreceiptno, max(toreceiptno) as toreceiptno, 
  min(fromseries) as fromseries, max(toseries) as toseries, 
  sum(qty) as qty, sum(amount) as amount, 
  sum(qtyvoided) as qtyvoided, sum(voidamt) as voidamt, 
  sum(qtycancelled) as qtycancelled, sum(cancelledamt) as cancelledamt, 
  formtype, serieslength, denomination, formno, stubno, 
  startseries, endseries, prefix, suffix 
from vw_remittance_cashreceipt_af 
group by 
  remittanceid, collector_objid, controlid, 
  formtype, serieslength, denomination, formno, stubno, 
  startseries, endseries, prefix, suffix
GO

-- ----------------------------
-- View structure for vw_remittance_cashreceiptitem
-- ----------------------------
if object_id('dbo.vw_remittance_cashreceiptitem', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_cashreceiptitem; 
go 
CREATE VIEW [vw_remittance_cashreceiptitem] AS 
select 
  c.remittanceid, r.controldate as remittance_controldate, r.controlno as remittance_controlno, 
  r.collectionvoucherid, c.collectiontype_objid, c.collectiontype_name, c.formtype, c.formno, 
  case when c.formtype = 'serial' then 0 else 1 end as formtypeindex, 
  cri.receiptid, c.receiptdate, c.receiptno, c.paidby, c.paidbyaddress, 
  c.collector_objid as collectorid, c.collector_name as collectorname, c.collector_title as collectortitle, 
  cri.item_fund_objid as fundid, cri.item_objid as acctid, cri.item_code as acctcode, cri.item_title as acctname, 
  case when v.objid is null then cri.amount else 0.0 end as amount, 
  case when v.objid is null then 0 else 1 end as voided, 
  case when v.objid is null then 0.0 else cri.amount end as voidamount 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem cri on cri.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid
GO

-- ----------------------------
-- View structure for vw_remittance_cashreceiptpayment_noncash
-- ----------------------------
if object_id('dbo.vw_remittance_cashreceiptpayment_noncash', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_cashreceiptpayment_noncash; 
go 
CREATE VIEW [vw_remittance_cashreceiptpayment_noncash] AS 
select 
  nc.objid, nc.receiptid, nc.refno, nc.refdate, 
  nc.reftype, nc.particulars, nc.refid, nc.amount, 
  case when v.objid is null then 0 else 1 end as voided, 
  case when v.objid is null then 0.0 else nc.amount end as voidamount, 
  cp.bankid, cp.bank_name, c.remittanceid, r.collectionvoucherid
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'CHECK') 
  inner join checkpayment cp on cp.objid = nc.refid 
  left join cashreceipt_void v on v.receiptid = c.objid 

union all 

select 
  cm.objid, cm.receiptid, cm.refno, cm.refdate, 
  'CREDITMEMO' as reftype, cm.particulars, cm.objid as refid, cm.amount, 
  case when v.objid is null then 0 else 1 end as voided, 
  case when v.objid is null then 0.0 else nc.amount end as voidamount, 
  ba.bank_objid as bankid, ba.bank_name, c.remittanceid, r.collectionvoucherid 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype <> 'CHECK') 
  inner join creditmemo cm on cm.receiptid = c.objid 
  inner join bankaccount ba on ba.objid = cm.bankaccount_objid 
  left join cashreceipt_void v on v.receiptid = c.objid
GO

-- ----------------------------
-- View structure for vw_remittance_cashreceiptshare
-- ----------------------------
if object_id('dbo.vw_remittance_cashreceiptshare', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_cashreceiptshare; 
go 
CREATE VIEW [vw_remittance_cashreceiptshare] AS 
select 
  c.remittanceid, r.controldate as remittance_controldate, r.controlno as remittance_controlno, 
  r.collectionvoucherid, c.formno, cs.receiptid, c.receiptdate, c.receiptno, c.formtype, c.paidby, c.paidbyaddress, 
  c.collector_objid as collectorid, c.collector_name as collectorname, c.collector_title as collectortitle, 
  cs.refitem_objid as refacctid, ia.fund_objid as fundid, ia.objid as acctid, ia.code as acctcode, ia.title as acctname, 
  case when v.objid is null then cs.amount else 0.0 end as amount, 
  case when v.objid is null then 0 else 1 end as voided, 
  case when v.objid is null then 0.0 else cs.amount end as voidamount 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid
GO

-- ----------------------------
-- View structure for vw_rptpayment_item
-- ----------------------------
if object_id('dbo.vw_rptpayment_item', 'V') IS NOT NULL 
  drop view dbo.vw_rptpayment_item; 
go 
CREATE VIEW `vw_rptpayment_item` AS select `x`.`rptledgerid` AS `rptledgerid`,`x`.`parentid` AS `parentid`,`x`.`rptledgerfaasid` AS `rptledgerfaasid`,`x`.`year` AS `year`,`x`.`qtr` AS `qtr`,`x`.`revperiod` AS `revperiod`,sum(`x`.`basic`) AS `basic`,sum(`x`.`basicint`) AS `basicint`,sum(`x`.`basicdisc`) AS `basicdisc`,sum(`x`.`basicdp`) AS `basicdp`,sum(`x`.`basicnet`) AS `basicnet`,sum(`x`.`basicidle`) AS `basicidle`,sum(`x`.`basicidleint`) AS `basicidleint`,sum(`x`.`basicidledisc`) AS `basicidledisc`,sum(`x`.`basicidledp`) AS `basicidledp`,sum(`x`.`sef`) AS `sef`,sum(`x`.`sefint`) AS `sefint`,sum(`x`.`sefdisc`) AS `sefdisc`,sum(`x`.`sefdp`) AS `sefdp`,sum(`x`.`sefnet`) AS `sefnet`,sum(`x`.`firecode`) AS `firecode`,sum(`x`.`sh`) AS `sh`,sum(`x`.`shint`) AS `shint`,sum(`x`.`shdisc`) AS `shdisc`,sum(`x`.`shdp`) AS `shdp`,sum(`x`.`amount`) AS `amount`,max(`x`.`partialled`) AS `partialled`,`x`.`voided` AS `voided` from `vw_rptpayment_item_detail` `x` group by `x`.`rptledgerid`,`x`.`parentid`,`x`.`rptledgerfaasid`,`x`.`year`,`x`.`qtr`,`x`.`revperiod`,`x`.`voided` 
go 

-- ----------------------------
-- View structure for vw_rptpayment_item_detail
-- ----------------------------
if object_id('dbo.vw_rptpayment_item_detail', 'V') IS NOT NULL 
  drop view dbo.vw_rptpayment_item_detail; 
go 
CREATE VIEW `vw_rptpayment_item_detail` AS select `rpi`.`objid` AS `objid`,`rpi`.`parentid` AS `parentid`,`rp`.`refid` AS `rptledgerid`,`rpi`.`rptledgerfaasid` AS `rptledgerfaasid`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revperiod` AS `revperiod`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`amount` else 0 end) AS `basic`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`interest` else 0 end) AS `basicint`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`discount` else 0 end) AS `basicdisc`,(case when (`rpi`.`revtype` = 'basic') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicdp`,(case when (`rpi`.`revtype` = 'basic') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicnet`,(case when (`rpi`.`revtype` = 'basicidle') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicidle`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`interest` else 0 end) AS `basicidleint`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`discount` else 0 end) AS `basicidledisc`,(case when (`rpi`.`revtype` = 'basicidle') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicidledp`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`amount` else 0 end) AS `sef`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`interest` else 0 end) AS `sefint`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`discount` else 0 end) AS `sefdisc`,(case when (`rpi`.`revtype` = 'sef') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `sefdp`,(case when (`rpi`.`revtype` = 'sef') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sefnet`,(case when (`rpi`.`revtype` = 'firecode') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `firecode`,(case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sh`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`interest` else 0 end) AS `shint`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`discount` else 0 end) AS `shdisc`,(case when (`rpi`.`revtype` = 'sh') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `shdp`,((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) AS `amount`,`rpi`.`partialled` AS `partialled`,`rp`.`voided` AS `voided` from (`rptpayment_item` `rpi` join `rptpayment` `rp` on((`rpi`.`parentid` = `rp`.`objid`))) 
go 
