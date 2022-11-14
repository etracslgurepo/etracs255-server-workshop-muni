package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class RemoveTaxFee implements RuleActionHandler {
	def request;
	public void execute(def params, def drools) {
		def tf = params.taxfee;
		def acctid = tf.acctid;
		def lob = tf.lob;
		def taxfees = request.taxfees;
		def facts = request.facts;
		facts.remove(tf);
		def test;
		if( !lob ) {
			test = taxfees.findAll{it.lob?.objid==null}.find{it.account.objid == acctid};
		}
		else {
			test = taxfees.findAll{it.lob?.objid!=null}.find{ it.lob.objid == lob.objid && it.account.objid == acctid };
		}
		if(test) {
			taxfees.remove(test);
		}	
	}
}
