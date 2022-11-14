package rptis.mach.actions;

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
		def mu = params.machuse 
		def muentity = mu.entity
		def rpuentity = mu.rpu.entity

		def classificationid = rpuentity.classification?.objid 
		def actualuseid = muentity.actualuse.objid
		def rputype = 'mach';

		def a = request.assessments.find{
				it.rputype == rputype && 
				it.classificationid == classificationid && 
				it.actualuseid == actualuseid && 
				it.taxable == mu.taxable
		}
		if ( ! a){
			if (rpuentity.assessments == null) 
				rpuentity.assessments = []
			
			def entity = [
				objid  :  'MA' + new java.rmi.server.UID(),
				rpuid  : rpuentity.objid, 
				rputype : rputype,
				classificationid : classificationid,
				classification   : [objid:classificationid],
				actualuseid  : actualuseid,
				actualuse    : [objid:actualuseid],
				areasqm      : 0.0,
				areaha       : 0.0,
				marketvalue  : muentity.marketvalue,
				assesslevel  : muentity.assesslevel,
				assessedvalue  : muentity.assessedvalue,
				taxable 		: mu.taxable, 
			]
			
			a = new RPUAssessment(entity)
			a.assesslevel = muentity.assesslevel
			a.assessedvalue = muentity.assessedvalue
			rpuentity.assessments << entity
			request.assessments << a
			request.facts << a 
			drools.insert(a)
		}
		else{
			a.marketvalue = NS.round(a.marketvalue + muentity.marketvalue)
			a.assessedvalue = NS.round(a.assessedvalue + muentity.assessedvalue)
			drools.update(a)
		}
	}
}