package enterprise.facts;

import java.util.*;

public class VariableInfo {
	
	String objid;
	String name;
	String state;
	String description;
	String caption;
	def arrayvalues;
	String category;
	int sortorder;

	double decimalvalue;
	int intvalue;
	boolean booleanvalue;
	String stringvalue;
	Date datevalue;
	String datatype;

	

	//just add so that it will match database. if 1=yes 0=no
	int system;

	public String getExcludeFields(){
		return "";
	};

	public int hashCode() {
		return name.hashCode();
	}

	public boolean equals( def o ) {
		return (hashCode() == o.hashCode());
	}

	/********************************************
	* This is from the fact to map data
	********************************************/
	public def toMap() {
		def m = [:];
		m.datatype = datatype;
		m.caption = caption;
		m.category = category;
		m.name = name;
		m.value = null;
		if(m.datatype == 'decimal') {
			m.value  = decimalvalue;
			m.decimalvalue = m.value;
		}	
		else if(m.datatype=="integer") {
			m.value = intvalue;
			m.intvalue = m.value;
		}	
		else if(m.datatype=="boolean") {
			m.value = booleanvalue;
			m.booleanvalue = m.value;
		}	
		else if(m.datatype == "date" ) {
			m.value = datevalue;
			m.datevalue = m.value;
		}	
		else {
			m.value = stringvalue;
			m.stringvalue = m.value;
		}	
		m.arrayvalues = arrayvalues;
		m.sortorder = sortorder;
		return m;
	}

	public void copy( def o ) {
		//println "fields to unmatch ->" + 	"class|metaClass"+excludeFields;
		this.metaClass.properties.each { k ->
			if( !k.name.matches("class|metaClass"+excludeFields)) {
				//add only if there is a setter
				if( k.setter && o.containsKey(k.name)) {
					def v = o.get( k.name );
					if(v) this[(k.name)] = v;	
				}
			}
		}
	}

}