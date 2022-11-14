package treasury.facts;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import com.rameses.rules.common.*;

public class QtrDueDate extends DateFact {
    
	int qtr;

    public QtrDueDate() {
        super();
    }

    public QtrDueDate(String s) {
        super(s);
    }

    public QtrDueDate(Date d) {
        super(d);
    }
    
}
