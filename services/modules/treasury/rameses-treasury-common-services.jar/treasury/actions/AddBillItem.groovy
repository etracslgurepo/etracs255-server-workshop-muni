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
class AddBillItem extends AbstractAddBillItem {

	public void execute(def params, def drools) {
		def amt = params.amount.decimalValue;

		int t = 0;

		boolean hasAccount = ( params.account && params.account.key != "null" );
		boolean hasTxntype = ( params.txntype && params.txntype.key != "null" );
		boolean hasBillcode = ( params.billcode && params.billcode.key != "null" );

		if(!hasAccount && !hasTxntype && !hasBillcode)
			throw new Exception("AddBillItem error. Please specify an account, txntype or billcode in rule "  );

		def billitem = new BillItem(amount: NumberUtil.round( amt));
		if(  hasAccount ) {
			setAccountFact( billitem, params.account.key );
		}
		if( hasTxntype ) {
			billitem.txntype = params.txntype.key;
		}
		if( hasBillcode ) {
			billitem.billcode = params.billcode.key;
		}
		//set the other parameters
		if( params.year ) billitem.year = params.year.eval();	
		if( params.month ) billitem.month = params.month.eval();		
		if( params.fromdate ) billitem.fromdate = params.fromdate.eval();		
		if( params.todate ) billitem.todate = params.todate.eval();		
		if( params.remarks ) billitem.remarks = params.remarks.eval();
		if( params.refid) billitem.refid = params.refid;

		addToFacts( billitem );
	}

}