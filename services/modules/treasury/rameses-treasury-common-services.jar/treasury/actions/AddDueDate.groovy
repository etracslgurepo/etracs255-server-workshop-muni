package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* This adds a simple due date 
* Parameters:
*    date expression
****/
class AddDueDate implements RuleActionHandler {

	public void execute(def params, def drools) {
		try {
			def sdate = params.date.eval();

			def tag = params.tag;

			def ct = RuleExecutionContext.getCurrentContext();
			def facts = ct.facts;

			//do not add due date if there is already a due date having the same fact and tag
			def dt = new DueDate(sdate );
			dt.tag = tag;
			def d = facts.findAll{ (it instanceof DueDate) && it.tag == dt.tag };
			if(!d) {
				facts << dt;
			}
		}
		catch(e) {
			e.printStackTrace();
			println "Error in AddDueDate. " + e.message;		
		}	
	}

}