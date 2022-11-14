<%
    import java.text.SimpleDateFormat;

	def prn_date = { rule->
		if(rule.effectivefrom!=null || rule.effectiveto!=null) {
			def dformat = new SimpleDateFormat("yyyyMMdd");
			out.print("EffectiveDate(");
			if(rule.effectivefrom!=null) { 
				out.print( "numericDate >= " + dformat.format(rule.effectivefrom));
				if(rule.effectiveto!=null) out.print(",");
			}
			if(rule.effectiveto!=null) { 
				out.print( "numericDate <= " + dformat.format(rule.effectiveto));
			}
			out.print(")");
		}
	}

	def prn_cond = { c->
		//if cond is dynamic, add dynamic var name
		int j = 0;
		if(c.dynamic?.key) {
			out.print ( c.fact.dynamicfieldname + "==\""+ c.dynamic.key +"\" ");
			j++;
		}
		if( c.fact.builtinconstraints ) {
			out.print ( c.fact.builtinconstraints );
			j++;
		}
		c.constraints.eachWithIndex { ct,i->
			if((i+j)>0) out.print(",");
			def h = ct.field.handler;
			if( ct.operator?.symbol?.contains("null")) h = "null";
			out.print( templateSvc.get( "rules/rule_constraint_"+h, [constraint:ct] ));
		}
	} 

	def prn_action_param = { o->
		def r;
		def handler = 	o.actiondefparam.handler
		if( o.exprtype == "range") handler+="-range";
		if( o.exprtype == "expression") handler+="-expression";

		switch( handler ) {
			case "lookup":
				r = "new KeyValue(\"${o.obj.key}\", \"${o.obj.value}\")".toString();
				break;
			case "var":
				r = o.var.name;
				break;
			case "lov":
				r = "\""+o.lov+"\"";
				break;
			case "message":	
				r = "\"" + o.stringvalue + "\"";
				break;
			case "string":
				r = "\"" + o.stringvalue + "\"";
				break;
			case "fieldlist":
				r = "\"" + o.stringvalue + "\"";
				break;	
			case "boolean":
				if( o.booleanvalue == 1 || o.booleanvalue == true ) 
					r = "true";
				else
					r = "false"	
				break;
			case "expression-expression":
				String expr = o.expr.replace('\n', ' ').replace('\t', ' ');
				r = "(new ActionExpression(\"${expr}\", bindings))" ;
				break;
			case "expression-range":
				r = "0.0";
				break;
		}
		return r ;
	}

	
%>
package ${rule.ruleset}.${rule.name};
import ${rule.ruleset}.*;
import java.util.*;
import com.rameses.rules.common.*;

global RuleAction action;

rule "${rule.name}"
	agenda-group "${rule.rulegroup}"
	salience ${rule.salience}
	<%if( rule.noloop == 1 ){%>no-loop<%}%>
	when
		<%prn_date(rule)%>
		<%rule.conditions.each { cond-> %>
		${(cond.notexist==1)?'not (': ((cond.varname)?cond.varname + ':': '') } ${cond.fact.factclass} (  <%prn_cond(cond)%> ) ${(cond.notexist==1?')':'')}
		<%}%>
	then
		Map bindings = new HashMap();
		<%rule.vars.each {%>
		bindings.put("${it.varname}", ${it.varname} );
		<%}%>
	<%rule.actions.eachWithIndex { action,i->
		def rangeEntries = action.params.findAll{ it.exprtype == 'range' };
		if( rangeEntries ) { 
			rangeEntries.eachWithIndex { param, j-> 
				def rname = "re${i}";
				def dtype = rule.vars.find{ it.objid == param.var.objid}.datatype ;
				def method = (dtype=='decimal')? "Decimalvalue" : "Intvalue";
				out.println( "RangeEntry ${rname} = new RangeEntry(\"${rule.name}\");");
				out.println( "${rname}.setBindings(bindings);");
				out.println( "${rname}.set${method}(${param.var.name});");
				action.params.eachWithIndex{ parm,k->
					out.println( "${rname}.getParams().put( \"${parm.actiondefparam.name}\", ${prn_action_param(parm)} );" );	
				}
				out.println( "insert(${rname});")
			}
		}
		else {	
			out.println( "Map _p${i} = new HashMap();" );
			action.params.eachWithIndex{ parm,j->
				out.println( "_p${i}.put( \"${parm.actiondefparam.name}\", ${prn_action_param(parm)} );" );
			}
			String actionName = action.actiondef.actionname 
			out.println( "action.execute( \"${actionName}\",_p${i},drools);");
		}	
	}%>
end

<%rule.actions.each { action->
	action.params.findAll{ it.exprtype == 'range' }.eachWithIndex { param, i-> 
		def dtype = rule.vars.find{ it.objid == param.var.objid}.datatype ;
		if(dtype=="integer") dtype = "int";

		param.listvalue.eachWithIndex{ entry, j-> %>
	
rule "${action.actiondef.name}_${i}_${j}"
	agenda-group "${rule.rulegroup}"
	salience ${rule.salience}
	no-loop
	when
		<%if( entry.from && entry.to ){%>
		rv: RangeEntry( id=="${rule.name}", ${dtype}value ${param.rangeoption==0?'>=':'>'} ${entry.from}, ${dtype}value ${param.rangeoption==0?'<':'<='} ${entry.to} )
		<%}%>
		<%if( entry.from && !entry.to ){%>
		rv: RangeEntry( id=="${rule.name}", ${dtype}value ${param.rangeoption==0?'>=':'>'} ${entry.from} )
		<%}%>
		<%if( !entry.from && entry.to ){%>
		rv: RangeEntry( id=="${rule.name}", ${dtype}value ${param.rangeoption==0?'<':'<='} ${entry.to} )
		<%}%>
	then
		Map bindings = rv.getBindings();
		Map params = rv.getParams();
		params.put( "${param.actiondefparam.name}", (new ActionExpression("${entry.value}", bindings)) );	
		<%String actionName = action.actiondef.actionname%> 
		action.execute( "${actionName}",params, drools);
end

<% }}} %>
	