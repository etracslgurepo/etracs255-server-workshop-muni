package bpls.actions;

import com.rameses.rules.common.*;
import market.facts.*;
import com.rameses.util.*;
import java.util.*;
import com.rameses.osiris3.common.*;
import treasury.facts.*;

import bpls.utils.*;

/****************************************************************
* This builds the qtr deadlines for each year 
*****************************************************************/
public class BuildBplsQtrDueDate implements RuleActionHandler {
	
	public void execute(def params, def drools) {
		def year = params.year;
		def ct = RuleExecutionContext.getCurrentContext();
		def facts = ct.facts;

		//test first if the qtrdue date already asserted in the facts
		def testExist = facts.find{ (it instanceof QtrDueDate ) && it.year == year };
		if(testExist) return;

		def svc = EntityManagerUtil.lookup( "bpexpirydate" );
		for( int qtr=1; qtr<=4; i++) {
			def m = svc.find( [year: year, qtr: qtr] ).first();	
			if(!m) {
				def mon  = '01';
				if( qtr == 2 ) mon = '04';
				else if( qtr == 3 ) mon = '07';
				else if(qtr == 4 ) mon = '10';
				def df = new java.text.SimpleDateFormat("yyyy-MM-dd");
				def dt = df.parse( year + "-" + mon  + "-" + "20" );
				m = [expirydate: dt];
			}
			def qdt = new QtrDueDate( m.expirydate );
			qdt.qtr = qtr; 
			facts << qdt;
		}

	}
}