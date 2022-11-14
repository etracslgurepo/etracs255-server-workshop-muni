package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class CollectExcess implements RuleActionHandler {
	def request;
	def NS;
	public void execute(def m, def drools) {
		def ep = new ExcessPayment(NS.round(m.excess));
		drools.insert( ep );
		request.facts << ep;
		request.excess =  ep;
	}
}