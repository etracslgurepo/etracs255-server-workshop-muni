package treasury.utils;

import com.rameses.rules.common.*;
import com.rameses.osiris3.common.*;
import com.rameses.util.*;
import treasury.facts.*;
import enterprise.facts.*;

public class BillItemProvider {
	
	def itemAcctUtil = new ItemAccountUtil();

	public def createFact(def v1 ) {
		def v = MapBeanUtils.copy( v1 );  
		def acct = null;
		Fund f = null;
		if(v.item?.objid) {
			acct = itemAcctUtil.lookup( v.item.objid );
		}

		/*
		def info = [:];
		info.parentid = v.parentid;
		info.refid = v.refid;
		info.reftype = v.reftype;
		*/
		if( acct ) {
			if( acct.fund?.objid  ) {
				f = new Fund( objid: acct.fund.objid, code: acct.fund.code, title: acct.fund.title);
			}

			def ac = new Account( objid: acct.objid, code: acct.code, title: acct.title, fund: f);
			if( acct.parentaccount?.objid ) {
				def pac = acct.parentaccount;
				ac.parentaccount = new Account( objid: pac.objid, code: pac.code, title: pac.title, fund: f);
			}
			if( acct.org?.objid ) {
				ac.org = new Org( orgid: acct.org.objid );
			} 
			v.account = ac;
		}
		/*
		info.txntype = v.txntype;
		info.amount = v.amount;

		if(v.principal) info.principal = v.principal;
		if(v.sortorder) info.sortorder = v.sortorder;
		if(v.remarks) info.remarks = v.remarks;
		if(v.duedate) info.duedate = v.duedate;


		//for month bill items
		if(v.year) info.year = v.year;
		if(v.month) info.month = v.month;
		if(v.fromdate) info.fromdate = v.fromdate;
		if(v.todate) info.todate = v.todate;
		*/
		return createBillItemFact( v );
	}

	def createBillItemFact = { o-> 
		if(o.month && o.year) {
			return new MonthBillItem(o);
		}
		else {
			return new BillItem(o); 	
		}
	};

}