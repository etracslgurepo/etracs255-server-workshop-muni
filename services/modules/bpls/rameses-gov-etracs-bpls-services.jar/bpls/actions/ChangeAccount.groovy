package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class ChangeAccount implements RuleActionHandler {
	def request;
	def BA;
	public void execute(def params, def drools) {
		def acct = params.account;
		def tf = params.taxfee;
		def acctid = tf.acctid;
		def lob = tf.lob;
		def taxfees = request.taxfees;
		def test;

		if( !lob ) {
			test = taxfees.findAll{it.lob?.objid==null}.find{it.account.objid == acctid};
		}
		else {
			test = taxfees.findAll{it.lob?.objid!=null}.find{ it.lob.objid == lob.objid && it.account.objid == acctid };
		}
		if(test) {
			test.account = BA.findAccount( [objid: acct.key] );
		}				
	}

}