package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class ResetAdjustment implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def adj= params.adjustment
		adj.resetValue();
	}
}