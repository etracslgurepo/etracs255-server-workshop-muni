package treasury.facts;

import java.util.*;

class SurchargeItem extends BillSubItem {

	int sortorder = 400;

	public SurchargeItem( def o ) {
		super(o);
	}

	public SurchargeItem() {}

	public def toMap() {
		def m = super.toMap();
		m.txntype = getTxntype();
		m.sortorder = sortorder;
		return m;
	}

	public String getTxntype() {
		return "surcharge";
	}
}