[list]
 select * from realpropertyupdate
 
[list-by-pin]
 select * from realpropertyupdate where pin like $P{pin}
 
[list-by-pin-state]
 select * from realpropertyupdate where pin like $P{pin} and state = $P{state}


[find-land]
 select objid, rp from faas where objid = $P{landfaasid} 

[find-improvements]
 select f.objid, f.rp from faaslist fl
 inner join faas f on f.objid = fl.objid
 where fl.landfaasid = $P{objid} and f.docstate <> 'CANCELLED'
 
 
[update-faas-rp]
 update faas set rp=$P{rp} where objid=$P{objid}
 

[update-faaslist-rp]
 update faaslist
 set 
	cadastrallotno=$P{cadastrallotno},
	blockno=$P{blockno},
	surveyno=$P{surveyno}
 where objid=$P{faasid}
 

[update-rpt-ledger-rp]
 update rptledger
 set cadastrallotno=$P{cadastrallotno}, blockno=$P{blockno}
 where faasid=$P{faasid}



#============================================
#	LOOKUP PROPERTY SUPPORT
#============================================

[lookup-realproperty-list]
 select r.* from realproperty r
 inner join faaslist f on f.objid = r.landfaasid
 where f.docstate <> 'CANCELLED'
 order by r.pin



[lookup-realproperty-list-by-pin]
 select r.* from realproperty r
 inner join faaslist f on f.objid = r.landfaasid
 where f.docstate <> 'CANCELLED' and r.pin = $P{pin}
 order by r.pin
 
 