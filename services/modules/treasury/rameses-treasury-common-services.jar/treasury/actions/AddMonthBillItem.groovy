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
class AddMonthBillItem extends AbstractAddBillItem {

	public MonthBillItem createMonthBillItem(def params) {
		if(!params.account && !params.txntype ) {
			throw new Exception("AddMonthBillItem error. Please specify an account or txntype in rule");
		}
		return new MonthBillItem();		
	}

	public void execute(def params, def drools) {
		def me = params.monthentry;
		def amt = params.amount.decimalValue;
		def remarks = null;

		def billitem = createMonthBillItem(params) ;
		billitem.amount = NumberUtil.round( amt);
		billitem.year = me.year;
		billitem.month = me.month;
		billitem.fromdate = me.fromdate;
		billitem.todate = me.todate;

		if( params.txntype?.key &&  params.txntype.key != 'null' ) {
			billitem.txntype = params.txntype.key;
		}
		if( params.remarks ) {
			billitem.remarks = params.remarks.eval();		
		}

		def acct = params.account;
		if( acct  ) {
			setAccountFact( billitem, acct.key );
		}
		addToFacts( billitem );
	}

}