package bpls.facts;

import java.util.Date;
import com.rameses.util.*;

public class BillItem {
    
    BPApplication application;
    String objid;
    String acctid;
    BPLedger ledger;
    String type;
    LOB lob;
    String name;
    double amount;
    double  amtpaid;
    double amtdue;
    boolean expired;
    Date deadline;
    double surcharge;
    double interest;
    double discount;
    double total;
    Object account;
    int year;
    int qtr;
    int paypriority;
    int sortorder;
    double balance;
    String receivableid;
    Object surchargeaccount;
    Object interestaccount;
    boolean deleted;
    double fullamtdue;
    String assessmenttype;

    
    /** Creates a new instance of BillItem */
    public BillItem() {
    }
    
    public BillItem(def map) {
        if(map.amtpaid==null) map.amtpaid = 0;
        this.acctid = map.account.objid;
        
        this.amount = map.amount;
        this.amtpaid = map.amtpaid;
        this.amtdue = this.amount - this.amtpaid;
        this.fullamtdue = this.amtdue;
        this.total = this.amtdue;
        this.account = map.account;
        this.receivableid = map.objid;
        this.qtr = 0;
        if(map.year) this.year = map.year;
        if(map.iyear) this.year = map.iyear;
        this.type = map.taxfeetype;
        this.assessmenttype = map.assessmenttype;
        if(this.type == "TAX") {
            this.paypriority = 30 + this.qtr;
            this.sortorder = 1;
        }
        else if(this.type == "REGFEE") {
            this.paypriority = 20 + this.qtr;
            this.sortorder = 2;
        }
        else {
            this.paypriority = 10+this.qtr;
            this.sortorder = 3;
        }   
    }

    public Date getFirstdateofyear() {
        Calendar cal = Calendar.getInstance();
        cal.set( this.year, Calendar.JANUARY, 1, 0, 0);
        return cal.getTime();
    }

    public def toItem() {
        def item = [:];    
        item.year = this.year;
        item.qtr = this.qtr;
        if( this.lob ) {
            item.lob = [objid: this.lob.objid, name:this.lob.name, assessmenttype: this.lob.assessmenttype ]; 
        }
        item.account = this.account;
        item.taxfeetype = this.type;
        item.amtdue = this.amtdue;
        item.surcharge = this.surcharge;
        item.interest = this.interest;
        item.discount = this.discount;
        item.total = this.total;
        item.paypriority = (this.qtr*10) + (this.paypriority);

        def _qtr = this.qtr;
        if(_qtr == 0) _qtr = 5;
        item.sortorder = (_qtr*10)+(this.sortorder);
        item.duedate = this.deadline;
        item.balance = this.balance;
        item.receivableid = this.receivableid;
        //this is the full amtpaid.
        item.amount = this.amount;
        item.amtpaid = this.amtpaid;
        item.interestaccount = this.interestaccount;
        item.surchargeaccount = this.surchargeaccount;
        item.assessmenttype = this.assessmenttype;

        return item;
    }

    public void removeSurcharge() {
        this.surcharge = 0.0; 
        this.surchargeaccount = null; 
        updateTotal(); 
    }

    public void updateTotal() {
        this.total = (this.amtdue + this.surcharge + this.interest) - this.discount; 
    }

    public void printInfo() {
        println "-------------------------"
        println "amtpaid " + this.amtpaid;
        println "acctid " + this.acctid;
        println "amount " + this.amount;
        println "LOB " + this.lob;
        println "amtpaid " + this.amtpaid;
        println "amtdue " + this.amtdue;
        println "total " + this.total;
        println "account " + this.account;
        //x.objid is the receivable id.
        println "receivableid " +  this.receivableid;
        println "qtr " +  this.qtr;
        println "year " +  this.year;
        println "type " + this.type;
        println "paypriority " + this.paypriority;
        println "assessmenttype " + this.assessmenttype;

    }


}
