/* CHANGE RPUT TYPE  */
INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`, `checkbalance`, `reconcileledger`, `allowannotated`) VALUES ('CK', 'Change Kind', '0', '1', '1', 'DP', '1', '1', '1', '1', '', '0', '0', '0')
;


/* EXAMINATION FINDING */
alter table examiner_finding add txnno varchar(25)
;

create table zzztmp_examiner_finding 
select * from examiner_finding
;

alter table zzztmp_examiner_finding  add oid int auto_increment primary key
;

create index ix_objid on zzztmp_examiner_finding (objid)
;

update examiner_finding f, zzztmp_examiner_finding z set 
	f.txnno = concat('S', lpad(z.oid, 6, '0'))
where f.objid = z.objid 
;

drop table zzztmp_examiner_finding
;

create unique index ix_txnno on examiner_finding ( txnno) 
;



/* OCULAR INSPECTION */
drop view if exists vw_ocular_inspection 
;

create view vw_ocular_inspection 
as 
select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join faas f on ef.parent_objid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  


union all 



select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join subdivision_motherland sm on ef.parent_objid = sm.subdivisionid  
  join faas f on sm.landfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join consolidation c on ef.parent_objid = c.objid  
  join faas f on c.newfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  '' AS owner_name,
  '' AS owner_address,
  '' AS titleno,
  '' AS fullpin,
  '' AS blockno,
  '' AS cadastrallotno,
  0 AS totalareaha,
  0 AS totalareasqm,
  0 AS totalmv,
  0 AS totalav,
  o.objid AS lguid,
  o.name AS lgu_name,
  b.objid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  '' AS purok,
  '' AS street 
from  examiner_finding ef 
  join batchgr bgr on ef.parent_objid = bgr.objid  
  join sys_org b on bgr.barangay_objid = b.objid  
  join sys_org o on bgr.lgu_objid = o.objid 

union all 

select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join cancelledfaas cf on ef.parent_objid = cf.objid  
join faas f on cf.faasid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  
;
/* SUBDIVISION VIEWS */
drop view if exists vw_report_subdividedland
;

create view vw_report_subdividedland
as 
select 
	sl.objid,
	s.objid as subdivisionid,
	s.txnno, 
	b.name as barangay,
	o.name as lguname,
	pc.code as classcode,
	f.tdno,
	f.owner_name,
	f.administrator_name,
	f.titleno,
	f.lguid,
	f.titledate,
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.rputype,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	f.txntype_objid,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name
from subdividedland sl 
	inner join subdivision s on sl.subdivisionid = s.objid 
	inner join faas f on sl.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
;

drop view if exists vw_report_motherland_summary
;

create view vw_report_motherland_summary
as 
select 
	m.subdivisionid,
	f.tdno,
	f.owner_name,
	b.name as barangay,
	o.name as lguname,
	f.titleno,
	f.titledate,
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.administrator_name,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from subdivision_motherland m
	inner join faas f on m.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
;



/* CONSOLIDATION VIEWS */
drop view if exists vw_report_consolidation
;

create view vw_report_consolidation
as 
select 
	c.objid,
	c.txnno,
	b.name as barangay,
	o.name as lguname,
	f.tdno,
	f.owner_name,
	f.administrator_name,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.txntype_objid,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from consolidation c
	inner join faas f on c.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 	
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
;

drop view if exists vw_report_consolidated_land
;

create view vw_report_consolidated_land
as 
select 
	cl.consolidationid,
	f.tdno,
	f.owner_name,
	b.name as barangay,
	o.name as lguname,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.administrator_name,
	f.txntype_objid,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from consolidatedland cl 
	inner join faas f on cl.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
;



/* SYNC2: DOWNLOADED */
drop table if exists rpt_syncdata_downloaded
; 

CREATE TABLE `rpt_syncdata_downloaded` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

insert into rpt_syncdata_downloaded(
	objid, 
	etag,
	error
)
select 
	objid,
	etag,
	error
from rpt_syncdata_fordownload
where state = 'DOWNLOADED'
;

insert into rpt_syncdata_downloaded(
	objid, 
	etag,
	error
)
select 
	filekey,
	'-',
	1
from rpt_syncdata_error
;

delete from rpt_syncdata_fordownload 
where state = 'DOWNLOADED'
;



/* REPORT VIEW: OCULAR INSPECTION */
DROP VIEW IF EXISTS `vw_ocular_inspection` 
;

CREATE VIEW `vw_ocular_inspection` 
AS 
select 
  `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
join `faas` `f` on `ef`.`parent_objid` = `f`.`objid`  
join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
left join `subdivision_motherland` `sm` on `ef`.`parent_objid` = `sm`.`subdivisionid`  
left join `faas` `f` on `sm`.`landfaasid` = `f`.`objid`  
left join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
left join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
left join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
left join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
join `consolidation` `c` on `ef`.`parent_objid` = `c`.`objid`  
left join `faas` `f` on `c`.`newfaasid` = `f`.`objid`  
left join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
left join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
left join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
left join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,'
  ' AS `owner_name`,'
  ' AS `owner_address`,'
  ' AS `titleno`,'
  ' AS `fullpin`,'
  ' AS `blockno`,'
  ' AS `cadastrallotno`
  ,0 AS `totalareaha`
  ,0 AS `totalareasqm`
  ,0 AS `totalmv`
  ,0 AS `totalav`,
  `o`.`objid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `b`.`objid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,'
  ' AS `purok`,'
  ' AS `street` 
from  `examiner_finding` `ef` 
join `batchgr` `bgr` on `ef`.`parent_objid` = `bgr`.`objid`  
join `sys_org` `b` on `bgr`.`barangay_objid` = `b`.`objid`  
join `sys_org` `o` on `bgr`.`lgu_objid` = `o`.`objid` 
;


