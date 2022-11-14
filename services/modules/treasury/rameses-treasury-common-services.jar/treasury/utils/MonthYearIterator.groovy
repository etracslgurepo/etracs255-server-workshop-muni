package treasury.utils;

import treasury.facts.*;
import com.rameses.util.*;
import com.rameses.functions.*;
/**
* This class handles iteration given two dates and returns
* the year, month and number of days for the particular month. 
* The result is handled by the third parameter 
* ex. collectYearMonth( year, month, {y,m,days-> println "year:"+y+";month:"+m+";days:"+days} )
*/
public class MonthYearIterator {

  private Date fromdate;
  private Date todate;

  private Date cursorDate;

  public MonthYearIterator() {
  }

  public MonthYearIterator(Date fromdate, Date todate) {
      this.fromdate = fromdate;
      this.todate = todate;  
  }

  public def findMonthEnd( def d ) {
       Calendar cal = Calendar.getInstance();
       cal.setTime(d);
       int maxDays = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
       cal.set(Calendar.DATE, maxDays );
       return cal.getTime();            
  } 


  public int getMaxDays( def year, def month ) {
       if( month == 1) return 31;
       else if( month == 2) {
            def cal = Calendar.instance;
            cal.set( Calendar.YEAR, year );
            cal.set( Calendar.MONTH, month - 1);
            return cal.getActualMaximum(Calendar.DAY_OF_MONTH);
       }
       else if( month == 3) return 31;
       else if( month == 4) return 30;
       else if( month == 5) return 31;
       else if( month == 6) return 30;
       else if( month == 7) return 31;
       else if( month == 8) return 31;
       else if( month == 9) return 30;
       else if( month == 10) return 31;
       else if( month == 11) return 30;
       else if( month == 12) return 31;
  } 


  public void collectYearMonth(def fromdate, def todate, def handler ) {
       if( fromdate.after(todate)) throw new Exception("from date must be before todate"); 
       def cal = Calendar.instance;
       cal.setTime( fromdate );
       int startMonth = cal.get(Calendar.MONTH)+1;
       int startYear = cal.get(Calendar.YEAR);

       def startMonthEnd = findMonthEnd( fromdate );
       
       def cal2 = Calendar.instance;
       cal2.setTime( todate );
       int endYear = cal2.get(Calendar.YEAR);
       int endMonth = cal2.get(Calendar.MONTH)+1; 
       int endDays = cal2.get(Calendar.DAY_OF_MONTH);

       int daysDiff = 0;   
       int i = 0;
       if( (startYear == endYear) && (startMonth==endMonth) ) {
           daysDiff =   DateUtil.diff(fromdate, todate, Calendar.DATE);
           def mx = [year:startYear, month:startMonth, days:daysDiff+1, fromdate:fromdate, todate:todate, index:i++]
           handler( mx );
       }; 
       else {
           boolean lastEntry = false;
           int monthsDiff = DateFunc.monthsDiff( fromdate, todate )+1;
           def _startdate = fromdate;
           def _cal = Calendar.instance;  
           (1..monthsDiff).each {
               _cal.setTime( _startdate );
               int yr = _cal.get(Calendar.YEAR);
               int month = _cal.get(Calendar.MONTH)+1;
               
               def _from = _cal.getTime();
               _cal.set( Calendar.DATE, _cal.getActualMaximum(Calendar.DAY_OF_MONTH) );
               def _to = _cal.getTime();

               if(_to.after(todate)) {
                  _to = todate;
                  lastEntry = true;
               }   
               int _daysDiff = DateUtil.diff(_from, _to, Calendar.DATE);
               def mx = [year:yr, month:month, days:_daysDiff+1, fromdate:_from, todate: _to, index:i++ ];
               handler( mx );   
               if( lastEntry ) return; 
               _startdate = DateUtil.add( _to, "1d" );
           }

       };       
  };

  public def getMonthYearItems() {
      def list = [];
      def h = { mx->
          def mi = new MonthYearItem();
          mi.month = mx.month;
          mi.year = mx.year;
          mi.days = mx.days;
          mi.fromdate = mx.fromdate;
          mi.todate = mx.todate;
          list << mi;
      };
      collectYearMonth(this.fromdate, this.todate, h);
      return list;
  }

  public MonthYearItem createMonthYearItem( int year, int month, Date fdate, Date tdate ) {
      def mi = new MonthYearItem();
      mi.month = month;
      mi.year = year;
      mi.fromdate = fdate;
      mi.todate = tdate;
      mi.days = DateUtil.diff(fdate, tdate, Calendar.DATE)+1;
      return mi;
  }

  public MonthYearItem next() {
      if(cursorDate==null) cursorDate = fromdate;
      if( cursorDate.after(todate) ) return null;

      int monthsDiff = DateFunc.monthsDiff( cursorDate, todate );
      def cal = Calendar.instance;
      cal.setTime( cursorDate );

      int _month = cal.get(Calendar.MONTH)+1;
      int _year = cal.get(Calendar.YEAR);

      MonthYearItem mi = null;
      //if cursorDate same month as todate. Then return immediately
      if( monthsDiff == 0 ) {
          mi = createMonthYearItem( _year, _month, cursorDate, todate );
          cursorDate = DateUtil.add( todate, "1d" );     
      }
      else {
         //get month end  
         int maxDays = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
         cal.set(Calendar.DATE, maxDays );
         def _todate = cal.getTime();   
         mi = createMonthYearItem( _year, _month, cursorDate, _todate );
         cursorDate = DateUtil.add( _todate, "1d" );     
      }
      return mi;
  }


}
