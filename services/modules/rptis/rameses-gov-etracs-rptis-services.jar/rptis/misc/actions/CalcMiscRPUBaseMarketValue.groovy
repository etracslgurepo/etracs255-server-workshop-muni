package rptis.misc.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.misc.facts.*;


public class CalcMiscRPUBaseMarketValue implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def miscrpu = params.miscrpu
		miscrpu.basemarketvalue = params.expr.getDecimalValue()
	}
}