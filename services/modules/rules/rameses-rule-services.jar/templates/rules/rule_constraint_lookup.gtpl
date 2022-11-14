<% 
	if( constraint.varname ) {
		out.print( constraint.varname + ':');
	}
	if( !constraint.field.vardatatype || constraint.field.vardatatype == "string" ) {
		out.print( constraint.field.name );
	}
	else {
		out.print( constraint.field.name  + "." + constraint.field.lookupkey );
	}
	
	if( constraint.operator?.symbol ) {
		out.print( " " + constraint.operator.symbol + " " );
		if( constraint.usevar == 1 ) {
			out.print( constraint.var.name );
		}
		else if(constraint.field.multivalued==1) {
			out.print( "\".*-"+ constraint.listvalue*.key.join("-|-") + "-.*\"" );
		}
		else {
			out.print( "\""+ constraint.listvalue*.key.join("|") + "\"" );
		}			
	}
%>