package rptis.mach.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.mach.facts.*;


public class CalcMachineAssessLevel implements RuleActionHandler {
	def request
	def settingSvc 

	public void execute(def params, def drools) {
		def muentity = params.machuse.entity
		def machine = params.machine

		machine.assesslevel = 0.0
		if (muentity.actualuse){
			if(muentity.actualuse.fixrate == 1 || muentity.actualuse.fixrate == true) {
	            machine.assesslevel = muentity.actualuse.rate 
	        }
	        else{
		        def range = settingSvc.lookupAssessLevelByRange(muentity.actualuse.objid, machine.marketvalue)
		        if(range) {
		        	machine.assesslevel = range.rate 
		        }
	        }
		}
	}
}

