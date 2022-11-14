package treasury.facts;

import java.util.*;
import com.rameses.util.*;

class CreditBalanceBillItem extends AbstractBillItem {

	String reftype;
	String refid;
	int sortorder = -1000;
	String txntype = "creditbalance";	

	public CreditBalanceBillItem( def o ) {
		super(o);
		if( o.reftype ) reftype = o.reftype;
		if( o.refid ) refid = o.refid;
	}

	public def toMap() {
		def m = super.toMap();
		m.refid = refid;
		m.reftype = reftype;
		m.total = m.amount;
		m.sortorder = 99999999;
		return m;
	}

	public int hashCode() {
		def sb = new StringBuilder();
		if( account?.objid ) sb.append( account.objid );
		if( refid ) sb.append( refid );
		if( txntype ) sb.append( txntype );
		return sb.toString().hashCode();
	}

}