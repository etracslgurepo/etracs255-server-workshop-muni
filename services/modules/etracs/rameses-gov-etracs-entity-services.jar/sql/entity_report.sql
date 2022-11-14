[getEncodingStatistics]
SELECT 
	username AS name,
	SUM(CASE WHEN ref in ('IndividualEntity','entityindividual') and action = 'create' then 1 else 0 end) as individualcnt,
	SUM(CASE WHEN ref in ('JuridicalEntity','entityjuridical') and action = 'create' then 1 else 0 end) as juridicalcnt,
	SUM(CASE WHEN ref in ('MultipleEntity','entitymultiple') and action = 'create' then 1 else 0 end) as multiplecnt,
	SUM(CASE WHEN action = 'create' then 1 else 0 end) as total
FROM  txnlog 
WHERE ref in (
	'individualentity', 'juridicalentity', 'multipleentity', 
	'entityindividual', 'entityjuridical', 'entitymultiple'
)
  AND txndate BETWEEN $P{fromdate} AND $P{todate}
GROUP BY username 