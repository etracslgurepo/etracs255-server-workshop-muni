[getStructures]
SELECT 
  bs.*,
  s.code AS structure_code,
  s.name AS structure_name,
  m.code AS material_code,
  m.name AS material_name 
FROM bldgstructure bs 
  LEFT JOIN structure s ON bs.structure_objid = s.objid 
  LEFT JOIN material m ON bs.material_objid = m.objid 
WHERE bs.bldgrpuid = $P{objid}  
ORDER BY bs.floor, s.indexno


[getBldgUses]
SELECT 
  bu.*,
  bal.code AS  actualuse_code,
  bal.name AS actualuse_name
FROM bldguse bu
  LEFT JOIN bldgassesslevel bal ON bu.actualuse_objid = bal.objid 
WHERE bu.structuraltype_objid = $P{structuraltypeid}


[getFloors]
SELECT * FROM bldgfloor WHERE bldguseid = $P{bldguseid}  ORDER BY floorno 

[getAdditionalItems]
SELECT bfa.*,
  bi.code AS additionalitem_code,
  bi.name AS additionalitem_name,
  bi.expr AS additionalitem_expr,
  bi.unit AS additionalitem_unit,
  bi.type AS additionalitem_type 
FROM bldgflooradditional bfa 
  INNER JOIN bldgadditionalitem bi ON bfa.additionalitem_objid = bi.objid 
WHERE bfa.bldgfloorid = $P{bldgfloorid}


[getAdditionalItemParams]
SELECT a.*,
  p.name AS param_name,
  p.caption AS param_caption,
  p.paramtype AS param_paramtype,
  p.maxvalue AS param_maxvalue,
  p.minvalue AS param_minvalue
FROM bldgflooradditionalparam a
  INNER JOIN rptparameter p ON a.param_objid = p.objid 
WHERE a.bldgflooradditionalid = $P{bldgflooradditionalid}

[getAssessments]
SELECT 
  ba.*,
  bal.code AS  actualuse_code,
  bal.name AS actualuse_name,
  pc.code AS classification_code, 
  pc.name AS classification_name
FROM rpu_assessment ba
  INNER JOIN bldgassesslevel bal ON ba.actualuse_objid = bal.objid 
  INNER JOIN propertyclassification pc ON ba.classification_objid = pc.objid 
WHERE ba.rpuid = $P{objid}



[deleteAllParams]
DELETE FROM bldgflooradditionalparam WHERE bldgrpuid = $P{objid}

[deleteAllFloorAdditionals]
DELETE FROM bldgflooradditional WHERE bldgrpuid = $P{objid}

[deleteAllFloors]
DELETE FROM bldgfloor WHERE bldgrpuid = $P{objid}

[deleteAllUses]
DELETE FROM bldguse WHERE bldgrpuid = $P{objid}

[deleteAllStructures]
DELETE FROM bldgstructure WHERE bldgrpuid = $P{objid}


[deleteAllStructuralTypes]
DELETE FROM bldgrpu_structuraltype WHERE bldgrpuid = $P{objid}


[getStructuralTypes]
SELECT 
  stt.*,
  pc.code AS classification_code, 
  pc.name AS classification_name,
	bs.ry
FROM bldgrpu_structuraltype stt
  LEFT JOIN bldgtype bt ON stt.bldgtype_objid = bt.objid 
	LEFT JOIN bldgrysetting bs on bt.bldgrysettingid = bs.objid 
  LEFT JOIN bldgkindbucc bucc ON stt.bldgkindbucc_objid = bucc.objid 
  LEFT JOIN propertyclassification pc ON stt.classification_objid = pc.objid 
WHERE stt.bldgrpuid = $P{bldgrpuid}


[getBldgLands]
SELECT 
  bl.*, 
  f.owner_name AS landfaas_owner_name, 
  f.tdno AS landfaas_tdno, f.fullpin AS landfaas_fullpin
FROM bldgrpu_land bl 
  INNER JOIN faas f ON bl.landfaas_objid = f.objid 
WHERE bl.bldgrpuid = $P{objid}  


[getStandardStructures]
select * 
from structure 
where name in ('FLO', 'ROF', 'WAP')


[getBldgMasterList]
select 
  r.rpumasterid as objid,
  f.state, f.tdno, f.owner_name, f.fullpin,
  pc.code as classification_code,
  r.rputype, r.totalmv, r.totalav
from faas f 
  inner join rpu r on f.rpuid = r.objid 
  inner join realproperty rp on f.realpropertyid = rp.objid 
  inner join propertyclassification pc on r.classification_objid = pc.objid 
where f.state like $P{state}
and r.ry LIKE $P{ry}  
and r.rputype like $P{rputype}
and rp.pin like $P{pin}
and f.objid in (
  select objid from faas where tdno LIKE $P{searchtext}
  union 
  select objid from faas where name like $P{searchtext}
  union 
  select f.objid from faas f, realproperty rp where f.realpropertyid = rp.objid and rp.cadastrallotno like $P{searchtext}
)
