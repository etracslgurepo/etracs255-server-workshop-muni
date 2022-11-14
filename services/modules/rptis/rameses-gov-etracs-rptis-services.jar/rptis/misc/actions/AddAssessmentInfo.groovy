package rptis.misc.actions;

import com.rameses.rules.common.*;
import rptis.misc.facts.*;
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
		def miscrpu = params.miscrpu 
		def entity = miscrpu.entity 

		def rputype = 'misc';

		if (entity.assessments == null) {
			entity.assessments = []
		}

        def classificationid = entity.classification?.objid
        def actualuseid = entity.actualuse?.objid
        def actualusecode = entity.actualuse?.code

        entity.items.each{item ->
            def a = request.assessments.find {
                it.classificationid == classificationid && it.actualuseid == actualuseid && it.taxable == item.taxable
            }

            if ( ! a){
                def assessmentinfo = [
                    objid  :  'MA' + new java.rmi.server.UID(),
                    rpuid  : entity.objid, 
                    rputype : rputype,
                    classificationid : classificationid,
                    classification   : entity.classification,
                    actualuseid  : actualuseid,
                    actualusecode  : actualusecode,
                    actualuse    : entity.actualuse,
                    areasqm      : 0, 
                    areaha       : 0,
                    marketvalue  : item.marketvalue,
                    exemptedmarketvalue : (item.taxable == false ? item.marketvalue : 0.0),
                    taxable 		: item.taxable, 
                    assesslevel  : item.assesslevel,
                    assessedvalue  : item.assessedvalue,
                ]
                
                a = new RPUAssessment(assessmentinfo)
                a.assesslevel = item.assesslevel
                a.assessedvalue = item.assessedvalue
                entity.assessments << assessmentinfo
                request.assessments << a
                request.facts << a 
                drools.insert(a)
            }
            else {
                a.marketvalue = NS.round(a.marketvalue + item.marketvalue)
                if (item.taxable == false) {
                    a.exemptedmarketvalue = NS.round(a.exemptedmarketvalue + item.marketvalue)
                }
                a.assessedvalue = NS.round(a.assessedvalue + item.assessedvalue)
                drools.update(a)
            }
        }
		
	}

}
