package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    billitem
*    account 
*    amount 	
****/
class AddDiscountItem extends AddBillSubItem {

	public def createSubItemFact( def billitem, def amt ) {
		return new DiscountItem(parent: billitem, amount: NumberUtil.round((amt * -1)), txntype:"discount");
	}

}