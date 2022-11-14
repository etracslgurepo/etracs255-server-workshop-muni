[getList]
SELECT * FROM business_redflag WHERE businessid=$P{objid}

[getOpenIssues]
SELECT * FROM business_redflag WHERE resolved=0 AND businessid=$P{businessid} AND blockaction=$P{blockaction}

[findBusinessInfo]
SELECT * FROM business WHERE objid=$P{businessid} 
