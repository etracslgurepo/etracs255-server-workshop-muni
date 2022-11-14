package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;


/***
* Description: Simple Add of Item. Item is unique based on the account. 
* Parameters:
*    billitem
*    fieldname
*    value 
****/
class SetBillItemProperty  implements RuleActionHandler  {

	public void execute(def params, def drools) {
		def billitem = params.billitem;
		def propname = params.fieldname;
		def value = params.value.eval();

		billitem[(propname)] = value;
	}

}