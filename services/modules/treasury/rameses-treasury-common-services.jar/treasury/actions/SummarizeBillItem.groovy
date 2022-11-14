package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    billitem
*    type ( SUM, MAX, MIN )
****/
class SummarizeBillItem implements RuleActionHandler {

	public void execute(def params, def drools) {
		def billitem = params.billitem;
		def fields = params.fields;
		def remarks = params.remarks;

		if(!billitem)
			throw new Exception("treasury.actions.SummarizeBillItem");

		//add to keys, account is the default key 
		def keys = [billitem.account];	
		fields?.split(",").each { k->
			try {
				keys << billitem[k.trim()];
			}	
			catch(e){;}	
		}

		def ct = RuleExecutionContext.getCurrentContext();
		def facts = ct.facts;

		def obj = facts.find{ (it instanceof SummaryBillItem) && it.keys == keys  };
		if( !obj ) {
			obj = new SummaryBillItem();
			obj.keys = keys;
			obj.account = billitem.account;
			obj.dynamic = billitem.dynamic;
			obj.txntype = billitem.txntype;
			obj.sortorder = billitem.sortorder;
			facts << obj;
		};
		
		obj.items << billitem;
		obj.amount = NumberUtil.round(obj.items.sum{ it.amount });

		if(remarks!=null) {
			remarks.params.put("ITEM", obj);
			obj.remarks = remarks.eval();
		}

		//remove the billitem in the main facts and billitems
		facts.remove( billitem );
		drools.retract( billitem );		
	}

}