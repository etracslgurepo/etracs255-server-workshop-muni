package treasury.utils;

import com.rameses.util;

class InstallmentFeeBuilder {

	public static List buildInstallmentFee( int startyear,  int startmonth, int months, double amount, double startamt, double lastamt, String txntype ) {
        def list = [];
        int dt = (startyear * 12)+startmonth;
        (1..months).each { m->
            int yr = (int)(dt/12);
            int mon = (dt % 12);
            double _amt = amount;
            if( m == 1 && startamt > 0 ) _amt = startamt;
            else if( m == months && lastamt > 0 ) _amt = lastamt; 
            list << new InstallmentFee( year:yr, month: mon, amount: NumberUtil.round(_amt), txntype: txntype );
            dt = dt + 1;
        }
        return list;
    }


	public static List buildInstallmentFee( def startdate,  int months, double amount, double amtpaid, String txntype ) {
	     def cal = Calendar.instance;
        cal.setTime(startdate);
        int yr = cal.get(Calendar.YEAR);
        int mon = cal.get(Calendar.MONTH)+1;

        //get the amortization
        double amort = (((int)(amount * 1000)) / months) / 1000;
        
    
        //determine the start month
        int monthsPaid = (int)(amtpaid / amort);
        int _startDate = ((yr*12)+mon) + monthsPaid;

        int startYear = (int)(_startDate / 12);
        int startMonth = (_startDate % 12);
        
        //determine partial amount unpaid
        double startAmt = 0;
        double partialPaid = ((int)(amtpaid * 1000)) % ((int)(amort * 1000)) / 1000;
        if(partialPaid > 0 ) {
            startAmt  = amort - partialPaid;
        } 

        int monthsRemaining = months - monthsPaid;
        double lastAmt = amount - NumberUtil.round( NumberUtil.round(amort) * (months-1));
        return buildInstallmentFee( startYear, startMonth, monthsRemaining, NumberUtil.round(amort), NumberUtil.round(startAmt), NumberUtil.round(lastAmt), txntype );
	}

    
}