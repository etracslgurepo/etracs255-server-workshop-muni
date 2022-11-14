package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;
import com.rameses.util.*;

public class SetupTaxCreditAccount implements RuleActionHandler {
	
	def request;
	def BA;

	public void execute(def params, def drools) {
		def tc = params.excess;	
		def acct = params.account;
		try {
			def account = BA.findAccount( [objid: acct.key] );
			if(account==null) throw new Exception("Tax credit account not found");
			tc.account = account;
			request.excess = tc; 
		}
		catch(e) {
			throw e;
		}
	}

}