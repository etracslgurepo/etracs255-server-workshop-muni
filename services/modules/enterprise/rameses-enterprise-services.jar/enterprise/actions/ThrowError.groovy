package enterprise.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import enterprise.facts.*;

public class ThrowError implements RuleActionHandler {

	public void execute(def params, def drools) {
		def ct = RuleExecutionContext.getCurrentContext();

		def msg = params.message.getStringValue();
		if(!ct.errs) ct.errs = [];

		ct.errs << msg;
	}
	
}