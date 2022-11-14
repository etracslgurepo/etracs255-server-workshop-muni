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
class GroupBillItem implements RuleActionHandler {

	public void execute(def params, def drools) {
		def billitem = params.billitem;
		def groupfields = params.fields;

		if(!billitem)
			throw new Exception("treasury.actions.GroupBillItem billitem parameter is required");
		if(!groupfields)
			throw new Exception("treasury.actions.GroupBillItem fields parameter is required");


		def fldArr = groupfields.split(",");
		def groupKeys = [];
		fldArr.each { fname ->
			groupKeys << billitem[fname];			
		}


		def ct = RuleExecutionContext.getCurrentContext();
		def billitems = ct.result.billitems;
		def facts = ct.facts;

		def obj = billitems.find{ (it instanceof BillItem) &&   };
		if( !obj ) {
			obj = new SummaryBillItem();
			obj.account = billitem.account;
			obj.aggtype = aggtype;
			obj.dynamic = billitem.dynamic;
			obj.txntype = billitem.txntype;
			obj.sortorder = billitem.sortorder;
			billitems << obj;			
			facts << obj;
		}
		
		obj.items << billitem;

		//Calculate the amount 
		if(aggtype =="SUM" ) {
			obj.amount = obj.items.sum{ it.amount };
		}
		else if( aggtype == "COUNT") {
			obj.amount = obj.items.size();
		}
		else if( aggtype == "AVG" ) {
			obj.amount = obj.items.sum{ it.amount } / obj.items.size();
		}
		else if( aggtype == "MIN" ) {
			obj.amount = obj.items.min{ it.amount };
		}
		else if( aggtype == "MAX" ) {
			obj.amount = obj.items.max{ it.amount };
		}

		//remove the billitem in the main facts and billitems
		billitems.remove( billitem );
		facts.remove( billitem );
		drools.retract( billitem );		
	}

}