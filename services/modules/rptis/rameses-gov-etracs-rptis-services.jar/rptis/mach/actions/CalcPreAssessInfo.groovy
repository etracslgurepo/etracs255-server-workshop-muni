package rptis.mach.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.mach.facts.*;


public class CalcPreAssessInfo implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def machuse = params.machuse
		machuse.basemarketvalue  = 0.0
		machuse.marketvalue      = 0.0
        machuse.assesslevel      = 0.0
        machuse.assessedvalue    = 0.0
	}
}