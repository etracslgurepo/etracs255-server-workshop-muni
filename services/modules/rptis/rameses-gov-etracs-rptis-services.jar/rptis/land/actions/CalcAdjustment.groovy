package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;


public class CalcAdjustment implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def adj = params.adjustment
		def ld = params.landdetail

		def val = params.expr.getDecimalValue()
		if (!val) val = 0.0
		adj.adjustment = NS.roundA( adj.adjustment + val, 2)
		adj.basemarketvalue += ld.basemarketvalue
		adj.marketvalue += ld.marketvalue
		ld.adjustment = NS.roundA( ld.adjustment + val, 2)
		
		if (adj.type == 'LV')
			ld.landvalueadjustment = NS.roundA( ld.landvalueadjustment + val, 2)
		else
			ld.actualuseadjustment = NS.roundA( ld.actualuseadjustment + val, 2)
	}
}
