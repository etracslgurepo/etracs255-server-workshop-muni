package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;


//Loads each variable and 
public class AssertSysVars implements RuleActionHandler {
	def request;
	public void execute(def params, def drools) {
		def vars = request.vars;
		def facts = request.facts;
		vars.each { k,v->
			def f = new SysVariable(v.datatype, v.value);
			f.name = v.name;
			facts << f;
		}
		vars.clear();
	}

}