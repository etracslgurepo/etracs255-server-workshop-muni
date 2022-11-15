-- ## 2022-03-07

delete from sys_wf_transition where processname = 'business_application' and parentid = 'approval' and action = 'submit' 
;

insert into sys_wf_transition (
  parentid, processname, action, `to`, idx, eval, properties, permission, caption, ui
) 
values (
  'approval', 'business_application', 'submit', 'payment', '0', NULL, 
  '[  caption:\"Approve For Payment\",  icon:\"approve\",  confirm: ''You are about to submit this for payment. Proceed?'',   depends: ''currentSection'',   visibleWhen: ''#{(has_loaded_assessment == true && entity.totals.total > 0)}'']', NULL, NULL, NULL
)

;
insert into sys_wf_transition (
  parentid, processname, action, `to`, idx, eval, properties, permission, caption, ui
) 
values (
  'approval', 'business_application', 'submit', 'release', '0', NULL, 
  '[  caption:\"Approve For Release\",  icon:\"approve\",  confirm: ''You are about to submit this for release. Proceed?'',   depends: ''currentSection'',   visibleWhen: ''#{(has_loaded_assessment == true && entity.totals.total == 0)}'']', NULL, NULL, NULL
)
;




-- ## 2022-04-07

insert into sys_rule_fact_field (
  objid, parentid, name, title, sortorder, `handler`, datatype, vardatatype 
) 
select 
  concat(f.objid, '.year') as objid, f.objid as parentid, 'year' as name, 'Year' as title, 
  4 as sortorder, 'integer' as `handler`, 'integer' as datatype, 'integer' as vardatatype 
from sys_rule_fact f 
  left join sys_rule_fact_field ff on (ff.parentid = f.objid and ff.name = 'year') 
where f.factclass = 'bpls.facts.BillItem'
  and ff.objid is null 
; 




-- ## 2022-04-11

INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUBarangay', 'treasury.facts.LGUBarangay', 'LGU Barangay', 'treasury.facts.LGUBarangay', '100', NULL, 'BRGY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUMunicipality', 'treasury.facts.LGUMunicipality', 'LGU Municipality', 'treasury.facts.LGUMunicipality', '100', NULL, 'MUNI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUProvince', 'treasury.facts.LGUProvince', 'LGU Province', 'treasury.facts.LGUProvince', '100', NULL, 'PROV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');

INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgid', 'treasury.facts.LGUBarangay', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgclass', 'treasury.facts.LGUBarangay', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.root', 'treasury.facts.LGUBarangay', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgid', 'treasury.facts.LGUMunicipality', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgclass', 'treasury.facts.LGUMunicipality', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.root', 'treasury.facts.LGUMunicipality', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgid', 'treasury.facts.LGUProvince', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgclass', 'treasury.facts.LGUProvince', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.root', 'treasury.facts.LGUProvince', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUBarangay');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUMunicipality');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUProvince');


INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.CollectionType', 'treasury.facts.CollectionType', 'Collection Type', 'treasury.facts.CollectionType', '0', NULL, 'CT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', NULL);

INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.CollectionType.objid', 'treasury.facts.CollectionType', 'objid', 'ID', 'string', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.CollectionType.name', 'treasury.facts.CollectionType', 'name', 'Name', 'string', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.CollectionType.handler', 'treasury.facts.CollectionType', 'handler', 'Handler', 'string', '2', 'lookup', 'collectiontype_handler:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.CollectionType');




-- ## 2022-04-15

drop view if exists vw_cashbook_cashreceipt
; 
CREATE VIEW vw_cashbook_cashreceipt AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  ci.amount as dr, null as cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid
  inner join cashreceiptitem ci on ci.receiptid = c.objid
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceipt_share
; 
CREATE VIEW vw_cashbook_cashreceipt_share AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  -cs.amount AS dr, null AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.refitem_objid AS refitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceipt_share_payable
; 
CREATE VIEW vw_cashbook_cashreceipt_share_payable AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount AS dr, null AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.payableitem_objid AS payableitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid  
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_cashreceiptvoid
; 
CREATE VIEW vw_cashbook_cashreceiptvoid AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -ci.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then -ci.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -ci.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then -ci.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then cs.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then cs.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then cs.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share_payable
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share_payable AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -cs.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then -cs.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then -cs.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_remittance
;
CREATE VIEW vw_cashbook_remittance AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ci.item_fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then ci.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then ci.amount
    else null 
  end) as cr,  
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series, 
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name, 
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share
;
CREATE VIEW vw_cashbook_remittance_share AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then -cs.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then -cs.amount 
    else null 
  end) as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share_payable
;
CREATE VIEW vw_cashbook_remittance_share_payable AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then cs.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then cs.amount 
    else null 
  end) as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid
  left join cashreceipt_void v on v.receiptid = c.objid 
;
