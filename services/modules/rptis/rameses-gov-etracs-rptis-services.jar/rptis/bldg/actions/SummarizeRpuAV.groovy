package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class SummarizeRpuAV implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def rpu = params.rpu
		def assessment = params.assessment 
		rpu.totalav += assessment.assessedvalue
	}
}