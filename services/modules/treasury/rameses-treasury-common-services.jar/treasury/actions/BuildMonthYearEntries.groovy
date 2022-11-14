package treasury.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import treasury.facts.*;
import com.rameses.osiris3.common.*;

/***
* Parameters:
*    billitem
****/
class BuildMonthYearEntries implements RuleActionHandler {

	public void execute(def params, def drools) {
		def fromdate = params.fromdate.eval();
		def todate = params.todate.eval();

		if( fromdate >= todate ) {
			//do not proceed if fromdate less than todate but do not throw an error either
			return;
		}

		def fdb = new DateBean(fromdate, 'yyyy-MM-dd');
		int fyr = fdb.year;
		int fmon = fdb.month;
		int fday = fdb.day;

		def tdb = new DateBean(todate, 'yyyy-MM-dd');
		int tyr = tdb.year;
		int tmon = tdb.month;
		int tday = tdb.day;

		boolean monthEnd = false;	
		if(tdb.date == tdb.monthEnd) {
			monthEnd = true;
		}		

		def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
		def list = [];
		def ct = RuleExecutionContext.getCurrentContext();	

		(((fyr*12)+(fmon))..((tyr*12)+(tmon))).eachWithIndex { s, idx ->

			int fromYear = (int)((s-1)/12);
			int fromMonth = s % 12;
			if( fromMonth == 0 ) fromMonth = 12;

			def fromDate = sdf.parse( fromYear + "-" + fromMonth + "-" + fday );
			def toDate = null;

			if( monthEnd) {
				def db = new DateBean( fromDate, 'yyyy-MM-dd' );
				toDate = db.monthEnd;
			}
			else if( tday <= fday ) {
				int toYear = (int)((s+1)/12);
				int toMonth = (s+1)%12;
				toDate = sdf.parse( toYear + "-" + toMonth + "-" + tday );
			}
			else {
				toDate = sdf.parse( fromYear + "-" + fromMonth + "-" + tday );
			}
			def me = new MonthEntry( year: fromYear, month: fromMonth, fromdate: fromDate, todate: toDate  );
			me.index = idx++;
			list << me;
		}

		if(list) {
			list.first().first = true;
			list.last().last = true;
			ct.facts.addAll(list);
		}
	}

}
