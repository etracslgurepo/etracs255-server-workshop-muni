package bpls.actions;

import com.rameses.rules.common.*;
import com.rameses.common.*;

import bpls.facts.*;


public class SetBillExpiryDate implements RuleActionHandler {

	def request;
	def df = new  java.text.SimpleDateFormat("yyyy-MM-dd");
		
	public void execute(def params, def drools) {
		def dt = params.expirydate;	
		//statement
		def t = ExpressionResolver.getInstance().eval( dt.statement, dt.params );
		if(t==null)
			throw new Exception("Error in set bill expiry date. Date result cannot be null");

		String str = df.format( t );
		request.billexpirydate = df.parse( df.format( t )); 
		 
		/*	
		String str = df.format( t );
		t = df.parse( df.format( t )); 
		if( !request.expirydate ) {
			request.billexpirydate = t;
		}
		else if( t < request.billexpirydate ) {
			request.billexpirydate = t;	
		}
		*/
	}
}