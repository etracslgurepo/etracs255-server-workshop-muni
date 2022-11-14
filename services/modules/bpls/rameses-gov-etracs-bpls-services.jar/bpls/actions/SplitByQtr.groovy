package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class SplitByQtr implements RuleActionHandler {
	def request;
	def NS;
	public void execute(def params, def drools) {
		def tf = params.billitem;
		drools.retract( tf );
		request.facts.remove( tf );

		def amount = tf.amount;
		def amtpaid = tf.amtpaid;
		def divisor = NS.round( amount / 4 );

		for( int i=1; i<=4; i++) { 
			def amt = ((i==4) ? amount : divisor);
			amount = NS.round(amount-divisor);  
			if( amtpaid >= amt ) {
				amtpaid = NS.round(amtpaid - amt);
				continue;
			}	
			def _tf = new BillItem();
			_tf.objid = tf.objid + "_" + i;
			_tf.application = tf.application;
			_tf.acctid = tf.acctid;
			_tf.type = tf.type;
			_tf.amount = amt;
			_tf.amtpaid = amtpaid;
			_tf.amtdue = amt - amtpaid;
			_tf.fullamtdue = tf.fullamtdue;
			_tf.total = amt - amtpaid;
			_tf.qtr = i;
			_tf.year = tf.year;
			_tf.expired = false;
			_tf.account = tf.account;
			_tf.lob = tf.lob;
			_tf.receivableid = tf.receivableid;
			_tf.paypriority = tf.paypriority+i;
			_tf.assessmenttype = tf.assessmenttype;
			request.facts << _tf;
			drools.insert( _tf );
			amtpaid = 0;		    
		}
	}
}
