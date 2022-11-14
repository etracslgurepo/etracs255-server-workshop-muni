package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;


/***
* Description: Simple Add of Item. Item is unique based on the account. 
* Parameters:
*    account 
*    amount
****/
class AddOrgBillItem extends AbstractAddBillItem {

	public void execute(def params, def drools) {

		def acct = params.parentaccount;
		def org = params.org;
		def amt = params.amount.decimalValue;

		def acctid = getAccountFactByOrgAndParent( acct.key, org.orgid );
		if(!acctid)
			throw new Exception("RuleAction AddOrgBillItem error. No record found having parent "+acct.value + " org:" + org.orgid );

		def billitem = new BillItem(amount: NumberUtil.round( amt));
		if( params.txntype?.key ) {
			billitem.txntype = params.txntype.key;
		}
		setAccountFact( billitem, acctid );
		addToFacts( billitem );
	}

}