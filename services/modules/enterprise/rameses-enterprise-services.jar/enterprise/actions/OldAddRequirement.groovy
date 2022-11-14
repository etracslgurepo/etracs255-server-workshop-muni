package enterprise.actions;

import com.rameses.rules.common.*;
import com.rameses.osiris3.*;
import com.rameses.util.*;
import java.util.*;
import enterprise.facts.*;
import com.rameses.osiris3.common.*;

public class AddRequirement implements RuleActionHandler {

	/*
	public void execute(def params, def drools) {
		def type = params.type;
		def step = params.step;
		def context = params.context;
		if( !request.requirements.find{it.refid == type.key}) {
			def z = BR.findEntry([objid: type.key])
			request.requirements << [reftype:type.key, title: type.value, step: step, context:context ]; 
		}
	}
	*/

	public void execute(def params, def drools) {
		def var = params.type;
		def step = params.step;
		def context = params.context;

		println "add requirements " + var.key;

		boolean required = true;
		if(params.required) required = params.required.toString().toBoolean();

		if(!params.type) throw new Exception("type required in AddRequirement rules");

		def ct = RuleExecutionContext.getCurrentContext();
		
		//check first if var objid exists in the facts. if not exist add it.
		def varFact = ct.facts.find{ (it instanceof enterprise.facts.Requirement) && it.code == var.key };
		if(!varFact) {

			//check first if variable exists in database
			def em = EntityManagerUtil.lookup("sys_requirement_type");
			def z = em.find( [code: var.key] ).first();
			if(!z) throw new Exception("Requirement code " + var.key + " does not exist!");

			//add facts to be processed in next pass
			int irequired = (required)?1:0;
			Requirement rq = new Requirement( code:z.code, title:z.title, sortorder: z.sortindex, required: irequired);
			ct.facts << rq;

			//add infos in result.
			if( !ct.result.requirements ) ct.result.requirements = [];
			ct.result.requirements << rq.toMap();
		}

	}

}