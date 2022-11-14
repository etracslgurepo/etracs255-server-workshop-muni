package enterprise.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import rules.enterprise.facts.*;
import com.rameses.osiris3.common.*;

/***
* Description: Simple Add of Item. Item is unique based on the account. 
* Parameters:
*    account 
*    amount
****/
class ThrowException implements RuleActionHandler {

	public void execute(def params, def drools) {
		def msg = params.msg.eval();
		throw new Exception(msg);
	}

}