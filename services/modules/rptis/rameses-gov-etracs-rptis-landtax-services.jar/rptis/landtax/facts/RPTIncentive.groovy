package rptis.landtax.facts;

public class RPTIncentive 
{
    RPTLedgerFact rptledger
    Double basicrate 
    Double  sefrate   
    Integer fromyear  
    Integer  toyear    

    public RPTIncentive(){}

    public RPTIncentive(ledgerfact, incentive){
        this.rptledger = ledgerfact
        this.basicrate = incentive.basicrate
        this.sefrate =  incentive.sefrate
        this.fromyear = incentive.fromyear
        this.toyear = incentive.toyear
    }

}
