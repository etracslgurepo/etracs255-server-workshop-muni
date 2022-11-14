package rptis.mach.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.mach.facts.*;


public class CalcMachineAV implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def machine = params.machine
		machine.assessedvalue = params.expr.getDecimalValue()
	}
}