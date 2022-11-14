package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcAssessLevel implements RuleActionHandler {
	def request
	def bldgSettingSvc

	public void execute(def params, def drools) {
		def assessment = params.assessment
		def mv = (params.marketvalue != null ? params.marketvalue.getDecimalValue() : assessment.marketvalue) 
		
		
		def lvl = bldgSettingSvc.lookupBldgAssessLevelById(assessment.actualuseid)
		
		if (lvl.fixrate == true || lvl.fixrate == 1){
			assessment.assesslevel = lvl.rate 
		}
		else {
			def range = bldgSettingSvc.lookupAssessLevelFromRange(lvl.objid, mv)
			assessment.assesslevel = 0.0 
	        if( range ) {
	            assessment.assesslevel = range.rate 
	        }
		}
	}
}