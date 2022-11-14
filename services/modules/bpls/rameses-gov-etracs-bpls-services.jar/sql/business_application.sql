[getList]
SELECT DISTINCT 
    ba.objid, ba.state AS appstate, ba.txndate, 
    ba.ownername AS business_owner_name, 
    ba.tradename AS business_businessname,
    ba.businessaddress AS business_address_text,
    b.bin AS business_bin, ba.appyear,
    ba.appno, ba.apptype, ba.dtfiled AS appdate, 
    tsk.assignee_objid, tsk.assignee_name, tsk.startdate, 
    tsk.state, tsk.enddate, tsk.objid AS taskid 
FROM (
    SELECT tsk.objid as taskid, tsk.refid as applicationid 
    FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid
        LEFT JOIN business_application_task tsk ON ba.objid=tsk.refid 
    WHERE b.owner_name LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
    UNION 
    SELECT tsk.objid as taskid, tsk.refid as applicationid
    FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid
        LEFT JOIN business_application_task tsk ON ba.objid=tsk.refid 
    WHERE b.businessname LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
    UNION
    SELECT tsk.objid as taskid, tsk.refid as applicationid
    FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid
        LEFT JOIN business_application_task tsk ON ba.objid=tsk.refid 
    WHERE b.bin LIKE $P{searchtext} ${filter}  
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
    UNION 
    SELECT tsk.objid as taskid, tsk.refid as applicationid 
    FROM business_application ba 
        LEFT JOIN business_application_task tsk ON ba.objid=tsk.refid 
    WHERE ba.appno LIKE $P{searchtext} ${filter}  
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
)bt INNER JOIN business_application ba on bt.applicationid=ba.objid  
    INNER JOIN business b on ba.business_objid=b.objid 
    LEFT JOIN business_application_task tsk ON bt.taskid=tsk.objid 
WHERE b.state NOT IN ('CANCELLED') 
ORDER BY ba.appyear DESC, ba.txndate ASC  


[getMyTaskList]
SELECT 
    ba.objid, 
    b.owner_name AS business_owner_name,
    b.businessname AS business_businessname,
    b.address_text AS business_address_text,
    b.bin AS business_bin, ba.appyear,
    ba.appno, ba.apptype, ba.dtfiled AS appdate,
    tsk.assignee_objid, tsk.assignee_name, 
    tsk.startdate, tsk.message 
FROM business_application_task tsk   
    INNER JOIN business_application ba ON tsk.refid=ba.objid 
    INNER JOIN business b ON ba.business_objid=b.objid 
WHERE tsk.assignee_objid = $P{assigneeid} 
    AND tsk.enddate IS NULL 
    AND ba.appyear=YEAR(NOW()) 
ORDER BY tsk.startdate 


[getClosedTaskList]
SELECT 
    ba.objid, ba.state AS appstate,
    ba.ownername AS business_owner_name,
    ba.tradename AS business_businessname,
    ba.businessaddress AS business_address_text,
    b.bin AS business_bin, ba.appyear,
    ba.appno, ba.apptype, ba.dtfiled AS appdate
FROM (
    SELECT ba.objid FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid
    WHERE b.owner_name LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
    UNION 
    SELECT ba.objid FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid 
    WHERE b.businessname LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
    UNION 
    SELECT ba.objid FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid 
    WHERE b.bin LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
    UNION 
    SELECT ba.objid FROM business_application ba 
        INNER JOIN business b ON ba.business_objid=b.objid 
    WHERE ba.appno LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
)bt INNER JOIN business_application ba ON bt.objid=ba.objid 
    INNER JOIN business b ON ba.business_objid=b.objid 


[getCompletedList]
SELECT 
    ba.objid, ba.state AS appstate,
    ba.ownername AS business_owner_name,
    ba.tradename AS business_businessname,
    ba.businessaddress AS business_address_text,
    b.bin AS business_bin, ba.appyear,
    ba.appno, ba.apptype, ba.dtfiled AS appdate
FROM (
    SELECT ba.objid FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid
    WHERE b.owner_name LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
UNION 
    SELECT ba.objid FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid 
    WHERE b.businessname LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
UNION
    SELECT ba.objid FROM business b 
        INNER JOIN business_application ba ON b.objid=ba.business_objid 
    WHERE b.bin LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
UNION
    SELECT ba.objid FROM business_application ba 
    WHERE ba.appno LIKE $P{searchtext} ${filter} 
        AND ba.apptype IN ( 'NEW','RENEW','RETIRE','ADDITIONAL','RETIRELOB' ) 
)bt INNER JOIN business_application ba ON bt.objid=ba.objid 
    INNER JOIN business b ON ba.business_objid=b.objid 


