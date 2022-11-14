package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class SelectOneSurcharge implements RuleActionHandler {

	def request;

	public void execute(def params, def drools) {
		def billitems = request.facts.findAll{( it.toString().startsWith('bpls.facts.BillItem'))} 
		def taxfees = billitems.findAll{ it.type == 'TAX' }
		taxfees.groupBy{ it.lob?.objid }.each{ k,v-> 
			v.sort{ it.year.toString() + it.qtr.toString() } 
			def vmin = v.min{ it.qtr } 
			if ( !vmin ) return; 

			v.each{
				if ( it.qtr != vmin.qtr ) { 
					it.removeSurcharge(); 
				} 
			}
		}
	}
}
