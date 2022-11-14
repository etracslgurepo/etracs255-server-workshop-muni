package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import treasury.utils.*;
import com.rameses.osiris3.common.*;
import com.rameses.functions.*;



public class UpdateMonthYearPeriod implements RuleActionHandler {

	public void execute(def params, def drools) {
		def me = params.monthentry;
		me.fromdate = params.fromdate.eval();
		me.todate = params.todate.eval();
	}

}