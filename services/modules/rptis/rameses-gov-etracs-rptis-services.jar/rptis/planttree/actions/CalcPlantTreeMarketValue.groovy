package rptis.planttree.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;


public class CalcPlantTreeMarketValue implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def ptd = params.planttreedetail
		ptd.marketvalue = params.expr.getDecimalValue()
	}
}