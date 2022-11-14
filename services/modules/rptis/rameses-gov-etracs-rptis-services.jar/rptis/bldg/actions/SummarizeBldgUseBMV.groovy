package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class SummarizeBldgUseBMV implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def bu = params.bldguse 
		def bf = params.bldgfloor
		bu.basemarketvalue += bf.basemarketvalue
	}
}