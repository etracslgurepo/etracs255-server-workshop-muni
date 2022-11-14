package rptis.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;


public class CalcTotalRPUMarketValue implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def rpu = params.rpu
		rpu.totalmv = params.expr.getDecimalValue()
	}
}