package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcBldgUseBMV implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def bu = params.bldguse 
		bu.basemarketvalue = params.expr.getDecimalValue()
	}
}