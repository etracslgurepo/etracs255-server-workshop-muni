package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class SummarizeFloorArea implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def bu = params.bldguse 
		def bf = params.bldgfloor
		
		bu.area += bf.area
		bu.bldgstructure.totalfloorarea += bf.area
		bu.bldgstructure.rpu.totalareasqm += bf.area
		bu.bldgstructure.rpu.totalareaha += NS.roundA(bf.area / 10000, 4)
	}
}