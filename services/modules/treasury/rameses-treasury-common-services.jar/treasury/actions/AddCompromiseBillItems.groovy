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
class AddCompromiseBillItems extends AbstractAddBillItem {

	public void execute(def params, def drools) {

		def acct = params.account;
		def comp = params.compromise;

		def startdate = comp.startdate;
		double total = comp.amount;
		int numpayments = comp.numpayments;
		double amtpaid = com.amtpaid;
		double unitamt = NumberUtil.round( total / numpayments );

		def cal = Calendar.instance;
		double totalamt = total;
		def currdate = startdate;

		for( int i=0; i<numpayments; i++ ) {
		    if( amtpaid > unitamt ) {
		        amtpaid -= unitamt;    
		        totalamt -= unitamt;
		        continue;
		    }
		    double amt = 0.0;
		    if( amtpaid > 0 ) {
		        amt = NumberUtil.round( unitamt - amtpaid );
		        amtpaid = 0;
		    }
		    else {
		        amt = NumberUtil.round( (totalamt < unitamt) ? totalamt : unitamt );
		    }
		    totalamt -= unitamt;
		    def m = [:];
		    m.amount = amt;
		    m.index = i+1;

		    cal.setTime(startdate);            
		    cal.add( Calendar.MONTH, i );
		    m.duedate = cal.getTime();
		    m.year = cal.get(Calendar.YEAR);
			m.month = cal.get(Calendar.MONTH)+1;
			def billitem = new CompromiseBillItem( m );   
			setAccountFact( billitem, acct.key );
			addToFacts( billitem );
		}  

	}

}