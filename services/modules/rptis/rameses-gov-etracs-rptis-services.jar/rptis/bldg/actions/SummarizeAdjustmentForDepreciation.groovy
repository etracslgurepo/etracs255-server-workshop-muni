package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class SummarizeAdjustmentForDepreciation implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def bf = params.bldgfloor
		def adj = params.adjustment

		if (bf.bldguse.adjfordepreciation == null)
			bf.bldguse.adjfordepreciation = 0.0
		bf.bldguse.adjfordepreciation += adj.amount 

		println 'SummarizeAdjustmentForDepreciation ... ' + bf.bldguse.adjfordepreciation
	}
}