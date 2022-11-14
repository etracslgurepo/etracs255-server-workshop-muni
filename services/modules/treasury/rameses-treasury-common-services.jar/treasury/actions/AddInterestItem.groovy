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
class AddInterestItem extends AddBillSubItem {

	public def createSubItemFact( def billitem, def amt ) {
		return new InterestItem(parent: billitem, amount: NumberUtil.round(amt), txntype:"interest");
	}

}