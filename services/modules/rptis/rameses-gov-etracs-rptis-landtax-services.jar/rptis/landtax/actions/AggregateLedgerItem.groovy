package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class AggregateLedgerItem implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def item = params.rptledgeritem
		def entity = item.entity
		drools.retract(item)
		request.facts.remove(item)
		request.items.remove(entity)

		def aitem = request.items.find{ it.objid == entity.objid && it.qtrly == false && it.qtr == null}
		if (!aitem){
			aitem = [:]
			aitem.putAll(entity)
			aitem.qtrly = false
			aitem.qtr = null 
			request.items << aitem 
			request.facts << new RPTLedgerItemFact(item.ledger, aitem)
		}
		else {
			aitem.amtdue += entity.amtdue 
			aitem.interest += entity.interest 
			aitem.discount += entity.discount 
			def factitem = request.facts.findAll{it instanceof RPTLedgerItemFact}.find{it.objid == aitem.objid && it.qtr == null}
			if (!factitem) throw new Exception('Ledger Item is expected here.')
			factitem.amtdue = aitem.amtdue
			factitem.interest = aitem.interest
			factitem.discount = aitem.discount
		}
	}
}