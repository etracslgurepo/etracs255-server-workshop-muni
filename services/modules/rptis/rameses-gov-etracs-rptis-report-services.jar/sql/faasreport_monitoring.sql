[getTxnLogActions]
SELECT DISTINCT
	action 
FROM txnlog
WHERE ref = 'FAAS'
AND userid LIKE $P{userid}
AND txndate >= $P{startdate} AND txndate < $P{enddate}
ORDER BY action


[findActionCount]
SELECT 
	count(distinct refid) as sum
FROM txnlog
WHERE ref = 'FAAS'
AND action = $P{action}
AND userid LIKE $P{userid}
AND txndate >= $P{startdate} AND txndate < $P{enddate}


[getUsers]
SELECT DISTINCT
	userid, username
FROM txnlog
WHERE ref = 'FAAS'
AND userid LIKE $P{userid}
AND txndate >= $P{startdate} AND txndate < $P{enddate}
ORDER BY username 

[getData]
SELECT 
username AS user, action  
FROM txnlog 
WHERE ref = 'FAAS'
AND userid LIKE $P{userid}
AND txndate >= $P{startdate} AND txndate < $P{enddate}
ORDER BY username, action 

