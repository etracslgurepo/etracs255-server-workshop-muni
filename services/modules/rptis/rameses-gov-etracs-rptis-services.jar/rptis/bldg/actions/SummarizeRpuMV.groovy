package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class SummarizeRpuMV implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def rpu = params.rpu
		def assessment = params.assessment 
		rpu.totalmv += assessment.marketvalue
	}
}