package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class RemoveLedgerItem implements RuleActionHandler {
	def request

	public void execute(def params, def drools) {
		def item = params.rptledgeritem
		drools.retract(item)
		request.facts.remove(item)
		request.items.remove(item.entity)
	}
}