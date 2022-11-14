package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;


public class CalcMarketValue implements RuleActionHandler {
	def request;
	def NS;

	public void execute(def params, def drools) {
		def ld = params.landdetail
		ld.marketvalue = params.expr.getDecimalValue()
	}
}