package rptis.landtax.actions;

import com.rameses.rules.common.*;
import com.rameses.common.*;

public class SetBillExpiryDate implements RuleActionHandler {
	def request
	def dateFormatter = new  java.text.SimpleDateFormat("yyyy-MM-dd");

	public void execute(def params, def drools) {
		def bill = params.bill
		def expr = params.expr 

		def dt = ExpressionResolver.getInstance().eval( expr.statement, expr.params )
		if (!dt){
			throw new Exception('Bill Expiry date cannot be set. Date cannot be null.')
		}

		bill.expirydate = dateFormatter.parse(dateFormatter.format(dt)) + 1 
		
	}
}	