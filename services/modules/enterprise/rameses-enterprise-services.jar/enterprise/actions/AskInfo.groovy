package enterprise.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import enterprise.facts.*;
import enterprise.utils.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*  infotype
*  defaultvalue  - 
****/
public class AskInfo implements RuleActionHandler {

	public String getInfoSchemaName() {
		return null;	
	}

	//overridable. Key normally is the name
	public def createKeyFinder( def infoName, def params ) {
		return { o-> o.name == infoName };		
	}

	//overridable. Creates a new Fact.
	public def createFact( String infoName, def params ) {
		def ct = RuleExecutionContext.getCurrentContext();
		if(! ct.env.infoUtil ) {
			ct.env.infoUtil = new VariableInfoUtil();
		}	

		String sname = getInfoSchemaName();
		if( sname!=null ) {
			 ct.env.infoUtil.schemaName = sname; 
		}
		def value = null;
		if(params.value) {
			if(! (params.value instanceof ActionExpression)) {
				params.value = new ActionExpression( " " + params.value );
			}
			value = params.value.eval();
		}	

		//lookup the info from variable em. then create the fact.
		def dinfo = ct.env.infoUtil.lookupInfo( [name: infoName, value: value] );
		dinfo.params = params; 
		return ct.env.infoUtil.provider.createFact( dinfo );	
	}

	public void execute(def params, def drools) {
		def infotype = params.name;
		if(!infotype) throw new Exception("type is required in any AskInfo action");

		String infoName = params.name.key;
		def keyFinder = createKeyFinder(infoName, params);

		def ct = RuleExecutionContext.getCurrentContext();

		/********************************************************************************************
		* check first if input already exists in facts, infos or askinfos
		* Do not add if its exists already.
		* Use a custom key finder for this. default custom finder based on name only
  		*********************************************************************************************/
		boolean include = true;
		if( ct.facts.find{ (it instanceof VariableInfo) && keyFinder(it) }!=null ) {
			include = false;
		}
		else if(ct.result.infos) {
			if( ct.result.infos.find(keyFinder) ) include = false;
		}
		else if( ct.result.askinfos ) {
			if( ct.result.askinfos.find(keyFinder) ) include = false;
		}	

		if(include) {
			if( !ct.result.askinfos ) ct.result.askinfos = new LinkedHashSet<VariableInfo>();
			def vinfo = createFact(  infoName, params );
			ct.result.askinfos.add( vinfo  );
		}
	}

}