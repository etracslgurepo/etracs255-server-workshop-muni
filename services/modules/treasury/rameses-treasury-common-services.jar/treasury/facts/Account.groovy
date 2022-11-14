package treasury.facts;

import enterprise.facts.*;

class Account {
	
	Fund fund;
	String objid;
	String code;
	String title;
	int sortorder;
	Org org;

	Account parentaccount;	//if there is a patrent account in account

	public Map toMap() {
		def m = [:];
		m.objid = objid;
		m.code = code;
		m.title = title;
		m.fund = fund?.toMap();
		return m;
	}

	public int hashCode() {
		return objid.hashCode();
	}

	public boolean equals( def o ) {
		return hashCode() == o.hashCode();
	}

}