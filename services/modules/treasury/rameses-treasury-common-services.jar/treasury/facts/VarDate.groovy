package treasury.facts;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import com.rameses.rules.common.*;

public class VarDate extends DateFact {
    
	String tag;

    public VarDate() {
        super();
    }

    public VarDate(String s) {
        super(s);
    }

    public VarDate(Date d) {
        super(d);
    }
    
}
