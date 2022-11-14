package rptis.planttree.actions;

import com.rameses.rules.common.*;
import rptis.land.facts.*;
import rptis.facts.*;


public class AddPlantTreeAssessmentInfo implements RuleActionHandler {
	def request
	def NS

	/*-----------------------------------------------------
	* create a assessment fact summarized based 
	* on the actualuseid
	*
	-----------------------------------------------------*/
	public void execute(def params, def drools) {
		def ptd = params.planttreedetail 
		def ptdentity = ptd.entity
		def rpuentity = ptd.rpu.entity
		if (ptdentity.assesslevel == null) ptdentity.assesslevel = 0.0
		if (ptd.assesslevel == null) ptd.assesslevel = 0.0
		if (ptd.assessedvalue == null) ptd.assessedvalue = 0.0


		def classificationid = rpuentity.classification?.objid 
		if (!classificationid) classificationid = ptdentity.actualuse?.classification?.objid 
		def actualuseid = ptdentity.actualuse?.objid
		def actualusecode = ptdentity.actualuse?.code
		def rputype = 'planttree'

		def a = request.assessments.find{it.rputype == rputype && it.classificationid == classificationid && it.actualusecode == actualusecode}
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
				areasqm      : 0.0, 
				areaha       : 0.0,
				marketvalue  : ptdentity.marketvalue,
				assesslevel  : ptd.assesslevel,
				assessedvalue  : ptd.assessedvalue,
				taxable  : ptd.taxable, 
			]
			
			a = new RPUAssessment(entity)
			a.assesslevel = entity.assesslevel
			a.assessedvalue = entity.assessedvalue

			rpuentity.assessments << entity
			request.assessments << a
			request.facts << a 
			drools.insert(a)
		}
		else{
			a.marketvalue = NS.round(a.marketvalue + ptd.marketvalue)
			a.assessedvalue = NS.round(a.assessedvalue + ptd.assessedvalue)
			drools.update(a)
		}
	}
}