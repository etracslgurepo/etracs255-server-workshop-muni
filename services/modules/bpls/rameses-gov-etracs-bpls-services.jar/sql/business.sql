########################################################
# BusinessInfoService
########################################################
[getList]
SELECT DISTINCT b.*  
FROM 
(
	SELECT xb.objid,xb.state,xb.owner_objid,xb.owner_name,xb.businessname,xb.address_text,xb.activeyear,xb.bin,
    bp.permitno, bp.expirydate, bp.state AS permitstate, bp.version 
	FROM business xb
    LEFT JOIN business_permit bp ON bp.applicationid=xb.currentapplicationid
	WHERE xb.owner_name LIKE $P{searchtext} 
UNION 
    SELECT xb.objid,xb.state,xb.owner_objid,xb.owner_name,xb.businessname,xb.address_text,xb.activeyear,xb.bin,
    bp.permitno, bp.expirydate, bp.state AS permitstate, bp.version
    FROM business xb
    LEFT JOIN business_permit bp ON bp.applicationid=xb.currentapplicationid 
	WHERE xb.businessname LIKE $P{searchtext} 
UNION
    SELECT xb.objid,xb.state,xb.owner_objid,xb.owner_name,xb.businessname,xb.address_text,xb.activeyear,xb.bin,
    bp.permitno, bp.expirydate, bp.state AS permitstate, bp.version
    FROM business xb
    LEFT JOIN business_permit bp ON bp.applicationid=xb.currentapplicationid 
	WHERE xb.bin LIKE $P{searchtext} 
) b
WHERE NOT(b.objid IS NULL)
${filter}


[getListForVerification]
SELECT objid,state,owner_name,businessname,address_text,activeyear
FROM business 
WHERE businessname LIKE $P{businessname}
ORDER BY businessname

[getSearchList]
SELECT a.* FROM
(SELECT DISTINCT 
    xb.objid, xb.state, xb.owner_name AS ownername, 
    xb.owner_address_text AS owneraddress, xb.businessname, 
    xb.address_text AS address, xb.activeyear, xb.bin 
FROM ( 
    SELECT objid, MAX(activeyear) AS activeyear  
    FROM business b  
    WHERE b.owner_name LIKE $P{ownername} AND b.state NOT IN ('CANCELLED','RETIRED') 
    GROUP BY objid 
    
    UNION
    
    SELECT objid, MAX(activeyear) AS activeyear 
    FROM business b 
    WHERE b.businessname LIKE $P{tradename} AND b.state NOT IN ('CANCELLED','RETIRED') 
    GROUP BY objid 
    
    UNION 
    
    SELECT objid, MAX(activeyear) AS activeyear  
    FROM business b 
    WHERE b.bin LIKE $P{bin} AND b.state NOT IN ('CANCELLED','RETIRED') 
    GROUP BY objid 
)bt 
INNER JOIN business xb ON (bt.objid=xb.objid AND bt.activeyear=xb.activeyear)) a  


[updatePermit]
UPDATE business SET 
    state='ACTIVE', apptype=$P{apptype}, permit_objid=$P{permitid} 
WHERE 
    objid=$P{businessid}

[findByBIN]
SELECT objid, businessname, owner_name FROM business WHERE bin = $P{bin}

[findBusinessInfoByBIN]
SELECT 
    objid AS businessid, businessname, tradename, address_text,
    owner_objid,  owner_name, owner_address_text, bin 
FROM business 
WHERE bin = $P{bin}

[updateApplicationId]
UPDATE business SET currentapplicationid=$P{applicationid} WHERE objid=$P{businessid}

[updateOnRelease]
UPDATE business SET state=$P{state}, activeyear=$P{activeyear} WHERE objid=$P{objid}  

[updateForRetire]
UPDATE business SET state=$P{state}, apptype=$P{apptype} WHERE objid=$P{objid}  

[getListByOwner]
select 
    b.*, 
    (case when tmpc.capital is null then 0.0 else tmpc.capital end) as capital, 
    (case when tmpc.gross is null then 0.0 else tmpc.gross end) as latestgross, 
    (case when tmpc.amtdue is null then 0.0 else tmpc.amtdue end) as amtdue 
from ( 
    select 
        businessid, sum(capital) as capital, 
        sum(gross) as gross, sum(amtdue) as amtdue 
    from ( 
        select 
            ba.business_objid as businessid, 
            (
                select sum(bai.decimalvalue) from business_application xba 
                    inner join business_application_info bai on bai.applicationid=xba.objid  
                where xba.business_objid=tmpa.business_objid 
                    and xba.state in ('RELEASE','COMPLETED') 
                    and bai.attribute_objid='CAPITAL' 
            ) as capital, 
            (
                select sum(decimalvalue) from business_application_info 
                where applicationid=ba.objid and attribute_objid='GROSS' 
            ) as gross, 
            (
                select sum(br.amount-br.amtpaid) from business_application xba 
                    inner join business_receivable br on br.applicationid=xba.objid 
                where xba.business_objid=tmpa.business_objid 
                    and xba.state in ('RELEASE','COMPLETED') 
            ) as amtdue 
        from ( 
            select a.business_objid, max(a.appyear) as maxyear  
            from business b, business_application a 
            where b.owner_objid = $P{ownerid} 
                and a.business_objid = b.objid 
            group by a.business_objid 
        )tmpa 
            inner join business_application ba on ba.business_objid=tmpa.business_objid 
        where ba.appyear=tmpa.maxyear  
    )tmpb 
    group by businessid 
)tmpc, business b 
where b.objid=tmpc.businessid 
