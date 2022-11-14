package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class CollectItem implements RuleActionHandler {
	def request;
	public void execute(def tf, def drools) {
		request.items << tf.toItem();
	}
}