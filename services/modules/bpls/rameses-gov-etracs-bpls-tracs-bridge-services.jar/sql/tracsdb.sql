[getList]
SELECT * FROM (
   SELECT 
      b.ObjID AS objid, 
      b.strTradeName AS businessname, 
      b.strTradeName AS tradename, 
      strBusinessAddress AS address,
      ta.intyear AS activeyear, 
      ta.inttype, 
      t.strTaxpayer AS name, 
      t.strTaxpayerID AS ownerid, 
      t.strTaxpayer AS ownername, 
      t.strTaxpayerAddress AS owneraddress 
   FROM tblBusiness b
      INNER JOIN tblTaxpayer t on t.strTaxpayerID = b.strTaxpayerID 
      INNER JOIN tblBPLedger bpl on bpl.strBusinessID = b.ObjID 
      INNER JOIN tblAssessment ta on ta.strBusinessID = b.ObjID 
)i 
WHERE NOT EXISTS (SELECT 1 FROM etracs25_capture_business bb WHERE bb.oldbusinessid=i.objid) 
   AND i.inttype in (0,1,6,7) ${filter} 
ORDER BY i.activeyear DESC,  i.tradename 


[getInfo]
select
   b.ObjID AS oldbusinessid, 
   b.strTradeName as business_businessname,
   b.strTradeName as business_tradename, 
   strBusinessAddress as business_address_text,
   a.objid as applicationid, 
   case stat.strtype 
      WHEN 'RENEWAL' THEN 'RENEW'
      WHEN 'REASSESSED (RENEW)' THEN 'RENEW'
      WHEN 'REASSESSED (NEW)' THEN 'NEW'
      WHEN 'ADDITIONAL' THEN 'NEW'
      ELSE stat.strtype 
   end AS apptype, 
   a.dtassessmentdate as dtfiled,
   a.intyear as activeyear, 
   intYearStarted as yearstarted, 
   t.strTaxpayer as business_owner_name, 
   t.strTaxpayerID AS business_owner_oldid,
   it.strLastname AS business_owner_lastname,   
   it.strFirstname AS business_owner_firstname, 
   it.strMiddlename AS business_owner_middlename,
   it.strSexID AS business_owner_gender,
   t.strTaxpayerID AS business_owner_entityno,
   t.strTaxpayerAddress as business_owner_address,  
   case strOrganizationTypeID 
      when 'S' then 'SING'
      when 'P' then 'PART'
      WHEN 'CORP' THEN 'CORP'
      WHEN 'COOP' THEN 'COOP'
      WHEN 'ASSO' THEN 'ASSO'
      when 'FOUN' then 'FOUND'
      else strOrganizationTypeID 
   end as business_orgtype
from tblBusiness b 
   inner join (
      select strbusinessid, max(intyear) as intyear 
      from tblAssessment 
      where strbusinessid = $P{objid} 
      group by strbusinessid 
   )g ON b.objid=g.strbusinessid 
   inner join tblAssessment a ON (g.strbusinessid=a.strbusinessid AND g.intyear=a.intyear) 
   inner join sysTblAssessmentType stat ON a.inttype=stat.objid 
   inner join tblTaxpayer t on t.strTaxpayerID = b.strTaxpayerID 
   inner join tblBPLedger bpl on bpl.strBusinessID = b.ObjID 
   left join tblIndividualTaxpayer it ON it.ObjID=t.strTaxpayerID
   left join etracs25_capture_entity e ON e.oldentityid = b.strTaxpayerID
where b.ObjID = $P{objid} 
   and a.inttype in (0,1,2,6,7) 


[getLobs]
SELECT DISTINCT 
   oldlobid, oldlobname, oldname, assessmenttype, lobid, name 
FROM ( 
   SELECT TOP 100 PERCENT 
      bl.objid as oldlobid,
      bl.strbusinessline as oldlobname, 
      bl.strbusinessline as oldname, 
      CASE stat.strtype 
         WHEN 'RENEWAL' THEN 'RENEW'
         WHEN 'REASSESSED (RENEW)' THEN 'RENEW'
         WHEN 'REASSESSED (NEW)' THEN 'NEW'
         WHEN 'ADDITIONAL' THEN 'NEW'
         ELSE stat.strtype 
      END AS assessmenttype,
      cl.lob_objid AS lobid, 
      cl.lob_name AS name, 
      a.dtassessmentdate as assessmentdate  
   FROM tblAssessment a
      INNER JOIN tblAssessmentBO bo ON bo.parentid = a.objid
      INNER JOIN tblBusinessLine bl ON bl.objid = bo.strBusinessLineID 
      INNER JOIN sysTblAssessmentType stat ON stat.objid = a.inttype 
      LEFT JOIN etracs25_capture_lob cl ON cl.oldlob_objid = bl.objid 
   WHERE a.objid = $P{objid} 
      AND a.inttype IN (0,1,4,6,7)
   ORDER BY a.dtassessmentdate, bl.strbusinessline 
)t1 


[getReceivables]
select 
   ('TRACSBR-'+ convert(varchar(50), NEWID())) as objid, 
   t1.businessid, t1.yearapplied, t1.[year], t1.assessmenttype, 
   case tfa.stracctType 
      when 'FEE' then 'REGFEE' 
      when 'TAX' then 'TAX' 
      else 'OTHERCHARGE' 
   end AS taxfeetype, 
   bl.objid AS oldlob_objid, bl.strbusinessline AS oldlob_name,
   clob.lob_objid, clob.lob_name, 
   t1.acctid AS oldaccount_objid, tfa.strAcctCode AS oldaccount_code, tfa.strDescription AS oldaccount_title, 
   ca.account_objid, ca.account_title, 
   t1.amount, t1.amtpaid, t1.balance 
from ( 
   select 
      b.strBusinessId as businessid, ta.objid as applicationid, ta.intyear AS yearapplied, 
      ta.intyear AS [year], tb.strBusinessLineID as lobid, tb.strAcctID as acctid, 
      sum(tb.curAmount) AS amount, sum(tb.curAmtPaid) AS amtpaid, 
      sum(tb.curAmount - tb.curAmtPaid) AS balance, 
      case stat.strtype 
         WHEN 'RENEWAL' THEN 'RENEW'
         WHEN 'REASSESSED (RENEW)' THEN 'RENEW'
         WHEN 'REASSESSED (NEW)' THEN 'NEW'
         WHEN 'ADDITIONAL' THEN 'NEW' 
         else stat.strtype 
      end AS assessmenttype 
   from tblassessment ta 
      inner join tblBPLedgerBill tb ON tb.strassessmentid = ta.objid  
      inner join tblBPLedger b ON b.objid = tb.parentid 
      inner join sysTblAssessmentType stat ON stat.objid = ta.inttype  
   where ta.objid = $P{objid} 
   group by b.strBusinessId, ta.objid, ta.intyear, tb.strBusinessLineID, tb.strAcctID, stat.strtype  
   having sum(tb.curAmount - tb.curAmtPaid) > 0 
)t1 
   inner join tblTaxFeeAccount tfa ON tfa.objid = t1.acctid 
   left join tblBusinessLine bl ON bl.objid = t1.lobid 
   left join etracs25_capture_lob clob ON clob.oldlob_objid = t1.lobid 
   left join etracs25_capture_account ca ON ca.oldaccount_objid = t1.acctid 
order by 
   (case tfa.stracctType when 'TAX' then 0 when 'FEE' then 1 else 2 end), tfa.strDescription 
