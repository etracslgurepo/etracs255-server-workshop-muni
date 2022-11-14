package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class SelectTaxFee implements RuleActionHandler {
	def request;
	public void execute(def params, def drools) {
		def taxfeefacts = request.taxfeefacts;
		def tf = params.taxfeeaccount;
		def selectoption = params.selectoption;

		def data = tf.data;
		data.lob = null;
		def test = taxfeefacts.find{ it.account?.objid == tf.acctid };
		if(!test) {
			taxfeefacts << data;
		}
		else {
			def torep=null;
			if(selectoption == "MIN" ) {
				if(test.amount > data.amount) {
					taxfeefacts.remove( test );	
					taxfeefacts << data;				
					torep = test;
				}
				else {
					torep = data;
				}	
			} 
			else if (selectoption == "MAX") {
				if(test.amount < data.amount ) {
					taxfeefacts.remove(test);
					taxfeefacts << data;
					torep = test;
				}	
				else {
					torep = data;
				}	
			}
			else if (selectoption == "SUM") {
				torep = data; 
				test.amount = test.amount + data.amount; 
			} 

			def z = request.taxfees.find{ it.objid == torep.objid };
			request.taxfees.remove(z);
			//remove from facts
			def f = request.facts.findAll{ it.class.name == "bpassessment.TaxFeeAccount" }.find{ it.objid == torep.objid };
			request.facts.remove(f);
		}
	}
}
