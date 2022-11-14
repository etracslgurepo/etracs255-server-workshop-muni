package treasury.facts;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import com.rameses.rules.common.*;

public class DueDate extends DateFact {
    
	String tag;

    public DueDate() {
        super();
    }

    public DueDate(String s) {
        super(s);
    }

    public DueDate(Date d) {
        super(d);
    }
    
}
