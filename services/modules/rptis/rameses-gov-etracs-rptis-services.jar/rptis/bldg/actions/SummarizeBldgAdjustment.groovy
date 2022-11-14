package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class SummarizeBldgAdjustment implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def bf = params.bldgfloor
		def adj = params.adjustment

		bf.adjustment += adj.amount 
		bf.bldguse.adjustment += adj.amount 
		bf.bldguse.bldgstructure.rpu.totaladjustment += adj.amount 
	}
}