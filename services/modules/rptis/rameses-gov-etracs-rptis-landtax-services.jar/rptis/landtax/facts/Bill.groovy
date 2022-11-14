package rptis.landtax.facts;

public class Bill
{
	Date currentdate 
	Date expirydate 
    Date billdate 
    Integer billtoyear
    Integer billtoqtr
    Boolean advancebill
    Boolean forpayment

    def entity 
    
    public Bill(){}

    public Bill(bill){
    	this.entity = bill 
    	this.currentdate = bill.currentdate 
        this.billtoyear = bill.billtoyear
        this.billtoqtr = bill.billtoqtr
        this.advancebill = bill.advancebill
        this.billdate = bill.billdate 
        this.forpayment = (bill._forpayment ? bill._forpayment : false)
    }

    public void setExpirydate(expirydate){
    	this.expirydate = expirydate
    	entity.expirydate = expirydate
    }
}
