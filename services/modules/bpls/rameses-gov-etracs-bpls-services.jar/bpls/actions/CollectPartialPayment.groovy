package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class CollectPartialPayment implements RuleActionHandler {
	def request;
	def NS;
	public void execute(def m, def drools) {
		def tf = m.billitem;
		def partialpmt = m.amtpaid;

		def oldAmt = tf.total;

		
		/*
		def oldAmtDue = tf.amtdue;
		def oldSurcharge = tf.surcharge;
		def oldInterest = tf.interest;
		def oldTotal = tf.total;
		def oldDisc = tf.discount;
		*/

		//distribute amount partially
		tf.amtdue = NS.round( tf.amtdue / tf.total * partialpmt );
		if( tf.surcharge > 0.0 ) {
			tf.surcharge = NS.round( tf.surcharge / tf.total * partialpmt );
		}
		if( tf.interest > 0.0 ) {
			tf.interest = NS.round( partialpmt - tf.amtdue - tf.surcharge );
		}
		if( tf.discount > 0.0 ) {
			tf.discount = NS.round( tf.discount / tf.total * partialpmt );
		}		
		tf.total = NS.round( tf.amtdue + tf.surcharge + tf.interest - tf.discount );
		tf.balance = NS.round( oldAmt - tf.total );

		def b = tf.toItem();
		b.partial = true;
		request.items << b;
	}
}
