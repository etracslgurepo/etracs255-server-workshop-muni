package treasury.facts;

import java.util.*;
import com.rameses.util.*;
import com.rameses.functions.*;

class BillItem extends AbstractBillItem {

	//initiated because of late renewal from Vehicle, Business etc.
	String parentid;

	String refid; 
	String reftype;

	Date duedate;

	//amount that is left unpaid from the full amount
	double partialunpaid;

	//we will include the year in this case because we will need the year for 
	int year;
	int month;
	int qtr;

	LinkedHashSet<BillSubItem> items = new LinkedHashSet<BillSubItem>();

	//used for hascoding dates
	def dtHashcode = new java.text.SimpleDateFormat("yyyyMMdd");

	public BillItem() {}

	public BillItem( def o ) {
		super(o);
		if(o.parentid ) parentid = o.parentid;
		if(o.refid) refid = o.refid; 
		if(o.reftype) reftype = o.reftype;
		if(o.duedate) duedate = o.duedate;
		if(o.partialunpaid) partialunpaid = o.partialunpaid;
		if(o.year) year = o.year;
		if(o.month) month = o.month;
		if(o.qtr) qtr = o.qtr;
	}

	public def getTotals( def txntype ) {
		return items.findAll{ it.txntype == txntype }.sum{it.amount};
	}

	public double getTotal() {
		if(items.size()>0) {
			return  NumberUtil.round( amount + items.sum{ it.amount } );		
		}
		else {
			return NumberUtil.round( amount );
		}
	};

	public String toString() {
		def buff = new StringBuffer();
		buff.append( super.toString() );
		if( year > 0 ) buff.append("y:"+year+";");
		if( month > 0 ) buff.append( "m:"+month+";");
		if( qtr > 0 ) buff.append("q:"+qtr+";");
		if( account?.objid ) buff.append( "acct:"+account.objid+";");
		if( txntype ) buff.append( "type:"+txntype+";");
		if( refid ) buff.append( "refid:"+refid+";");
		return buff.toString();
	}

	public int hashCode() {
		return toString().hashCode();
	}

	public def toMap() {
		def m = super.toMap();
		m.refid = refid;
		m.reftype = reftype;
		m.parentid = parentid;
		items.each {
			if(it.amount == null) it.amount = 0;
			m.put(it.txntype?.toLowerCase(), NumberUtil.round(it.amount));
		};
		if(duedate ) m.duedate = duedate;		
		m.total = total;
		m.partialunpaid = partialunpaid;
		if( m.surcharge == null ) m.surcharge = 0;
		if( m.interest == null ) m.interest = 0;
		if( m.discount == null) m.discount = 0;
		if(year>0) m.year = year;
		if(month>0) m.month = month;
		if( qtr>0) m.qtr = qtr;
		
		return m;
	}

	//call this after apply payment
	void recalc() {;}

	//call this to distribute payment and return the remainder
	double applyPayment( double payamt ) {
		//store original amount in principal so we can recover it later
		//principal = amount;

		double linetotal = NumberUtil.round(total);
		if( payamt >= linetotal ) {
			return NumberUtil.round( payamt - linetotal );
		}

		//in case for partial payments, distribute evenly first to its subitems. The remainder add to the amount of this bill
		double _amt = payamt;
		/*
		println "*****************************************************"
		println "line total is " + linetotal + " while payamt is " + payamt;
		println "% amount of main " + NumberUtil.round( amount / linetotal );
		println "original amount is " + amount;
		println "value of amount ->" + NumberUtil.round( NumberUtil.round( amount / linetotal ) * payamt);
		println "----------------------------------------------------------------"
		*/
		for(BillSubItem bi: items) { 
			def xxx = ( bi.amount / linetotal ) * payamt; 
			def result = NumberUtil.round( xxx );
			bi.amount = result;
			_amt -= bi.amount;
		}
		//println "remainder amount " + NumberUtil.round(_amt);
		//amount =  NumberUtil.round( NumberUtil.round( amount / linetotal ) * payamt ) ;
		//println "% amouint calculated " + NumberUtil.round(amount);
		//_amt -= amount;
		
		partialunpaid = amount - _amt;
		amount = _amt;
		//println "------- end -----------";

		//we must return 0 to indicate that all payment is consumed.
		return 0;
	}

	//pay priority is only used during apply payment and will not be used anywhere else. This is defined by the extending class.
	int _paypriority = 0;
	def payDf = new java.text.SimpleDateFormat("yyyyMM");

	public void setPaypriority( int p ) {
		this._paypriority = p;
	}

	public int getPaypriority() {
		if( _paypriority > 0 ) return _paypriority;
		if( duedate !=null ) {
			return (payDf.format(duedate) + _paypriority.toString().substring(0,4).padLeft(4, "0")).toInteger();
		}
		else {
			return _paypriority;	
		}
	}

	//**********************************************************************************************************************************
	// extended properties for the billitem assuming there is year and month
	//**********************************************************************************************************************************
	public int getYearMonth() {
		return (year*12)+month;
	}

	public int getSortorder() {
		if( super.getSortorder() > 0 ) return super.getSortorder();
		return (yearMonth*1000); //+ super.getSortorder();
	} 
}