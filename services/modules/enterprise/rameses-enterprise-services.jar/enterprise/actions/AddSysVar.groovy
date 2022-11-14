package enterprise.actions;

import com.rameses.rules.common.*;
import enterprise.facts.*;

public class AddSysVar implements RuleActionHandler {
	
	def comparator = { agg, oldvalue, newvalue ->
		switch(agg) {
			case "COUNT":
				return (oldvalue + 1);

			case "SUM":
				return oldvalue + newvalue;

			case "MIN":
				if( oldvalue <= newvalue  )		
					return oldvalue;
				else
					return newvalue;
			case "MAX":
				if( oldvalue >= newvalue  )		
					return oldvalue;
				else
					return newvalue;
		}
		return 0;
	};

	public void execute(def params, def drools) {
		def ct = RuleExecutionContext.getCurrentContext();
		if(ct.result.vars == null) {
			ct.result.vars = [:];
		}
		def vars = ct.result.vars;

		String name = params.name;
		String agg = params.aggregate;
		String dtype = params.datatype;
		def value = params.value;
		if( agg == "COUNT") dtype = "integer";
		
		def var = vars[name];
		if( var == null ) {
			var = [datatype:dtype, name: name ];
			vars[name] = var;
		}
		def newAmt = 0;
		if( agg !="COUNT") {
			newAmt = (dtype=="integer") ? value.intValue : value.doubleValue;
		}
		
		def oldAmt = (var.value==null) ? 0 : var.value;

		var.value = comparator( agg, oldAmt, newAmt );
 		
	}
}
