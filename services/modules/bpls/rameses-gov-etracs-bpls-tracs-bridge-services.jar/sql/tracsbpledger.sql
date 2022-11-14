#######################################
# BusinessCaptureService
#######################################
[getReceivables]
SELECT x.businessid, 
x.lob_objid, x.lob_name, x.account_objid, 
x.account_code,x.account_title, SUM(x.amount) AS amount,
SUM(x.amtpaid) AS amtpaid, SUM(balance) AS balance, 
x.year
FROM
(SELECT a.* 
	FROM 
		(SELECT 
			tb.objid AS objid,
			b.strBusinessId AS businessid,
			tb.strBusinessLineID AS lob_objid,
			bl.strBusinessLine AS lob_name,
			tb.strAcctID AS account_objid,
			tfa.strAcctCode AS account_code,
			tfa.strDescription AS account_title,
			tb.curAmount AS amount, 
			tb.curAmtPaid AS amtpaid, 
			(tb.curAmount-tb.curAmtPaid) AS balance,
			ta.intyear AS year
			FROM tblBPLedgerBill tb
			INNER JOIN tblBPLedger b ON b.objid=tb.parentid
			INNER JOIN tblTaxFeeAccount tfa ON tfa.objid=tb.strAcctID
			INNER JOIN tblassessment ta ON ta.objid=tb.strAssessmentID
			LEFT JOIN tblBusinessLine bl ON bl.objid=tb.strBusinessLineID
			WHERE b.strBusinessID=$P{objid}
		) a
	WHERE NOT(a.objid IS NULL)
	${filter}
) x 
GROUP BY x.businessid, 
x.lob_objid, x.lob_name, x.account_objid, 
x.account_code, x.account_title, x.year
ORDER BY x.year DESC

[getPayments]
select 
tb.parentid, 
o.strORNO AS receiptno, 
o.dtORDate AS receiptdate, 
o.curAmount AS amount, 
b.strBusinessID AS businessid
from tblBPLedgerBill tb
INNER JOIN tblBPLedger b ON b.objid=tb.parentid
INNER JOIN tblORItem oi ON oi.strLedgerID=tb.ObjID
INNER JOIN tblOR o ON o.objid=oi.parentid

