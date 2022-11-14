package treasury.facts;

import java.util.*;

public class CompromiseBillItem extends BillItem {

	int year;
	int month;
	Date duedate;

	public CompromiseBillItem(def o ) {
		super(o);
		if(o.year) year = o.year;
		if(o.month) month = o.month;
		if(o.duedate) duedate = o.duedate;
	}

	public CompromiseBillItem() {}

	public int hashCode() {
		return (super.hashCode() + (year+"-"+month)).hashCode();			
	}

    public int getPaypriority() {
       return (year*12)+month;
    }

}