[findIdByAppno]
SELECT objid FROM business_application WHERE appno=$P{appno}

[findInfoByBIN]
SELECT 
    ba.*, b.tradename, b.owner_objid, b.owner_name, b.bin, 
    b.address_objid, b.address_text, b.businessname  
FROM business b 
    INNER JOIN business_application ba ON b.currentapplicationid=ba.objid 
WHERE b.bin=$P{bin} 

[findInfoByAppno]
SELECT 
    ba.*, b.tradename, b.owner_objid, b.owner_name, b.bin, 
    b.address_objid, b.address_text, b.businessname  
FROM business_application ba 
INNER JOIN business b ON ba.business_objid=b.objid
WHERE ba.appno=$P{appno}

[findInfoByAppid]
SELECT 
    ba.*, b.tradename, b.owner_objid, b.owner_name, b.bin, 
    b.address_objid, b.address_text, b.businessname 
FROM business_application ba 
INNER JOIN business b ON ba.business_objid=b.objid
WHERE ba.objid=$P{applicationid} 

[getInfosByBusinessIdAndYear]
SELECT * FROM business_application 
WHERE business_objid=$P{businessid} AND appyear=$P{appyear} AND apptype=$P{apptype}

[getListByBusiness]
SELECT * FROM business_application WHERE business_objid=$P{businessid} ORDER BY dtfiled DESC

[updatePermit]
UPDATE business_application SET 
    state='COMPLETED', 
    dtreleased=$P{dtreleased}, 
    permit_objid=$P{permitid} 
WHERE 
    objid=$P{applicationid}

[getOpenApplications]
SELECT * FROM business_application 
WHERE business_objid=$P{businessid} 
AND state NOT IN ('COMPLETED', 'CANCELLED') ${filter}

[updateOpenApplicationsOwner]
UPDATE business_application SET ownername=$P{ownername} 
WHERE business_objid=$P{businessid} 
AND  NOT(state IN ('COMPLETED', 'CANCELLED'))

[updateOpenApplicationsBusinessName]
UPDATE business_application SET tradename=$P{tradename} 
WHERE business_objid=$P{businessid} 
AND NOT( state IN ('COMPLETED','CANCELLED'))

[updateOpenApplicationsBusinessAddress]
UPDATE business_application SET businessaddress=$P{businessaddress} 
WHERE business_objid=$P{businessid} 
AND NOT(state IN ('COMPLETED', 'CANCELLED'))


[findBusinessInfoByAppno]
SELECT a.objid AS applicationid,  
b.objid AS businessid, b.address_text,
b.businessname, b.tradename, b.owner_objid, b.owner_name, b.owner_address_text, b.bin  
FROM business_application a 
INNER JOIN business b ON a.business_objid=b.objid
WHERE a.appno=$P{appno}



[updateExpirydate]
UPDATE business_application SET expirydate=$P{expirydate} WHERE objid=$P{applicationid}

[updateState]
UPDATE business_application SET state=$P{state} WHERE objid=$P{applicationid}

[findMobileNo]
SELECT b.mobileno FROM business_application ba
INNER JOIN business b ON ba.business_objid=b.objid 
WHERE ba.objid = $P{objid}

[findNextBillDate]
SELECT objid, nextbilldate FROM business_application WHERE objid=$P{applicationid}  

[updateNextBillDate]
UPDATE business_application SET 
    nextbilldate = $P{nextbilldate} 
WHERE objid=$P{applicationid}  


[getAppLobs]
select * from business_application_lob where applicationid=$P{applicationid} 

[getAppInfos]
select * from business_application_info where applicationid=$P{applicationid} and type='appinfo'

[getAssessmentInfos]
select * from business_application_info where applicationid=$P{applicationid} and type='assessmentinfo'

[findLatestApplication]
select a.* 
from ( 
    select business_objid, max(appyear) as appyear, max(txndate) as txndate 
    from business_application 
    where business_objid = $P{businessid} 
    group by business_objid 
)xx 
    inner join business_application a on a.business_objid=xx.business_objid 
where a.appyear = xx.appyear and a.txndate = xx.txndate 

[getDelinquentApplications]
select 
    businessid, iyear, sum(amount) as amount, sum(amtpaid) as amtpaid  
from business_receivable 
where businessid=$P{businessid} 
    and iyear < $P{appyear}  
    and (amount-amtpaid) > 0.0 
group by businessid, iyear 
order by iyear 

[findBusinessAddress]
select addr.* 
from business_application ba 
    inner join business b on b.objid = ba.business_objid 
    inner join business_address addr on addr.objid = b.address_objid 
where ba.objid = $P{applicationid}
