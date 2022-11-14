package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class CollectFullPayment implements RuleActionHandler {
	def request;
	public void execute(def tf, def drools) {
		def m = tf.toItem();
		request.items << m;

		def p = new AppliedPayment();
		p.lob = tf.lob;
		p.account = tf.account;
		p.amount = m.amtdue;
		p.surcharge = m.surcharge;
		p.interest = m.interest;
		p.taxfeetype = m.taxfeetype;
		p.receivableid = m.receivableid;
		p.qtr = m.qtr;
		request.facts << p;
	}
}