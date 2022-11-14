package treasury.facts;

import java.util.*;
import com.rameses.util.*;
import com.rameses.functions.*;

/*********************************************************************************************************************************
* This is used for bill items that need year and month like schedules etc.
**********************************************************************************************************************************/
class MonthBillItem extends BillItem {

	def monthNames = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];

	Date fromdate;
	Date todate;

	public MonthBillItem(def o ) {
		super(o);
		if(o.fromdate ) fromdate = o.fromdate;
		if(o.todate) todate = o.todate;
	}
	
	public MonthBillItem() {} 

	public int getPaypriority() { 
	   return (year*12)+month; 
	} 

	public def toMap() { 
		def m = super.toMap(); 
		m.monthname = monthname; 
		m.sortorder = getSortorder(); 
		m.fromdate = fromdate; 
		m.todate = todate; 

		def df = new java.text.SimpleDateFormat("yyyy-MM-dd"); 
		if ( !m.fromdate ) { 
			m.fromdate = df.parse(year+"-"+month+"-01"); 
		} 
		if ( !m.todate ) { 
			//if fromdate not provided, by default use beginning of month. 
			//if todate not provided, by default use end of month. 
			def tmpDt = DateFunc.getMonthAdd(m.fromdate, 1); 
			m.todate = DateFunc.getDayAdd(tmpDt, -1); 
		} 

		m.fromday = getFromday();
		m.today = getToday();
		return m;
	}


	//in the hash code priority is the txntype not the accout code
	public int hashCode() {
		def buff = new StringBuilder();
		buff.append( yearMonth );
		if( txntype ) {
			buff.append( "-" + txntype );
		}
		else if( account?.objid ) {
			buff.append( "-" + account.objid  )
		};
		return buff.toString().hashCode();
	}

	public int getSortorder() {
		return (getYearMonth()*1000); //+ super.getSortorder();
	}	

	public String getMonthname() { 
		def idx = month-1; 
		if ( idx >= 0 && idx < monthNames.size() ) {
			return monthNames[ idx ]; 
		}
		return null; 
    }

    public int getToday() {
    	if ( !todate ) return 0;

		def cal = Calendar.instance;
    	cal.setTime( todate );
    	return cal.get( Calendar.DAY_OF_MONTH );
    }

    public int getFromday() { 
    	if ( !fromdate ) return 0; 

    	def cal = Calendar.instance;
    	cal.setTime( fromdate );
    	return cal.get( Calendar.DAY_OF_MONTH );
    }

    public int getNumdays() {
    	if( fromdate == null ) return 0;
    	if(todate == null) return 0;
    	return DateFunc.daysDiff( fromdate, todate ) + 1;
    }

	public int getFromyear() {
		if ( !fromdate ) return 0; 
		return new com.rameses.util.DateBean( fromdate ).getYear();
	}    
	public int getFrommonth() {
		if ( !fromdate ) return 0; 
		return new com.rameses.util.DateBean( fromdate ).getMonth();
	}   	
	public int getToyear() {
		if ( !todate ) return 0; 
		return new com.rameses.util.DateBean( todate ).getYear();
	}    
	public int getTomonth() {
		if ( !todate ) return 0; 
		return new com.rameses.util.DateBean( todate ).getMonth();
	}    
}