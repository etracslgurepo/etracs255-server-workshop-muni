package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcBldgEffectiveAge implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def rpu = params.rpu 
		rpu.effectiveage = params.expr.getIntValue()
	}
}