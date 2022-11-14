package treasury.utils;

import treasury.facts.*;

public class MonthEntryBuilder {
	

     public static List buildMonthEntries( int fromYear, int fromMonth, int fromDay, int toYear, int toMonth, int toDay ) {
        def list = [];
        def cal = Calendar.instance;
        int idx = 1;
        int startYearMonth = ((fromYear*12)+fromMonth);
        int endYearMonth =  ((toYear*12)+toMonth);
        int sz = (endYearMonth - startYearMonth)+1;

        (startYearMonth..endYearMonth).each {
            def me = new MonthEntry();
            list << me;
            me.month = it % 12;
            me.year = (int)(it / 12);
            me.index = idx;
            me.first = false;
            me.last = false;
            
            me.fromday = 1;
            if( idx == 1 && fromDay > 0 ) me.fromday = fromDay;
            if( idx == 1 ) me.first = true;
            
            cal.set(Calendar.YEAR, toYear);
            cal.set(Calendar.MONTH, toMonth - 1 );
            cal.set(Calendar.DATE, 1 );
            me.today = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
         
            if( idx == sz  && toDay > 0 )  me.today = toDay;
            if( idx == sz ) me.last = true;

             me.numdays = (me.today - me.fromday) + 1;
            idx++; 
        }
        return list;
     } 

	 public static List buildMonthEntries( Date fromdate, Date todate ) {
        def stack = new Stack();
        def cal = Calendar.instance;
        int idx = 1;
        (fromdate..todate).each {
            cal.setTime( it);
            int month = cal.get( Calendar.MONTH )+1;
            int year = cal.get( Calendar.YEAR );
            int day = cal.get( Calendar.DATE );
            if( stack.empty() || stack.peek().month != month ) {
                def me = new MonthEntry();
                me.month = month;
                me.index = (idx++);
                me.fromdate = it;
                me.fromday = day;     
                me.year = year;   
                stack.push( me );         
            }
            stack.peek().numdays++;
            stack.peek().todate = it;
            stack.peek().today = it.date;   
        }
        def list = [];
        while( !stack.empty() ) {
            def st = stack.pop();
            list.add( 0, st );
        }
        list.first().first = true;
        list.last().last = true;
        return list;
    } 


    public static List buildDailyMonthEntryByAmount(  Date startdate, double dividend, double divisor ) {
        def cal = Calendar.instance;
        cal.setTime( startdate );

        //determine number of days to add
        int days = (int)(dividend / divisor);
        if( dividend % divisor  > 0) days = days + 1;
        cal.add( Calendar.DATE, days );
        def todate = cal.getTime();
        return buildMonthEntries(startdate, todate );
    }

}