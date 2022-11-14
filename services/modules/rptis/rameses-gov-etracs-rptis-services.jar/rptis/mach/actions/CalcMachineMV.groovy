package rptis.mach.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.mach.facts.*;


public class CalcMachineMV implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def machine = params.machine
		machine.marketvalue = params.expr.getDecimalValue()
	}
}