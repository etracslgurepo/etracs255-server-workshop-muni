package rptis.planttree.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;


public class CalcPlantTreeAdjustment implements RuleActionHandler {
	def request
	def NS 

	public void execute(def params, def drools) {
		def ptd = params.planttreedetail
		ptd.adjustment = NS.roundA(params.expr.getDecimalValue(), 2)
	}
}