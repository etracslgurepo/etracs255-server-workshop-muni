[getRootOrgs]
select * from sys_org where root=1

[findOrg]
select * from sys_org where objid = $P{objid} 

[findOrgClass]
select * from sys_orgclass where name = $P{name}  

[getCollectionTypeOrgs]
select * from collectiontype_org where org_objid = $P{orgid} 

[getCollectionTypes]
select ct.*, tmp1.orgid, tmp1.orgname, tmp1.orgtype 
from ( 
  select distinct 
    o.collectiontypeid, 
    o.org_objid as orgid, 
    o.org_name as orgname, 
    o.org_type as orgtype 
  from collectiontype_org o 
    inner join collectiontype ct on ct.objid = o.collectiontypeid 
  where o.org_objid = $P{orgid} 
)tmp1, collectiontype ct 
where ct.objid = tmp1.collectiontypeid 
order by ct.formno, ct.name 

[getCollectionTypeAccounts]
select distinct cta.*  
from collectiontype_org o 
  inner join collectiontype ct on ct.objid = o.collectiontypeid 
  inner join collectiontype_account cta on cta.collectiontypeid = ct.objid 
where o.org_objid = $P{orgid} 

[getCollectionGroups]
select g.*, 
  o.org_objid as orgid, 
  o.org_name as orgname, 
  o.org_type as orgtype   
from collectiongroup_org o 
  inner join collectiongroup g on g.objid = o.collectiongroupid 
where o.org_objid = $P{orgid} 

[getCollectionGroupItems]
select a.* 
from collectiongroup_org o 
  inner join collectiongroup g on g.objid = o.collectiongroupid 
  inner join collectiongroup_account a on a.collectiongroupid = g.objid 
where o.org_objid = $P{orgid}  

[getCollectionGroupOrgs]
select * from collectiongroup_org where org_objid = $P{orgid}  

[getAFs]
select af.* from ( 
  select distinct objid  
  from ( 
    select af.objid 
    from collectiontype_org o 
      inner join collectiontype ct on ct.objid = o.collectiontypeid 
      inner join af on af.objid = ct.formno 
    where o.org_objid = $P{orgid} 
    union 
    select af.objid 
    from af_control afc 
      inner join af on afc.afid = af.objid 
    where afc.org_objid = $P{orgid} 
  )t1  
)t2, af 
where af.objid = t2.objid 

[getSearchAFUnits]
select * from afunit where ${filter} 

[findFund] 
select * from fund where objid = $P{objid} 

[getFunds]
select fund.* from ( 
  select distinct objid 
  from ( 
    select f.objid  
    from collectiontype_org o 
      inner join collectiontype ct on ct.objid = o.collectiontypeid 
      inner join fund f on f.objid = ct.fund_objid 
    where o.org_objid = $P{orgid} 
    union 
    select f.objid 
    from collectiontype_org o 
      inner join collectiontype ct on ct.objid = o.collectiontypeid 
      inner join collectiontype_account ca on ca.collectiontypeid = ct.objid 
      inner join itemaccount ia on ia.objid = ca.account_objid 
      inner join fund f on f.objid = ia.fund_objid 
    where o.org_objid = $P{orgid} 
    union 
    select f.objid  
    from itemaccount ia 
      inner join fund f on ia.fund_objid=f.objid 
    where ia.org_objid = $P{orgid} 
  )t1 
)t2, fund 
where fund.objid = t2.objid 

[getFundGroups]
select * from fundgroup 

