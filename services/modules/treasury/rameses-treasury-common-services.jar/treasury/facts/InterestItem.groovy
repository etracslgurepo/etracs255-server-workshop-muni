package treasury.facts;

import java.util.*;

class InterestItem extends BillSubItem {

	int sortorder = 500;

	public InterestItem(def o ) {
		super(o);
	}

	public InterestItem() {}

	public def toMap() {
		def m = super.toMap();
		m.txntype = getTxntype();
		m.sortorder = sortorder;
		return m;
	}

	public String getTxntype() {
		return "interest";
	}

}