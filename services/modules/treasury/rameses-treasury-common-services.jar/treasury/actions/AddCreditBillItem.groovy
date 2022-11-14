package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;


/***
* Description: Simple Add of Item. Item is unique based on the account. 
* This is used for overpayment
* Parameters:
*    account 
*    amount
****/
class AddCreditBillItem extends AddBillItem {

	public void execute(def params, def drools) {
		def amt = params.amount.decimalValue;

		boolean hasAccount = ( params.account && params.account.key != "null" );
		boolean hasTxntype = ( params.txntype && params.txntype.key != "null" );
		boolean hasBillcode = ( params.billcode && params.billcode.key != "null" );

		if(!hasAccount && !hasTxntype && !hasBillcode)
			throw new Exception("AddCreditBillItem error. Please specify an account, txntype or billcode in rule "  );

		def billitem = new CreditBillItem(amount: NumberUtil.round( amt), txntype: 'credit');
		if(  hasAccount ) {
			setAccountFact( billitem, params.account.key );
		}
		if( hasTxntype ) {
			billitem.txntype = params.txntype.key;
		}
		if( hasBillcode ) {
			billitem.billcode = params.billcode.key;
		}

		getFacts().add( billitem );
	}


}