package rptis.landtax.facts

import java.math.*


public class RPTLedgerItemFact
{
    RPTLedgerFact ledger 
    String objid 
    String rptledgerfaasid
    Integer year
    Integer qtr
    Double av
    Double basicav
    Double sefav
    String txntype
    String classification
    String actualuse
    String revtype
    String revperiod
    Integer monthsfromqtr
    Integer monthsfromjan
    Integer priority
    Integer fromqtr
    Integer toqtr
    Boolean backtax
    Boolean idleland
    Boolean reclassed
    Boolean taxdifference 
    Boolean fullypaid 
    Boolean qtrlypaymentavailed 
    Double amount
    Double amtpaid
    Double amtdue
    Double interest 
    Double discount
    Boolean qtrly
    Boolean partialled 

    def entity

    public RPTLedgerItemFact(){
        this.amount = 0.0
        this.amtpaid = 0.0
        this.amtdue = 0.0
        this.interest  = 0.0
        this.discount = 0.0
    }

    public RPTLedgerItemFact(ledgerfact, item){
        this()
        this.ledger = ledgerfact
        this.entity = item 
        this.objid = item.objid 
        this.rptledgerfaasid = item.rptledgerfaas?.objid
        this.year = item.year
        this.qtr = item.qtr
        this.av = item.av
        this.basicav = item.basicav
        this.sefav = item.sefav
        this.txntype = item.txntype
        this.classification = (item.classification ? item.classification : item.rptledgerfaas?.classification?.objid)
        this.actualuse = (item.actualuse ? item.actualuse : item.rptledgerfaas?.actualuse?.objid)
        this.revtype = item.revtype
        this.monthsfromqtr = item.monthsfromqtr
        this.monthsfromjan = item.monthsfromjan
        this.priority = item.priority
        this.fromqtr = item.fromqtr
        this.toqtr = item.toqtr
        this.backtax = item.backtax
        this.idleland = item.idleland
        this.reclassed = item.reclassed
        this.taxdifference  = item.taxdifference 
        this.qtrlypaymentavailed = item.qtrlypaymentavailed
        this.amount = item.amount
        this.amtpaid = item.amtpaid
        this.amtdue = item.amtdue
        this.partialled = false 
        setRevperiod(null)
        setQtrly(item.qtrly ? item.qtrly : false)
        setInterest(item.interest ? item.interest : 0.0)
        setDiscount(item.discount ? item.discount : 0.0)
    }

    public void setAmount(amount){
        this.amount = toBigDecimal(amount)
        entity.amount = this.amount
    }

    public void setAmtpaid(amtpaid){
        this.amtpaid = toBigDecimal(amtpaid)
        entity.amtpaid = this.amtpaid
    }

    public void setAmtdue(amtdue){
        this.amtdue = toBigDecimal(amtdue)
        entity.amtdue = this.amtdue
    }

    public void setInterest(interest){
        this.interest = toBigDecimal(interest)
        entity.interest = this.interest
    }

    public void setDiscount(discount){
        this.discount = toBigDecimal(discount)
        entity.discount = this.discount
    }

    public void setRevperiod(revperiod){
        this.revperiod = revperiod
        entity.revperiod = revperiod
    }

    public void setQtr(qtr){
        this.qtr = qtr
        entity.qtr = qtr
    }

    public void setQtrly(qtrly){
        this.qtrly = qtrly
        entity.qtrly = qtrly
    }

    public void setPartialled(partialled){
        this.partialled = partialled
        entity.partialled = partialled
    }

    def toBigDecimal(val){
        if (val == null) val = 0.0
        return new java.math.BigDecimal(val+'').setScale(4, java.math.RoundingMode.HALF_DOWN)
    }

}
