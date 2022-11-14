<% 
	if( constraint.varname ) {
		out.print( constraint.varname + ':');
	}
	out.print( constraint.fieldname );
	if( constraint.operator?.symbol ) {
		out.print( " " + constraint.operator.symbol );
	}
%>