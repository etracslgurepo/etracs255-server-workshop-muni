package bpls.facts;

import java.util.*;
import treasury.facts.*;
import com.rameses.util.*;

/***************************************************
* Use for adding business tax
* this should be the last in pay priority 
****************************************************/
class AbstractBplsBillItem extends treasury.facts.BillItem {
	
	LOB lob;

	Date duedate;
	int year = 0;
	int qtr = 1;

	public int getPaypriority() {
       return ( (year *12) + (qtr*10) );
    }

}