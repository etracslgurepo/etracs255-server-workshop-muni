package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcAdjustment implements RuleActionHandler {
	def request
	def NS

	public void execute(def params, def drools) {
		def adj= params.adjustment
		def var = params.var 
		adj.amount = NS.round( params.expr.getDecimalValue() )
		if (var){
			//update variable value 
			def param = adj.entity.params.find{it.param.objid == var.varid}
			if (param)
				param.decimalvalue = new java.math.BigDecimal(var.value +'')
		}
	}
}