package enterprise.facts;

class Requirement {
	
	String type;
	String title;
	Date expirydate;
	boolean completed;

	/****************************************************************************************
	* this is marked if the requirement is included. See AddRequirement action to set
	* and see BillingRuleService for its usage
	****************************************************************************************/
	boolean included = false;

	public int hashCode() {
		return type.hashCode();
	}

	public boolean equals(def o ) {
		return (hashCode()==o.hashCode());
	}

	public Map toMap() {
		def m = [:];
		m.type = type;
		m.expirydate = expirydate;
		m.title = title;
		m.completed = completed;
		return m;
	}

}