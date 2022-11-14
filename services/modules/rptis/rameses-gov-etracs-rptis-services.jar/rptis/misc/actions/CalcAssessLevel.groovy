package rptis.misc.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.misc.facts.*;


public class CalcAssessLevel implements RuleActionHandler {
	def request
	def em
	def NS

	public void execute(def params, def drools) {
		def miscitem = params.miscitem
		def miscrpu = miscitem.miscrpu;

		miscitem.assesslevel = 0.0
		if (miscrpu.actualuse){
			if(miscrpu.actualuse.fixrate == 1 || miscrpu.actualuse.fixrate == true) {
	            miscitem.assesslevel = miscrpu.actualuse.rate 
	        }
	        else{
		        def info = [ry:miscrpu.ry, miscassesslevelid:miscrpu.actualuse.objid, marketvalue:miscitem.marketvalue]
		        def range = em.findAssessLevelRange(info)
		        if( range ) 
		        	miscitem.assesslevel = range.rate 
		        else
		        	throw new Exception('Market Value of P' + NS.format('#,##0.00', miscitem.marketvalue) + ' has no equivalent assess level rate defined.')
	        }
		}
	}
}