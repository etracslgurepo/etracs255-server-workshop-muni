package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcFloorMV implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def bf = params.bldgfloor
		bf.marketvalue = params.expr.getDecimalValue()
	}
}