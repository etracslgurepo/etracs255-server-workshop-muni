[getUsers]
select distinct u.objid, u.name, u.jobtitle  
from sys_user u
inner join examiner_finding e on u.objid = e.inspectedby_objid
order by u.name 


[getExaminationFindings]
select x.* 
from (
  select 
    ef.dtinspected, ef.findings, ef.recommendations, ef.notedby, ef.notedbytitle,
    ef.inspectedby_name, ef.inspectedby_title, ef.objid, ef.inspectedby_objid,
    case when f.tdno is not null then f.tdno else concat('Prev# ', f.prevtdno) end as refno,
    o.name as lgu_name, o.orgclass as lgu_type
  from examiner_finding ef
    inner join faas f on ef.parent_objid = f.objid 
    inner join realproperty rp on f.realpropertyid = rp.objid
    inner join sys_org o on f.lguid = o.objid 
  where ef.dtinspected >= $P{startdate} and ef.dtinspected < $P{enddate}
    and ef.inspectedby_objid like $P{userid}
    AND f.lguid LIKE $P{lguid}
    ${brgyfilter}

  union all 

  select 
    ef.dtinspected, ef.findings, ef.recommendations, ef.notedby, ef.notedbytitle,
    ef.inspectedby_name, ef.inspectedby_title, ef.objid, ef.inspectedby_objid,
    concat('SD# ', s.txnno) as refno,
    o.name as lgu_name, o.orgclass as lgu_type
  from examiner_finding ef
    inner join subdivision s on ef.parent_objid = s.objid 
    inner join sys_org o on s.lguid = o.objid 
  where ef.dtinspected >= $P{startdate} and ef.dtinspected < $P{enddate}
    and ef.inspectedby_objid like $P{userid}
    AND s.lguid LIKE $P{lguid}

  union all 

  select 
    ef.dtinspected, ef.findings, ef.recommendations, ef.notedby, ef.notedbytitle,
    ef.inspectedby_name, ef.inspectedby_title, ef.objid, ef.inspectedby_objid,
    concat('CS# ',c.txnno) as refno,
    o.name as lgu_name, o.orgclass as lgu_type
  from examiner_finding ef
    inner join consolidation c on ef.parent_objid = c.objid 
    inner join sys_org o on c.lguid = o.objid 
  where ef.dtinspected >= $P{startdate} and ef.dtinspected < $P{enddate}
    and ef.inspectedby_objid like $P{userid}
    AND c.lguid LIKE $P{lguid}
) x
order by x.dtinspected, x.inspectedby_name, x.refno



