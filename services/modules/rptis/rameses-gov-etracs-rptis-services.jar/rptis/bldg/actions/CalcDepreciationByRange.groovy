package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcDepreciationByRange implements RuleActionHandler {
	def request
	def bldgSettingSvc

	public void execute(def params, def drools) {
		def bs = params.bldgstructure
		def cdurating = params.cdurating 

		if ( bs.entity.bldgtype && bs.entity.bldgtype.objid ){
			def depreciations = bldgSettingSvc.getDepreciations(bs.entity.bldgtype?.objid)

			if( ! depreciations ) {
				println 'Depreciation schedule for Type ' + bs.entity.bldgtype.code + ' is not defined.'
			}
			else {
				def depreciationrate = 0.0
				int effectiveage = bs.rpu.effectiveage 
		        if( effectiveage > 0 )  {
		        	def sked = depreciations.find{effectiveage >= it.agefrom && effectiveage <= it.ageto}
		        	if (sked){
		        		def rate = (cdurating ? sked[cdurating] : sked.rate )
		        		if (rate == null) rate = 0.0 
		        		depreciationrate = rate
		        	}
				}
				
				def maxdepreciation = 100.0 - bs.entity.bldgtype.residualrate 
				if( maxdepreciation < depreciationrate) 
					bs.rpu.depreciation = maxdepreciation
				else
					bs.rpu.depreciation = depreciationrate
			}
			
		}
	}
}