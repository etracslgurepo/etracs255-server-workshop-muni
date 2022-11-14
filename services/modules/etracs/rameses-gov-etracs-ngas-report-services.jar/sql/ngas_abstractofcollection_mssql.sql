[getLiquidationFunds]
select fund.objid, fund.code, fund.title 
from vw_remittance_cashreceiptitem ci, fund 
where ci.collectionvoucherid = $P{refid}  
	and fund.objid = ci.fundid 
group by fund.objid, fund.code, fund.title


[getLiquidationReport]
select 
	v.formno as af, v.receiptno, v.receiptdate, 
	case when v.voided=0 then v.paidby else '** VOIDED **' end as paidby, 
	v.collectorname as collector, fund.title as fund, 
	case 
		when m.objid is null then 'UNMAPPED' 
		else (m.title +' ('+ m.code +')')  
	end as account, 
	v.amount, v.voided 
from vw_collectionvoucher_cashreceiptitem v 
	inner join fund on fund.objid = v.fundid 
	left join vw_account_mapping m on (m.itemid = v.acctid and m.maingroupid = $P{maingroupid})
where v.collectionvoucherid = $P{refid} ${filters} 
order by v.formno, v.receiptno, fund.title, m.code 
