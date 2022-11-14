<% 
	if( constraint.varname ) {
		out.print( constraint.varname + ':');
	}
	
	out.print( constraint.fieldname );

	if( constraint.operator?.symbol ) {
		out.print( " " + constraint.operator.symbol + " " );
		if( constraint.usevar == 1 ) {
			out.print( constraint.var.name );
		}
		else {
			out.print( constraint.var.name );
		}			
	}
	
%>