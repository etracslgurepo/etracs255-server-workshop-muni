package enterprise.facts;
import com.rameses.rules.common.*;

public class DateInfo extends VariableInfo {

	def dateFact;

	public Date getValue() {
		return this.datevalue;
	}
	

    public void setValue( def d ) {
        this.dateFact = new DateFact( d );
        this.datevalue = getDate();
    }

	/*
    public void setValue( Date d ) {
		this.datevalue = d;
		this.dateFact = new DateFact( d );
	}
    */
	

    public Date getDate() {
        return dateFact.date;
    }

    public int getYear() {
        return dateFact.year;
    }

    public int getQtr() {
        return dateFact.qtr;
    }

    public int getMonth() {
        return dateFact.month;
    }

    public int getHour() {
        return dateFact.hour;
    }

    public int getMinute() {
        return dateFact.minute;
    }

    public int getSecond() {
        return dateFact.second;
    }

    public int getDay() {
        return dateFact.day;
    }

    public int getDayOfWeek() {
        return dateFact.dayOfWeek;
    }

    public Date getMonthEnd() {
        return dateFact.monthEnd;
    }
    
    public Date getMonthBegin() {
        return dateFact.monthBegin;
    }

    public Date getTimeStamp() {
        return dateFact.timeStamp;
    }

    public int getMilliSecond() {
        return dateFact.milliSecond;
    }
    
}


