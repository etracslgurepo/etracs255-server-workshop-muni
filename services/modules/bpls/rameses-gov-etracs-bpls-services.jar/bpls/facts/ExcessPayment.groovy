package bpls.facts;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class ExcessPayment {
    
    def amount;
    def account;

    public ExcessPayment(def a) {
        this.amount = a;
    }

    public def toItem() {
    	return [account:account];
    }
}
