package bpls.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import treasury.utils.*;
import com.rameses.osiris3.common.*;

class SplitBillItemByQtr implements RuleActionHandler {


	public void execute(def params, def drools) {
		def billitem = params.billitem;

		def amt = billitem.amount;

		def ct = RuleExecutionContext.getCurrentContext();		
		if( !ct.env.acctUtil ) ct.env.acctUtil = new ItemAccountUtil();

		def facts = ct.facts;
		facts.remove( billitem );

		//split the billitem into 4 qtrs;
		


	}


}