drop view if exists vw_report_landrpu
;

create view vw_report_landrpu as 
select	
	f.objid,
	f.state,
	o.name as lgu, 
	b.name as barangay,
	f.tdno,
	f.fullpin as pin,
	f.titleno,
	f.dtapproved,
	f.canceldate,
	f.cancelledbytdnos,
	f.prevtdno,
	f.effectivityyear,
	f.effectivityqtr,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address, 
	f.owner_name,
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	pc.name as classification,
	lspc.name as specificclass,
	sub.code as subclasscode, 
	sub.name as subclass,
	rp.blockno,
	rp.cadastrallotno,
	rp.ry,
	rp.section,
	rp.parcel,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	case 
		when r.useswornamount = 1 then r.swornamount 
		else r.totalbmv 
	end as totalbmv,
	r.totalmv,
	r.totalav
from faas f 
inner join rpu r on f.rpuid  = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rp.barangayid = b.objid 
inner join sys_org o on f.lguid = o.objid 
inner join propertyclassification pc on r.classification_objid = pc.objid 
inner join landdetail ld on r.objid = ld.landrpuid 
inner join lcuvspecificclass spc on ld.specificclass_objid = spc.objid 
inner join landspecificclass lspc on spc.landspecificclass_objid = lspc.objid 
inner join lcuvsubclass sub on ld.subclass_objid = sub.objid 
inner join entity e on f.taxpayer_objid = e.objid 
;

/* ABSTRACT RPT COLLECTION: change remittance to controldate */

DROP VIEW IF EXISTS `vw_landtax_abstract_of_collection_detail`
;

CREATE VIEW `vw_landtax_abstract_of_collection_detail` AS 
select 
`liq`.`objid` AS `liquidationid`,
`liq`.`controldate` AS `liquidationdate`,
`rem`.`objid` AS `remittanceid`,
`rem`.`controldate` AS `remittancedate`,
`cr`.`objid` AS `receiptid`,
`cr`.`receiptdate` AS `ordate`,
`cr`.`receiptno` AS `orno`,
`cr`.`collector_objid` AS `collectorid`,
`rl`.`objid` AS `rptledgerid`,
`rl`.`fullpin` AS `fullpin`,
`rl`.`titleno` AS `titleno`,
`rl`.`cadastrallotno` AS `cadastrallotno`,
`rl`.`rputype` AS `rputype`,
`rl`.`totalmv` AS `totalmv`,
`b`.`name` AS `barangay`,
`rp`.`fromqtr` AS `fromqtr`,
`rp`.`toqtr` AS `toqtr`,
`rpi`.`year` AS `year`,
`rpi`.`qtr` AS `qtr`,
`rpi`.`revtype` AS `revtype`,
(case when isnull(`cv`.`objid`) then `rl`.`owner_name` else '*** voided ***' end) AS `taxpayername`,
(case when isnull(`cv`.`objid`) then `rl`.`tdno` else '' end) AS `tdno`,
(case when isnull(`m`.`name`) then `c`.`name` else `m`.`name` end) AS `municityname`,
(case when isnull(`cv`.`objid`) then `rl`.`classcode` else '' end) AS `classification`,
(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessvalue`,
(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessedvalue`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basiccurrentyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicpreviousyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic')) then `rpi`.`discount` else 0.0 end) AS `basicdiscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltycurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltyprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `sefcurrentyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `sefpreviousyear`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef')) then `rpi`.`discount` else 0.0 end) AS `sefdiscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltycurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltyprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basicidlecurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicidleprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle')) then `rpi`.`amount` else 0.0 end) AS `basicidlediscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicidlecurrentpenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicidlepreviouspenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `shcurrent`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `shprevious`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh')) then `rpi`.`discount` else 0.0 end) AS `shdiscount`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `shcurrentpenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `shpreviouspenalty`,
(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'firecode')) then `rpi`.`amount` else 0.0 end) AS `firecode`,
(case when isnull(`cv`.`objid`) then ((`rpi`.`amount` - `rpi`.`discount`) + `rpi`.`interest`) else 0.0 end) AS `total`,
(case when isnull(`cv`.`objid`) then `rpi`.`partialled` else 0 end) AS `partialled` 
from  `collectionvoucher` `liq` 
join `remittance` `rem` on `rem`.`collectionvoucherid` = `liq`.`objid`  
join `cashreceipt` `cr` on `rem`.`objid` = `cr`.`remittanceid`  left 
join `cashreceipt_void` `cv` on `cr`.`objid` = `cv`.`receiptid`  
join `rptpayment` `rp` on `rp`.`receiptid` = `cr`.`objid`  
join `rptpayment_item` `rpi` on `rpi`.`parentid` = `rp`.`objid`  
join `rptledger` `rl` on `rl`.`objid` = `rp`.`refid`  
join `barangay` `b` on `b`.`objid` = `rl`.`barangayid`  left 
join `district` `d` on `b`.`parentid` = `d`.`objid`  left 
join `city` `c` on `d`.`parentid` = `c`.`objid`  left 
join `municipality` `m` on `b`.`parentid` = `m`.`objid` 
;


/* ADD TAXABLE */
DROP  VIEW IF EXISTS  `vw_report_subdividedland`
;

