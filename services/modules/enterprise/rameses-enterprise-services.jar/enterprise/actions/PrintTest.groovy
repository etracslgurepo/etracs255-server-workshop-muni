package enterprise.actions;

import com.rameses.rules.common.*;

public class PrintTest implements RuleActionHandler {
	public void execute(def params, def drools) {
		def msg = params.message;
		println "-------------- Print Message ------------------";
		println msg.stringValue; 
	}

}
