[getList]
SELECT * FROM sys_wf

[getNodes]
SELECT * FROM sys_wf_node WHERE processname=$P{processname} ORDER BY idx

[getNodeTransitions]
SELECT * FROM sys_wf_transition WHERE processname=$P{processname} AND parentid=$P{name} ORDER BY idx

[getTransitionList]
SELECT 
  n0.name AS currentname, n0.nodetype AS currentnodetype, t.[to], n1.nodetype AS tonodetype, 
  t.action, t.properties, t.permission, t.eval 
FROM sys_wf_transition t 
INNER JOIN  sys_wf_node n0 ON n0.name=t.parentid and n0.processname=t.processname
LEFT JOIN  sys_wf_node n1 ON n1.name=t.[to] and n1.processname=t.processname
WHERE t.parentid=$P{nodename} and t.processname=$P{processname} 
ORDER BY t.idx ASC

[getOpenForkList]
SELECT b.*, n.salience, n.title  
FROM ${taskTablename} b
INNER JOIN sys_wf_node n ON n.name=b.state AND n.processname=$P{processname}
WHERE b.parentprocessid=$P{parentprocessid}
AND b.enddate IS NULL

[findTask]
SELECT b.*, n.salience, n.domain, n.role, n.title, n.salience, n.idx
FROM ${taskTablename} b 
INNER JOIN sys_wf_node n ON n.name=b.state AND n.processname=$P{processname}
WHERE b.objid=$P{objid}

[findNodeInfo]
SELECT n.salience, n.domain, n.role, n.title, n.salience, n.idx
FROM sys_wf_node n WHERE n.name=$P{state} AND n.processname=$P{processname}


[getOpenWorkitemList]
SELECT * FROM ${workitemTablename}
WHERE taskid=$P{taskid}
AND enddate IS NULL

[getOpenTaskList]
SELECT b.*, n.nodetype 
FROM ${taskTablename} b 
INNER JOIN sys_wf_node n ON n.name=b.state AND n.processname=$P{processname}
WHERE b.refid=$P{refid}
AND b.enddate IS NULL

[getStates]
SELECT * FROM sys_wf_node 
WHERE processname=$P{processname} AND nodetype='state' ORDER BY idx

[getTaskListByRef]
SELECT b.*, n.nodetype, n.title  
FROM ${taskTablename} b 
INNER JOIN sys_wf_node n ON n.name=b.state AND n.processname=$P{processname}
WHERE b.refid=$P{refid} 
AND n.nodetype = 'state'
ORDER BY b.startdate

[getWorkitemTypes]
SELECT * FROM sys_wf_workitemtype 
WHERE processname=$P{processname}

[removeTransitions]
DELETE FROM sys_wf_transition WHERE processname=$P{processname}  

[removeNodes]
DELETE FROM sys_wf_node WHERE processname=$P{processname}  

[getNodesByDomain]
select * from sys_wf_node 
where domain=$P{domain} ${filter} 
order by idx 
