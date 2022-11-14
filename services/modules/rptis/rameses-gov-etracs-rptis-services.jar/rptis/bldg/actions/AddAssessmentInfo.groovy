package rptis.bldg.actions;

import com.rameses.rules.common.*;
import rptis.bldg.facts.*;
import rptis.facts.*;


public class AddAssessmentInfo implements RuleActionHandler {
	def request
	def NS

	/*-----------------------------------------------------
	* create a assessment fact summarized based 
	* on the actualuseid
	*
	-----------------------------------------------------*/
	public void execute(def params, def drools) {
		def bu = params.bldguse 
		def bsentity = bu.bldgstructure.entity 
		def rpuentity = bu.bldgstructure.rpu.entity
		def actualuseid = params.actualuseid
		def rputype = 'bldg';

		// def mv = ( bu.useswornamount ? bu.swornamount - bu.adjustment - bu.depreciationvalue : bu.marketvalue)
		def mv = ( bu.useswornamount ? bu.swornamount - bu.depreciationvalue : bu.marketvalue)

		def a = request.assessments.find{it.rputype == rputype && it.actualuseid == actualuseid && it.taxable == bu.taxable}
		if ( ! a){
			def entity = [
				objid  :  'BA' + new java.rmi.server.UID(),
				rpuid  : rpuentity.objid, 
				rputype : rputype,
				classificationid : bsentity.classification.objid,
				classification : bsentity.classification,
				actualuseid  : actualuseid,
				actualuse    : [objid:actualuseid, name:bu.entity.actualuse.name],
				areasqm      : NS.round(bu.area), 
				areaha       : NS.roundA( bu.area / 10000.0, 6),
				marketvalue         : mv, 
				exemptedmarketvalue : (bu.taxable == false ? mv : 0.0),
				assesslevel  : bu.assesslevel,
				assessedvalue: bu.assessedvalue,
				taxable 	 : bu.taxable, 
			]

			if (rpuentity.assessments == null) 
				rpuentity.assessments = []
			rpuentity.assessments << entity

			a = new RPUAssessment(entity)
			request.assessments << a
			request.facts << a 
			drools.insert(a)
		}
		else{
			a.marketvalue = NS.round(a.marketvalue + mv)
			if (bu.taxable == false){
				a.exemptedmarketvalue = NS.round(a.exemptedmarketvalue + mv)
			}

			a.areasqm = NS.round( a.areasqm + bu.area )
			a.areaha  = NS.roundA( a.areaha + (bu.area / 10000.0), 6)
			drools.update(a)
		}
	}
}