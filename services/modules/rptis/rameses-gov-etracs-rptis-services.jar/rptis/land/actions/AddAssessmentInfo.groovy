package rptis.land.actions;

import com.rameses.rules.common.*;
import rptis.land.facts.*;
import rptis.planttree.facts.*;
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
		def ld = params.landdetail 
		def ldentity = ld.entity
		def rpuentity = ld.rpu.entity

		def classificationid = params.classificationid 
		if (params.classification){
			classificationid = params.classification.objid			
		}

		def actualuseid = ldentity.actualuse?.objid
		def actualusecode = ldentity.actualuse?.code
		def rputype = rpuentity.rputype;

		def a = request.assessments.find{it.rputype == rputype && it.classificationid == classificationid && it.actualusecode == actualusecode && it.taxable == ldentity.taxable}
		if ( ! a){
			if (rpuentity.assessments == null) 
				rpuentity.assessments = []
			
			def entity = [
				objid  :  'BA' + new java.rmi.server.UID(),
				rpuid  : rpuentity.objid, 
				rputype : rputype,
				classificationid : classificationid,
				classification   : [objid:classificationid],
				actualuseid  : actualuseid,
				actualusecode  : actualusecode,
				actualuse    : [objid:actualuseid],
				areasqm      : NS.round(ldentity.areasqm), 
				areaha       : NS.roundA( ldentity.areaha, 6),
				marketvalue  : ld.marketvalue,
				exemptedmarketvalue : (ld.taxable == false ? ld.marketvalue : 0.0),
				taxable 		: ld.taxable, 
				assesslevel  : ld.assesslevel,
				assessedvalue  : ld.assessedvalue,
			]
			
			a = new RPUAssessment(entity)
			a.assesslevel = ld.assesslevel
			a.assessedvalue = ld.assessedvalue
			rpuentity.assessments << entity
			request.assessments << a
			request.facts << a 
			drools.insert(a)
		}
		else{
			a.marketvalue = NS.round(a.marketvalue + ld.marketvalue)
			if (ld.taxable == false){
				a.exemptedmarketvalue = NS.round(a.exemptedmarketvalue + ld.marketvalue)
			}
			a.assessedvalue = NS.round(a.assessedvalue + ld.assessedvalue)
			a.areasqm = NS.round( a.areasqm + ldentity.areasqm )
			a.areaha  = NS.roundA( a.areaha + ldentity.areaha , 6)
			drools.update(a)
		}
	}
}