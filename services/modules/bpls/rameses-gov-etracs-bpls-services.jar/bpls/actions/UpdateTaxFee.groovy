package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class UpdateTaxFee implements RuleActionHandler {
	def request;
	public void execute(def params, def drools) {
		def amt = params.amount.doubleValue;
		def tf = params.taxfee;
		tf.amount = amt
		params.taxfee.data.amount = amt;
	}
}
