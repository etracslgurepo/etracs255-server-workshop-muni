[getList]
select * from ( 
   select 
      b.objid, b.tradename as businessname, b.tradename, b.businessaddress as address, 
      case when e.objid is null then b.taxpayername else e.entityname end as entityname, 
      case when e.objid is null then b.taxpayerid else e.objid end as ownerid, 
      case when e.objid is null then b.taxpayername else e.entityname end as ownername,
      case when e.objid is null then b.taxpayeraddress else e.entityaddress end as owneraddress,  
      ba.objid as applicationid, ba.iyear as activeyear, ba.txntype, xx.txndate 
   from ( 
      select xx.*, max(ba.txndate) as txndate 
      from ( 
         select ba.businessid, max(ba.iyear) as appyear  
         from ( 
            select objid from business 
            where tradename like $P{tradename} and taxpayername like $P{ownername} and 1=$P{searchlevel}  
            union 
            select b.objid from entity e 
               inner join business b on e.objid = b.taxpayerid 
            where e.entityname like $P{ownername} and 2=$P{searchlevel}  
         )xx 
            inner join bpapplication ba on xx.objid = ba.businessid 
         where ba.docstate in ('ACTIVE','PERMIT_PENDING','RENEWED','EXPIRED') 
         group by ba.businessid 
      )xx 
         inner join bpapplication ba on (xx.businessid=ba.businessid and ba.iyear=xx.appyear) 
      where ba.docstate in ('ACTIVE','PERMIT_PENDING','RENEWED','EXPIRED')  
      group by xx.businessid, xx.appyear 
   )xx 
      inner join bpapplication ba on (xx.businessid=ba.businessid and ba.iyear=xx.appyear and ba.txndate=xx.txndate) 
      inner join business b on xx.businessid = b.objid 
      left join entity e on b.taxpayerid = e.objid 
   where 
      b.objid not in (select oldbusinessid from etracs25_capture_business where oldbusinessid=b.objid)     
      and ba.docstate in ('ACTIVE','PERMIT_PENDING','RENEWED','EXPIRED')    
)b  
order by activeyear desc, tradename 


[findInfo]
select 
   ba.objid AS objid,
   b.objid AS oldbusinessid,
   b.tradename AS business_businessname,
   b.tradename AS business_tradename,
   b.businessaddress AS business_address_text,
   CASE ba.txntype
      WHEN 'RENEWAL' THEN 'RENEW'
      ELSE ba.txntype
   END as apptype,
   ba.objid AS applicationid, 
   ba.iyear AS activeyear,
   ba.txndate AS dtfiled,
   case when e.objid is null then b.taxpayername else e.entityname end as business_owner_name, 
   case when e.objid is null then b.taxpayerid else e.objid end as business_owner_oldid, 
   case when e.objid is null then b.taxpayeraddress else e.entityaddress end as business_owner_address_text,  
   e.entityno as business_owner_entityno,
   e.info, 
   ba.iyear as appyear,
   CASE b.organization 
      WHEN 'SINGLE PROPRIETORSHIP' THEN 'SING'
      WHEN 'CORPORATION' THEN 'CORP'
      WHEN 'COOPERATIVE' THEN 'COOP'
      WHEN 'ASSOCIATION' THEN 'ASSO'
      WHEN 'PROPRIETORSHIP' THEN 'PART'   
      WHEN 'FOUNDATION' THEN 'FOUND'   
      WHEN 'GOVERNMENT' THEN 'GOV'  
      WHEN 'RELIGIOUS' THEN 'REL'
      ELSE 'NA'   
   END AS business_orgtype, 
   (
      select min(iyear) from bpapplication 
      where businessid = b.objid and docstate not in ('DRAFT') 
   ) as yearstarted 
from ( 
   select objid from bpapplication 
   where businessid = $P{objid} and iyear = $P{activeyear}  
      and docstate in ('ACTIVE','PERMIT_PENDING','RENEWED','EXPIRED') 
)xx 
   inner join bpapplication ba on xx.objid = ba.objid 
   inner join business b on ba.businessid = b.objid 
   left join entity e on b.taxpayerid = e.objid 
order by ba.txndate desc 


