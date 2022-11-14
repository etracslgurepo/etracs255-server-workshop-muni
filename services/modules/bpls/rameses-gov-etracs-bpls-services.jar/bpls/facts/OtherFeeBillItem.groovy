package bpls.facts;

import java.util.*;
import treasury.facts.*;
import com.rameses.util.*;

class OtherFeeBillItem extends bpls.facts.AbstractBplsBillItem {
	
	String txntype = "other";

	public int getPaypriority() {
       return (super.getPaypriority() + '03' ).toInteger();
    }

}