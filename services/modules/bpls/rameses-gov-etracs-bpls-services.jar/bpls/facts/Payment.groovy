package bpls.facts;

import java.math.BigDecimal;
import java.text.DecimalFormat;

public class Payment {
    
    String option = "FULLYEAR";       
    int qtr;    
    double amtpaid;
    private double balance;
    
    /** Creates a new instance of Payment */
    public Payment(def m) {
        option = m.option;
        if(m.qtr) {
            qtr = m.qtr;  
        }    
        if(m.amount) {
            //amtpaid = m.amount;
            balance = m.amount;
        }  
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        DecimalFormat format = new DecimalFormat("0.00");
        String s = format.format(balance); 
        this.balance = (new BigDecimal(s)).doubleValue();
    }
    
    void printInfo() {
        println "option:"+option;
        println "qtr:"+qtr;
        println "balance:"+balance;
    }

}