[getItemAccounts]
select a.* from ( 
  select distinct objid  
  from ( 
    select ia.objid  
    from itemaccount ia 
      inner join fund f on f.objid = ia.fund_objid 
    where ia.org_objid = $P{orgid}  
    union 
    select ia.objid  
    from collectiontype_org o 
      inner join collectiontype ct on ct.objid = o.collectiontypeid 
      inner join collectiontype_account ca on ca.collectiontypeid = ct.objid 
      inner join itemaccount ia on ia.objid = ca.account_objid 
      inner join fund f on f.objid = ia.fund_objid 
    where o.org_objid = $P{orgid} 
    union 
    select ia.objid  
    from collectiongroup_org o 
      inner join collectiongroup g on g.objid = o.collectiongroupid 
      inner join collectiongroup_account a on a.collectiongroupid = g.objid 
      inner join itemaccount ia on ia.objid = a.account_objid 
      inner join fund on fund.objid = ia.fund_objid 
    where o.org_objid = $P{orgid} 
  )t1  
)t2, itemaccount a 
where a.objid = t2.objid 

[getItemAccountTags]
select tg.* from ( 
  select distinct objid  
  from ( 
    select ia.objid  
    from itemaccount ia 
      inner join fund f on f.objid = ia.fund_objid 
    where ia.org_objid = $P{orgid}  
    union 
    select ia.objid  
    from collectiontype_org o 
      inner join collectiontype ct on ct.objid = o.collectiontypeid 
      inner join collectiontype_account ca on ca.collectiontypeid = ct.objid 
      inner join itemaccount ia on ia.objid = ca.account_objid 
      inner join fund f on f.objid = ia.fund_objid 
    where o.org_objid = $P{orgid} 
    union 
    select ia.objid  
    from collectiongroup_org o 
      inner join collectiongroup g on g.objid = o.collectiongroupid 
      inner join collectiongroup_account a on a.collectiongroupid = g.objid 
      inner join itemaccount ia on ia.objid = a.account_objid 
      inner join fund on fund.objid = ia.fund_objid 
    where o.org_objid = $P{orgid} 
  )t1  
)t2, itemaccount a, itemaccount_tag tg   
where a.objid = t2.objid 
  and a.objid = tg.acctid 

[getUserGroups]
select ug.* from ( 
  select distinct usergroup_objid 
  from ( 
    select usergroup_objid from sys_usergroup_member where usergroup_objid = 'TREASURY.LIQUIDATING_OFFICER'
    union 
    select usergroup_objid from sys_usergroup_member where org_objid = $P{orgid} 
  )t1 
)t2, sys_usergroup ug  
where ug.objid = t2.usergroup_objid 

[getUserGroupPermissions]
select ugp.* from ( 
  select distinct usergroup_objid 
  from ( 
    select usergroup_objid from sys_usergroup_member where usergroup_objid = 'TREASURY.LIQUIDATING_OFFICER'
    union 
    select usergroup_objid from sys_usergroup_member where org_objid = $P{orgid} 
  )t1 
)t2, sys_usergroup ug, sys_usergroup_permission ugp 
where ug.objid = t2.usergroup_objid 
  and ug.objid = ugp.usergroup_objid 

[getUsers]
select u.* from ( 
  select distinct t1.user_objid  
  from ( 
    select user_objid from sys_usergroup_member where usergroup_objid = 'TREASURY.LIQUIDATING_OFFICER'
    union 
    select user_objid from sys_usergroup_member where org_objid = $P{orgid} 
  )t1 
)t2, sys_user u   
where u.objid = t2.user_objid 
order by u.name 


[getSecurityGroups]
select sg.* from ( 
  select distinct securitygroup_objid  
  from ( 
    select securitygroup_objid from sys_usergroup_member where usergroup_objid = 'TREASURY.LIQUIDATING_OFFICER'
    union 
    select securitygroup_objid from sys_usergroup_member where org_objid = $P{orgid} 
  )t1 
)t2, sys_securitygroup sg    
where sg.objid = t2.securitygroup_objid 


[getUserGroupMembers]
select ugm.* from ( 
  select distinct objid   
  from ( 
    select objid from sys_usergroup_member where usergroup_objid = 'TREASURY.LIQUIDATING_OFFICER'
    union 
    select objid from sys_usergroup_member where org_objid = $P{orgid} 
  )t1 
)t2, sys_usergroup_member ugm      
where ugm.objid = t2.objid  


[getBanks]
select * from bank
