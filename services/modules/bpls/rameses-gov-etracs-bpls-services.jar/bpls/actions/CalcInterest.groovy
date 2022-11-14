package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class CalcInterest implements RuleActionHandler {
	def request;
	def NS;
	def BA;

	public void execute(def params, def drools) {
		def tf = params.billitem;
		def amt = params.amount.doubleValue;
		def acct = params.account;

		try {
			if( amt == null )
				throw new Exception("Amount in CalcInterest must not be null");
			tf.interest = NS.round(amt);

			//do not remove this. this is needed for partial payment
			tf.total += NS.round(tf.interest);

			if(acct.key==null)
				throw new Exception("Interest account must be specified");
			def account = BA.findAccount( [objid: acct.key] );
			if(account==null) throw new Exception("Interest account not found");
			tf.interestaccount = account;
		}
		catch(e) {
			throw e;
		}	
	}
}