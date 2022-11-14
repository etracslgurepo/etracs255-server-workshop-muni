package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class UpdateBasicAV implements RuleActionHandler {
	def numSvc

	public void execute(def params, def drools) {
		def avfact = params.avfact
		avfact.basicav = numSvc.round(params.expr.getDecimalValue())
	}
}	