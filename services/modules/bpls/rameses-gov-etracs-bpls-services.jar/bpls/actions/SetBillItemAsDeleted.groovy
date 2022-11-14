package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class SetBillItemAsDeleted implements RuleActionHandler {

	def request;

	public void execute(def params, def drools) {
		def billitem = params.billitem;
		billitem.deleted = true;
		drools.update(billitem);
	}
}

