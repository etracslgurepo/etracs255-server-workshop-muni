package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class AddSysVar implements RuleActionHandler {
	
	def request;
	def comparator;

	public void execute(def params, def drools) {
		def vars = request.vars;
		String name = params.name;
		String agg = params.aggregate;
		String dtype = params.datatype;
		def value = params.value;

		if ( agg == "COUNT" ) dtype = "integer";
		
		def var = vars[name];
		if( var == null ) {
			var = [datatype:dtype, name: name ];
			vars[name] = var;
		}

		def oldVal = var.value; 
		def newVal = null; 
		if ( dtype == 'string' ) { 
			newVal = value.eval(); 
			var.value = string_comparator( agg, oldVal, newVal ); 
			return; 
		} 

		if ( agg !="COUNT" ) { 
			newVal = ( dtype == "integer" ? value.intValue : value.doubleValue );
		}
		var.value = comparator( agg, oldVal, newVal );
	} 


	def string_comparator = { agg, oldvalue, newvalue ->
		switch( agg ) {
			case "COUNT":
				return null; 

			case "SUM":
				return null;

			case "MIN": 
				def vals = [ oldvalue, newvalue ].findAll{( it )}.sort{ it } 
				return ( vals ? vals.first() : null ); 

			case "MAX":
				def vals = [ oldvalue, newvalue ].findAll{( it )}.sort{ it } 
				return ( vals ? vals.last() : null ); 
		} 

		return null; 
	}
}
