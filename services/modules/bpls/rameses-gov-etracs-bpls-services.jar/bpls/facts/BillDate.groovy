package bpls.facts;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class BillDate {
    
    private Date date;
    private int qtr;
    private int month;
    private int year;
    int day;
    Date monthEnd = null;
    Date validUntil;

    private int numericDate;
    
    public BillDate(Date d) {
        this.date = d;
        //we need to remove the time component
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String s = df.format( this.date );
            this.date = df.parse( s );
            this.numericDate = Integer.parseInt( s.replace('-','' ));
        }
        catch(Throwable ign){;}
        


        Calendar cal = Calendar.getInstance();
	    cal.setTime( d );
        this.month = cal.get( Calendar.MONTH ) + 1;
    	this.day = cal.get( Calendar.DATE );
    	this.year = cal.get( Calendar.YEAR );
    	if( month >= 1 && month <= 3 ) this.qtr = 1;
        else if( month >= 4 && month <= 6 ) this.qtr = 2;
        else if( month >= 7 && month <= 9 ) this.qtr = 3;
        else this.qtr = 4;
        int ds = cal.getActualMaximum( Calendar.DAY_OF_MONTH );
        cal.set( Calendar.DAY_OF_MONTH, ds );
        monthEnd = cal.getTime();
        
        validUntil = monthEnd;
    }
    
    public Date getDate() {
        return date;
    }
    
    public int getQtr() {
        return qtr;
    }
    
    public int getMonth() {
        return month;
    }
    
    public int getYear() {
        return year;
    }
    
    public int getNumericDate() {
        return this.numericDate;
    }    
}
