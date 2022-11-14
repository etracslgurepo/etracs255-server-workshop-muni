#######################################
# BusinessCaptureService
#######################################
[getList]
select distinct a.* from 
(
	SELECT
		b.ObjID as objid, t.strTaxpayer as owner_name, t.strTaxpayerID as owner_objid, 
		t.strTaxpayerAddress as owner_address,  b.strTradeName as businessname, 
		b.strTradeName as tradename, strBusinessAddress as businessaddress,
		ta.intyear AS activeyear
	FROM tblBusiness b
	  INNER JOIN  tblTaxpayer t on t.strTaxpayerID = b.strTaxpayerID 
	  INNER JOIN tblBPLedger bpl on bpl.strBusinessID = b.ObjID 
	  INNER JOIN tblAssessment ta on ta.strBusinessID = b. ObjID 
	WHERE ta.intyear=$P{activeyear} 
	AND (ta.state=2 OR ta.state=3)
	AND EXISTS (SELECT * FROM tblAssessmentTaxFee WHERE ParentID=ta.ObjID)
	AND NOT EXISTS (SELECT * FROM tracs_etracs.dbo.registered_business WHERE objid=b.Objid)
	${filter}
) a ORDER BY a.activeyear DESC


[findBusinessInfo]
select
	b.ObjID AS objid, t.strTaxpayer as ownername, 
	it.strFirstname AS ownerfirstname, 
	it.strLastname AS ownerlastname, 
	it.strMiddlename AS ownermiddlename,
	it.strSexID AS ownergender,
	it.strTIN AS ownertin,
	t.strTaxpayerAddress as owneraddress,  
	null as barangay_objid, null as barangay_name, 
	b.strTradeName as businessname,
	b.strTradeName as tradename, 
	strBusinessAddress as businessaddress, 
	case strOrganizationTypeID 
		when 'S' then 'SING'
		when 'P' then 'PART'
		when 'FOUN' then 'FOUND'
		else strOrganizationTypeID 
	end as orgtype, 
	intYearStarted as yearstarted, 'SYSTEM' AS user_objid, 
	(select MAX(intyear) from tblAssessment where strBusinessID = b. ObjID ) as activeyear, 
	null as bin, lngPIN as pin, null as tin, bpl.ObjID as ledgerid  
from tblBusiness b
  inner join  tblTaxpayer t on t.strTaxpayerID = b.strTaxpayerID 
  inner join tblBPLedger bpl on bpl.strBusinessID = b.ObjID 
  left join tblIndividualTaxpayer it ON it.ObjID=t.strTaxpayerID
 where b.ObjID=$P{objid}

 [findDeclaredCapital]
 
[getLobs]
SELECT DISTINCT 
ta.strBusinessID AS businessid, bl.objid AS tracslobid, bl.strBusinessLine AS tracslobname,
(SELECT TOP 1 lo.etracslobid FROM tracs_etracs.dbo.lobmapping lo WHERE lo.tracslobid=bl.objid) AS lob_objid,
(SELECT TOP 1 lo.etracslobname FROM tracs_etracs.dbo.lobmapping lo WHERE lo.tracslobid=bl.objid) AS lob_name
FROM tblAssessment ta
INNER JOIN tblAssessmentBO bo ON bo.parentid=ta.objid
INNER JOIN tblBusinessLine bl ON bo.strBusinessLineID=bl.objid 
WHERE ta.strBusinessID=$P{objid} AND ta.inttype NOT IN ( 2,10 )

[getReceivables]
SELECT 
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
ORDER BY ta.intyear DESC

[insertBusinessID]
INSERT INTO tracs_etracs.dbo.registered_business (objid) VALUES ($P{objid})


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


[findLOB]
SELECT * FROM lobmapping;