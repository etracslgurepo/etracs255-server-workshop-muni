package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcAssessValue implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def assessment = params.assessment
		assessment.assessedvalue = params.expr.getDecimalValue()
	}
}