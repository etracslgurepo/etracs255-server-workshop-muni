package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class CalcDiscount implements RuleActionHandler {
	def request;
	def NS;
	public void execute(def params, def drools) {
		def tf = params.billitem;
		def amt = params.amount.doubleValue;
		tf.discount = NS.round(amt);
		tf.total -= NS.round( tf.discount );
	}
}