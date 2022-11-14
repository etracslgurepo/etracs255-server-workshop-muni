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
class UpdateItemProperty  implements RuleActionHandler  {

	public void execute(def params, def drools) {
		def item = params.item;
		def propname = params.fieldname;
		def value = params.value.eval();
		item[(propname)] = value;
	}

}