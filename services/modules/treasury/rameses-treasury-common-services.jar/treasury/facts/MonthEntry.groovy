package treasury.facts;

import java.util.*;
import com.rameses.util.*;
import com.rameses.functions.*;

class MonthEntry {

   Date fromdate;
   Date todate;
   Date duedate;
   
   int month;
   int year;
   int fromday;
   int today;
   int index;  //this is base 1. indicates position if first or last entry
   
   def monthNames = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];

   int _qtr = 0;

   boolean first = false;
   boolean last = false;
   int getMonthYearIndex() {
   		return (year * 12)+month;	
   }

   int getQtr() {
      if( _qtr == 0 ) {
         if( month <= 3 ) _qtr = 1;
         else if( month <= 6 ) _qtr = 2;
         else if( month <= 9 ) _qtr = 3;
         else _qtr = 4;
      }
      return _qtr;
   }

   public String getMonthname() {
        return monthNames[ month - 1 ]; 
   }

   public int getMaxdays() {
      def cal = Calendar.instance;
      cal.set(Calendar.YEAR, year);
      cal.set(Calendar.MONTH, month - 1 );
      cal.set(Calendar.DATE, 1 );
      return cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    } 

    public int getNumdays() {
      if( fromdate == null ) return 0;
      if(todate == null) return 0;
      return DateFunc.daysDiff( fromdate, todate ) + 1;
    }

}