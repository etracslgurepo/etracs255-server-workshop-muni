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
class RemoveDiscountItem implements RuleActionHandler {

	public void execute(def params, def drools) {
		def billitem = params.billitem;
		if( billitem == null )
			throw new Exception("billitem is required in RemoveDiscountItem action");

		if( !(billitem instanceof BillItem ))
			throw new Exception("billitem must be an instance of treasury.facts.BillItem in RemoveDiscountItem action");

		def discItem = billitem.items.find{ it instanceof DiscountItem };
		if( discItem ) {
			billitem.items.remove( discItem );
			billitem.amount += discItem.amount;
			def ct = RuleExecutionContext.getCurrentContext();
			ct.facts.remove( discItem );
		}	
		
	}

}
