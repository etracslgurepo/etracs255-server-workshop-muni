package rptis.misc.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.misc.facts.*;


public class CalcDepreciation implements RuleActionHandler {
	def request;

	public void execute(def params, def drools) {
		def miscitem = params.miscitem
		miscitem.depreciatedvalue = params.expr.getDecimalValue()
	}
}