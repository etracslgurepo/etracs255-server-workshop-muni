package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;


/***
* Description: Simple Add of Item. Item is unique based on the account. 
* Parameters:
*    object
*    fieldname
*    value 
****/
class UpdateFieldValue  implements RuleActionHandler  {

	public void execute(def params, def drools) {

		def object = params.object;
		def propname = params.fieldname;
		def value = params.value;

		def rulename = drools.rule.name;

		if( object ==null ) throw new Exception("UpdateFieldValue error of rule " + rulename  + " . object parameter is required");
		if( propname ==null ) throw new Exception("UpdateFieldValue error of rule " + rulename  + ". fieldname parameter is required");
		if( value ==null ) throw new Exception("UpdateFieldValue error of rule " + rulename  + ". value parameter is required");

		object[(propname)] = value.eval();
	}

}