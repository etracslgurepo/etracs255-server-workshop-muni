package enterprise.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import enterprise.facts.*;
import com.rameses.osiris3.common.*;

/***
* Description: Simple Add of Item. Item is unique based on the account. 
* Parameters:
*    account 
*    amount
****/
class AddRequirement implements RuleActionHandler {

	public void execute(def params, def drools) {
		def dtype = params.type;
		def type = dtype.key;
		def title = dtype.value;


		def ct = RuleExecutionContext.getCurrentContext();
		def req = ct.facts.find{ (it instanceof Requirement) && it.type == type };
		//mark as included so it will be included in the output.
		if( req ) {
			req.included = true;
		}
		else {
			req = new Requirement( type:type, title: title, completed:false, included: true );
			ct.facts << req;
		}
	}

}