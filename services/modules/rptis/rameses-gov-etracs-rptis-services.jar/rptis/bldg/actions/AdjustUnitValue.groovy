package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class AdjustUnitValue implements RuleActionHandler {
	def request
	def NS 

	public void execute(def params, def drools) {
		def bs = params.bldgstructure
		bs.unitvalue = NS.round(params.expr.getDecimalValue())
	}
}