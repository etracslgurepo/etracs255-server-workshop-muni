package rptis.planttree.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;


public class CalcPlantTreeBaseMarketValue implements RuleActionHandler {
	def request;
	def NS;

	public void execute(def params, def drools) {
		def planttreedetail = params.planttreedetail
		planttreedetail.basemarketvalue = NS.round(params.expr.getDecimalValue())
	}
}