package bpls.facts;

class AppliedPayment {
	
	LOB lob;
	double amount;
	double surcharge;
    double interest;
    Object account;
    String taxfeetype;
    String receivableid;
    int qtr;

    public String toString() {
    	return lob?.name + " " +  account + 'amount'+ amount + ' surcharge ' + surcharge + ' ' + taxfeetype;	
    }

   
}