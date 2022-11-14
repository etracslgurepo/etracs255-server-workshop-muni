package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;


public class CalcAssessLevel implements RuleActionHandler {
	def request
	def em
	def NS

	public void execute(def params, def drools) {
		def ld = params.landdetail
		def entity = ld.entity;

		ld.assesslevel = 0.0
		if (entity.actualuse){
			if(entity.actualuse.fixrate == 1 || entity.actualuse.fixrate == true) {
	            ld.assesslevel = entity.actualuse.rate 
	        }
	        else{
		        def info = [ry:ld.rpu.ry, landassesslevelid:entity.actualuse.objid, marketvalue:ld.marketvalue]
		        def range = em.findAssessLevelRange(info)
		        if( ! range ) {
		        	println 'Market Value of P' + NS.format('#,##0.00', ld.marketvalue) + ' has no assess level range definition.'
		        }
		        else{
		        	ld.assesslevel = range.rate 
		        }
	        }
		}
	}
}