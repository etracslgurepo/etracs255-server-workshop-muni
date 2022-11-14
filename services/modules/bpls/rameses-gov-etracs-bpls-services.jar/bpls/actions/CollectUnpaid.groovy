package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class CollectUnpaid implements RuleActionHandler {
	def request;
	public void execute(def tf, def drools) {
		request.receivables << tf.toItem();
	}
}