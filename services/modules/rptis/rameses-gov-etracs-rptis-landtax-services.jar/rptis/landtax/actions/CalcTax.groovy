package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class CalcTax implements RuleActionHandler {
	def numSvc

	public void execute(def params, def drools) {
		def rli = params.rptledgeritem
		rli.amount = numSvc.round(params.expr.getDecimalValue())
		rli.amtdue = rli.amount 
	}
}	