package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcBldgUseMV implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def bu = params.bldguse 
		bu.marketvalue = params.expr.getDecimalValue()
	}
}