CREATE  VIEW `vw_report_subdividedland` AS 
select 
  `sl`.`objid` AS `objid`,
  `s`.`objid` AS `subdivisionid`,
  `s`.`txnno` AS `txnno`,
  `b`.`name` AS `barangay`,
  `o`.`name` AS `lguname`,
  `pc`.`code` AS `classcode`,
  `f`.`tdno` AS `tdno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`administrator_name` AS `administrator_name`,
  `f`.`titleno` AS `titleno`,
  `f`.`lguid` AS `lguid`,
  `f`.`titledate` AS `titledate`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`surveyno` AS `surveyno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`rputype` AS `rputype`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `r`.`taxable` as `taxable`,
  `f`.`txntype_objid` AS `txntype_objid`,
  `ft`.`displaycode` AS `txntype_code`,
  `e`.`name` AS `taxpayer_name` 
  from  `subdividedland` `sl` 
  join `subdivision` `s` on `sl`.`subdivisionid` = `s`.`objid` 
  join `faas` `f` on `sl`.`newfaasid` = `f`.`objid` 
  join `rpu` `r` on `f`.`rpuid` = `r`.`objid` 
  join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid` 
  join `barangay` `b` on `rp`.`barangayid` = `b`.`objid` 
  join `sys_org` `o` on `f`.`lguid` = `o`.`objid` 
  join `faas_txntype` `ft` on `f`.`txntype_objid` = `ft`.`objid` 
  join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid` 
  join `propertyclassification` `pc` on `r`.`classification_objid` = `pc`.`objid`
;

DROP  VIEW IF EXISTS  `vw_report_consolidated_land`
;

CREATE VIEW `vw_report_consolidated_land` AS 
select 
  `cl`.`consolidationid` AS `consolidationid`,
  `f`.`tdno` AS `tdno`,
  `f`.`owner_name` AS `owner_name`,
  `b`.`name` AS `barangay`,
  `o`.`name` AS `lguname`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`surveyno` AS `surveyno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`rputype` AS `rputype`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `r`.`taxable` as `taxable`,
  `f`.`administrator_name` AS `administrator_name`,
  `f`.`txntype_objid` AS `txntype_objid`,
  `pc`.`code` AS `classcode`,
  `ft`.`displaycode` AS `txntype_code`,
  `e`.`name` AS `taxpayer_name` 
from  `consolidatedland` `cl` 
join `faas` `f` on `cl`.`landfaasid` = `f`.`objid` 
join `rpu` `r` on `f`.`rpuid` = `r`.`objid` 
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid` 
join `barangay` `b` on `rp`.`barangayid` = `b`.`objid` 
join `sys_org` `o` on `f`.`lguid` = `o`.`objid` 
join `propertyclassification` `pc` on `r`.`classification_objid` = `pc`.`objid` 
join `faas_txntype` `ft` on `f`.`txntype_objid` = `ft`.`objid` 
join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid`
;


/* ENCODER_APPROVER */
INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('RPT.ENCODER_APPROVER', 'RPT ENCODER_APPROVER', 'RPT', NULL, NULL, 'ENCODER_APPROVER')
;

/* TOPN IMPROVEMENT */
create index ix_year on report_rptdelinquency_item(year)
;


DROP VIEW IF EXISTS `vw_landtax_report_rptdelinquency_detail` 
;

/* ADD PARENTID */
CREATE VIEW `vw_landtax_report_rptdelinquency_detail` AS 
select 
  r.objid as parentid,
  `ri`.`objid` AS `objid`,
  `ri`.`rptledgerid` AS `rptledgerid`,
  `ri`.`barangayid` AS `barangayid`,
  `ri`.`year` AS `year`,
  `ri`.`qtr` AS `qtr`,
  `r`.`dtgenerated` AS `dtgenerated`,
  `r`.`dtcomputed` AS `dtcomputed`,
  `r`.`generatedby_name` AS `generatedby_name`,
  `r`.`generatedby_title` AS `generatedby_title`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,
  (case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,
  (case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,
  (case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,
  (case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,
  (case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,
  (case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,
  (case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,
  (case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,
  (case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,
  (case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,
  (case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,
  (case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,
  (case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,
  ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` 
