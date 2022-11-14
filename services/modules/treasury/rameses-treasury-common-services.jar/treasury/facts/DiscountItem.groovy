package treasury.facts;

import java.util.*;

class DiscountItem extends BillSubItem {

	String txntype = "DISCOUNT";
	int sortorder = 300;


	public DiscountItem( def o ) {
		super(o);
	}

	public def toMap() {
		def m = super.toMap();
		m.txntype = "discount";
		m.sortorder = sortorder;
		return m;
	}
}