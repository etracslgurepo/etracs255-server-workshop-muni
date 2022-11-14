package enterprise.utils;

import com.rameses.rules.common.*;
import com.rameses.osiris3.common.*;
import com.rameses.util.*;
import enterprise.facts.*;

public class VariableInfoUtil {
	
	private def map = [:];
	private def svc;
	String schemaName = "variableinfo";
	VariableInfoProvider provider;

	public VariableInfoUtil() {

	}

	public VariableInfoUtil(String n) {
		if(n!=null) {
			schemaName = n;	
		}
	}
 
	public def lookup( def vname ) {
		String sname = schemaName;
		if( provider ) {
			sname = provider.getSchemaName();
		}

		if(svc==null) {
			svc = EntityManagerUtil.lookup( sname );
		}
		if( ! map.containsKey(vname)) {
			def m = svc.find( [name: vname] ).first();	
			if( !m ) throw new Exception("Variable Info not found " + vname + " in VariableInfoLookup");
			map.put(vname, m );
		}
		return map.get(vname);		
	}
 
	public void convertData( def v ) {
		def o = lookup(v.name);
		v.caption = o.caption;
		v.arrayvalues = o.arrayvalues;
		v.category = o.category;
		v.sortorder = o.sortorder;
		v.datatype = o.datatype;		
		if(v.datatype == 'decimal') {
			v.value = v.decimalvalue;
		}
		else if(v.datatype=="integer") {
			v.value = v.intvalue;
		}
		else if(v.datatype=="boolean") {
			def t = false;
			if( (v.booleanvalue+"").matches("true|1|yes")) {
				t = true;
			}
			v.value = t;
		}
		else if( v.datatype == "date" ) {
			v.value = v.datevalue;
		}
		else{
			v.value = v.stringvalue;
		}
	}

	public def getConvertedData( def datatype, def value ) {
		if(datatype == 'decimal') {
			if(value==null) value = "0";
			return (""+value).toDouble();
		}
		else if(datatype=="integer") {
			if(value==null) value = "0";
			return (""+value).toInteger();
		}
		else if(datatype=="boolean") {
			if(value==null) value = "false";
			return (""+value).toBoolean();
		}
		else if( datatype == "date" ) {
			if(value==null) return null;
			if(!(value instanceof Date)) {
				def df = new java.text.SimpleDateFormat("yyyy-MM-dd");
				return df.parse( value );
			}	
			else {
				return value;
			}
		}
		else {
			if(value==null) return null;
			return value.toString();
		}
	}

	public void fixData(  def obj, def  datatype, def value ) {
		if(value == "null") value = null;
		if( value!=null ) {
			if(datatype == 'decimal') {
				obj.decimalvalue = (""+value).toDouble();
			}
			else if(datatype=="integer") {
				obj.intvalue = (""+value).toInteger();
			}
			else if(datatype=="boolean") {
				obj.booleanvalue = (""+value).toBoolean();
			}
			else if( datatype == "date" ) {
				if(!(value instanceof Date)) {
					def df = new java.text.SimpleDateFormat("yyyy-MM-dd");
					obj.datevalue = df.parse( value );
				}	
				else {
					obj.datevalue = value;
				}
			}
			else {
				obj.stringvalue = value.toString();
			}
		}
	}

	public def createFact(def v) {
		def o = lookup(v.name);
		def vinfo = null;
		if( provider ) {
			vinfo = provider.createFact( o );
		}
		else {
			vinfo = new VariableInfo();
			vinfo.name = o.name;
			vinfo.caption = o.caption;
			vinfo.arrayvalues = o.arrayvalues;
			vinfo.category = o.category;
			vinfo.sortorder = o.sortorder;
			vinfo.datatype = o.datatype;			
		}
		def value = v.value;
		fixData( vinfo, o.datatype, value );
		return vinfo;
	}

	//for simply looking up the info but does not wrap into a VariableInfo yet.
	public def lookupInfo(def v) {
		def o = lookup(v.name);
		def value = v.value;
		def vinfo = [:];
		vinfo.name = o.name;
		vinfo.caption = o.caption;
		vinfo.arrayvalues = o.arrayvalues;
		vinfo.category = o.category;
		vinfo.sortorder = o.sortorder;
		vinfo.datatype = o.datatype;		
		fixData( vinfo, o.datatype, value );
		return vinfo;
	}


}