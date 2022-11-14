[getUsers]
select distinct 
	u.objid, 
	u.name
from txnlog l
inner join sys_user u on l.userid = u.objid 
where u.state = 'ACTIVE' or u.state is null 
order by u.name 

[getRefTypes]
select distinct 
	ref
from txnlog 
order by ref 


[getList] 
select 
  xx.username,
	xx.ref,
	xx.action, 
	sum(xx.cnt) as cnt 
from (
	select 
		x.*
	from (
			select  
				u.objid AS userid,
				u.name AS username,
				t.txndate AS txndate,
				t.ref AS ref,
				t.action AS action,
					1 AS cnt 
			from  txnlog t join sys_user u on  t.userid = u.objid    
			where t.userid = $P{userid} 
			and t.txndate >= $P{startdate} and t.txndate < $P{enddate}

			union 
			
			select 
				u.objid AS userid,
				u.name AS username,
				t.enddate AS txndate,'faas' AS ref, 
				case 
				when  t.state like '%receiver%'  then 'receive' 
				when  t.state like '%examiner%'  then 'examine' 
				when  t.state like '%taxmapper_chief%'  then 'approve taxmap' 
				when  t.state like '%taxmapper%'  then 'taxmap' 
				when  t.state like '%appraiser%'  then 'appraise' 
				when  t.state like '%appraiser_chief%'  then 'approve appraisal' 
				when  t.state like '%recommender%'  then 'recommend' 
				when  t.state like '%approver%'  then 'approve' 
				else t.state end  AS action,
				1 AS cnt 
			from  faas_task t join sys_user u on  t.actor_objid = u.objid    
			where t.actor_objid = $P{userid} 
			and t.enddate >= $P{startdate} and t.enddate < $P{enddate}
			and  not  t.state like '%assign%'    
			
			union 
			
			select 
				u.objid AS userid,
				u.name AS username,
				t.enddate AS txndate,'subdivision' AS ref, 
				case 
				when  t.state like '%receiver%'  then 'receive' 
				when  t.state like '%examiner%'  then 'examine' 
				when  t.state like '%taxmapper_chief%'  then 'approve taxmap' 
				when  t.state like '%taxmapper%'  then 'taxmap' 
				when  t.state like '%appraiser%'  then 'appraise' 
				when  t.state like '%appraiser_chief%'  then 'approve appraisal' 
				when  t.state like '%recommender%'  then 'recommend' 
				when  t.state like '%approver%'  then 'approve' 
				else t.state end  AS action,
				1 AS cnt 
			from  subdivision_task t join sys_user u on  t.actor_objid = u.objid    
			where t.actor_objid = $P{userid} 
			and t.enddate >= $P{startdate} and t.enddate < $P{enddate}
			and not  t.state like '%assign%'    
			
			union 
			
			select 
				u.objid AS userid,
				u.name AS username,
				t.enddate AS txndate,'consolidation' AS ref, 
				case 
				when  t.state like '%receiver%'  then 'receive' 
				when  t.state like '%examiner%'  then 'examine' 
				when  t.state like '%taxmapper_chief%'  then 'approve taxmap' 
				when  t.state like '%taxmapper%'  then 'taxmap' 
				when  t.state like '%appraiser%'  then 'appraise' 
				when  t.state like '%appraiser_chief%'  then 'approve appraisal' 
				when  t.state like '%recommender%'  then 'recommend' 
				when  t.state like '%approver%'  then 'approve' 
				else t.state end  AS action,
				1 AS cnt 
			from  subdivision_task t join sys_user u on  t.actor_objid = u.objid    
			where t.actor_objid = $P{userid} 
			and t.enddate >= $P{startdate} and t.enddate < $P{enddate}
			and  not  t.state like '%consolidation%'    

			union 
			
			select 
				u.objid AS userid,
				u.name AS username,
				t.enddate AS txndate,'cancelledfaas' AS ref, 
				case 
				when  t.state like '%receiver%'  then 'receive' 
				when  t.state like '%examiner%'  then 'examine' 
				when  t.state like '%taxmapper_chief%'  then 'approve taxmap' 
				when  t.state like '%taxmapper%'  then 'taxmap' 
				when  t.state like '%appraiser%'  then 'appraise' 
				when  t.state like '%appraiser_chief%'  then 'approve appraisal' 
				when  t.state like '%recommender%'  then 'recommend' 
				when  t.state like '%approver%'  then 'approve' 
				else t.state end  AS action,
				1 AS cnt 
			from  subdivision_task t join sys_user u on  t.actor_objid = u.objid    
			where t.actor_objid = $P{userid} 
			and t.enddate >= $P{startdate} and t.enddate < $P{enddate}
			and not  t.state like '%cancelledfaas%'   

			union 
			
			select 
				u.objid AS userid,
				u.name AS username,
				t.enddate AS txndate,'rptcertification' AS ref, 
				case 
				when  t.state like '%receiver%'  then 'receive' 
				when  t.state like '%examiner%'  then 'examine' 
				when  t.state like '%taxmapper_chief%'  then 'approve taxmap' 
				when  t.state like '%taxmapper%'  then 'taxmap' 
				when  t.state like '%appraiser%'  then 'appraise' 
				when  t.state like '%appraiser_chief%'  then 'approve appraisal' 
				when  t.state like '%recommender%'  then 'recommend' 
				when  t.state like '%approver%'  then 'approve' 
				else t.state end  AS action,
				1 AS cnt 
			from  rptcertification_task t join sys_user u on  t.actor_objid = u.objid    
			where t.actor_objid = $P{userid} 
			and t.enddate >= $P{startdate} and t.enddate < $P{enddate}
			and not  t.state like '%released%'  
			
		)x
		where 1=1 
		${filter}
	)xx
group by xx.username, xx.ref, xx.action
order by xx.username, xx.ref, xx.action