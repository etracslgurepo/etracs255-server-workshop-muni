package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class SummarizeRpuBMV implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def rpu = params.rpu
		def bu = params.bldguse 
		rpu.totalbmv += bu.basemarketvalue
	}
}