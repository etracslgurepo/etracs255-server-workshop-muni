package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    billitem
*    amount 
****/
class AddBillSubItem extends AbstractAddBillItem {

	public def createSubItemFact( def billitem, def amt) {
		def subItem = new BillSubItem(parent: billitem);
		subItem.amount = NumberUtil.round(amt);
		return subItem;
	}

	public void execute(def params, def drools) {
		def billitem = params.billitem;
		if( params.amount == null ) throw new Exception("Please specify amount in AddBillSubItem of " + drools.rule.name );
		if( billitem == null ) throw new Exception("Please add billitem in AddBillSubItem of " + drools.rule.name );

		boolean hasAccount = ( params.account && params.account.key != "null" );
		boolean hasTxntype = ( params.txntype && params.txntype.key != "null" );
		boolean hasBillcode = ( params.billcode && params.billcode.key != "null" );

		if(!hasAccount && !hasTxntype && !hasBillcode)
			throw new Exception("AddBillSubItem error. Please specify an account, txntype or billcode in rule "  );

		def amt = params.amount.doubleValue;

		def subItem = createSubItemFact(  billitem, amt );
		if(  hasAccount ) {
			def acct = params.account;
			def ct = RuleExecutionContext.getCurrentContext();		
			if( ct.env.acctUtil ) {
				subItem.account = ct.env.acctUtil.createAccountFact( [objid: acct.key] );			
			}
			else {
				subItem.account = new Account( objid: acct.key, code: acct.value, title: acct.value);
			}
			//setAccountFact( subItem, params.account.key );
		}
		if( hasTxntype ) {
			subItem.txntype = params.txntype.key;
		}
		if( hasBillcode ) {
			subItem.billcode = params.billcode.key;
		}

		boolean b = billitem.items.add(subItem);

		//add to facts so it can be evaluated...
		if(b) {
			getFacts() << subItem;	
		}
	}

}