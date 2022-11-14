[getBuildFunds]
select 
	cv.objid as parentid, cv.objid as parent_objid, cv.controlno as parent_controlno, 
	fund.objid as fund_objid, fund.title as fund_title, fund.code as fund_code, 
	sum(rf.amount) as amount, sum(rf.totalcash) as totalcash, 
	sum(rf.totalcheck) as totalcheck, sum(rf.totalcr) as totalcr 
from collectionvoucher cv 
	inner join remittance r on r.collectionvoucherid = cv.objid 
	inner join remittance_fund rf on rf.remittanceid = r.objid 
	left join fund on fund.objid = rf.fund_objid 
where cv.objid = $P{objid} 
group by cv.objid, cv.controlno, fund.objid, fund.title, fund.code 
order by fund.code, fund.title 
