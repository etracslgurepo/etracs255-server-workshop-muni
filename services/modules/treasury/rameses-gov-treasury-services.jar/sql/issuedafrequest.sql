[getList]
select t.* from 
(
	select objid, issueno, dtfiled, request_reqno, issueto_name as issuedto, 
		issueto_title as issueto, user_name as issuedby, 'ISSUE' as type  
	from stockissue WHERE state =$P{state} 

	union all 

	select objid, issueno, dtfiled, request_reqno, soldto_name as issuedto, 
		soldto_title as issuedtotitle, user_name as issuedby, 'SALE' as type  
	from stocksale WHERE state =$P{state} 

	union all 

	select objid, receiptno as issueno, dtfiled, request_reqno, null as issuedto, 
		null as issuedtotitle, user_name as issuedby, 'PURCHASE' as type  
	from stockreceipt WHERE state =$P{state} 
) t
order by issueno desc 

[getListbyIssueNo]
select t.* from 
(
	select objid, issueno, dtfiled, request_reqno, issueto_name as issuedto, 
		issueto_title as issueto, user_name as issuedby, 'ISSUE' as type 
	from stockissue WHERE state =$P{state} and issueno like $P{searchtext}

	union all 

	select objid, issueno, dtfiled, request_reqno, soldto_name as issuedto, 
		soldto_title as issuedtotitle, user_name as issuedby, 'SALE' as type  
	from stocksale WHERE state =$P{state} and issueno like $P{searchtext}

	union all

	select objid, receiptno as issueno, dtfiled, request_reqno, null as issuedto, 
		null as issuedtotitle, user_name as issuedby, 'PURCHASE' as type  
	from stockreceipt WHERE state =$P{state} and receiptno like $P{searchtext}

) t
order by issueno desc 


[getListbyReqNo]
select t.* from 
(
	select objid, issueno, dtfiled, request_reqno, issueto_name as issuedto, 
		issueto_title as issueto, user_name as issuedby, 'ISSUE' as type  
	from stockissue WHERE state =$P{state} and request_reqno like $P{searchtext}	

	union all 

	select objid, issueno, dtfiled, request_reqno, soldto_name as issuedto, 
		soldto_title as issuedtotitle, user_name as issuedby, 'SALE' as type  
	from stocksale WHERE state =$P{state} and request_reqno like $P{searchtext}	

	union all

	select objid, receiptno as issueno, dtfiled, request_reqno, null as issuedto, 
		null as issuedtotitle, user_name as issuedby, 'PURCHASE' as type  
	from stockreceipt WHERE state =$P{state} and request_reqno like $P{searchtext}	

) t
order by issueno desc 


[getListbyRequester]
select t.* from 
(
	select objid, issueno, dtfiled, request_reqno, issueto_name as issuedto, 
		issueto_title as issueto, user_name as issuedby, 'ISSUE' as type  
	from stockissue WHERE state =$P{state} and issueto_name like $P{searchtext}

	union all 

	select objid, issueno, dtfiled, request_reqno, soldto_name as issuedto, 
		soldto_title as issuedtotitle, user_name as issuedby, 'SALE' as type  
	from stocksale WHERE state =$P{state} and soldto_name like $P{searchtext} 

	union all 

	select objid, receiptno as issueno, dtfiled, request_reqno, null as issuedto, 
		null as issuedtotitle, user_name as issuedby, 'PURCHASE' as type  
	from stockreceipt WHERE state =$P{state} and user_name like $P{searchtext}	 
) t
order by issueno desc 


