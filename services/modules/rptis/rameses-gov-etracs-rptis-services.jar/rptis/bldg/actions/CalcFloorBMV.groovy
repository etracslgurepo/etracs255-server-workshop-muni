package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcFloorBMV implements RuleActionHandler {
	def request
	def NS 

	public void execute(def params, def drools) {
		def bf = params.bldgfloor
		bf.basemarketvalue = NS.round(params.expr.getDecimalValue())
	}
}