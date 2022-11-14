package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class CalcDiscount implements RuleActionHandler {
	def numSvc

	public void execute(def params, def drools) {
		def rli = params.rptledgeritem
		rli.discount = numSvc.round(params.expr.getDecimalValue())
	}
}	