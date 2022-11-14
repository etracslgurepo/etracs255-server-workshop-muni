package bpls.facts;

import java.util.*;
import treasury.facts.*;
import com.rameses.util.*;

/***************************************************
* Use for adding business tax
* this should be the last in pay priority 
****************************************************/
class TaxBillItem extends bpls.facts.AbstractBplsBillItem {
	
	String txntype = "tax";

	public int getPaypriority() {
		return (super.getPaypriority() + '05' ).toInteger();
    }

}