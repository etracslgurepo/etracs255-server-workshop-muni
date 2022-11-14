package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class AskBusinessInfo extends AbstractBusinessInfoAction implements RuleActionHandler {

	def request;

	public void execute(def params, def drools) {
		def lob = params.lob;
		def attrid = params.attribute.key;
		
		def entity = request.entity;
		def newinfos = request.newinfos;

		def val = params.defaultvalue;

		if(!val || val == "null") {
			val = null;
		}
		else if( val instanceof String ) {
			val = new ActionExpression( val, [:] );	
		}

		def info = getInfo( entity, newinfos, lob, attrid, val, request.phase );
		if ( info ) info.defaultvalue = info.value; 
	}

}

