[getList]
select 
  b.objid, b.tradename as businessname, b.tradename, b.businessAddress as address, b.year as activeyear,
  p.name, p.objid AS ownerid, p.name AS ownername, p.primaryaddress AS owneraddress
from ( 
  select b.objid from business b 
    inner join payer p on b.taxpayerid = p.objid 
  where b.tradename like $P{tradename} and p.name like $P{ownername} and 1=$P{searchlevel} 
  union 
  select b.objid from payer p 
    inner join business b on p.objid = b.taxpayerid 
  where p.name like $P{ownername} and 2=$P{searchlevel} 
)xx 
  inner join business b on xx.objid = b.objid 
  inner join payer p on b.taxpayerid = p.objid 
where 
  b.objid not in (select oldbusinessid from etracs25_capture_business where oldbusinessid=b.objid) 
order by b.year desc, b.tradename 


[findInfo]
SELECT
  ba.objid AS objid,
  b.objid AS oldbusinessid,
  b.tradename AS business_businessname,
  b.tradename AS business_tradename,
  b.businessaddress AS business_address_text,
  CASE ba.type
    WHEN 'RENEWAL' THEN 'RENEW'
    WHEN 'LATERENEWAL' THEN 'RENEW'
    ELSE ba.type
  END as apptype,
  ba.objid AS applicationid, 
  aa.year AS activeyear,
  (
    select min(aa.year) from bpapplication ba 
      inner join abstractbpapplication aa on ba.objid=aa.objid 
    where ba.businessid=b.objid and aa.state not in ('DRAFT') 
  ) as yearstarted, 
  b.taxpayername as business_owner_name,
  b.taxpayerid as business_owner_oldid,
  e.taxpayerno as business_owner_entityno,
  b.taxpayeraddress as business_owner_address_text,
  aa.year as appyear,
  CASE b.organizationtype  
    WHEN 'SINGLE' THEN 'SING'
    WHEN 'CORP' THEN 'CORP'
    WHEN 'COOP' THEN 'COOP'
    WHEN 'ASSO' THEN 'ASSO'
    WHEN 'PART' THEN 'PART'   
    ELSE 'NA'   
  END AS business_orgtype 
FROM business b 
  INNER JOIN bpapplication ba ON b.applicationid = ba.objid 
  INNER JOIN abstractbpapplication aa on ba.objid = aa.objid 
  INNER JOIN payer e ON b.taxpayerid = e.objid 
WHERE b.objid = $P{objid} 


[getLobs]
select 
   lob.objid AS oldlobid, lob.name AS oldname, 
   case 
      when ba.type='ADDLOB' then 'NEW'  
      when ba.type='RENEWAL' then 'RENEW'
      when ba.type='LATERENEWAL' then 'RENEW'
      when ba.type='RETIRELOB' then 'RETIRE'
      else ba.type
   end AS assessmenttype, 
   cl.lob_objid AS lobid, cl.lob_name AS name 
from business b 
  inner join bpapplication ba on b.objid = ba.businessid 
  inner join abstractbpapplication aba on ba.objid = aba.objid 
  inner join bpapplication_lob bl on aba.objid = bl.bpapplication_objid 
  inner join lob on bl.lines_objid = lob.objid 
  left join etracs25_capture_lob cl ON lob.objid = cl.oldlob_objid 
where b.objid = $P{businessid} 
  and b.year = aba.year 


