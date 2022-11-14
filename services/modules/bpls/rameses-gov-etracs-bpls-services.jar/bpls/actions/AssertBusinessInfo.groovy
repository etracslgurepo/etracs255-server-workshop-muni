package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class AssertBusinessInfo extends AbstractBusinessInfoAction implements RuleActionHandler {

	def request;
	def comparator;

	public void execute(def params, def drools) {
		def lob = params.lob;
		def attrid = params.attribute.key;
		def val = params.value;
		def facts = request.facts;

		//check if fact already exists
		def info = getInfo( request.entity, request.newinfos, lob, attrid, val, request.phase );
		if(info!=null) {
			def dtype = info.attribute.datatype;
			def f = new BusinessInfo(dtype, info.value);
			f.objid = info.objid;
			f.name = info.attribute.name;
			f.lob = lob;
			facts << f;
		}
	}
}

