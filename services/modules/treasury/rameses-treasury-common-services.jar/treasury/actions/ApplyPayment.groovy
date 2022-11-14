package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    billitem
* If there are credit bill items, do the ff:
*   add the credit bill amount to payment (make sure to make this positive first because this is a negative value)
*   
****/
class ApplyPayment implements RuleActionHandler {

	public void execute(def params, def drools) {
		def payment = params.payment;

		if(!payment) throw new Exception("Payment fact is required in ApplyPayment action");

		def ct = RuleExecutionContext.getCurrentContext();
		def facts = ct.facts;

		double amt = payment.amount;

		def billitems = facts.findAll{ it instanceof BillItem }.sort{it.paypriority};

		if(billitems) {

			def newBillItems = [];
			
			/******************************************************************************
			* This is already a tested routine. If you cannot get the desired result
			* please check the payment priority order. 
			*******************************************************************************/
			for( BillItem b: billitems ) {
				amt = b.applyPayment( amt );
				newBillItems << b;
				if( amt == 0 ) break;
			}

			//remove all billitems in facts
			def removeList = facts.findAll{ it instanceof AbstractBillItem };
			facts.removeAll( removeList );
			
			removeList.each {
				drools.retract( it );
			}

			//add new facts
			for(b in newBillItems) {
				facts << b;
				for(bi in b.items) {
					facts << bi;
				}		
			}
		}
		
		//add excess payment if any... remove total credit so you can target the correct value.
		if(  amt > 0 ) {
			//amt = amt - totalCredit;	
			def ep = new ExcessPayment( amount: amt );
			facts << ep;
			drools.insert( ep );
		}	

		//effect immediately in the drools engine removal of the payment so it can be used again
		facts.remove( payment );
		drools.retract(payment);
		
	}

}
