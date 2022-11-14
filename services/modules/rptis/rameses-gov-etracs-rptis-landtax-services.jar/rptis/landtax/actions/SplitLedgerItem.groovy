package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class SplitLedgerItem implements RuleActionHandler {
	def numSvc 
	def request

	public void execute(def params, def drools) {
		def item = params.rptledgeritem
		def amtpaid = item.amtpaid 
		def fullint = item.interest 
		def fulldisc = item.discount

		if (item.amtdue == null || item.amtdue == 0){
			return;
		}

		def intrate = numSvc.round(item.interest / item.amtdue)
		def discrate = numSvc.round(item.discount / item.amtdue)

		drools.retract(item)
		request.facts.remove(item)
		request.items.remove(item.entity)

		def qtrlyvalues = buildQtrlyAmoutDues(item)
		def qtrlyfacts = []
		for( int qtr=1; qtr<=4; qtr++){
			def qifact = createLedgerItemFact(request, item, qtr, qtrlyvalues[qtr])
			if (amtpaid >= qifact.amtdue){
				amtpaid -= qifact.amtdue 
			}
			else {
				if (amtpaid > 0 ){
					qifact.amtdue -= amtpaid
					amtpaid = 0
				}
				qifact.interest = numSvc.round(qifact.amtdue * intrate)
				qifact.discount = numSvc.round(qifact.amtdue * discrate)
				qtrlyfacts << qifact 
			}
		}

		// adjust last item totals 
		if (qtrlyfacts.size() == 1){
			qtrlyfacts[0].interest = fullint
			qtrlyfacts[0].discount = fulldisc
		}
		else {
			def lastitem = qtrlyfacts.last() 
			def previtems = qtrlyfacts[0..qtrlyfacts.size() - 2]
			lastitem.interest = fullint - previtems.interest.sum()
			lastitem.discount = fulldisc - previtems.discount.sum()
		}

		qtrlyfacts.each{
			request.items << it.entity
			request.facts << it
			drools.insert(it)	
		}
	}

	def buildQtrlyAmoutDues(item){
		def amtdue13 = numSvc.round(item.amount / 4)
		def amtdue4 = numSvc.round(item.amount - (amtdue13 * 3))
		
		def qv = []
		qv[0] = [amtdue:amtdue13]
		qv[1] = [amtdue:amtdue13]
		qv[2] = [amtdue:amtdue13]
		qv[3] = [amtdue:amtdue13]
		qv[4] = [amtdue:amtdue4]
		return qv 
	}

	def createLedgerItemFact(request, item, qtr, qtrav){
		def qitem = [:]
		qitem.putAll(item.entity)
		qitem.qtr = qtr 

		def qifact = new RPTLedgerItemFact(item.ledger, qitem)
		qifact.amtdue = qtrav.amtdue
		qifact.interest = qtrav.interest
		qifact.discount = qtrav.discount
		qifact.qtrly = true 
		return qifact 
	}
}