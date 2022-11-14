package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class ApplyIncentive implements RuleActionHandler {
	def numSvc

	public void execute(def params, def drools) {
		def rli = params.rptledgeritem
		def incentive = params.incentive

		if ('basic'.equalsIgnoreCase(rli.revtype) && incentive.basicrate > 0.0){
			rli.amount = numSvc.round( rli.amount * (100 - incentive.basicrate) / 100.0 )
			rli.discount = numSvc.round( rli.discount * (100 - incentive.basicrate) / 100.0 )
			rli.interest = numSvc.round( rli.interest * (100 - incentive.basicrate) / 100.0 )
		}
		
		if ('sef'.equalsIgnoreCase(rli.revtype) && incentive.sefrate > 0.0){
			rli.amount = numSvc.round( rli.amount * (100 - incentive.sefrate) / 100.0 )
			rli.discount = numSvc.round( rli.discount * (100 - incentive.sefrate) / 100.0 )
			rli.interest = numSvc.round( rli.interest * (100 - incentive.sefrate) / 100.0 )
		}
	}
}	
