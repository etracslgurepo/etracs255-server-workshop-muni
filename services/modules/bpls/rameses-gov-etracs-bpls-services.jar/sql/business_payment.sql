[getList]
SELECT * FROM business_payment WHERE businessid=$P{objid} 
ORDER BY refdate DESC

[getItems]
SELECT * FROM business_payment_item WHERE parentid=$P{objid}

[getApplicationPayments]
SELECT * FROM business_payment 
WHERE applicationid=$P{applicationid} AND voided=0 
ORDER BY refdate 

[updateReceivables]
UPDATE business_receivable r
INNER JOIN (
	SELECT 
		receivableid, SUM(amount) as amount, SUM(surcharge) as surcharge, 
		SUM(interest) as interest, SUM(discount) as discount, max(qtr) as qtr, 
		MAX(partial) as partial
	FROM business_payment_item 
	WHERE parentid=$P{paymentid}  
	GROUP BY receivableid 
	)bpi ON r.objid=bpi.receivableid 
SET 
	r.amtpaid = r.amtpaid + bpi.amount,
	r.surcharge = r.surcharge + bpi.surcharge,
	r.interest = r.interest + bpi.interest, 
	r.discount = r.discount + bpi.discount,  
	r.lastqtrpaid = bpi.qtr, 
	r.partial= bpi.partial

[voidReceivables]
update business_receivable r 
INNER JOIN
	(SELECT
		receivableid, SUM(amount) as amount, SUM(surcharge) as surcharge, 
		SUM(interest) as interest, SUM(discount) as discount 
	 FROM business_payment_item 
	 WHERE parentid=$P{paymentid}  
	 GROUP BY receivableid 
	)bpi ON r.objid=bpi.receivableid 
SET 
	r.amtpaid = r.amtpaid - bpi.amount,
	r.surcharge = r.surcharge - bpi.surcharge,
	r.interest = r.interest - bpi.interest, 
	r.discount = r.discount - bpi.discount

[removePaymentItems]
delete from business_payment_item where parentid=$P{paymentid} 

[findLastQtrPaid] 
select 
	py.applicationid, py.refno, year(py.refdate) as `year`, 
	pyi.qtr, max(pyi.partial) as `partial` 
from business_payment py 
	inner join business_payment_item pyi on py.objid=pyi.parentid 
where py.applicationid=$P{applicationid} and voided=0 
group by py.applicationid, py.refno, py.refdate, pyi.qtr 
having max(pyi.partial)=0 
order by py.refdate desc, pyi.qtr desc 

[findLastQtrPaidWithLob] 
select 
	py.applicationid, py.refno, year(py.refdate) as `year`, 
	pyi.qtr, max(pyi.partial) as `partial`, pyi.lob_objid as lobid 
from business_payment py 
	inner join business_payment_item pyi on py.objid=pyi.parentid 
where py.applicationid=$P{applicationid} and pyi.lob_objid=$P{lobid} and voided=0 
group by py.applicationid, py.refno, py.refdate, pyi.qtr, pyi.lob_objid 
having max(pyi.partial)=0 
order by py.refdate desc, pyi.qtr desc 


[resetLedgerAmtPaid]
update business_receivable set amtpaid=0.0 where applicationid=$P{applicationid}

[resyncLedgerAmtPaid]
update 
	business_receivable br, ( 
		select bpi.receivableid, sum(bpi.amount) as amtpaid  
		from business_payment bp, business_payment_item bpi 
		where bp.applicationid=$P{applicationid} 
			and bpi.parentid=bp.objid 
			and bp.voided=0 
		group by bpi.receivableid 
	)tmp 
set br.amtpaid = tmp.amtpaid 
where br.objid=tmp.receivableid 
