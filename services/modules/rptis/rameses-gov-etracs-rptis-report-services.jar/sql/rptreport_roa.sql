[getCurrentFaasRecord]
SELECT
f.objid,
f.owner_name,
f.tdno,
f.fullpin,
r.taxable,
r.rputype,
'CURRENT' as state,
null as parentlguindex,
null as lguindex,
CASE WHEN r.taxable=1  and r.rputype = 'land' THEN r.totalareasqm ELSE null END AS totalareasqm,
CASE WHEN r.taxable=1  and r.rputype = 'land' THEN r.totalareaha ELSE null END AS totalareaha,
f.dtapproved,
ft.displaycode as code,
CASE WHEN r.taxable=1 AND r.rputype='land' THEN r.totalmv ELSE null END AS taxmvland,
CASE WHEN r.taxable=1 AND r.rputype='bldg' THEN r.totalmv ELSE null END AS taxmvbuild,
CASE WHEN r.taxable=1 AND r.rputype='mach' THEN r.totalmv ELSE null END AS taxmvmach,
CASE WHEN r.taxable=1 AND r.rputype='planttree' THEN r.totalmv ELSE null END AS taxmvplanttree,
CASE WHEN r.taxable=1 AND r.rputype='land' THEN r.totalav ELSE null END AS taxavland,
CASE WHEN r.taxable=1 AND r.rputype='bldg' THEN r.totalav ELSE null END AS taxavbuild,
CASE WHEN r.taxable=1 AND r.rputype='mach' THEN r.totalav ELSE null END AS taxavmach,
CASE WHEN r.taxable=1 AND r.rputype='planttree' THEN r.totalav ELSE null END AS taxavplanttree,
f.effectivityyear as yeartaxbegin,
CASE WHEN r.taxable = 0 and r.rputype='land' THEN r.totalareasqm ELSE null END AS exptlandareasqm,
CASE WHEN r.taxable = 0 and r.rputype='land' THEN r.totalareaha ELSE null END AS exptlandareaha,
CASE WHEN r.taxable = 0 AND r.rputype='land' THEN r.totalmv ELSE null END AS exptmvland,
CASE WHEN r.taxable = 0 AND r.rputype='bldg' THEN r.totalmv ELSE null END AS exptmvbuild,
CASE WHEN r.taxable = 0 AND r.rputype='mach' THEN r.totalmv ELSE null END AS exptmvmach,
CASE WHEN r.taxable = 0 AND r.rputype='planttree' THEN r.totalmv ELSE null END AS exptmvplanttree,
CASE WHEN r.taxable = 0 AND r.rputype='land' THEN r.totalav ELSE null END AS exptavland,
CASE WHEN r.taxable = 0 AND r.rputype='bldg' THEN r.totalav ELSE null END AS exptavbuild,
CASE WHEN r.taxable = 0 AND r.rputype='mach' THEN r.totalav ELSE null END AS exptavmach,
CASE WHEN r.taxable = 0 AND r.rputype='planttree' THEN r.totalav ELSE null END AS exptavplanttree
FROM faas f
INNER JOIN rpu r ON f.rpuid = r.objid
INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
INNER JOIN barangay b ON rp.barangayid = b.objid
INNER JOIN faas_txntype as ft on f.txntype_objid = ft.objid 
WHERE (
	(f.dtapproved < $P{enddate} AND f.state = 'CURRENT' ) OR 
	(f.canceldate >= $P{enddate} AND f.state = 'CANCELLED' )
)
${filter}
ORDER BY f.tdno


[getPreviousFaases]
select prevfaasid from faas_previous where faasid = $P{objid}


[findCancelledFaasRecord]
SELECT
f.objid, 
f.owner_name,
f.tdno,
f.fullpin,
r.taxable,
r.rputype,
'CANCELLED' as state,
NULL AS parentlguindex,
NULL AS lguindex,
CASE WHEN r.taxable=1 and r.rputype='land' THEN r.totalareasqm ELSE NULL END AS totalareasqm,
CASE WHEN r.taxable=1 and r.rputype='land' THEN r.totalareaha ELSE NULL END AS totalareaha,
f.dtapproved,
ft.displaycode as code,
CASE WHEN r.taxable=1 AND r.rputype='land' THEN r.totalmv ELSE NULL END AS taxmvland,
CASE WHEN r.taxable=1 AND r.rputype='bldg' THEN r.totalmv ELSE NULL END AS taxmvbuild,
CASE WHEN r.taxable=1 AND r.rputype='mach' THEN r.totalmv ELSE NULL END AS taxmvmach,
CASE WHEN r.taxable=1 AND r.rputype='planttree' THEN r.totalmv ELSE NULL END AS taxmvplanttree,
CASE WHEN r.taxable=1 AND r.rputype='land' THEN r.totalav ELSE NULL END AS taxavland,
CASE WHEN r.taxable=1 AND r.rputype='bldg' THEN r.totalav ELSE NULL END AS taxavbuild,
CASE WHEN r.taxable=1 AND r.rputype='mach' THEN r.totalav ELSE NULL END AS taxavmach,
CASE WHEN r.taxable=1 AND r.rputype='planttree' THEN r.totalav ELSE NULL END AS taxavplanttree,
f.effectivityyear AS yeartaxbegin,
CASE WHEN r.taxable = 0 and r.rputype='land' THEN r.totalareasqm ELSE NULL END AS exptlandareasqm,
CASE WHEN r.taxable = 0 and r.rputype='land' THEN r.totalareaha ELSE NULL END AS exptlandareaha,
CASE WHEN r.taxable = 0 AND r.rputype='land' THEN r.totalmv ELSE NULL END AS exptmvland,
CASE WHEN r.taxable = 0 AND r.rputype='bldg' THEN r.totalmv ELSE NULL END AS exptmvbuild,
CASE WHEN r.taxable = 0 AND r.rputype='mach' THEN r.totalmv ELSE NULL END AS exptmvmach,
CASE WHEN r.taxable = 0 AND r.rputype='planttree' THEN r.totalmv ELSE NULL END AS exptmvplanttree,
CASE WHEN r.taxable = 0 AND r.rputype='land' THEN r.totalav ELSE NULL END AS exptavland,
CASE WHEN r.taxable = 0 AND r.rputype='bldg' THEN r.totalav ELSE NULL END AS exptavbuild,
CASE WHEN r.taxable = 0 AND r.rputype='mach' THEN r.totalav ELSE NULL END AS exptavmach,
CASE WHEN r.taxable = 0 AND r.rputype='planttree' THEN r.totalav ELSE NULL END AS exptavplanttree
FROM faas f
INNER JOIN rpu r ON f.rpuid = r.objid
INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
INNER JOIN barangay b ON rp.barangayid = b.objid
INNER JOIN faas_txntype as ft on f.txntype_objid = ft.objid 
WHERE f.objid = $P{prevfaasid}
ORDER BY f.tdno