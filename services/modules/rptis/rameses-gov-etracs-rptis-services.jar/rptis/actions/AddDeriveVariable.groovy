package rptis.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;


public class AddDeriveVariable implements RuleActionHandler {
	def request
	
	public void execute(def params, def drools) {
		def refid = params.refid 
		def varid = params.var.key
		def objid = params.var.key + refid
		def value = params.expr.getDecimalValue()

		def v = request.variables.find{it.objid == objid}
		if ( ! v){
			v = new RPTVariable(refid, objid, varid, value, params.aggregatetype)
			request.variables << v 
			request.facts << v 
			drools.insert( v )
		}
		else{
			v.updateValue(value)
			drools.update(v)
		}
	}
}