package treasury.utils;

import com.rameses.rules.common.*;
import com.rameses.osiris3.common.*;
import com.rameses.util.*;
import treasury.facts.*;

public class ItemAccountUtil {
	
	private def map = [:];
	private def svc;

	public def lookup( def acctid ) {
		if(svc==null) {
			svc = ServiceLookup.create( "ItemAccountLookupService", "financial");
		}
		if( ! map.containsKey(acctid)) {
			def m = svc.lookup( [objid: acctid] );	
			if( !m ) throw new Exception("Account not found in item account.  " );
			map.put(acctid, m );
		}
		return map.get(acctid);		
	}
 
	public def createAccountFact(def v) {
		def acct = lookup(v.objid);
		return buildAccountFact( acct );
	}

	public def createAccountFactByOrg( def parentid, def orgid ) {
		if(svc==null) {
			svc = ServiceLookup.create( "ItemAccountLookupService", "financial");
		}
		def o = svc.lookupByOrg([ parentid: parentid , orgid: orgid ]); 
		if ( o ) {
			return buildAccountFact( o );
		} 
		return null; 
	}

	public def buildAccountFact(def acct ) {
		Fund f = null;
		if( acct.fund?.objid  ) {
			f = new Fund( objid: acct.fund.objid, code: acct.fund.code, title: acct.fund.title);
		}
		def ac = new Account( objid: acct.objid, code: acct.code, title: acct.title, fund: f);
		if( acct.parentaccount?.objid  ) {
			def pac = acct.parentaccount;
			ac.parentaccount = new Account(objid: pac.objid, code: pac.code, title: pac.title,   )
		}
		return ac;
	}


	public def lookupIdByParentAndOrg( def parentid, def orgid ) {
		if(svc==null) {
			svc = ServiceLookup.create( "ItemAccountLookupService", "financial");
		}; 
		return svc.lookupByOrg( [parentid:parentid, orgid: orgid ])?.objid;
	}

}