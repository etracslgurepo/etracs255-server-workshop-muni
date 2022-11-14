package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;

public class PrintTest implements RuleActionHandler {
	public void execute(def params, def drools) {
		def msg = params.message;
		println "-------------- Print Message ------------------";
		println msg.stringValue; 
	}

}
