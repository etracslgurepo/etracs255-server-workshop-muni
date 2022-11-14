package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    billitem
*    amount 
****/
class UpdateBillItemAmount implements RuleActionHandler {

	public void execute(def params, def drools) {

		def amt = params.amount.decimalValue;
		def bi = params.billitem;
		def type = params.type;

		if( type == 'ADD' ) {
			bi.amount += amt;	
		}
		else {
			bi.amount = amt;	
		}
	}

}