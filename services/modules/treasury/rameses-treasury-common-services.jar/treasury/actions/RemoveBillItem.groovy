package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    billitem
****/
class RemoveBillItem implements RuleActionHandler {

	public void execute(def params, def drools) {
		def billitem = params.billitem;

		def ct = RuleExecutionContext.getCurrentContext();
		if(ct.result.billitems) {
			ct.result.billitems.remove(billitem);
		}
		ct.facts.remove( billitem );
	}

}
