package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;



class AddRevenueShare implements RuleActionHandler  {

	public void execute(def params, def drools) {

		def refitem = params.refitem;
		def payableaccount = params.payableaccount;
		def amt = params.amount.decimalValue;
		def org = params.org;

		if( refitem == null )
			throw new Exception("refitem is required in AddRevenueShare action. Please indicate a ref item. Check the rule " + drools.rule.name );

		if( payableaccount?.key == null || payableaccount?.key == 'null' )
			throw new Exception("Payable account or generic payable account is required in AddRevenueShare action. Check the rule " + drools.rule.name);

		def ct = RuleExecutionContext.getCurrentContext();
		def rs = new RevenueShare();
		rs.receiptitemid = refitem.refid;
		
		rs.refitem = ct.env.acctUtil.createAccountFact( [objid: refitem.account.objid] );

		if( org == null ) {
			rs.payableitem = ct.env.acctUtil.createAccountFact( [objid: payableaccount.key] );	
		}
		else {
			rs.payableitem = ct.env.acctUtil.createAccountFactByOrg( payableaccount.key, org.orgid ); 
			if ( !rs.payableitem ) throw new Exception('There is no payable account with parent '+ payableaccount.value + ' org '+ org?.orgid);
		}

		rs.amount  = amt;
		if (!ct.result.sharing) {
			ct.result.sharing = []
		}
		ct.facts << rs;
	}

}