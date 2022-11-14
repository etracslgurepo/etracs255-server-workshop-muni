package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import treasury.utils.*;
import com.rameses.osiris3.common.*;

class SplitBillItemByQtr  implements RuleActionHandler {

	public void execute(def params, def drools) {

		def billitem = params.billitem;

		def amt = billitem.amount;
		def principal = billitem.principal;
		def amtpaid = billitem.amtpaid;

		def ct = RuleExecutionContext.getCurrentContext();		

		def facts = ct.facts;
		facts.remove( billitem );

		//split the billitem into 4 qtrs;
		def qprincipal = NumberUtil.round( principal / 4 );

		def facts = [];
		for(int i=1; i<=4; i++) {
		    def clone = billitem.clone();
		    clone.qtr = i;    
		    if( i != 4 ) {
		        clone.principal = qprincipal;
		    }
		    else {
		        clone.principal = NumberUtil.round( principal - (qprincipal*3));
		    }
		    if( amtpaid >= 0 ) {
		        clone.amtpaid = (amtpaid > clone.principal ) ? clone.principal : amtpaid;
		        amtpaid = amtpaid - clone.amtpaid;
		    }
		    clone.amount = clone.principal - clone.amtpaid;
		    if( clone.amount > 0 ) {
		        facts << clone;        
		    }
		}

	}


}