from (`report_rptdelinquency_item` `ri` 
  join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;




DROP TABLE IF EXISTS report_rptdelinquency_total_bytaxpayer
;

CREATE TABLE report_rptdelinquency_total_bytaxpayer (
  taxpayer_objid varchar(50) DEFAULT NULL,
  parentid varchar(50) NOT NULL,
  amount decimal(16,2) DEFAULT NULL,
	ledgercount int
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parentid on report_rptdelinquency_total_bytaxpayer(parentid)
;
create index ix_taxpayer_objid on report_rptdelinquency_total_bytaxpayer(taxpayer_objid)
;
create index ix_amount on report_rptdelinquency_total_bytaxpayer(amount)
;

insert into report_rptdelinquency_total_bytaxpayer (
	taxpayer_objid,
	parentid,
	amount,
	ledgercount
)
SELECT 
	rl.taxpayer_objid,
	rr.parentid,
	SUM(rr.basic - rr.basicdisc + rr.basicint  + rr.sef - rr.sefdisc + rr.sefint ) AS amount,
	count( distinct rr.rptledgerid) as ledgercount
FROM vw_landtax_report_rptdelinquency_detail rr 
	inner join rptledger rl on rr.rptledgerid = rl.objid 
WHERE rl.taxable = 1
AND NOT EXISTS(select * from faas_restriction where ledger_objid = rr.rptledgerid and state='ACTIVE')
GROUP BY rl.taxpayer_objid, rr.parentid
;




/* TOPN PAYER IMPROVEMENT */

DROP TABLE IF EXISTS `report_rptcollection_annual_bypayer`
;

CREATE TABLE `report_rptcollection_annual_bypayer` (
  `rputype` varchar(50) not null,
  `year` int(11) NOT NULL,
  `payer_name` varchar(2000) NOT NULL,
  `amount` decimal(50,2) DEFAULT NULL,
  dtgenerated datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_rputype on report_rptcollection_annual_bypayer(rputype)
;
create index ix_year on report_rptcollection_annual_bypayer(year)
;
create index ix_payer on report_rptcollection_annual_bypayer(payer_name(150))
;


delete from report_rptcollection_annual_bypayer
;

insert into report_rptcollection_annual_bypayer(
  rputype,
	year, 
	payer_name,
	amount,
  dtgenerated
)
select 
  rl.rputype,
		year(c.receiptdate), 
		c.paidby as payer_name, 
		sum(
			basic + basicint - basicdisc + 
			sef + sefint - sefdisc + firecode +
			basicidle + basicidleint - basicidledisc +
			sh + shint - shdisc
		) as amount,
    now()
from collectionvoucher cv
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt c on rem.objid = c.remittanceid 
	left join cashreceipt_void crv on c.objid = crv.receiptid
	inner join rptpayment rp on c.objid = rp.receiptid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
-- where cv.controldate < concat(YEAR(now()), '-01-01')
group by rl.rputype, c.receiptdate,  c.paidby 
;



/* PORTION OF */
alter table realproperty add portionof varchar(255)
;

/* MISCRPU */
alter table miscrpuitem add appraisalstartdate date
;
alter table miscrpuitem add taxable int
;
update miscrpuitem set taxable = 1 where taxable is null 
;
/* ADMIN PERMISSIONS */
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-189d', 'RPT.ADMIN', 'faas', 'view_issued_clearances', 'View issued clearances');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-334b', 'RPT.ADMIN', 'faas', 'update_ledger_mapping', 'Update FAAS and Ledger mapping');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-4a01', 'RPT.ADMIN', 'faas', 'resend_to_province', 'Resend to province');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-5fbf', 'RPT.ADMIN', 'faas', 'modify_superseded_info', 'Modify superseded information');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-611c', 'RPT.ADMIN', 'faas', 'view_payments', 'Modify payments');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-6243', 'RPT.ADMIN', 'faas', 'modify_information', 'Modify information');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-638a', 'RPT.ADMIN', 'faas', 'modify_owner', 'Modify owner');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-6473', 'RPT.ADMIN', 'faas', 'modify_property_info', 'Modify property information');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-653e', 'RPT.ADMIN', 'faas', 'modify_signatories', 'Modify signatories');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-65eb', 'RPT.ADMIN', 'faas', 'modify_sketch', 'Modify sketch');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-6682', 'RPT.ADMIN', 'faas', 'modify_appraisal', 'Modify appraisal');
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS38a4ea88:1830c0b3fec:-7a00', 'RPT.ADMIN', 'faas', 'view_payments', 'View payments');

/* ASSESSMENT NOTICE NATB */
alter table assessmentnotice add info varchar(1000)
;
alter table assessmentnoticeitem add info varchar(1000)
;

DROP VIEW IF EXISTS `vw_assessment_notice_item`;

CREATE VIEW `vw_assessment_notice_item` AS 
  select 
    `ni`.`objid` AS `objid`,
    `ni`.`assessmentnoticeid` AS `assessmentnoticeid`,
    `ni`.`info`,
    `f`.`objid` AS `faasid`,
    `f`.`effectivityyear` AS `effectivityyear`,
    `f`.`effectivityqtr` AS `effectivityqtr`,
    `f`.`tdno` AS `tdno`,
    `f`.`taxpayer_objid` AS `taxpayer_objid`,
    `e`.`name` AS `taxpayer_name`,
    `e`.`address_text` AS `taxpayer_address`,
    `f`.`owner_name` AS `owner_name`,
    `f`.`owner_address` AS `owner_address`,
    `f`.`administrator_name` AS `administrator_name`,
    `f`.`administrator_address` AS `administrator_address`,
    `f`.`rpuid` AS `rpuid`,
    `f`.`lguid` AS `lguid`,
    `f`.`txntype_objid` AS `txntype_objid`,
    `ft`.`displaycode` AS `txntype_code`,
    `rpu`.`rputype` AS `rputype`,
    `rpu`.`ry` AS `ry`,
    `rpu`.`fullpin` AS `fullpin`,
    `rpu`.`taxable` AS `taxable`,
    `rpu`.`totalareaha` AS `totalareaha`,
    `rpu`.`totalareasqm` AS `totalareasqm`,
    `rpu`.`totalbmv` AS `totalbmv`,
    `rpu`.`totalmv` AS `totalmv`,
    `rpu`.`totalav` AS `totalav`,
    `rp`.`section` AS `section`,
    `rp`.`parcel` AS `parcel`,
    `rp`.`surveyno` AS `surveyno`,
    `rp`.`cadastrallotno` AS `cadastrallotno`,
    `rp`.`blockno` AS `blockno`,
    `rp`.`claimno` AS `claimno`,
    `rp`.`street` AS `street`,
    `o`.`name` AS `lguname`,
    `b`.`name` AS `barangay`,
    `pc`.`code` AS `classcode`,
    `pc`.`name` AS `classification` 
