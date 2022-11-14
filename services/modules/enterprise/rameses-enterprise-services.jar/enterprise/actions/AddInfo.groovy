package enterprise.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import enterprise.facts.*;
import enterprise.utils.*;
import com.rameses.osiris3.common.*;

/*********************************************************
* This will add info to the facts and to the info result
**********************************************************/
public class AddInfo implements RuleActionHandler {

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
		//lookup the info from variable em. then create the fact.
		def dinfo = ct.env.infoUtil.lookupInfo( [name: infoName] );
		dinfo.params = params;
		return ct.env.infoUtil.provider.createFact( dinfo );	
	}

	public def getAggregateValue( def oldValue, def newValue, def aggtype ) {
		if(aggtype == "COUNT") {
			return (!oldValue)? 1 : oldValue + 1; 
		}
		else if( aggtype == "SUM" ) {
			return oldValue + newValue;
		}
		else if( aggtype == "MIN" ) {
			return (( oldValue < newValue )? oldValue : newValue );
		}
		else if(aggtype == "MAX") {
			return ((oldValue > newValue)) ? newValue : oldValue;
		}
		throw new Exception(" " + aggtype + " not yet supported");
	}

	public void execute(def params, def drools) {
		def infotype = params.name;
		if(!infotype) throw new Exception("type is required in any AskInfo action");
		if( params.value == null && params.aggtype == null )
		 	throw new Exception("Please specify value or aggtype in AddInfo action");

		def aggtype = params.aggtype;
		def value = null;
		if(params.value) {
			if(! (params.value instanceof ActionExpression)) {
				params.value = new ActionExpression( " " + params.value );
			}
			value = params.value.eval();
		};	

		String infoName = params.name.key;
		def keyFinder = createKeyFinder(infoName, params);

		def ct = RuleExecutionContext.getCurrentContext();

		//check if it exists in the facts
		def obj = ct.facts.find{ (it instanceof VariableInfo) && keyFinder(it) };
		if( obj ) {
			if( aggtype ) {
				value = getAggregateValue( value, obj.value, aggtype );
			}
			//replace the value
			obj.value = value;
		}
		else {
			def vinfo = createFact(  infoName, params );
			if( aggtype ) {
				value = getAggregateValue( value, 0, aggtype );
			}			
			vinfo.value = value;
			ct.facts.add( vinfo );
		}
	}


}