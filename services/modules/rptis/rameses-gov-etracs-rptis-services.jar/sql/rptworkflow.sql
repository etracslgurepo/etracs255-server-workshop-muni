[findStart]
SELECT wfs.*
FROM rptworkflow wf
	 INNER JOIN rptworkflow_state wfs ON wf.objid = wfs.workflowid 
WHERE wf.appliedto LIKE $P{appliedto}	 
  AND wfs.type = 'start' 


[findNext]  
SELECT wfs.*
FROM rptworkflow wf
	 INNER JOIN rptworkflow_state wfs ON wf.objid = wfs.workflowid 
WHERE wf.appliedto LIKE $P{appliedto}	 
  AND wfs.fromstate = $P{fromstate}

[findNextByWorkflowId]  
SELECT wfs.*
FROM rptworkflow wf
	 INNER JOIN rptworkflow_state wfs ON wf.objid = wfs.workflowid 
WHERE wf.objid = $P{workflowid}
  AND wfs.fromstate = $P{fromstate}  

