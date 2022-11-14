package treasury.facts;

class Fund {
	
	String objid;
	String code;
	String title;

	public def toMap() {
		def m = [:];
		m.objid = objid;
		m.code = code;
		m.title = title;
		return m;
	}

}