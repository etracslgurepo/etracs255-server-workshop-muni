package treasury.actions;

import com.rameses.rules.common.*;
import market.facts.*;
import com.rameses.util.*;
import java.util.*;
import com.rameses.osiris3.common.*;
import treasury.facts.*;

public class SetBillItemDueDate implements RuleActionHandler {
	
	public void execute(def params, def drools) {
		def billitem = params.billitem;
		def duedate = params.duedate.eval();

		//check if there are overrides in the database for the dates:
		def ct = RuleExecutionContext.getCurrentContext();
		billitem.duedate = duedate;	
	}
}