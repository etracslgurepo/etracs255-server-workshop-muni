package rptis.mach.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.mach.facts.*;


public class CalcMachUseAssessLevel implements RuleActionHandler {
	def request
	def settingSvc 

	public void execute(def params, def drools) {
		def machuse = params.machuse
		def muentity = params.machuse.entity

		if (muentity.actualuse){
			if(muentity.actualuse.fixrate == 1 || muentity.actualuse.fixrate == true) {
	            machuse.assesslevel = muentity.actualuse.rate 
	        }
	        else{
		        def range = settingSvc.lookupAssessLevelByRange(muentity.actualuse.objid, machuse.marketvalue)
		        if(range) {
		        	machuse.assesslevel = range.rate 
		        }
	        }
		}
	}
}

