package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;


public class UpdateAdjustment implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def adj = params.adjustment
		adj.adjustment  = params.expr.getDecimalValue()
	}
}
