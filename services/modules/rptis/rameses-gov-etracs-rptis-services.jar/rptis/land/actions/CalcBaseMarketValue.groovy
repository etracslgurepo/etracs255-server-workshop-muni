package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;


public class CalcBaseMarketValue implements RuleActionHandler {
	def request;
	def NS;

	public void execute(def params, def drools) {
		def landdetail = params.landdetail
		landdetail.basemarketvalue = NS.round(params.expr.getDecimalValue())
	}
}