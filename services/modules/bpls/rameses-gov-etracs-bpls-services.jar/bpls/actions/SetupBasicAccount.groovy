package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;
import com.rameses.util.*;

public class SetupBasicAccount implements RuleActionHandler {
	
	def request;
	def BA;

	public void execute(def params, def drools) {
		def pmt = params.payment;	
		def lob = params.lob;
		def sa = params.account;

		def account = pmt.account;
		if(sa.key!=null && sa.key.trim()!='null') {
			def z = BA.findAccount( [objid: sa.key] );
			if(z) account = z;
		}
		else {
			account = BA.findAccount( [objid: account.objid ]);
		}
		def amt = pmt.amount;
		def key = [account: account, receivableid: pmt.receivableid];
		if(lob) {
			key.lob = [objid: lob.objid, name: lob.name];
		}	
		def acctMap = request.accounts;
		def val = acctMap.get(key);
		if(!val) {
			val = [:];	
			val.amount = 0;
			val.surcharge = 0;
			val.interest = 0;
			val.remarks = "";
			if(lob) {
				val.lob = [objid: lob.objid, name: lob.name];
			}		
			val.item = account;
			val.receivableid = pmt.receivableid;
			val.taxfeetype = pmt.taxfeetype;
 			if(val.taxfeetype == "TAX") val.sortorder = 1;
 			else if(val.taxfeetype == "REGFEE") val.sortorder = 2;
 			else val.sortorder = 3;
 			val.txntype = 'basic';
			acctMap.put( key, val);
		}		
		val.amount = NumberUtil.round( val.amount + amt );
		val.surcharge = NumberUtil.round(val.surcharge + pmt.surcharge);
		val.interest = NumberUtil.round(val.interest + pmt.interest);
		val.remarks = "";
		if(val.lob) val.remarks = val.lob.name;
		if(pmt.qtr) {
			if(!val.fromqtr || pmt.qtr <= val.fromqtr) val.fromqtr = pmt.qtr;
			if(!val.toqtr || pmt.qtr >= val.toqtr) val.toqtr = pmt.qtr;
			if( val.fromqtr != val.toqtr  ) 
				val.remarks += " [Q"+ val.fromqtr + "- Q" + val.toqtr + "]";
			else
				val.remarks += " [Q"+ val.fromqtr + "]";
		}


	}

}