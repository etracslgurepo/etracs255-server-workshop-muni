package rptis.landtax.facts;

import java.math.*;

public class RPTLedgerFact 
{
    String objid
    String taxpayerid 
    Integer lastyearpaid
    Integer lastqtrpaid
    Boolean firstqtrpaidontime
    Boolean qtrlypaymentpaidontime
    Boolean undercompromise
    Boolean missedpayment
    String parentlguid
    String lguid
    String barangayid
    String barangay
    String rputype
    String tdno
    String prevtdno
    String txntype

    //data reference
    def entity    

    public RPTLedgerFact(){}

    public RPTLedgerFact(ledger){
        this.entity                 = ledger 
        this.objid                  = ledger.objid
        this.taxpayerid             = ledger.taxpayer?.objid 
        this.lastyearpaid           = ledger.lastyearpaid
        this.lastqtrpaid            = ledger.lastqtrpaid
        this.firstqtrpaidontime     = (ledger.firstqtrpaidontime == 1 || (ledger.firstqtrpaidontime ? true : false ))
        this.qtrlypaymentpaidontime = (ledger.qtrlypaymentpaidontime == 1 || (ledger.qtrlypaymentpaidontime ? true : false ))
        this.undercompromise        = (ledger.undercompromise == 1 || (ledger.undercompromise ? true : false ))
        this.parentlguid            = ledger.parentlguid
        this.lguid                  = ledger.lguid
        this.barangayid             = ledger.barangayid
        this.barangay               = ledger.barangay
        this.rputype                = ledger.rputype
        this.tdno                   = ledger.tdno
        this.prevtdno               = ledger.prevtdno
        this.missedpayment          = ledger.missedpayment
        this.txntype                = ledger.txntype?.objid
    }

}
