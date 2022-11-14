package treasury.facts;

import java.util.*;

public class SummaryBillItem extends AbstractBillItem {

	List<AbstractBillItem> items = [];
	def keys;

	public SummaryBillItem(def o ) {
		if(o.items) items = o.items;
		if(o.keys) keys = o.keys;
	}

	public SummaryBillItem() {}

	public int getSortorder() {
		if(items )  {
			return items*.sortorder.max();	
		}
		return 100000;	//just an arbitrary high number	
	}
	
	public def toMap() {
		def map = super.toMap();
		map.summary = true;
		return map;
	}

}