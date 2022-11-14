package rptis.landtax.facts;

public class ShareFact 
{
    String lgutype  
    String revtype
    String revperiod 
    String sharetype  
    String barangayid 
    Double amount     
    Double discount 

    def entity 
    
    public ShareFact(){}

    public ShareFact(params, share){
        this.entity = share 
        this.barangayid = params.taxsummary.ledger.barangayid 
        this.lgutype = params.lgutype  
        this.revtype = share.revtype
        this.revperiod = share.revperiod
        this.sharetype = params.stype
        this.amount = 0.0
        this.discount = 0.0
    }

    public void setAmount(amount){
        this.amount = toBigDecimal(amount)
        entity.amount = this.amount
    }

    public void setDiscount(discount){
        this.discount = toBigDecimal(discount)
        entity.discount = this.discount
    }

    def toBigDecimal(val){
        if (val == null) val = 0.0
        return new java.math.BigDecimal(val+'').setScale(4, java.math.RoundingMode.HALF_DOWN)
    }
}
