package treasury.facts;

import java.util.*;
import com.rameses.util.*;
import com.rameses.functions.*;

/*********************************************************************************************************************************
* This is used for bill items that need year and month like schedules etc.
**********************************************************************************************************************************/
class QtrBillItem extends BillItem {

	int year;
	int qtr;
	
    def df = new java.text.SimpleDateFormat("yyyy-MM-dd");

	public QtrBillItem(def o ) {
		super(o);
		if(o.year) year = o.year;
		if(o.qtr ) qtr = o.qtr;
	}
	
	public QtrBillItem() {}

	public int getPaypriority() {
	   return (year*12)+startMonth;
	}

	public def toMap() {
		def m = super.toMap();
		m.year = year;
		m.qtr = qtr;
		return m;
	}

	//in the hash code priority is the txntype not the accout code
	public int hashCode() {
		def buff = new StringBuilder();
		buff.append( ((year * 12) + startMonth) );
		if( txntype ) {
			buff.append( "-" + txntype );
		}
		else if( account?.objid ) {
			buff.append( "-" + account.objid  )
		};
		return buff.toString().hashCode();
	}

	public int getStartMonth() {
        switch(qtr) {
            case 1: 
                return 1;
            case 2: 
                return 4; 
            case 3: 
                return 7; 
            default: 
                return 10;
        }
    }
    
    public int getEndMonth() {
        switch(qtr) {
            case 1: 
                return 3;
            case 2: 
                return 6; 
            case 3: 
                return 9; 
            default: 
                return 12;
        }
    }

    public Date getStartDate() {
        return df.parse( year + "-" + getStartMonth() + "-1" );
    }

    public Date getEndQtrDate() {
        def dt = df.parse( year + "-" + getEndMonth() + "-1" );
        Calendar cal = Calendar.getInstance();
        cal.setTime(dt);
        int d = cal.getActualMaximum( Calendar.DAY_OF_MONTH );
        cal.set( Calendar.DAY_OF_MONTH, d );
        return cal.getTime();
    }

    public int getSortorder() {
        return (getYear()*12)+startMonth);
    }   

}