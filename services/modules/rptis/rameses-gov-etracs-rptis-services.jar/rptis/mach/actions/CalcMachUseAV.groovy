package rptis.mach.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.mach.facts.*;


public class CalcMachUseAV implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def machuse = params.machuse
		machuse.assessedvalue = params.expr.getDecimalValue()
	}
}