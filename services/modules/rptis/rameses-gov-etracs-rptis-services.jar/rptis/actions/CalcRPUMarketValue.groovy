package rptis.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;


public class CalcRPUMarketValue implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def rpuassessment = params.rpuassessment
		rpuassessment.marketvalue = params.expr.getDecimalValue()
	}
}