[getLobs]
select 
   lob.objid as oldlobid, lob.name as oldname, 
   case 
      when ba.txntype = 'RENEW' then 'RENEW' 
      when ba.txntype = 'RENEWAL' then 'RENEW'
      when ba.txntype = 'ADDLOB' then 'NEW' 
      when ba.txntype = 'NEW' then 'NEW' 
      else null 
   end as assessmenttype, ba.txntype, 
   c.lob_objid as lobid, c.lob_name as name 
from bpapplication ba 
   inner join business b ON ba.businessid = b.objid 
   inner join bploblisting bl ON ba.objid = bl.applicationid 
   inner join lob ON bl.lobid = lob.objid 
   left join etracs25_capture_lob c ON lob.objid = c.oldlob_objid 
where ba.businessid = $P{businessid} 
   and ba.iyear = $P{activeyear} and bl.iyear = ba.iyear 
   and ba.txntype IN ('NEW','RENEW','RENEWAL','ADDLOB') 
   and ba.docstate IN ('ACTIVE','PERMIT_PENDING','RENEWED','EXPIRED') 


[getApplications]
SELECT 
   objid, txntype, appinfos, taxfees, receivables, credits 
FROM bpapplication  
where businessid = $P{businessid} and iyear = $P{activeyear}  
   and txntype IN ('NEW','RENEW','RENEWAL','ADDLOB') 
   and docstate IN ('ACTIVE','PERMIT_PENDING','RENEWED','EXPIRED') 


[findAccount]
SELECT * 
FROM etracs25_capture_account 
WHERE oldaccount_objid=$P{acctid}


[findLob]
SELECT *   
FROM etracs25_capture_lob  
WHERE oldlob_objid=$P{lobid} 


[getReceivables]
select 
   xx.assessmenttype, b.objid AS businessid,  
   CASE ia.systype  
     WHEN 'CHARGE' THEN 'OTHERCHARGE' 
     WHEN 'REG_FEE' THEN 'REGFEE' 
     WHEN 'OTHER_FEE' THEN 'OTHERCHARGE' 
     WHEN 'BUSINESS_TAX' THEN 'TAX' 
     WHEN 'TAX' THEN 'TAX' 
   END AS taxfeetype,
   xx.iyear as yearapplied, 
   lob.objid AS oldlob_objid, lob.name AS oldlob_name,
   clob.lob_objid, clob.lob_name, 
   ia.objid AS oldaccount_objid, ia.accttitle AS oldaccount_title, 
   ca.account_objid, ca.account_title,
   xx.amount, xx.amtpaid, 0.0 as surcharge, 0.0 as interest, 0.0 as discount, 
   xx.iyear as year, null as lastreceiptid, xx.lastqtrpaid 
from ( 
   select top 100 percent  
      xx.applicationid, xx.businessid, xx.iyear, max(xx.lastqtrpaid) as lastqtrpaid, 
      xx.lobid, xx.acctid, sum(xx.amount) as amount, sum(xx.amtpaid) as amtpaid, 
      xx.assessmenttype  
   from ( 
      select br.*, 
         case 
            when ba.txntype = 'RENEW' then 'RENEW' 
            when ba.txntype = 'RENEWAL' then 'RENEW'
            when ba.txntype = 'ADDLOB' then 'NEW' 
            when ba.txntype = 'NEW' then 'NEW' 
            else null 
         end as assessmenttype,
         case 
            when br.amtpaid >= br.amount then br.iqtr else null 
         end as lastqtrpaid 
      from bpapplication ba 
         inner join bpreceivable br on ba.objid = br.applicationid 
      where ba.businessid = $P{businessid} and ba.iyear = $P{activeyear} 
         and ba.txntype IN ('NEW','RENEW','RENEWAL','ADDLOB') 
         and ba.docstate IN ('ACTIVE','PERMIT_PENDING','RENEWED','EXPIRED') 
   )xx 
   group by xx.applicationid, xx.businessid, xx.iyear, xx.lobid, xx.acctid, xx.assessmenttype 
   order by xx.lobid, xx.acctid, xx.iyear  
)xx 
   inner join business b ON xx.businessid=b.objid 
   inner join incomeaccount ia ON xx.acctid=ia.objid 
   inner join lob lob ON xx.lobid=lob.objid 
   left join etracs25_capture_lob clob ON clob.oldlob_objid=lob.objid 
   left join etracs25_capture_account ca ON ia.objid=ca.oldaccount_objid 
