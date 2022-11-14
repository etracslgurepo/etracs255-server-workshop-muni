package treasury.facts;

/**********************************************************************
* If you need  aspecial sharing, just extend this class
**********************************************************************/

class RevenueShare {
	
	String receiptitemid;
	Account refitem;
	Account payableitem;
	double amount;

	public Map toMap() {
		def m = [:];
		m.receiptitemid = receiptitemid;
		m.refitem = refitem.toMap();
		m.payableitem = payableitem.toMap();
		m.amount = amount;
		return m;
	}

	public int hashCode() {
		return (refitem.hashCode() + "" + payableitem.hashCode()).hashCode();
	}

	public boolean equals( def o ) {
		return hashCode() == o.hashCode();
	}

}