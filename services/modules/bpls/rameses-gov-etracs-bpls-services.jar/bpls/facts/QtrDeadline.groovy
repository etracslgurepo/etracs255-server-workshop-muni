package bpls.facts;


import java.util.Calendar;
import java.util.Date;

public class QtrDeadline {
    
    Date _deadline;
    int qtr;
    int month;
    int year;
    int day;
    
    /** Creates a new instance of QtrDeadline */
    public QtrDeadline() {
    }
    
    public QtrDeadline( def d ) {

    }

    public QtrDeadline(int yr, int qtr, int day ) {
        this.year = yr;
        this.qtr = qtr;
        this.month = getQtrMonth(qtr);
        this.day = day;
    }
    
    private static int getQtrMonth( int qtr ) {
        switch(qtr) {
            case 1: 
                return Calendar.JANUARY;
            case 2: 
                return Calendar.APRIL; 
            case 3: 
                return Calendar.JULY; 
            default: 
                return Calendar.OCTOBER;
        }
    }
    
    public QtrDeadline(int yr, int qtr ) {
        this.year = yr;
        this.qtr = qtr;
        this.month = getQtrMonth(qtr);
    }

    
    public Date getBeginQtrDate() {
        return startQtrDate( year, qtr );
    }
    
    private static Date startQtrDate( int year, int qtr ) {
        Calendar cal = Calendar.getInstance();
        int month = 0;
        switch(qtr) {
            case 1: month = Calendar.JANUARY; break;
            case 2: month = Calendar.APRIL; break;
            case 3: month = Calendar.JULY; break;
            default: month = Calendar.OCTOBER;
        }
        cal.set( year, month, 1,  0, 0  );
        return cal.getTime();
    }
    
    public void setDeadline(def d) {
        def cal = Calendar.getInstance();
        cal.setTime( d );
        _deadline = cal.getTime();        
    }

    public Date getDeadline() {
        return _deadline;        
    }
    
}
