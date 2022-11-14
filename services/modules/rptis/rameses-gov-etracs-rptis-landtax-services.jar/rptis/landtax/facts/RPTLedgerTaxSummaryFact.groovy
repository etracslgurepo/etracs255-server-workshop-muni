package rptis.landtax.facts;

import java.math.*;

public class RPTLedgerTaxSummaryFact 
{
    RPTLedgerFact ledger 
    String  revtype
    String  revperiod      
    Double amount          
    Double interest
    Double discount
    
    public RPTLedgerTaxSummaryFact(){}

    public RPTLedgerTaxSummaryFact(item){
        this.ledger = item.ledger
        this.revtype = item.revtype 
        this.revperiod = item.revperiod 
        this.amount  = 0.0
        this.interest = 0.0
        this.discount = 0.0
    }
}
