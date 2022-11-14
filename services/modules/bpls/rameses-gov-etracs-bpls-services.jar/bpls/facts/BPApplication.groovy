package bpls.facts;

import java.text.SimpleDateFormat;
import java.util.*;
import com.rameses.util.*;

public class BPApplication {
    
    String objid;
    String orgtype;
    String apptype;
    String txnmode;
    int appyear;
    String appno;
    String purpose;
    int yearstarted;
    Date dateapplied;
    String officetype;
    String permittype;
    
    int appqtr;
    int appmonth;
    int appdate;

    int lastqtrpaid;

    //for removal...
    //String officetype;
    //String barangayid;

    /** Creates a new instance of BPApplication */
    public BPApplication() {
    }

    public BPApplication(int yr) {
        this.appyear = appyear;
    }
     
    public BPApplication( def app ) {
        //correct dtfiled as date applied
        if(app.dtfiled) app.dateapplied = app.dtfiled;

        objid = app.objid;
        appno = app.appno;
        if(!app.appyear) 
            throw new Exception("BPApplication Fact error. Please provide an app.appyear");
        appyear = app.appyear;
        if(app.yearstarted) {
            this.yearstarted = app.yearstarted;
        }   
        if(app.dateapplied) {
            if(!(app.dateapplied instanceof Date)) {
                try {
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                    this.dateapplied = df.parse( app.dateapplied );
                }
                catch(Exception ign){
                    println "ERROR !" + ign.message;
                }
            }    
            else {
                this.dateapplied = app.dateapplied;
            }
        }
        else {
            this.dateapplied = new Date();
        }

        def db = new DateBean( this.dateapplied );
        this.appqtr = db.qtr;
        this.appmonth = db.month;
        this.appqtr = db.qtr;
        this.appdate = db.day;     
           
        apptype = app.apptype;
        txnmode = app.txnmode;
        orgtype = app.business?.orgtype;
        permittype = app.business?.permittype;
        officetype = app.business?.officetype;

        if(app.lastqtrpaid==null) app.lastqtrpaid = 0;
        lastqtrpaid = app.lastqtrpaid;
    }

    
}
