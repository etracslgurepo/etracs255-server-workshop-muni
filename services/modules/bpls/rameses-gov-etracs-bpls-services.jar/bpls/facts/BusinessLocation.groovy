package bpls.facts;

public class BusinessLocation {
	
	String type;
	String barangayid;

	public BusinessLocation() {
	}

	public BusinessLocation(a) {
		this.type = a.type;
		if(a.type == 'local') type = 'owned';
		if(a.barangay) {
			barangayid = a.barangay.objid	
		}
	}

}