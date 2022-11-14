import treasury.facts.*;
import com.rameses.util.*;

class RegFeeBillItem extends bpls.facts.AbstractBplsBillItem {
	
	String txntype = "regfee";

	public int getPaypriority() {
       return (super.getPaypriority() + '04' ).toInteger();
    }

}