[getReceivables]
select * from ( 
   select xx.*, 
      case 
          when xx.taxfeetype='TAX' then 0 
          when xx.taxfeetype='REGFEE' and xx.oldlob_objid is not null then 1  
          when xx.taxfeetype='REGFEE' then 2 
          when xx.taxfeetype='OTHERCHARGE' then 3 
          else 4 
      end as sortorder 
   from ( 
      select 
         br.objid, 
         CASE 
            WHEN br.applicationtype='ADD LINE' THEN 'NEW' 
            WHEN br.applicationtype='RENEWAL' THEN 'RENEW'
            WHEN br.applicationtype='LATERENEWAL' THEN 'RENEW'
            ELSE br.applicationType 
         END AS assessmenttype, 
         b.objid AS businessid, 
         CASE btf.acctType 
            WHEN 'CHARGE' THEN 'OTHERCHARGE' 
            WHEN 'REG_FEE' THEN 'REGFEE' 
            WHEN 'OTHER_FEE' THEN 'OTHERCHARGE' 
            WHEN 'BUSINESS_TAX' THEN 'TAX' 
            WHEN 'TAX' THEN 'TAX' 
         END AS taxfeetype, 
         YEAR(btf.dtapplied) AS yearapplied,
         lob.objid AS oldlob_objid, lob.name AS oldlob_name,
         clob.lob_objid, clob.lob_name, 
         ia.objid AS oldaccount_objid, ia.title AS oldaccount_title, 
         ca.account_objid, ca.account_title,
         br.amount, br.amtpaid, btf.surcharge, btf.interest, btf.discount, 
         btf.year, br.lastreceiptid, br.lastqtrpaid  
      from business b 
         inner join bpreceivable br on b.objid = br.businessid 
         inner join bptaxfee btf on br.taxfeeid = btf.objid 
         inner join incomeaccount ia on btf.acctid = ia.objid 
         inner join abstractbpapplication aa on btf.parentid = aa.objid 
         left join lob on btf.lobid = lob.objid 
         left join etracs25_capture_lob clob ON clob.oldlob_objid = lob.objid 
         left join etracs25_capture_account ca ON ia.objid = ca.oldaccount_objid
      where b.objid = $P{businessid} and b.year = aa.year 
   )xx 
)xx 
order by xx.sortorder, xx.oldlob_name, xx.oldaccount_title 


[getAssessmentInfos]
select * from ( 
  select 
    bi.parentid as applicationid, ba.businessid, aa.year as activeyear, 
    case 
      when ba.type='ADDLOB' then 'NEW'  
      when ba.type='RENEWAL' then 'RENEW'
      when ba.type='LATERENEWAL' then 'RENEW'
      else ba.type
    end AS assessmenttype,
    case 
      when v.name='GROSS' then 1 
      when v.name='CAPITAL' then 1 
      when v.name='NO_OF_SQM' then 0 
      when v.name='NO_EMPLOYEES' then 0 
      else 2 
    end as groupindex, 
    case 
      when v.name='GROSS' then 'assessmentinfo' 
      when v.name='CAPITAL' then 'assessmentinfo' 
      when v.name='NO_OF_SQM' then 'appinfo' 
      when v.name='NO_EMPLOYEES' then 'appinfo' 
      else null 
    end as type, 
    case 
      when v.name='GROSS' then 'GROSS' 
      when v.name='CAPITAL' then 'CAPITAL' 
      when v.name='NO_OF_SQM' then 'AREA_SQM' 
      when v.name='NO_EMPLOYEES' then 'NUM_EMPLOYEE' 
      else null 
    end as attribute_objid, 
    case 
      when v.name='GROSS' then 'GROSS' 
      when v.name='CAPITAL' then 'CAPITAL' 
      when v.name='NO_OF_SQM' then 'AREA_SQM' 
      when v.name='NO_EMPLOYEES' then 'NUM_EMPLOYEE' 
      else null 
    end as attribute_name,
    lob.objid as oldlobid, lob.name as oldlobname, 
    bi.doublevalue as decimalvalue, 
    bi.integervalue as intvalue, 
    bi.booleanvalue  as boolvalue, 
    bi.stringvalue 
  from business b 
    inner join bpapplication ba on b.objid = ba.businessid 
    inner join abstractbpapplication aa on ba.objid = aa.objid 
    inner join bpapplicationinfo bi on aa.objid = bi.parentid 
    inner join abstractvariable v on bi.variableid = v.objid  
    inner join lob on bi.lobid = lob.objid 
  where b.objid = $P{businessid}  and b.year = aa.year 
    and v.name in ('GROSS','CAPITAL','NO_OF_SQM','NO_EMPLOYEES') 
)xx 
order by groupindex, oldlobname, attribute_name 


[getLandTaxPaymentInfo]
select 
   receiptNo as orno,
   receiptDate as ordate,
   sum( basic + basicInterest + basicPrevious + basicIntPrevious + basicPrior + basicIntPrior - basicDiscount + 
       sef + sefInterest + sefPrevious + sefIntPrevious + sefPrior + sefIntPrior - sefDiscount + advancePayment )  as oramount,
   CONCAT(MIN(fromQtr), 'Q,', fromYear, ' - ', MAX(toQtr), 'Q,', toYear) as period
from abstractrptcredit 
where ledgerid = $P{rptledgerid}
  and    (toYear = $P{year} OR toYear > $P{year} )
  AND (toYear > $P{year} OR (toYear = $P{year} AND toQtr <= $P{qtr}))  
group by refno, ordate, fromYear, toYear   

