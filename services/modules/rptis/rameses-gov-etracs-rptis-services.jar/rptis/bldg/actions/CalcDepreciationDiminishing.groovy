package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;


public class CalcDepreciationDiminishing implements RuleActionHandler {
    def NS;
	def request
	def bldgSettingSvc

	public void execute(def params, def drools) {
		def bs = params.bldgstructure
		def bu = params.bldguse
		def cdurating = params.cdurating 

        if ( bs.entity.bldgtype && bs.entity.bldgtype.objid ){
			def depreciations = bldgSettingSvc.getDepreciations(bs.entity.bldgtype?.objid)
			if( ! depreciations ) {
				println 'Depreciation schedule for Type ' + bs.entity.bldgtype.code + ' is not defined.'
                return;
            }

            def residualrate = bs.entity.bldgtype.residualrate
            def effectiveage = bs.rpu.effectiveage
            //
            //set marketvalue to depreciate
            def marketvalue = bu.basemarketvalue + bu.adjfordepreciation
            bs.rpu.depreciation = 0.0
            bu.depreciationvalue = 0.0
        
            def totaldepreciation = 0.0;
            def isresidual = false;

            for (int age = 1; age <= effectiveage; age++) {
                def depreciationrange = depreciations.find{age >= it.agefrom && age <= it.ageto}
                if (!depreciationrange) depreciationrange = depreciations.last()

                totaldepreciation += depreciationrange.rate
                if (totaldepreciation <= (100 - residualrate)) {
                    def depreciation = depreciationrange.rate / 100.0 
                    def depreciationvalue = NS.round( marketvalue * depreciation)
                    bu.depreciationvalue += depreciationvalue
                    marketvalue -= depreciationvalue
                } else {
                    bu.depreciationvalue = NS.round( bu.basemarketvalue * (100 - residualrate) / 100.0 )
                    bs.rpu.depreciation = 100 - residualrate
                    isresidual = true
                    break;
                }
            }
            if (!isresidual) {
                bs.rpu.depreciation = totaldepreciation;
            }
		}
	}
}