from  `assessmentnoticeitem` `ni` join `faas` `f` on `ni`.`faasid` = `f`.`objid`  
left join `txnsignatory` `ts` on `ts`.`refid` = `f`.`objid`  and  `ts`.`type` = 'APPROVER'  
join `rpu` on `f`.`rpuid` = `rpu`.`objid`  
join `propertyclassification` `pc` on `rpu`.`classification_objid` = `pc`.`objid`  
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
join `barangay` `b` on `rp`.`barangayid` = `b`.`objid`  
join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  
join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid`  
join `faas_txntype` `ft` on `f`.`txntype_objid` = `ft`.`objid` 
;

/* ORC */
DROP VIEW IF EXISTS `vw_report_orc`
;

CREATE VIEW `vw_report_orc` AS 
select 
  `f`.`objid` AS `objid`,
  `f`.txntype_objid,
  `f`.`state` AS `state`,
  `e`.`objid` AS `taxpayerid`,
  `e`.`name` AS `taxpayer_name`,
  `e`.`address_text` AS `taxpayer_address`,
  `o`.`name` AS `lgu_name`,
  `o`.`code` AS `lgu_indexno`,
  `f`.`dtapproved` AS `dtapproved`,
  `r`.`rputype` AS `rputype`,
  `pc`.`code` AS `classcode`,
  `pc`.`name` AS `classification`,
  `f`.`fullpin` AS `pin`,
  `f`.`titleno` AS `titleno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `f`.`tdno` AS `tdno`,
  `f`.`prevtdno`,
  '' AS `arpno`,
  `f`.`prevowner` AS `prevowner`,
  `b`.`name` AS `location`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  (case when (`f`.`state` = 'CURRENT') then '' else 'CANCELLED' end) AS `remarks` 
from  `faas` `f` 
join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
join `propertyclassification` `pc` on `r`.`classification_objid` = `pc`.`objid`  
join `entity` `e` on `f`.`taxpayer_objid` = `e`.`objid`  
join `sys_org` `o` on `rp`.`lguid` = `o`.`objid`  
join `barangay` `b` on `rp`.`barangayid` = `b`.`objid`  
where  `f`.`state` in  ('CURRENT','CANCELLED')
;



DROP  VIEW IF EXISTS `vw_idle_land`
;
CREATE  VIEW `vw_idle_land` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`f`.`rpuid` AS `rpuid`,`f`.`realpropertyid` AS `realpropertyid`,`f`.`lguid` AS `lguid`,`f`.`barangayid` AS `barangayid`,`o`.`name` AS `lgu`,`f`.`barangay` AS `barangay`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`tdno` AS `tdno`,`f`.`titleno` AS `titleno`,`f`.`pin` AS `pin`,`pc`.`name` AS `classification`,`f`.`cadastrallotno` AS `cadastrallotno`,`f`.`blockno` AS `blockno`,`f`.`ry` AS `ry`,`f`.`totalareaha` AS `totalareaha`,`f`.`totalareasqm` AS `totalareasqm`,`f`.`totalmv` AS `totalmv`,`f`.`totalav` AS `totalav` from (((`faas_list` `f` join `landrpu` `lr` on(`f`.`rpuid`)) join `propertyclassification` `pc` on(`f`.`classification_objid`)) join `sys_org` `o` on(`f`.`lguid`)) where ((`f`.`state` in ('current','cancelled')) and (`lr`.`idleland` = 1))
;
drop table if exists rptacknowledgement_item;
drop table if exists rptacknowledgement;

