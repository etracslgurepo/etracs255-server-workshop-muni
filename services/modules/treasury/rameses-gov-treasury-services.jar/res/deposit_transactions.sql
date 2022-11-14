[cleanUpDeposit]
UPDATE collectionvoucher SET depostvoucherid = NULL;
UPDATE checkpayment SET depositvoucherid = NULL, fundid = NULL, depositslipid = NULL;
DELETE FROM depositslip;
DELETE FROM depositvoucher_fund;
DELETE FROM depositvoucher;

[cleanUpCollection]
UPDATE remittance SET collectionvoucherid = NULL;
DELETE FROM collectionvoucher_fund;
DELETE FROM collection_voucher;

[cleanUpRemittance]
UPDATE cashreceipt SET remittanceid = NULL:
DELETE FROM remittance_fund;
DELETE FROM remittance_af;
DELETE FROM remittance; 
