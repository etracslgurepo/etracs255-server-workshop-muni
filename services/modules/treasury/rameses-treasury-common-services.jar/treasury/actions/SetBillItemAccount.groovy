package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;
import treasury.utils.*;

/***
* Parameters:
*    billitem
*    account
****/
class SetBillItemAccount implements RuleActionHandler {

	public void execute(def params, def drools) {
		def billitem = params.billitem;
		def acct = params.account;
		def billcode = params.billcode;

		boolean hasAccount = ( acct && acct.key != "null" );
		boolean hasBillcode = ( billcode && billcode.key != "null" );

		if(!hasAccount && !hasBillcode) throw new Exception("SetBillItemAccount error. Please indiciate an account or billcode" );

		if( hasAccount ) {
	 		def ct = RuleExecutionContext.getCurrentContext();		
			if( ct.env.acctUtil ) {
				billitem.account = ct.env.acctUtil.createAccountFact( [objid: acct.key] );			
			}
			else {
				billitem.account = new Account( objid: acct.key, code: acct.value, title: acct.value);
			}
		}
		else {
			billitem.billcode = billcode.key;
		}
	}

}