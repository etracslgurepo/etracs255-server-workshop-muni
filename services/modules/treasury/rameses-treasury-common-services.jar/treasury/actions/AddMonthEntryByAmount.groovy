package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    startdate, type (DAILY OR MONTHLY),  
****/
class AddMonthEntryByAmount implements RuleActionHandler {

	public void execute(def params, def drools) {
		def startdate = params.startdate;
		def dividend = params.dividend.decimalValue;
		def divisor = params.divisor.decimalValue;
		def type = params.type;
	}

}