CREATE TABLE `rptacknowledgement` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `pin` varchar(25) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(150) DEFAULT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtchecked` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_txnno` (`txnno`),
  KEY `ix_rptacknowledgement_pin` (`pin`),
  KEY `ix_rptacknowledgement_taxpayerid` (`taxpayer_objid`),
  KEY `ix_rptacknowledgement_createdby_objid` (`createdby_objid`),
  KEY `ix_rptacknowledgement_createdby_name` (`createdby_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rptacknowledgement_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `trackingno` varchar(25) DEFAULT NULL,
  `ref_objid` varchar(50) DEFAULT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_itemno` (`trackingno`),
  KEY `ix_rptacknowledgement_parentid` (`parent_objid`),
  KEY `ix_rptacknowledgement_item_faasid` (`ref_objid`),
  KEY `ix_rptacknowledgement_item_newfaasid` (`newfaas_objid`),
  CONSTRAINT `fk_rptacknowledgement_item_rptacknowledgement` FOREIGN KEY (`parent_objid`) REFERENCES `rptacknowledgement` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS `rpttracking` 
;

CREATE TABLE `rpttracking` (
  `objid` varchar(50) NOT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `trackingno` varchar(25) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `landcount` int(11) DEFAULT '0',
  `bldgcount` int(11) DEFAULT '0',
  `machcount` int(11) DEFAULT '0',
  `planttreecount` int(11) DEFAULT '0',
  `misccount` int(11) DEFAULT '0',
  `pin` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rpttracking_trackingno` (`trackingno`),
  KEY `ix_rpttracking_receivedby` (`receivedby`),
  KEY `ix_rpttracking_remarks` (`remarks`),
  KEY `ix_rpttracking_pin` (`pin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

/* RPU HISTORY */
CREATE TABLE `rpu_history` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `rpumaster_objid` varchar(50) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `prevtdno` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `ry` int(11) NOT NULL,
  `txntype_objid` varchar(5) NOT NULL,
  `effectivityyear` int(11) NOT NULL,
  `effectivityqtr` int(11) NOT NULL,
  `titleno` varchar(50) DEFAULT NULL,
  `titledate` date DEFAULT NULL,
  `portionof` varchar(255) DEFAULT NULL,
  `owner_name` varchar(1500) NOT NULL,
  `owner_address` varchar(255) DEFAULT NULL,
  `administrator_name` varchar(255) DEFAULT NULL,
  `administrator_address` varchar(255) DEFAULT NULL,
  `beneficiary_name` varchar(255) DEFAULT NULL,
  `beneficiary_address` varchar(255) DEFAULT NULL,
  `classification_objid` varchar(50) NOT NULL,
  `totalareaha` decimal(16,6) NOT NULL,
  `totalareasqm` decimal(16,2) NOT NULL,
  `totalmv` decimal(16,2) NOT NULL,
  `totalav` decimal(16,2) NOT NULL,
  `memoranda` varchar(1500) NOT NULL,
  `surveyno` varchar(255) DEFAULT NULL,
  `cadastrallotno` varchar(255) DEFAULT NULL,
  `blockno` varchar(25) DEFAULT NULL,
  `purok` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `dtapproved` date NOT NULL,
  `cancelreason` varchar(50) NOT NULL,
  `canceldate` date NOT NULL,
  `cancelledbytdnos` varchar(255) NOT NULL,
  `prevhistory_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_rpumasterid` (`rpumaster_objid`),
  KEY `ix_tdno` (`tdno`),
  KEY `ix_prevtdno` (`prevtdno`),
  KEY `ix_pin` (`pin`),
  KEY `ix_titleno` (`titleno`),
  KEY `ix_owner_name` (`owner_name`(255)),
  KEY `ix_administrator_name` (`administrator_name`),
  KEY `ix_classification_objid` (`classification_objid`),
  KEY `ix_cadastrallotno` (`cadastrallotno`),
  KEY `ix_cancelledbytdnos` (`cancelledbytdnos`),
  KEY `ix_prevhistory_objid` (`prevhistory_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table rpu_history add constraint fk_rpuhistory_rpumaster 
foreign key (rpumaster_objid) references rpumaster (objid)
;

INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) 
VALUES ('RPT.RECORD.faas.create_history', 'RPT.RECORD', 'faas', 'create_history', 'Create FAAS History')
;


/* TXN INITIATED BY ASSESSOR */
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.RECEIVER_ADMIN', 'RPT RECEIVER_ADMIN', 'RPT', NULL, NULL, 'RECEIVER_ADMIN');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createCorrection', 'RPT.RECEIVER_ADMIN', 'faas', 'createCorrection', 'FAAS correction initiated by assessor');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createReassessment', 'RPT.RECEIVER_ADMIN', 'faas', 'createReassessment', 'FAAS reassessment initiated by assessor');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createPropertyDestruction', 'RPT.RECEIVER_ADMIN', 'faas', 'createPropertyDestruction', 'FAAS destruction initiated by assessor');





/* REPRINT TD AS ORIGINAL */
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.RECORD_ADMIN', 'RPT RECORD_ADMIN', 'RPT', NULL, NULL, 'RECORD_ADMIN');
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECORD_ADMIN:faas:reprint_original_taxdec', 'RPT.RECORD_ADMIN', 'faas', 'reprint_original_taxdec', 'Reprint tax dec as original');

/* EXAMINATION FINDING */
INSERT INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.ADMIN:examination_finding:delete', 'RPT.ADMIN', 'examination_finding', 'delete', 'Delete examination finding');

INSERT IGNORE INTO sys_var (name, value, description, datatype, category) 
VALUES ('faas_effectivity_editable', '0', 'Allow or disallows editing of FAAS effectivity', 'boolean', 'ASSESSOR')
;

alter table sys_usergroup_permission modify column permission varchar(100)
; 


INSERT IGNORE INTO sys_usergroup_permission (objid, usergroup_objid, object, permission, title) 
VALUES ('RPT.CERTIFICATION_RELEASER:rptcertification:reprint', 'RPT.CERTIFICATION_RELEASER', 'rptcertification', 'reprint', 'Reprint released certification')
;

INSERT IGNORE INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('LANDTAX.RECORD_ADMIN', 'LANDTAX RECORD_ADMIN', 'LANDTAX', NULL, NULL, 'RECORD_ADMIN')
;
INSERT IGNORE INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('RPT.RECORD_ADMIN', 'RPT RECORD_ADMIN', 'RPT', NULL, NULL, 'RECORD_ADMIN')
;

INSERT IGNORE INTO sys_usergroup_permission (objid, usergroup_objid, object, permission, title) 
VALUES ('LANDTAX.RECORD_ADMIN:faas:print_td_official_copy', 'LANDTAX.RECORD_ADMIN', 'faas', 'print_taxdec_official_copy', 'Print official copy of tax declaration')
; 


DROP TABLE IF EXISTS `rptexpiry`
;

CREATE TABLE `rptexpiry` (
	`iyear` int(11) NOT NULL,
  `iqtr` int(11) NOT NULL,
  `imonth` int(11) NOT NULL,
  `expirytype` varchar(50) NOT NULL,
  `expirydate` date DEFAULT NULL,
	`validuntil` date DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`iqtr`,`imonth`,`iyear`,`expirytype`),
  KEY `ix_rptexpiry_yrqtr` (`iyear`,`iqtr`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* TXN INITIATED BY ASSESSOR */
INSERT IGNORE INTO `sys_usergroup_permission` (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('RPT.RECEIVER_ADMIN:faas:createChangePin', 'RPT.RECEIVER_ADMIN', 'faas', 'createChangePin', 'FAAS Change PIN initiated by assessor');


DROP VIEW IF EXISTS `vw_landtax_collection_detail_eor`
;


drop view if exists vw_landtax_collection_detail;
drop view if exists vw_landtax_collection_detail_eor;
drop view if exists vw_landtax_collection_disposition_detail;
drop view if exists vw_landtax_collection_disposition_detail_eor;
drop view if exists vw_landtax_collection_share_detail;
drop view if exists vw_landtax_collection_share_detail_eor;

CREATE VIEW `vw_landtax_collection_detail` AS select `cv`.`objid` AS `liquidationid`,`cv`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`cr`.`receiptdate` AS `receiptdate`,`o`.`objid` AS `lguid`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`indexno` AS `brgyindex`,`b`.`name` AS `barangay`,`ri`.`revperiod` AS `revperiod`,`ri`.`revtype` AS `revtype`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`ri`.`amount` AS `amount`,`ri`.`interest` AS `interest`,`ri`.`discount` AS `discount`,`pc`.`name` AS `classname`,`pc`.`orderno` AS `orderno`,`pc`.`special` AS `special`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basiccurrent`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0.0 end) AS `basicdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basicprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basiccurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basicprevint`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `basicnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefcurrent`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0.0 end) AS `sefdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefcurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefprevint`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `sefnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idlecurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idleprev`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0.0 end) AS `idledisc`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `idleint`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `idlenet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shcurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shprev`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0.0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `shnet`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `firecode`,0.0 AS `levynet`,(case when isnull(`crv`.`objid`) then 0 else 1 end) AS `voided` from (((((((((`remittance` `rem` join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) left join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`))) join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `ri` on((`rp`.`objid` = `ri`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`)))
;
CREATE VIEW `vw_landtax_collection_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`receiptdate` AS `receiptdate`,`o`.`objid` AS `lguid`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`indexno` AS `brgyindex`,`b`.`name` AS `barangay`,`ri`.`revperiod` AS `revperiod`,`ri`.`revtype` AS `revtype`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`ri`.`amount` AS `amount`,`ri`.`interest` AS `interest`,`ri`.`discount` AS `discount`,`pc`.`name` AS `classname`,`pc`.`orderno` AS `orderno`,`pc`.`special` AS `special`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basiccurrent`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0.0 end) AS `basicdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basicprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basiccurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basicprevint`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `basicnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefcurrent`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0.0 end) AS `sefdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefcurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefprevint`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `sefnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idlecurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idleprev`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0.0 end) AS `idledisc`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `idleint`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `idlenet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shcurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shprev`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0.0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `shnet`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `firecode`,0.0 AS `levynet` from (((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `ri` on((`rp`.`objid` = `ri`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`)))
;
CREATE VIEW `vw_landtax_collection_disposition_detail` AS select `cv`.`objid` AS `liquidationid`,`cv`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`cr`.`receiptdate` AS `receiptdate`,`ri`.`revperiod` AS `revperiod`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitybasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munibasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint')) and (`ri`.`sharetype` = 'barangay')) then `ri`.`amount` else 0.0 end) AS `brgybasicshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitysefshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munisefshare`,0.0 AS `brgysefshare`,(case when isnull(`crv`.`objid`) then 0 else 1 end) AS `voided` from (((((`remittance` `rem` join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) left join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`))) join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `ri` on((`rp`.`objid` = `ri`.`parentid`)))
;
CREATE VIEW `vw_landtax_collection_disposition_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`receiptdate` AS `receiptdate`,`ri`.`revperiod` AS `revperiod`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitybasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munibasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint')) and (`ri`.`sharetype` = 'barangay')) then `ri`.`amount` else 0.0 end) AS `brgybasicshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitysefshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munisefshare`,0.0 AS `brgysefshare` from (((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `ri` on((`rp`.`objid` = `ri`.`parentid`)))
;
CREATE VIEW `vw_landtax_collection_share_detail` AS select `cv`.`objid` AS `liquidationid`,`cv`.`controlno` AS `liquidationno`,`cv`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controlno` AS `remittanceno`,`rem`.`controldate` AS `remittancedate`,`cr`.`objid` AS `receiptid`,`cr`.`receiptno` AS `receiptno`,`cr`.`receiptdate` AS `receiptdate`,`cr`.`txndate` AS `txndate`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`name` AS `barangay`,`cra`.`revtype` AS `revtype`,`cra`.`revperiod` AS `revperiod`,`cra`.`sharetype` AS `sharetype`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgycurr`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgyprev`,(case when (`cra`.`revtype` = 'basicint') then `cra`.`amount` else 0 end) AS `brgypenalty`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgyprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `cityprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunicurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmuniprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunipenaltyshare`,`cra`.`amount` AS `amount`,`cra`.`discount` AS `discount`,(case when isnull(`crv`.`objid`) then 0 else 1 end) AS `voided` from ((((((((`remittance` `rem` join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `cra` on((`rp`.`objid` = `cra`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`)))
;
CREATE VIEW `vw_landtax_collection_share_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controlno` AS `liquidationno`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controlno` AS `remittanceno`,`rem`.`controldate` AS `remittancedate`,`eor`.`objid` AS `receiptid`,`eor`.`receiptno` AS `receiptno`,`eor`.`receiptdate` AS `receiptdate`,`eor`.`txndate` AS `txndate`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`name` AS `barangay`,`cra`.`revtype` AS `revtype`,`cra`.`revperiod` AS `revperiod`,`cra`.`sharetype` AS `sharetype`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgycurr`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgyprev`,(case when (`cra`.`revtype` = 'basicint') then `cra`.`amount` else 0 end) AS `brgypenalty`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgyprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `cityprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunicurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmuniprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunipenaltyshare`,`cra`.`amount` AS `amount`,`cra`.`discount` AS `discount` from (((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `cra` on((`rp`.`objid` = `cra`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `cashreceipt_void` `crv` on((`eor`.`objid` = `crv`.`receiptid`)))
;


update itemaccount set state = 'ACTIVE' where objid like 'RPT_%';
update itemaccount set state = 'ACTIVE' where parentid like 'RPT_%';




/*========================================
** LGU ACCOUNT MAPPING 
========================================*/


set foreign_key_checks = 0
;


INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_ADVANCE', 'ACTIVE', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_CURRENT', 'ACTIVE', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASICINT_CURRENT', 'ACTIVE', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_PREVIOUS', 'ACTIVE', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASICINT_PREVIOUS', 'ACTIVE', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASIC_PRIOR', 'ACTIVE', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_BASICINT_PRIOR', 'ACTIVE', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_ADVANCE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_CURRENT', 'ACTIVE', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEFINT_CURRENT', 'ACTIVE', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEFINT_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEF_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid)
SELECT 'RPT_SEFINT_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;


INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE PROVINCE SHARE', 'RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PROVINCE SHARE', 'RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PROVINCE SHARE', 'RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE PROVINCE SHARE', 'RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PROVINCE SHARE', 'RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PROVINCE SHARE', 'RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEF_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PROVINCE SHARE', 'RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;
INSERT IGNORE INTO itemaccount (
        objid, state, code, title, description, type, fund_objid, fund_code, fund_title, 
        defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_ADVANCE_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASIC_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;

INSERT IGNORE INTO itemaccount(
        objid, state, code, title, description, type, fund_objid, fund_code, 
        fund_title, defaultvalue, valuetype, org_objid, org_name, parentid
) 
SELECT 'RPT_BASICINT_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL
;



/* REVENUE TAG */
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE' as objid, 'RPT_BASIC_ADVANCE' as acctid, 'rpt_basic_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_CURRENT' as objid, 'RPT_BASIC_CURRENT' as acctid, 'rpt_basic_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_CURRENT' as objid, 'RPT_BASICINT_CURRENT' as acctid, 'rpt_basicint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PREVIOUS' as objid, 'RPT_BASIC_PREVIOUS' as acctid, 'rpt_basic_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PREVIOUS' as objid, 'RPT_BASICINT_PREVIOUS' as acctid, 'rpt_basicint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PRIOR' as objid, 'RPT_BASIC_PRIOR' as acctid, 'rpt_basic_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PRIOR' as objid, 'RPT_BASICINT_PRIOR' as acctid, 'rpt_basicint_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_ADVANCE' as objid, 'RPT_SEF_ADVANCE' as acctid, 'rpt_sef_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_CURRENT' as objid, 'RPT_SEF_CURRENT' as acctid, 'rpt_sef_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_CURRENT' as objid, 'RPT_SEFINT_CURRENT' as acctid, 'rpt_sefint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PREVIOUS' as objid, 'RPT_SEF_PREVIOUS' as acctid, 'rpt_sef_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PREVIOUS' as objid, 'RPT_SEFINT_PREVIOUS' as acctid, 'rpt_sefint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PRIOR' as objid, 'RPT_SEF_PRIOR' as acctid, 'rpt_sef_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PRIOR' as objid, 'RPT_SEFINT_PRIOR' as acctid, 'rpt_sefint_prior' as tag
;


/* PROVINCE PAYABLE TAG */
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_basic_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASIC_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basic_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basicint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basic_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basicint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASIC_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basic_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basicint_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_SEF_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_sef_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEF_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sef_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sefint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sef_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sefint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEF_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEF_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sef_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sefint_prior' as tag
;

/* BARANGAY PAYABLE TAG */
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_BRGY_SHARE' as objid, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as acctid, 'rpt_basic_advance' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_CURRENT_BRGY_SHARE' as objid, 'RPT_BASIC_CURRENT_BRGY_SHARE' as acctid, 'rpt_basic_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_CURRENT_BRGY_SHARE' as objid, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as acctid, 'rpt_basicint_current' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basic_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basicint_previous' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_PRIOR_BRGY_SHARE' as objid, 'RPT_BASIC_PRIOR_BRGY_SHARE' as acctid, 'rpt_basic_prior' as tag
;
replace into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASICINT_PRIOR_BRGY_SHARE' as objid, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as acctid, 'rpt_basicint_prior' as tag
;



/* MUNICIPALITY ACCOUNT MAPPING */
replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_ADVANCE' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicadvacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicprioracct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicpriorintacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicprevacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basicprevintacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basiccurracct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.basiccurrintacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_ADVANCE' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefadvacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefprioracct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PRIOR' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefpriorintacct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefprevacct_objid  = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PREVIOUS' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefprevintacct_objid = ia.objid
and m.lguid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefcurracct_objid = ia.objid
and m.lguid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',m.lguid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_CURRENT' as parentid 
from municipality_taxaccount_mapping m, itemaccount ia, municipality l 
where m.sefcurrintacct_objid= ia.objid
and m.lguid = l.objid
;





/* PROVINCE SHARE ACCOUNT MAPPING */
replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicadvacct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicprioracct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicpriorintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicprevacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basicprevintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basiccurracct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.basiccurrintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_ADVANCE_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefadvacct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefprioracct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefpriorintacct_objid = ia.objid
and l.objid = '047'
;



replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefprevacct_objid  = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefprevintacct_objid = ia.objid
and l.objid = '047'
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEF_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefcurracct_objid = ia.objid
and l.objid = '047'
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid,':',l.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as parentid 
from province_taxaccount_mapping m, itemaccount ia, province l 
where m.sefcurrintacct_objid= ia.objid
and l.objid = '047'
;



/* BARANGAY ACCOUNT MAPPING */
replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicadvacct_objid = ia.objid
and m.barangayid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PRIOR_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicprioracct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicpriorintacct_objid = ia.objid
and m.barangayid = l.objid
;


replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicprevacct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basicprevintacct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASIC_CURRENT_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basiccurracct_objid = ia.objid
and m.barangayid = l.objid
;

replace into itemaccount (
	objid, state, code, title, description, 
	type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, org_objid, org_name, parentid 
)
select 
	concat(ia.objid) as objid, 'ACTIVE' as state, '-' as code, 
	ia.title, 
	ia.description, ia.type, 
	ia.fund_objid, ia.fund_code, ia.fund_title, ia.defaultvalue, ia.valuetype, 
	l.objid as org_objid, l.name as org_name, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as parentid 
from brgy_taxaccount_mapping m, itemaccount ia, barangay l 
where m.basiccurrintacct_objid = ia.objid
and m.barangayid = l.objid
;



set foreign_key_checks = 1
;



