package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import treasury.utils.*;
import com.rameses.osiris3.common.*;


public class AddVarDecimal  implements RuleActionHandler {

	public void execute(def params, def drools) {
		try {
			def tag = params.tag;

			def ct = RuleExecutionContext.getCurrentContext();
			def facts = ct.facts;

			//do not add due date if there is already a due date having the same fact and tag
			
			def d = facts.findAll{ (it instanceof VarDecimal) && it.tag == tag };
			if(!d) {
				def dt = new VarDecimal();
				dt.value =  params.value.eval();
				dt.tag = tag;
				facts << dt;
				drools.insert(dt);
			}
		}
		catch(e) {
			throw e;
			//println "Error in AddVarDate. " + e.message;		
		}
	}

}