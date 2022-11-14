package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcBldgUseDepreciation implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def bu = params.bldguse
		bu.depreciationvalue = NS.round( params.expr.getDecimalValue() )
	}
}