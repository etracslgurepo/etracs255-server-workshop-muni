package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class UpdateAV implements RuleActionHandler {
	def numSvc

	public void execute(def params, def drools) {
		def avfact = params.avfact
		avfact.av = numSvc.round(params.expr.getDecimalValue())
	}
}	