package treasury.facts;

import java.util.*;

public class BillSubItem extends AbstractBillItem {

	BillItem parent;
	boolean dynamic = true;		//not saved in database
	int sortorder = 200;


	public BillSubItem( def o ) {
		super(o);
		if(o.parent ) parent = o.parent;
		if(o.dynamic) dynamic = o.dynamic; 
		if(o.sortorder) sortorder = o.sortorder;
	}

	public BillSubItem() {}

	public int hashCode() {
		return (parent?.account?.objid+"_"+parent?.txntype+"_"+ account?.objid+"_"+txntype).hashCode();			
	}

	public def toMap() {
		def m = super.toMap();
		m.dynamic = true;
		return m;
	}


}