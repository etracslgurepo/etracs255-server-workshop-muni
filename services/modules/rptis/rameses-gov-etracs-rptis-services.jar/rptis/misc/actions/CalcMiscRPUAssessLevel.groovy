package rptis.misc.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.misc.facts.*;


public class CalcMiscRPUAssessLevel implements RuleActionHandler {
	def request
	def em
	def NS 

	public void execute(def params, def drools) {
		def miscrpu = params.miscrpu
		def entity = miscrpu.entity 
		miscrpu.assesslevel = 0.0
		if (entity.actualuse){
			if(entity.actualuse.fixrate == 1 || entity.actualuse.fixrate == true) {
	            miscrpu.assesslevel = entity.actualuse.rate 
	        }
	        else{
		        def info = [ry:entity.ry, miscassesslevelid:entity.actualuse.objid, marketvalue:miscrpu.marketvalue]
		        def range = em.findAssessLevelRange(info)
		        if( range ) 
		        	miscrpu.assesslevel = range.rate 
		        else
		        	throw new Exception('Market Value of P' + NS.format('#,##0.00', miscrpu.marketvalue) + ' has no equivalent assess level rate defined.')
	        }
		}
	}
}