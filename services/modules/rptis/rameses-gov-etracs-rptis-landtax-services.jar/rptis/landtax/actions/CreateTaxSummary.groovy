package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;


public class CreateTaxSummary implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def rli = params.rptledgeritem
		rli.revperiod = params.revperiod

		def item = [:]
		item.ledger = rli.ledger 
		item.revtype = rli.revtype 
		item.revperiod = params.revperiod 

		def var = request.facts.findAll{it instanceof RPTLedgerTaxSummaryFact}
					.find{it.revtype == item.revtype && it.revperiod == item.revperiod}

		if (! var){
			var = new RPTLedgerTaxSummaryFact(item)
			request.facts << var 
		}

		var.amount  += rli.amtdue
		var.interest += rli.interest
		var.discount += rli.discount
	}
}	

