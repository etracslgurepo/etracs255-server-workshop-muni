package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.facts.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;

/*==========================================
*	
* Calculates the area in terms of 
* sqm and hectare based on areatype 
*
==========================================*/
public class CalcPreAssessInfo implements RuleActionHandler {
	def request;
	def NS;

	public void execute(def params, def drools) {
		def ld = params.landdetail
		def entity = ld.entity 

		//set values
		ld.basevalue = 0.0
		ld.areatype = 'SQM'
		ld.basemarketvalue  = 0.0
		ld.adjustment  		= 0.0
        ld.landvalueadjustment 	= 0.0
		ld.actualuseadjustment 	= 0.0
        ld.marketvalue      = 0.0
        ld.assesslevel      = 0.0
        ld.assessedvalue    = 0.0
        ld.striprate 		= 0.0

		if (entity.subclass) 
			ld.basevalue = entity.subclass.unitvalue
		if (entity.specificclass) 
			ld.areatype  = entity.specificclass.areatype 
		if( entity.stripping && entity.stripping.rate > 0) {
        	ld.striprate = entity.stripping.rate 
        }

		//calc areas
		ld.areasqm = 0.0
		ld.areaha = 0.0

		if ('SQM'.equalsIgnoreCase(ld.areatype)){
			ld.areasqm = NS.round(ld.area * 1.0)
			ld.areaha  = NS.roundA(ld.area / 10000.0, 6)
		}
		else if ('HA'.equalsIgnoreCase(ld.areatype)){
			ld.areasqm = NS.round(ld.area * 10000.0)
			ld.areaha  = NS.roundA(ld.area * 1.0, 6)
		}

		//calc unitvalues
		ld.unitvalue = ld.basevalue 
		if( ld.striprate > 0.0) {
            ld.unitvalue = NS.round( ld.basevalue * ld.striprate / 100.0 )
        }
	}
}