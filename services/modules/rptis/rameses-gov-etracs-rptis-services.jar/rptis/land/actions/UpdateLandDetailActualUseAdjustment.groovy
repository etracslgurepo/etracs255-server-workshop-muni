package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;


public class UpdateLandDetailActualUseAdjustment implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def landdetail = params.landdetail 
		landdetail.actualuseadjustment = params.expr.getDecimalValue()
	}
}
